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
			$database = new Database();
			$database->DeleteConditional('comments', "id = $commentId");
		}

		public static function removePost($postId)
		{
			$database = new Database();
			$database->DeleteConditional('blog_entries', "id = $postId");
		}
		
		public static function addPost($category, $title, $shortText, $text)
		{
			$database = new Database();
			
			$image = 'img/noimage.jpg';
			$auth = Authorization::getInstance();
			$author = $auth->getUserId();
			
			$database->Query("INSERT INTO blog_entries (`category`, `image`, `author`, `title`, `desc`, `short_desc`)
							VALUES ($category, '$image', $author, '$title', '$text', '$shortText');");
		}
		
		public static function updatePost($id, $category, $title, $shortDesc, $fullText)
		{
			$database = new Database();
			$database->Query("UPDATE blog_entries
							SET `category` = $category, `title` = '$title', `desc` = '$fullText', `short_desc` = 'shortDesc'
							WHERE id = $id");
		}
		
		public static function updateUser($id, $name, $surname, $vk, $twitter, $linkedin, $oldPass, $newPass, $newPassRepeat)
		{
			$database = new Database();
			
			$database->Query("UPDATE `user_profiles`
							SET `name` = '$name', `surname` = '$surname'
							WHERE id = $id");
							
			$database->Query("UPDATE `user_social_links`
							SET `vk` = '$vk', `twitter` = '$twitter', `linkedin` = '$linkedin'
							WHERE user_id = $id");
					
			if (strlen($oldPass) != 0 or strlen($newPass) != 0 or strlen($newPassRepeat) != 0)
			{
				$auth = Authorization::getInstance();
				if ($auth->isValidPassword($oldPass) and $auth->isValidPassword($newPass) and $auth->isValidPassword($newPassRepeat))
				{
					$oldPassDb = '';
					
					$oldPassResult = $database->SelectConditional('user_profiles', 'password', "id = $id");
					print_r($oldPassResult);
					if (count($oldPassResult) > 0)
					{
						$oldPassDb = $oldPassResult[0]['password'];
					}
					
					// Compare new passwords
					if ($oldPassDb == md5($oldPass) and $newPass == $newPassRepeat)
					{
						$database->Query("UPDATE `user_profiles` SET `password` = MD5('$newPass') WHERE `id` = $id");
						
						self::redirectToMessagePage(11);
					}
				}
				
				self::redirectToMessagePage(10);
			}
		}

		public static function addComment($postId, $commentText)
		{
			$database = new Database();
			$commentText = htmlspecialchars($commentText);
			$authorId = Authorization::getInstance()->getUserId();
			$database->Query("INSERT INTO `comments` (`text`, `post_id`, `author_id`) VALUES ('$commentText', $postId, $authorId);");
		}
		
		public static function addCategory($categoryName)
		{
			$database = new Database();
			$commentText = htmlspecialchars($commentText);
			$authorId = Authorization::getInstance()->getUserId();
			$database->Query("INSERT INTO `blogcategories` (`name`) VALUES ('$categoryName');");
		}
		
		public static function sendMail($recepient, $subject, $message, $headers = '')
		{
			return mail($recepient, $subject, $message, $headers);
		}
	}
?>