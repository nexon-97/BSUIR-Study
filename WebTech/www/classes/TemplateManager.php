<?php

	require_once('SiteInfo.php');

	abstract class TemplateManager
	{
		public static $templateFolder = 'templates/';
		public static $templateExtension = '.tpl';
		
		public static function GetDocumentTemplate($templateId)
		{
			switch ($templateId)
			{
				case 'blog':
					return file_get_contents('templates/blog.tpl');
				case 'name':
				default:
					return file_get_contents('templates/document.tpl');
			}
		}
		
		public static function GetFullPath($path)
		{
			return SiteInfo::$siteDomain.TemplateManager::$templateFolder.$path.TemplateManager::$templateExtension;
		}
	}

?>