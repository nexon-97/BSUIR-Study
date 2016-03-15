<?php
	require_once('UserProfilePage.php');
	require_once('UserProfileErrorMessage.php');

	class UserInfoPageContent extends Template
	{
		private $contentPage;
		
		public function __construct()
		{
			parent::__construct('user_profile_content');
			
			if ($this->loadUserInfo() == false)
			{
				$this->loadUserErrorPage();
			}
		}
		
		private function loadUserInfo()
		{
			$userId = $_GET['id'];
			if (ctype_digit($userId))
			{
				$databaseConnection = new Database('nexonlab');
				$result = $databaseConnection->SelectConditional('user_profiles', 'nickname, email, avatar, name, surname', 'id = ' . $userId);
				if (count($result) > 0)
				{	
					$info = $result[0];
					$this->contentPage = new UserProfilePage($info['nickname'], '0', $info['avatar'], $info['name'], $info['surname'], $info['email']);	
					
					return true;
				}
			}
			
			return false;
		}
		
		private function loadUserErrorPage()
		{
			$this->contentPage = new UserProfileErrorMessage();
		}
		
		protected function HandleKeywords()
		{
			$this->ReplaceKeywordByText('USER_INFO', $this->contentPage->GetText());
		}
	}

?>