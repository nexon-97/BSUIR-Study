<?php
	require_once('HeaderBlock.php');
	require_once('FooterBlock.php');
	require_once('HeaderHorizontalMenu.php');
	require_once('IndexPageContent.php');
	require_once('BlogPageContent.php');
	require_once('ContactPageContent.php');
	require_once('UserInfoPageContent.php');
	require_once('FullPostViewContent.php');
	require_once('AdminBarContent.php');
	require_once('LoginContent.php');
	require_once('ErrorMessage.php');

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
				case 'adminbar':
					$this->content = new AdminBarContent();
					break;
				case 'error':
					if (isset($_GET['errcode']))
					{
						$errcode = (int)($_GET['errcode']);
						ErrorMessage::initErrorTexts();
						$errorMsg = ErrorMessage::getErrorMessage($errcode);
						$this->content = new ErrorMessage($errorMsg['title'], $errorMsg['desc']);
					}
					break;
				case 'login':
					$this->content = new LoginContent();
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

			if (isset($this->content))
			{
				$this->replaceKeywordByText('PAGE_CONTENT', $this->content->getText());
			}				
			else
			{
				header('Location: http://www.nexonlab.by/index.php');
				exit;
			}
			
			$this->replaceKeywordByText('FOOTER', $this->footer->getText());
		}
	}
?>