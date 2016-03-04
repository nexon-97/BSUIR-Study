<?php

	require_once('Template.php');

	class PinnedPostBlock extends Template
	{
		
		protected $pinnedPost;
		
		public function __construct()
		{
			parent::__construct('pinnedPostLayout');
		}
		
		protected function HandleKeywords()
		{
			$this->ReplaceKeywordByText('TITLE', 'Post title');
			$this->ReplaceKeywordByText('DESCRIPTION', 'Pinned post full description, which can be even multilined');
			$this->ReplaceKeywordByText('IMAGE', 'img/pinned_post_img.jpg');
		}
		
	}

?>