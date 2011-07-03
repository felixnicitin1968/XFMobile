//
//  global.h
//  iXfire
//
//  Created by Moti Joseph on 4/25/09.
//  Copyright 2009 Gamepe. All rights reserved.
//

#import <Foundation/Foundation.h>
    
#define       GOOGLE_AD_TEST 1


#define        DEBUG_XFIRE 1
#define RGB(r,g,b) ((unsigned int)(((unsigned char)(r)|((short)(g) << 8))|(((unsigned int)(unsigned char)(b)) << 16))) 

#define OPAQUE_HEXCOLOR(c) [UIColor colorWithRed:((c>>16)&0xFF)/255.0 \
green:((c>>8)&0xFF)/255.0 \
blue:(c&0xFF)/255.0 \
alpha:1.0]; 

#define GROUP_SID     4

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


#define CHAT_CELL_ID 0
#define FRIEND_CELL_ID 1
#define CLAN_CELL_ID    2 

extern int g_nXfMobileSkin;

#define BLUE_SKIN    0
#define PURPULE_SKIN 1



typedef unsigned short  uint16;
typedef unsigned int    uint32;
typedef unsigned char   uint8;


extern NSUInteger    g_XfNavBarBackgroundColor;
extern NSUInteger    g_XfBackgroundColor;
extern NSUInteger    g_XfContactsNameTextColor;
extern NSUInteger    g_XfContactsStatusTextColor;
extern NSUInteger    g_XfContactSectionTextColor;
extern NSUInteger    g_XfContactsStatusTextColor;
extern NSUInteger    g_XfContactSectionBackgroundTextColor;

extern NSUInteger    g_XfContactSeparatorColor;

typedef struct  XScreenShot
	{
		
		
		int  userid;
		int  gameid;
		char cComment[0x100];
		char cTime[0x50];
		char cURL[50];
		
	} XScreenShot;




typedef struct XFireContact
	{
		
		char            cUsername[0x100];
		char            cNickname[0x100];
		char            cStatusMsg[0x100];
		int             imIndex;
		unsigned int    gameid;
		unsigned long   userid;
		unsigned char   sid[16];
		unsigned long   uStatus;
		NSMutableArray *Messageslist;
		BOOL            bIsPendingMessages;
		unsigned int    nTotalRecivedMessages;
		unsigned int    nRowInTable;
		char            cGamename[50];
		bool            isConversation;
	    UIImage          *image;
		UIImage          *avatar;
		BOOL             invited;
		
		
		
	}XFireContact;




typedef struct  XfireClan
	{
		
		char           name[0x100];
		uint32         id;
	    uint16         userscount;
		uint16         online_userscount;
		XFireContact   *users;
		
	}XfireClan;



typedef struct TXfireFriend
	{
		
		char            cUsername[0x100];
		char            fname[50];
		char            lname[50];

			
	
	}TXfireFriend;

char*     byteArrayToHexString(unsigned char *Buffer,unsigned short Size) ;
char*     cryptPassword(char *pUserName,char *pPassword,unsigned char *pSalt);
uint32    write_array_attribute_noname(uint8 *Buffer,uint32 offset,uint32 type,uint8* data,uint16 datalen);
uint32    read_attribute(uint8 *Buffer,uint32 offset,char *name,uint32 type,uint8* data);
uint32    read_attribute_noname(uint8 *Buffer,uint32 offset,uint32 type,uint8* data);
uint32    write_attribute_noname(uint8 *Buffer,uint32 offset,uint32 type,uint8* data);
uint32    write_attribute(uint8 *Buffer,uint32 offset,char *name,uint32 type,uint8* data);
uint32    write_array_attribute(uint8 *Buffer,uint32 offset,char *name,uint32 type,uint8* data,uint16 datalen);
void      add_header(uint8 *Buffer,uint16 size,uint16 type ,uint8 attribute_count);


void MetricImpressionsNotificationThread();
void MetricClickNotificationThread();



extern char g_szLinkToAdImage[1024];
extern char g_szLinkToAd[1024];
extern char g_szTextAd[1024];

extern char g_ad_result[4096];

extern  char                   push_token_id[0x100];
extern  int                    g_idGamesCategory[50];
extern  int                    g_xScreenShotCount;
extern  int                    g_idGamesCategoryCunt;
extern  int                    g_myuserid;


extern XScreenShot             *g_xScreenShot;


extern char*                   get_url(char *s) ;


extern  int            g_nXfireSearchedFriendCount;
extern  TXfireFriend   g_xfireSearchedFriends[0x80];
extern int    g_nTotalOnlineUsers;
extern BOOL   g_bIsUsernamesVisible;
extern BOOL   g_bIsClansVisible;
extern BOOL   g_bIsDisableSignature;
extern BOOL   g_bIsShowOfflineFriends;
extern BOOL   g_bIsTokenSent;

extern BOOL   g_bDisableAds;

extern BOOL   g_bIsPlayRecvIMSound;


extern char   g_cMyStatusMessage[0x100];

@class        XfireCore;
extern        XfireCore    *g_pXfireNetCore;

bool hashSha1(  char *string, int len, char *sha);
char * GetGameName(unsigned int gameid);
extern UIDeviceOrientation g_orientation;
void dumpbuffer(char *pBuffer,unsigned short size);