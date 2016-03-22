<?php

	class ContactPageContent extends Template
	{	
		public function __construct()
		{
			parent::__construct('contactPage');
		}
		
		protected function handleKeywords()
		{
			//$this->replaceKeywordByText('CATEGORIES', $this->getCategoriesQuickViewText());
		}
	}

?>