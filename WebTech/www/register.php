<?php
	require_once('classes/DocumentTemplate.php');
	
	$template = new DocumentTemplate('register');
	echo $template->GetText();
?>