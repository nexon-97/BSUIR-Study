<?php
	require_once('ErrorMessage.php');

	class PostNotFoundErrorMessage extends ErrorMessage
	{
		public function __construct()
		{
			parent::__construct('Post not found', 'Maybe, it was deleted, or you are not granted access to it.');
		}
	}

?>