<?php
	require_once('SiteInfo.php');
	require_once('Authorization.php');

	class Utils
	{
		public static function redirect($location, $timeout = 0)
		{
			header("Refresh: $timeout; URL=$location");
			exit;
		}
		
		public static function localRedirect($location, $timeout = 0)
		{
			self::redirect(SiteInfo::$siteDomain.$location, $timeout);
		}
		
		public static function readDataFile($file)
		{
			$path = SiteInfo::$siteDomain.'data/'.$file;
			return @file_get_contents($path);
		}
		
		public static function redirectToErrorPage($errorId, $timeout = 0)
		{
			self::localRedirect('error.php?errcode='.$errorId, $timeout);
		}

		public static function redirectToMessagePage($messageId, $timeout = 0)
		{
			self::localRedirect('message.php?msg_id='.$messageId, $timeout);
		}
		
		public static function redirectToIndex($timeout = 0)
		{
			self::localRedirect('index.php', $timeout);
		}

		public static function removeComment($commentId)
		{
			$database = new Database('nexonlab');
			$database->DeleteConditional('comments', "id = $commentId");
		}

		public static function removePost($postId)
		{
			$database = new Database('nexonlab');
			$database->DeleteConditional('blog_entries', "id = $postId");
		}

		public static function addComment($postId, $commentText)
		{
			$database = new Database('nexonlab');
			$commentText = htmlspecialchars($commentText);
			$authorId = Authorization::getInstance()->getUserId();
			$database->Query("INSERT INTO `comments` (`text`, `post_id`, `author_id`) VALUES ('$commentText', $postId, $authorId);");
		}

		public static function sendMail($recepient, $subject, $message)
		{
			$message = wordwrap($message, 70, "\r\n");
			return mail($recepient, $subject, $message);
		}
	}
?>