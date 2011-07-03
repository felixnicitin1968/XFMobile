/************************************
  REVISION LOG ENTRY
  Revision By: Mihai Filimon
  Revised on 2/1/99 4:16:16 PM
  Comments: XTabCtrl.cpp : implementation file
 ************************************/

#include "stdafx.h"
#include "XTabCtrl.h"
#include "resourceppc.h"
#include "Global.h"
#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CXTabCtrl::CTabItem class 

int CXTabCtrl::CTabItem::m_nDXBorder = 3;
#define ISUP m_pParentCtrl->GetStyle() & TCXS_UP
#define SNDMSGNOTIFY(message) if (CWnd* pParentWnd = GetParent())\
								if ( ::IsWindow( pParentWnd->m_hWnd ) )\
								{\
									NMHDR nmHdr;\
									nmHdr.hwndFrom = m_hWnd;\
									nmHdr.idFrom = ::GetDlgCtrlID(m_hWnd);\
									nmHdr.code = message;\
									::SendMessage(pParentWnd->m_hWnd, WM_NOTIFY, MAKEWPARAM(nmHdr.idFrom, NULL), LPARAM(&nmHdr));\
								}
#define SNDMSGKEYDOWN(_wVKey, _flags) if (CWnd* pParentWnd = GetParent())\
								if ( ::IsWindow( pParentWnd->m_hWnd ) )\
								{\
									TC_KEYDOWN tcKeyDown;\
									tcKeyDown.hdr.hwndFrom = m_hWnd;\
									tcKeyDown.hdr.idFrom = ::GetDlgCtrlID(m_hWnd);\
									tcKeyDown.hdr.code = TCN_KEYDOWN;\
									tcKeyDown.wVKey = _wVKey;\
									tcKeyDown.flags = _flags;\
									::SendMessage(pParentWnd->m_hWnd, WM_NOTIFY, MAKEWPARAM(tcKeyDown.hdr.idFrom, NULL), LPARAM(&tcKeyDown));\
								}
// Function name	: CXTabCtrl::CTabItem::CTabItem
// Description	    : Default construcotr
// Return type		: 
CXTabCtrl::CTabItem::CTabItem(LPCTSTR lpszItemText, CXTabCtrl* pParentCtrl):CString(lpszItemText)
{
	m_hIcon = NULL;
	m_nWidth = NULL;
	m_lParam = NULL;
	m_pParentCtrl = pParentCtrl;
}

// Function name	: = 
// Description	    : 
// Return type		: CTabItem* CXTabCtrl::CTabItem::operator 
// Argument         : HICON hIcon
CXTabCtrl::CTabItem* CXTabCtrl::CTabItem::operator = (HICON hIcon)
{
	m_hIcon = hIcon;
	return this;
}

// Function name	: CXTabCtrl::CTabItem::NewItem
// Description	    : Called to create one new Item . Uses by AddItem functiopn
// Return type		: CXTabCtrl::CTabItem* 
// Argument         : LPCTSTR lpszItemText
CXTabCtrl::CTabItem* CXTabCtrl::CTabItem::NewItem(LPCTSTR lpszItemText, CXTabCtrl* pParentCtrl)
{
	return new CTabItem(lpszItemText, pParentCtrl);
}

// Function name	: CXTabCtrl::CTabItem::GetIdealWidth
// Description	    : Calc the ideal width of items.
// Return type		: void 
// Argument         : CDC * pDC
int CXTabCtrl::CTabItem::GetIdealWidth(CDC * pDC)
{
	int nResult = pDC->GetTextExtent(*this).cx + 2 * m_nDXBorder + (m_hIcon ? 16 + m_nDXBorder: 0);
	nResult = max(8 + m_nDXBorder, nResult);
	return nResult;
}

// Function name	: CXTabCtrl::CTabItem::Draw
// Description	    : Invalidate this item into pDC
// Return type		: void 
// Argument         : CDC * pDC
void CXTabCtrl::CTabItem::Draw(CDC* pDC, BOOL bActive, BOOL bFocused)
{
	DrawFrame(pDC, bActive);
	DrawText(pDC, bActive, bActive && bFocused);
}

// Function name	: CXTabCtrl::CTabItem::DrawIcon
// Description	    : 
// Return type		: void 
// Argument         : CDC* pDC
int CXTabCtrl::CTabItem::DrawIcon(CDC* pDC, BOOL bActive)
{
	CRect rect(GetItemRect());
	if (!bActive) rect.top += 2;
	rect.DeflateRect(CSize(m_nDXBorder,0));
	if (m_hIcon)
		// If the icon cover the area, draw it
		if (rect.Width() > 16)
		{
			CRect r(rect);
			r.right = r.left + 16;
			r.DeflateRect(CSize(0, (rect.Height() - 16)/2));
			CDC dcMem; CBitmap bmp;
			CSize sIcon(32,32);
			if (dcMem.CreateCompatibleDC(pDC))
				if (bmp.CreateCompatibleBitmap(pDC, sIcon.cx, sIcon.cy))
				{
					CBitmap* pBmp = dcMem.SelectObject(&bmp);
					dcMem.FillRect(CRect(CPoint(0,0), sIcon), CBrush::FromHandle((HBRUSH)GetStockObject(LTGRAY_BRUSH)));
					dcMem.DrawIcon(0,0,m_hIcon);
					pDC->StretchBlt(r.left,r.top, r.Width(), r.Height(), &dcMem, 0,0,sIcon.cx, sIcon.cy, SRCCOPY);
					dcMem.SelectObject(pBmp);
				}
			rect.left += r.Width() + m_nDXBorder/2;
		}
	return rect.left;
}

// Function name	: CXTabCtrl::CTabItem::DrawText
// Description	    : Draw the text here
// Return type		: void 
// Argument         : CDC* pDC
void CXTabCtrl::CTabItem::DrawText(CDC* pDC, BOOL bActive, BOOL bFocused)
{
	CRect rect(GetItemRect());
	if (!bActive) rect.top += 2;
	rect.DeflateRect(CSize(m_nDXBorder,0));
	rect.left = DrawIcon(pDC, bActive);
	CString sText(*this), sThree(_T("..."));
	int l = sText.GetLength();
	while ((l) && (pDC->GetTextExtent(sText).cx > rect.Width()))
		if (l > 1)
			sText = sText.Left(--l) + sThree;
		else
			if (sText.IsEmpty())
				break;
			else
				sText = sText.Left(sText.GetLength() - 1);
	if (!sText.IsEmpty())
	{
		pDC->DrawText(sText, rect, DT_LEFT | DT_VCENTER | DT_SINGLELINE);
		if (bFocused)
		{
			rect.DeflateRect(0, 2);
			pDC->DrawFocusRect(rect);
		}
	}
}

// Function name	: CXTabCtrl::CTabItem::GetItemRect
// Description	    : Return the item rect
// Return type		: CRect 
CRect CXTabCtrl::CTabItem::GetItemRect()
{
	ASSERT (m_pParentCtrl);
	CRect rect; m_pParentCtrl->GetClientRect(rect);
	int y = ISUP ? rect.top : rect.bottom - m_pParentCtrl->GetItemHeight() - 1;
	return CRect(CPoint(m_nStart, y) ,CSize(m_nWidth, m_pParentCtrl->GetItemHeight()));
}

// Function name	: CXTabCtrl::CTabItem::PtInItem
// Description	    : Return TRUE of point is in Item
// Return type		: BOOL 
// Argument         : CPoint point
BOOL CXTabCtrl::CTabItem::PtInItem(CPoint point)
{
	return GetItemRect().PtInRect(point);
}

static CPen _penG(PS_SOLID,1 ,RGB(128,128,128));
static CPen _penGG(PS_SOLID,1 ,RGB(192,192,192));
static CPen _penW(PS_SOLID,1 ,RGB(255,255,255));
static CPen _penB(PS_SOLID,1 ,RGB(0,0,0));
// Function name	: CXTabCtrl::CTabItem::DrawFrame
// Description	    : Draw the frame.
// Return type		: void 
// Argument         : CDC * pDC
void CXTabCtrl::CTabItem::DrawFrame(CDC * pDC, BOOL bActive)
{
	
	
	CRect rect(GetItemRect());
	if (ISUP)
	{
		if (!bActive) rect.top += 2;
		pDC->SelectObject(!bActive ? _penW : _penGG);
		pDC->MoveTo(rect.right - 1, rect.bottom);
		pDC->LineTo(rect.left , rect.bottom );
		pDC->SelectObject(_penW);
		pDC->LineTo(rect.left, rect.top + 2);
		pDC->LineTo(rect.left + 2, rect.top);
		pDC->LineTo(rect.right - 2, rect.top);
		pDC->SelectObject(&_penG);
		pDC->MoveTo(rect.right - 2, rect.top + 1);
		pDC->LineTo(rect.right - 2, rect.bottom);
		pDC->SelectObject(&_penB);
		pDC->MoveTo(rect.right - 1, rect.top + 2);
		pDC->LineTo(rect.right - 1, rect.bottom);
	}
	else
	{

		
		CRect r(rect);
		r.left++;
		r.right -= 2;
		if (bActive) pDC->FillRect(r, CBrush::FromHandle((HBRUSH)GetStockObject(LTGRAY_BRUSH)));
		if (!bActive) rect.bottom -= 2;
		rect.top += 2;
		pDC->SelectObject(_penW);
		pDC->MoveTo(rect.left, !bActive ? rect.top : rect.top - 2);
		pDC->LineTo(rect.left, rect.bottom - 1);
		pDC->SelectObject(_penG);
		pDC->MoveTo(rect.left + 1, rect.bottom - 2);
		pDC->LineTo(rect.left + 1, rect.bottom - 1);
		pDC->LineTo(rect.right - 2, rect.bottom - 1);
		pDC->MoveTo(rect.right - 3, rect.bottom - 2);
		pDC->LineTo(rect.right - 1, rect.bottom - 2);
		pDC->MoveTo(rect.right - 2, rect.bottom - 2);
		pDC->LineTo(rect.right - 2, !bActive ? rect.top - 1 : rect.top - 3);
		pDC->SelectObject(_penB);
		pDC->MoveTo(rect.left + 2, rect.bottom);
		pDC->LineTo(rect.right - 2, rect.bottom);
		pDC->MoveTo(rect.right - 2, rect.bottom - 1);
		pDC->LineTo(rect.right - 1, rect.bottom - 1);
		pDC->MoveTo(rect.right - 1, rect.bottom - 2);
		pDC->LineTo(rect.right - 1, rect.top - 1);
	}
}

/////////////////////////////////////////////////////////////////////////////
// CXTabCtrl class

// Function name	: CXTabCtrl::CXTabCtrl
// Description	    : default constrcutor
// Return type		: 
CXTabCtrl::CXTabCtrl()
{
	m_nActiveItem = -1;
	m_nStyle = NULL;
	VERIFY(m_hAccel = LoadAccelerators(AfxGetInstanceHandle(), MAKEINTRESOURCE(IDR_XTABCTRL)));
}

// Function name	: CXTabCtrl::~CXTabCtrl
// Description	    : virtual destructor
// Return type		: 
CXTabCtrl::~CXTabCtrl()
{
	while (DeleteItem(0));
}


BEGIN_MESSAGE_MAP(CXTabCtrl, CWnd)
	//{{AFX_MSG_MAP(CXTabCtrl)
	ON_WM_PAINT()
	ON_WM_SIZE()
	ON_WM_SETFOCUS()
	ON_WM_LBUTTONDOWN()
	ON_WM_ERASEBKGND()
	ON_WM_GETDLGCODE()
	ON_COMMAND(ID_KEY_LEFT, OnKeyLeft)
	ON_COMMAND(ID_KEY_RIGHT, OnKeyRight)
	ON_COMMAND(ID_KEY_SCTAB, OnKeySctab)
	ON_COMMAND(ID_KEY_CTAB, OnKeyCtab)
	ON_COMMAND(ID_KEY_END, OnKeyEnd)
	ON_COMMAND(ID_KEY_HOME, OnKeyHome)
	ON_COMMAND(ID_KEY_STAB, OnKeyStab)
	ON_COMMAND(ID_KEY_TAB, OnKeyTab)
	ON_WM_KILLFOCUS()
	ON_COMMAND(ID_KEY_UP, OnKeyUp)
	ON_COMMAND(ID_KEY_DOWN, OnKeyDown)
	
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()


/////////////////////////////////////////////////////////////////////////////
// CXTabCtrl message handlers




static const TCHAR* pszL = NULL;
CString _S(int i)
{
	CString sTemp; AfxExtractSubString(sTemp, pszL, i, TCHAR(','));
	return sTemp;
}

#ifdef _UNICODE
	#define _L(i) _wtol(_S(i))
#else
	#define _L(i) atol(_S(i))
#endif

#define _B(i) (BYTE)_L(i)
#define StartConversion(s) pszL = s
void FillLogFont(LOGFONT& logFont, LPCTSTR lpszFontString = _defaultFont)
{
	StartConversion(lpszFontString);
	logFont.lfHeight = _L(0);
	logFont.lfWidth = _L(1);
	logFont.lfEscapement = _L(2);
	logFont.lfOrientation = _L(3);
	logFont.lfWeight = _L(4);
	logFont.lfItalic = _B(5);
	logFont.lfUnderline = _B(6);
	logFont.lfStrikeOut = _B(7);
	logFont.lfCharSet = _B(8);
	logFont.lfOutPrecision = _B(9);
	logFont.lfClipPrecision = _B(10);
	logFont.lfQuality = _B(11);
	logFont.lfPitchAndFamily = _B(12);
	memcpy(logFont.lfFaceName, _S(13), LF_FACESIZE);
}

// Function name	: CXTabCtrl::Create
// Description	    : Create window as a tab control
// Return type		: BOOL 
// Argument         : UINT wStyle
// Argument         : const CRect & rect
// Argument         : CWnd * pParentWnd
// Argument         : UINT nID
BOOL CXTabCtrl::Create(UINT wStyle, const CRect & rect, CWnd * pParentWnd, UINT nID)
{
	m_nStyle = !(wStyle & TCXS_MASK) ? wStyle | TCXS_UP : wStyle;
	if (CWnd::Create(AfxRegisterWndClass(CS_DBLCLKS | CS_HREDRAW | CS_VREDRAW, AfxGetApp()->LoadStandardCursor(IDC_ARROW), (HBRUSH)GetStockObject(LTGRAY_BRUSH), NULL),
						NULL,
						m_nStyle | WS_CLIPCHILDREN | WS_CLIPSIBLINGS,
						rect, 
						pParentWnd, 
						nID))
	{
		m_nStyle &= TCXS_MASK;
		LOGFONT logFont;
		FillLogFont(logFont);
		m_font.CreateFontIndirect(&logFont);
		SetFont(&m_font);
		return TRUE;
	}
	return FALSE;
}

// Function name	: CXTabCtrl::OnInitDC
// Description	    : 
// Return type		: void 
// Argument         : CDC * pDC
void CXTabCtrl::OnInitDC(CDC * pDC)
{
	m_pFont = pDC->SelectObject(&m_font);
	pDC->SetBkMode(TRANSPARENT);
}

void CXTabCtrl::OnEndDC(CDC * pDC)
{
	pDC->SelectObject(m_pFont);
}

// Function name	: CXTabCtrl::OnPaint
// Description	    : 
// Return type		: void 
void CXTabCtrl::OnPaint() 
{
	CPaintDC dc(this); // device context for painting

	CDC dcMem; CBitmap bmp;
	CRect rect; GetClientRect(rect);
	if (dcMem.CreateCompatibleDC(&dc))
		if (bmp.CreateCompatibleBitmap(&dc, rect.Width(), rect.Height()))
		{
			OnInitDC(&dcMem);
			CBitmap* pBmp = dcMem.SelectObject(&bmp);
			dcMem.FillRect(rect, CBrush::FromHandle((HBRUSH)GetStockObject(LTGRAY_BRUSH)));
			CRect rEdge(rect);
			BOOL bUp = GetStyle() & TCXS_UP;
			if (bUp) rEdge.top += GetItemHeight() - 1;
			else rEdge.bottom -= GetItemHeight() - 1;
			dcMem.DrawEdge(rEdge, BDR_RAISEDINNER | BDR_RAISEDOUTER, BF_RECT);
			for (int i = 0; i < GetCount(); i++)
				m_arItems[i]->Draw(&dcMem, i == m_nActiveItem, GetFocus() == this);
			dc.BitBlt(0,0,rect.Width(), rect.Height(), &dcMem, 0,0, SRCCOPY);
			dcMem.SelectObject(pBmp);
			OnEndDC(&dcMem);	
		}
}

// Function name	: CXTabCtrl::AutoSize
// Description	    : Called from RecalLayout, for resize all items if need
// Return type		: void 
// Argument         : int nlWidth
// Argument         : int nAreaWidth
void CXTabCtrl::AutoSize(int nlWidth, int nAreaWidth)
{
	if (nlWidth > nAreaWidth)
		if (int nItems = GetCount())
		{
			int nDX = nAreaWidth / nItems;
			int n = 1, i;
			for (i = 0; i < nItems - 1; i++)
			{
				m_arItems[i]->SetWidth(nDX);
				m_arItems[i]->SetStart(n);
				n += nDX;
			}
			m_arItems[i]->SetWidth(nAreaWidth - n);
			m_arItems[i]->SetStart(n);
		}
}

// Function name	: CXTabCtrl::RecalcLayout
// Description	    : Called after resize, after AddItem, or DeleteItem
// Return type		: void 
void CXTabCtrl::RecalcLayout()
{
	if (int nItems = GetCount())
	{
		CRect rect; GetClientRect(rect);
		CDC* pDC = GetDC();
		OnInitDC(pDC);
		int n = 1;
		//Trying to put all items into client
		for (int i = 0; i < nItems; i++)
		{
			int ncx = m_arItems[i]->GetIdealWidth(pDC);
			m_arItems[i]->SetWidth(ncx);
			m_arItems[i]->SetStart(n);
			n += ncx;
		}
		OnEndDC(pDC);
		ReleaseDC(pDC);
		// If these exced the client area...
		AutoSize(n, rect.Width());
	}
}

// Function name	: CXTabCtrl::OnSize
// Description	    : 
// Return type		: void 
// Argument         : UINT nType
// Argument         : int cx
// Argument         : int cy
void CXTabCtrl::OnSize(UINT nType, int cx, int cy) 
{
	CWnd::OnSize(nType, cx, cy);
	
	RecalcLayout();
}

// Function name	: CXTabCtrl::GetCount
// Description	    : Return the number of items
// Return type		: int 
int CXTabCtrl::GetCount()
{
	return m_arItems.GetSize();
}

// Function name	: CXTabCtrl::OnKillFocus
// Description	    : Invalidate the items when this lose the focus
// Return type		: void 
// Argument         : CWnd* pNewWnd
void CXTabCtrl::OnKillFocus(CWnd* pNewWnd) 
{
	CWnd::OnKillFocus(pNewWnd);
	
	InvalidateNew();
	
}

// Function name	: CXTabCtrl::OnSetFocus
// Description	    : When the control receive the focus, 
// Return type		: void 
// Argument         : CWnd* pOldWnd
void CXTabCtrl::OnSetFocus(CWnd* pOldWnd) 
{
	CWnd::OnSetFocus(pOldWnd);
	
	InvalidateNew();
	
}

// Function name	: CXTabCtrl::ItemSize
// Description	    : Return Item size of nIndex item, if this is positive
// Return type		: CSize 
// Argument         : int iIndex
CSize CXTabCtrl::ItemSize(int iIndex)
{
	if (iIndex >= 0)
		if (iIndex < GetCount())
			return CSize(m_arItems[iIndex]->GetWidth(), GetItemHeight());
	CSize sResult(0, GetItemHeight());
	for (int i = 0; i < GetCount(); i++)
		sResult.cx += m_arItems[i]->GetWidth();
	return sResult;
}


// Function name	: CXTabCtrl::AddItem
// Description	    : 
// Return type		: int 
// Argument         : LPCTSTR lpszItemText
// Argument         : HICON hIcon
int CXTabCtrl::AddItem(LPCTSTR lpszItemText,LPARAM lParam, HICON hIcon)
{
	int nResult = -1;
	if (CTabItem* nNewItem = CTabItem::NewItem(lpszItemText, this))
	{
		nResult = m_arItems.Add(nNewItem);
		*nNewItem = hIcon;
		nNewItem->m_lParam = lParam;
		RecalcLayout();
		InvalidateNew();
	}
	return nResult;
}

// Function name	: CXTabCtrl::GetActiveItem
// Description	    : Return the active item
// Return type		: int 
int CXTabCtrl::GetActiveItem()
{
	return m_nActiveItem;
}

// Function name	: CXTabCtrl::DeleteItem
// Description	    : 
// Return type		: BOOL 
// Argument         : int nItem
BOOL CXTabCtrl::DeleteItem(int nItem)
{
	if (nItem >= 0)
		if (nItem < GetCount())
		{
			delete m_arItems[nItem];
			m_arItems.RemoveAt(nItem);
			if (::IsWindow(m_hWnd))
			{
				RecalcLayout();
				InvalidateNew();
			}
			return TRUE;
		}
	return FALSE;
}

// Function name	: CXTabCtrl::PreCreateWindow
// Description	    : 
// Return type		: BOOL 
// Argument         : CREATESTRUCT& cs
BOOL CXTabCtrl::PreCreateWindow(CREATESTRUCT& cs) 
{
	cs.style |= WS_CLIPCHILDREN;
	
	return CWnd::PreCreateWindow(cs);
}

// Function name	: CXTabCtrl::OnLButtonDown
// Description	    : First click will be the focus event
// Return type		: void 
// Argument         : UINT nFlags
// Argument         : CPoint point
void CXTabCtrl::OnLButtonDown(UINT nFlags, CPoint point) 
{
	SetFocus();

	
	// Activate the item, which is onto poitn
	int nResult = Point2Item(point);
	*this = nResult;
	if (nResult >= 0)
		SNDMSGNOTIFY( NM_CLICK );
		
	CWnd::OnLButtonDown(nFlags, point);
}

// Function name	: = 
// Description	    : Set the new active item o be nActiveItem
// Return type		: CXTabCtrl* CXTabCtrl::operator 
// Argument         : int nActiveItem
CXTabCtrl* CXTabCtrl::operator = (int nActiveItem)
{

	
	if (nActiveItem >= 0)
		if (nActiveItem < GetCount())
		{
			

			
			if ( m_nActiveItem != nActiveItem )
			{
				
				SNDMSGNOTIFY( TCN_SELCHANGING );
				
				switch(nActiveItem){

					case 0:
						
						AddMenuBar(GetParent()->GetSafeHwnd(),IDR_MENU3);
						break;

					case 1:
						AddMenuBar(GetParent()->GetSafeHwnd(),IDR_MENU1);
						break;

					case 2:
						AddMenuBar(GetParent()->GetSafeHwnd(),IDR_MENU4);

						break;

				}
				OnActivatePage(m_nActiveItem, nActiveItem);
				m_nActiveItem = nActiveItem;
				InvalidateNew();
				SNDMSGNOTIFY( TCN_SELCHANGE );

			}
		}
	return this;
}

// Function name	: CXTabCtrl::Point2Item
// Description	    : Return index of item from point
// Return type		: int 
// Argument         : CPoint point
int CXTabCtrl::Point2Item(CPoint point)
{
	for (int i = 0; i < GetCount(); i++)
		if (m_arItems[i]->PtInItem(point))
			return i;
	return -1;
}

// Function name	: CXTabCtrl::OnEraseBkgnd
// Description	    : Dont erase the background, because I will do in WM_PAINT
// Return type		: BOOL 
// Argument         : CDC* pDC
BOOL CXTabCtrl::OnEraseBkgnd(CDC* pDC) 
{
	return TRUE;
}

// Function name	: CXTabCtrl::OnGetDlgCode
// Description	    : We want to handle the TAB and arrow key
// Return type		: UINT 
UINT CXTabCtrl::OnGetDlgCode() 
{
	return DLGC_WANTTAB | DLGC_WANTARROWS;
}

// Function name	: CXTabCtrl::PreTranslateMessage
// Description	    : Send here few WM_COMMAND messages
// Return type		: BOOL 
// Argument         : MSG* pMsg
BOOL CXTabCtrl::PreTranslateMessage(MSG* pMsg) 
{
	// Only if we have more than one item
	if (GetCount())
		if (::TranslateAccelerator(m_hWnd, m_hAccel, pMsg))
		{
			SNDMSGKEYDOWN(pMsg->wParam, pMsg->lParam);
			return TRUE;
		}
	
	return CWnd::PreTranslateMessage(pMsg);
}

// Function name	: CXTabCtrl::OnKeyLeft
// Description	    : Left key was pressed
// Return type		: void 
void CXTabCtrl::OnKeyLeft() 
{
	*this = m_nActiveItem ? m_nActiveItem - 1 : GetCount() - 1;
}
void CXTabCtrl::GoToFriends()
{
	
	*this = 1;
}
void CXTabCtrl::GoHome()
{
	*this = 0;
}

void CXTabCtrl::GoToChat()
{
	*this = 2;
}
// Function name	: CXTabCtrl::OnKeyRight
// Description	    : Right key was pressed
// Return type		: void 
void CXTabCtrl::OnKeyRight() 
{
	*this = (m_nActiveItem + 1) % GetCount();
}

// Function name	: CXTabCtrl::OnKeySctab
// Description	    : Shift + Ctrl + Tab was pressed. Same thing as left key
// Return type		: void 
void CXTabCtrl::OnKeySctab() 
{
	OnKeyLeft();
}

// Function name	: CXTabCtrl::OnKeyCtab
// Description	    : Ctrl + Tab was pressed. Same thing as right key
// Return type		: void 
void CXTabCtrl::OnKeyCtab() 
{
	OnKeyRight();
}

// Function name	: CXTabCtrl::OnKeyEnd
// Description	    : Last item will be activated
// Return type		: void 
void CXTabCtrl::OnKeyEnd() 
{
	*this = GetCount() - 1;
}

// Function name	: CXTabCtrl::OnKeyHome
// Description	    : Frist item will be activated
// Return type		: void 
void CXTabCtrl::OnKeyHome() 
{
	*this = 0;
}

// Function name	: CXTabCtrl::OnKeyUp
// Description	    : Give the control to first child
// Return type		: void 
void CXTabCtrl::OnKeyUp() 
{
	if (CWnd* pWnd = GetWindow(GW_CHILD))
		pWnd->SetFocus();
}

// Function name	: CXTabCtrl::OnKeyDown
// Description	    : Give the control to first child
// Return type		: void 
void CXTabCtrl::OnKeyDown() 
{
	OnKeyUp();
}

// Function name	: CXTabCtrl::OnKeyStab
// Description	    : Tab was pressed 
// Return type		: void 
void CXTabCtrl::OnKeyStab() 
{
	if (CWnd* pWndDlg = GetParent())
	{
		if (CWnd* pWndNext = pWndDlg->GetNextDlgTabItem(this,
			(GetKeyState(VK_SHIFT) < 0)))
			pWndNext->SetFocus();
	}
}

void CXTabCtrl::OnKeyTab() 
{
	OnKeyStab();
}

// Function name	: CXTabCtrl::InvalidateNew
// Description	    : Call this, instead Invalidate to check the if this is a window
// Return type		: BOOL 
// Argument         : BOOL bErase
void CXTabCtrl::InvalidateNew(BOOL bErase)
{
	if (::IsWindow(m_hWnd))
		Invalidate(bErase);
}

// Function name	: CXTabCtrl::GetStyle
// Description	    : return the particular style
// Return type		: UINT 
UINT CXTabCtrl::GetStyle()
{
	return m_nStyle;
}

// Function name	: CXTabCtrl::GetItemHeight
// Description	    : return the item height of control
// Return type		: int 
int CXTabCtrl::GetItemHeight()
{
	return GetStyle() & TCXS_UP ? 22 : 24;
}

// Function name	: CXTabCtrl::_GetClientRect
// Description	    : 
// Return type		: CRect 
CRect CXTabCtrl::_GetClientRect()
{
	CRect rect;
	GetClientRect(rect);
	rect.DeflateRect(2,2);
	if (GetStyle() & TCXS_UP)
		rect.top += GetItemHeight();
	else
		rect.bottom -= GetItemHeight();
	return rect;
}

// Function name	: CXTabCtrl::OnActivatePage
// Description	    : Called when opertor = is called
// Return type		: void 
// Argument         : int nItemOld
// Argument         : int nItemNew
void CXTabCtrl::OnActivatePage(int nItemOld, int nItemNew)
{
	// do nothing here

	



}

// Function name	: Item
// Description	    : return the nIndex item
// Return type		: virtual CTabItem* 
// Argument         : int nIndex
CXTabCtrl::CTabItem* CXTabCtrl::Item(int nIndex)
{
	if (nIndex >= 0)
		if (nIndex < GetCount())
			return m_arItems[nIndex];
	return NULL;
}