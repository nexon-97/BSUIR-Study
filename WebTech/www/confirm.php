<?php
	require_once('classes/Authorization.php');
	require_once('classes/Utils.php');
	require_once('classes/MessagesDatabase.php');
	
	if (isset($_GET['user'], $_GET['token']))
	{
		$user = $_GET['user'];
		$token = $_GET['token'];
		
		// Load user confirmation info
		$auth = Authorization::getInstance();
		$confirmed = $auth->emailConfirmed($user);
		
		if ($confirmed === 0)
		{
			$dbToken = $auth->getConfirmToken($user);
			
			if ($dbToken === $token)
			{
				$auth->confirmUserMail($user);
				
				Utils::redirectToMessagePage(MessagesDatabase::RIGISTER_SUCCESS_MSG);
			}
		}
		
		Utils::redirectToMessagePage(MessagesDatabase::INVALID_CONFIRM_TOKEN_MSG);
	}
	
	Utils::redirectToIndex();
?>