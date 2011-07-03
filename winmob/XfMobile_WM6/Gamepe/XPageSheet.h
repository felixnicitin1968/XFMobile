/************************************
  REVISION LOG ENTRY
  Revision By: Mihai Filimon
  Revised on 2/3/99 7:30:11 AM
  Comments: XPageSheet.h: interface for the CXPropertySheet class.
 ************************************/

#if !defined(AFX_XPAGESHEET_H__2EB6AD46_B9A2_11D2_8767_0040055C08D9__INCLUDED_)
#define AFX_XPAGESHEET_H__2EB6AD46_B9A2_11D2_8767_0040055C08D9__INCLUDED_

#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000

#include "XTabCtrl.h"
#include "XPropertyPage.h"

class CXPropertySheet : public CXTabCtrl  
{
	friend class CXPropertyPage;
public:
	virtual CXPropertyPage* GetPage(int nIndex);
	CXPropertySheet();
	virtual ~CXPropertySheet();
	virtual int AddItem(LPCTSTR lpszItemText, LPARAM lParam = NULL, HICON hIcon = NULL);
	//Operations
	CXTabCtrl::CTabItem* AddPage( CXPropertyPage *pPage, LPCTSTR,HICON hIcon = NULL, LPARAM lParam = NULL );

	//{{AFX_DATA(CXPropertySheet)
		// NOTE: the ClassWizard will add data members here
	//}}AFX_DATA

	//{{AFX_VIRTUAL(CXPropertySheet)
	//}}AFX_VIRTUAL

protected:
	virtual void OnActivatePage(int nItemOld, int nItemNew);
	CArray<CXPropertyPage*, CXPropertyPage*> m_arPages;
	// Generated message map functions
	//{{AFX_MSG(CXPropertySheet)
	afx_msg void OnSize(UINT nType, int cx, int cy);
	afx_msg HBRUSH OnCtlColor(CDC* pDC, CWnd* pWnd, UINT nCtlColor);
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()

};

#endif // !defined(AFX_XPAGESHEET_H__2EB6AD46_B9A2_11D2_8767_0040055C08D9__INCLUDED_)
