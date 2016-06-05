<?php
	require_once('../classes/Database.php');
	
	function cleanupSessionsBase()
	{
		$dbConnection = new Database('u864060956_game', 'u864060956_nexus', 'zVEBUtsAirzGyfS8wm');
		$timeout = 5;
	
		// Remove all session entries that are older than 5 minutes
		$dbConnection->Query("DELETE FROM `sessions` WHERE `last_activity` < timestamp(DATE_SUB(NOW(), INTERVAL $timeout MINUTE))");
	}
?>	