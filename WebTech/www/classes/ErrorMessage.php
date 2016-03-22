<?php
	require_once('Template.php');
	
	const ERRCODE_ERROR = 0;
	const ERRCODE_WARNING = 1;
	const ERRCODE_INFO = 2;

	class ErrorMessage extends Template
	{
		public $title;
		public $description;
		public $errorCode;
		
		private $useCustomErrorImage;
		private $errorImage;
		
		public function __construct($title, $description, $errorCode = ERRCODE_ERROR)
		{
			parent::__construct('general_error_message');
			
			$this->title = $title;
			$this->description = $description;
			$this->errorCode = $errorCode;
			$this->useCustomErrorImage = false;
		}
		
		public function setCustomErrorImage($imagePath)
		{
			$this->errorImage = $imagePath;
			$this->useCustomErrorImage = true;
		}
		
		private function getErrorImage()
		{
			if ($this->useCustomErrorImage)
			{
				return $this->errorImage;
			}
			else
			{
				switch ($this->errorCode)
				{
					case ERRCODE_ERROR:
					default:
						return 'img/warning.png';
				}
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