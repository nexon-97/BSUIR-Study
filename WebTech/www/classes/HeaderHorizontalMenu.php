<?php

	require_once('HeaderHorizontalMenuItem.php');

	class HeaderHorizontalMenu extends Template
	{
		
		protected $menuItems;
		
		public function __construct()
		{
			parent::__construct('mainHorizontalMenu');
			
			$this->LoadMenuItems();
		}
		
		public function LoadMenuItems()
		{
			$this->menuItems = array();
			$this->menuItems[] = new HeaderHorizontalMenuItem('Blog', 'blog.php');
			$this->menuItems[] = new HeaderHorizontalMenuItem('Projects');
			$this->menuItems[] = new HeaderHorizontalMenuItem('Tutorials');
			$this->menuItems[] = new HeaderHorizontalMenuItem('Guides');
			$this->menuItems[] = new HeaderHorizontalMenuItem('Games');
			$this->menuItems[] = new HeaderHorizontalMenuItem('Contact Me', 'contact.php');
		}
		
		private function GetMenuItemsList()
		{
			$menuItemsList = array();
			foreach ($this->menuItems as $item)
			{
				$menuItemsList[] = $item->getText();
			}
			
			return Template::getStringsInRow($menuItemsList);
		}
		
		protected function handleKeywords()
		{
			$this->replaceKeywordByText('MENU_ITEMS', $this->GetMenuItemsList());
		}
		
	}

?>