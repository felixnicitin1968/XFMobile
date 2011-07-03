// GamepeDlg.cpp : implementation file
//

#include "stdafx.h"
#include "Gamepe.h"
#include "GamepeDlg.h"
#include "SHA1.h"
#include "MsgQue.h"
#include "ClientT.h"
#include "XfireCore.h"
#include "Global.h"
#include "LoginPage.h"
#include "FriendsPane.h"
#include "AddBuddy.h"
#include "MyStatusDlg.h"
#include "ChatViewDlg.h"
#include "OptionsPane.h"
#ifdef _DEBUG
#define new DEBUG_NEW
#endif

// CGamepeDlg dialog





CGamepeDlg::CGamepeDlg(CWnd* pParent /*=NULL*/)
: CDialog(CGamepeDlg::IDD, pParent)
{
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
	m_hLogoIcon = AfxGetApp()->LoadIcon(IDR_LOGO);
}

void CGamepeDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);


}

BEGIN_MESSAGE_MAP(CGamepeDlg, CDialog)
	
	//}}AFX_MSG_MAP
	ON_COMMAND(ID_SIGNOUT, &CGamepeDlg::OnSignout)
	ON_UPDATE_COMMAND_UI(ID_SIGNOUT, &CGamepeDlg::OnUpdateSignout)
	ON_WM_CTLCOLOR()
	ON_COMMAND(ID_OPTIONS_ADDBUDDY, &CGamepeDlg::OnOptionsAddbuddy)
	ON_COMMAND(ID_OPTIONS_VIEWPROFILE, &CGamepeDlg::OnOptionsViewprofile)
	ON_COMMAND(ID_OPTIONS_SETMYSTATUS, &CGamepeDlg::OnOptionsSetmystatus)
	ON_MESSAGE(WM_CONNECTION_STATUS, OnConnectionStatus)
	ON_MESSAGE(WM_NEW_CHAT_WND, OnNewChatWindow)
	ON_WM_SETTINGCHANGE()
	ON_COMMAND(ID_OPTIONS_MINIMIZE, &CGamepeDlg::OnOptionsMinimize)
	ON_COMMAND(ID_OPTIONS_SUPPORT, &CGamepeDlg::OnOptionsSupport)
	ON_COMMAND(ID_FRIENDS, &CGamepeDlg::OnFriends)
	ON_COMMAND(ID_SENDIM, &CGamepeDlg::OnSendim)
	ON_COMMAND(ID_ENDCONVERSATION, &CGamepeDlg::OnEndconversation)
	ON_COMMAND(IDC_SIGNIN_BUTTON, &CGamepeDlg::OnSigninButton)
	ON_COMMAND(ID_CLEAR, &CGamepeDlg::OnClear)
	ON_COMMAND(ID_MENU_OPTIONS, &CGamepeDlg::OnMenuOptions)
	ON_MESSAGE(WM_HOTKEY,OnHotKey)

	
	//ON_WM_ACTIVATEAPP()
	ON_WM_TIMER()
	
	ON_COMMAND(ID_MENU_INVITE, &CGamepeDlg::OnMenuInvite)
	ON_COMMAND(ID_MENU_VISITOURWEBSITE, &CGamepeDlg::OnMenuVisitourwebsite)
	ON_WM_KEYUP()
END_MESSAGE_MAP()


LRESULT CGamepeDlg::OnHotKey(WPARAM wParam, LPARAM lParam)
{


   DbgMsg(L"TOnHotKeyOnHotKeyOnHotKeyOnHotKey\n");


	PostQuitMessage(0);
	return 0;
}


LRESULT CGamepeDlg::OnNewChatWindow(WPARAM wParam, LPARAM lParam)
{


	XfireContact *pContact=(XfireContact*)wParam;


	WCHAR wName[0x100];

	if (pContact->cNickname[0]==0){


		MultiByteToWideChar(CP_UTF8, 0, pContact->cUsername, -1, wName, 0x100);

	}else{

		MultiByteToWideChar(CP_UTF8, 0, pContact->cNickname, -1, wName, 0x100);

	}

	pContact->nTotalRecivedMessages=0;  





	m_chatPane->SetUserID(pContact->userid);

	//lstrcpyW(pChatTitle->GetBuffer(0),wName);


	::SendMessage(g_hContactsWnd,WM_ADD_CONVERSATION,(WPARAM)pContact,0);

	m_x1.GoToChat();



	return 0;
}



LRESULT CGamepeDlg::OnConnectionStatus(WPARAM wParam, LPARAM lParam)
{


	if (wParam==XFIRE_LOGIN_SUCCESS_ID){



		g_isDisconnected=FALSE;
        PlaySound(MAKEINTRESOURCE(IDR_WAVE3), ::GetModuleHandle(NULL),SND_ASYNC | SND_RESOURCE);
		m_x1.GoToFriends();


	}
	if (wParam==XFIRE_LOGIN_FAILED_ID){


		OnSignout();

		g_isDisconnected=TRUE;

	}



	return 0;
}


BOOL CGamepeDlg::OnInitDialog()
{
	CDialog::OnInitDialog();

	// Set the icon for this dialog.  The framework does this automatically
	//  when the application's main window is not a dialog
	SetIcon(m_hIcon, TRUE);			// Set big icon
	SetIcon(m_hIcon, FALSE);		// Set small icon

	// TODO: Add extra initialization here



	ModifyStyle(0, WS_CLIPCHILDREN);

	AfxEnableDRA(TRUE);

	g_hMainDlg=GetSafeHwnd();


	RegisterHotKey(g_hMainDlg, 2, 0, 0x73); //END KEY OVERWRITE


	m_x1.Create( TCXS_DOWN |WS_CHILD | WS_VISIBLE, CRect(0,0,0,0), this, 0);


	RECT rc;

	GetClientRect(&rc);

	m_x1.SetWindowPos(&wndTop  ,0,0,rc.right-rc.left,rc.bottom-rc.top,SWP_SHOWWINDOW   );



	m_loginPane=new CLoginPage();
	m_friendPane=new CFriendsPane();


	m_x1.AddPage(m_loginPane,L"Login");

	m_x1.AddPage(m_friendPane,L"Friends"); 

	
	m_chatPane=new CChatPane();
	pChatTitle= m_x1.AddPage(m_chatPane,L"Conversation");

		
	m_x1.GoHome();
   
	
	::SendMessage(SHFindMenuBar(GetSafeHwnd()), SHCMBM_OVERRIDEKEY,VK_TTALK,         
		MAKELPARAM((SHMBOF_NODEFAULT|SHMBOF_NOTIFY), (SHMBOF_NODEFAULT|SHMBOF_NOTIFY)));

	SetTimer(100,300,NULL);

	return TRUE;  // return TRUE  unless you set the focus to a control
}


void CGamepeDlg::OnSize(UINT nType, int cx, int cy)
{

   
	return;
	if (!m_x1) return;
	RECT rc;

	GetClientRect(&rc);
	m_x1.SetWindowPos(&wndTop  ,0,0,rc.right-rc.left,rc.bottom-rc.top,SWP_SHOWWINDOW   );
	m_x1.SendMessage(WM_SIZE, 0,0);

	m_loginPane->MoveWindow(m_x1._GetClientRect(),1);// (0,0,10,10,TRUE);
	m_friendPane->MoveWindow(m_x1._GetClientRect(),1);// (0,0,10,10,TRUE);

	m_friendPane->ResizeTreeCtrl();


	if (m_chatPane){
		m_chatPane->MoveWindow(m_x1._GetClientRect(),1);

	}



}





void CGamepeDlg::OnSignout()
{
	// TODO: Add your command handler code here



	g_isDisconnected=TRUE;

	if (::PostThreadMessage(g_nActiveThreadID, WM_TERM_THREAD, 0, 0) == 0) {

		DbgMsg(L"Thread 0x%02x possibly already terminated\n", g_nActiveThreadID);
	}

	m_loginPane->GetDlgItem(IDC_SIGNIN_BUTTON)->EnableWindow(true);

	m_x1.GoHome();
}

void CGamepeDlg::OnUpdateSignout(CCmdUI *pCmdUI)
{
	// TODO: Add your command update UI handler code here

	pCmdUI->Enable(0);
}

HBRUSH CGamepeDlg::OnCtlColor(CDC* pDC, CWnd* pWnd, UINT nCtlColor)
{
	HBRUSH hbr = CDialog::OnCtlColor(pDC, pWnd, nCtlColor);

	// TODO:  Change any attributes of the DC here

	// TODO:  Return a different brush if the default is not desired
	return hbr;//::CreateSolidBrush(RGB(0x0,0x0,128));


	//return ::CreateSolidBrush(RGB(255,255,255));
}

void CGamepeDlg::OnOptionsAddbuddy()
{
	// TODO: Add your command handler code here


	if (!CXfireCore::IsConnected()){
		

		AfxMessageBox(L"you are not connected to the xfire network",MB_ICONINFORMATION|MB_OK);
	//	return;

	}
	CAddBuddy addBuddyDlg;

	addBuddyDlg.DoModal();



}

void CGamepeDlg::OnOptionsViewprofile()
{
	// TODO: Add your command handler code here



	if (!CXfireCore::IsConnected())
	{
		
		AfxMessageBox(L"you are not connected to the xfire network",MB_ICONINFORMATION|MB_OK);
		return;
	}

	XfireContact *xontact=CXfireCore::getContactByID(g_SelectedUserID);

	
	if (!xontact){
	
		xontact=CXfireCore::getClanMember(g_SelectedUserID);

		if (!xontact){
		   return;
		}
	}

	WCHAR wName[0x100];

	MultiByteToWideChar(CP_UTF8, 0, xontact->cUsername, -1, wName, 0x100);

	WCHAR szURL[0x200];

	wsprintf(szURL,L"http://www.xfire.com/profile/");
	lstrcat(szURL,wName);


	SHELLEXECUTEINFO ShExecInfo;

	ShExecInfo.cbSize = sizeof(SHELLEXECUTEINFO);
	ShExecInfo.fMask = NULL;
	ShExecInfo.hwnd = NULL;
	ShExecInfo.lpVerb = NULL;
	ShExecInfo.lpFile = L"iexplore.exe" ;
	ShExecInfo.lpParameters = szURL;
	ShExecInfo.lpDirectory = NULL;
	ShExecInfo.nShow = SW_SHOWMAXIMIZED;
	ShExecInfo.hInstApp = NULL;

	ShellExecuteEx(&ShExecInfo);




}

void CGamepeDlg::OnOptionsSetmystatus()
{
	// TODO: Add your command handler code here


	if (!CXfireCore::IsConnected()){


		AfxMessageBox(L"you are not connected to the xfire network",MB_ICONINFORMATION|MB_OK);
	//	return;

	}

	CMyStatusDlg myStatusDlg;

	myStatusDlg.DoModal();

}

void CGamepeDlg::OnSettingChange(UINT uFlags, LPCTSTR lpszSection)
{
	CDialog::OnSettingChange(uFlags, lpszSection);


	// TODO: Add your message handler code here

	if (!m_x1) return;
	RECT rc;

	GetClientRect(&rc);
	m_x1.SetWindowPos(&wndTop  ,0,0,rc.right-rc.left,rc.bottom-rc.top,SWP_SHOWWINDOW   );
	m_x1.SendMessage(WM_SIZE, 0,0);

	m_loginPane->MoveWindow(m_x1._GetClientRect(),1);
	m_friendPane->MoveWindow(m_x1._GetClientRect(),1);
	m_friendPane->ResizeTreeCtrl();

	if (m_chatPane){
		m_chatPane->MoveWindow(m_x1._GetClientRect(),1);

	}
}



void CGamepeDlg::OnOptionsMinimize()
{
	// TODO: Add your command handler code here



	::SetWindowPos(GetSafeHwnd(), NULL, -1000, -1000, 0, 0,
		SWP_NOZORDER | SWP_NOSIZE | SWP_NOACTIVATE );


	//::ShowWindow(GetSafeHwnd(),SW_HIDE );
	::ShowWindow(g_hwndMb,SW_HIDE );
	::SetForegroundWindow(::FindWindow(
		_T("DesktopExplorerWindow"), _T("Desktop")));


	

}

void CGamepeDlg::OnOptionsSupport()
{
	// TODO: Add your command handler code here
	SHELLEXECUTEINFO ShExecInfo;

	ShExecInfo.cbSize = sizeof(SHELLEXECUTEINFO);
	ShExecInfo.fMask = NULL;
	ShExecInfo.hwnd = NULL;
	ShExecInfo.lpVerb = NULL;
	ShExecInfo.lpFile = L"tmail.exe" ;
	ShExecInfo.lpParameters = L"mailto: moti@gamepe.com  ?subject=XfMobile(WinMo)";
	ShExecInfo.lpDirectory = NULL;
	ShExecInfo.nShow = SW_SHOWMAXIMIZED;
	ShExecInfo.hInstApp = NULL;

	ShellExecuteEx(&ShExecInfo);
}


void CGamepeDlg::OnFriends()
{
	// TODO: Add your command handler code here

	//if (!CXfireCore::IsConnected()) return;

	m_x1.GoToFriends();
}






void CGamepeDlg::OnSendim()
{
	// TODO: Add your command handler code here

	XfireContact *pContact=CXfireCore::getContactByID(g_SelectedUserID);

	if (!pContact) {
		


		pContact=CXfireCore::getClanMember(g_SelectedUserID);

		if (!pContact) {	

		          AfxMessageBox(L"please select a friend",MB_ICONINFORMATION|MB_OK);

			       return;
		 
		}
			

	}


	WCHAR wName[0x100]={0};

	if (pContact->cNickname[0]==0){


		MultiByteToWideChar(CP_UTF8, 0, pContact->cUsername, -1, wName, 0x100);

	}else{

		MultiByteToWideChar(CP_UTF8, 0, pContact->cNickname, -1, wName, 0x100);

	}

	pContact->nTotalRecivedMessages=0;


	
	m_chatPane->SetUserID(pContact->userid);

	WCHAR szTitle[0x100]=L"Chatting with ";
	lstrcatW(szTitle,wName);
	m_chatPane->SetChatTitle(szTitle);

 
	m_chatPane->LoadHistory();
	///lstrcpyW(pChatTitle->GetBuffer(0),wName);
	
	::SendMessage(g_hContactsWnd,WM_ADD_CONVERSATION,(WPARAM)pContact,0);

	m_x1.GoToChat();
}


void CGamepeDlg::OnEndconversation()
{


	m_x1.GoToFriends();

}



void CGamepeDlg::OnSigninButton()
{
	// TODO: Add your command handler code here
	m_loginPane->OnBnClickedSigninButton();
}

void CGamepeDlg::OnClear()
{
	// TODO: Add your command handler code here
	m_chatPane->ClearChat();
}

void CGamepeDlg::OnMenuOptions()
{
	// TODO: Add your command handler code here

	COptionsPane optPane;

	optPane.DoModal();
}



void CGamepeDlg::OnTimer(UINT_PTR nIDEvent)
{
	// TODO: Add your message handler code here and/or call default
  
	if (::GetForegroundWindow()==GetSafeHwnd() ){


		::ShowWindow(GetSafeHwnd(),SW_SHOW);
		::ShowWindow(g_hwndMb,SW_SHOW );
	}

	CDialog::OnTimer(nIDEvent);
}

void CGamepeDlg::OnSizing(UINT fwSide, LPRECT pRect)
{


	// TODO: Add your message handler code here
}

void CGamepeDlg::OnMenuInvite()
{
	// TODO: Add your command handler code here



	if (!CXfireCore::IsConnected()){

		AfxMessageBox(L"you are not connected to the xfire network",MB_ICONINFORMATION|MB_OK);
		return;

	}



	if (g_SelectedUserID!=0 && g_SelectedUserID!=-1) {

		XfireContact *pContact=CXfireCore::getContactByID(g_SelectedUserID);

		if (!pContact){
		

			pContact=CXfireCore::getClanMember(g_SelectedUserID);

			if (!pContact){
			
				 return;
			}

		}

		CXfireCore::s_pCore->Invite(pContact->sid);

		WCHAR szMsg[0x100];
		wsprintfW(szMsg,L"Invitation to join xfire mobile was sent to your friend.");
		AfxMessageBox(szMsg,MB_ICONINFORMATION|MB_OK);
	}else{


		AfxMessageBox(L"Please select a friend to invite.",MB_ICONINFORMATION|MB_OK);
	}



}


/*


	*/



void CGamepeDlg::OnMenuVisitourwebsite()
{
	// TODO: Add your command handler code here


AfxBeginThread(MetricClickNotificationThread,0);


	SHELLEXECUTEINFO ShExecInfo;

	ShExecInfo.cbSize = sizeof(SHELLEXECUTEINFO);
	ShExecInfo.fMask = NULL;
	ShExecInfo.hwnd = NULL;
	ShExecInfo.lpVerb = NULL;
	ShExecInfo.lpFile = L"iexplore.exe" ;
	ShExecInfo.lpParameters = g_szLinkToAd;
	ShExecInfo.lpDirectory = NULL;
	ShExecInfo.nShow = SW_SHOWMAXIMIZED;
	ShExecInfo.hInstApp = NULL;

	ShellExecuteEx(&ShExecInfo);
	
}

void CGamepeDlg::OnKeyUp(UINT nChar, UINT nRepCnt, UINT nFlags)
{
	// TODO: Add your message handler code here and/or call default


	OutputDebugString(L"---->OnKeyUp");
	CDialog::OnKeyUp(nChar, nRepCnt, nFlags);
}
