<?php

	class AttributesList
	{
	
		protected $attributes;
		
		public function __construct()
		{
			$this->attributes = array();
		}
		
		public function addAttribute($key, $value)
		{
			$this->attributes[$key] = $value;
		}
		
		public function addAttributes($array)
		{
			if (is_array($array))
			{
				foreach ($array as $key => $value)
				{
					$this->addAttribute($key, $value);
				}
			}
		}
		
		public function getAttribute($key)
		{
			return $this->attributes[$key];
		}
		
		public function getText()
		{
			$outString = '';
			foreach ($this->attributes as $key => $value)
			{
				$outString .= (" $key=\"$value\"");
			}
			
			return $outString;
		}
	
	}

?>