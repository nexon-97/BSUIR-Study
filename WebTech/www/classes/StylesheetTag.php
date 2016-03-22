<?php

	require_once('Template.php');

	class StylesheetTag extends Template
	{
		
		public $stylesheetPath;
		
		public function __construct($path)
		{
			parent::__construct('style_tag');
			
			$this->stylesheetPath = $path;
		}
		
		protected function handleKeywords()
		{
			$this->replaceKeywordByText('PATH', $this->stylesheetPath);
		}
		
	}

?>