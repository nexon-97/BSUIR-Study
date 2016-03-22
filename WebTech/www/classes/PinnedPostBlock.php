<?php

	require_once('Template.php');

	class PinnedPostBlock extends Template
	{
		
		protected $pinnedPost;
		
		public function __construct()
		{
			parent::__construct('pinnedPostLayout');
		}
		
		protected function handleKeywords()
		{
			$this->replaceKeywordByText('TITLE', 'Post title');
			$this->replaceKeywordByText('DESCRIPTION', 'Pinned post full description, which can be even multilined');
			$this->replaceKeywordByText('IMAGE', 'img/pinned_post_img.jpg');
		}
		
	}

?>