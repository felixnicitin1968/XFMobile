#pragma once


// COptionsPane dialog

class COptionsPane : public CDialog
{
	DECLARE_DYNAMIC(COptionsPane)

public:
	COptionsPane(CWnd* pParent = NULL);   // standard constructor
	virtual ~COptionsPane();

// Dialog Data
	enum { IDD = IDD_OPTIONS_PANE };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

	virtual BOOL OnInitDialog();
	DECLARE_MESSAGE_MAP()	
public:
	afx_msg void OnBnClickedCheckSoundNotification();
	afx_msg void OnClose();

	afx_msg void OnBnClickedCheckIconNotification();
	afx_msg HBRUSH OnCtlColor(CDC* pDC, CWnd* pWnd, UINT nCtlColor);
};
