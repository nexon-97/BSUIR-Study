<?php
	require_once('Database.php');

	class Authorization
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
		
		const BANNED_RIGHTS = 0;
		const GUEST_RIGHTS = 1;
		const LOGGED_USER_RIGHTS = 2;
		const MODERATOR_RIGHTS = 3;
		const ADMIN_RIGHTS = 4;
		
		protected $username;
		protected $passwordHash;
		protected $authorized;
		protected $userRights;
		
		protected function init()
		{
			$this->userRights = 0;
			$this->passwordHash = 0;
			$this->userRights = 0;
			$this->authorized = false;
			
			$this->authorizeFromCookies();
		}
		
		public function authorizeFromCookies()
		{
			$this->authorized = false;
			
			if (isset($_COOKIE['user']) and isset($_COOKIE['hash']))
			{
				$cookieUsername = $_COOKIE['user'];
				
				// Load password hash
				$db = new Database('nexonlab');
				$selectResult = $db->SelectConditional('user_profiles', 'id, password', 'nickname = "'.$cookieUsername.'"');
				if (count($selectResult) > 0)
				{
					// Compare database hash with hash from cookies
					$loadedHash = $selectResult[0]['password'];
					$cookieHash = $_COOKIE['hash'];
					
					if ($loadedHash === $cookieHash)
					{
						$this->username = $_COOKIE['user'];
						$this->passwordHash = $cookieHash;
						
						$this->authorized = true;
						
						// Determine user rights
						$userId = $selectResult[0]['id'];
						$rightsInfo = $db->SelectConditional('user_privilegies', 'rights', "user_id = $userId");
						if (count($rightsInfo) > 0)
						{
							$this->userRights = $rightsInfo[0]['rights'];
						}
					}
				}
			}
			
			return $this->authorized;
		}
		
		public function isAuthorized()
		{
			return $this->authorized;
		}
		
		public function getRights()
		{
			return $this->userRights;
		}
	}
?>