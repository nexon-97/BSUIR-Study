<?php

	require_once('HeaderBlock.php');
	require_once('FooterBlock.php');
	require_once('HeaderHorizontalMenu.php');
	require_once('IndexPageContent.php');
	require_once('BlogPageContent.php');

	class DocumentBody extends Template
	{
		
		protected $header;
		protected $footer;
		protected $horizontalMenu;
		protected $content;
		
		public function __construct($contentType)
		{
			parent::__construct('bodyTemplate');
			
			$this->header = new HeaderBlock();
			$this->footer = new FooterBlock();
			$this->horizontalMenu = new HeaderHorizontalMenu();
			
			$this->LoadContent($contentType);
		}
		
		public function LoadContent($contentType)
		{	
			switch ($contentType)
			{
				case 'blog':
					$this->content = new BlogPageContent();
					break;
				case 'index':
				default:
					$this->content = new IndexPageContent();
			}
		}
		
		protected function HandleKeywords()
		{
			$this->ReplaceKeywordByText('HEADER', $this->header->GetText());
			$this->ReplaceKeywordByText('HORIZONTAL_MENU', $this->horizontalMenu->GetText());		
			$this->ReplaceKeywordByText('PAGE_CONTENT', $this->content->GetText());
			$this->ReplaceKeywordByText('FOOTER', $this->footer->GetText());
		}
		
	}

?>