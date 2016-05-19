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
			Utils::redirectToErrorPage(1);
		}
	}
	else
	{
		Utils::localRedirect('login.php');
	}
?>