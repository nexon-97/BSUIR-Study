<?php
	require_once('ErrorMessage.php');

	class UserProfileErrorMessage extends ErrorMessage
	{
		public function __construct()
		{
			parent::__construct('Error', 'Sorry, but requested user not found.');
		}
	}

?>