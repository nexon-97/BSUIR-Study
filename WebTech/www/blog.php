<?php

	require_once('classes/DocumentTemplate.php');
	
	$template = new DocumentTemplate('blog');
	echo $template->GetText();
	
?>