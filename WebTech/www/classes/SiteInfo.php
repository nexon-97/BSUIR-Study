<?php

	abstract class SiteInfo
	{
		public static $siteDomain = 'http://www.nexonlab.by/';
		
		public static function getPostTitlePath($postId)
		{
			return SiteInfo::$siteDomain . 'posts/post_' . $postId . '_title.txt';
		}
		
		public static function getPostShortTextPath($postId)
		{
			return SiteInfo::$siteDomain . 'posts/post_' . $postId . '_text_short.txt';
		}
		
		public static function getPostFullTextPath($postId)
		{
			return SiteInfo::$siteDomain . 'posts/post_' . $postId . '_text_full.txt';
		}
		
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