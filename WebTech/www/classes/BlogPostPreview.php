<?php

	class BlogPostPreview extends Template
	{
		public $postTitle;
		public $postDate;
		public $postShortDescription;
		public $displayStyle;
		public $imagePath;
		public $postHRef;
		
		public function __construct(
			$title, $date, $shortDescription = '', $imagePath = 'img/noimage.jpg', $author = '', $href = '#')
		{
			parent::__construct('blog_post_preview');
			
			$this->postTitle = $title;
			$this->postShortDescription = $shortDescription;
			$this->displayStyle = 0;
			$this->imagePath = $imagePath;
			$this->postDate = $date;
			$this->postAuthor = $author;
			$this->postHRef = $href;
		}
		
		protected function HandleKeywords()
		{
			$this->ReplaceKeywordByText('IMAGE_PATH', $this->imagePath);
			$this->ReplaceKeywordByText('TITLE', $this->postTitle);
			$this->ReplaceKeywordByText('DATE', $this->postDate);
			$this->ReplaceKeywordByText('AUTHOR', $this->postAuthor);
			$this->ReplaceKeywordByText('SHORT_DESCRIPTION', $this->postShortDescription);
			$this->ReplaceKeywordByText('POST_HREF', $this->postHRef);
		}
	}

?>