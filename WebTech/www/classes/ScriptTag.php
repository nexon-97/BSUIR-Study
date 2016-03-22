<?php

	require_once('Template.php');

	class ScriptTag extends Template
	{
		
		public $scriptPath;
		
		public function __construct($path)
		{
			parent::__construct('script_tag');
			
			$this->scriptPath = $path;
		}
		
		protected function handleKeywords()
		{
			$this->replaceKeywordByText('PATH', $this->scriptPath);
		}
		
	}

?>