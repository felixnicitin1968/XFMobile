// AddBuddy.cpp : implementation file
//

#include "stdafx.h"
#include "Gamepe.h"
#include "AddBuddy.h"
#include "XfireCore.h"
#include "Global.h"

// CAddBuddy dialog

IMPLEMENT_DYNAMIC(CAddBuddy, CDialog)

CAddBuddy::CAddBuddy(CWnd* pParent /*=NULL*/)
	: CDialog(CAddBuddy::IDD, pParent)
{

}

CAddBuddy::~CAddBuddy()
{
}

void CAddBuddy::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
}


BEGIN_MESSAGE_MAP(CAddBuddy, CDialog)
	ON_BN_CLICKED(IDOK, &CAddBuddy::OnBnClickedOk)
	ON_COMMAND(ID_CLOSE, &CAddBuddy::OnClose)
	ON_WM_CTLCOLOR()
END_MESSAGE_MAP()


// CAddBuddy message handlers

void CAddBuddy::OnBnClickedOk()
{
	// TODO: Add your control notification handler code here


	char  szName[0x100];
	WCHAR wzName[0x100];
	GetDlgItem(IDC_ADD_USERNAME)->GetWindowText(wzName,0x100);


	WideCharToMultiByte( CP_ACP, // ANSI Code Page
		0, // No special handling of unmapped chars
		wzName, // wide-character string to be converted
		0x100,
		szName, 
		0x100,
		NULL, NULL ); // Unrepresented char replacement - Use Default 


	if (strlen(szName)>2) {
		if (CXfireCore::s_pCore) {
	     
			   CXfireCore::s_pCore->AddFriend(szName,"");
		}
	}
	OnOK();
}


BOOL CAddBuddy::OnInitDialog()
{


	SHMENUBARINFO mbi;
	memset(&mbi, 0, sizeof(SHMENUBARINFO));
	mbi.cbSize     = sizeof(SHMENUBARINFO);
	mbi.hwndParent = GetSafeHwnd();
	mbi.nToolBarId = IDR_MENU2;
	mbi.hInstRes   = ::GetModuleHandle(NULL);
	mbi.dwFlags = SHCMBF_HMENU;


	if (SHCreateMenuBar(&mbi)){

		

	}

	{
	RECT rc={0,0,0,0};
	::GetWindowRect(g_hMainDlg,&rc);

	SetWindowPos(&wndTop  ,0,0,rc.right-rc.left,rc.bottom-rc.top,SWP_SHOWWINDOW   );

	}



	/*m_title.Create(WS_CHILD | WS_VISIBLE | WS_TABSTOP | WS_BORDER|ES_READONLY,rc,this,IDC_EDIT_CHATVIEW);

	::GetClientRect(GetSafeHwnd(),&rc);

    int nHighet=rc.bottom-rc.top;
    int nWidth=rc.right-rc.left;


	
	m_title.SetWindowPos(&wndTop  ,0,0,nWidth,nHighet*0.2,SWP_SHOWWINDOW);

	m_title.SetWindowTextW(L"Add your buddyxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.");

*/

	//CenterWindow();

	GetDlgItem(IDC_ADD_USERNAME)->SetFocus();
	return TRUE;
}

void CAddBuddy::OnClose()
{
	// TODO: Add your command handler code here

	
	EndDialog(0);
}

HBRUSH CAddBuddy::OnCtlColor(CDC* pDC, CWnd* pWnd, UINT nCtlColor)
{
	
	
	HBRUSH hbr = CDialog::OnCtlColor(pDC, pWnd, nCtlColor);
    
	pDC->SetTextColor(RGB(255,255,255));  // change the text color

	pDC->SetBkColor(RGB(0x12,0x28,0x3f));  // change the text color

	return ::CreateSolidBrush(RGB(0x12,0x28,0x3f));
}

