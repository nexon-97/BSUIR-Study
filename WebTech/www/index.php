<?php

	require_once('classes/DocumentTemplate.php');
	require_once('classes/Database.php');
	
	$db = new Database('nexonlab');
	$selectResult = $db->Select('blogcategories', '`name`');
	
	echo '<pre>';
	echo print_r($selectResult);
	echo '</pre>';
	
	$template = new DocumentTemplate();
	echo $template->GetText();
	
?>