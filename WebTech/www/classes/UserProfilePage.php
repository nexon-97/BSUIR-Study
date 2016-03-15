<?php

	class UserProfilePage extends Template
	{
		public $nickname;
		public $rightsStr;
		public $name;
		public $surname;
		public $email;
		public $avatar;
		
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
		
		protected function HandleKeywords()
		{
			$this->ReplaceKeywordByText('NICKNAME', $this->nickname);
			$this->ReplaceKeywordByText('RIGHTS', $this->rightsStr);
			$this->ReplaceKeywordByText('NAME', $this->name);
			$this->ReplaceKeywordByText('SURNAME', $this->surname);
			$this->ReplaceKeywordByText('EMAIL', $this->email);
			$this->ReplaceKeywordByText('AVATAR', $this->avatar);
		}
	}

?>