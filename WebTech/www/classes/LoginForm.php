<?php
	require_once('Template.php');

	class LoginForm extends Template
	{
		private $errorText;
		private $showError;
		
		public function __construct($hasErrors)
		{
			parent::__construct('loginPage');
			
			$this->errorText = $hasErrors ? 'No such username & password combination found!' : '';
			$this->showError = strlen($this->errorText) > 0;
		}
		
		protected function handleKeywords()
		{
			$this->replaceKeywordByText('LOGIN_ERROR_TEXT', $this->errorText);
			$this->replaceKeywordByText('ERROR_DISPLAY', $this->showError ? 'block' : 'none');
		}
	}
?>