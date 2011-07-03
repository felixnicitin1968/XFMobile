#pragma once


// CFriendsPane dialog
#include "VividTree.h"
#include "XPropertyPage.h"

#include "ImageButton.h"

struct XfireContact;
class CFriendsPane : public CXPropertyPage

{
	DECLARE_DYNAMIC(CFriendsPane)

public:
	LRESULT OnAddFriend(WPARAM, LPARAM);   // a connection has been closed
	LRESULT OnRemoveFriend(WPARAM wParam, LPARAM); // received new message
	LRESULT OnAddClans(WPARAM wParam, LPARAM lParam);
    LRESULT OnFriendStatus(WPARAM wParam, LPARAM lParam);
	LRESULT OnClanMembers(WPARAM wParam, LPARAM lParam);
	LRESULT OnConnectionStatus(WPARAM wParam, LPARAM lParam);
	LRESULT OnAddConversation(WPARAM wParam, LPARAM lParam);
    LRESULT OnRecvIM(WPARAM wParam, LPARAM lParam);


	XfireContact * getClanMember(long userid);
	BOOL      removeClanMember(long userid);
	BOOL      addClanMember(long userid);
    HTREEITEM m_hOnlineFriendsSection; 
	HTREEITEM m_hConvSection; 
	void ResizeTreeCtrl();
	
    void OnLink(const CString &strHref);

	
	BOOL CreateADWindow(RECT rect);


	BOOL NavigateTo(LPWSTR wURL);
	BOOL CreateHtmlWindow(RECT rect);
	HWND m_hwndHtml,m_hwndAD;


	HICON m_OnlineIcon,m_AwayIcon,m_PersonIcon;

	CImageButton   m_adImage;
	VividTree  *m_pFriendsTreeCtrl;
public:
	CFriendsPane(CWnd* pParent = NULL);   // standard constructor
	virtual ~CFriendsPane();



// Dialog Data
	enum { IDD = IDD_CONTACTS_PANE };

virtual BOOL PreTranslateMessage(MSG* pMsg) ;
protected:
	virtual LRESULT WindowProc(UINT message, WPARAM wParam, LPARAM lParam) ;
	virtual BOOL OnInitDialog();
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
		
	DECLARE_MESSAGE_MAP()
public:
	
	afx_msg void OnSize(UINT nType, int cx, int cy);
	afx_msg void OnSettingChange(UINT uFlags, LPCTSTR lpszSection);
	afx_msg void OnMenuInvite();
	afx_msg void OnAdClick();
};
