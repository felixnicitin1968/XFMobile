#pragma once


// CChatViewDlg dialog
#include "XPropertyPage.h"
class CChatPane : public CXPropertyPage
{
	//DECLARE_DYNAMIC(CChatPane)


public:
	CChatPane(CWnd* pParent = NULL);   // standard constructor
	virtual ~CChatPane();
	LRESULT OnRecvIM(WPARAM wParam, LPARAM lParam);
	void   LoadHistory();
     
	int m_userid;
    CBrush m_redbrush,m_bluebrush;
    COLORREF m_redcolor,m_bluecolor,m_textcolor;

	CEdit      m_input;
	CEdit      m_view;
	CEdit      m_title;
	BOOL m_bIsInit;

	
    void ClearChat();
	void SetChatTitle(WCHAR *szTitle);
	void SetUserID(int userid){

		m_userid=userid;
	}
// Dialog Data
	enum { IDD = IDD_CHAT_DLG };

protected:
	virtual BOOL OnInitDialog();
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	virtual BOOL PreTranslateMessage(MSG* pMsg) ;

	afx_msg void OnSize(UINT nType, int cx, int cy);
	DECLARE_MESSAGE_MAP()
public:
	afx_msg void OnEnChangeEditChatview();
	afx_msg void OnBnClickedSendChat();
	afx_msg HBRUSH OnCtlColor(CDC* pDC, CWnd* pWnd, UINT nCtlColor);
	afx_msg void OnSettingChange(UINT uFlags, LPCTSTR lpszSection);
};
