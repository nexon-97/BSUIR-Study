<?php

	require_once('HeaderBlock.php');
	require_once('FooterBlock.php');
	require_once('HeaderHorizontalMenu.php');
	require_once('IndexPageContent.php');
	require_once('BlogPageContent.php');
	require_once('ContactPageContent.php');
	require_once('UserInfoPageContent.php');
	require_once('FullPostViewContent.php');

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
			
			$this->loadContent($contentType);
		}
		
		public function loadContent($contentType)
		{	
			switch ($contentType)
			{
				case 'blog':
					$this->content = new BlogPageContent();
					break;
				case 'contact':
					$this->content = new ContactPageContent();
					break;
				case 'user':
					$this->content = new UserInfoPageContent();
					break;
				case 'post':
					$this->content = new FullPostViewContent();
					break;
				case 'index':
				default:
					$this->content = new IndexPageContent();
			}
		}
		
		protected function handleKeywords()
		{
			$this->replaceKeywordByText('HEADER', $this->header->getText());
			$this->replaceKeywordByText('HORIZONTAL_MENU', $this->horizontalMenu->getText());		
			$this->replaceKeywordByText('PAGE_CONTENT', $this->content->getText());
			$this->replaceKeywordByText('FOOTER', $this->footer->getText());
		}
		
	}

?>