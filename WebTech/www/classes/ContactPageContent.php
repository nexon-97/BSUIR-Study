<?php

	class ContactPageContent extends Template
	{	
		public function __construct()
		{
			parent::__construct('contactPage');
		}
		
		protected function HandleKeywords()
		{
			//$this->ReplaceKeywordByText('CATEGORIES', $this->GetCategoriesQuickViewText());
		}
	}

?>