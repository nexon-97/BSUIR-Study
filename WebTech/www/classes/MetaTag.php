<?php

	require_once('Template.php');
	require_once('AttributesList.php');

	class MetaTag extends Template
	{
		
		protected $attributes;
		
		public function __construct($attributes)
		{
			parent::__construct('meta_tag');
			
			$this->attributes = new AttributesList();
			if (is_array($attributes))
			{
				$this->addAttributes($attributes);
			}
		}
		
		public function addAttribute($key, $value)
		{
			$this->attributes->addAttribute($key, $value);
		}
		
		public function addAttributes($array)
		{
			$this->attributes->addAttributes($array);
		}
		
		public function getAttribute($key)
		{
			return $this->attributes->getAttribute($key);
		}
		
		public function getAttributes()
		{
			return $this->attributes;
		}
		
		protected function handleKeywords()
		{
			$this->replaceKeywordByText('ATTRIBUTES', $this->attributes->getText());
		}
		
	}

?>