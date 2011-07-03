/************************************
  REVISION LOG ENTRY
  Revision By: Mihai Filimon
  Revised on 2/3/99 7:28:48 AM
  Comments: CXPropertyPage dialog
 ************************************/

#if !defined(AFX_XPROPERTYPAGE_H__2EB6AD48_B9A2_11D2_8767_0040055C08D9__INCLUDED_)
#define AFX_XPROPERTYPAGE_H__2EB6AD48_B9A2_11D2_8767_0040055C08D9__INCLUDED_

#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000
// XPropertyPage.h : header file

class CXPropertyPage : public CDialog
{
	friend class CXPropertySheet;
// Construction
public:
	CXPropertyPage* operator = (BOOL bAutoSize);
	CXPropertyPage(UINT nIDTemplate, CWnd* pParent = NULL);   // standard constructor

// Dialog Data
	//{{AFX_DATA(CXPropertyPage)
		// NOTE: the ClassWizard will add data members here
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CXPropertyPage)
	public:
	virtual BOOL PreTranslateMessage(MSG* pMsg);
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	virtual void PostNcDestroy();
	void         Resize();
	//}}AFX_VIRTUAL

// Implementation
protected:
	virtual BOOL Create(CXPropertySheet* pParentWnd);
	CString m_strCaption;
	UINT m_nIDTemplate;
	BOOL m_bCreated;
	BOOL m_bAutoSize;

	// Generated message map functions
	//{{AFX_MSG(CXPropertyPage)
	afx_msg void OnSize(UINT nType, int cx, int cy);
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Developer Studio will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_XPROPERTYPAGE_H__2EB6AD48_B9A2_11D2_8767_0040055C08D9__INCLUDED_)
