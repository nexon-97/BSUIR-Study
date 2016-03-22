<?php

	require_once('TemplateManager.php');

	abstract class Template
	{
		
		protected $path;
		protected $templateText;
		protected $plainText;
		
		public function __construct($path)
		{
			$this->path = TemplateManager::getFullPath($path);
		}
		
		public function loadFromFile()
		{			
			$this->templateText = file_get_contents($this->path);
			$this->plainText = $this->templateText;
		}
		
		public function getTemplateText()
		{
			return $this->templateText;
		}
		
		public function getText()
		{
			$this->rebuild();
			return $this->plainText;
		}
		
		public function rebuild()
		{
			$this->loadFromFile($this->path);
			$this->handleKeywords();
		}
		
		public function replaceKeywordByText($key, $text)
		{
			$this->plainText = str_replace('$'.$key.'$', $text, $this->plainText);
		}
		
		public function replaceKeywordByStaticContent($key, $contentPath)
		{
			$this->plainText = str_replace('$'.$key.'$', file_get_contents(SiteInfo::$siteDomain.$contentPath), $this->plainText);
		}
		
		public function removeKeyword($key)
		{
			$this->plainText = str_replace('$'.$key.'$', '', $this->plainText);
		}
		
		// Override this method to process particular keyword in each child class
		protected function handleKeywords() { }
		
		public static function getStringsInRow($stringArray)
		{
			$outString = '';
			foreach ($stringArray as $item)
			{
				$outString .= $item."\n";
			}
			
			return trim($outString);
		}
		
		protected function loadContentFile($path, $defaultText = '')
		{
			$content = @file_get_contents($path);
			return ($content === FALSE) ? $defaultText : $content;
		}
		
	}

?>