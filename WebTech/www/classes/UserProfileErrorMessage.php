<?php
	require_once('Template.php');

	class UserProfileErrorMessage extends Template
	{
		public function __construct()
		{
			parent::__construct('user_error_message');
			
		}
		
		protected function HandleKeywords()
		{
			//$this->ReplaceKeywordByText('USER_INFO', $this->contentPage->GetText());
		}
	}

?>