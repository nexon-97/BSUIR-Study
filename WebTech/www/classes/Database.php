<?php

	class Database
	{
		protected $MySQLDatabase;
		
		public function __construct($databaseName)
		{
			$this->MySQLDatabase = new mysqli('www.nexonlab.by', 'root', '2246baklan', $databaseName);
			
			// Enable UTF-8 encoding
			$this->MySQLDatabase->query("SET NAMES 'utf8';");
			$this->MySQLDatabase->query("SET CHARACTER SET 'utf8';");
			$this->MySQLDatabase->query("SET SESSION collation_connection = 'utf8_general_ci';");
		}
		
		public function __destruct()
		{
			$this->MySQLDatabase->close();
		}
		
		public function Query($query)
		{
			return $this->MySQLDatabase->query($query);
		}
		
		public function ParseSelectResult($result)
		{
			$parsedArray = array();
			if ($result !== false)
			{
				if ($result->num_rows > 0) {
					while ($item = $result->fetch_assoc())
					{
						$parsedArray[] = $item;
					}
				}
			}
			
			return $parsedArray;
		}
		
		public function SelectAll($table)
		{
			$queryResult = $this->Query("SELECT * FROM `$table`");
			return $this->ParseSelectResult($queryResult);
		}
		
		public function Select($table, $field)
		{
			$queryResult = $this->Query("SELECT $field FROM `$table`");
			return $this->ParseSelectResult($queryResult);
		}
		
		public function SelectLimited($table, $field, $limit)
		{
			$queryResult = $this->Query("SELECT $field FROM `$table` LIMIT $limit");
			return $this->ParseSelectResult($queryResult);
		}
		
		public function SelectConditional($table, $field, $condition)
		{
			$queryResult = $this->Query("SELECT $field FROM `$table` WHERE $condition");
			return $this->ParseSelectResult($queryResult);
		}
		
		public function SelectConditionalLimited($table, $field, $condition, $limit)
		{
			$queryResult = $this->Query("SELECT $field FROM `$table` WHERE $condition LIMIT $limit");
			return $this->ParseSelectResult($queryResult);
		}
	}

?>