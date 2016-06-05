<?php
	require_once('Utils.php');

	class MessagesDatabase
	{
		// ==========================
		// ! Singleton pattern part !
		protected static $_instance;

		private function __construct()
		{
			$this->init();
		}

		public static function getInstance()
		{
			if (self::$_instance === null)
			{
				self::$_instance = new self;  
			}
 
			return self::$_instance;
		}
 
		// Disable clone and wakeup methods
		private function __clone() { }
		private function __wakeup() { }

		// ==========================

		const RIGISTER_SUCCESS_MSG = 3;
		const CONFIRM_EMAIL_MSG = 6;
		const INVALID_CONFIRM_TOKEN_MSG = 7;
		const RESET_PASS_INFO_MSG = 8;
		const PASSWORD_RESET_TOKEN_OK_MSG = 9;

		protected $messagesPath = 'GeneralMessages.json';
		protected $messages;

		protected function init()
		{
			$this->loadMessages();
		}

		public function loadMessages()
		{
			if (!isset($this->messages))
			{
				$jsonText = Utils::readDataFile($this->messagesPath);
				if ($jsonText !== false)
				{
					$this->messages = json_decode($jsonText, true);
				}
			}
		}

		public function getMessage($id)
		{
			return (isset($this->messages[$id])) ? $this->messages[$id] : $this->messages[0];
		}
	}
?>