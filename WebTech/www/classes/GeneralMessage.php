<?php
	require_once('Template.php');
	require_once('Utils.php');
	
	const MESSAGE_TYPE_INFO = 0;
	const MESSAGE_TYPE_OK = 1;
	const MESSAGE_TYPE_ERROR = 2;

	class GeneralMessage extends Template
	{
		public $title;
		public $description;
		public $messageType;
		
		private $errorImage;
		
		public function __construct($title, $description, $messageType = MESSAGE_TYPE_INFO)
		{
			parent::__construct('general_message');
			
			$this->title = $title;
			$this->description = $description;
			$this->messageType = (int)$messageType;
		}
		
		private function getErrorImage()
		{
			switch ($this->messageType)
			{
				case MESSAGE_TYPE_ERROR:
					return 'img/warning.png';
				case MESSAGE_TYPE_OK:
					return 'img/ok.png';
				case MESSAGE_TYPE_INFO:
				default:
					return 'img/info.png';
			}
		}
		
		protected function handleKeywords()
		{
			$this->replaceKeywordByText('ERROR_IMAGE', $this->getErrorImage());
			$this->replaceKeywordByText('ERROR_TITLE', $this->title);
			$this->replaceKeywordByText('ERROR_DESC', $this->description);
		}
	}
?>