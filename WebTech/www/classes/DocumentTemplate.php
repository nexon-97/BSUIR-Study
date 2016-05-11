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
			$this->loadMetaTags();
			$this->loadStylesheets();
			$this->loadScripts();
			$this->loadBody($contentType);
		}
		
		private function loadMetaTags()
		{
			$this->metaTags = array();
			$this->metaTags[] = new MetaTag(array('charset' => 'UTF-8'));
			$this->metaTags[] = new MetaTag(array('http-equiv' => 'X-UA-Compatible', 'content' => 'IE=10'));
		}
		
		private function loadStylesheets()
		{
			$this->stylesheets = array();
			$this->stylesheets[] = new StylesheetTag('styles/mainStyle.css');
			$this->stylesheets[] = new StylesheetTag('styles/highlight_style.css');
		}
		
		private function loadScripts()
		{
			$this->scripts = array();
			$this->scripts[] = new ScriptTag('scripts/jquery-1.12.1.min.js');
			$this->scripts[] = new ScriptTag('scripts/effects.js');
			$this->scripts[] = new ScriptTag('scripts/footer_controller.js');
			$this->scripts[] = new ScriptTag('scripts/highlight.js');
		}
		
		private function loadBody($contentType)
		{
			$this->body = new DocumentBody($contentType);
		}
		
		private function getMetaTagsStr()
		{
			$tagsArray = array();
			foreach ($this->metaTags as $tag)
			{
				$tagsArray[] = $tag->getText();
			}
			
			return Template::getStringsInRow($tagsArray);
		}
		
		private function getStylesheetsStr()
		{
			$stylesheetsArray = array();
			foreach ($this->stylesheets as $stylesheet)
			{
				$stylesheetsArray[] = $stylesheet->getText();
			}
			
			return Template::getStringsInRow($stylesheetsArray);
		}
		
		private function getScriptsList()
		{
			$scriptsList = array();
			foreach ($this->scripts as $script)
			{
				$scriptsList[] = $script->getText();
			}
			
			return Template::getStringsInRow($scriptsList);
		}
		
		protected function handleKeywords()
		{
			$this->replaceKeywordByText('DOCTYPE', '<!DOCTYPE html>');
			$this->replaceKeywordByText('LANG', 'lang="en-US"');
			$this->replaceKeywordByText('PAGE_TITLE', '<title>'.$this->pageTitle.'</title>');
			$this->replaceKeywordByText('META_TAGS', $this->getMetaTagsStr());
			$this->replaceKeywordByText('STYLESHEETS', $this->getStylesheetsStr());
			$this->replaceKeywordByText('JAVASCRIPT_FILES', $this->getScriptsList());
			$this->replaceKeywordByText('CONTENT', $this->body->getText());
		}
		
	}

?>