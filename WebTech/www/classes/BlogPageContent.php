<?php
	require_once('BlogCategoryQuickView.php');

	class BlogPageContent extends Template
	{
		private $categoriesQuickViews;
		
		public function __construct()
		{
			parent::__construct('blogContent');
			
			$this->LoadCategoriesQuickViews();
		}
		
		private function LoadCategoriesQuickViews()
		{
			$this->categoriesQuickViews = array();
			
			$databaseConnection = new Database('nexonlab');
			$result = $databaseConnection->Query('SELECT id, name FROM `blogcategories`');
			if ($result->num_rows > 0) {
				while($row = $result->fetch_assoc()) {
					$this->categoriesQuickViews[] = new BlogCategoryQuickView($row['id'], $row['name']);
				}
			}
		}
		
		private function GetCategoriesQuickViewText()
		{
			$categoriesArray = array();
			foreach ($this->categoriesQuickViews as $category)
			{
				$categoriesArray[] = $category->GetText();
			}
			
			return Template::GetStringsInRow($categoriesArray);
		}
		
		private function GetAllBlogPostsListing()
		{
			$postsListing = array();
			
			$databaseConnection = new Database('nexonlab');
			$result = $databaseConnection->Query('SELECT title FROM `blog_entries`');
			if ($result->num_rows > 0) {
				while($row = $result->fetch_assoc()) {
					$postsListing[] = '<h3>'.$row['title'].'</h3>';
				}
			}
			
			return Template::GetStringsInRow($postsListing);
		}
		
		protected function HandleKeywords()
		{
			$this->ReplaceKeywordByText('CATEGORIES', $this->GetCategoriesQuickViewText());
			$this->ReplaceKeywordByText('POSTS_LIST', $this->GetAllBlogPostsListing());
		}
		
	}

?>