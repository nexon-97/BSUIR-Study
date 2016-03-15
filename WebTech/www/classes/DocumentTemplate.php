<?php

	require_once('MetaTag.php');
	require_once('StylesheetTag.php');
	require_once('ScriptTag.php');
	require_once('DocumentBody.php');

	class DocumentTemplate extends Template
	{
		
		protected $metaTags;
		public $pageTitle;
		protected $stylesheets;
		protected $scripts;
		protected $body;
		
		public function __construct($contentType = 'index')
		{
			parent::__construct('document');
			
			$this->pageTitle = 'Page title';
			$this->LoadMetaTags();
			$this->LoadStylesheets();
			$this->LoadScripts();
			$this->LoadBody($contentType);
		}
		
		private function LoadMetaTags()
		{
			$this->metaTags = array();
			$this->metaTags[] = new MetaTag(array('charset' => 'UTF-8'));
			$this->metaTags[] = new MetaTag(array('http-equiv' => 'X-UA-Compatible', 'content' => 'IE=10'));
		}
		
		private function LoadStylesheets()
		{
			$this->stylesheets = array();
			$this->stylesheets[] = new StylesheetTag('styles/mainStyle.css');
		}
		
		private function LoadScripts()
		{
			$this->scripts = array();
			$this->scripts[] = new ScriptTag('scripts/jquery-1.12.1.min.js');
			$this->scripts[] = new ScriptTag('scripts/effects.js');
			$this->scripts[] = new ScriptTag('scripts/footer_controller.js');
		}
		
		private function LoadBody($contentType)
		{
			$this->body = new DocumentBody($contentType);
		}
		
		private function GetMetaTagsStr()
		{
			$tagsArray = array();
			foreach ($this->metaTags as $tag)
			{
				$tagsArray[] = $tag->GetText();
			}
			
			return Template::GetStringsInRow($tagsArray);
		}
		
		private function GetStylesheetsStr()
		{
			$stylesheetsArray = array();
			foreach ($this->stylesheets as $stylesheet)
			{
				$stylesheetsArray[] = $stylesheet->GetText();
			}
			
			return Template::GetStringsInRow($stylesheetsArray);
		}
		
		private function GetScriptsList()
		{
			$scriptsList = array();
			foreach ($this->scripts as $script)
			{
				$scriptsList[] = $script->GetText();
			}
			
			return Template::GetStringsInRow($scriptsList);
		}
		
		protected function HandleKeywords()
		{
			$this->ReplaceKeywordByText('DOCTYPE', '<!DOCTYPE html>');
			$this->ReplaceKeywordByText('LANG', 'lang="en-US"');
			$this->ReplaceKeywordByText('PAGE_TITLE', '<title>'.$this->pageTitle.'</title>');
			$this->ReplaceKeywordByText('META_TAGS', $this->GetMetaTagsStr());
			$this->ReplaceKeywordByText('STYLESHEETS', $this->GetStylesheetsStr());
			$this->ReplaceKeywordByText('JAVASCRIPT_FILES', $this->GetScriptsList());
			$this->ReplaceKeywordByText('CONTENT', $this->body->GetText());
		}
		
	}

?>