<?php
	require_once('classes/DocumentTemplate.php');
	
	$template = new DocumentTemplate('login');
	echo $template->GetText();
?>