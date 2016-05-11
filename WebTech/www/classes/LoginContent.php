<?php
	require_once('LoginForm.php');
	require_once('Authorization.php');

	class LoginContent extends Template
	{		
		protected $loginForm;
	
		public function __construct()
		{
			parent::__construct('general_content_block');
			
			$auth = Authorization::getInstance();
			$hasCredentials = isset($_POST['loginUsernameInput'], $_POST['loginPasswordInput']);
			
			$logInResult = false;
			if ($hasCredentials)
			{
				$username = $_POST['loginUsernameInput'];
				$password = $_POST['loginPasswordInput'];
				
				$logInResult = $auth->tryLogIn($username, $password);
			}
			
			$showLogInErrors = ($hasCredentials and !$logInResult);
			if ($logInResult === false)
			{
				$this->loginForm = new LoginForm($showLogInErrors);
			}
			else
			{
				// Show login success window
				Utils::redirectToIndex();
			}
		}
		
		protected function handleKeywords()
		{
			$this->replaceKeywordByText('CONTENT', $this->loginForm->getText());
		}
	}
?>