<?php
	require_once('RegisterForm.php');
	require_once('Authorization.php');

	class RegisterPageContent extends Template
	{
		protected $registerForm;
	
		public function __construct()
		{
			parent::__construct('general_content_block');
			
			$auth = Authorization::getInstance();
			$hasCredentials = isset($_POST['loginInput']);
			
			$loginError = RegisterForm::INPUT_VALID;
			$passwordError = RegisterForm::INPUT_VALID;
			$passwordRepeatError = RegisterForm::INPUT_VALID;
			$emailError = RegisterForm::INPUT_VALID;
			
			if ($hasCredentials)
			{
				$login = $_POST['loginInput'];
				$password = $_POST['passwordInput'];
				$passwordRepeat = $_POST['passwordRepeatInput'];
				$email = $_POST['emailInput'];
				$name = $_POST['nameInput'];
				$surname = $_POST['surnameInput'];
				
				$phoneNumber = $_POST['phoneNumberInput'];
				$vkLink = $_POST['vkPageInput'];
				$twitterLink = $_POST['twitterPageInput'];
				$linkedinLink = $_POST['linkedinPageInput'];
				
				// Verify login
				if ($auth->isValidUsername($login))
				{
					if ($auth->usernameAlreadyTaken($login))
					{
						$loginError = RegisterForm::LOGIN_ERROR_TAKEN;
					}
				}
				else
				{
					$loginError = RegisterForm::LOGIN_ERROR_INVALID_LOGIN;
				}
				
				// Verify password
				if ($auth->isValidPassword($password))
				{
					if ($password != $passwordRepeat)
					{
						$passwordRepeatError = RegisterForm::PASSWORD_REPEAT_DOESNT_MATCH;
					}
				}
				else
				{
					$passwordError = RegisterForm::PASSWORD_ERROR;
				}
				
				// Verify email
				if ($auth->isValidEmail($email))
				{
					if ($auth->emailAlreadyTaken($email))
					{
						$emailError = RegisterForm::EMAIL_ALREADY_REGISTERED;
					}
				}
				else
				{
					$emailError = RegisterForm::INVALID_EMAIL;
				}
				
				if ($loginError === RegisterForm::INPUT_VALID and
					$passwordError === RegisterForm::INPUT_VALID and
					$passwordRepeatError === RegisterForm::INPUT_VALID and
					$emailError === RegisterForm::INPUT_VALID)
				{
					// Pack user data to register
					$userData = array(
						'login' => $login,
						'password' => $password,
						'email' => $email,
						'name' => $name,
						'surname' => $surname,
						'phone' => $phoneNumber,
						'vk' => $vkLink,
						'twitter' => $twitterLink,
						'linkedin' => $linkedinLink
					);
					
					$auth->registerUser($userData);
				}
			}
			
			$this->registerForm = new RegisterForm($loginError, $passwordError, $passwordRepeatError, $emailError);
		}
		
		protected function handleKeywords()
		{
			$this->replaceKeywordByText('CONTENT', $this->registerForm->getText());
		}
	}
?>