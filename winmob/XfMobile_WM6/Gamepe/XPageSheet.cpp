// XPageSheet.cpp: implementation of the CXPropertySheet class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "XPageSheet.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CXPropertySheet::CXPropertySheet()
{

}

CXPropertySheet::~CXPropertySheet()
{

}

BEGIN_MESSAGE_MAP(CXPropertySheet, CXTabCtrl)
	//{{AFX_MSG_MAP(CXPropertySheet)
	ON_WM_SIZE()
	ON_WM_CTLCOLOR()
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()


// Function name	: CXPropertySheet::AddItem
// Description	    : Do not call AddItem function
// Return type		: int 
// Argument         : LPCTSTR lpszItemText
// Argument         : LPARAM lParam
// Argument         : HICON hIcon



HBRUSH CXPropertySheet::OnCtlColor(CDC* pDC, CWnd* pWnd, UINT nCtlColor)
{
	HBRUSH hbr = CWnd::OnCtlColor(pDC, pWnd, nCtlColor);

	// TODO:  Change any attributes of the DC here

	// TODO:  Return a different brush if the default is not desired
	return ::CreateSolidBrush(RGB(255,255,255));
}



int CXPropertySheet::AddItem(LPCTSTR lpszItemText, LPARAM lParam , HICON hIcon )
{
	//Do not call AddItem function. Call instead AddPage function.
	ASSERT (FALSE);
	return -1;
}

// Function name	: CXPropertySheet::AddPage
// Description	    : Add a new page into sheet control
// Return type		: void 
// Argument         :  CXPropertyPage *pPage
// Argument         : HICON hIcon
// Argument         : LPARAM lParam
CXTabCtrl::CTabItem* CXPropertySheet::AddPage( CXPropertyPage *pPage,LPCTSTR szTitle, HICON hIcon , LPARAM lParam )
{
	VERIFY(!::IsWindow(pPage->m_hWnd));
	int nItem = NULL;
	VERIFY((nItem = CXTabCtrl::AddItem(szTitle, lParam, hIcon)) >= 0 );
	pPage->Create(this);
	m_arPages.Add(pPage);
		
	*(CXTabCtrl*)this = nItem;

	// Force to resize at on add page
	SendMessage(WM_SIZE, 0,0);
	return m_arItems[nItem];
}

// Function name	: CXPropertySheet::OnSize
// Description	    : Resize childs ...
// Return type		: void 
// Argument         : UINT nType
// Argument         : int cx
// Argument         : int cy
void CXPropertySheet::OnSize(UINT nType, int cx, int cy) 
{
	CXTabCtrl::OnSize(nType, cx, cy);
	
	CRect rect = _GetClientRect();
	// Return the client area. Not equal with GetClientRect.
	// Warning. Here rect.left, rect.top can be different on null
	for (int i = 0; i < GetCount(); i++){
		
			HWND hWnd=m_arPages[i]->GetSafeHwnd();
		   
		//	::SendMessage(hWnd,WM_SIZE,rect.Size().cx, rect.Size().cy);
	
	}
}

// Function name	: CXPropertySheet::OnActivatePage
// Description	    : 
// Return type		: void 
// Argument         : int nItemOld
// Argument         : int nItemNew
void CXPropertySheet::OnActivatePage(int nItemOld, int nItemNew)
{
	// Hide old active item
	if (nItemOld >= 0)
		if (nItemOld < GetCount())
			m_arPages[nItemOld]->ShowWindow(SW_HIDE);
	// Show the new one
	if (nItemNew >= 0)
		if (nItemNew < GetCount())
			m_arPages[nItemNew]->ShowWindow(SW_SHOW);
}

// Function name	: CXPropertySheet::GetPage
// Description	    : Return the page index nIndex
// Return type		: CXPropertyPage* 
// Argument         : int nIndex
CXPropertyPage* CXPropertySheet::GetPage(int nIndex)
{
	if (nIndex >= 0)
		if (nIndex < GetCount())
			return m_arPages[nIndex];
	return FALSE;
}
