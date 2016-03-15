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
				return $node->GetText();
			}
			else
			{
				return '';
			}
		}
		
		protected function HandleKeywords()
		{
			$this->ReplaceKeywordByText('NICKNAME', $this->nickname);
			$this->ReplaceKeywordByText('RIGHTS', $this->rightsStr);
			$this->ReplaceKeywordByText('NAME', $this->name);
			$this->ReplaceKeywordByText('SURNAME', $this->surname);
			$this->ReplaceKeywordByText('EMAIL', $this->email);
			$this->ReplaceKeywordByText('AVATAR', $this->avatar);			
			$this->ReplaceKeywordByText('PHONE_NUMBER', $this->getNodeText($this->phone));
			$this->ReplaceKeywordByText('VK_LINK', $this->getNodeText($this->vkLink));
			$this->ReplaceKeywordByText('TWITTER_LINK', $this->getNodeText($this->twitterLink));
			$this->ReplaceKeywordByText('LINKEDIN_LINK', $this->getNodeText($this->linkedinLink));
		}
	}

?>