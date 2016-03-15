<?php

	class BlogPostPreview extends Template
	{
		public $postTitle;
		public $postDate;
		public $postShortDescription;
		public $displayStyle;
		public $imagePath;
		public $postHRef;
		public $authorLink;
		
		public function __construct(
			$title, $date, $shortDescription = '', $imagePath = 'img/noimage.jpg', $author = '', $href = '#', $authorLink = '#')
		{
			parent::__construct('blog_post_preview');
			
			$this->postTitle = $title;
			$this->postShortDescription = $shortDescription;
			$this->displayStyle = 0;
			$this->imagePath = $imagePath;
			$this->postDate = $date;
			$this->postAuthor = $author;
			$this->postHRef = $href;
			$this->authorLink = $authorLink;
		}
		
		protected function HandleKeywords()
		{
			$this->ReplaceKeywordByText('IMAGE_PATH', $this->imagePath);
			$this->ReplaceKeywordByText('TITLE', $this->postTitle);
			$this->ReplaceKeywordByText('DATE', $this->postDate);
			$this->ReplaceKeywordByText('AUTHOR', $this->postAuthor);
			$this->ReplaceKeywordByText('SHORT_DESCRIPTION', $this->postShortDescription);
			$this->ReplaceKeywordByText('POST_HREF', $this->postHRef);
			$this->ReplaceKeywordByText('AUTHOR_LINK', $this->authorLink);
		}
	}

?>