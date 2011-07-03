// Gamepe.cpp : Defines the class behaviors for the application.
//

#include "stdafx.h"
#include "Gamepe.h"
#include "GamepeDlg.h"
#
#include<windows.h>
#include "SHA1.h"
#include "MsgQue.h"
#include "XfireCore.h"

#include <imaging.h> 
#ifdef _DEBUG
#define new DEBUG_NEW
#endif

#pragma comment(lib,"htmlview.lib")
// CGamepeApp

BEGIN_MESSAGE_MAP(CGamepeApp, CWinApp)
END_MESSAGE_MAP()


// CGamepeApp construction
CGamepeApp::CGamepeApp()
	: CWinApp()
{
	// TODO: add construction code here,
	// Place all significant initialization in InitInstance
}


// The one and only CGamepeApp object
CGamepeApp theApp;

// CGamepeApp initialization
HANDLE g_GamepeMutex;

BOOL CGamepeApp::InitInstance()
{
    // SHInitExtraControls should be called once during your application's initialization to initialize any
    // of the Windows Mobile specific controls such as CAPEDIT and SIPPREF.
    SHInitExtraControls();

	if (!AfxSocketInit())
	{
		AfxMessageBox(IDP_SOCKETS_INIT_FAILED);
		return FALSE;
	}
    
	
	CoInitializeEx(NULL, 0);

	g_GamepeMutex= CreateMutex(NULL,TRUE,L"GAMEPE"); 


	if(GetLastError()==ERROR_ALREADY_EXISTS) 
	{

		    AfxMessageBox(L"Gamepe mobile already running");
            HWND hXfireWnd=FindWindow(NULL,L"Xfire");
			
			ShowWindow(hXfireWnd,SW_SHOW);
			CloseHandle(g_GamepeMutex); 
			return FALSE;
	}
	

	 WCHAR version[0x100]={0};
	 if (GetXFMobileVersion(version,sizeof(version))){


		 if (wcscmp(version,L"1.1")!=0) {
		 
			 AfxMessageBox(L"A new version of XfMobile is now avaliable @ www.xf-mobile.com");

			 SHELLEXECUTEINFO ShExecInfo;

			 ShExecInfo.cbSize = sizeof(SHELLEXECUTEINFO);
			 ShExecInfo.fMask = NULL;
			 ShExecInfo.hwnd = NULL;
			 ShExecInfo.lpVerb = NULL;
			 ShExecInfo.lpFile = L"iexplore.exe" ;
			 ShExecInfo.lpParameters = L"www.xf-mobile.com";
			 ShExecInfo.lpDirectory = NULL;
			 ShExecInfo.nShow = SW_SHOWMAXIMIZED;
			 ShExecInfo.hInstApp = NULL;

			 ShellExecuteEx(&ShExecInfo);
			 return FALSE;
		 }
	 }

	
	 


	 GetUserAgent();

	 if (!::CreateDirectory(L"\\My Documents\\XFMOBILE",NULL)){

		    AfxMessageBox(L"Failed to create the \\My Documents\\XFMOBILE folder");
	 }


	 HRESULT hr = CoCreateInstance(CLSID_ImagingFactory, NULL,
		 CLSCTX_INPROC_SERVER,__uuidof(IImagingFactory),(LPVOID *)&g_pImageFactory);

	 if (hr!=S_OK)  {

		 DbgMsg(L"CoCreateInstance:CLSID_ImagingFactory error");
		 return FALSE;

	 }


	InitHTMLControl(AfxGetInstanceHandle());

	// Standard initialization
	// If you are not using these features and wish to reduce the size
	// of your final executable, you should remove from the following
	// the specific initialization routines you do not need
	// Change the registry key under which our settings are stored
	// TODO: You should modify this string to be something appropriate
	// such as the name of your company or organization
	//SetRegistryKey(_T("Local AppWizard-Generated Applications"));


	
	CGamepeDlg dlg;
	m_pMainWnd = &dlg;
	
	INT_PTR nResponse = dlg.DoModal();
	if (nResponse == IDOK)
	{
		// TODO: Place code here to handle when the dialog is
		//  dismissed with OK

		CloseHandle(g_GamepeMutex);
	}

	// Since the dialog has been closed, return FALSE so that we exit the
	//  application, rather than start the application's message pump.
	return FALSE;
}

