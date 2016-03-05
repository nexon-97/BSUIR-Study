#include "stdafx.h"
#include "GraphicsEditor.h"

#include "ShapeCollection.h"
#include "ShapesList.h"
#include "Toolbar.h"
#include "FactoriesList.h"

#define MAX_LOADSTRING 100

// Global Variables:
HINSTANCE hInst;                                // current instance
WCHAR szTitle[MAX_LOADSTRING];                  // The title bar text
WCHAR szWindowClass[MAX_LOADSTRING];            // the main window class name
HWND MainWindow;

nexon::Toolbar* ToolsList;
nexon::ShapeCollection* ShapesList;
HDC DeviceContext;

// Forward declarations of functions included in this code module:
ATOM                MyRegisterClass(HINSTANCE hInstance);
BOOL                InitInstance(HINSTANCE, int);
LRESULT CALLBACK    WndProc(HWND, UINT, WPARAM, LPARAM);
INT_PTR CALLBACK    About(HWND, UINT, WPARAM, LPARAM);
VOID				InitShapeList();
VOID				InitToolbar();

int APIENTRY wWinMain(_In_ HINSTANCE hInstance,
                     _In_opt_ HINSTANCE hPrevInstance,
                     _In_ LPWSTR    lpCmdLine,
                     _In_ int       nCmdShow)
{
    UNREFERENCED_PARAMETER(hPrevInstance);
    UNREFERENCED_PARAMETER(lpCmdLine);

    // Initialize global strings
    LoadStringW(hInstance, IDS_APP_TITLE, szTitle, MAX_LOADSTRING);
    LoadStringW(hInstance, IDC_GRAPHICSEDITOR, szWindowClass, MAX_LOADSTRING);
    MyRegisterClass(hInstance);

    // Perform application initialization:
    if (!InitInstance (hInstance, nCmdShow))
    {
        return FALSE;
    }

    HACCEL hAccelTable = LoadAccelerators(hInstance, MAKEINTRESOURCE(IDC_GRAPHICSEDITOR));

    MSG msg;

	InitShapeList();
	InitToolbar();
	InvalidateRect(MainWindow, NULL, TRUE);

    // Main message loop:
    while (GetMessage(&msg, nullptr, 0, 0))
    {
        if (!TranslateAccelerator(msg.hwnd, hAccelTable, &msg))
        {
            TranslateMessage(&msg);
            DispatchMessage(&msg);
        }
    }

	delete ShapesList;
	delete ToolsList;

    return (int) msg.wParam;
}



WORD MyRegisterClass(HINSTANCE hInstance)
{
    WNDCLASSEXW wcex;

    wcex.cbSize = sizeof(WNDCLASSEX);

    wcex.style          = CS_HREDRAW | CS_VREDRAW;
    wcex.lpfnWndProc    = WndProc;
    wcex.cbClsExtra     = 0;
    wcex.cbWndExtra     = 0;
    wcex.hInstance      = hInstance;
    wcex.hIcon          = LoadIcon(hInstance, MAKEINTRESOURCE(IDI_GRAPHICSEDITOR));
    wcex.hCursor        = LoadCursor(nullptr, IDC_ARROW);
    wcex.hbrBackground  = (HBRUSH)(COLOR_WINDOW+1);
    wcex.lpszMenuName   = MAKEINTRESOURCEW(IDC_GRAPHICSEDITOR);
    wcex.lpszClassName  = szWindowClass;
    wcex.hIconSm        = LoadIcon(wcex.hInstance, MAKEINTRESOURCE(IDI_SMALL));

    return RegisterClassExW(&wcex);
}

BOOL InitInstance(HINSTANCE hInstance, int nCmdShow)
{
   hInst = hInstance;

   MainWindow = CreateWindow(
		szWindowClass, szTitle, WS_OVERLAPPEDWINDOW,
		CW_USEDEFAULT, 0, CW_USEDEFAULT, 0, nullptr, nullptr, hInstance, nullptr);

   if (!MainWindow)
   {
      return FALSE;
   }

   ShowWindow(MainWindow, nCmdShow);
   UpdateWindow(MainWindow);

   return TRUE;
}

VOID InitToolbar()
{
	ToolsList = new nexon::Toolbar(GetMenu(MainWindow));

	ToolsList->RegisterTool(IDM_CIRCLE, new nexon::CircleFactory(MainWindow, ShapesList));
	ToolsList->RegisterTool(IDM_LINE, new nexon::LineFactory(MainWindow, ShapesList));
	ToolsList->RegisterTool(IDM_ELLIPSE, new nexon::EllipseFactory(MainWindow, ShapesList));
	ToolsList->RegisterTool(IDM_RECTANGLE, new nexon::RectangleFactory(MainWindow, ShapesList));
	ToolsList->RegisterTool(IDM_SQUARE, new nexon::SquareFactory(MainWindow, ShapesList));
	ToolsList->RegisterTool(IDM_POLYGON, new nexon::PolygonFactory(MainWindow, ShapesList));
	ToolsList->RegisterTool(IDM_TRIANGLE, new nexon::TriangleFactory(MainWindow, ShapesList));

	ToolsList->SelectTool(IDM_LINE);
}

VOID InitShapeList()
{
	ShapesList = new nexon::ShapeCollection();

	POINT Begin = { 50, 50 }, End = { 150, 250 };
	nexon::Line* RedLine = new nexon::Line(Begin, End);
	RedLine->SetLineColor(RGB(255, 0, 0));
	ShapesList->Add(RedLine);

	POINT CircleCenter = {300, 300};
	nexon::Circle* BlueCircle = new nexon::Circle(CircleCenter, 100);
	BlueCircle->SetLineColor(RGB(0, 0, 255));
	BlueCircle->SetPenWidth(5);
	ShapesList->Add(BlueCircle);

	POINT EllipseCenter = {600, 200};
	nexon::Ellipse* BlackEllipse = new nexon::Ellipse({ 450, 150 }, { 750, 250 });
	ShapesList->Add(BlackEllipse);

	nexon::Rectangle* BlueRect = new nexon::Rectangle(120, 20, 200, 80);
	BlueRect->SetLineColor(RGB(0, 128, 255));
	BlueRect->SetPenWidth(7);
	ShapesList->Add(BlueRect);

	nexon::Square* GreenSquare = new nexon::Square({ 50, 300 }, 100);
	GreenSquare->SetLineColor(RGB(0, 128, 0));
	ShapesList->Add(GreenSquare);

	nexon::Polygon* StarPolygon = new nexon::Polygon();
	StarPolygon->SetLineColor(RGB(255, 106, 0));
	std::vector<POINT> StarPoints;
	StarPoints.push_back({ 500, 400 });
	StarPoints.push_back({ 550, 400 });
	StarPoints.push_back({ 550, 350 });
	StarPoints.push_back({ 600, 350 });
	StarPoints.push_back({ 600, 400 });
	StarPoints.push_back({ 650, 400 });
	StarPoints.push_back({ 650, 450 });
	StarPoints.push_back({ 600, 450 });
	StarPoints.push_back({ 600, 500 });
	StarPoints.push_back({ 550, 500 });
	StarPoints.push_back({ 550, 450 });
	StarPoints.push_back({ 500, 450 });
	StarPolygon->SetPoints(StarPoints);
	ShapesList->Add(StarPolygon);

	nexon::Triangle* PurpleTriangle = new nexon::Triangle({800, 300}, {1050, 400}, {950, 250});
	PurpleTriangle->SetLineColor(RGB(178, 0, 255));
	ShapesList->Add(PurpleTriangle);
}

VOID DrawWindow(HDC& hdc)
{
	if (ShapesList)
	{
		for (UINT i = 0; i < ShapesList->Size(); i++)
		{
			ShapesList->At(i)->Draw(hdc);
		}
	}
}

LRESULT CALLBACK WndProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
{
	nexon::Factory* ActiveFactory;

    switch (message)
    {
		case WM_COMMAND:
			{
				int wmId = LOWORD(wParam);
				
				if (ToolsList->IsRegisteredTool(wmId))
				{
					ToolsList->SelectTool(wmId);
				}
				else
				{
					switch (wmId)
					{
					case IDM_ABOUT:
						DialogBox(hInst, MAKEINTRESOURCE(IDD_ABOUTBOX), hWnd, About);
						break;
					case IDM_EXIT:
						DestroyWindow(hWnd);
						break;
					case IDM_CLEAR:
						ShapesList->Clear();
						InvalidateRect(MainWindow, NULL, TRUE);
						break;
					case IDM_UNDO:
						ShapesList->Pop();
						InvalidateRect(MainWindow, NULL, TRUE);
						break;
					default:
						return DefWindowProc(hWnd, message, wParam, lParam);
					}
				}
			}
			break;
		case WM_PAINT:
			{
				PAINTSTRUCT ps;
				HDC hdc = BeginPaint(hWnd, &ps);
				DrawWindow(hdc);
				EndPaint(hWnd, &ps);
			}
			break;
		case WM_LBUTTONDOWN:
			ActiveFactory = ToolsList->GetActiveFactory();
			if (ActiveFactory)
			{
				ActiveFactory->ProcessMousePress(LOWORD(lParam), HIWORD(lParam));
			}
			break;
		case WM_LBUTTONUP:
			ActiveFactory = ToolsList->GetActiveFactory();
			if (ActiveFactory)
			{
				ActiveFactory->ProcessMouseRelease(LOWORD(lParam), HIWORD(lParam));
			}
			break;
		case WM_MOUSEMOVE:
			ActiveFactory = ToolsList->GetActiveFactory();
			if (ActiveFactory)
			{
				ActiveFactory->ProcessMouseMove(LOWORD(lParam), HIWORD(lParam));
			}
			break;
		case WM_RBUTTONDOWN:
			ActiveFactory = ToolsList->GetActiveFactory();
			if (ActiveFactory)
			{
				ActiveFactory->ProcessMouseDoubleClick(LOWORD(lParam), HIWORD(lParam));
			}
			break;
		case WM_DESTROY:
			PostQuitMessage(0);
			break;
		default:
			return DefWindowProc(hWnd, message, wParam, lParam);
    }

    return 0;
}

INT CALLBACK About(HWND hDlg, UINT message, WPARAM wParam, LPARAM lParam)
{
    UNREFERENCED_PARAMETER(lParam);

    switch (message)
    {
		case WM_INITDIALOG:
			return TRUE;
		case WM_COMMAND:
			if (LOWORD(wParam) == IDOK || LOWORD(wParam) == IDCANCEL)
			{
				EndDialog(hDlg, LOWORD(wParam));
				return TRUE;
			}
			break;
    }

    return FALSE;
}
