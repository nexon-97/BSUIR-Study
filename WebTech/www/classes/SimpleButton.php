<?php
	require_once('Template.php');
	
	class SimpleButton extends Template
	{
		private $action;
		private $label;
		private $shown;
		private $customClass;
		
		public function __construct($label, $action = '#', $shown = true, $customClass = '')
		{
			parent::__construct('simpleButton');
			
			$this->action = $action;
			$this->label = $label;
			$this->shown = $shown;
			$this->customClass = $customClass;
		}
		
		protected function handleKeywords()
		{
			$this->replaceKeywordByText('LABEL', $this->label);
			$this->replaceKeywordByText('ACTION', $this->action);
			$this->replaceKeywordByText('SHOW_FLAG', ($this->shown === true) ? 'block' : 'none');
			$this->replaceKeywordByText('CUSTOM_CLASS', $this->customClass);
		}
	}
?>