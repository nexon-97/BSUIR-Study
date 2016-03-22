<?php
	require_once('FullPostView.php');
	require_once('PostNotFoundErrorMessage.php');

	class FullPostViewContent extends Template
	{
		private $postText;
		private $postStats;
		private $postTitle;
		
		private $contentBlock;
		
		public function __construct()
		{
			parent::__construct('general_content_block');
			
			if (!$this->loadPostText())
			{
				$this->contentBlock = new PostNotFoundErrorMessage();
			}
		}
		
		private function loadPostText()
		{
			$postId = isset($_GET['id']) ? $_GET['id'] : '0';
			if (ctype_digit($postId))
			{
				$databaseConnection = new Database('nexonlab');
				$postInfo = $databaseConnection->SelectConditional('blog_entries', 'id, category, creation_date, author', 'id = ' . $postId);
				if (count($postInfo) > 0)
				{
					$postInfo = $postInfo[0];
					
					$categoryTitle = $databaseConnection->SelectConditional('blogcategories', 'name', 'id = ' . $postInfo['category']);					
					$categoryTitle = $categoryTitle[0]['name'];
					
					$authorInfo = $databaseConnection->SelectConditional('user_profiles', 'id, nickname', 'id = ' . $postInfo['author']);					
					$authorInfo = $authorInfo[0];

					$this->contentBlock = new FullPostView($categoryTitle,
						$postInfo['id'], $postInfo['creation_date'], $authorInfo['id'], $authorInfo['nickname']);
					return true;
				}
			}
			
			return false;
		}
		
		protected function handleKeywords()
		{
			$this->replaceKeywordByText('CONTENT', $this->contentBlock->getText());
		}
	}

?>