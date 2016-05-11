<?php
	require_once('classes/Authorization.php');
	require_once('classes/DocumentTemplate.php');
	
	$auth = Authorization::getInstance();
	if ($auth->isAuthorized())
	{
		if ($auth->getRights() >= Authorization::MODERATOR_RIGHTS)
		{
			$template = new DocumentTemplate('adminbar');
			echo $template->GetText();
		}
		else
		{
			header('Location: http://www.nexonlab.by/error.php?errcode=1');
			exit;
		}
	}
	else
	{
		header('Location: http://www.nexonlab.by/login.php');
		exit;
	}
?>