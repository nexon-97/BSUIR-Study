<?php
	require_once('classes/DocumentTemplate.php');
	require_once('classes/Database.php');
	
	$template = new DocumentTemplate();
	echo $template->GetText();
?>