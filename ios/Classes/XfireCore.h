//
//  XfireCore.h
//  iXfire
//
//  Created by Moti Joseph on 4/1/09.
//  Copyright 2009 Gamepe. All rights reserved.
//
#define XFIRE_CLAN_PACKET 158
#define XFIRE_RECVPREFSPACKET 141

#define XFIRE_CLAN_BUDDYS_NAMES_ID 159
#define		XFIRE_FRIENDS_PLAYING_GAME 135
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

#define		XFIRE_MESSAGE_OF_THEDAY 154
#define DEF_MSGBUFFERSIZE			0xFFFF
#define DEF_MSGFROM_XFIRESERVER     5


#define  MISTATUS_AWAY      2
#define  MISTATUS_ONLINE    1
#define  MISTATUS_OFFLINE   0
#define DEF_MSGQUENESIZE			256

@class AsyncSocket;
@class MsgQue;
@class LoginViewControlller;
@class ContactsViewController;
#import <Foundation/Foundation.h>
#import "SearchViewController.h"
#import "global.h"

#import "XGroupChannel.h"
#define CLAN_MAX_MEMBERS 100

#define  INT_TYPE    2
#define  STRING_TYPE 1
#define  SID_TYPE    3 
#define  BOOL_TYPE   8
#define  ARRAY_TYPE  4
#define  CHILDS_TYPE 5



@interface NUSERID : NSObject
{
	
	uint32  m_userid;

	
};

@property (nonatomic,assign)    uint32 m_userid;    

-(void)                 setUserid:(int) userid;
-(uint32)               getUserid;

@end





@interface XfireCore : NSObject
{

		AsyncSocket               *coreSocket;
    	uint32                     m_cStatus  ;      
	    BOOL                       m_bIsConnected;
		uint16                     m_dwReadSize ;    
	    uint16                     m_dwTotalReadSize ;
	    char                       *m_pRcvBuffer;
	    uint16                      m_dwBufferSize;
		ContactsViewController      *_ContactsViewController;
    	char                        m_cUserName[0x100];
	    char                        m_cPassword[0x100];
	    LoginViewControlller        *m_pLoginController;
	    SearchViewController        *m_pSearchedFriendVC;
	  
    	uint32                      m_iQueneHead  ;
	    uint32                      m_iQueneTail ;
	    MsgQue *                    m_pMsgQuene[DEF_MSGQUENESIZE];
	    char                        _myNickname[50]; 
	    uint32                      _myuserid;
	    uint8                       _mysid[16];
	
	   char                         _user_pending_invite[0x100];
	
	    XfGroupChannel             * m_pXfGroupChannel;
	
	
	
	     XFireContact              *m_pContacts;
	     XfireClan                 * m_pClans;
     	
     	 uint32                       m_nTotalClans;
	     uint32                      m_nTotalContacts;
	
};
@property (nonatomic,assign)    XfireClan                           *m_pClans;    
@property (nonatomic,assign)    XFireContact                        *m_pContacts;      
@property                       BOOL                                m_bIsConnected;
@property (nonatomic,assign)    LoginViewControlller                *m_pLoginController;
@property (nonatomic,assign)    SearchViewController                *m_pSearchedFriendVC;

-(void) send_push_token;
-(XfGroupChannel*)   getActiveGroup;
-(void) AcceptGroupInvite;
-(void) LeaveGroupChat;
-(char*)   getGroupName;
-(bool) removeGroupUser:(uint32)userid;

-(void) XfMobileHandle_BuddyInitation:(unsigned char *)pBuffer  MsgSize:(unsigned short) dwMsgSize;
-(void) XfMobileHandle_Invitation_Reject:(char *)p_name;
-(void) XfMobileHandle_Invitation_Accept:(char *)p_name;
-(void) XfMobileGChat_TopicChange:(unsigned char *)pBuffer  MsgSize:(unsigned short) dwMsgSize;
-(void) XfMobileGChat_MotdChange:(unsigned char *)pBuffer  MsgSize:(unsigned short) dwMsgSize;
-(void) XfMobileGChat_HandleBuddys:(unsigned char *)pBuffer  MsgSize:(unsigned short) dwMsgSize;
-(void) XfMobileGChat_Leave:(unsigned char *)gsid;
-(void) XfMobileGChat_HandleMOTD:(unsigned char *)pBuffer  MsgSize:(unsigned short) dwMsgSize;
-(void) XfMobileGChat_BuddyJoin:(unsigned char *)pBuffer  MsgSize:(unsigned short) dwMsgSize;
-(void) XfMobileGChat_BuddyPart:(unsigned char *)pBuffer  MsgSize:(unsigned short) dwMsgSize;
-(void) XfMobileGChat_SendIM:(unsigned char *)gsid  msg:(char*) message;
-(void) XfMobileGChat_AcceptInvite:(unsigned char *)gsid  roomName:(char*) room  passRoom:(char*)pass;
-(void) XfMobileGChat_HandleIM:(unsigned char *)pBuffer  MsgSize:(unsigned short) dwMsgSize;
-(void) XfMobileGChat_SendMOTD:( uint8 *)gsid  p_motd:( char*) motd;
-(void) XfMobileGChat_SendInvite:(uint8 *)sid;
-(void) XfMobileGChat_RejectInvite:(uint8 *)gsid;
-(void) XfMobileGChat_HandleInvite:(unsigned char *)pBuffer  MsgSize:(unsigned short) dwMsgSize;
-(void) XfMobileGChat_CreateRoom:(char *)room  password:(char*) pass;
-(void) XfMobileGChat_JoinRoom:(unsigned char *)pBuffer  MsgSize:(unsigned short) dwMsgSize;


-(void)              XfMobile_SearchFreinds:(char *)friend   view:(SearchViewController*)vc;
-(void)              XfMobile_GetData:(int)userid;
-(void)              XfMobile_NewNickname:(char *)nickname;
-(void)              XfMobileHandle_ClansNames:(unsigned char *)pBuffer  MsgSize:(unsigned short) dwMsgSize;
-(void)              XfMobileHandle_Clans:(unsigned char *)pBuffer MsgSize:(unsigned short) dwMsgSize;
-(void)              XfMobile_SendIM:(uint8 *)sid  Imindex:(uint32) imindex msg:(char *)Message;
-(void)              XfMobile_MessageOfTheDay:(char *)Message;
-(void)              XfMobile_AddFriend:(char *)Friend msg:(char *)Message;
-(void)              XfMobile_KeepAlive;
-(void)              XfMobile_Typing:(uint8 *)sid  Imindex:(uint32) imindex  Typing:(uint32) typing;
-(void)              XfMobile_HandleMismatchVersion:(unsigned char *)pBuffer  MsgSize:(unsigned short) dwMsgSize;
-(void)              XfMobile_HandleSuccessLogin:(unsigned char *)pBuffer  MsgSize:(unsigned short) dwMsgSize;
-(void)              XfMobile_HandleIM:(unsigned char *)pBuffer  MsgSize:(unsigned short) dwMsgSize;
-(void)              XfMobile_HandleBuddyStatus:(unsigned char *)pBuffer  MsgSize:(unsigned short) dwMsgSize;
-(void)              XfMobile_HandlePlayingGame:(unsigned char *)pBuffer  MsgSize:(unsigned short) dwMsgSize;
-(void)              XfMobileHandleHeartbeat:(unsigned char *)pBuffer  MsgSize:(unsigned short) dwMsgSize;
-(void)              XfMobileHandle_SystemBroadcast:(unsigned char *)pBuffer  MsgSize:(unsigned short) dwMsgSize;
-(void)              XfMobile_HandleNewNickName:(unsigned char *)pBuffer  MsgSize:(unsigned short) dwMsgSize;
-(void)              XfMobile_HandleStatusMessage:(unsigned char *)pBuffer  MsgSize:(unsigned short) dwMsgSize;
-(void)              XfMobileHandle_AvatarInfo:(unsigned char *)pBuffer  MsgSize:(unsigned short) dwMsgSize;
-(void)              XfMobile_HandleContacts:(unsigned char *)pBuffer  MsgSize:(unsigned short) dwMsgSize;

-(void)              setNickname:(char*)nickname;
-(char*)             _myNickname;
-(void)              reloadContactsAvatars;
-(void)              sortClanContacts;
-(void)              sortContacts;
-(uint32)            getTotalClans;
-(uint32 )           getTotalContacts;
-(XfireClan*)        clans;
-(XFireContact*)     contacts;
-(XfireClan*)        getClanById:(uint32)clanid;
-(XFireContact *)    getClanContactBySid:(uint8 *)psid;
-(XFireContact *)    getClanContactByUserid:(uint32) userid;


-(void) clearContactInvite;

-(void)           handlsRequestForInformation:(unsigned char*) pBuffer MsgSize:(unsigned short) dwMsgSize;

-(void)           keepAliveTimer: (id) timer;
-(void)           loadContactsAvatars;

-(void)           HandleSearchFriends:(unsigned char *)pBuffer MsgSize:(unsigned short) dwMsgSize;
-(void)           cleanup;
-(char*)          username;


-(BOOL)           bGetMsgQuene:(char*)pFrom Data:(unsigned char*)pData Size:(unsigned short*)szMsgSize Index:(uint32*)pIndex Key:(char*)pKey;
-(BOOL)           bPutMsgQuene:(char)cFrom Data:(unsigned char*)pData Size:(unsigned short)szMsgSize Index:(uint32) iIndex Key:(char)cKey;
-(void)           Disconnect;
-(BOOL)           IsConnecetd;
-(void)           Connect;
-(void)           Login;
-(void)           OnRead;
-(void )          sendPacketMsg:(const void *)bytes length:(NSUInteger)length;
-(void)           handleTimer: (id) timer;
-(void)           ParseMessage:(unsigned char *)pBuffer  MsgSize:(unsigned short) dwMsgSize;
-(void)           HandleAuth:(unsigned char *)pBuffer MsgSize:(unsigned short) dwMsgSize;

-(XFireContact*)  getContactByUsername:(char *)szUsername;
-(XFireContact*)  getContactByUserid:(unsigned long) userid;
-(XFireContact *) getContactBySid:(unsigned char *)psid;
-(void)           setLogin:(const char*)Username Password:(const char*)Password;
- (UIImage *)     newImageFromResource:(NSString *)filename  ;

@end
