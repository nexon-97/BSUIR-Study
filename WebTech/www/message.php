<?php
	require_once('classes/DocumentTemplate.php');
	
	$template = new DocumentTemplate('message');
	echo $template->GetText();
?>