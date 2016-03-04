<?php

	class BlogPageContent extends Template
	{
		
		public function __construct()
		{
			parent::__construct('blogContent');
		}
		
		protected function HandleKeywords()
		{
			//$this->ReplaceKeywordByText('PINNED_POST', $this->pinnedPost->GetText());
			//$this->ReplaceKeywordByText('LATEST_POSTS_FEED', '');
		}
		
	}

?>