<?php
	require_once('classes/Authorization.php');
	require_once('classes/DocumentTemplate.php');

	function redirectToRefererPage()
	{
		if (isset($_GET['referer']))
		{
			Utils::localRedirect($_GET['referer']);
		}
	}
	
	$auth = Authorization::getInstance();
	if ($auth->isAuthorized() and $auth->getRights() >= Authorization::MODERATOR_RIGHTS and isset($_GET['entity'], $_GET['id']))
	{
		// Perform deletion
		$entity = $_GET['entity'];
		$id = $_GET['id'];

		switch ($entity)
		{
			case 'comment':
				Utils::removeComment($id);
				break;
			case 'post':
				Utils::removePost($id);
				break;
		}

		// Redirect after performing
		redirectToRefererPage();
	}
	else
	{
		Utils::redirectToErrorPage(1);
	}
?>