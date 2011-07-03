// LoginPage.cpp : implementation file
//

#include "stdafx.h"
#include "Gamepe.h"
#include "LoginPage.h"
#include "SHA1.h"
#include "MsgQue.h"
#include "ClientT.h"
#include "Global.h"
#include "XfireCore.h"
#include <stdio.h>
#include <stdlib.h>
#include <Winreg.h>


BOOL  LoadUserData()
{


	HKEY  hKey;
	DWORD dwDisposition;

	if (RegOpenKeyEx(HKEY_CURRENT_USER,L"Gamepe",0,0,&hKey)!=ERROR_SUCCESS){


		if (RegCreateKeyEx(HKEY_CURRENT_USER,L"Gamepe",0,0,0,0,0,&hKey,&dwDisposition)!=ERROR_SUCCESS){


			DbgMsg(L"Critical Error unable to open the reg");
			return FALSE;
		}

	}

	DWORD dwType=REG_SZ;
	DWORD cbData=0x100;
	RegQueryValueEx(hKey,L"username",0,&dwType,
		(LPBYTE)CXfireCore::s_cUserName,&cbData);

    
	cbData=0x100;
	RegQueryValueEx(hKey,L"password",0,&dwType,
		(LPBYTE)CXfireCore::s_cPassword,&cbData);


	RegCloseKey (hKey);

	return TRUE;


}
void  SaveUserData()
{


	HKEY  hKey;
	DWORD dwDisposition;

	if (RegOpenKeyEx(HKEY_CURRENT_USER,L"Gamepe",0,0,&hKey)!=ERROR_SUCCESS){


		if (RegCreateKeyEx(HKEY_CURRENT_USER,L"Gamepe",0,0,0,0,0,&hKey,&dwDisposition)!=ERROR_SUCCESS){


			DbgMsg(L"Critical Error unable to open the reg");
			return;
		}

	}


	RegSetValueEx(hKey,L"username",0,REG_SZ,
		(const BYTE *)CXfireCore::s_cUserName,strlen(CXfireCore::s_cUserName));


	RegSetValueEx(hKey,L"password",0,REG_SZ,
		(const BYTE *)CXfireCore::s_cPassword,strlen(CXfireCore::s_cPassword));

	
	RegCloseKey (hKey);


}
// CLoginPage dialog

IMPLEMENT_DYNAMIC(CLoginPage, CPropertyPage)

CLoginPage::CLoginPage(CWnd* pParent /*=NULL*/)
: CXPropertyPage(CLoginPage::IDD, pParent)
{

	bInitCtrlsPos=FALSE;
}

CLoginPage::~CLoginPage()
{
}

void CLoginPage::DoDataExchange(CDataExchange* pDX)
{
	CXPropertyPage::DoDataExchange(pDX);
}


BOOL CLoginPage::OnInitDialog()
{
	CXPropertyPage::OnInitDialog();


	g_hLoginWnd=GetSafeHwnd();
	GetDlgItem(IDC_CONNECT_STATUS)->SetWindowText(L"Disconnected.");

	if (LoadUserData())
	{

		WCHAR wTemp[0x100];


		MultiByteToWideChar(CP_UTF8, 0, CXfireCore::s_cUserName, -1, wTemp, 0x100);


		::SetWindowText(GetDlgItem(IDC_USERNAME)->GetSafeHwnd(),wTemp);

		MultiByteToWideChar(CP_UTF8, 0, CXfireCore::s_cPassword, -1, wTemp, 0x100);

		::SetWindowText(GetDlgItem(IDC_PASSWORD)->GetSafeHwnd(),wTemp);

	}

	
	GetDlgItem(IDC_USERNAME)->GetWindowRect(&rcUsername);

	
	GetDlgItem(IDC_PASSWORD)->GetWindowRect(&rcPassword);

	

	
	GetDlgItem(IDC_STATIC_USERNAME)->GetWindowRect(&rcStaticUsername);


	GetDlgItem(IDC_STATIC_PASSWORD)->GetWindowRect(&rcStaticPassword);

	
	GetDlgItem(IDC_CONNECT_STATUS)->GetWindowRect(&rcConnectStatus);

	
	GetDlgItem(IDC_SIGNIN_BUTTON)->GetWindowRect(&rcSigninButton);

    ScreenToClient(&rcSigninButton);

	ScreenToClient(&rcConnectStatus);
	
	ScreenToClient(&rcStaticUsername);
	ScreenToClient(&rcStaticPassword);



	ScreenToClient(&rcUsername);
	ScreenToClient(&rcPassword);

	nResizeTop=rcUsername.top;

	bInitCtrlsPos=TRUE;
	
// Create a menu bar

	
	return TRUE;  // return TRUE  unless you set the focus to a control
}




BEGIN_MESSAGE_MAP(CLoginPage, CXPropertyPage)
	ON_BN_CLICKED(IDC_SIGNIN_BUTTON, &CLoginPage::OnBnClickedSigninButton)
	ON_MESSAGE(WM_CONNECTION_STATUS, OnConnectionStatus)
	
	
	ON_MESSAGE(WM_LANDSCAPE, OnLandScape)

	ON_WM_SIZE()
	ON_WM_CTLCOLOR()
	ON_STN_CLICKED(IDC_STATIC_LOGO, &CLoginPage::OnStnClickedStaticLogo)
END_MESSAGE_MAP()


// CLoginPage message handlers




LRESULT CLoginPage::OnLandScape(WPARAM wParam, LPARAM lParam)
{



	return 0;
}

LRESULT CLoginPage::OnConnectionStatus(WPARAM wParam, LPARAM lParam)
{


	
	if (CXfireCore::IsConnected()){

		GetDlgItem(IDC_CONNECT_STATUS)->SetWindowText(L"Connected.");

		GetDlgItem(IDC_SIGNIN_BUTTON)->SetWindowTextW(L"Sign out"); 
		
		//EnableWindow(FALSE);


	/*	if (::PostThreadMessage(g_nActiveThreadID, WM_TERM_THREAD, 0, 0) == 0) {

		DbgMsg(L"Thread 0x%02x possibly already terminated\n", g_nActiveThreadID);
	}

	m_loginPane->GetDlgItem(IDC_SIGNIN_BUTTON)->EnableWindow(true);

	m_x1.GoHome();*/



	}else{

		GetDlgItem(IDC_CONNECT_STATUS)->SetWindowText(L"Disconnected.");
		GetDlgItem(IDC_SIGNIN_BUTTON)->SetWindowTextW(L"Sign in");

		//GetDlgItem(IDC_SIGNIN_BUTTON)->EnableWindow(TRUE);


	}

	return 0;
}




void CLoginPage::OnBnClickedSigninButton()
{
	// TODO: Add your control notification handler code here


	if (CXfireCore::IsConnected()){

		if (::PostThreadMessage(g_nActiveThreadID, WM_TERM_THREAD, 0, 0) == 0) {

			DbgMsg(L"Thread 0x%02x possibly already terminated\n", g_nActiveThreadID);
		}
		return;
	}

	CXfireCore::InitToZero();

	


	WCHAR cTemp[0x100];

	::GetWindowText(GetDlgItem(IDC_USERNAME)->GetSafeHwnd(),cTemp,0x100);

	WideCharToMultiByte( CP_ACP, // ANSI Code Page
		0, // No special handling of unmapped chars
		cTemp, // wide-character string to be converted
		0x100,
		CXfireCore::s_cUserName, 
		0x100,
		NULL, NULL ); // Unrepresented char replacement - Use Default 


	::GetWindowText(GetDlgItem(IDC_PASSWORD)->GetSafeHwnd(),cTemp,0x100);


	WideCharToMultiByte( CP_ACP, // ANSI Code Page
		0, // No special handling of unmapped chars
		cTemp, // wide-character string to be converted
		0x100,
		CXfireCore::s_cPassword, 
		0x100,
		NULL, NULL ); // Unrepresented char replacement - Use Default 



	if (strlen(CXfireCore::s_cUserName)<1 ||
		strlen(CXfireCore::s_cPassword)<1 ) {

			AfxMessageBox(L"Your username or password is too short.",MB_ICONINFORMATION|MB_OK);

			return;

	}

	SaveUserData();

	


//	GetDlgItem(IDC_SIGNIN_BUTTON)->EnableWindow(FALSE);
    GetDlgItem(IDC_CONNECT_STATUS)->SetWindowText(L"Please wait connecting...");



	CClientThread* pThread = (CClientThread*)AfxBeginThread(RUNTIME_CLASS(CClientThread), THREAD_PRIORITY_NORMAL, 0, CREATE_SUSPENDED);
	if (!pThread)
	{

		OutputDebugString(L"CClientThread AfxBeginThread Failed!!!CRITICAL ERROR \n");
		return;
	}


	m_pClientThread=pThread;
	g_nActiveThreadID=pThread->m_nThreadID;
	pThread->m_socket.m_pThread = pThread; // the thread that m_socket lives

	// Now start the thread.
	pThread->ResumeThread();
}

void CLoginPage::OnSize(UINT nType, int cx, int cy)
{

	//AfxMessageBox(L"CLoginPage::OnSize");
	//CXPropertyPage::OnSize(nType, cx, cy);

	OutputDebugString(L"CLoginPage::OnSize \n");
		
	
    SIPINFO sipInfo={0};
	sipInfo.cbSize=sizeof(SIPINFO);
	if (!bInitCtrlsPos) return;

	if (SipGetInfo(&sipInfo)){

		if ((sipInfo.fdwFlags&SIPF_ON)==SIPF_ON){

			OutputDebugString(L"Keyboard SIPF_ON \n");
		

			GetDlgItem(IDC_STATIC_LOGO)->ShowWindow(SW_HIDE);


		GetDlgItem(IDC_STATIC_VERSION)->ShowWindow(SW_HIDE);

			GetDlgItem(IDC_USERNAME)->SetWindowPos(&wndTop,rcUsername.left,rcUsername.top-nResizeTop,0,0,
				SWP_NOSIZE |SWP_SHOWWINDOW);

		    GetDlgItem(IDC_PASSWORD)->SetWindowPos(&wndTop,rcPassword.left,rcPassword.top-nResizeTop,0,0,
					SWP_NOSIZE |SWP_SHOWWINDOW);

			GetDlgItem(IDC_STATIC_PASSWORD)->SetWindowPos(&wndTop,rcStaticPassword.left,rcStaticPassword.top-nResizeTop,0,0,
					SWP_NOSIZE |SWP_SHOWWINDOW);

			GetDlgItem(IDC_STATIC_USERNAME)->SetWindowPos(&wndTop,rcStaticUsername.left,rcStaticUsername.top-nResizeTop,0,0,
					SWP_NOSIZE |SWP_SHOWWINDOW);

			 GetDlgItem(IDC_CONNECT_STATUS)->SetWindowPos(&wndTop,rcConnectStatus.left,rcConnectStatus.top-nResizeTop,0,0,
					SWP_NOSIZE |SWP_SHOWWINDOW);


             GetDlgItem(IDC_SIGNIN_BUTTON)->SetWindowPos(&wndTop,rcSigninButton.left,rcSigninButton.top-nResizeTop,0,0,
					SWP_NOSIZE |SWP_SHOWWINDOW);


		}else
			if ((sipInfo.fdwFlags&SIPF_OFF)==SIPF_OFF){

				OutputDebugString(L"Keyboard SIPF_OFF \n");
		
			     GetDlgItem(IDC_STATIC_LOGO)->ShowWindow(SW_SHOW);
        

				GetDlgItem(IDC_STATIC_VERSION)->ShowWindow(SW_SHOW);


				GetDlgItem(IDC_USERNAME)->SetWindowPos(&wndTop,rcUsername.left,rcUsername.top,0,0,
					SWP_NOSIZE |SWP_SHOWWINDOW);

			
				GetDlgItem(IDC_PASSWORD)->SetWindowPos(&wndTop,rcPassword.left,rcPassword.top,0,0,
					SWP_NOSIZE |SWP_SHOWWINDOW);

				GetDlgItem(IDC_STATIC_PASSWORD)->SetWindowPos(&wndTop,rcStaticPassword.left,rcStaticPassword.top,0,0,
					SWP_NOSIZE |SWP_SHOWWINDOW);

				GetDlgItem(IDC_STATIC_USERNAME)->SetWindowPos(&wndTop,rcStaticUsername.left,rcStaticUsername.top,0,0,
					SWP_NOSIZE |SWP_SHOWWINDOW);

			    GetDlgItem(IDC_CONNECT_STATUS)->SetWindowPos(&wndTop,rcConnectStatus.left,rcConnectStatus.top,0,0,
					SWP_NOSIZE |SWP_SHOWWINDOW);


			    GetDlgItem(IDC_SIGNIN_BUTTON)->SetWindowPos(&wndTop,rcSigninButton.left,rcSigninButton.top,0,0,
					SWP_NOSIZE |SWP_SHOWWINDOW);

				

					

			}


	}else{

		OutputDebugString(L"SipGetInfo Failed \n");
		
	}

	
}


HBRUSH CLoginPage::OnCtlColor(CDC* pDC, CWnd* pWnd, UINT nCtlColor)
{
	HBRUSH hbr = CXPropertyPage::OnCtlColor(pDC, pWnd, nCtlColor);

	// TODO:  Change any attributes of the DC here

	// TODO:  Return a different brush if the default is not desired
	
	pDC->SetTextColor(RGB(255,255,255));  // change the text color

	pDC->SetBkColor(RGB(0x12,0x28,0x3f));  // change the text color

	return ::CreateSolidBrush(RGB(0x12,0x28,0x3f));
}

void CLoginPage::OnStnClickedStaticLogo()
{
	// TODO: Add your control notification handler code here
}
