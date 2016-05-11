<?php
	require_once('LoginForm.php');
	require_once('Authorization.php');

	class LoginContent extends Template
	{		
		protected $loginForm;
	
		public function __construct()
		{
			parent::__construct('general_content_block');
			
			$this->loginForm = new LoginForm();
		}
		
		protected function handleKeywords()
		{
			$this->replaceKeywordByText('CONTENT', $this->loginForm->getText());
		}
	}

?>