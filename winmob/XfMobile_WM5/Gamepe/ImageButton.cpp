// ImageButton.cpp : implementation file
//

#include "stdafx.h"
#include "ImageButton.h"
#include "global.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CImageButton

CImageButton::CImageButton(UINT up, UINT down, UINT disabled, BOOL fill)
{
 this->up = up;
 this->down = down;
 this->disabled = disabled;
 this->m_fill = fill;
}

CImageButton::~CImageButton()
{
}


BEGIN_MESSAGE_MAP(CImageButton, CButton)
	//{{AFX_MSG_MAP(CImageButton)
		// NOTE - the ClassWizard will add and remove mapping macros here.
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CImageButton message handlers

/****************************************************************************
*                            CImageButton::SetVPos
* Inputs:
*       DWORD newstyle: Vertical style, one of BS_TOP, BS_BOTTOM, BS_VCENTER
* Result: DWORD
*       Previous style
* Effect: 
*       Sets the style
****************************************************************************/

DWORD CImageButton::SetVPos(DWORD newstyle)
    {
     DWORD style = GetStyle();
     DWORD result = style;
     style &= ~ (BS_TOP | BS_BOTTOM | BS_VCENTER);
     style |= newstyle;
     ::SetWindowLong(m_hWnd, GWL_STYLE, (long)style);
     InvalidateRect(NULL);
     return result & (BS_TOP | BS_BOTTOM | BS_VCENTER);
    } // CImageButton::SetVPos

/****************************************************************************
*                            CImageButton::SetHPos
* Inputs:
*       DWORD newstyle: Horizontal style, one of BS_LEFT, BS_RIGHT, BS_CENTER
* Result: DWORD
*       Previous style
* Effect: 
*       Sets the style
****************************************************************************/

DWORD CImageButton::SetHPos(DWORD newstyle)
   {
    DWORD style = GetStyle();
    DWORD result = style;
    style &= ~ (BS_LEFT | BS_RIGHT | BS_CENTER);
    style |= newstyle;
    ::SetWindowLong(m_hWnd, GWL_STYLE, (long)style);
    InvalidateRect(NULL);
    return result & (BS_LEFT | BS_RIGHT | BS_CENTER);
   } // CImageButton::SetHPos

void CImageButton::DrawItem(LPDRAWITEMSTRUCT dis) 
{
    

	 DisplayImage(GetSafeHwnd(),dis->hDC);
	 return;
   
}
