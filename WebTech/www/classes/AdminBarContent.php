<?php
	require_once('LoginForm.php');
	require_once('Authorization.php');

	class AdminBarContent extends Template
	{		
		public function __construct()
		{
			parent::__construct('general_content_block');
		}
		
		protected function handleKeywords()
		{
			$this->replaceKeywordByText('CONTENT', '<h1>ADMIN BAR</h1>');
		}
	}

?>