<?php

	require_once('classes/DocumentTemplate.php');
	
	$template = new DocumentTemplate('category');
	echo $template->GetText();
	
?>