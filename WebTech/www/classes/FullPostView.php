<?php
	require_once('PostNotFoundErrorMessage.php');

	class FullPostView extends Template
	{
		private $category;
		private $title;
		private $text;
		private $creationDate;	
		private $authorId;
		private $author;
		
		private $postStats;
		
		public function __construct($category, $postId, $creationDate, $authorId, $author, $authorLink = '#')
		{
			parent::__construct('full_post_view');
			
			$this->category = $category;
			$this->title = $this->loadContentFile(SiteInfo::getPostTitlePath($postId), '[TITLE]');
			$this->text = $this->loadContentFile(SiteInfo::getPostFullTextPath($postId), '[TEXT]');
			$this->creationDate = $creationDate;
			$this->authorId = $authorId;
			$this->author = $author;
			
			$this->postStats = $creationDate . ' by ' . $author;
		}
		
		protected function handleKeywords()
		{
			$this->replaceKeywordByText('POST_CATEGORY', $this->category);
			$this->replaceKeywordByText('CREATION_DATE', $this->creationDate);
			$this->replaceKeywordByText('AUTHOR_NAME', $this->author);
			$this->replaceKeywordByText('AUTHOR_LINK', SiteInfo::getAuthorLink($this->authorId));
			$this->replaceKeywordByText('POST_TEXT', $this->text);
			$this->replaceKeywordByText('POST_COMMENTS', '<h3>Comments (NOT IMPLEMENTED YET)</h3>');
			$this->replaceKeywordByText('POST_TITLE', $this->title);
			$this->replaceKeywordByText('CATEGORY_LINK', SiteInfo::getCategoryLinkByTitle($this->category));
		}
	}

?>