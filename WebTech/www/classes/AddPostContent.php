<?php
	require_once('Template.php');
	require_once('Database.php');

	class AddPostContent extends Template
	{		
		public function __construct()
		{
			parent::__construct('edit_post');
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
			$this->replaceKeywordByText('CATEGORY_OPTIONS', $this->getCategorySelectOptions());
			$this->replaceKeywordByText('ACTION', 'add.php');
			$this->replaceKeywordByText('ENTITY_ID', '');
			$this->replaceKeywordByText('TITLE', '');
			$this->replaceKeywordByText('SHORT_DESC', '');
			$this->replaceKeywordByText('DESC', '');
		}
	}
?>