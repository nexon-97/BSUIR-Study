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
		
		const MIN_USERNAME_LENGTH = 4;
		const MAX_USERNAME_LENGTH = 32;
		const MIN_PASSWORD_LENGTH = 6;
		const MAX_PASSWORD_LENGTH = 16;
		
		const AUTH_FAIL = 0;
		const AUTH_SUCCESS = 1;
		const AUTH_INVALID_LOGIN = 2;
		const AUTH_INVALID_PASSWORD = 3;
		
		protected $validUsernameChars;
		
		protected $username;
		protected $passwordHash;
		protected $authorized;
		protected $userRights;
		protected $userId;
		
		protected function init()
		{
			$this->fillValidUsernameChars();
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
			// Validate user login and password
			if (!$this->isValidUsername($username))
			{
				return self::AUTH_INVALID_LOGIN;
			}
			
			if (!$this->isValidPassword($password))
			{
				return self::AUTH_INVALID_PASSWORD;
			}
			
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
					
					return self::AUTH_SUCCESS;
				}
			}
			
			return self::AUTH_FAIL;
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
		
		protected function fillValidUsernameChars()
		{
			$this->validUsernameChars = array();
			
			// Add digits
			for ($charCode = ord('0'); $charCode <= ord('9'); $charCode++)
			{
				$this->validUsernameChars[] = chr($charCode);
			}
			
			// Add chars
			for ($charCode = ord('a'); $charCode <= ord('z'); $charCode++)
			{
				$this->validUsernameChars[] = chr($charCode);
				$this->validUsernameChars[] = strtoupper(chr($charCode));
			}
			
			// Add special symbols
			array_push($this->validUsernameChars, '_', '$', '.');
		}
		
		public function isValidUsername($username)
		{
			$usernameLength = strlen($username);
			if ($usernameLength >= self::MIN_USERNAME_LENGTH and $usernameLength <= self::MAX_USERNAME_LENGTH)
			{
				$usernameChars = str_split($username);
				foreach ($usernameChars as $char)
				{
					if (!in_array($char, $this->validUsernameChars))
					{
						return false;
					}
				}
				
				// Username is valid, when it fits in length, and has no invalid characters
				return true;
			}
			
			return false;
		}
		
		public function isValidPassword($password)
		{
			$passwordLength = strlen($password);
			if ($passwordLength >= self::MIN_PASSWORD_LENGTH and $passwordLength <= self::MAX_PASSWORD_LENGTH)
			{
				$passwordChars = str_split($password);
				foreach ($passwordChars as $char)
				{
					if (!in_array($char, $this->validUsernameChars))
					{
						return false;
					}
				}
				
				// Password is valid, when it fits in length, and has no invalid characters
				return true;
			}
			
			return false;
		}
		
		public function usernameAlreadyTaken($username)
		{
			$db = new Database('nexonlab');
			$userData = $db->SelectConditional('user_profiles', 'id', 'nickname = "'.$username.'"');
			
			return (count($userData) === 1);
		}
		
		public function isValidEmail($email)
		{
			return filter_var($email, FILTER_VALIDATE_EMAIL);
		}
		
		public function emailAlreadyTaken($email)
		{
			$db = new Database('nexonlab');
			$userData = $db->SelectConditional('user_profiles', 'id', 'email = "'.$email.'"');
			
			return (count($userData) === 1);
		}
		
		public function registerUser($userData)
		{
			$db = new Database('nexonlab');
			$db->Query('INSERT INTO user_profiles (nickname, email, password, name, surname)
			VALUES (
				"'.$userData['login'].'", "'.$userData['email'].'", MD5("'.$userData['password'].'"), 
				"'.$userData['name'].'", "'.$userData['surname'].'"
			);');
			
			$userId = $db->SelectConditional('user_profiles', 'id', 'nickname = "'.$userData['login'].'"');
			$userId = $userId[0]['id'];
			
			// Set user privilegies to default
			$db->Query('INSERT INTO user_privilegies (user_id, rights) VALUES ('.$userId.', 2);');
			
			// Load social info
			$db->Query('INSERT INTO user_social_links (user_id, phone, vk, twitter, linkedin)
				VALUES ('.$userId.', "'.$userData['phone'].'", "'.$userData['vk'].'", "'.$userData['twitter'].'", "'.$userData['linkedin'].'");');
		}
	}
?>