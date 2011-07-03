#pragma once


// CMyStatusDlg dialog

class CMyStatusDlg : public CDialog
{
	DECLARE_DYNAMIC(CMyStatusDlg)

public:
	CMyStatusDlg(CWnd* pParent = NULL);   // standard constructor
	virtual ~CMyStatusDlg();

// Dialog Data
	enum { IDD = IDD_SETSTATUS_DLG };

protected:
	virtual BOOL OnInitDialog();
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

	DECLARE_MESSAGE_MAP()
public:
	afx_msg void OnBnClickedOk();
	afx_msg void OnClose();
	afx_msg HBRUSH OnCtlColor(CDC* pDC, CWnd* pWnd, UINT nCtlColor);
};
