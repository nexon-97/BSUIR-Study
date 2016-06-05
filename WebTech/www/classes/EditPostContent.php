<?php
	require_once('Template.php');
	require_once('Database.php');

	class EditPostContent extends Template
	{		
		private $postId;
		private $title;
		private $shortDesc;
		private $fullText;
	
		public function __construct()
		{
			parent::__construct('edit_post');
			
			$this->postId = $_GET['id'];
			
			$db = new Database();
			$selectResult = $db->SelectConditional('blog_entries', '*', 'id = '.$this->postId);
			if (count($selectResult) > 0)
			{
				$selectResult = $selectResult[0];
				
				$this->title = $selectResult['title'];
				$this->shortDesc = $selectResult['short_desc'];
				$this->fullText = $selectResult['desc'];
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
			$this->replaceKeywordByText('CATEGORY_OPTIONS', $this->getCategorySelectOptions());
			$this->replaceKeywordByText('ACTION', 'edit.php');
			$this->replaceKeywordByText('ENTITY_ID', 'id='.$this->postId.'&');
			$this->replaceKeywordByText('TITLE', $this->title);
			$this->replaceKeywordByText('SHORT_DESC', $this->shortDesc);
			$this->replaceKeywordByText('DESC', $this->fullText);
		}
	}
?>