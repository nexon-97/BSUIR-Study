<?php

	require_once('PinnedPostBlock.php');

	class IndexPageContent extends Template
	{
		
		protected $pinnedPost;
		
		public function __construct()
		{
			parent::__construct('indexContent');
			
			$this->LoadPinnedPost();
		}
		
		private function LoadPinnedPost()
		{
			$this->pinnedPost = new PinnedPostBlock();
		}
		
		protected function handleKeywords()
		{
			$this->replaceKeywordByText('PINNED_POST', $this->pinnedPost->getText());
			$this->replaceKeywordByText('LATEST_POSTS_FEED', '');
		}
		
	}

?>