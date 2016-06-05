<?php
	require_once('Template.php');
	require_once('Database.php');

	class EditUserContent extends Template
	{		
		private $name;
		private $surname;
		private $vk;
		private $twitter;
		private $linkedin;
		private $userId;
	
		public function __construct()
		{
			parent::__construct('edit_user');
			
			$this->userId = $_GET['id'];
			
			$db = new Database();
			$generalInfo = $db->SelectConditional('user_profiles', 'name, surname', 'id = '.$this->userId);
			$socialInfo = $db->SelectConditional('user_social_links', '*', 'user_id = '.$this->userId);
			if (count($generalInfo) > 0 and count($socialInfo) > 0)
			{
				$generalInfo = $generalInfo[0];
				$socialInfo = $socialInfo[0];
				
				$this->name = $generalInfo['name'];
				$this->surname = $generalInfo['surname'];
				$this->vk = $socialInfo['vk'];
				$this->twitter = $socialInfo['twitter'];
				$this->linkedin = $socialInfo['linkedin'];
			}
		}
		
		private function getCategorySelectOptions()
		{
			$db = new Database();
			$categories = $db->Select('blogcategories', '*');
			
			foreach ($categories as $index => $info)
			{
				$options .= '<option value="'.$info['id'].'">'.$info['name'].'</option>'."\n";
			}
			
			return $options;
		}
		
		protected function handleKeywords()
		{
			$this->replaceKeywordByText('NAME', $this->name);
			$this->replaceKeywordByText('SURNAME', $this->surname);
			$this->replaceKeywordByText('VK', $this->vk);
			$this->replaceKeywordByText('TWITTER', $this->twitter);
			$this->replaceKeywordByText('LINKEDIN', $this->linkedin);
			$this->replaceKeywordByText('USER_ID', $this->userId);
		}
	}
?>