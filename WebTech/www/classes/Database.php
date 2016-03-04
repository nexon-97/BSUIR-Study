<?php

	class Database
	{
		protected $MySQLDatabase;
		
		public function __construct($databaseName)
		{
			$this->MySQLDatabase = new mysqli('www.nexonlab.by', 'root', '2246baklan', $databaseName);
		}
		
		public function Query($query)
		{
			return $this->MySQLDatabase->query($query);
		}
		
		public function Select($table, $field = '*')
		{
			$result = $this->Query("SELECT * FROM `$table` LIMIT 0,1");
			return $result->fetch_assoc();
		}
	}

?>