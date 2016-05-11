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
		protected $userId;
		
		protected function init()
		{
			$this->resetLoginData();		
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
						$this->userId = $selectResult[0]['id'];
						$rightsInfo = $db->SelectConditional('user_privilegies', 'rights', 'user_id = '.$this->userId);
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
		
		public function logOut()
		{
			$this->clearCookies();
			$this->resetLoginData();
		}
		
		public function tryLogIn($username, $password)
		{
			$success = false;
			
			$passwordHash = md5($password);
			
			$db = new Database('nexonlab');
			$serverCredentials = $db->SelectConditional('user_profiles', 'id, password', 'nickname = "'.$username.'"');
			if (count($serverCredentials) > 0)
			{
				$serverCredentials = $serverCredentials[0];
				
				if ($passwordHash == $serverCredentials['password'])
				{
					$userId = $serverCredentials['id'];
					$dbRights = $db->SelectConditional('user_privilegies', 'rights', "user_id = $userId");
					$this->logIn($username, $userId, $dbRights[0]['rights'], $passwordHash);
					
					$success = true;
				}
			}
			
			return $success;
		}
		
		protected function logIn($username, $userId, $rights, $hash)
		{
			$this->username = $username;
			$this->userId = $userId;
			$this->userRights = $rights;
			$this->passwordHash = $hash;
			$this->authorized = true;
			
			setcookie('user', $this->username, time() + 2592000);
			setcookie('hash', $this->passwordHash, time() + 2592000);
		}
		
		public function resetLoginData()
		{
			$this->username = 'Guest';
			$this->userId = 0;
			$this->userRights = 1;
			$this->passwordHash = '';
			$this->authorized = false;
		}
		
		protected function clearCookies()
		{
			$cookieNames = array('user', 'hash');
			foreach ($cookieNames as $cookie)
			{
				setcookie($cookie, '', 0);
			}
		}
		
		public function getUsername()
		{
			return $this->username;
		}
		
		public function getUserId()
		{
			return $this->userId;
		}
	}
?>