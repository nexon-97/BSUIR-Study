<?php
	require_once('classes/Authorization.php');
	require_once('classes/Utils.php');

	function redirectToRefererPage()
	{
		if (isset($_GET['referer']))
		{
			Utils::localRedirect($_GET['referer']);
		}
	}
	
	$auth = Authorization::getInstance();
	if ($auth->isAuthorized() and $auth->getRights() >= Authorization::LOGGED_USER_RIGHTS)
	{
		if (isset($_GET['post_id'], $_POST['commentText']))
		{
			// Perform insertion
			$postId = $_GET['post_id'];
			$commentText = $_POST['commentText'];

			if (strlen($commentText) > 0)
			{
				Utils::addComment($postId, $commentText);
			}
		}

		// Redirect after performing
		redirectToRefererPage();
	}
	else
	{
		Utils::redirectToErrorPage(1);
	}

	Utils::redirectToIndex();
?>