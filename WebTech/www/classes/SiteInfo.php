<?php

	abstract class SiteInfo
	{
		public static $siteDomain = 'http://nexonlab.hol.es/';
		
		public static function getAuthorLink($authorId)
		{
			return 'user.php?id=' . $authorId;
		}
		
		public static function getCategoryLinkById($categoryId)
		{
			return 'category.php?id=' . $categoryId;
		}
		
		public static function getCategoryLinkByTitle($categoryTitle)
		{
			return 'category.php?title=' . $categoryTitle;
		}
		
		public static function getIndexPath($categoryTitle)
		{
			return SiteInfo::$siteDomain . 'index.php';
		}
	}

?>