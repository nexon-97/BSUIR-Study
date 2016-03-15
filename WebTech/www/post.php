<?php
	require_once('classes/DocumentTemplate.php');
	
	$template = new DocumentTemplate('post');
	echo $template->GetText();
?>