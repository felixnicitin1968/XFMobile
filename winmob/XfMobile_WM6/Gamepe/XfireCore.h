#pragma once

#include<windows.h>

#define MAX_BUFF 0xFFFF

#include <stdio.h>      // standard input/output




#include "Global.h"
#define MSG_OF_THEDAY       0x2E
#define GROUP_SID           4



class CXfireCore:public CAsyncSocket
{
public:

	int                      m_cStatus  ;      
	BOOL                     m_bIsConnected;
	unsigned short           m_dwReadSize ;    
	unsigned short           m_dwTotalReadSize ;
	unsigned short           m_dwBufferSize;

	int                      m_iQueneHead  ;
	int                      m_iQueneTail ;


	class CMsg *            m_pMsgQuene[DEF_MSGQUENESIZE];
	unsigned char		            m_pMsgBuffer[DEF_MSGBUFFERSIZE+1];


	bool m_bReadyToSend;

	CWinThread* m_pThread; // the thread we are running in

	char m_sendBuff[MAX_BUFF];
	int   m_nSendDataLen;    // length of data to send
	int   m_nBytesSent;      // bytes sent so far

	unsigned char m_recvBuff[MAX_BUFF];
	int   m_nRecvDataLen;     // bytes to receive
	int   m_nBytesRecv;       // bytes received so far
	
	BOOL  m_bReadDataLength;  // reading packet header
	
	
	void           AsyncSendBuff(void* lpBuf, int nBufLen);


    static char s_cUserName[0x100];
	static char s_cPassword[0x100];
	static      UINT  s_uTimerID;

	static void StartParser(void);
	static CXfireCore  *s_pCore;
	static BOOL  m_fConnected;       // tcp connection

	static  int  s_nNumOfContacts;
	static vector<XfireContact*> _listContacts;

	static int                getGameId(int userid);
	static  XfireContact*     getContactByID(int userid);
	static  int               getContactIndexByID(int userid);
	static  XfireContact*     getContactBySID(unsigned char *sid);
	static  XfireClan*        getClanByID(long  clanid);
	static  int               s_nTotalOnlineContacts;
	static  int               s_nTotalClans;
	static bool               isFriendAway(int userid);
	static bool               isFriend(char*);
	static XfireContact *     getClanMember(long userid);
	static XfireContact *     getClanMemberbySID(unsigned char *psid);

	static XfireClan          s_ClansList[32]; 
	static  char _cNickname[0x100];

    static HICON  geContactGameImage(int userid);
	static void InitToZero();
	
	static unsigned char g_groupsid[21];

public:
	CXfireCore();
	~CXfireCore();
    void                   Handle_ChatMOTD(unsigned char *pBuffer ,unsigned short dwMsgSize);
	void                   Handle_ChatUserJoin(unsigned char *pBuffer ,unsigned short dwMsgSize);
    void                   Handle_ChatUserPart(unsigned char *pBuffer ,unsigned short dwMsgSize);
	void                   Handle_ChatIM(unsigned char *pBuffer ,unsigned short dwMsgSize);
	void                   Handle_ChatSendIM(uint8 *gsid,char *message);
	void                   Handle_ChatChange_motd( uint8 *gsid, char* motd);
    void                   Handle_BuddyInvitation(unsigned char *pBuffer ,unsigned short dwMsgSize);
	void                   Handle_Invitation_Accept(char *p_name);
	void                   Handle_Invitation_Reject(char *p_name);
	void                   Handle_ChatLeave(uint8 *gsid);
	void                   Handle_TopicChanage(unsigned char *pBuffer ,unsigned short dwMsgSize);
	void                   Handle_JoinRoom(unsigned char *pBuffer ,unsigned short dwMsgSize);
	void                   Handle_CreateRoom(char *room,char *pass);
	void                   Handle_ChatBuddys(unsigned char *pBuffer ,unsigned short dwMsgSize);

	void                   Handle_SendInvite(unsigned char *gsid,unsigned char*);

	void                   handleLoginSuccessPacket(unsigned char* pBuffer,int  MsgSize);
	void                    ModifyNick(char *pNickName);
	void                    Invite(unsigned char* );
    void                    handleContactPlayingGame(unsigned char *pBuffer,unsigned short dwMsgSize);
	//void                    sendAddContactPkt(char * pBuddyName);
	
	//void                    sendMyStatusMessagePacket(const char *pStatusMsg);

	void                    Handle_Clans(unsigned char *pBuffer ,unsigned short dwMsgSize);
	void                    Handle_ClansNames(unsigned char *pBuffer ,unsigned short dwMsgSize);
	void                    HandleStatusMessage(unsigned char *pBuffer ,unsigned short dwMsgSize);
    void                    HandlePlayingGame(unsigned char *pBuffer ,unsigned short dwMsgSize);
    void                    HandleStatus(unsigned char *pBuffer ,unsigned short dwMsgSize);
    void                    HandleSuccessLogin(unsigned char *pBuffer ,unsigned short dwMsgSize);
	void                    HandleContacts(unsigned char *pBuffer ,unsigned short dwMsgSize);
    void                    HandleMismatchVersion(unsigned char *pBuffer ,unsigned short dwMsgSize);
	void                    HandleNewNickName(unsigned char *pBuffer ,unsigned short dwMsgSize);
	void                    HandleIM(unsigned char *pBuffer ,unsigned short dwMsgSize);


	void                    SendIM(uint8 *sid,uint32 imindex,char *Message);
	void                    KeepAlive();
	uint32                  P2P(unsigned char *sid, uint32 ip, uint32 port, uint32 local_ip, uint32 local_port, uint32 nat_type, const char *p_salt);
	void                    Typing(uint8 *sid,uint32 imindex,uint32 typing);
    void                    AddFriend(char *Friend,char *Message);
	void                    MessageOfTheDay(char *Message);

	unsigned char*          cryptPassword(char *pUserName,char *pPassword,unsigned char *pSalt);
    void                    hashSha1(const char *string, unsigned char *sha);

	void		            DoAsyncSendBuff();
	bool                    OnAsyncError(int nErrorCode);

	void                    HandleAuth(unsigned char *pBuffer ,DWORD MsgSize);
	void                    Login();
	void                    ParseMessage(unsigned char *pBuffer , USHORT MsgSize);
	void                    init();
	void                    MsgProcess();
	BOOL                    bGetMsgQuene( unsigned char * pData, DWORD * pMsgSize);
	BOOL                    bPutMsgQuene( unsigned char * pData, DWORD dwMsgSize);


	static BOOL             IsConnected(){return m_fConnected;}

	virtual int Receive(void* lpBuf, int nBufLen, int nFlags = 0);
	virtual int Send(const void* lpBuf, int nBufLen, int nFlags = 0);

	virtual BOOL ShutDown(int nHow = sends);


	virtual  void OnClose(
		int nErrorCode 
		);
	virtual void OnConnect(
		int nErrorCode 
		);

	virtual void OnReceive(
		int nErrorCode 
		);

	virtual void OnSend(
		int nErrorCode 
		);


};






