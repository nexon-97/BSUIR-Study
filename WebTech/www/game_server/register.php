<?php
	require_once('../classes/Authorization.php');

	$auth = Authorization::getInstance();
	if (isset($_POST['login'], $_POST['password']))
	{
		// Check if such login has already taken
	}
	else
	{
		echo 'FAIL!';
	}
?>