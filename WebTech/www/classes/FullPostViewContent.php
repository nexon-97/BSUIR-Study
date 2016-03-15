<?php
	require_once('Template.php');

	class FullPostViewContent extends Template
	{
		private $postText;
		private $postStats;
		private $postTitle;
		private $postCategory;
		
		public function __construct()
		{
			parent::__construct('full_post_view_content');
			
			if ($this->loadPostText())
			{
				
			}
		}
		
		private function loadPostText()
		{
			$success = false;
			$postId = isset($_GET['id']) ? $_GET['id'] : '0';
			if (ctype_digit($postId))
			{
				$databaseConnection = new Database('nexonlab');
				$postInfo = $databaseConnection->SelectConditional('blog_entries', 'category, title, full_text, creation_date, author', 'id = ' . $postId);
				if (count($postInfo) > 0)
				{
					$postInfo = $postInfo[0];
					
					$this->postTitle = $postInfo['title'];
					$this->postText = $postInfo['full_text'];
					$this->postStats = $postInfo['creation_date'] . ' by ' . $postInfo['author'];
					
					$categoryTitle = $databaseConnection->SelectConditional('blogcategories', 'name', 'id = ' . $postInfo['category']);					
					$this->postCategory = $categoryTitle[0]['name'] . ' > ' . $this->postTitle;

					$success = true;
				}
			}
			
			return $success;
		}
		
		protected function HandleKeywords()
		{
			$this->ReplaceKeywordByText('POST_HIERARCHY', $this->postCategory);
			$this->ReplaceKeywordByText('POST_STATS', $this->postStats);
			$this->ReplaceKeywordByText('POST_TEXT', $this->postText);
			$this->ReplaceKeywordByText('POST_COMMENTS', '<h3>Comments</h3>');
			$this->ReplaceKeywordByText('POST_TITLE', $this->postTitle);
		}
	}

?>