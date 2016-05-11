<?php
	require_once('classes/DocumentTemplate.php');
	
	$template = new DocumentTemplate('error');
	echo $template->GetText();
?>