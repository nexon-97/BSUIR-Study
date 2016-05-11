<?php
	require_once('UserProfilePage.php');
	require_once('UserProfileErrorMessage.php');
	require_once('Utils.php');

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
			$success = false;
			
			$userId = isset($_GET['id']) ? $_GET['id'] : '0';
			if (ctype_digit($userId))
			{
				$databaseConnection = new Database('nexonlab');
				$result = $databaseConnection->SelectConditional('user_profiles', 'nickname, email, avatar, name, surname', 'id = ' . $userId);
				$socialInfo = $databaseConnection->SelectConditional('user_social_links', 'phone, vk, twitter, linkedin', 'user_id = ' . $userId);
				
				if (count($result) > 0)
				{	
					$info = $result[0];
					$this->contentPage = new UserProfilePage($info['nickname'], '0', $info['avatar'], $info['name'], $info['surname'], $info['email']);	
					
					$success = true;
				}
				
				if (count($socialInfo) > 0)
				{
					$socialInfo = $socialInfo[0];
					
					$this->contentPage->setSocialInfo($socialInfo['phone'], $socialInfo['vk'], $socialInfo['twitter'], $socialInfo['linkedin']);
				}
			}
			
			return $success;
		}
		
		private function loadUserErrorPage()
		{
			Utils::redirectToErrorPage(USER_NOT_FOUND_ERROR);
		}
		
		protected function handleKeywords()
		{
			$this->replaceKeywordByText('USER_INFO', $this->contentPage->getText());
		}
	}

?>