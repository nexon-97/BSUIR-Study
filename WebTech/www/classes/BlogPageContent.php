<?php
	require_once('BlogCategoryQuickView.php');
	require_once('Authorization.php');

	class BlogPageContent extends Template
	{
		private $categoriesQuickViews;
		private $addPostButton;
		
		public function __construct()
		{
			parent::__construct('blogContent');
			
			$this->loadCategoriesQuickViews();
			
			$auth = Authorization::getInstance();
			if ($auth->getRights() >= Authorization::LOGGED_USER_RIGHTS)
			{
				$this->addPostButton = new SimpleButton('Add post', 'add.php?entity=post', true);
			}
		}
		
		private function loadCategoriesQuickViews()
		{
			$this->categoriesQuickViews = array();
			
			$databaseConnection = new Database('u864060956_db');
			$result = $databaseConnection->Query('SELECT id, name FROM `blogcategories`');
			if ($result->num_rows > 0) {
				while($row = $result->fetch_assoc()) {
					$this->categoriesQuickViews[] = new BlogCategoryQuickView($row['id'], $row['name']);
				}
			}
		}
		
		private function getCategoriesQuickViewText()
		{
			$categoriesArray = array();
			foreach ($this->categoriesQuickViews as $category)
			{
				$categoriesArray[] = $category->getText();
			}
			
			return Template::getStringsInRow($categoriesArray);
		}
		
		private function getAllBlogPostsListing()
		{
			$postsListing = array();
			
			$databaseConnection = new Database('u864060956_db');
			$entriesList = $databaseConnection->Select('blog_entries', 'id, title');

			foreach ($entriesList as $item)
			{
				$postsListing[] = '<h3><a href="post.php?id='.$item['id'].'">'.$item['title'].'</a></h3>';
			}
			
			return Template::getStringsInRow($postsListing);
		}
		
		private function getAddPostButtonText()
		{
			return (isset($this->addPostButton)) ? $this->addPostButton->getText() : '';
		}
		
		protected function handleKeywords()
		{
			$this->replaceKeywordByText('CATEGORIES', $this->getCategoriesQuickViewText());
			$this->replaceKeywordByText('POSTS_LIST', $this->getAllBlogPostsListing());
			$this->replaceKeywordByText('ADD_POST_BUTTON', $this->getAddPostButtonText());
		}
	}
?>