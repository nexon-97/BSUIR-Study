<?php
	require_once('classes/Authorization.php');
	require_once('classes/Utils.php');
	
	$auth = Authorization::getInstance();
	$auth->logOut();
	
	if (isset($_GET['from']))
	{
		Utils::localRedirect($_GET['from']);
	}
	else
	{
		Utils::redirectToIndex();
	}
?>