<?php
	require_once('SiteInfo.php');

	class Utils
	{
		public static function redirect($location)
		{
			header("Location: $location");
			exit;
		}
		
		public static function localRedirect($location)
		{
			self::redirect(SiteInfo::$siteDomain.$location);
		}
		
		public static function readDataFile($file)
		{
			$path = SiteInfo::$siteDomain.'data/'.$file;
			return @file_get_contents($path);
		}
		
		public static function redirectToErrorPage($errorId)
		{
			self::localRedirect('error.php?errcode='.$errorId);
		}
	}
?>