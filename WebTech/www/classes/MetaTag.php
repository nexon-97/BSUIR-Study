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
				$this->AddAttributes($attributes);
			}
		}
		
		public function AddAttribute($key, $value)
		{
			$this->attributes->AddAttribute($key, $value);
		}
		
		public function AddAttributes($array)
		{
			$this->attributes->AddAttributes($array);
		}
		
		public function GetAttribute($key)
		{
			return $this->attributes->GetAttribute($key);
		}
		
		public function GetAttributes()
		{
			return $this->attributes;
		}
		
		protected function HandleKeywords()
		{
			$this->ReplaceKeywordByText('ATTRIBUTES', $this->attributes->GetText());
		}
		
	}

?>