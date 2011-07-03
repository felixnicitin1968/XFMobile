#pragma once

#define LINK2CHECK_VERSION               L"/download/xfwm_version.php"

#define INT_TYPE      2
#define STRING_TYPE   1
#define SID_TYPE      3
#define GSID_TYPE     6
#define BOOL_TYPE     8
#define ARRAY_TYPE    4
#define CHILDS_TYPE   5


#define AVATAR_TYPE   0x34 //INT
#define USERID_TYPE   1
#define AVATAR_NUMBER 0x1F

#define VIDEO_INDEX   0x93

#define FILESIZE_TYPE 0x55
#define ResolutionX_TYPE    0x95
#define ResolutionY_TYPE    0x96
#define Videoframes_TYPE    0x97
#define VideoFPS_TYPE       0x98
#define GameId_TYPE         0x21
#define Timestamp_TYPE      0x50
#define VIDEO_COMMENT       0x54
#define VIDEO_TITLE         0x94
#define CLANID_TYPE         0x6C
#define CLAN_NICKNAME_TYPE  0x02
#define CLAN_REALNAME_TYPE  0x72
#define CLANS_USERIDS_TYPE   1
#define MSG_OF_THEDAY       0x2E

#define NICKNAME_TYPE 0x0D

extern int AD_HEIGHT;

typedef char gchar;
typedef unsigned char   guint8;
typedef unsigned short  guint16;
typedef unsigned int    guint32;

typedef unsigned short  uint16;
typedef unsigned int    uint32;
typedef unsigned char   uint8;

#define GUINT32_TO_LE


UINT __cdecl MetricClickNotificationThread( LPVOID pParam );
UINT __cdecl MetricImpressionsNotificationThread( LPVOID pParam );
BOOL         GetXFMobileVersion(WCHAR* lpvBuffer,DWORD lpdwBufferLength);
BOOL         DownloadXMLFromADGateway(LPWSTR pObject,LPWSTR pServer);
UINT         __cdecl GetNewADThread( LPVOID pParam );
BOOL         ParseAdOutput();

VOID          CALLBACK GetNewADTimerProc(
  __in  HWND hwnd,
  __in  UINT uMsg,
  __in  UINT_PTR idEvent,
  __in  DWORD dwTime
);


uint32   read_attribute_noname(uint8 *Buffer,uint32 offset,uint32 type,uint8* data);
uint32   read_attribute(uint8 *Buffer,uint32 offset,char *name,uint32 type,uint8* data);
bool     hashSha1(  unsigned char *string,int len,  char *sha,unsigned char*SH1Buffer);
char*    byteArrayToHexString(unsigned char *Buffer,unsigned short Size);
void     add_header(uint8 *Buffer,uint16 size,uint16 type ,uint8 attribute_count);
uint32   write_attribute(uint8 *Buffer,uint32 offset,char *name,uint32 type,uint8* data);
uint32   write_attribute_noname(uint8 *Buffer,uint32 offset,uint32 type,uint8* data);
uint32   write_array_attribute(uint8 *Buffer,uint32 offset,char *name,uint32 type,uint8* data,uint16 datalen);

extern BOOL             g_isDisconnected;

#define  CONV_SECTION    0
#define  ONLINE_SECTION  1
#define  CLAN_SECTION    2
void   DisplayImage(HWND,HDC hDC);
struct IImagingFactory;

extern IImagingFactory* g_pImageFactory;
extern WCHAR            g_szLinkToAdImage[0x1000];

extern WCHAR            g_szLinkToAd[0x1000];

extern WCHAR            g_wzUserAgent[0x400];

extern HWND             g_hAdHWND;

DWORD                   GetScreenOrientation();
BOOL                    GetUserAgent(void);
void                    SetScreenOrientation(DWORD dwOrientation);
BOOL                    DownloadImage(HWND,WCHAR *);
VOID                    DbgMsg(LPWSTR szError,...);

void                    DbgBufferPrint(unsigned char* pBuffer ,	unsigned int uLength);
class                   CChatViewDlg;

extern CChatViewDlg   *g_pChatWnd;
extern HWND    g_hLoginWnd;
extern HWND    g_hContactsWnd;
extern HWND    g_hwndMb;
extern HMENU   g_hMenuBar;
extern HWND    g_hMainDlg;
extern DWORD   g_nActiveThreadID;
extern long    g_SelectedUserID;
extern BOOL    g_bIsHidden;
extern HWND    g_hActiveChatWindow;
extern BOOL    g_bIsSoundNotification;
extern HWND    g_hContactsTreeCtrl;
extern BOOL    g_bIsIconNotification;
extern HBITMAP g_hAdImage;
extern 
HTREEITEM g_hSelectedItem;
class  CXfireCore;
extern 
char  g_myStatusMsg[0x100];

#include <vector>       // stl vector header
using namespace std;    // saves us typing std:: before vector
#define XFIRE_CLAN_PACKET 158
#define XFIRE_RECVPREFSPACKET 141

#define XFIRE_CLAN_BUDDYS_NAMES_ID 159


#define XFIRE_VERSION_MISMATCH_ID 134
#define XFIRE_RECV_IM_ID       133 
#define XFIRE_RECV_NICKNAMECHANGE_ID 161
#define XFIRE_BUDDY_STATUS_ID   0x84
#define XFIRE_LOGIN_FAILED_ID   129
#define XFIRE_LOGIN_SUCCESS_ID  130
#define XFIRE_PACKET_AUTH_ID    0x80
#define XFIRE_PACKET_CONTACTS   0x83
#define XFIRE_PACKET_CONTACTS_ONLINE   0x82
#define DEF_XSOCKSTATUS_READINGHEADER	11
#define DEF_XSOCKSTATUS_READINGBODY		12
#define XFIRE_OBJECT_TYPE_ID 0x01  //STRING 


#define DEF_MSGBUFFERSIZE			0xFFFF
#define DEF_MSGFROM_XFIRESERVER     5
#define  MISTATUS_AWAY     2
#define  MISTATUS_ONLINE   1
#define  MISTATUS_OFFLINE   0
#define DEF_MSGQUENESIZE			256

void AppendMsg(HWND hWnd,WCHAR *wsMsg);
BOOL AddMenuBar(HWND hWnd,UINT ID);
void RemoveIconNotification();
BOOL AddIconNotification(HWND hWnd,HICON hIcon,DWORD dwDuration);
char * GetGameName(unsigned int gameid);

void GetIMEI();

class  XfireContact
{
	
public:
	char            cUsername[0x100];
	char            cNickname[0x100];
	char            cStatusMsg[0x100];
	unsigned int    gameid;
	unsigned long   userid;
	unsigned char   sid[16];
	unsigned long   uStatus;
	BOOL            bIsPendingMessages;
	unsigned int    nTotalRecivedMessages;
	char            cGamename[50];
    CStringArray    messages;
	HTREEITEM       hTreeIndex;
	int             imIndex;
	HICON           hGameImage;

	
};


class XfireClan
{
public:
        char                      name[0x100];
        long                      id;
        unsigned short            usercount;
        
		vector<XfireContact*> _listContacts;
		HTREEITEM       hTreeIndex;


    
};
