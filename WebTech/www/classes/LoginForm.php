<?php
	require_once('Template.php');

	class LoginForm extends Template
	{
		public function __construct()
		{
			parent::__construct('loginPage');
		}
		
		protected function handleKeywords()
		{
			//$this->replaceKeywordByText('CONTENT', $this->contentBlock->getText());
		}
	}
?>