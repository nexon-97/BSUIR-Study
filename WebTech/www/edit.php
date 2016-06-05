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
	if ($auth->isAuthorized() and $auth->getRights() >= Authorization::LOGGED_USER_RIGHTS and isset($_GET['entity'], $_GET['id']))
	{
		// Perform deletion
		$entity = $_GET['entity'];
		$id = $_GET['id'];

		switch ($entity)
		{
			case 'post':
				if (isset($_POST['categorySelect'], $_POST['postTitle'], $_POST['shortDesc'], $_POST['postText']))
				{
					Utils::updatePost($id, $_POST['categorySelect'], $_POST['postTitle'], $_POST['shortDesc'], $_POST['postText']);
					redirectToRefererPage();
				}
				else
				{
					$document = new DocumentTemplate('editpost');
					echo $document->getText();
				}
				break;
			case 'user':
				if ($id === $auth->getUserId() or $auth->getRights() === Authorization::ADMIN_RIGHTS)
				{
					if (isset($_POST['nameEdit'], $_POST['surnameEdit'], $_POST['vkEdit']))
					{
						Utils::updateUser($id,
							$_POST['nameEdit'],
							$_POST['surnameEdit'],
							$_POST['vkEdit'], 
							$_POST['twitterEdit'],
							$_POST['linkedinEdit'],
							$_POST['passwordEdit'], 
							$_POST['newPasswordEdit'],
							$_POST['newPasswordRepeatEdit']);
						redirectToRefererPage(10);
					}
					else
					{
						$document = new DocumentTemplate('edituser');
						echo $document->getText();
					}
				}
				break;
		}
	}
	else
	{
		Utils::redirectToErrorPage(1);
	}
?>