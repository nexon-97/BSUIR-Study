<?php
	require_once('classes/DocumentTemplate.php');
	require_once('classes/Utils.php');

	if (isset($_POST['msgText'], $_POST['msgTheme']))
	{
		$subject = $_POST['msgTheme'];
		$message = $_POST['msgText'];

		// Send mail
		$message = wordwrap($message, 70, "\r\n");

		// Send
		$sent = mail('denis.ponyakov@nexonlab.hol.es', $subject, $message);

		if ($sent)
		{
			Utils::redirectToMessagePage(4);
		}
		else
		{
			Utils::redirectToMessagePage(5);
		}
	}
	
	$template = new DocumentTemplate('contact');
	echo $template->GetText();
?>