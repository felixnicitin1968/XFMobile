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


	BOOL CreateHtmlWindow(RECT rect);
	//To use images in HTML you should register them before.
	//strHtmlImageName should be a string that will be
	//used in HTML in "src" attribute of "img" tag.
	//This function adds image from bitmap resource with 
	//the given id.
	void RegisterHtmlImage(int nResourceId, const CString& strHtmlImageName);

	//To use images in HTML you should register them before.
	//strHtmlImageName should be a string that will be
	//used in HTML in "src" attribute of "img" tag.
	//This function adds the given bitmap image.
	void RegisterHtmlImage(CBitmap *pBitmap, const CString& strHtmlImageName);
    BOOL CreateADWindow(RECT rect);

	//This function deletes all images
	virtual void DeleteHtmlImages();

	//List of images that will be accessible from HTML
	CMapStringToOb m_imagesCache;

    CImageButton   m_adImage;
	XfireContact * getClanMember(long userid);
	BOOL    removeClanMember(long userid);
	BOOL    addClanMember(long userid);
    HTREEITEM m_hOnlineFriendsSection; 
	HTREEITEM m_hConvSection; 
	void ResizeTreeCtrl();

	void OnInlineImage(const CString &strHref, DWORD dwCookie);

	void OnLink(const CString &strHref);

	void SetHtml(const CString &strHtml);

	LRESULT WindowProc(UINT message, WPARAM wParam, LPARAM lParam) ;

	//LRESULT WindowProc(UINT message, WPARAM wParam,
      //                        LPARAM lParam);

	HICON m_OnlineIcon,m_AwayIcon,m_PersonIcon;

	VividTree  *m_pFriendsTreeCtrl;
	HWND       m_hwndHtml;
	//Instance of dll to support HTML view control
	 HINSTANCE m_HtmlViewInstance;
public:
	CFriendsPane(CWnd* pParent = NULL);   // standard constructor
	virtual ~CFriendsPane();

// Dialog Data
	enum { IDD = IDD_CONTACTS_PANE };

virtual BOOL PreTranslateMessage(MSG* pMsg) ;
protected:
	virtual BOOL OnInitDialog();
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
		
	DECLARE_MESSAGE_MAP()
public:
	
	afx_msg void OnSize(UINT nType, int cx, int cy);
	afx_msg void OnSettingChange(UINT uFlags, LPCTSTR lpszSection);
	afx_msg void OnMenuInvite();
	afx_msg void OnAdClick();
};
