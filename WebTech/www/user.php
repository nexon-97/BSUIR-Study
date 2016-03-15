<?php

	require_once('classes/DocumentTemplate.php');
	
	$template = new DocumentTemplate('user');
	echo $template->GetText();
	
?>