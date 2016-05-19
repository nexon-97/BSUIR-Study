<?php
	require_once('AdminBarCommentsView.php');

	class AdminBarContent extends Template
	{		
		protected $view;
		protected $activeView;

		public function __construct()
		{
			parent::__construct('adminbar_content');

			if (isset($_GET['view']))
			{
				$this->view = $_GET['view'];
			}

			$this->loadActiveView();
		}
		
		protected function loadActiveView()
		{
			$this->activeView = new AdminBarCommentsView();
		}

		protected function handleKeywords()
		{
			$this->replaceKeywordByText('ACTIVE_VIEW', $this->activeView->getText());
		}
	}
?>