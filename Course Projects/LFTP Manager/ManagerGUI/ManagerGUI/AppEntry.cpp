#include <wx/wxprec.h>
#include <wx/wx.h>

#include <wx/msw/wx.rc>

class MyApp : public wxApp
{
	virtual bool OnInit();
};

bool MyApp::OnInit()
{
	MyFrame *frame = new MyFrame("Hello World", wxPoint(50, 50), wxSize(450, 340));
	frame->Show(true);
	SetTopWindow(frame);
	return true;
}
