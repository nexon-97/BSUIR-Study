<?php
	require_once('classes/Utils.php');
	require_once('classes/Database.php');
	require_once('classes/MessagesDatabase.php');
	require_once('classes/Authorization.php');
	
	if (isset($_GET['username']))
	{
		$username = $_GET['username'];
		
		if (isset($_GET['token'], $_GET['pass']))
		{
			$token = $_GET['token'];
			$pass = $_GET['pass'];
			
			// Change user credentials
			$auth = Authorization::getInstance();
			$userId = $auth->getUserIdByLogin($username);
			
			if ($userId > 0)
			{
				$serverToken = $auth->getConfirmToken($userId);
			
				if ($serverToken === $token)
				{
					$auth->changeUserPassword($userId, $pass);
				
					// Invalidate token
					//$auth->updateUserToken($userId);
					Utils::redirectToMessagePage(MessagesDatabase::PASSWORD_RESET_TOKEN_OK_MSG);
				}
				else
				{
					Utils::redirectToMessagePage(MessagesDatabase::INVALID_CONFIRM_TOKEN_MSG);
				}
			}
			
			Utils::redirectToIndex();
		}
		else
		{
			$db = new Database();
			$userInfo = $db->SelectConditional('user_profiles', 'email', "nickname = '$username'");
			
			if (count($userInfo) > 0)
			{
				$userInfo = $userInfo[0];
				$email = $userInfo['email'];
				
				// Send reset password email
				$auth = Authorization::getInstance();
				$userId = $auth->getUserIdByLogin($username);
				$token = $auth->getConfirmToken($userId);
				$newPassword = substr(md5(rand()), 0, 10);
				$confirmationLink = SiteInfo::$siteDomain.'restorepass.php?username='.$username.'&token='.$token.'&pass='.$newPassword;
				
				$message = "A password reset request recognized on your account at nexonlab.hol.es\n";
				$message .= "If you didn't requested such action, just ignore this message.\n";
				$message .= "If you want to reset your password, click the link below.\n";
				$message .= $confirmationLink."\n";
				$message .= "Your new temporary password will be \"$newPassword\". Change it as soon as you acquire access to your account.\n";
				Utils::sendMail($email, 'Restore password', $message);
				
				Utils::redirectToMessagePage(MessagesDatabase::RESET_PASS_INFO_MSG);
			}
		}
	}
	else
	{
		Utils::redirectToIndex();
	}
?>