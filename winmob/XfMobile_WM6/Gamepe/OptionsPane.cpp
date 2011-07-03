// OptionsPane.cpp : implementation file
//

#include "stdafx.h"
#include "Gamepe.h"
#include "OptionsPane.h"
#include  "Global.h"

// COptionsPane dialog

IMPLEMENT_DYNAMIC(COptionsPane, CDialog)

COptionsPane::COptionsPane(CWnd* pParent /*=NULL*/)
	: CDialog(COptionsPane::IDD, pParent)
{

}

COptionsPane::~COptionsPane()
{
}

void COptionsPane::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
}


BEGIN_MESSAGE_MAP(COptionsPane, CDialog)
	ON_COMMAND(ID_CLOSE, &COptionsPane::OnClose)
	ON_BN_CLICKED(IDC_CHECK_SOUND_NOTIFICATION, &COptionsPane::OnBnClickedCheckSoundNotification)
	ON_BN_CLICKED(IDC_CHECK_ICON_NOTIFICATION, &COptionsPane::OnBnClickedCheckIconNotification)
	ON_WM_CTLCOLOR()
END_MESSAGE_MAP()


// COptionsPane message handlers


BOOL COptionsPane::OnInitDialog()
{



	AddMenuBar(GetSafeHwnd(),IDR_MENU2);


	RECT rc={0,0,0,0};
	::GetClientRect(GetParent()->GetSafeHwnd(),&rc);
	SetWindowPos(&wndTop  ,0,0,rc.right-rc.left,rc.bottom-rc.top,SWP_SHOWWINDOW );

	if (g_bIsSoundNotification){
		((CButton*)GetDlgItem(IDC_CHECK_SOUND_NOTIFICATION))->SetCheck(BST_CHECKED );

	}else{

		((CButton*)GetDlgItem(IDC_CHECK_SOUND_NOTIFICATION))->SetCheck(BST_UNCHECKED );

	}

	if (g_bIsIconNotification){
		((CButton*)GetDlgItem(IDC_CHECK_ICON_NOTIFICATION))->SetCheck(BST_CHECKED );

	}else{

		((CButton*)GetDlgItem(IDC_CHECK_ICON_NOTIFICATION))->SetCheck(BST_UNCHECKED );

	}

	
	return TRUE;


}




void COptionsPane::OnClose()
{
	// TODO: Add your command handler code here
	EndDialog(0);
}

void COptionsPane::OnBnClickedCheckSoundNotification()
{
	// TODO: Add your control notification handler code here
	
	g_bIsSoundNotification=!g_bIsSoundNotification;
}

void COptionsPane::OnBnClickedCheckIconNotification()
{
	// TODO: Add your control notification handler code here

	g_bIsIconNotification=!g_bIsIconNotification;
}

HBRUSH COptionsPane::OnCtlColor(CDC* pDC, CWnd* pWnd, UINT nCtlColor)
{
	HBRUSH hbr = CDialog::OnCtlColor(pDC, pWnd, nCtlColor);

	pDC->SetTextColor(RGB(255,255,255));  // change the text color

	pDC->SetBkColor(RGB(0x12,0x28,0x3f));  // change the text color

	return ::CreateSolidBrush(RGB(0x12,0x28,0x3f));
}
