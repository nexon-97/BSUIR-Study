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
				'id, creation_date, image, author, title, short_desc',
				'category = ' . $this->categoryId,
				$maxArticles
			);
			
			$this->articleHeaders = array();
			foreach ($articles as $item)
			{
				$authorDesc = $databaseConnection->SelectConditional('user_profiles', 'id, nickname', 'id = ' . $item['author']);
				$authorDesc = $authorDesc[0];
				$this->articleHeaders[] = new BlogPostPreview(
					$item['id'], $item['title'], $item['short_desc'], $item['creation_date'],
					$item['image'], $authorDesc['nickname'],
					'post.php?id=' . $item['id'], 'user.php?id=' . $authorDesc['id']);
			}
		}
		
		private function getArticlesPreviewText()
		{
			$articlesArray = array();
			foreach ($this->articleHeaders as $preview)
			{
				$articlesArray[] = $preview->getText();
			}
			
			return Template::getStringsInRow($articlesArray);
		}
		
		protected function handleKeywords()
		{
			$this->replaceKeywordByText('CATEGORY_TITLE', $this->categoryTitle);
			$this->replaceKeywordByText('POSTS', $this->getArticlesPreviewText());
		}
	}
?>