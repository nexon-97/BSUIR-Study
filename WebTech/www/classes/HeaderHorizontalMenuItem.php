<?php

	require_once('Template.php');

	class HeaderHorizontalMenuItem extends Template
	{
		
		public $caption;
		public $href;
		
		public function __construct($caption, $href = '#')
		{
			parent::__construct('horizMenuItem');
			
			$this->caption = $caption;
			$this->href = $href;
		}
		
		protected function handleKeywords()
		{
			$this->replaceKeywordByText('CAPTION', $this->caption);
			$this->replaceKeywordByText('HREF', $this->href);
		}
		
	}

?>