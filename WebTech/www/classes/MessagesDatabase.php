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