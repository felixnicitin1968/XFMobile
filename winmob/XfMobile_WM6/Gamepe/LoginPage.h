#pragma once

#include "XPropertyPage.h"


// CLoginPage dialog
class CClientThread;
class CLoginPage : public CXPropertyPage
{
	DECLARE_DYNAMIC(CLoginPage)

	
	
	RECT rcStaticUsername;
	RECT rcStaticPassword;
	RECT rcSigninButton;
	RECT rcConnectStatus;

	RECT rcUsername;
	RECT rcPassword;

	BOOL bInitCtrlsPos;

	int  nResizeTop;


public:
	CLoginPage(CWnd* pParent = NULL);   // standard constructor
	virtual ~CLoginPage();
	LRESULT OnConnectionStatus(WPARAM wParam, LPARAM lParam);

    LRESULT OnLandScape(WPARAM wParam, LPARAM lParam);
	
	CClientThread *m_pClientThread;
// Dialog Data
	enum { IDD = IDD_LOGIN_PAGE };

protected:
	virtual BOOL OnInitDialog();
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

	DECLARE_MESSAGE_MAP()
public:

	afx_msg void OnBnClickedSigninButton();


	afx_msg void OnSize(UINT nType, int cx, int cy);
	afx_msg HBRUSH OnCtlColor(CDC* pDC, CWnd* pWnd, UINT nCtlColor);
	afx_msg void OnStnClickedStaticLogo();
	afx_msg void OnChar(UINT nChar, UINT nRepCnt, UINT nFlags);
};
