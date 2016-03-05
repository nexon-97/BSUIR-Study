<?php

	require_once('classes/DocumentTemplate.php');
	
	$template = new DocumentTemplate('contact');
	echo $template->GetText();
	
?>