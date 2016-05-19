<?php
	require_once('Comment.php');
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
			
			$this->loadComments($postId);
		}
		
		public function loadComments($postId)
		{
			$this->comments = array();
			
			$databaseConnection = new Database('nexonlab');
			$comments = $databaseConnection->SelectConditionalOrder('comments', 'id, text, author_id, date', 'post_id = ' . $postId, 'date');

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
			$this->replaceKeywordByText('POST_ID', $this->postId);
		}
	}
?>