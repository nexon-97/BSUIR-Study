<?php
	require_once('Template.php');

	class RegisterForm extends Template
	{
		const INPUT_VALID = 0;
		const EMPTY_STRING = '';
		
		const LOGIN_ERROR_INVALID_LOGIN = 1;
		const LOGIN_ERROR_TAKEN = 2;
		const PASSWORD_ERROR = 1;
		const PASSWORD_REPEAT_DOESNT_MATCH = 1;
		const INVALID_EMAIL = 1;
		const EMAIL_ALREADY_REGISTERED = 2;
		
		private $errorMask;
		protected $errorTexts;
		
		public function __construct($usernameError = 0, $passwordError = 0, $passwordRepeatError = 0,
			$emailError = 0)
		{
			parent::__construct('registerPage');
			
			$this->loadErrorTexts();
			
			$this->errorMask = array();
			$this->errorMask['login'] = $usernameError;
			$this->errorMask['password'] = $passwordError;
			$this->errorMask['password_repeat'] = $passwordRepeatError;
			$this->errorMask['email'] = $emailError;
		}
		
		protected function loadErrorTexts()
		{
			$jsonText = Utils::readDataFile('RegisterFormErrors.json');
			if ($jsonText !== false)
			{
				$this->errorTexts = json_decode($jsonText, true);
			}
		}
		
		protected function errorShown($errorName)
		{
			return ($this->errorMask[$errorName] > 0) ? 'block' : 'none';
		}
		
		protected function getErrorMessage($errorName, $errorId)
		{
			if ($errorId === 0)
			{
				return self::EMPTY_STRING;
			}
			
			return $this->errorTexts[$errorName][$errorId];
		}
		
		protected function handleKeywords()
		{
			// Show/hide errors
			$this->replaceKeywordByText('LOGIN_ERROR_DISPLAY', $this->errorShown('login'));
			$this->replaceKeywordByText('PASSWORD_ERROR_DISPLAY', $this->errorShown('password'));
			$this->replaceKeywordByText('PASSWORD_REPEAT_ERROR_DISPLAY', $this->errorShown('password_repeat'));
			$this->replaceKeywordByText('EMAIL_ERROR_DISPLAY', $this->errorShown('email'));
			
			// Set error texts
			$this->replaceKeywordByText('LOGIN_ERROR_TEXT', $this->getErrorMessage('login', $this->errorMask['login']));
			$this->replaceKeywordByText('PASSWORD_ERROR_TEXT', $this->getErrorMessage('password', $this->errorMask['password']));
			$this->replaceKeywordByText('PASSWORD_REPEAT_ERROR_TEXT', $this->getErrorMessage('password_repeat', $this->errorMask['password_repeat']));
			$this->replaceKeywordByText('EMAIL_ERROR_TEXT', $this->getErrorMessage('email', $this->errorMask['email']));
		}
	}
?>