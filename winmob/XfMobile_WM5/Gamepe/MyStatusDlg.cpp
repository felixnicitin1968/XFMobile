// MyStatusDlg.cpp : implementation file
//

#include "stdafx.h"
#include "Gamepe.h"
#include "MyStatusDlg.h"
#include "XfireCore.h"


// CMyStatusDlg dialog

IMPLEMENT_DYNAMIC(CMyStatusDlg, CDialog)

CMyStatusDlg::CMyStatusDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CMyStatusDlg::IDD, pParent)
{

}

CMyStatusDlg::~CMyStatusDlg()
{
}


BOOL CMyStatusDlg::OnInitDialog()
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
	


	RECT rc;
	::GetClientRect(GetParent()->GetSafeHwnd(),&rc);
	SetWindowPos(&wndTop  ,0,0,rc.right-rc.left,rc.bottom-rc.top,SWP_SHOWWINDOW   );

	SetFocus();
	GetDlgItem(IDC_EDIT_MYSTATUS)->SetFocus();

	WCHAR wTemp[0x100];

	MultiByteToWideChar(CP_UTF8, 0,g_myStatusMsg, -1, wTemp, 0x100);


	GetDlgItem(IDC_EDIT_MYSTATUS)->SetWindowText(wTemp);


	return TRUE;
}



void CMyStatusDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
}


BEGIN_MESSAGE_MAP(CMyStatusDlg, CDialog)
	ON_BN_CLICKED(IDOK, &CMyStatusDlg::OnBnClickedOk)
	ON_COMMAND(ID_CLOSE, &CMyStatusDlg::OnClose)
	ON_WM_CTLCOLOR()
END_MESSAGE_MAP()


// CMyStatusDlg message handlers

void CMyStatusDlg::OnBnClickedOk()
{
	// TODO: Add your control notification handler code here
	
	char  szName[0x100];
	WCHAR wzName[0x100];
	GetDlgItem(IDC_EDIT_MYSTATUS)->GetWindowText(wzName,0x100);


	WideCharToMultiByte( CP_ACP, // ANSI Code Page
		0, // No special handling of unmapped chars
		wzName, // wide-character string to be converted
		0x100,
		szName, 
		0x100,
		NULL, NULL ); // Unrepresented char replacement - Use Default 


	if (strlen(szName)>2) {
		if (CXfireCore::s_pCore) {
	     
			  strcpy(g_myStatusMsg,szName);
			  CXfireCore::s_pCore->MessageOfTheDay (szName);
		}
	}
	OnOK();
}

void CMyStatusDlg::OnClose()
{
	// TODO: Add your command handler code here
	EndDialog(0);
}

HBRUSH CMyStatusDlg::OnCtlColor(CDC* pDC, CWnd* pWnd, UINT nCtlColor)
{
	
	HBRUSH hbr = CDialog::OnCtlColor(pDC, pWnd, nCtlColor);
	
	
	pDC->SetTextColor(RGB(255,255,255));  // change the text color

	pDC->SetBkColor(RGB(0x12,0x28,0x3f));  // change the text color

	return ::CreateSolidBrush(RGB(0x12,0x28,0x3f));
}
