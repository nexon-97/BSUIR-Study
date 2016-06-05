<?php
    require_once('../classes/Database.php');

    if (isset($_GET['id']))
    {
        $id = $_GET['id'];
        $dbConnection = new Database('u864060956_game', 'u864060956_nexus', 'zVEBUtsAirzGyfS8wm');
	$questionData = $dbConnection->SelectConditional('questions', '*', "id = $id");

        $questionData = $questionData[0];
        echo $questionData['title'].'|'.$questionData['var1'].'|'.$questionData['var2'].'|'.$questionData['var3'].'|'.$questionData['var4'].'|'.$questionData['correct'];
    }
?>