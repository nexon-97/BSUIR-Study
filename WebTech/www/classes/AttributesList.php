<?php

	class AttributesList
	{
	
		protected $attributes;
		
		public function __construct()
		{
			$this->attributes = array();
		}
		
		public function AddAttribute($key, $value)
		{
			$this->attributes[$key] = $value;
		}
		
		public function AddAttributes($array)
		{
			if (is_array($array))
			{
				foreach ($array as $key => $value)
				{
					$this->AddAttribute($key, $value);
				}
			}
		}
		
		public function GetAttribute($key)
		{
			return $this->attributes[$key];
		}
		
		public function GetText()
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