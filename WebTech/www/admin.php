<?php
	require_once('classes/Authorization.php');
	require_once('classes/DocumentTemplate.php');
	
	setcookie('user', 'DigitalKnight', time() + 64000);
	setcookie('hash', 'f88c965ac81a95f319f90a4e2f54cdd7', time() + 64000);
	
	$auth = Authorization::getInstance();
	if ($auth->isAuthorized())
	{
		if ($auth->getRights() >= Authorization::MODERATOR_RIGHTS)
		{
			$template = new DocumentTemplate('adminbar');
		}
		else
		{
			header('Location: http://www.nexonlab.by/error.php?errcode=1');
			exit;
		}
		
		echo $template->GetText();
	}
	else
	{
		header('Location: http://www.nexonlab.by/login.php');
		exit;
	}
?>