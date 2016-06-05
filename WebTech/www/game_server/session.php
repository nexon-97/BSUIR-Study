<?php
	require_once('../classes/Database.php');
	require_once('cleanup_sessions.php');

	function createSession($userId, $address)
	{
		$dbConnection = new Database('u864060956_game', 'u864060956_nexus', 'zVEBUtsAirzGyfS8wm');
		$dbConnection->Query("INSERT INTO `sessions` (`user_id`, `address`) VALUES ($userId,  '$address')");
		return $dbConnection->getInsertId();
	}
	
	function dropSession($sessionId)
	{
		$dbConnection = new Database('u864060956_game', 'u864060956_nexus', 'zVEBUtsAirzGyfS8wm');
		$dbConnection->Query("DELETE FROM `sessions` WHERE `id` = $sessionId");
	}
	
	function updateSession($sessionId)
	{
		$dbConnection = new Database('u864060956_game', 'u864060956_nexus', 'zVEBUtsAirzGyfS8wm');
		$timestamp = gmdate('yy-mm-dd hh:mm:ss', time());
		$dbConnection->Query("UPDATE `sessions` SET `last_activity` = '$timestamp' WHERE `id` = $sessionId");
	}
	
	function getSession($sessionId)
	{
		$dbConnection = new Database('u864060956_game', 'u864060956_nexus', 'zVEBUtsAirzGyfS8wm');
		$selectResult = $dbConnection->SelectConditional('sessions', '*', "id = $sessionId");
		if (count($selectResult) > 0)
		{
			return $selectResult[0];
		}
		else
		{
			return false;
		}
	}
	
	cleanupSessionsBase();
	
	if (isset($_POST['action']))
	{
		$action = $_POST['action'];
		
		switch ($action)
		{
			case 'create':
				if (isset($_POST['user_id'], $_POST['address']))
				{
					$sessionId = createSession($_POST['user_id'], $_POST['address']);
					echo $sessionId;
					exit;
				}
				break;
			case 'drop':
				if (isset($_POST['id']))
				{
					dropSession($_POST['id']);
					echo 'OK';
					exit;
				}
				break;
			case 'update':
				if (isset($_POST['id']))
				{
					updateSession($_POST['id']);
					echo 'OK';
					exit;
				}
				break;
			case 'get':
				if (isset($_POST['id']))
				{
					$sessionInfo = getSession($_POST['id']);
					if ($sessionInfo !== false)
					{
						echo $sessionInfo['id'].'|'.$sessionInfo['user_id'].'|'.$sessionInfo['address'].'|'.$sessionInfo['last_activity'];
					}
					else
					{
						echo 'NOT FOUND';
					}
					exit;
				}
				break;
		}
	}
	
	echo 'FAILED';
?>