// GamepeDlg.h : header file
//
/*

Border: None 
Title Bar: False 
System Menu: False 
Style: Popup 
*/



#pragma once
class CClientThread;

// CGamepeDlg dialog

#include "XTabCtrl.h"	// Added by ClassView
#include "XPageSheet.h"
class CTabItem;
class CLoginPage;
class CFriendsPane;
class CChatPane;
class CTabItem;
class CXTabCtrl;
class CGamepeDlg : public CDialog
{
// Construction
public:
	CGamepeDlg(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
	enum { IDD = IDD_IBLAZE_DIALOG };

	CXPropertySheet m_x1;
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
	
	LRESULT OnConnectionStatus(WPARAM wParam, LPARAM lParam);
    LRESULT OnNewChatWindow(WPARAM wParam, LPARAM lParam);
LRESULT OnHotKey(WPARAM wParam, LPARAM lParam);
	//afx_msg void OnHotKey(UINT nHotKeyId, UINT nKey1, UINT nKey2);
	CLoginPage     *m_loginPane;
	CFriendsPane   *m_friendPane;
	CChatPane      *m_chatPane; 
	CXTabCtrl::CTabItem* pChatTitle;

// Implementation
protected:
	HICON m_hIcon,m_hLogoIcon;
	
	//CXTabCtrl	m_tabctrl;

	// Generated message map functions
	virtual BOOL OnInitDialog();
//#if defined(_DEVICE_RESOLUTION_AWARE) && !defined(WIN32_PLATFORM_WFSP)
	afx_msg void OnSize(UINT /*nType*/, int /*cx*/, int /*cy*/);
	
//#endif
	DECLARE_MESSAGE_MAP()
public:
 
	afx_msg void OnBnClickedButton1();
	afx_msg void OnSignout();
	afx_msg void OnUpdateSignout(CCmdUI *pCmdUI);
	afx_msg HBRUSH OnCtlColor(CDC* pDC, CWnd* pWnd, UINT nCtlColor);
	afx_msg void OnOptionsAddbuddy();
	afx_msg void OnOptionsViewprofile();
	afx_msg void OnOptionsSetmystatus();
	afx_msg void OnSettingChange(UINT uFlags, LPCTSTR lpszSection);
	afx_msg void OnOptionsMinimize();
	afx_msg void OnOptionsSupport();
	afx_msg void OnActivate(UINT nState, CWnd* pWndOther, BOOL bMinimized);
	afx_msg void OnFriends();
	afx_msg void OnSendim();
	afx_msg void OnEndconversation();
	afx_msg void OnSigninButton();
	afx_msg void OnClear();
	afx_msg void OnMenuOptions();
	afx_msg void OnActivateApp(BOOL bActive, DWORD dwThreadID);
	

	afx_msg void OnTimer(UINT_PTR nIDEvent);
	afx_msg void OnSizing(UINT fwSide, LPRECT pRect);
	afx_msg void OnMenuInvite();
	afx_msg void OnMenuVisitourwebsite();
	afx_msg void OnKeyUp(UINT nChar, UINT nRepCnt, UINT nFlags);
};
