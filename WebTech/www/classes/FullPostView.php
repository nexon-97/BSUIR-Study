<?php
	require_once('Comment.php');
	require_once('CommentForm.php');
	require_once('Authorization.php');

	class FullPostView extends Template
	{
		private $category;
		private $title;
		private $text;
		private $creationDate;	
		private $authorId;
		private $author;
		
		private $postStats;
		private $postId;
		private $comments;
		
		private $commentForm;
		private $deleteButton;
		private $editButton;
		
		public function __construct($category, $postId, $title, $postText, $creationDate, $authorId, $author, $authorLink = '#')
		{
			parent::__construct('full_post_view');
			
			$this->category = $category;
			$this->title = $title;
			$this->text = $postText;
			$this->creationDate = $creationDate;
			$this->authorId = $authorId;
			$this->author = $author;
			$this->postId = $postId;
			
			$this->postStats = $creationDate . ' by ' . $author;
			
			$this->loadComments();
			
			$auth = Authorization::getInstance();
			if ($auth->getUserId() === $this->authorId or $auth->getRights() >= Authorization::MODERATOR_RIGHTS)
			{
				$this->deleteButton = new SimpleButton('Delete', 'delete.php?entity=post&id='.$this->postId.'&referer=blog.php');
				$this->editButton = new SimpleButton('Edit', 'edit.php?entity=post&id='.$this->postId.'&referer=blog.php');
			}
		}
		
		public function loadComments()
		{
			$this->comments = array();
			
			$databaseConnection = new Database('u864060956_db');
			$comments = $databaseConnection->SelectConditionalOrder('comments', 'id, text, author_id, date', 'post_id = ' . $this->postId, 'date');

			$auth = Authorization::getInstance();
			
			foreach ($comments as $comment)
			{
				$userInfo = $databaseConnection->SelectConditional('user_profiles', 'id, nickname, avatar', 'id = ' . $comment['author_id']);
				$userInfo = $userInfo[0];
				
				$canDeleteComment = (($auth->getRights() >= Authorization::MODERATOR_RIGHTS) or ($auth->getUserId() === $comment['author_id']));
				$referer = 'post.php?id='.$this->postId;
				$this->comments[] = new Comment(
					$userInfo['nickname'], $userInfo['id'],
					$comment['text'], $comment['date'], $userInfo['avatar'], $comment['id'], $canDeleteComment, $referer);
			}
			
			if ($auth->getRights() >= Authorization::LOGGED_USER_RIGHTS)
			{
				$this->commentForm = new CommentForm($this->postId);
			}
		}
		
		private function getCommentsText()
		{
			$commentsArray = array();
			foreach ($this->comments as $comment)
			{
				$commentsArray[] = $comment->getText();
			}
			
			return Template::getStringsInRow($commentsArray);
		}
		
		private function getDeleteButtonText()
		{
			return (isset($this->deleteButton)) ? $this->deleteButton->getText() : '';
		}
		
		private function getEditButtonText()
		{
			return (isset($this->editButton)) ? $this->editButton->getText() : '';
		}
		
		protected function handleKeywords()
		{
			$this->replaceKeywordByText('POST_CATEGORY', $this->category);
			$this->replaceKeywordByText('CREATION_DATE', $this->creationDate);
			$this->replaceKeywordByText('AUTHOR_NAME', $this->author);
			$this->replaceKeywordByText('AUTHOR_LINK', SiteInfo::getAuthorLink($this->authorId));
			$this->replaceKeywordByText('POST_TEXT', $this->text);
			$this->replaceKeywordByText('POST_TITLE', $this->title);
			$this->replaceKeywordByText('CATEGORY_LINK', SiteInfo::getCategoryLinkByTitle($this->category));
			
			$this->replaceKeywordByText('POST_COMMENTS', $this->getCommentsText());
			$this->replaceKeywordByText('COMMENT_FORM', (isset($this->commentForm) ? $this->commentForm->getText() : ''));
			$this->replaceKeywordByText('POST_ID', $this->postId);
			
			$this->replaceKeywordByText('DELETE_POST_BUTTON', $this->getDeleteButtonText());
			$this->replaceKeywordByText('EDIT_POST_BUTTON', $this->getEditButtonText());
		}
	}
?>