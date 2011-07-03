/************************************
  REVISION LOG ENTRY
  Revision By: Mihai Filimon
  Revised on 2/1/99 4:16:26 PM
  Comments: // XTabCtrl.h : header file
 ************************************/

#if !defined(AFX_XTABCTRL_H__7A55DF62_B8FC_11D2_8766_0040055C08D9__INCLUDED_)
#define AFX_XTABCTRL_H__7A55DF62_B8FC_11D2_8766_0040055C08D9__INCLUDED_

#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000
// XTabCtrl.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CXTabCtrl window
#define TCXS_UP			1
#define TCXS_DOWN		2
#define TCXS_MASK		3
#include <afxtempl.h>
static const TCHAR* _defaultFont = _T("-11,0,0,0,400,0,0,0,0,1,2,1,34,MS Sans Serif");
class CXTabCtrl : public CWnd
{
public:
	class CTabItem : public CString
	{
		friend class CXTabCtrl;
		public:
			LPARAM m_lParam;
			virtual CRect GetItemRect();
			static CTabItem* NewItem(LPCTSTR lpszItemText, CXTabCtrl* pParentCtrl);
			CTabItem(LPCTSTR lpszItemText, CXTabCtrl* pParentCtrl);
			virtual CTabItem* operator = (HICON hIcon);
			inline int GetWidth() { return m_nWidth; };
			inline int GetStart() { return m_nStart; };
		protected:
			virtual BOOL PtInItem(CPoint point);
			virtual void DrawText(CDC* pDC, BOOL bActive, BOOL bFocused);
			virtual int DrawIcon(CDC* pDC, BOOL bActive);
			virtual void DrawFrame(CDC* pDC, BOOL bActive);
			inline void SetWidth(int nWidth) { m_nWidth = nWidth; };
			inline void SetStart(int nStart) { m_nStart = nStart; };
			virtual int GetIdealWidth(CDC* pDC);
			virtual void Draw(CDC* pDC, BOOL bActive = FALSE, BOOL bFocused = FALSE);
			// Atributtes
			CXTabCtrl* m_pParentCtrl;
			static int m_nDXBorder;
			HICON m_hIcon;
			int m_nWidth;
			int m_nStart;
	};

	CArray<CTabItem*, CTabItem*> m_arItems;
// Construction
public:
	CXTabCtrl();

// Attributes
public:

// Operations
public:
	CXTabCtrl* operator = (int nActiveItem);

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CXTabCtrl)
	public:
	virtual BOOL PreTranslateMessage(MSG* pMsg);
	protected:
	virtual BOOL PreCreateWindow(CREATESTRUCT& cs);
	//}}AFX_VIRTUAL

// Implementation
public:
	virtual CXTabCtrl::CTabItem* Item(int nIndex);
	virtual int GetItemHeight();
	virtual UINT GetStyle();
	virtual int GetActiveItem();
	virtual int GetCount();
	virtual CSize ItemSize(int iIndex = -1);
	virtual BOOL DeleteItem(int nItem);
	virtual int AddItem(LPCTSTR lpszItemText, LPARAM lParam = NULL, HICON hIcon = NULL);
	virtual BOOL Create(UINT wStyle, const CRect& rect, CWnd* pParentWnd, UINT nID);
	virtual ~CXTabCtrl();
	void    GoHome();
	void    GoToFriends();
	void    GoToChat();

	// Generated message map functions
public:
	virtual void OnActivatePage(int nItemOld, int nItemNew);
	virtual CRect _GetClientRect();
	UINT m_nStyle;
	HACCEL m_hAccel;
	virtual int Point2Item(CPoint point);
	virtual void AutoSize(int nlWidth, int nAreaWidth);
	int m_nActiveItem;
	virtual void OnInitDC(CDC* pDC);
	virtual void OnEndDC(CDC* pDC);
	virtual void RecalcLayout();
	int m_nDY;
	CFont m_font, *m_pFont;
	//{{AFX_MSG(CXTabCtrl)
	afx_msg void OnPaint();
	afx_msg void OnSize(UINT nType, int cx, int cy);
	afx_msg void OnSetFocus(CWnd* pOldWnd);
	afx_msg void OnLButtonDown(UINT nFlags, CPoint point);
	afx_msg BOOL OnEraseBkgnd(CDC* pDC);
	afx_msg UINT OnGetDlgCode();
	afx_msg void OnKeyLeft();
	afx_msg void OnKeyRight();
	afx_msg void OnKeySctab();
;
	afx_msg void OnKeyCtab();
	afx_msg void OnKeyEnd();
	afx_msg void OnKeyHome();
	afx_msg void OnKeyStab();
	afx_msg void OnKeyTab();
	afx_msg void OnKillFocus(CWnd* pNewWnd);
	afx_msg void OnKeyUp();
	afx_msg void OnKeyDown();
	
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
public:
	void InvalidateNew(BOOL bErase = TRUE);
};

/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Developer Studio will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_XTABCTRL_H__7A55DF62_B8FC_11D2_8766_0040055C08D9__INCLUDED_)
