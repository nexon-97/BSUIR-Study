<?php
	require_once('classes/DocumentTemplate.php');
	require_once('classes/Utils.php');

	if (isset($_POST['msgText'], $_POST['msgTheme']))
	{
		$subject = $_POST['msgTheme'];
		$message = $_POST['msgText'];

		if (Utils::sendMail('denis.ponyakov@nexonlab.hol.es', $subject, $message))
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