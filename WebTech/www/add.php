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
	if ($auth->isAuthorized() and $auth->getRights() >= Authorization::LOGGED_USER_RIGHTS and isset($_GET['entity']))
	{
		// Perform deletion
		$entity = $_GET['entity'];

		switch ($entity)
		{
			case 'post':
				if (isset($_POST['categorySelect'], $_POST['postTitle'], $_POST['shortDesc'], $_POST['postText']))
				{
					Utils::addPost($_POST['categorySelect'], $_POST['postTitle'], $_POST['shortDesc'], $_POST['postText']);
					redirectToRefererPage();
				}
				else
				{
					$document = new DocumentTemplate('addpost');
					echo $document->getText();
				}
				break;
			case 'cat':
				if (isset($_GET['name']))
				{
					Utils::addCategory($_GET['name']);
					redirectToRefererPage();
				}
				break;
		}
	}
	else
	{
		Utils::redirectToErrorPage(1);
	}
?>