<?php

	require_once('TemplateManager.php');

	abstract class Template
	{
		
		protected $path;
		protected $templateText;
		protected $plainText;
		
		public function __construct($path)
		{
			$this->path = TemplateManager::GetFullPath($path);
		}
		
		public function LoadFromFile()
		{			
			$this->templateText = file_get_contents($this->path);
			$this->plainText = $this->templateText;
		}
		
		public function GetTemplateText()
		{
			return $this->templateText;
		}
		
		public function GetText()
		{
			$this->Rebuild();
			return $this->plainText;
		}
		
		public function Rebuild()
		{
			$this->LoadFromFile($this->path);
			$this->HandleKeywords();
		}
		
		public function ReplaceKeywordByText($key, $text)
		{
			$this->plainText = str_replace('$'.$key.'$', $text, $this->plainText);
		}
		
		public function ReplaceKeywordByStaticContent($key, $contentPath)
		{
			$this->plainText = str_replace('$'.$key.'$', file_get_contents(SiteInfo::$siteDomain.$contentPath), $this->plainText);
		}
		
		public function RemoveKeyword($key)
		{
			$this->plainText = str_replace('$'.$key.'$', '', $this->plainText);
		}
		
		// Override this method to process particular keyword in each child class
		protected function HandleKeywords() { }
		
		public static function GetStringsInRow($stringArray)
		{
			$outString = '';
			foreach ($stringArray as $item)
			{
				$outString .= $item."\n";
			}
			
			return trim($outString);
		}
		
	}

?>