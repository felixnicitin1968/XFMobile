///////////////////////////////////////////////////////////////////////////
// VividTree.cpp : Implementation of Class VividTree
///////////////////////////////////////////////////////////////////////////
//
// Copyright(C) 2005 Jim Alsup  All rights reserved
//              email: ja.alsup@gmail.com
//
// License: This code is provided "as is" with no expressed or implied 
//          warranty. You may use, or derive works from this file without
//          any restrictions except those listed below.
//
//        - This original header must be kept in the derived work.
//
//        - If your derived work is distributed in any form, you must
//          notify the author via the email address above and provide a 
//          short description of the product and intended audience.  
//
//        - You may not sell this code or a derived version of it as part of 
//          a comercial code library. 
//
//        - Offering the author a free licensed copy of any end product 
//          using this code is not required, but does endear you with a 
//          bounty of good karma.
//
///////////////////////////////////////////////////////////////////////////

//
// This owner draw tree control allows for the creation of a tree control
// that loosely resembles the user interface used by Skype's main window.
//
// Beside demonstrating the basics of creating an ownerdrawn tree control,
// but more importantly, demonstrates gradient backgrounds fills, bitmap 
// backgrounds, flicker free drawing, and how to deal with these in a 
// scrollable and resizable dialog.
//
// The underlying gradient or bitmap image is sized according the natural
// size of the visible (on screen or not) tree data.  This can be more
// readily understood and seen by opening and collasping the tree leaf
// with a long text name.  Notice the bmp or gradient resizes to the
// actual screen content.  
//
// Version History
//
// Sept 1, 2005  1.0.0  Initial Version

#include "stdafx.h"
#include "VividTree.h"
#include ".\vividtree.h"

#include "XfireCore.h"

#define _OWNER_DRAWN 1  // Set to 0 to use Windows draw code.  


// Gradient Filling Helper Routine
void GradientFillRect( CDC *pDC, CRect &rect, COLORREF col_from, COLORREF col_to, bool vert_grad )
{
	TRIVERTEX        vert[2];
	GRADIENT_RECT    mesh;

	vert[0].x      = rect.left;
	vert[0].y      = rect.top;
	vert[0].Alpha  = 0x0000;
	vert[0].Blue   = GetBValue(col_from) << 8;
	vert[0].Green  = GetGValue(col_from) << 8;
	vert[0].Red    = GetRValue(col_from) << 8;

	vert[1].x      = rect.right;
	vert[1].y      = rect.bottom; 
	vert[1].Alpha  = 0x0000;
	vert[1].Blue   = GetBValue(col_to) << 8;
	vert[1].Green  = GetGValue(col_to) << 8;
	vert[1].Red    = GetRValue(col_to) << 8;

	mesh.UpperLeft  = 0;
	mesh.LowerRight = 1;

	GradientFill( pDC->m_hDC, vert, 2, &mesh, 1, vert_grad ? GRADIENT_FILL_RECT_V : 
		GRADIENT_FILL_RECT_H );

}



// CTreeCtrlEx

IMPLEMENT_DYNAMIC(VividTree, CTreeCtrl)

VividTree::VividTree()
{
	m_gradient_bkgd_sel = RGB( 0x0, 0x0, 0xFF );	//Blueish
	m_gradient_bkgd_from = RGB( 0xf0, 0x130, 0x0 );	//White
	m_gradient_bkgd_to = RGB( 0x0, 0xc0, 0xe5 );	//Light Greyish Blue
	m_bkgd_mode = BK_MODE_GRADIENT;
	m_bmp_tiled_mode = false;
	m_gradient_horz = true;

    VERIFY( m_bmp_tree_closed.LoadBitmap( IDB_TREE_CLOSED ) ) ; 
    m_bmp_tree_closed.GetSafeHandle();
    VERIFY( m_bmp_tree_open.LoadBitmap( IDB_TREE_OPENED ) ) ; 
    m_bmp_tree_open.GetSafeHandle();
	m_icon = NULL;
}


VividTree::~VividTree()
{
    if (m_bmp_back_ground.GetSafeHandle())
        m_bmp_back_ground.DeleteObject();
    if (m_bmp_tree_closed.GetSafeHandle())
        m_bmp_tree_closed.DeleteObject();
    if (m_bmp_tree_open.GetSafeHandle())
        m_bmp_tree_open.DeleteObject();
}


BEGIN_MESSAGE_MAP(VividTree, CTreeCtrl)
	ON_WM_ERASEBKGND()
#if _OWNER_DRAWN
	ON_WM_PAINT()
#endif
	ON_NOTIFY_REFLECT(TVN_ITEMEXPANDING, OnTvnItemexpanding)
	ON_NOTIFY_REFLECT(TVN_SELCHANGED, OnItemChanged)
	ON_NOTIFY_REFLECT(TVN_SELCHANGING, OnItemChanging)
    //ON_NOTIFY_REFLECT(NM_DBLCLK, OnDblclk)

	
	 
//	ON_WM_CREATE()
END_MESSAGE_MAP()



// CVividTree message handlers


BOOL VividTree::OnEraseBkgnd(CDC* pDC)
{
    // nothing to do here -- see OnPaint
	return TRUE;
}


#if _OWNER_DRAWN
void VividTree::OnPaint()
{
	CPaintDC dc(this);	// Device context for painting
	CDC dc_ff;			// Memory base device context for flicker free painting
	CBitmap bm_ff;		// The bitmap we paint into
	CBitmap *bm_old;
	CFont *font, *old_font;
	CFont fontDC;
	int old_mode;

	GetClientRect(&m_rect);
	SCROLLINFO scroll_info;
	// Determine window portal to draw into taking into account
	// scrolling position
	if ( GetScrollInfo( SB_HORZ, &scroll_info, SIF_POS | SIF_RANGE ) )
	{
		m_h_offset = -scroll_info.nPos;
		m_h_size = max( scroll_info.nMax+1, m_rect.Width());
	}
	else
	{
		m_h_offset = m_rect.left;
		m_h_size = m_rect.Width();
	}
	if (0)// GetScrollInfo( SB_VERT, &scroll_info, SIF_POS | SIF_RANGE ) )
	{
		if ( scroll_info.nMin == 0 && scroll_info.nMax == 100) 
			scroll_info.nMax = 0;

		//m_v_offset = -scroll_info.nPos * GetItemHeight();
		//m_v_size = max( (scroll_info.nMax+2)*((int)GetItemHeight()+1), m_rect.Height() );
	}
	else
	{
		m_v_offset = m_rect.top;
		m_v_size = m_rect.Height();
	}

	// Create an offscreen dc to paint with (prevents flicker issues)
	dc_ff.CreateCompatibleDC( &dc );
    bm_ff.CreateCompatibleBitmap( &dc, m_rect.Width(), m_rect.Height() );
    // Select the bitmap into the off-screen DC.
    bm_old = (CBitmap *)dc_ff.SelectObject( &bm_ff );
	// Default font in the DC is not the font used by 
	// the tree control, so grab it and select it in.
	font = GetFont();
	old_font = dc_ff.SelectObject( font );
	// We're going to draw text transparently
	old_mode = dc_ff.SetBkMode( TRANSPARENT );

	DrawBackGround( &dc_ff );
	DrawItems( &dc_ff );

    // Now Blt the changes to the real device context - this prevents flicker.
    dc.BitBlt( m_rect.left, m_rect.top, m_rect.Width(), m_rect.Height(), &dc_ff, 0, 0, SRCCOPY);

	dc_ff.SelectObject( old_font );
	dc_ff.SetBkMode( old_mode );
    dc_ff.SelectObject( bm_old );
}
#endif


// Draw TreeCtrl Background - 
void VividTree::DrawBackGround( CDC* pDC )
{
	BkMode mode = m_bkgd_mode;

	if ( mode == BK_MODE_BMP )
	{
		if ( !m_bmp_back_ground.GetSafeHandle() )
			mode = BK_MODE_GRADIENT;
	}
	if ( mode == BK_MODE_GRADIENT )
	{
		GradientFillRect( pDC, 
			CRect( m_h_offset, m_v_offset, m_h_size + m_h_offset, m_v_size + m_v_offset ), 
			m_gradient_bkgd_from, m_gradient_bkgd_to, !m_gradient_horz );
	}
	else if ( mode == BK_MODE_FILL )
		pDC->FillSolidRect( m_rect, pDC->GetBkColor() ); 
	else if ( mode == BK_MODE_BMP )
	{
		BITMAP bm;
		CDC dcMem;
	      
		VERIFY(m_bmp_back_ground.GetObject(sizeof(bm), (LPVOID)&bm));
		dcMem.CreateCompatibleDC(NULL);
		CBitmap* bmp_old = (CBitmap*)dcMem.SelectObject( &m_bmp_back_ground ); 
		
		if ( m_bmp_tiled_mode ) 	// BitMap Tile Mode
		{
			for ( int y = 0; y <= (m_v_size / bm.bmHeight); y++ )
			{
				for ( int x = 0; x <= (m_h_size / bm.bmWidth); x++ )
				{
					pDC->BitBlt((x*bm.bmWidth) + m_h_offset, (y*bm.bmHeight) + m_v_offset,
						bm.bmWidth, bm.bmHeight, &dcMem, 0, 0, SRCCOPY);
				}
			}
		}
		else  // BITMAP Stretch Mode
		{
			pDC->StretchBlt( m_h_offset, m_v_offset, m_h_size, m_v_size, 
				&dcMem, 0, 0, bm.bmWidth, bm.bmHeight, SRCCOPY );
		}
		// CleanUp
		dcMem.SelectObject( bmp_old );
	}
	else
		ASSERT( 0 );  // Unknown BackGround Mode
}



// Draw TreeCtrl Items
void VividTree::DrawItems( CDC *pDC )
{
	// draw items
	HTREEITEM show_item, parent;
	CRect rc_item;
	CString name;
	COLORREF color;
	DWORD tree_style;
	BITMAP bm;
	CDC dc_mem;
	CBitmap *button;
	int count = 0;
	int state;
	bool selected;
	bool has_children;

	show_item = GetFirstVisibleItem();
	if ( show_item == NULL )
		return;

	dc_mem.CreateCompatibleDC(NULL);
	color = pDC->GetTextColor();
	
	//color = pDC->SetTextColor(RGB(0x255,0x255,0x255) );//xxx

	color= pDC->SetTextColor( RGB(0x8A,0xBA,0xF1) );

	tree_style = ::GetWindowLong( m_hWnd, GWL_STYLE ); 

	do
	{
		state = GetItemState( show_item, TVIF_STATE );
		parent = GetParentItem( show_item );
		has_children = ItemHasChildren( show_item ) || parent == NULL;
		selected = (state & TVIS_SELECTED) && ((this == GetFocus()) || 
				(tree_style & TVS_SHOWSELALWAYS));

		if ( GetItemRect( show_item, rc_item, TRUE ) )
		{
			if ( has_children  || selected )
			{
				COLORREF from;
				CRect rect;
				// Show 
				if (1)//selected )
					from = m_gradient_bkgd_sel;
				else
					from = m_gradient_bkgd_to - (m_gradient_bkgd_from - m_gradient_bkgd_to);
				rect.top = rc_item.top;
				rect.bottom = rc_item.bottom;
				rect.right = m_h_size + m_h_offset;
				if ( !has_children )
					rect.left = rc_item.left + m_h_offset;
				else
					rect.left = m_h_offset;
				GradientFillRect( pDC, rect, from, m_gradient_bkgd_to, FALSE );
				if (has_children){


						pDC->SetTextColor(RGB(0x12,0x28,0x3f) );
				}else {
			
					// pDC->SetTextColor( RGB(0x255,0x255,0x255) );

					 pDC->SetTextColor( RGB(0x8A,0xBA,0xF1) );

					

				}
				if ( has_children )
				{
					// Draw an Open/Close button
					if ( state & TVIS_EXPANDED )
						button = &m_bmp_tree_open;
					else
						button = &m_bmp_tree_closed;
					VERIFY(button->GetObject(sizeof(bm), (LPVOID)&bm));
					CBitmap *bmp_old = (CBitmap*)dc_mem.SelectObject(button); 
					pDC->BitBlt( rc_item.left - bm.bmWidth - 2, rc_item.top, bm.bmWidth, bm.bmHeight, 
						&dc_mem, 0, 0, SRCAND );
					// CleanUp
					dc_mem.SelectObject( bmp_old );
				}
			}
			if ( !has_children )
			{
				// lookup the ICON instance (if any) and draw dit
				/*HICON icon;
				icon = GetItemIcon( show_item );
				if ( icon != NULL ) 
				DrawIconEx( pDC->m_hDC, rc_item.left - 18, rc_item.top, icon, 16, 16,0,0, DI_NORMAL );
				*/


			 long userid=GetItemData(show_item);


			 if (GetItemData(GetParentItem(show_item))==CONV_SECTION)
			 {
				 
				 

				 if (CXfireCore::isFriendAway(userid)){

					 HICON icon;
					 icon = GetAwayIcon( show_item );
					 DrawIconEx( pDC->m_hDC, rc_item.left - 18, rc_item.top+0, icon, 16, 16,0,0, DI_NORMAL );
				 }else{
					 HICON icon;
					 icon = GetOnlineIcon( show_item );
					 DrawIconEx( pDC->m_hDC, rc_item.left - 18, rc_item.top+0, icon, 16, 16,0,0, DI_NORMAL );
				 }

				 //HICON icon;
				 //icon = GetOnlineIcon( show_item );
				// DrawIconEx( pDC->m_hDC, rc_item.left - 18, rc_item.top, icon, 16, 16,0,0, DI_NORMAL );
				 //pDC->SetTextColor( RGB(255,255,255) );
				  pDC->SetTextColor( RGB(0x8A,0xBA,0xF1) );


			 }else

			 if (CXfireCore::isFriendAway(userid))
			 {

				 HICON icon;
				 icon = GetAwayIcon( show_item );
				 DrawIconEx( pDC->m_hDC, rc_item.left - 18, rc_item.top+0, icon, 16, 16,0,0, DI_NORMAL );
			 }else{
				 HICON icon;
				 icon = GetOnlineIcon( show_item );
				 DrawIconEx( pDC->m_hDC, rc_item.left - 18, rc_item.top+0, icon, 16, 16,0,0, DI_NORMAL );
			 }

			 int gameid=CXfireCore::getGameId(userid);
			 if (gameid !=0 && gameid>=4096 && gameid<=6047){

              	 HICON hIcon = CXfireCore::geContactGameImage(userid);
				 
				 if (hIcon!=NULL){
				  
					 DrawIconEx( pDC->m_hDC, rc_item.left - 18, rc_item.top+0, hIcon, 16, 16,0,0, DI_NORMAL );

				 }
				
				
				


			 
			 }
			
			}
			name = GetItemText( show_item );
			rc_item.DeflateRect( 0,1,0,1 );
			if (selected )
			{
				if ( !has_children  ) {
					pDC->SetTextColor( GetSysColor(RGB(255,255,255)) ); //COLOR_HIGHLIGHTTEXT
				
				}
				COLORREF col = pDC->GetBkColor();
				//pDC->SetTextColor( RGB(255,255,255) );
				 pDC->SetTextColor( RGB(0x8A,0xBA,0xF1) );
				pDC->DrawText( name, rc_item, DT_LEFT );
				pDC->SetTextColor( color );
				pDC->SetBkColor( col );
			}
			else
			{
				//pDC->SetTextColor(RGB(255,255,255));
				 pDC->SetTextColor( RGB(0x8A,0xBA,0xF1) );
				pDC->DrawText( name, rc_item, DT_LEFT );
				
			}
			//if ( state & TVIS_BOLD )
			//	pDC->SelectObject( font );
		}
	} while ( (show_item = GetNextVisibleItem( show_item )) != NULL );
}



void VividTree::SetBitmapID( UINT id )
{
	// delete any existing bitmap
    if (m_bmp_back_ground.GetSafeHandle())
        m_bmp_back_ground.DeleteObject();
	// add in the new bitmap
    VERIFY( m_bmp_back_ground.LoadBitmap( id ) ) ; 
    m_bmp_back_ground.GetSafeHandle();
}



// Determine if a referenced item is visible within the control window
bool VividTree::ItemIsVisible( HTREEITEM item )
{
	HTREEITEM scan_item;
	scan_item = GetFirstVisibleItem();
	while ( scan_item != NULL )
	{
		if ( item == scan_item )
			return true;
		scan_item = GetNextVisibleItem( scan_item );
	}
	return false;
}


// For a given tree node return an ICON for display on the left side.
// This default implementation only returns one icon.
// This function is virtual and meant to be overriden by deriving a class
// from VividTree and supplying your own icon images. 
HICON VividTree::GetOnlineIcon( HTREEITEM item )		
{
	return m_icon;  // default implementation - overridable
}


// If the background is a bitmap, and a tree is expanded/collapsed we
// need to redraw the entire background because windows moves the bitmap
// up (on collapse) destroying the position of the background.
void VividTree::OnTvnItemexpanding(NMHDR *pNMHDR, LRESULT *pResult)
{
	LPNMTREEVIEW pNMTreeView = reinterpret_cast<LPNMTREEVIEW>(pNMHDR);
	if ( GetBkMode() == VividTree::BK_MODE_BMP && ItemIsVisible( pNMTreeView->itemNew.hItem ) )
		Invalidate();  // redraw everything
	*pResult = 0;
}




void VividTree::OnItemChanging(NMHDR* pNMHDR, LRESULT* pResult)
{

	
		

	

}
void VividTree::OnItemChanged(NMHDR* pNMHDR, LRESULT* pResult)

{
	



	LPNMTREEVIEW pNMTreeView = reinterpret_cast<LPNMTREEVIEW>(pNMHDR);

	long userid=GetItemData(pNMTreeView->itemNew.hItem);

	if (!userid)  return;


	if (g_SelectedUserID!=userid){
	
		g_SelectedUserID=userid;

	    return;
	}



	XfireContact *xontact=CXfireCore::getContactByID(g_SelectedUserID);

	if (!xontact)  
	{
	
		xontact=CXfireCore::getClanMember(g_SelectedUserID);
		if (xontact==NULL) {
		
			 return;
		}

	}



	g_hSelectedItem=pNMTreeView->itemNew.hItem;
	//::SendMessage(g_hMainDlg,WM_NEW_CHAT_WND,(WPARAM)xontact,0);


		

}

void VividTree::OnDblclk(NMHDR* pNMHDR, LRESULT* pResult)
{
  /*LPNMTREEVIEW pNMTreeView = reinterpret_cast<LPNMTREEVIEW>(pNMHDR);

	long userid=GetItemData(pNMTreeView->itemNew.hItem);

	if (!userid)  return;


	
    g_SelectedUserID=userid;

	   
	



	XfireContact *xontact=CXfireCore::getContactByID(g_SelectedUserID);

	if (!xontact) return;

	g_hSelectedItem=pNMTreeView->itemNew.hItem;
	::SendMessage(g_hMainDlg,WM_NEW_CHAT_WND,(WPARAM)xontact,0);*/

}
