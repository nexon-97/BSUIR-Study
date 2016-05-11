<?php
	require_once('Template.php');

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
			$postId, $title, $shortDesc, $date, $imagePath = 'img/noimage.jpg', $author = '', $href = '#', $authorLink = '#')
		{
			parent::__construct('blog_post_preview');
			
			$this->postTitle = $title;
			$this->postShortDescription = $shortDesc;
			
			$this->displayStyle = 0;
			$this->imagePath = $imagePath;
			$this->postDate = $date;
			$this->postAuthor = $author;
			$this->postHRef = $href;
			$this->authorLink = $authorLink;
		}
		
		protected function handleKeywords()
		{
			$this->replaceKeywordByText('IMAGE_PATH', $this->imagePath);
			$this->replaceKeywordByText('TITLE', $this->postTitle);
			$this->replaceKeywordByText('DATE', $this->postDate);
			$this->replaceKeywordByText('AUTHOR', $this->postAuthor);
			$this->replaceKeywordByText('SHORT_DESCRIPTION', $this->postShortDescription);
			$this->replaceKeywordByText('POST_HREF', $this->postHRef);
			$this->replaceKeywordByText('AUTHOR_LINK', $this->authorLink);
		}
	}

?>