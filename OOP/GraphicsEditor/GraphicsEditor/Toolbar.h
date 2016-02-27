#pragma once
#include "stdafx.h"
#include "Factory.h"
#include <vector>

namespace nexon
{
	struct PAINT_TOOL
	{
		WORD ToolID;
		Factory* CreativeFactory;
	};

	class Toolbar
	{
	public:
		Toolbar();
		Toolbar(HMENU attachedMenu);
		~Toolbar();

		void AttachMenu(HMENU attachedMenu);

		void RegisterTool(WORD ToolID, Factory* CreativeFactory);
		void SelectTool(WORD ToolID);
		void UnselectAll();

		bool IsRegisteredTool(WORD ToolID);
		Factory* GetToolFactory(WORD ToolID);
		Factory* GetActiveFactory();

	private:
		const WORD NO_TOOL = -1;
		WORD GetToolIndex(WORD ToolID);

		HMENU AttachedMenu;
		std::vector<PAINT_TOOL> Tools;
		WORD ActiveTool;
	};
}
