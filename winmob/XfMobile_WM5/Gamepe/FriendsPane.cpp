// FriendsPane.cpp : implementation file
//

#include "stdafx.h"
#include "Gamepe.h"
#include "FriendsPane.h"
#include "XfireCore.h"
#include <Htmlctrl.h>
// CFriendsPane dialog

IMPLEMENT_DYNAMIC(CFriendsPane, CDialog)



BOOL CFriendsPane::CreateADWindow(RECT rect)

{


	return m_adImage.Create(L"Push Button",WS_CHILD |  BS_FLAT  |WS_VISIBLE |BS_OWNERDRAW    ,rect,this,0x8801);
	



}
CFriendsPane::CFriendsPane(CWnd* pParent /*=NULL*/)
	: CXPropertyPage(CFriendsPane::IDD, pParent)
{
     m_pFriendsTreeCtrl=new VividTree();
}

CFriendsPane::~CFriendsPane()
{

	 delete m_pFriendsTreeCtrl;
}

void CFriendsPane::DoDataExchange(CDataExchange* pDX)
{
	CXPropertyPage::DoDataExchange(pDX);
}


BEGIN_MESSAGE_MAP(CFriendsPane, CXPropertyPage)
	
	
	ON_MESSAGE(WM_ADD_FRIEND, OnAddFriend)
	ON_MESSAGE(WM_REMOVE_FRIEND, OnRemoveFriend)
    ON_MESSAGE(WM_ADD_CLANS, OnAddClans)
	ON_MESSAGE(WM_FRIEND_STATUS, OnFriendStatus)
	ON_MESSAGE(WM_ADDCLAN_MEMBERS, OnClanMembers)
	ON_MESSAGE(WM_CONNECTION_STATUS, OnConnectionStatus)
	ON_MESSAGE(WM_ADD_CONVERSATION, OnAddConversation)
	ON_MESSAGE(WM_RECV_IM, OnRecvIM)
	//ON_COMMAND(ID_OPTIONS_VIEWPROFILE, &CContactsPane::OnOptionsViewprofile)

	ON_WM_SIZE()
	ON_WM_SETTINGCHANGE()
	ON_COMMAND(ID_MENU_INVITE, &CFriendsPane::OnMenuInvite)
	ON_COMMAND(0x8801, &CFriendsPane::OnAdClick)
END_MESSAGE_MAP()


// CFriendsPane message handlers



void CFriendsPane::OnAdClick()
{

	

	AfxBeginThread(MetricClickNotificationThread,0);
	
	SHELLEXECUTEINFO ShExecInfo;

	ShExecInfo.cbSize = sizeof(SHELLEXECUTEINFO);
	ShExecInfo.fMask = NULL;
	ShExecInfo.hwnd = NULL;
	ShExecInfo.lpVerb = NULL;
	ShExecInfo.lpFile = L"iexplore.exe" ;
	ShExecInfo.lpParameters = g_szLinkToAd;
	ShExecInfo.lpDirectory = NULL;
	ShExecInfo.nShow = SW_SHOWMAXIMIZED;
	ShExecInfo.hInstApp = NULL;

	ShellExecuteEx(&ShExecInfo);
}
LRESULT CFriendsPane::OnRecvIM(WPARAM wParam, LPARAM lParam)
{


	XfireContact *pContact=(XfireContact*)wParam;

	char *pMsg=(char*)lParam;


	WCHAR wMsg[0x100];

	WCHAR wName[0x200];

	if (pContact->cNickname[0]==0){


		MultiByteToWideChar(CP_UTF8, 0, pContact->cUsername, -1, wName, 0x100);

	}else{

		MultiByteToWideChar(CP_UTF8, 0, pContact->cNickname, -1, wName, 0x100);

	}


	lstrcat(wName,L":\r\n");

	MultiByteToWideChar(CP_UTF8, 0, pMsg, -1, wMsg, 0x100);


	lstrcat(wName,wMsg);


	if (pContact->nTotalRecivedMessages %100 ==0 ){


		pContact->nTotalRecivedMessages=0;
		  pContact->messages.RemoveAll();


	}



	AddIconNotification(g_hMainDlg,AfxGetApp()->LoadIcon(IDR_MAINFRAME),3);

	::SendMessage(g_hActiveChatWindow,WM_RECV_IM,pContact->userid,(LPARAM)wName);

	lstrcat(wName,L"\r\n");

	CString historyMsg=CString(wName);

	pContact->messages.Add(historyMsg);

	delete []pMsg;

	return 0;
}



LRESULT CFriendsPane::OnAddConversation(WPARAM wParam, LPARAM lParam)
{

	
	XfireContact *pContact=(XfireContact*)wParam;
	WCHAR wName[0x100]={' '};

	if (m_pFriendsTreeCtrl->ItemHasChildren(m_hConvSection))
	{
		HTREEITEM hNextItem;
		HTREEITEM hChildItem = m_pFriendsTreeCtrl->GetChildItem(m_hConvSection);

		while (hChildItem != NULL)
		{
			hNextItem = m_pFriendsTreeCtrl->GetNextItem(hChildItem, TVGN_NEXT);

			if (m_pFriendsTreeCtrl->GetItemData(hChildItem)==pContact->userid){
			
				if (pContact->cNickname[0]==0){


					MultiByteToWideChar(CP_UTF8, 0, pContact->cUsername, -1, wName+1, 0x100);

				}else{

					MultiByteToWideChar(CP_UTF8, 0, pContact->cNickname, -1, wName+1, 0x100);

				}

				pContact->nTotalRecivedMessages++;

				WCHAR szData[0x100];
				wsprintf(szData,L"(+%d)",pContact->nTotalRecivedMessages);

				lstrcat(wName,szData);
				m_pFriendsTreeCtrl->SetItemText(hChildItem,wName);

				m_pFriendsTreeCtrl->Invalidate();
				return 1;

			}
			hChildItem = hNextItem;
		}
	}




    pContact->nTotalRecivedMessages=0;
	if (pContact->cNickname[0]==0){


		 MultiByteToWideChar(CP_UTF8, 0, pContact->cUsername, -1, wName+1, 0x100);

	}else{

        MultiByteToWideChar(CP_UTF8, 0, pContact->cNickname, -1, wName+1, 0x100);

	}

	WCHAR wzOnline[0x100];


	
	wsprintfW(wzOnline,L"Conversation");

	m_pFriendsTreeCtrl->SetItemText(m_hConvSection,wzOnline);


	HTREEITEM hItem=m_pFriendsTreeCtrl->InsertItem(wName,m_hConvSection,TVI_LAST );

	m_pFriendsTreeCtrl->SetItemData(hItem,(DWORD_PTR)pContact->userid);

    m_pFriendsTreeCtrl->Expand(m_hConvSection,TVE_EXPAND);

    m_pFriendsTreeCtrl->Invalidate();

	return 0;
}


LRESULT CFriendsPane::OnConnectionStatus(WPARAM wParam, LPARAM lParam)
{


	
	m_pFriendsTreeCtrl->DeleteAllItems();
	
	m_hConvSection=m_pFriendsTreeCtrl->InsertItem(L"Conversations",TVI_ROOT,TVI_LAST );
	
	m_pFriendsTreeCtrl->SetItemData(m_hConvSection,CONV_SECTION);


	m_hOnlineFriendsSection= m_pFriendsTreeCtrl->InsertItem(L"Online",TVI_ROOT,TVI_LAST );
	
	m_pFriendsTreeCtrl->SetItemData(m_hOnlineFriendsSection,ONLINE_SECTION);


	m_pFriendsTreeCtrl->Expand(m_hOnlineFriendsSection,TVE_EXPAND   );


	return 0;
}
 


XfireContact * CFriendsPane::getClanMember(long userid)
{


	for (int i=0; i<CXfireCore::s_nTotalClans; i++){


		for (int j=0; j<CXfireCore::s_ClansList[i].usercount; j++){


			XfireContact *pContact=CXfireCore::s_ClansList[i]._listContacts.at(j);

			if (pContact->userid==userid) {

				
				   return pContact;

			}
		}
	}

	return NULL;


}

BOOL CFriendsPane::addClanMember(long userid)
{



	WCHAR wName[0x100]={' '};


	for (int i=0; i<CXfireCore::s_nTotalClans; i++){


		for (int j=0; j<CXfireCore::s_ClansList[i].usercount; j++){


			XfireContact *pContact=CXfireCore::s_ClansList[i]._listContacts.at(j);

			if (pContact->userid==userid) {


				if (pContact->cNickname[0]==0){



					MultiByteToWideChar(CP_UTF8, 0, pContact->cUsername, -1, wName+1, 0x100);

				}else{

					MultiByteToWideChar(CP_UTF8, 0, pContact->cNickname, -1, wName+1, 0x100);

				}


				HTREEITEM hItem=m_pFriendsTreeCtrl->InsertItem(wName,CXfireCore::s_ClansList[i].hTreeIndex,TVI_LAST );

				
	            m_pFriendsTreeCtrl->SetItemData(hItem,(DWORD_PTR)pContact->userid);

				pContact->hTreeIndex=hItem;
				m_pFriendsTreeCtrl->Invalidate();
				return TRUE;
			}
		}


	}



	return FALSE;

}


BOOL CFriendsPane::removeClanMember(long userid)
{

	
	WCHAR wName[0x100]={' '};
	for (int i=0; i<CXfireCore::s_nTotalClans; i++){


		for (int j=0; j<CXfireCore::s_ClansList[i].usercount; j++){


			XfireContact *pContact=CXfireCore::s_ClansList[i]._listContacts.at(j);

			if (pContact->userid==userid) {


				if (pContact->cNickname[0]==0){



					MultiByteToWideChar(CP_UTF8, 0, pContact->cUsername, -1, wName+1, 0x100);

				}else{

					MultiByteToWideChar(CP_UTF8, 0, pContact->cNickname, -1, wName+1, 0x100);

				}


				m_pFriendsTreeCtrl->DeleteItem(pContact->hTreeIndex);
	            pContact->hTreeIndex=NULL;

				m_pFriendsTreeCtrl->Invalidate();
				return TRUE;
			}
		}


	}



	return FALSE;

}



LRESULT CFriendsPane::OnClanMembers(WPARAM wParam, LPARAM lParam)

{

/*


LRESULT CFriendsPane::OnRemoveFriend(WPARAM wParam, LPARAM)
{
	// callback from the client socket thread to signify a connection has
	// been tear down and the client socket thread has terminated.
	//DbgMsg(L"OnRemoveFriend");

	XfireContact *pContact=(XfireContact*)wParam;

	

	WCHAR wName[0x100]={0};

	if (pContact->cNickname[0]==0){


		 MultiByteToWideChar(CP_UTF8, 0, pContact->cUsername, -1, wName, 0x100);

	}else{

         MultiByteToWideChar(CP_UTF8, 0, pContact->cNickname, -1, wName, 0x100);

	}


	WCHAR wzOnline[0x100];

	wsprintfW(wzOnline,L"Online(%d)",CXfireCore::s_nTotalOnlineContacts);
	m_pFriendsTreeCtrl->SetItemText(m_hOnlineFriendsSection,wzOnline);

	m_pFriendsTreeCtrl->DeleteItem(pContact->hTreeIndex);
	pContact->hTreeIndex=NULL;
	return 0;
}



	return 0;
	long clanid=(long)wParam;

	WCHAR wName[0x100]={' '};

	static  XfireClan*     pClan=CXfireCore::getClanByID(clanid);

	if (pClan){
             

		for (int i=0; i<pClan->usercount; i++){


			XfireContact *xcontact= (XfireContact*) pClan->_listContacts.at(i);

			if (!xcontact) break;
		
				if (xcontact->cNickname[0]==0){



					MultiByteToWideChar(CP_UTF8, 0, xcontact->cUsername, -1, wName+1, 0x100);

				}else{

					MultiByteToWideChar(CP_UTF8, 0, xcontact->cNickname, -1, wName+1, 0x100);

				}


				
				HTREEITEM hItem=m_pFriendsTreeCtrl->InsertItem(wName,pClan->hTreeIndex,TVI_LAST );

				//m_pFriendsTreeCtrl->SetItemData(hItem,xcontact->userid);
				



		}


	}

	m_pFriendsTreeCtrl->Invalidate();
*/
	return 0;
}

LRESULT CFriendsPane::OnFriendStatus(WPARAM wParam, LPARAM lParam)

{


	XfireContact *pXfireContact=(XfireContact*)wParam;

	WCHAR wName[0x200]={' '};

	WCHAR wStatusMsg[0x100]={0};
	MultiByteToWideChar(CP_UTF8, 0,pXfireContact->cStatusMsg, -1, wStatusMsg, 0x100);


	pXfireContact->uStatus=MISTATUS_ONLINE;

	if (strstr(pXfireContact->cStatusMsg,"(AFK")!=0){

		pXfireContact->uStatus=MISTATUS_AWAY;

	}


	if (pXfireContact->cGamename[0]!=0){


		if (pXfireContact->cNickname[0]==0){



			MultiByteToWideChar(CP_UTF8, 0, pXfireContact->cUsername, -1, wName+1, 0x100);

		}else{

			MultiByteToWideChar(CP_UTF8, 0, pXfireContact->cNickname, -1, wName+1, 0x100);

		}


		WCHAR wzGame[0x100];
		MultiByteToWideChar(CP_UTF8, 0, pXfireContact->cGamename, -1, wzGame, 0x100);

		lstrcat(wName,L" [");

		lstrcat(wName,wzGame);
		lstrcat(wName,L" ]");
		
		HTREEITEM hChildItem=pXfireContact->hTreeIndex;

		m_pFriendsTreeCtrl->SetItemText(hChildItem,wName);
		


	}else{


		if (strstr(pXfireContact->cStatusMsg,"(AFK")==0) {
			if (pXfireContact->cNickname[0]==0){



				MultiByteToWideChar(CP_UTF8, 0, pXfireContact->cUsername, -1, wName+1, 0x100);

			}else{

				MultiByteToWideChar(CP_UTF8, 0, pXfireContact->cNickname, -1, wName+1, 0x100);

			}
			lstrcat(wName,L" [");

			lstrcat(wName,wStatusMsg);
			lstrcat(wName,L" ]");
			HTREEITEM hChildItem=pXfireContact->hTreeIndex;
			m_pFriendsTreeCtrl->SetItemText(hChildItem,wName);
		}

	}



	m_pFriendsTreeCtrl->Expand(m_hOnlineFriendsSection,TVE_EXPAND);


	m_pFriendsTreeCtrl->Invalidate();



	return 0;
}
	
LRESULT CFriendsPane::OnAddClans(WPARAM wParam, LPARAM lParam)
{

	WCHAR wName[0x100]={0};
	for (int i=0; i<CXfireCore::s_nTotalClans; i++){


		

		 MultiByteToWideChar(CP_UTF8, 0,CXfireCore::s_ClansList[i].name, -1, wName, 0x100);

         CXfireCore::s_ClansList[i].hTreeIndex=
         m_pFriendsTreeCtrl->InsertItem(wName,TVI_ROOT,TVI_LAST );
	}

	return 0;
}


LRESULT CFriendsPane::OnAddFriend(WPARAM wParam, LPARAM lParam)
{
	// callback from the client socket thread to signify a connection has
	// been tear down and the client socket thread has terminated.
	
	//DbgMsg(L"OnAddFriend");

	XfireContact *pContact=(XfireContact*)wParam;

	if (addClanMember(pContact->userid)) return 0;



	WCHAR wName[0x100]={' '};

	if (pContact->cNickname[0]==0){


		 MultiByteToWideChar(CP_UTF8, 0, pContact->cUsername, -1, wName+1, 0x100);

	}else{

        MultiByteToWideChar(CP_UTF8, 0, pContact->cNickname, -1, wName+1, 0x100);

	}

	WCHAR wzOnline[0x100];

	wsprintfW(wzOnline,L"Online(%d)",CXfireCore::s_nTotalOnlineContacts);

	m_pFriendsTreeCtrl->SetItemText(m_hOnlineFriendsSection,wzOnline);


	pContact->hTreeIndex=m_pFriendsTreeCtrl->InsertItem(wName,m_hOnlineFriendsSection,TVI_LAST );

	m_pFriendsTreeCtrl->SetItemData(pContact->hTreeIndex,(DWORD_PTR)pContact->userid);


	
	m_pFriendsTreeCtrl->SortChildren(m_hOnlineFriendsSection);





	return 0;
}
LRESULT CFriendsPane::OnRemoveFriend(WPARAM wParam, LPARAM)
{
	// callback from the client socket thread to signify a connection has
	// been tear down and the client socket thread has terminated.
	//DbgMsg(L"OnRemoveFriend");

	XfireContact *pContact=(XfireContact*)wParam;

	if (removeClanMember(pContact->userid)) return 0;

	WCHAR wName[0x100]={0};

	if (pContact->cNickname[0]==0){


		 MultiByteToWideChar(CP_UTF8, 0, pContact->cUsername, -1, wName, 0x100);

	}else{

         MultiByteToWideChar(CP_UTF8, 0, pContact->cNickname, -1, wName, 0x100);

	}


	WCHAR wzOnline[0x100];

	wsprintfW(wzOnline,L"Online(%d)",CXfireCore::s_nTotalOnlineContacts);
	m_pFriendsTreeCtrl->SetItemText(m_hOnlineFriendsSection,wzOnline);

	

	m_pFriendsTreeCtrl->DeleteItem(pContact->hTreeIndex);
	pContact->hTreeIndex=NULL;
	return 0;
}


void CFriendsPane::OnInlineImage(const CString &strHref, DWORD dwCookie)
{
   // Here handle image loading
  
   // Set image if all is OK
  /* if ( bImageLoadedOK )
   {
   INLINEIMAGEINFO imageInfo;
   imageInfo.dwCookie    = dwCookieValue;
   imageInfo.bOwnBitmap  = FALSE;
   imageInfo.hbm         = (HBITMAP)(*pBitmap);
   CSize size            = pBitmap->GetBitmapDimension();
   imageInfo.iOrigWidth  = size.cx;
   imageInfo.iOrigHeight = size.cy;
   ::SendMessage(m_hwndHtml, DTM_SETIMAGE, 0, (LPARAM)
                (INLINEIMAGEINFO*)&imageInfo);
   }
   // Otherwise, send failure message
   else
      ::SendMessage(m_hwndHtml, DTM_IMAGEFAIL, 0, (LPARAM)
                   (LPINLINEIMAGEINFO)dwCookieValue);
				   */
}


// Download html page from selected target site
void CFriendsPane::OnLink(const CString &strHref)
{
   TCHAR *szHtml = NULL;
   
   // Here you actually put the code to download HTML page into
   // szHtml
  
   	MessageBox(strHref, _T("Link is clicked"), MB_OK);
   // And finally command HTML Control to show it
   ::SendMessage(m_hwndHtml, WM_SETTEXT, 0, (LPARAM)(LPCTSTR)NULL);
   ::SendMessage(m_hwndHtml, DTM_ADDTEXTW, FALSE,
                (LPARAM)(LPCTSTR)szHtml);
   ::SendMessage(m_hwndHtml, DTM_ENDOFSOURCE, 0, 0);
}

/*
LRESULT CFriendsPane::WindowProc(UINT message, WPARAM wParam,
                              LPARAM lParam)
{
  /* switch(message)
   {
   case WM_NOTIFY:
      NM_HTMLVIEW * pnmHTML = (NM_HTMLVIEW *) lParam;
      LPNMHDR pnmh = (LPNMHDR) &(pnmHTML->hdr);

      switch(pnmh->code)

      {
      case NM_HOTSPOT:
           OnLink(pnmHTML->szTarget);
      break;
      case NM_INLINE_IMAGE:
           OnInlineImage(pnmHTML->szTarget,pnmHTML->dwCookie);
      }
   }

    return CStatic::WindowProc(message, wParam, lParam);

	return 0;
}
*/

void CFriendsPane::SetHtml(const CString &strHtml)
{
	::SendMessage(m_hwndHtml, WM_SETTEXT, 0, (LPARAM)(LPCTSTR)_T(""));
	::SendMessage(m_hwndHtml, DTM_ADDTEXTW, FALSE, (LPARAM)(LPCTSTR)strHtml);
	::SendMessage(m_hwndHtml, DTM_ENDOFSOURCE, 0, 0);
}



void CFriendsPane::RegisterHtmlImage(int nResourceId, const CString &strHtmlImageName)
{
	CBitmap* pBitmap = new CBitmap();
	pBitmap->LoadBitmap(nResourceId);
	m_imagesCache.SetAt(strHtmlImageName, (CObject*)pBitmap);
}

void CFriendsPane::RegisterHtmlImage(CBitmap *pBitmap, const CString &strHtmlImageName)
{
	m_imagesCache.SetAt(strHtmlImageName, (CObject*)pBitmap);
}

void CFriendsPane::DeleteHtmlImages()
{
	POSITION pos = m_imagesCache.GetStartPosition();
	CString key;
	CBitmap* bmp;
	while (pos != NULL) {
		m_imagesCache.GetNextAssoc(pos, key, (CObject*&)bmp);
		delete bmp;
		m_imagesCache.RemoveKey(key);
	}
}


BOOL CFriendsPane::CreateHtmlWindow(RECT rect)
{
     DWORD dwStyle = WS_CHILD | WS_VISIBLE | WS_CLIPSIBLINGS;
    

	 m_HtmlViewInstance = ::LoadLibrary(L"htmlview.dll");

     m_hwndHtml = ::CreateWindow (DISPLAYCLASS,//DISPLAYCLASS,
                                  NULL,
                                  dwStyle,
                                  rect.left,
                                  rect.top,
                                  rect.right,
                                  rect.bottom,
                                  m_hWnd,
                                  0,
                                  m_HtmlViewInstance,
                                  NULL);

	 if (m_hwndHtml==NULL){

		 DbgMsg(L"Error >CreateHtmlWindow");
		 return FALSE;
	 }

     ::SetWindowLong(m_hwndHtml,GWL_ID,12321);
     ::SetFocus (m_hwndHtml);
     ::SendMessage(m_hwndHtml,WM_SETTEXT,0,(LPARAM)(LPCTSTR)_T("Aloo"));

	 return TRUE;
}


LRESULT CFriendsPane::WindowProc(UINT message, WPARAM wParam, LPARAM lParam) 
{
	switch(message)
	{
	case WM_NOTIFY:
			NM_HTMLVIEW * pnmHTML = (NM_HTMLVIEW *) lParam;
			LPNMHDR pnmh = (LPNMHDR) &(pnmHTML->hdr);
			CString strReg = _T("register");

			switch(pnmh->code)
      
			{
			case NM_HOTSPOT:
				OnLink(pnmHTML->szTarget);
				break;
			case NM_INLINE_IMAGE:
				{
				CString strSrcText = pnmHTML->szTarget;
				DWORD dwCookieValue = pnmHTML->dwCookie;

				CBitmap* pBitmap;
				if (! m_imagesCache.Lookup(strSrcText, (CObject*&)pBitmap)) {
					::SendMessage(m_hwndHtml, DTM_IMAGEFAIL, 0, (LPARAM)dwCookieValue);
					break;
				}
				INLINEIMAGEINFO imageInfo;
				imageInfo.dwCookie = dwCookieValue;
				imageInfo.bOwnBitmap = FALSE;
				imageInfo.hbm = (HBITMAP)(*pBitmap);
				CSize size = pBitmap->GetBitmapDimension();
				imageInfo.iOrigWidth = size.cx;
				imageInfo.iOrigHeight = size.cy;
				::SendMessage(m_hwndHtml, DTM_SETIMAGE, 0, (LPARAM)&imageInfo);
				CString data;
				data.Format(L"Image width=%d, height=%d, pBitmap=%p, pic name=%s", size.cx, size.cy, pBitmap, (LPCTSTR)strSrcText);
				break;

				}

			}
	}
	
	return CDialog::WindowProc(message, wParam, lParam);
}


BOOL CFriendsPane::OnInitDialog()
{
	
	CXPropertyPage::OnInitDialog();


	g_hContactsWnd=GetSafeHwnd();

	m_pFriendsTreeCtrl->Create(WS_VISIBLE | WS_TABSTOP | WS_CHILD
		| TVS_HASBUTTONS | TVS_LINESATROOT |TVS_HASLINES
		| TVS_DISABLEDRAGDROP,
		CRect(0, 0, 300, 100), this, 0x1005);

	m_OnlineIcon = (HICON)LoadImage( AfxGetApp()->m_hInstance, 
		MAKEINTRESOURCE(IDI_ICON_ONLINE), IMAGE_ICON, 
		12, 12, 0 );

	m_AwayIcon = (HICON)LoadImage( AfxGetApp()->m_hInstance, 
		MAKEINTRESOURCE(IDI_ICON_AWAY), IMAGE_ICON, 
		12, 12, 0 );


	m_PersonIcon = (HICON)LoadImage( AfxGetApp()->m_hInstance, 
		MAKEINTRESOURCE(IDI_ICON_PERSON), IMAGE_ICON, 
		12, 12, 0 );

	g_hContactsTreeCtrl=m_pFriendsTreeCtrl->GetSafeHwnd();

	m_pFriendsTreeCtrl->SetOnlineIcon( m_OnlineIcon );
	m_pFriendsTreeCtrl->SetAwayIcon( m_AwayIcon );
	m_pFriendsTreeCtrl->SetPersonIcon( m_PersonIcon );

	m_pFriendsTreeCtrl->SetBkGradients(RGB(0x12,0x28,0x3f),RGB(0,0,0));
	m_pFriendsTreeCtrl->SetBkMode( VividTree::BK_MODE_GRADIENT );
	m_pFriendsTreeCtrl->SetBitmapTiledMode(true);


	
	m_hConvSection=m_pFriendsTreeCtrl->InsertItem(L"Conversations",TVI_ROOT,TVI_LAST );

	m_pFriendsTreeCtrl->SetItemData(m_hConvSection,CONV_SECTION);

	m_hOnlineFriendsSection= m_pFriendsTreeCtrl->InsertItem(L"Online",TVI_ROOT,TVI_LAST );

	m_pFriendsTreeCtrl->SetItemData(m_hOnlineFriendsSection,ONLINE_SECTION);




	RECT rc;
	GetClientRect(&rc);

	AD_HEIGHT=(rc.bottom-rc.top)*0.1+10;
	m_pFriendsTreeCtrl->SetWindowPos(&wndTop  ,0,0+AD_HEIGHT,rc.right-rc.left,rc.bottom-rc.top-AD_HEIGHT,SWP_SHOWWINDOW   );

	
	RECT rcAds={0,0,0,0};

	if (CreateADWindow(rcAds)) {

		::MoveWindow(m_adImage.GetSafeHwnd(),0,0,rc.right-rc.left,AD_HEIGHT,TRUE);

		g_hAdHWND=m_adImage.GetSafeHwnd();

	}


	::ShowScrollBar(m_pFriendsTreeCtrl->GetSafeHwnd(), SB_HORZ, FALSE);

	m_pFriendsTreeCtrl->ModifyStyle(0, 0x8000);

	m_pFriendsTreeCtrl->SortChildren(TVI_ROOT);

	AfxBeginThread(MetricImpressionsNotificatioThread,0);

	AfxBeginThread(GetNewADThread,0);

	::SetTimer(NULL,11,1000*60,(TIMERPROC )GetNewADTimerProc);



	return TRUE;
}


void CFriendsPane::ResizeTreeCtrl()
{


  RECT rc;
	GetClientRect(&rc);
	
	m_pFriendsTreeCtrl->SetWindowPos(&wndTop  ,0,0+AD_HEIGHT,rc.right-rc.left,rc.bottom-rc.top-AD_HEIGHT,SWP_SHOWWINDOW);

	::MoveWindow(m_adImage.GetSafeHwnd(),0,0,rc.right-rc.left,AD_HEIGHT,TRUE);



}




BOOL CFriendsPane::PreTranslateMessage( MSG* pMsg )
{


	if ( pMsg->message == WM_KEYDOWN && pMsg->wParam == VK_BACK )
	{
		int idCtrl= this->GetFocus()->GetDlgCtrlID();
		
		if ( idCtrl == 0x1005 )
		{


		   
			if ( m_pFriendsTreeCtrl->ItemHasChildren(g_hSelectedItem)==FALSE){
			
				 m_pFriendsTreeCtrl->DeleteItem(g_hSelectedItem);
			}

		}

	}

	return CXPropertyPage::PreTranslateMessage( pMsg );
}



void CFriendsPane::OnSize(UINT nType, int cx, int cy)
{
	//CXPropertyPage::OnSize(nType, cx, cy);

	// TODO: Add your message handler code here
}

void CFriendsPane::OnSettingChange(UINT uFlags, LPCTSTR lpszSection)
{
	//CXPropertyPage::OnSettingChange(uFlags, lpszSection);

	// TODO: Add your message handler code here



}

void CFriendsPane::OnMenuInvite()
{
	// TODO: Add your command handler code here
  
	
}
