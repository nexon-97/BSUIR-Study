<?php
	require_once('Database.php');
	require_once('BlogPostPreview.php');

	class BlogCategoryQuickView extends Template
	{
		public $categoryId;
		public $categoryTitle;
		public $articleHeaders;
		
		public function __construct($categoryId, $categoryTitle)
		{
			parent::__construct('blog_category_quick_view');
			
			$this->categoryId = $categoryId;
			$this->categoryTitle = $categoryTitle;
			
			$this->LoadArticleHeaders(5);
		}
		
		private function LoadArticleHeaders($maxArticles = 5)
		{
			$databaseConnection = new Database('nexonlab');
			$articles = $databaseConnection->SelectConditionalLimited
			(
				'blog_entries',
				'title, creation_date, description, image, author',
				'category = ' . $this->categoryId,
				$maxArticles
			);
			
			$this->articleHeaders = array();
			foreach ($articles as $item)
			{
				$authorNick = $databaseConnection->SelectConditional('user_profiles', 'nickname', 'id = ' . $item['author']);
				$this->articleHeaders[] = new BlogPostPreview(
					$item['title'], $item['creation_date'], $item['description'], $item['image'], $authorNick[0]['nickname']);
			}
		}
		
		private function GetArticlesPreviewText()
		{
			$articlesArray = array();
			foreach ($this->articleHeaders as $preview)
			{
				$articlesArray[] = $preview->GetText();
			}
			
			return Template::GetStringsInRow($articlesArray);
		}
		
		protected function HandleKeywords()
		{
			$this->ReplaceKeywordByText('CATEGORY_TITLE', $this->categoryTitle);
			$this->ReplaceKeywordByText('POSTS', $this->GetArticlesPreviewText());
		}
	}

?>