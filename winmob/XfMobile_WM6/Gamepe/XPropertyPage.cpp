/************************************
  REVISION LOG ENTRY
  Revision By: Mihai Filimon
  Revised on 2/2/99 4:45:04 PM
  Comments: XPropertyPage.cpp : implementation file
 ************************************/

#include "stdafx.h"
#include "XPropertyPage.h"
#include "XPageSheet.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CXPropertyPage dialog

// Function name	: CXPropertyPage::CXPropertyPage
// Description	    : Default constuctructor
// Return type		: 
// Argument         : UINT nIDTemplate
// Argument         : CWnd* pParent /*=NULL*/
CXPropertyPage::CXPropertyPage(UINT nIDTemplate, CWnd* pParent /*=NULL*/)
	: CDialog(nIDTemplate, pParent)
{
	//{{AFX_DATA_INIT(CXPropertyPage)
		// NOTE: the ClassWizard will add member initialization here
	//}}AFX_DATA_INIT
	m_strCaption.LoadString(nIDTemplate );
	m_nIDTemplate = nIDTemplate;
	m_bCreated = FALSE;
	m_bAutoSize = FALSE;
}

// Function name	: CXPropertyPage::DoDataExchange
// Description	    : 
// Return type		: void 
// Argument         : CDataExchange* pDX
void CXPropertyPage::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CXPropertyPage)
		// NOTE: the ClassWizard will add DDX and DDV calls here
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CXPropertyPage, CDialog)
	//{{AFX_MSG_MAP(CXPropertyPage)
	ON_WM_SIZE()
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CXPropertyPage message handlers

// Function name	: CXPropertyPage::Create
// Description	    : Create this page
// Return type		: BOOL 
// Argument         : CWnd * pParentWnd
BOOL CXPropertyPage::Create(CXPropertySheet* pParentWnd)
{
	if (CDialog::Create(m_nIDTemplate))
	{
		ModifyStyle(WS_DLGFRAME | WS_THICKFRAME , WS_CLIPCHILDREN | WS_CLIPSIBLINGS);
		SetParent((CWnd*)pParentWnd);
		MoveWindow(pParentWnd->_GetClientRect());
		m_bCreated = TRUE;
		return TRUE;
	}
	return FALSE;
}

// Function name	: CXPropertyPage::OnSize
// Description	    : Resize first this when, WM_SIZE is 
// Return type		: void 
// Argument         : UINT nType
// Argument         : int cx
// Argument         : int cy
void CXPropertyPage::OnSize(UINT nType, int cx, int cy) 
{
	CDialog::OnSize(nType, cx, cy);

	if (m_bCreated)
	{
		
		MoveWindow(((CXPropertySheet*)GetParent())->_GetClientRect());
		if (m_bAutoSize)
			if (CWnd* pWnd = GetWindow(GW_CHILD))
			{
				CRect rect; GetClientRect(rect);
				pWnd->MoveWindow(rect);
			}
			
	}
}

void CXPropertyPage::Resize()
{

	RECT rc={0,0,0,0};
	GetClientRect(&rc);
	MoveWindow(&rc);
	/*if (m_bAutoSize)
		if (CWnd* pWnd = GetWindow(GW_CHILD))
		{
			CRect rect; GetClientRect(rect);
			pWnd->MoveWindow(rect);
		}*/

}
// Function name	: CXPropertyPage::PostNcDestroy
// Description	    : delete the page after destroy event
// Return type		: void 
void CXPropertyPage::PostNcDestroy() 
{
	delete this;
	
	CDialog::PostNcDestroy();
}

// Function name	: = 
// Description	    : 
// Return type		: CXPropertyPage* CXPropertyPage::operator 
// Argument         : BOOL bAutoSize
CXPropertyPage* CXPropertyPage::operator = (BOOL bAutoSize)
{
	m_bAutoSize = bAutoSize;
	return this;
}

// Function name	: CXPropertyPage::PreTranslateMessage
// Description	    : 
// Return type		: BOOL 
// Argument         : MSG* pMsg
BOOL CXPropertyPage::PreTranslateMessage(MSG* pMsg) 
{
	switch (pMsg->message)
	{
		case WM_KEYDOWN:
		{
			switch ((int)pMsg->wParam)
			{
				case VK_RETURN:
				case VK_ESCAPE:
					return TRUE;
			}
			break;
		}
	}
	
	return CDialog::PreTranslateMessage(pMsg);
}
