<?php
	require_once('SocialInfoLine.php');

	class UserProfilePage extends Template
	{
		public $nickname;
		public $rightsStr;
		public $name;
		public $surname;
		public $email;
		public $avatar;
		public $phone;
		public $vkLink;
		public $twitterLink;
		public $linkedinLink;
		
		public function __construct($nickname, $rights, $avatar, $name, $surname, $email)
		{
			parent::__construct('user_profile');
			
			$this->nickname = $nickname;
			$this->rightsStr = $rights;
			$this->name = $name;
			$this->surname = $surname;
			$this->email = $email;
			$this->avatar = $avatar;
		}
		
		public function setSocialInfo($phone, $vkLink, $twitterLink, $linkedinLink)
		{
			$this->phone = $this->addSocialInfoLine('Phone Number', $phone);
			$this->vkLink = $this->addSocialInfoLine('VK', $vkLink);
			$this->twitterLink = $this->addSocialInfoLine('Twitter', $twitterLink);
			$this->linkedinLink = $this->addSocialInfoLine('LinkedIn', $linkedinLink);
		}
		
		private function addSocialInfoLine($key, $value)
		{
			if (strlen($value) > 0)
			{
				return new SocialInfoLine($key, $value);
			}
			
			return null;
		}
		
		private function getNodeText($node)
		{
			if (isset($node))
			{
				return $node->getText();
			}
			else
			{
				return '';
			}
		}
		
		protected function handleKeywords()
		{
			$this->replaceKeywordByText('NICKNAME', $this->nickname);
			$this->replaceKeywordByText('RIGHTS', $this->rightsStr);
			$this->replaceKeywordByText('NAME', $this->name);
			$this->replaceKeywordByText('SURNAME', $this->surname);
			$this->replaceKeywordByText('EMAIL', $this->email);
			$this->replaceKeywordByText('AVATAR', $this->avatar);			
			$this->replaceKeywordByText('PHONE_NUMBER', $this->getNodeText($this->phone));
			$this->replaceKeywordByText('VK_LINK', $this->getNodeText($this->vkLink));
			$this->replaceKeywordByText('TWITTER_LINK', $this->getNodeText($this->twitterLink));
			$this->replaceKeywordByText('LINKEDIN_LINK', $this->getNodeText($this->linkedinLink));
		}
	}

?>