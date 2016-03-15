<?php

	class SocialInfoLine extends Template
	{
		public $property;
		public $value;
		
		public function __construct($property, $value)
		{
			parent::__construct('social_info_line');
			
			$this->property = $property;
			$this->value = $value;
		}
		
		protected function HandleKeywords()
		{
			$this->ReplaceKeywordByText('KEY', $this->property);
			$this->ReplaceKeywordByText('VALUE', $this->value);
		}
	}

?>