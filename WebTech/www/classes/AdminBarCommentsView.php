<?php
	require_once('Template.php');

	class AdminBarCommentsView extends Template
	{
		public function __construct()
		{
			parent::__construct('comments_view');
		}
		
		protected function handleKeywords()
		{
			//$this->replaceKeywordByText('LOGIN_ERROR_TEXT', $this->errorText);
			//$this->replaceKeywordByText('ERROR_DISPLAY', $this->showError ? 'block' : 'none');
		}
	}
?>