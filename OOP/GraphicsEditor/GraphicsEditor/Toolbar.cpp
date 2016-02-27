#include "stdafx.h"
#include "Toolbar.h"

using namespace nexon;

Toolbar::Toolbar()
{
	ActiveTool = NO_TOOL;
}

Toolbar::Toolbar(HMENU attachedMenu)
{
	AttachMenu(attachedMenu);
}

Toolbar::~Toolbar()
{

}

void Toolbar::AttachMenu(HMENU attachedMenu)
{
	AttachedMenu = attachedMenu;
}

void Toolbar::RegisterTool(WORD ToolID, Factory* CreativeFactory)
{
	if (GetToolIndex(ToolID) == NO_TOOL)
	{
		Tools.push_back({ ToolID, CreativeFactory });
	}
}

void Toolbar::SelectTool(WORD ToolID)
{
	UnselectAll();

	ActiveTool = GetToolIndex(ToolID);
	if (ActiveTool != NO_TOOL)
	{
		CheckMenuItem(AttachedMenu, Tools[ActiveTool].ToolID, MF_CHECKED);
	}
}

void Toolbar::UnselectAll()
{
	ActiveTool = NO_TOOL;

	for (WORD i = 0; i < Tools.size(); i++)
	{
		CheckMenuItem(AttachedMenu, Tools[i].ToolID, MF_UNCHECKED);
	}
}

bool Toolbar::IsRegisteredTool(WORD ToolID)
{
	return (GetToolIndex(ToolID) != NO_TOOL);
}

WORD Toolbar::GetToolIndex(WORD ToolID)
{
	for (UINT i = 0; i < Tools.size(); i++)
	{
		if (Tools[i].ToolID == ToolID)
		{
			return i;
		}
	}

	return NO_TOOL;
}

Factory* Toolbar::GetToolFactory(WORD ToolID)
{
	for (WORD i = 0; i < Tools.size(); i++)
	{
		if (Tools[i].ToolID == ToolID)
		{
			return Tools[i].CreativeFactory;
		}
	}

	return NULL;
}

Factory* Toolbar::GetActiveFactory()
{
	return (ActiveTool != NO_TOOL) ? Tools[ActiveTool].CreativeFactory : NULL;
}
