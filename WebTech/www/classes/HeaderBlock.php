<?php
	require_once('Authorization.php');
	require_once('SimpleButton.php');
	
	class HeaderBlock extends Template
	{
		private $username;
		private $userId;
		private $logInButton;
		private $logOutButton;
		private $registerButton;
		
		public function __construct()
		{
			parent::__construct('header');
			
			$auth = Authorization::getInstance();
			$this->username = $auth->getUsername();
			$this->userId = $auth->getUserId();
			
			$this->loadButtons($auth->isAuthorized());
		}
		
		private function loadButtons($authorized)
		{
			$currentPageURI = substr($_SERVER['REQUEST_URI'], 1);
			$this->logInButton = new SimpleButton('Log In', 'login.php', !$authorized, 'loginButtonSection');
			$this->logOutButton = new SimpleButton('Log Out', 'logout.php?from='.$currentPageURI, $authorized, 'loginButtonSection');
			$this->registerButton = new SimpleButton('Register', 'register.php', true, 'loginButtonSection');
		}
		
		protected function handleKeywords()
		{
			$this->replaceKeywordByText('USERNAME', $this->username);
			$this->replaceKeywordByText('SIGN_IN_BUTTON', $this->logInButton->getText());
			$this->replaceKeywordByText('SIGN_OUT_BUTTON', $this->logOutButton->getText());
			$this->replaceKeywordByText('REGISTER_BUTTON', $this->registerButton->getText());
			$this->replaceKeywordByText('USER_LINK', ($this->userId !== 0) ? SiteInfo::getAuthorLink($this->userId) : 'login.php');
		}
	}
?>