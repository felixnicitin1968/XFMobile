#pragma once


// CAddBuddy dialog

class CAddBuddy : public CDialog
{
	DECLARE_DYNAMIC(CAddBuddy)

public:
	CAddBuddy(CWnd* pParent = NULL);   // standard constructor
	virtual ~CAddBuddy();

// Dialog Data
	enum { IDD = IDD_ADDBUDDYDLG };

	CEdit      m_title;

protected:
	virtual BOOL OnInitDialog();
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

	DECLARE_MESSAGE_MAP()
public:
	afx_msg void OnBnClickedOk();
	afx_msg void OnClose();
	afx_msg HBRUSH OnCtlColor(CDC* pDC, CWnd* pWnd, UINT nCtlColor);

};
