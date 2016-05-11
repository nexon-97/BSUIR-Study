<?php
	require_once('SiteInfo.php');

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
		
		public static function redirectToIndex($timeout = 0)
		{
			self::localRedirect('index.php', $timeout);
		}
	}
?>