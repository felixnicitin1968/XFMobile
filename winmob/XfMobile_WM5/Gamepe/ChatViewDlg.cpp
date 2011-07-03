// ChatViewDlg.cpp : implementation file
//

#include "stdafx.h"
#include "Gamepe.h"
#include "ChatViewDlg.h"
#include "XfireCore.h"
#include "Global.h"




// CChatViewDlg dialog
 
//IMPLEMENT_DYNAMIC(CChatPane, CXPropertyPage)

HWND m_hChatView;
CChatPane::CChatPane(CWnd* pParent /*=NULL*/)
	: CXPropertyPage(CChatPane::IDD, pParent)
{

	m_bIsInit=FALSE;
}

CChatPane::~CChatPane()
{
}

void CChatPane::DoDataExchange(CDataExchange* pDX)
{
	CXPropertyPage::DoDataExchange(pDX);
}


BEGIN_MESSAGE_MAP(CChatPane, CXPropertyPage)
	ON_EN_CHANGE(IDC_EDIT_CHATVIEW, &CChatPane::OnEnChangeEditChatview)
	ON_BN_CLICKED(IDC_SEND_CHAT, &CChatPane::OnBnClickedSendChat)
	ON_MESSAGE(WM_RECV_IM, OnRecvIM)
	ON_WM_CTLCOLOR()
	ON_WM_SETTINGCHANGE()
	ON_WM_SIZE()
END_MESSAGE_MAP()



LRESULT CChatPane::OnRecvIM(WPARAM wParam, LPARAM lParam)


{


	

	WCHAR *wsMsg=(WCHAR*)lParam;
	int userid=(int)wParam;

    AddIconNotification(GetParent()->GetSafeHwnd(),AfxGetApp()->LoadIcon(IDR_LOGO),1);


	if (userid!=m_userid) {


		  return -1;

	}

	HWND hEdit=m_view.GetSafeHwnd();

	//AppendMsg(hEdit,L"\r\n");
	AppendMsg(hEdit,wsMsg);
	AppendMsg(hEdit,L"\r\n");


	return 0;
}



	
// CChatViewDlg message handlers


BOOL CChatPane::OnInitDialog()
{
	CXPropertyPage::OnInitDialog();


	m_redcolor=RGB(255,0,0);                      // red
	m_bluecolor=RGB(0,0,255);                     // blue
	m_textcolor=RGB(255,255,255);                 // white text
	m_redbrush.CreateSolidBrush(m_redcolor);      // red background
	m_bluebrush.CreateSolidBrush(m_bluecolor);    // blue background


	g_hActiveChatWindow=GetSafeHwnd();
	
		
	RECT rc={0,0,0,0};


	m_input.Create(ES_AUTOHSCROLL |WS_CHILD | WS_VISIBLE | WS_TABSTOP | WS_BORDER,rc,this,IDC_EDIT_INPUTCAHT);

	m_view.Create(ES_MULTILINE | WS_CHILD | WS_VISIBLE | WS_TABSTOP | WS_BORDER| WS_VSCROLL 
		
		|ES_READONLY|ES_AUTOVSCROLL,rc,this,IDC_EDIT_CHATVIEW);

     m_title.Create(WS_CHILD | WS_VISIBLE | WS_TABSTOP | WS_BORDER|ES_READONLY,rc,this,IDC_EDIT_CHATVIEW+5);

	::GetClientRect(GetSafeHwnd(),&rc);

    int nHighet=rc.bottom-rc.top;
    int nWidth=rc.right-rc.left;

	nHighet-=66;



	m_input.SetLimitText(240000);

	m_title.SetWindowPos(&wndTop  ,0,0,nWidth,33,SWP_SHOWWINDOW);
	m_view.SetWindowPos(&wndTop  ,0,33,nWidth,nHighet-30,SWP_SHOWWINDOW);
	m_input.SetWindowPos(&wndTop  ,0,nHighet+33-30,nWidth,33,SWP_SHOWWINDOW   );


	/*
	
	m_title.SetWindowPos(&wndTop  ,0,0,nWidth,nHighet*0.1,SWP_SHOWWINDOW);
	m_view.SetWindowPos(&wndTop  ,0,nHighet*0.1,nWidth,nHighet*0.7,SWP_SHOWWINDOW);
	m_input.SetWindowPos(&wndTop  ,0,nHighet*0.8,nWidth,nHighet*0.2,SWP_SHOWWINDOW   );

*/
	m_view.ShowScrollBar(SB_VERT, TRUE);

	m_hChatView=GetDlgItem(IDC_EDIT_CHATVIEW)->GetSafeHwnd();
	//INIT_EASYSIZE;
	
	
	m_title.SetWindowTextW(L"Select a friend");
    GetDlgItem(IDC_EDIT_INPUTCAHT)->SetFocus();

	m_bIsInit=TRUE;
	return TRUE;  // return TRUE  unless you set the focus to a control
}

void CChatPane::ClearChat()
{

       m_view.SetWindowText(L"");
	  
}
void CChatPane::SetChatTitle(WCHAR *szTitle)
{

       m_title.SetWindowText(szTitle);
	   SetFocus();
}


void CChatPane::LoadHistory()
{


	XfireContact *pContact=CXfireCore::getContactByID(m_userid);

	if (!pContact) {	

		
		 pContact=CXfireCore::getClanMember(m_userid);


		 if (!pContact){
		   
			 
			 return;
		 
		 }
	}

    HWND hEdit=::GetDlgItem(GetSafeHwnd(),IDC_EDIT_CHATVIEW);
    
	::SetWindowText(hEdit,L"");

	int ndx = ::GetWindowTextLength(hEdit);

	for (int i=0; i<pContact->messages.GetCount(); i++){


		CString str=(CString)pContact->messages.GetAt(i);

		ndx = ::GetWindowTextLength(hEdit);
		::SendMessage (hEdit, EM_SETSEL, (WPARAM)ndx, (LPARAM)ndx);

		::SendMessage (hEdit, EM_REPLACESEL, 0,(LPARAM)(LPWSTR)(LPCWSTR)str);


	}


}
void CChatPane::OnSettingChange(UINT uFlags, LPCTSTR lpszSection)
{



	OutputDebugString(L"CChatPane::OnSettingChange");

	RECT rc;
	::GetClientRect(GetSafeHwnd(),&rc);

    int nHighet=rc.bottom-rc.top;
    int nWidth=rc.right-rc.left;


	nHighet-=60;




	m_title.SetWindowPos(&wndTop  ,0,0,nWidth,30,SWP_SHOWWINDOW);
	m_view.SetWindowPos(&wndTop  ,0,30,nWidth,nHighet-30,SWP_SHOWWINDOW);
	m_input.SetWindowPos(&wndTop  ,0,nHighet+30-30,nWidth,30,SWP_SHOWWINDOW   );

/*

	nHighet-=44;
	m_title.SetWindowPos(&wndTop  ,0,0,nWidth,22,SWP_SHOWWINDOW);
	m_view.SetWindowPos(&wndTop  ,0,22,nWidth,nHighet,SWP_SHOWWINDOW);
	m_input.SetWindowPos(&wndTop  ,0,nHighet+22,nWidth,22,SWP_SHOWWINDOW   );


/*	m_title.SetWindowPos(&wndTop  ,0,0,nWidth,nHighet*0.2,SWP_SHOWWINDOW);
	m_view.SetWindowPos(&wndTop  ,0,nHighet*0.2,nWidth,nHighet*0.6,SWP_SHOWWINDOW);
	m_input.SetWindowPos(&wndTop  ,0,nHighet*0.8,nWidth,nHighet*0.2,SWP_SHOWWINDOW   );	/*
	m_title.SetWindowPos(&wndTop  ,0,0,nWidth,nHighet*0.1,SWP_SHOWWINDOW);
	m_view.SetWindowPos(&wndTop  ,0,nHighet*0.1,nWidth,nHighet*0.7,SWP_SHOWWINDOW);
	m_input.SetWindowPos(&wndTop  ,0,nHighet*0.8,nWidth,nHighet*0.2,SWP_SHOWWINDOW   );

*/
	//CXPropertyPage::OnSettingChange(uFlags, lpszSection);


	

}

BOOL CChatPane::PreTranslateMessage( MSG* pMsg )
{
	// TODO: Add your specialized code here and/or call the base class
	if ( pMsg->message == WM_KEYDOWN ){
	 GetDlgItem(IDC_EDIT_INPUTCAHT)->SetFocus();

	}
	if ( pMsg->message == WM_KEYDOWN && pMsg->wParam == VK_RETURN )
	{
		int idCtrl= this->GetFocus()->GetDlgCtrlID();
		
		if ( idCtrl == IDC_EDIT_INPUTCAHT )
		{

			
           
			XfireContact *pContact=CXfireCore::getContactByID(m_userid);

			if (!pContact) {
				
			
				pContact=CXfireCore::getClanMember(m_userid);
	           	if (!pContact) {	

				   return CXPropertyPage::PreTranslateMessage( pMsg );
				}

			}
			WCHAR wzMsg[0x100];
			GetDlgItem(idCtrl)->GetWindowTextW(wzMsg,0x100);


			char szMsg[0x100];
			WideCharToMultiByte( CP_ACP, // ANSI Code Page
				0, // No special handling of unmapped chars
				wzMsg, // wide-character string to be converted
				0x100,
				szMsg, 
				0x100,
				NULL, NULL ); // Unrepresented char replacement - Use Default 


			if (strlen(szMsg)!=0){


				int imindex=0 ;



				imindex=pContact->imIndex;
				pContact->imIndex++;


		

				CXfireCore::s_pCore->SendIM(pContact->sid,imindex,szMsg);
			
				
				
				HWND hEdit=m_view.GetSafeHwnd();


				 WCHAR wzMyName[0x100];

				 MultiByteToWideChar(CP_UTF8, 0,CXfireCore::_cNickname, -1, wzMyName, 0x100);


				 lstrcatW(wzMyName,L":\r\n");
				
				 AppendMsg(hEdit,wzMyName);//L"i said:\r\n");
                 AppendMsg(hEdit,wzMsg);
				 AppendMsg(hEdit,L"\r\n");
				 
				 CString Msg=CString(wzMyName);//L"i said:\r\n");

				 pContact->messages.Add(Msg);
				 Msg=CString(wzMsg);
				 pContact->messages.Add(Msg);
				 Msg=CString(L"\r\n");
				 pContact->messages.Add(Msg);

			}
			GetDlgItem(idCtrl)->SetWindowTextW(L"");


		}
	}
	return CXPropertyPage::PreTranslateMessage( pMsg );
}



void CChatPane::OnSize(UINT nType, int cx, int cy) 
{


	if (!m_bIsInit) return;
	OutputDebugString(L"CChatPane::OnSize ENTER \n");
	SIPINFO sipInfo={0};
	

	GetDlgItem(IDC_EDIT_INPUTCAHT)->SetFocus();
	sipInfo.cbSize=sizeof(SIPINFO);

	if (SipGetInfo(&sipInfo)){

		if ((sipInfo.fdwFlags&SIPF_ON)==SIPF_ON){

			OutputDebugString(L"Keyboard SIPF_ON \n");

			RECT rc;
			::GetClientRect(GetSafeHwnd(),&rc);

			int nHighet=rc.bottom-rc.top;
			int nWidth=rc.right-rc.left;
		


			if (cx>cy){


				OutputDebugString(L"LANDSCPAE MODE \n");

				if (nHighet<(22+20)){
					AfxMessageBox(L"Landscape mode is not supported with the current size of the On–Screen Keyboard",MB_ICONINFORMATION|MB_OK);
					
					SetScreenOrientation(DMDO_0);
					return;
				}

				nHighet-=30;
				m_title.SetWindowPos(&wndTop  ,0,0,nWidth,nHighet*0,SWP_SHOWWINDOW);
				m_view.SetWindowPos(&wndTop  ,0,nHighet*0.0,nWidth,nHighet,SWP_SHOWWINDOW);
				m_input.SetWindowPos(&wndTop  ,0,nHighet,nWidth,30,SWP_SHOWWINDOW   );



			}else{

				OutputDebugString(L"PROTRAIT  MODE X\n");
				
				nHighet-=60;
				m_title.SetWindowPos(&wndTop  ,0,0,nWidth,30,SWP_SHOWWINDOW);
				m_view.SetWindowPos(&wndTop  ,0,30,nWidth,nHighet-30,SWP_SHOWWINDOW);
				m_input.SetWindowPos(&wndTop  ,0,nHighet+30-30,nWidth,30,SWP_SHOWWINDOW   );


			}

		
		}else
			if ((sipInfo.fdwFlags&SIPF_OFF)==SIPF_OFF){

				OutputDebugString(L"Keyboard SIPF_OFF \n");
				RECT rc;
				::GetClientRect(GetSafeHwnd(),&rc);

				int nHighet=rc.bottom-rc.top;
				int nWidth=rc.right-rc.left;
				

				if (cx>cy){

					OutputDebugString(L"LANDSCPAE MODE \n");

					if (nHighet<(22+20)){
					    
						AfxMessageBox(L"Landscape mode is not supported with the current size of the On–Screen Keyboard",MB_ICONINFORMATION|MB_OK);
						SetScreenOrientation(DMDO_0);
						return;
					}
					nHighet-=30;
					m_title.SetWindowPos(&wndTop  ,0,0,nWidth,nHighet*0,SWP_SHOWWINDOW);
					m_view.SetWindowPos(&wndTop  ,0,nHighet*0.0,nWidth,nHighet,SWP_SHOWWINDOW);
					m_input.SetWindowPos(&wndTop  ,0,nHighet,nWidth,30,SWP_SHOWWINDOW   );



				}else{

					OutputDebugString(L"PROTRAIT  MODE  Y \n");
					nHighet-=60;




					m_title.SetWindowPos(&wndTop  ,0,0,nWidth,30,SWP_SHOWWINDOW);
					m_view.SetWindowPos(&wndTop  ,0,30,nWidth,nHighet,SWP_SHOWWINDOW);
					m_input.SetWindowPos(&wndTop  ,0,nHighet+30,nWidth,30,SWP_SHOWWINDOW   );




				}



			



			}


	}
	OutputDebugString(L"CChatPane::OnSize EXIT \n");

}
void CChatPane::OnEnChangeEditChatview()
{
	// TODO:  If this is a RICHEDIT control, the control will not
	// send this notification unless you override the CXPropertyPage::OnInitDialog()
	// function and call CRichEditCtrl().SetEventMask()
	// with the ENM_CHANGE flag ORed into the mask.

	// TODO:  Add your control notification handler code here
}

void CChatPane::OnBnClickedSendChat()
{
	// TODO: Add your control notification handler code here
	

}

HBRUSH CChatPane::OnCtlColor(CDC* pDC, CWnd* pWnd, UINT nCtlColor)
{
	HBRUSH hbr = CXPropertyPage::OnCtlColor(pDC, pWnd, nCtlColor);

	// TODO:  Change any attributes of the DC here

	// TODO:  Return a different brush if the default is not desired
	

	pDC->SetTextColor(RGB(255,255,255));  // change the text color

	pDC->SetBkColor(RGB(0x12,0x28,0x3f));  // change the text color

	return ::CreateSolidBrush(RGB(0x12,0x28,0x3f));
}
