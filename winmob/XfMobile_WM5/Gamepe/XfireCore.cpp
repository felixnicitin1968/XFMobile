#include "stdafx.h"
#include<windows.h>
#include "SHA1.h"
#include "MsgQue.h"
#include "XfireCore.h"
#include<stdio.h>
#include "resourceppc.h"
#include "Global.h"

void hashSha1(const char *string, unsigned char *sha);


char                  CXfireCore::s_cUserName[0x100];
char                  CXfireCore::s_cPassword[0x100];
CXfireCore           *CXfireCore::s_pCore;
UINT                  CXfireCore::s_uTimerID;
BOOL                  CXfireCore::m_fConnected;
int                   CXfireCore::s_nNumOfContacts;
int                   CXfireCore::s_nTotalOnlineContacts;
int                   CXfireCore::s_nTotalClans;
vector<XfireContact*> CXfireCore::_listContacts;

XfireClan             CXfireCore::s_ClansList[32]; 
char                   CXfireCore::_cNickname[0x100];
unsigned char CXfireCore::g_groupsid[21];


void CXfireCore::InitToZero()
{


	m_fConnected=FALSE;
	_listContacts.clear();
	s_nTotalOnlineContacts=0;

	s_nTotalClans=0;

	s_nNumOfContacts=0;

	for (int i=0; i<32; i++){


		memset(s_ClansList[i].name,0,0x100);

	}


}


unsigned char* CXfireCore::cryptPassword(char *pUserName,char *pPassword,unsigned char *pSalt)

{


	static unsigned char cResult[0x200];
	char cCode[0x100];
	char temp[81];

	strcpy(cCode,pUserName);
	strcat(cCode,pPassword);
	strcat(cCode,"UltimateArena");

	hashSha1(cCode,cResult);

	memcpy(temp,cResult,40);
	memcpy(temp+40,pSalt,40);
	temp[80] = 0x00;
	hashSha1(temp,cResult);
	return cResult;

}




void CXfireCore::hashSha1(const char *string, unsigned char *sha){

	char result[41];
	unsigned char temp[1024];
	CSHA1 sha1;
	sha1.Reset();
	sha1.Update((UINT_8 *)string, strlen(string));
	sha1.Final();
	sha1.GetHash(temp);	

	result[0] = 0; 
	char szTemp[16]; 
	for(int i = 0 ; i < 20 ; i++) { 
		sprintf(szTemp, "%02x", temp[i]); 
		strcat(result,szTemp); 
	}
	memcpy(sha,result,40);
	sha[40] = 0x00;
}


BOOL CXfireCore::bPutMsgQuene(unsigned char * pData, DWORD dwMsgSize)
{
	if (m_pMsgQuene[m_iQueneTail] != NULL) return FALSE;

	m_pMsgQuene[m_iQueneTail] = new class CMsg;
	if (m_pMsgQuene[m_iQueneTail] == NULL) return FALSE;

	if (m_pMsgQuene[m_iQueneTail]->bPut( pData, dwMsgSize) == FALSE) return FALSE;

	m_iQueneTail++;
	if (m_iQueneTail >= DEF_MSGQUENESIZE) m_iQueneTail = 0;

	return TRUE;
}





BOOL CXfireCore::bGetMsgQuene( unsigned char * pData, DWORD * pMsgSize)
{
	if (m_pMsgQuene[m_iQueneHead] == NULL) return FALSE;

	m_pMsgQuene[m_iQueneHead]->Get(pData, pMsgSize);

	delete m_pMsgQuene[m_iQueneHead];
	m_pMsgQuene[m_iQueneHead] = NULL;

	m_iQueneHead++;
	if (m_iQueneHead >= DEF_MSGQUENESIZE) m_iQueneHead = 0;

	return TRUE;
}


CXfireCore::CXfireCore()
{

	m_nBytesSent = m_nSendDataLen = 0;
	m_nRecvDataLen =2;	// initialize for 4 byte data length
	m_nBytesRecv = 0;
	m_fConnected = FALSE;
	m_bReadDataLength = TRUE;

	CXfireCore::s_pCore=this;

	init();

}

CXfireCore::~CXfireCore()
{


	::KillTimer(NULL,s_uTimerID);
	for ( int i = 0; i < DEF_MSGQUENESIZE; i++)  {
		if (m_pMsgQuene[i]){

			delete m_pMsgQuene[i];
			m_pMsgQuene[i] = NULL;

		}
	}

}


void CXfireCore::init()
{



	m_cStatus   = DEF_XSOCKSTATUS_READINGHEADER;      
	m_dwReadSize = 2;    
	m_dwTotalReadSize = 0;
	m_bIsConnected=FALSE;
	m_iQueneHead  = 0;
	m_iQueneTail  = 0;



	int i;
	for ( i = 0; i < DEF_MSGQUENESIZE; i++)  {
		m_pMsgQuene[i] = NULL;
	}


	StartParser();


}



VOID CALLBACK MyParserTimerProc( 
								HWND hwnd,        // handle to window for timer messages 
								UINT message,     // WM_TIMER message 
								UINT idTimer,     // timer identifier 
								DWORD dwTime)     // cuputrrent system time 
{ 


	CXfireCore::s_pCore->MsgProcess();

} 


VOID CALLBACK KeepAliveTimerProc( 
								HWND hwnd,        // handle to window for timer messages 
								UINT message,     // WM_TIMER message 
								UINT idTimer,     // timer identifier 
								DWORD dwTime)     // cuputrrent system time 
{ 

    
	CXfireCore::s_pCore->KeepAlive();

} 


void CXfireCore::StartParser(void)
{

	s_uTimerID = ::SetTimer(NULL,      // handle to main window 
		101,            // timer identifier 
		300,                    // 10-second interval 
		(TIMERPROC) MyParserTimerProc); // timer callback 


	s_uTimerID = ::SetTimer(NULL,      // handle to main window 
		102,            // timer identifier 
		1000*240,                    // 10-second interval 
		(TIMERPROC) KeepAliveTimerProc); // timer callback 



}



XfireContact*   CXfireCore::getContactBySID(unsigned char *sid)
{

	for (unsigned int i=0; i<_listContacts.size(); i++)   {



		XfireContact* xcontact=(XfireContact*) _listContacts.at(i);



		if (memcmp(xcontact->sid,sid,16)==0) {


			return xcontact; 
		} 

	}

	return NULL;
}




HICON  CXfireCore::geContactGameImage(int userid)
{


	XfireContact* xcontact=getContactByID(userid);

	if (xcontact==NULL){

		xcontact=getClanMember(userid);

	}

	if (xcontact==NULL) return NULL;


	return xcontact->hGameImage;
}
int  CXfireCore::getGameId(int userid)
{


	XfireContact* xcontact=getContactByID(userid);

	if (xcontact==NULL){

		xcontact=getClanMember(userid);

	}

	if (xcontact==NULL) return false;


	return xcontact->gameid;
}
bool   CXfireCore::isFriendAway(int userid)
{


	XfireContact* xcontact=getContactByID(userid);

	if (xcontact==NULL){

		xcontact=getClanMember(userid);

	}

	if (xcontact==NULL) return false;


	if (xcontact->uStatus==MISTATUS_AWAY) {


		return true; 
	} 



	return false;
}




void CXfireCore:: handleContactPlayingGame(unsigned char *pBuffer,unsigned short dwMsgSize)
{
	
	

	DbgMsg(L"Enter handleContactPlayingGame");

	
	unsigned int gameid;
	
	unsigned short userscount;

	unsigned char *sids=0;

	unsigned char *cp=pBuffer;
	cp+=2;
	if (*cp==3){ //strlen("sid")
		
		cp+=1;
		if (memcmp(cp,"sid",3)==0){
		
			cp+=5;
			
			
			userscount=*(cp+1)&0xFF;
			userscount<<=8;
			userscount|=*(cp+0);


			cp+=2;
		

			sids=new unsigned char[16*userscount];



			for (int i=0; i<userscount; i++)
			{



				memcpy(sids+i*16,cp,16);

				cp+=16;



			}




			
			
			
			if (*cp==6){
			
				if (memcmp(cp+1,"gameid",6)==0){
					
				
					cp+=7;
					
					cp+=2;
					

					unsigned short gameidscount=*(unsigned short*)cp;

					gameidscount=*(cp+1)&0xFF;
					gameidscount<<=8;
					gameidscount|=*(cp+0);

					cp+=2;
					
					for (int i=0; i< gameidscount; i++){
					
					


						gameid=*(cp+3)&0xFF;

						gameid<<=8;
						gameid|=*(cp+2);
						gameid<<=8;
						gameid|=*(cp+1);
						gameid<<=8;
						gameid|=*(cp+0);



						unsigned char  sid[16];
						memcpy(sid,sids+i*16,16);


						XfireContact *pFriend=getContactBySID(sid);

						if (pFriend==NULL){

							pFriend=getClanMemberbySID(sid);
						}

						if (pFriend!=NULL){
							
													
							pFriend->gameid=gameid;

							CloseHandle(pFriend->hGameImage);


							pFriend->hGameImage=(HICON)LoadImage( AfxGetApp()->m_hInstance, 
								MAKEINTRESOURCE(gameid), IMAGE_ICON, 
								12, 12, 0 );
							


							
							char *pName=GetGameName(gameid);
							if (pName)  {
							
								
								strcpy(pFriend->cGamename,pName);


								 ::PostMessage(g_hContactsWnd,WM_FRIEND_STATUS,(WPARAM)pFriend,0);

							}
						}
						
					
						cp+=4;
						
					}
					
					
					if (*cp==3){
					
						if (memcmp(cp+1,"gip",3)==0){
							
							//NSLog(@" GIP was found");  //we dont care////

							
							
						}
						
						
					}
									}
				
			
				if (sids)
				free(sids);
			}
			//NSLog(@"sid was found for playing game");
			
		}
		
		
	}
	
	


}




void CXfireCore::SendIM(uint8 *sid,uint32 imindex,char *Message)
{


	uint8 packet[0x400];
	uint32 ptr=5;
	
	ptr=write_attribute(packet,ptr,"sid",SID_TYPE,(uint8*)sid);


	uint8 peermsg=3; //number of child attribute
	ptr=write_attribute(packet,ptr,"peermsg",CHILDS_TYPE,&peermsg);

  
	uint32 msgtype=0;
	ptr=write_attribute(packet,ptr,"msgtype",INT_TYPE,(uint8*)&msgtype);

	ptr=write_attribute(packet,ptr,"imindex",INT_TYPE,(uint8*)&imindex);

	ptr=write_attribute(packet,ptr,"im",STRING_TYPE,(uint8*)Message);

	add_header(packet,ptr,0x0002,2);


	AsyncSendBuff((char*)packet,ptr);

	

}

void CXfireCore::KeepAlive()
{



	uint8 packet[0x400];
	uint32 ptr=5;
	
	uint32 value=0;
	ptr=write_attribute(packet,ptr,"value",INT_TYPE,(uint8*)&value);
	
	ptr=write_array_attribute(packet,ptr,"stats",INT_TYPE,0,0);

	add_header(packet,ptr,13,2);


	AsyncSendBuff((char*)packet,ptr);

}


uint32 CXfireCore::P2P(unsigned char *sid, uint32 ip, uint32 port, uint32 local_ip, uint32 local_port, uint32 nat_type, const char *p_salt)
{


	
	uint8 packet[0x400];
	uint32 ptr = 5;

	ptr=write_attribute(packet,ptr,"sid",SID_TYPE,(uint8*)sid);
	
	uint8 peermsg=7; //number of child attribute
	ptr=write_attribute(packet,ptr,"peermsg",CHILDS_TYPE,&peermsg);

	uint32	msgtype=2;
	ptr=write_attribute(packet,ptr,"msgtype",INT_TYPE,(uint8*)&msgtype);
	ptr=write_attribute(packet,ptr,"ip",INT_TYPE,(uint8*)&ip);
	ptr=write_attribute(packet,ptr,"port",INT_TYPE,(uint8*)&port);
	ptr=write_attribute(packet,ptr,"localip",INT_TYPE,(uint8*)&local_ip);
	ptr=write_attribute(packet,ptr,"localport",INT_TYPE,(uint8*)&local_port);
	ptr=write_attribute(packet,ptr,"status",INT_TYPE,(uint8*)&nat_type);
	ptr=write_attribute(packet,ptr,"salt",STRING_TYPE,(uint8*)p_salt);
	add_header(packet,ptr,0x0002,2);
	
	AsyncSendBuff((char*)packet,ptr);

	return ptr;

}
void CXfireCore::Typing(uint8 *sid,uint32 imindex,uint32 typing)
{


	
	uint8 packet[0x400];
	uint32 ptr=5;
	
	ptr=write_attribute(packet,ptr,"sid",SID_TYPE,(uint8*)sid);


	uint8 peermsg=3; //number of child attribute
	ptr=write_attribute(packet,ptr,"peermsg",CHILDS_TYPE,&peermsg);

  
	uint32 msgtype=3; //TYPING MODE
	ptr=write_attribute(packet,ptr,"msgtype",INT_TYPE,(uint8*)&msgtype);

	ptr=write_attribute(packet,ptr,"imindex",INT_TYPE,(uint8*)&imindex);

	ptr=write_attribute(packet,ptr,"typing",INT_TYPE,(uint8*)&typing);

	add_header(packet,ptr,0x0002,2);


	AsyncSendBuff((char*)packet,ptr);

	

}


void CXfireCore::AddFriend(char *Friend,char *Message)
{


	uint8 packet[0x100];
	uint32 ptr=5;


	ptr=write_attribute(packet,ptr,"name",STRING_TYPE,(uint8*)Friend);


	ptr=write_attribute(packet,ptr,"msg",STRING_TYPE,(uint8*)Message);

	add_header(packet,ptr,0x0006,2);

	AsyncSendBuff((char*)packet,ptr);



}

/*
void CXfireCore::sendAddContactPkt(char * pBuddyName)
{


	char *pkt=new char[0x100];
	int ptr=0;

	ptr+=2;

	pkt[ptr++]=6;
	pkt[ptr++]=0;
	pkt[ptr++]=2;


	pkt[ptr++]=4;
	pkt[ptr++]='n';
	pkt[ptr++]='a';
	pkt[ptr++]='m';
	pkt[ptr++]='e';

	pkt[ptr++]=0x01;

	pkt[ptr++]=(char)strlen(pBuddyName);

	pkt[ptr++]=0;


	memcpy(&pkt[ptr],pBuddyName,strlen(pBuddyName));
	ptr+=strlen(pBuddyName);

	pkt[ptr++]=3;//strlen(msg)


	pkt[ptr++]='m';
	pkt[ptr++]='s';
	pkt[ptr++]='g';

	pkt[ptr++]=1;
	pkt[ptr++]=0;
	pkt[ptr++]=0;


	pkt[0]=(char)ptr;
	pkt[1]=0x00;


	AsyncSendBuff(pkt,ptr);


}




void CXfireCore::KeepAlive()
{
    char pkt[0x100];
	int ptr=0;

	ptr+=2;

	pkt[ptr++]=13;
	pkt[ptr++]=0;
	pkt[ptr++]=2;

	

	pkt[ptr++] = 0x05;
	pkt[ptr++] = 'v';
	pkt[ptr++] = 'a';
	pkt[ptr++] = 'l';
    pkt[ptr++] = 'u';
	pkt[ptr++] = 'e';



	pkt[ptr++] = 0x02;
	pkt[ptr++] = 0x00;
	pkt[ptr++] = 0x00;
	pkt[ptr++] = 0x00;
    pkt[ptr++] = 0x00;
	
    pkt[ptr++] = 0x05;
	pkt[ptr++] = 's';
	pkt[ptr++] = 't';
	pkt[ptr++] = 'a';
    pkt[ptr++] = 't';
	pkt[ptr++] = 's';

	pkt[ptr++] = 0x04;
	pkt[ptr++] = 0x02;
	pkt[ptr++] = 0x00;
	pkt[ptr++] = 0x00;

	pkt[0]=(char)ptr;
	pkt[1]=0x00;

	AsyncSendBuff(pkt,ptr);



	
}*/


void CXfireCore::HandleNewNickName(unsigned char *pBuffer ,unsigned short dwMsgSize)
{

	
	uint32 ptr=3;

	uint32 userid;
	ptr=read_attribute_noname(pBuffer,ptr,USERID_TYPE,(uint8*)&userid);


	uint32 nickname_buffersize=read_attribute_noname(pBuffer,ptr,NICKNAME_TYPE,0);

	if (nickname_buffersize<=0) return;

	uint8 *nickname_bufferptr=(uint8*)malloc(nickname_buffersize+1);
	memset(nickname_bufferptr,0,nickname_buffersize+1);

	ptr=read_attribute_noname(pBuffer,ptr,NICKNAME_TYPE,nickname_bufferptr);


	free(nickname_bufferptr);


}

 void CXfireCore::handleLoginSuccessPacket(unsigned char* pBuffer,int  MsgSize)
	{
		
		int ptr=0;
		
		ptr+=3; //header - size
		
		ptr+=7; //"userid"
		
		ptr+=4;
		
		ptr+=5; //sid
		
		ptr+=18;
		
		
		
		
	
		if (pBuffer[ptr]=='n' && pBuffer[ptr+1]=='i' &&pBuffer[ptr+2]=='c' &&pBuffer[ptr+3]=='k'){
			
			ptr+=4;
			
			ptr+=1;
			

			short nUserLen=(short)pBuffer[(ptr+1)];       //16
			nUserLen<<=8; 
			nUserLen|=(short)(0xFF & pBuffer[(ptr)]);  //15

			ptr+=2;
			
			memcpy(_cNickname,&pBuffer[ptr],nUserLen);
		//	Log.v(TAG,"NICK FOUND  cNickname= "+new String(cNickname,0,nUserLen));
			
			//_myNickname=new String(cNickname,0,nUserLen);
			if (nUserLen==0)
				strcpy(_cNickname,"Me");
		
		}else{

			strcpy(_cNickname,"Me");

		}
		
			
		ptr+=5;
		
		

		
	}



void CXfireCore::ModifyNick(char *pNickName)
{

	unsigned char cPkt[0x100];
	int ptr=0;
	ptr+=2;
	cPkt[ptr++]=0x0E;
	cPkt[ptr++]=0x00;
	cPkt[ptr++]=0x01;
	cPkt[ptr++]=0x04;

	
	memcpy(&cPkt[ptr],"nick",4);

	ptr+=4;
	cPkt[ptr++]=0x01;

	cPkt[ptr++]=strlen(pNickName);
	cPkt[ptr++]=0;
   

	memcpy(&cPkt[ptr],pNickName,strlen(pNickName));

    ptr+=strlen(pNickName);
	cPkt[0]=(char)ptr;
	cPkt[1]=0x00;


	AsyncSendBuff(cPkt,ptr);




}



bool   CXfireCore::isFriend(char* pFriend)
{

	for (unsigned int i=0; i<_listContacts.size(); i++)   {



		XfireContact* xcontact=(XfireContact*) _listContacts.at(i);



		if (strstr(xcontact->cUsername,pFriend)) {


			return true; 
		} 

	}

	return false;
}


XfireContact * CXfireCore::getClanMemberbySID(unsigned char *psid)
{


	for (int i=0; i<CXfireCore::s_nTotalClans; i++){


		for (int j=0; j<CXfireCore::s_ClansList[i].usercount; j++){


			XfireContact *pContact=CXfireCore::s_ClansList[i]._listContacts.at(j);

			if (memcmp(psid,pContact->sid,16)==0) {

				
				   return pContact;

			}
		}
	}

	return NULL;


}
XfireContact * CXfireCore::getClanMember(long userid)
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

XfireContact*   CXfireCore::getContactByID(int userid)
{

	for (unsigned int i=0; i<_listContacts.size(); i++)   {


		XfireContact* xcontact=(XfireContact*) _listContacts.at(i);

		if (xcontact->userid==userid) {

			return xcontact;
		}

	}

	return NULL;
}



int   CXfireCore::getContactIndexByID(int userid)
{

	for (unsigned int i=0; i<_listContacts.size(); i++)   {



		XfireContact* xcontact=(XfireContact*) _listContacts.at(i);



		if (xcontact->userid==userid) {


			return i; 
		} 

	}

	return -1;
}

XfireClan*   CXfireCore::getClanByID(long  clanid)

{

	for (int j=0; j<32; j++){


		if (s_ClansList[j].id==clanid)
			return &s_ClansList[j];
	}

	return NULL;

}

/*
void sendAddContactPacket:(const char *)pBuddyName
{


unsigned char pkt[0x200]={0};
unsigned char *cp=pkt+2;
*cp++=6; //packet id
*cp++=0;
*cp++=2;//attrib number
*cp++=strlen("name");
memcpy(cp,"name",strlen("name"));
cp+=strlen("name");

*cp++=0x1;
*cp++=strlen(pBuddyName);
*cp++=0;
memcpy(cp,pBuddyName,strlen(pBuddyName));
cp+=strlen(pBuddyName);

*cp++=strlen("msg");
memcpy(cp,"msg",strlen("msg"));
cp+=strlen("msg");
*cp++=1;
*cp++=0;
*cp++=0;


*(unsigned short*)pkt=cp-pkt;


[self sendPacketMsg:pkt length:*(unsigned short*)pkt];

}*/





void CXfireCore::HandleIM(unsigned char *pBuffer ,unsigned short dwMsgSize)
{


	uint32 ptr=3;

	uint8 user_sid[16];

	ptr=read_attribute(pBuffer,ptr,"sid",SID_TYPE,(uint8*)user_sid);


	uint8 attribute_count=0;
	ptr=read_attribute(pBuffer,ptr,"peermsg",CHILDS_TYPE,&attribute_count);


	uint32 msgtype;

	ptr=read_attribute(pBuffer,ptr,"msgtype",INT_TYPE,(uint8*)&msgtype);

#define TYPING_MSG  3
#define NETWORK_MSG 2
#define IM_MSG      0


	switch(msgtype)
	{


	case IM_MSG:

		
		{
		


		uint32 imindex;

		ptr=read_attribute(pBuffer,ptr,"imindex",INT_TYPE,(uint8*)&imindex);

		uint32 im_buffer_size=read_attribute(pBuffer,ptr,"im",STRING_TYPE,0);
        
		uint8 *imbuffer_ptr=(uint8*)malloc(im_buffer_size+1);
		memset(imbuffer_ptr,0,im_buffer_size+1);

		ptr=read_attribute(pBuffer,ptr,"im",STRING_TYPE,imbuffer_ptr);
	


	

		XfireContact *pXfireContact=getContactBySID(user_sid);

		if (pXfireContact==NULL){

			pXfireContact=getClanMemberbySID(user_sid);
		}


		if (pXfireContact) {


			pXfireContact->imIndex=imindex;

			if (strlen((char*)imbuffer_ptr)<0x100){


				if (g_bIsSoundNotification){

					PlaySound(MAKEINTRESOURCE(IDR_WAVE2), ::GetModuleHandle(NULL),SND_ASYNC | SND_RESOURCE);

				}

				::SendMessage(g_hContactsWnd,WM_ADD_CONVERSATION,(WPARAM)pXfireContact,0);

				char *msg=new char[im_buffer_size+1];
				memset(msg,0,im_buffer_size+1);
				memcpy(msg,imbuffer_ptr+2,im_buffer_size-2);

			
				::SendMessage(g_hContactsWnd,WM_RECV_IM,(WPARAM)pXfireContact,(LPARAM)msg);

			}
		}

		free(imbuffer_ptr);

		unsigned char im_ACK[] = {
			0x3e, 0x00,//62 bytes
			0x02, 0x00, //or 0x02
			0x02, 
			0x03, 0x73, 0x69, 0x64,
			0x03, 
			0xCC, 0xCC, 0xCC, 0xCC, 0xCC, 0xCC, 
			0xCC, 0xCC, 0xCC, 0xCC, 0xCC, 0xCC, 0xCC, 0xCC, 
			0xCC, 0xCC, 
			
			0x07, 0x70, 0x65, 0x65, 0x72, 0x6d,0x73, 0x67, //peermsg
			0x05, 0x02,
			
			0x07, 0x6d, 0x73, 0x67, 0x74, 0x79, 0x70, 0x65, 
			0x02, 0x01, 0x00, 0x00, 0x00, 

			0x07, 0x69, 0x6d, 0x69, 0x6e, 0x64, 0x65, 0x78, 
			0x02, 0xCC, 0xCC, 0xCC, 0xCC };


			memcpy(&im_ACK[10],user_sid,16);
			memcpy(&im_ACK[58],&imindex,4);

			AsyncSendBuff((char*)im_ACK,0x3E);

		}

	
		break;

	case TYPING_MSG:


		uint32 imindex;
		ptr=read_attribute(pBuffer,ptr,"imindex",INT_TYPE,(uint8*)&imindex);

		uint32  typing;
		ptr=read_attribute(pBuffer,ptr,"typing",INT_TYPE,(uint8*)&typing);


		

		break;

	case NETWORK_MSG:

		
		{
		   uint32 public_ip;
		   ptr=read_attribute(pBuffer,ptr,"ip",INT_TYPE,(uint8*)&public_ip);
		   uint32 public_port;
		   ptr=read_attribute(pBuffer,ptr,"port",INT_TYPE,(uint8*)&public_port);


		   uint32 local_ip;
		   ptr=read_attribute(pBuffer,ptr,"localip",INT_TYPE,(uint8*)&local_ip);
		   uint32 local_port;
		   ptr=read_attribute(pBuffer,ptr,"localport",INT_TYPE,(uint8*)&local_port);


		   uint32 status;
		   ptr=read_attribute(pBuffer,ptr,"status",INT_TYPE,(uint8*)&status);

		   
		   uint32 salt_length=read_attribute(pBuffer,ptr,"salt",STRING_TYPE,0);
	

		   uint8 *saltbuffer_ptr=(uint8*)malloc(salt_length+1);
		   memset(saltbuffer_ptr,0,salt_length+1);

		   ptr=read_attribute(pBuffer,ptr,"salt",STRING_TYPE,saltbuffer_ptr);

		   memcpy(&salt_length,saltbuffer_ptr,2);

		  



		 

		   if (status>0){

			  //P2P(user_sid, htonl(inet_addr("10.0.0.2")),P2P_PORT, htonl(inet_addr("10.0.0.2")),P2P_PORT,4,(char*)saltbuffer_ptr);
		   }


		   
		   free(saltbuffer_ptr);
	



		}


		break;

	

	default:
		break;
	}




	



}

void CXfireCore::MessageOfTheDay(char *Message)
{


	uint8 packet[0x100];
	uint32 ptr=5;
	ptr=write_attribute_noname(packet,ptr,MSG_OF_THEDAY,(uint8*)Message);

	add_header(packet,ptr,0x0020,1);

	AsyncSendBuff((char*)packet,ptr);
	



}



void CXfireCore::Invite(unsigned char *sid)
{


	int imindex=0 ;

	XfireContact *pContact=getContactBySID(sid);


	if (pContact) {


		imindex=pContact->imIndex;
		pContact->imIndex++;


	}else{

		pContact=getClanMemberbySID(sid);

		if (pContact) {


			imindex=pContact->imIndex;
			pContact->imIndex++;
		}

	}


	SendIM(sid,imindex,"invite to join Xfire mobile @ http://www.gamepe.com");
	           
	
	 


}





void CXfireCore::Handle_Clans(unsigned char *pBuffer ,unsigned short dwMsgSize)
{

	
	uint32 ptr=3;


	uint32 clans_id_buffersize=read_attribute_noname(pBuffer,ptr,CLANID_TYPE,NULL);

	uint32 clans_count=clans_id_buffersize/4;


	if (clans_count==0)  {



	
		return;
	}

	s_nTotalClans=clans_count;

	memset(&s_ClansList,0,sizeof(s_ClansList));

	uint32 *clans_id_buffer=(uint32*)malloc(clans_id_buffersize);

	ptr=read_attribute_noname(pBuffer,ptr,CLANID_TYPE,(uint8*)clans_id_buffer);


	for (unsigned int i=0; i<clans_count; i++) {


		 unsigned  int clanid;
		 
		 memcpy(&clanid,clans_id_buffer+i,4);

		 s_ClansList[i].id=clanid;

	}





	uint32 clans_nicknames_buffersize=read_attribute_noname(pBuffer,ptr,CLAN_NICKNAME_TYPE,NULL);

	uint8 *clans_nicknames_buffer=(uint8*)malloc(clans_nicknames_buffersize);

	ptr=read_attribute_noname(pBuffer,ptr,CLAN_NICKNAME_TYPE,clans_nicknames_buffer);

	uint8 *clans_nickname_startbuffer=clans_nicknames_buffer;
	for (uint32 i=0; i<clans_count; i++){


		uint16 clan_nicknamelen;

		memcpy(&clan_nicknamelen,clans_nickname_startbuffer,2);
		clans_nickname_startbuffer+=2;


		if (clan_nicknamelen!=0){
		
			uint8 *clan_nickname=(uint8*)malloc(clan_nicknamelen+1);

			memset(clan_nickname,0,clan_nicknamelen+1);
			memcpy(clan_nickname,clans_nickname_startbuffer,clan_nicknamelen);

			memcpy(s_ClansList[i].name,clan_nickname,clan_nicknamelen+1);
		

		    free(clan_nickname);
		}
		clans_nickname_startbuffer+=clan_nicknamelen;
	}


	uint32 clans_realnames_buffersize=read_attribute_noname(pBuffer,ptr,CLAN_REALNAME_TYPE,NULL);



	uint8 *clans_realnames_buffer=(uint8*)malloc(clans_realnames_buffersize);

	read_attribute_noname(pBuffer,ptr,CLAN_NICKNAME_TYPE,clans_realnames_buffer);





	uint8 *clans_realname_startbuffer=clans_realnames_buffer;
	for (uint32 i=0; i<clans_count; i++){


		uint16 clan_realnamelen;

		memcpy(&clan_realnamelen,clans_realname_startbuffer,2);
		clans_realname_startbuffer+=2;


		if (clan_realnamelen!=0){
		
			uint8 *clan_realname=(uint8*)malloc(clan_realnamelen+1);

			memset(clan_realname,0,clan_realnamelen+1);
			memcpy(clan_realname,clans_realname_startbuffer,clan_realnamelen);

	

		    free(clan_realname);
		}
		clans_realname_startbuffer+=clan_realnamelen;
	}



	free(clans_realnames_buffer);
	free(clans_nicknames_buffer);

	free(clans_id_buffer);

	::SendMessage(g_hContactsWnd,WM_ADD_CLANS,(LPARAM)0,0);

}
void CXfireCore::Handle_ClansNames(unsigned char *pBuffer ,unsigned short dwMsgSize)
{

	
	uint32 ptr=3;

	uint32 clanid;
	ptr=read_attribute_noname(pBuffer,ptr,CLANID_TYPE,(uint8*)&clanid);


	
	XfireClan* pXfireClans=getClanByID(clanid);

	if (!pXfireClans){


		//DbgMsg(L"CLAN NOT FOUND ERRRRRRRRRRRRRRRRRRRRRROR\n");
		return;
	}

	uint32 clans_usersid_buffersize=read_attribute_noname(pBuffer,ptr,CLANS_USERIDS_TYPE,NULL);


	uint32 *clans_usersid_buffer=(uint32*)malloc(clans_usersid_buffersize);

	ptr=read_attribute_noname(pBuffer,ptr,CLANID_TYPE,(uint8*)clans_usersid_buffer);


	uint32 clans_usersid_count=clans_usersid_buffersize/4;

	
	if (clans_usersid_count==0)  {





		free(clans_usersid_buffer);

		return;
	}

	pXfireClans->usercount=clans_usersid_count;



	for (unsigned int j=0; j<pXfireClans->_listContacts.size(); j++){

		XfireContact *pContact=pXfireClans->_listContacts.at(j);

		if (pContact) {

			delete pContact;


		}
	}




	for (unsigned int i=0; i<clans_usersid_count; i++)
	{

		unsigned int userid;

		memcpy(&userid,clans_usersid_buffer+i,4);

		pXfireClans->_listContacts.push_back(new XfireContact());

		XfireContact *pContact=pXfireClans->_listContacts.at(i);
	

		pContact->userid =userid;
		pContact->uStatus=MISTATUS_OFFLINE;


	}
	uint32 clans_realnames_buffersize=read_attribute_noname(pBuffer,ptr,CLAN_NICKNAME_TYPE,NULL);



	uint8 *clans_realnames_buffer=(uint8*)malloc(clans_realnames_buffersize);

	ptr=read_attribute_noname(pBuffer,ptr,CLAN_NICKNAME_TYPE,clans_realnames_buffer);




	uint8 *clans_realname_startbuffer=clans_realnames_buffer;
	for (uint32 i=0; i<clans_usersid_count; i++){


		uint16 clan_realnamelen;

		memcpy(&clan_realnamelen,clans_realname_startbuffer,2);
		clans_realname_startbuffer+=2;


		if (clan_realnamelen!=0){
		
			uint8 *clan_realname=(uint8*)malloc(clan_realnamelen+1);

			memset(clan_realname,0,clan_realnamelen+1);
			memcpy(clan_realname,clans_realname_startbuffer,clan_realnamelen);

			//CApp::PutLogList((char*)clan_realname);

			XfireContact *pContact=pXfireClans->_listContacts.at(i);

			memcpy(pContact->cUsername,clan_realname,clan_realnamelen+1);


		    free(clan_realname);
		}
		clans_realname_startbuffer+=clan_realnamelen;
	}


	uint32 clans_nicknames_buffersize=read_attribute_noname(pBuffer,ptr,NICKNAME_TYPE,NULL);


	uint8 *clans_nicknames_buffer=(uint8*)malloc(clans_nicknames_buffersize);

	ptr=read_attribute_noname(pBuffer,ptr,CLAN_NICKNAME_TYPE,clans_nicknames_buffer);

	uint8 *clans_nickname_startbuffer=clans_nicknames_buffer;
	for (uint32 i=0; i<clans_usersid_count; i++){


		uint16 clan_nicknamelen;

		memcpy(&clan_nicknamelen,clans_nickname_startbuffer,2);
		clans_nickname_startbuffer+=2;


		if (clan_nicknamelen!=0){
		
			uint8 *clan_nickname=(uint8*)malloc(clan_nicknamelen+1);

			memset(clan_nickname,0,clan_nicknamelen+1);
			memcpy(clan_nickname,clans_nickname_startbuffer,clan_nicknamelen);

			//CApp::PutLogList((char*)clan_nickname);

			XfireContact *pContact=pXfireClans->_listContacts.at(i);

			memcpy(pContact->cNickname,clan_nickname,clan_nicknamelen+1);


		    free(clan_nickname);
		}
		clans_nickname_startbuffer+=clan_nicknamelen;
	}



	free(clans_realnames_buffer);
	free(clans_nicknames_buffer);
	free(clans_usersid_buffer);
//	CApp::PutLogList(dbgmsg);
	
	


}



void CXfireCore::HandleStatusMessage(unsigned char *pBuffer ,unsigned short dwMsgSize)

{


	uint32 ptr=3;

	uint32 users_sid_buffersize=read_attribute(pBuffer,ptr,"sid",ARRAY_TYPE,0);

    uint8   *users_sid_ptr=(uint8*)malloc(users_sid_buffersize);

	ptr=read_attribute(pBuffer,ptr,"sid",ARRAY_TYPE,users_sid_ptr);
	for (uint32 i=0; i<users_sid_buffersize/16; i++){

		//CApp::PutLogList(byteArrayToHexString(users_sid_ptr+i*16,16));

	}


	 uint32 friends_msgs_buffersize=read_attribute(pBuffer,ptr,"msg",ARRAY_TYPE,0);

	 if (friends_msgs_buffersize==-1){

		// CApp::PutLogList("Enter XfMobile_HandleStatusMessage:ERROR");
		 return;
	 }
	
	 uint8   *friends_msgs_ptr=(uint8*)malloc(friends_msgs_buffersize);


	 ptr=read_attribute(pBuffer,ptr,"msg",ARRAY_TYPE,(uint8*)friends_msgs_ptr);

	uint32  msgs_count=0;

	uint8  *friends_msgs_ptr_start=friends_msgs_ptr;

	 while(friends_msgs_ptr_start!=(friends_msgs_ptr+friends_msgs_buffersize)){

		

		uint16 msg_len=0;
		memcpy(&msg_len,friends_msgs_ptr_start,2);

	    friends_msgs_ptr_start+=2;
		if (msg_len){

			uint8 *msg=(uint8*)malloc(msg_len+1);
			memset(msg,0,msg_len+1);

			memcpy(msg,friends_msgs_ptr_start,msg_len);

			 //CApp::PutLogList((char*)msg);

			unsigned char sid[16];
			memcpy(sid,users_sid_ptr+msgs_count*16,16);

			XfireContact *pXfireContact=getContactBySID(sid);

			if (pXfireContact==NULL){

				pXfireContact=getClanMemberbySID(sid);
			}

			if (pXfireContact) {


				pXfireContact->gameid=0;
				memset(pXfireContact->cStatusMsg,0,sizeof(pXfireContact->cStatusMsg));
				memcpy(pXfireContact->cStatusMsg,msg,msg_len+1);

			
				::PostMessage(g_hContactsWnd,WM_FRIEND_STATUS,(WPARAM)pXfireContact,0);

			}else{


				DbgMsg(L"UPDATE STATUS SID WAS NOT FOUND\n");
			}



			
			free(msg);
		}else{

			 //CApp::PutLogList((char*)"no status message");

		}

		friends_msgs_ptr_start+=msg_len;

		msgs_count++;


	}


	free(friends_msgs_ptr);
	free(users_sid_ptr);



}

void CXfireCore::HandleStatus(unsigned char *pBuffer ,unsigned short dwMsgSize)
{
	
	uint32 ptr=3;


	uint8 zerosid[16];
	memset(zerosid,0,sizeof(zerosid));

	uint32 users_id_buffersize=read_attribute(pBuffer,ptr,"userid",ARRAY_TYPE,0);
	
	if (users_id_buffersize==-1){
	
		//CApp::PutLogList("HandleBuddyStatus attribute userid not found");
		return;
	}

	uint32   *users_id_ptr=(uint32*)malloc(users_id_buffersize);

	ptr=read_attribute(pBuffer,ptr,"userid",ARRAY_TYPE,(uint8*)users_id_ptr);



	uint32 users_sid_buffersize=read_attribute(pBuffer,ptr,"sid",ARRAY_TYPE,0);
	
	if (users_sid_buffersize==-1) {
	
		//CApp::PutLogList("HandleBuddyStatus attribute sid not found");
		return;
	}

	uint8   *users_sid_ptr=(uint8*)malloc(users_sid_buffersize);

	ptr=read_attribute(pBuffer,ptr,"sid",ARRAY_TYPE,users_sid_ptr);


	for (uint32 i=0; i<users_sid_buffersize/16; i++){

		//CApp::PutLogList(byteArrayToHexString(users_sid_ptr+i*16,16));

		bool  is_online=false;

		if (memcmp(zerosid,users_sid_ptr+i*16,16)==0){

			
			is_online=false;
		}else{

			is_online=true;
		
		
		}


		unsigned int userid;

        memcpy(&userid,users_id_ptr+i,4);



		int nIndex=getContactIndexByID(userid);

		XfireContact* pXfireContact=NULL;


		if (nIndex!=-1){

			pXfireContact=(XfireContact*) _listContacts.at(nIndex);


		}

		if (pXfireContact==NULL){

			pXfireContact=getClanMember(userid);

		}

		if (pXfireContact==NULL){


			DbgMsg(L"HandleBuddyStatus:contact not in friends list or clan groups ERROR!\n" );
			return;
		}

	

		memcpy(pXfireContact->sid,users_sid_ptr+i*16,16);

		if (is_online==false){

			if (s_nTotalOnlineContacts!=0){

				s_nTotalOnlineContacts--;
			}




			pXfireContact->uStatus=MISTATUS_OFFLINE;

			::SendMessage(g_hContactsWnd,WM_REMOVE_FRIEND,(LPARAM)pXfireContact,0);


		}else{


			s_nTotalOnlineContacts++;



			pXfireContact->uStatus=MISTATUS_ONLINE;

			::SendMessage(g_hContactsWnd,WM_ADD_FRIEND,(LPARAM)pXfireContact,0);



		}




	}

	free(users_id_ptr);
	free(users_sid_ptr);




		

}


void CXfireCore::HandlePlayingGame(unsigned char *pBuffer ,unsigned short dwMsgSize)
{


	//CApp::PutLogList("Enter XfMobile_HandlePlayingGame");

	uint32 ptr=3;

	uint32 users_sid_buffersize=read_attribute(pBuffer,ptr,"sid",ARRAY_TYPE,0);

	if (users_sid_buffersize==-1) return;


    uint8   *users_sid_ptr=(uint8*)malloc(users_sid_buffersize);

	ptr=read_attribute(pBuffer,ptr,"sid",ARRAY_TYPE,users_sid_ptr);

	for (uint32 i=0; i<users_sid_buffersize/16; i++){

		
	}


	uint32 users_gameids_buffersize=read_attribute(pBuffer,ptr,"gameid",ARRAY_TYPE,0);
	
	if (users_gameids_buffersize==-1) return;

	uint8 *users_gameids_buffer=(uint8*)malloc(users_gameids_buffersize);

	ptr=read_attribute(pBuffer,ptr,"gameid",ARRAY_TYPE,users_gameids_buffer);


	for (uint32 i=0; i<users_gameids_buffersize/4; i++){


		
		uint32 gameid;
		memcpy(&gameid,users_gameids_buffer+i*4,4);
	
		//CApp::PutLogList(dbgmsg);


		unsigned char  sid[16];
		memcpy(sid,users_sid_ptr+i*16,16);


		XfireContact *pFriend=getContactBySID(sid);

		if (pFriend==NULL){

			pFriend=getClanMemberbySID(sid);
		}

		if (pFriend!=NULL){


			pFriend->gameid=gameid;

			CloseHandle(pFriend->hGameImage);


			pFriend->hGameImage=(HICON)LoadImage( AfxGetApp()->m_hInstance, 
				MAKEINTRESOURCE(gameid), IMAGE_ICON, 
				12, 12, 0 );


			char *pName=GetGameName(gameid);
			if (pName)  {


				strcpy(pFriend->cGamename,pName);


				::PostMessage(g_hContactsWnd,WM_FRIEND_STATUS,(WPARAM)pFriend,0);

			}
		}



	}

	free(users_sid_ptr);
	free(users_gameids_buffer);






}



void CXfireCore::Handle_ChatUserJoin(unsigned char *pBuffer ,unsigned short dwMsgSize)
{

//CApp::PutLogList("XfMobileHandle_ChatUserJoin\n");
	uint32 ptr=3;

	
    uint8 gsid[21]={0};
	ptr=read_attribute_noname(pBuffer,ptr,GROUP_SID,gsid);

    uint32 userid;

	ptr=read_attribute_noname(pBuffer,ptr,0x01,(uint8*)&userid);


	uint8 name[0x100];

	ptr=read_attribute_noname(pBuffer,ptr,0x02,(uint8*)name);

	uint8 nick[0x100];

	ptr=read_attribute_noname(pBuffer,ptr,0x0D,(uint8*)nick);

	uint32 perm = 0;

	ptr=read_attribute_noname(pBuffer,ptr,0x12,(uint8*)&perm);

	//CApp::PutLogList((char*)(name+2));



}



void CXfireCore::Handle_ChatBuddys(unsigned char *pBuffer ,unsigned short dwMsgSize)
{

	//CApp::PutLogList("Enter XfMobileHandle_ChatBuddys");

	uint32 ptr=3;

	uint8 gsid[21]={0};
	ptr=read_attribute_noname(pBuffer,ptr,GROUP_SID,gsid);


	uint8 topic[0x100]={0};
	ptr=read_attribute_noname(pBuffer,ptr,0x05,(uint8*)topic);


	uint8 motd[0x100]={0};
	ptr=read_attribute_noname(pBuffer,ptr,0x4D,(uint8*)motd);

	
	


	uint32 allowVoiceChat;
	ptr=read_attribute_noname(pBuffer,ptr,0x4E,(uint8*)&allowVoiceChat);

	uint32 defaultPerm;
	ptr=read_attribute_noname(pBuffer,ptr,0x49,(uint8*)&defaultPerm);

	uint32 timeStamp;
	ptr=read_attribute_noname(pBuffer,ptr,0x14,(uint8*)&timeStamp);

	uint32 roomType;
    ptr=read_attribute_noname(pBuffer,ptr,0x17,(uint8*)&roomType);



	uint32 users_id_buffersize=read_attribute_noname(pBuffer,ptr,0x33,NULL);



	uint32 *users_id_buffer=(uint32*)malloc(users_id_buffersize);


	ptr=read_attribute_noname(pBuffer,ptr,0x33,(uint8*)users_id_buffer);



	

	uint32 clans_usersid_count=users_id_buffersize/4;
	for (uint32 i=0; i<users_id_buffersize/4; i++)
	{



	}

	uint32 users_permissions_buffersize=read_attribute_noname(pBuffer,ptr,0x44,NULL);



	uint32 *users_permissions_buffer=(uint32*)malloc(users_permissions_buffersize);


	ptr=read_attribute_noname(pBuffer,ptr,0x44,(uint8*)users_permissions_buffer);

 
	uint32 clans_realnames_buffersize=read_attribute_noname(pBuffer,ptr,0x42,NULL);



	uint8 *clans_realnames_buffer=(uint8*)malloc(clans_realnames_buffersize);

	ptr=read_attribute_noname(pBuffer,ptr,CLAN_NICKNAME_TYPE,clans_realnames_buffer);


	uint8 *clans_realname_startbuffer=clans_realnames_buffer;
	for (uint32 i=0; i<clans_usersid_count; i++){


		uint16 clan_realnamelen;

		memcpy(&clan_realnamelen,clans_realname_startbuffer,2);
		clans_realname_startbuffer+=2;


		if (clan_realnamelen!=0){
		
			uint8 *clan_realname=(uint8*)malloc(clan_realnamelen+1);

			memset(clan_realname,0,clan_realnamelen+1);
			memcpy(clan_realname,clans_realname_startbuffer,clan_realnamelen);

		
		    free(clan_realname);
		}
		clans_realname_startbuffer+=clan_realnamelen;
	}


	uint32 clans_nicknames_buffersize=read_attribute_noname(pBuffer,ptr,0x43,NULL);

	uint8 *clans_nicknames_buffer=(uint8*)malloc(clans_nicknames_buffersize);

	ptr=read_attribute_noname(pBuffer,ptr,CLAN_NICKNAME_TYPE,clans_nicknames_buffer);

	uint8 *clans_nickname_startbuffer=clans_nicknames_buffer;
	for (uint32 i=0; i<clans_usersid_count; i++){


		uint16 clan_nicknamelen;

		memcpy(&clan_nicknamelen,clans_nickname_startbuffer,2);
		clans_nickname_startbuffer+=2;


		if (clan_nicknamelen!=0){
		
			uint8 *clan_nickname=(uint8*)malloc(clan_nicknamelen+1);

			memset(clan_nickname,0,clan_nicknamelen+1);
			memcpy(clan_nickname,clans_nickname_startbuffer,clan_nicknamelen);


		    free(clan_nickname);
		}
		clans_nickname_startbuffer+=clan_nicknamelen;
	}



	free(clans_realnames_buffer);
	free(clans_nicknames_buffer);



	free(users_permissions_buffer);

    free(users_id_buffer);

}


void CXfireCore::Handle_ChatMOTD(unsigned char *pBuffer ,unsigned short dwMsgSize)
{

//	CApp::PutLogList("Enter XfMobileHandle_ChatMOTD");


	uint32 ptr=3;

	

	uint8 gsid[21]={0};
	ptr=read_attribute_noname(pBuffer,ptr,GROUP_SID,gsid);

   	
	uint8 motd[0x100]={0};
	ptr=read_attribute_noname(pBuffer,ptr,0x2E,(uint8*)motd);

	//CApp::PutLogList((char*)(motd+2));


}

void CXfireCore::Handle_ChatUserPart(unsigned char *pBuffer ,unsigned short dwMsgSize)
{
    
	
	//CApp::PutLogList("XfMobileHandle_ChatUserPart\n");
	uint32 ptr=3;

		
    uint8 gsid[21]={0};
	ptr=read_attribute_noname(pBuffer,ptr,GROUP_SID,gsid);

    uint32 userid;

	ptr=read_attribute_noname(pBuffer,ptr,0x01,(uint8*)&userid);


}

void CXfireCore::Handle_ChatIM(unsigned char *pBuffer ,unsigned short dwMsgSize)
{
	
	
	//CApp::PutLogList("XfMobileHandle_ChatIM\n");

	uint32 ptr=3;

	
    uint8 gsid[21]={0};
	ptr=read_attribute_noname(pBuffer,ptr,GROUP_SID,gsid);
   
	
	uint32 userid;

	ptr=read_attribute_noname(pBuffer,ptr,0x01,(uint8*)&userid);


	uint8 message[0x200]={0};
	ptr=read_attribute_noname(pBuffer,ptr,0x2E,(uint8*)message);

	//CApp::PutLogList((char*)(message+2));


}
void CXfireCore::Handle_ChatSendIM(uint8 *gsid,char *message)
{
	
	
	uint32 ptr=5;

	unsigned char packet[0x400]; 
	
	guint32 climsg = 0x4CF6;

	ptr=write_attribute(packet,ptr,"climsg",INT_TYPE,(uint8*)&climsg);

	uint8 msgattrib=2;
	ptr=write_attribute(packet,ptr,"msg",0x09,(uint8*)&msgattrib);

	ptr=write_attribute_noname(packet,ptr,0x04,(uint8*)gsid);

	
	ptr=write_attribute_noname(packet,ptr,0x2E,(uint8*)message);


    add_header(packet,ptr,0x19,2);


		AsyncSendBuff((char*)packet,ptr);



}

void CXfireCore::Handle_ChatChange_motd( uint8 *gsid, char* motd)
{
	
	unsigned char packet[0x100]; 

	uint32 ptr=5;

	uint32 climsg = 0x4D0C;
	ptr=write_attribute(packet,ptr,"climsg",INT_TYPE,(uint8*)&climsg);

	uint8 msgattrib=2;
	ptr=write_attribute(packet,ptr,"msg",0x09,(uint8*)&msgattrib);

	ptr=write_attribute_noname(packet,ptr,4,(uint8*)gsid);
    
	ptr=read_attribute_noname(packet,ptr,0x2E,(uint8*)motd);

	add_header(packet,ptr,0x19,2);


	AsyncSendBuff((char*)packet,ptr);


}
void CXfireCore::Handle_SendInvite(uint8 *gsid,uint8* usersid)
{


	//CApp::PutLogList("XfMobileHandle_SendInvite\n");

	unsigned char packet[0x200]; 

	uint32 ptr=5;

	uint32 climsg =0x4CF7;

	ptr=write_attribute(packet,ptr,"climsg",INT_TYPE,(uint8*)&climsg);

	uint8 msgattrib=3;
	ptr=write_attribute(packet,ptr,"msg",0x09,(uint8*)&msgattrib);


	ptr=write_attribute_noname(packet,ptr,4,(uint8*)gsid);

	ptr=write_attribute_noname(packet,ptr,0x11,(uint8*)usersid);

	uint32 id=0;

	ptr=write_attribute_noname(packet,ptr,0x47,(uint8*)&id);

	add_header(packet,ptr,0x19,2);

	AsyncSendBuff((char*)packet,ptr);



}

void CXfireCore::Handle_CreateRoom(char *room,char *pass)
{
	
	unsigned char packet[0x400]; 

	uint32 ptr=5;

	uint32 climsg = 0x4cf4;
	ptr=write_attribute(packet,ptr,"climsg",INT_TYPE,(uint8*)&climsg);

	uint8 msgattrib=6;
	ptr=write_attribute(packet,ptr,"msg",0x09,(uint8*)&msgattrib);

	unsigned char gsid[21]={0};
	ptr=write_attribute_noname(packet,ptr,4,(uint8*)gsid);




	uint32 requestIndex = 1;

	ptr=write_attribute_noname(packet,ptr,0x0B,(uint8*)&requestIndex);


  
	uint32 chatRoomType = 1;

	ptr=write_attribute_noname(packet,ptr,0xAA,(uint8*)&chatRoomType);


	ptr=write_attribute_noname(packet,ptr,0x05,(uint8*)room);

	ptr=write_attribute_noname(packet,ptr,0x5F,(uint8*)pass);


	uint8 id=0;
	ptr=write_attribute_noname(packet,ptr,0xA7,(uint8*)&id);

	add_header(packet,ptr,0x19,2);



	//DUMP_BUFFER(packet,ptr);

	AsyncSendBuff((char*)packet,ptr);


}
void CXfireCore::Handle_JoinRoom(unsigned char *pBuffer ,unsigned short dwMsgSize)
{
	
	
	//CApp::PutLogList("XfMobileHandle_JoinRoom\n");

	uint32 ptr=3;


	//CApp::PutLogList(byteArrayToHexString(pBuffer,21));
    uint8 gsid[21]={0};
	ptr=read_attribute_noname(pBuffer,ptr,GROUP_SID,gsid);

//	CApp::PutLogList(byteArrayToHexString(gsid,21));

	memcpy(g_groupsid,gsid,21);//XXX
   
	//CApp::PutLogList(byteArrayToHexString(g_groupsid,21));

	//XfMobileHandle_SendInvite(x,0xCBFAE4);

}

void CXfireCore::Handle_TopicChanage(unsigned char *pBuffer ,unsigned short dwMsgSize)
{


	//CApp::PutLogList("Enter XfMobileHandle_TopicChanage\n");
	uint32 ptr=3;


    uint8 gsid[21]={0};
	ptr=read_attribute_noname(pBuffer,ptr,GROUP_SID,gsid);


//	CApp::PutLogList(byteArrayToHexString(&pBuffer[ptr],10));
	uint8 topic[0x100]={0};
	ptr=read_attribute_noname(pBuffer,ptr,0x05,(uint8*)topic);

  //   CApp::PutLogList("Leave XfMobileHandle_TopicChanage\n");
	

}



void CXfireCore::Handle_ChatLeave(uint8 *gsid)
{
	
	uint32 ptr=5;

	unsigned char packet[0x400]; 
	
	guint32 climsg = 0x4CF5;

	ptr=write_attribute(packet,ptr,"climsg",INT_TYPE,(uint8*)&climsg);

	uint8 msgattrib=1;
	ptr=write_attribute(packet,ptr,"msg",0x09,(uint8*)&msgattrib);

	ptr=write_attribute_noname(packet,ptr,0x04,(uint8*)gsid);

    add_header(packet,ptr,0x19,2);


	
	AsyncSendBuff((char*)packet,ptr);




}

void CXfireCore::Handle_BuddyInvitation(unsigned char *pBuffer ,unsigned short dwMsgSize)
{
	
	

	uint32 ptr=3;

   uint32 friends_usernames_buffersize=read_attribute(pBuffer,ptr,"name",ARRAY_TYPE,0);

   if (friends_usernames_buffersize==-1){
	
	
	    return;
   }

   	uint8   *friends_usernames_ptr=(uint8*)malloc(friends_usernames_buffersize);


	ptr=read_attribute(pBuffer,ptr,"name",ARRAY_TYPE,(uint8*)friends_usernames_ptr);

	

	
	uint32  username_count=0;

	uint8  *friends_username_ptr_start=friends_usernames_ptr;

	 while(friends_username_ptr_start!=(friends_usernames_ptr+friends_usernames_buffersize)){


		uint16 username_len=0;
		memcpy(&username_len,friends_username_ptr_start,2);

	    friends_username_ptr_start+=2;
		uint8 *username=(uint8*)malloc(username_len+1);
		memset(username,0,username_len+1);
		
		memcpy(username,friends_username_ptr_start,username_len);
		
	//	XfMobileHandle_Invitation_Accept((char*)username);
		free(username);

		friends_username_ptr_start+=username_len;

		


	}



	 uint32 friends_nicknames_buffersize=read_attribute(pBuffer,ptr,"nick",ARRAY_TYPE,0);

	 if (friends_nicknames_buffersize==-1){

		 return;
	 }
	 uint8   *friends_nicknames_ptr=(uint8*)malloc(friends_nicknames_buffersize);


	ptr=read_attribute(pBuffer,ptr,"nick",ARRAY_TYPE,(uint8*)friends_nicknames_ptr);

	uint32  nickname_count=0;

	uint8  *friends_nickname_ptr_start=friends_nicknames_ptr;

	 while(friends_nickname_ptr_start!=(friends_nicknames_ptr+friends_nicknames_buffersize)){


		uint16 nickname_len=0;
		memcpy(&nickname_len,friends_nickname_ptr_start,2);

	    friends_nickname_ptr_start+=2;
		if (nickname_len){

			uint8 *nickname=(uint8*)malloc(nickname_len+1);
			memset(nickname,0,nickname_len+1);

			memcpy(nickname,friends_nickname_ptr_start,nickname_len);

			
			free(nickname);
		}else{

			//CApp::PutLogList((char*)"no nickname");

		}

		friends_nickname_ptr_start+=nickname_len;

		


	}



	 uint32 msg_buffersize=read_attribute(pBuffer,ptr,"msg",ARRAY_TYPE,0);

	 if (msg_buffersize==-1){

		 return;
	 }
	 uint8   *msg_ptr=(uint8*)malloc(msg_buffersize);


	ptr=read_attribute(pBuffer,ptr,"msg",ARRAY_TYPE,(uint8*)msg_ptr);



	uint8  *msg_ptr_start=msg_ptr;

	 while(msg_ptr_start!=(msg_ptr+msg_buffersize)){


		uint16 msg_len=0;
		memcpy(&msg_len,msg_ptr_start,2);

	    msg_ptr_start+=2;
		if (msg_len){

			uint8 *msg=(uint8*)malloc(msg_len+1);
			memset(msg,0,msg_len+1);

			memcpy(msg,msg_ptr_start,msg_len);

			
			free(msg);
		}else{

			//CApp::PutLogList((char*)"no nickname");

		}

		msg_ptr_start+=msg_len;

		


	}


    free(msg_ptr_start);
	free(friends_usernames_ptr);

	

}


void CXfireCore::Handle_Invitation_Accept(char *p_name)
{
    

	uint8 packet[0x400];

	uint32 ptr=5;
	

	ptr=write_attribute(packet,ptr,"name",STRING_TYPE,(uint8*)p_name);
	

	add_header(packet,ptr,0x07,1);


	AsyncSendBuff((char*)packet,ptr);

	return ;
}
void CXfireCore::Handle_Invitation_Reject(char *p_name)
{
    
	
	uint8 packet[0x400];

	uint32 ptr=5;
	

	ptr=write_attribute(packet,ptr,"name",STRING_TYPE,(uint8*)p_name);
	

	add_header(packet,ptr,0x08,1);

    AsyncSendBuff((char*)packet,ptr);
	
	return ;
}



void CXfireCore::HandleSuccessLogin(unsigned char *pBuffer ,unsigned short dwMsgSize)
{

	uint32 ptr=3;

	uint32 my_userid;
	ptr=read_attribute(pBuffer,ptr,"userid",INT_TYPE,(uint8*)&my_userid);

	uint8 my_sid[16];

	ptr=read_attribute(pBuffer,ptr,"sid",SID_TYPE,(uint8*)&my_sid);


	uint32 nickname_length=read_attribute(pBuffer,ptr,"nick",STRING_TYPE,0);



	char *nickname=(char*)malloc(nickname_length);

	ptr=read_attribute(pBuffer,ptr,"nick",STRING_TYPE,(uint8*)nickname);

//[length]nickname

	free(nickname);


	//CApp::PutLogList(byteArrayToHexString(my_sid,16));

	

	

}


void CXfireCore::HandleContacts(unsigned char *pBuffer ,unsigned short dwMsgSize)
{

   uint32 ptr=3;

   uint32 friends_usernames_buffersize=read_attribute(pBuffer,ptr,"friends",ARRAY_TYPE,0);

   if (friends_usernames_buffersize==-1){
	
		//CApp::PutLogList("XfMobile_HandleContacts attribute friends not found");
		return;
   }

   	uint8   *friends_usernames_ptr=(uint8*)malloc(friends_usernames_buffersize);


	ptr=read_attribute(pBuffer,ptr,"friends",ARRAY_TYPE,(uint8*)friends_usernames_ptr);


	for (unsigned int j=0; j<CXfireCore::_listContacts.size(); j++){

		XfireContact *pContact=CXfireCore::_listContacts.at(j);

		if (pContact) {

			delete pContact;


		}
	}

	uint32  username_count=0;

	uint8  *friends_username_ptr_start=friends_usernames_ptr;

	 while(friends_username_ptr_start!=(friends_usernames_ptr+friends_usernames_buffersize)){


		uint16 username_len=0;
		memcpy(&username_len,friends_username_ptr_start,2);

	    friends_username_ptr_start+=2;
		uint8 *username=(uint8*)malloc(username_len+1);
		memset(username,0,username_len+1);
		
		memcpy(username,friends_username_ptr_start,username_len);
		//CApp::PutLogList((char*)username);

		CXfireCore::_listContacts.push_back(new XfireContact());

		XfireContact *pContact=CXfireCore::_listContacts.at(username_count);
		memcpy(pContact->cUsername,friends_username_ptr_start,username_len+1);


		free(username);

		friends_username_ptr_start+=username_len;

		username_count++;

		


	}


	 CXfireCore::s_nNumOfContacts=username_count;

	 uint32 friends_nicknames_buffersize=read_attribute(pBuffer,ptr,"nick",ARRAY_TYPE,0);

	 if (friends_nicknames_buffersize==-1){

		 //CApp::PutLogList("XfMobile_HandleContacts attribute nick not found");
		 return;
	 }
	 uint8   *friends_nicknames_ptr=(uint8*)malloc(friends_nicknames_buffersize);


	 ptr=read_attribute(pBuffer,ptr,"nick",ARRAY_TYPE,(uint8*)friends_nicknames_ptr);

	 uint32  nickname_count=0;

	uint8  *friends_nickname_ptr_start=friends_nicknames_ptr;

	 while(friends_nickname_ptr_start!=(friends_nicknames_ptr+friends_nicknames_buffersize)){


		uint16 nickname_len=0;
		memcpy(&nickname_len,friends_nickname_ptr_start,2);

	    friends_nickname_ptr_start+=2;
		if (nickname_len){
			uint8 *nickname=(uint8*)malloc(nickname_len+1);
			memset(nickname,0,nickname_len+1);

			memcpy(nickname,friends_nickname_ptr_start,nickname_len);

			if (nickname[0]){

				XfireContact *pContact=CXfireCore::_listContacts.at(nickname_count);

				memcpy(pContact->cNickname,nickname,nickname_len+1);

			}

			free(nickname);
		}else{

			//CApp::PutLogList((char*)"no nickname");

		}

		friends_nickname_ptr_start+=nickname_len;

		nickname_count++;

		


	}



    uint32 friends_usersid_buffersize=read_attribute(pBuffer,ptr,"userid",ARRAY_TYPE,0);

	if (friends_usersid_buffersize!=-1) {

		uint32   *friends_users_id_ptr=(uint32*)malloc(friends_usersid_buffersize);

		ptr=read_attribute(pBuffer,ptr,"userid",ARRAY_TYPE,(uint8*)friends_users_id_ptr);


		for (unsigned int i=0; i<friends_usersid_buffersize/4; i++)
		{


			uint32 userid;

			memcpy(&userid,friends_users_id_ptr+i,4);


			XfireContact *pContact=CXfireCore::_listContacts.at(i);

			pContact->userid=userid;
			pContact->uStatus=0;


		
		
		

		}
		free(friends_users_id_ptr);

	}


	


	free(friends_nicknames_ptr);
	free(friends_usernames_ptr);
	
	

}
void CXfireCore::HandleMismatchVersion(unsigned char *pBuffer ,unsigned short dwMsgSize)
{



	unsigned	char version[] = {
		0x12, 0x00, 0x03, 0x00, 0x01,
		0x07, 0x76, 0x65, 0x72, 0x73, 0x69, 0x6f,0x6e,  //version
		0x02, 0xCC, 0xCC,   //1.87
		0xCC, 0xCC };

		
	uint32 ptr=3;

	uint32 version_buffersize=read_attribute(pBuffer,ptr,"version",ARRAY_TYPE,0);
	
	uint8   *version_ptr=(uint8*)malloc(version_buffersize);

	ptr=read_attribute(pBuffer,ptr,"version",ARRAY_TYPE,(uint8*)version_ptr);


	for (uint32 i=0; i<version_buffersize/4; i++){

		int xfire_version;
		memcpy(&xfire_version,version_ptr+i*4,4);

		
		
	}

	free(version_ptr);

	AsyncSendBuff((char*)version,sizeof(version));


}

void CXfireCore::HandleAuth(unsigned char *pBuffer ,DWORD MsgSize)
{


	unsigned char *cp=pBuffer;

	cp+=2;

	unsigned char cPacket[0x100];

	if (memcmp(cp+1,"salt",*cp)==0){

		OutputDebugString(L"CXfireCore::HandleAuth:salt found\n");
		cp=cp+*cp+1+3;
		unsigned char salt[40];
		memcpy(salt,cp,40);
		cp=cPacket;
		*cp++=0x61+strlen(s_cUserName);
		*cp++=0;
		*cp++=1;
		*cp++=0;
		*cp++=3;
		*cp++=4;
		memcpy(cp,"name",4);
		cp+=4;
		*cp++=1;
		*cp++=strlen(s_cUserName);
		*cp++=0;
		memcpy(cp,s_cUserName,strlen(s_cUserName));
		cp+=strlen(s_cUserName);

		*cp++=0x08;
		memcpy(cp,"password",8);
		cp+=8;
		*cp++=1;
		*cp++=0x28;
		*cp++=0;

		memcpy(cp,cryptPassword(s_cUserName,s_cPassword,salt),40);

		AsyncSendBuff(cPacket,*(unsigned short*)cPacket);


	}

}
void CXfireCore::Login()
{


OutputDebugString(L"CXfireCore::Login\n");
	    char uat[] = {
		0x55, 0x41, 0x30, 0x31 };

		unsigned char version[] = {
			0x12, 0x00, 0x03, 0x00, 0x01,
			0x07, 0x76, 0x65, 0x72, 0x73, 0x69, 0x6f,0x6e,  //version
			0x02, 0xCC, 0xCC,   //1.87
			0xCC, 0xCC };


		
			AsyncSendBuff(uat,sizeof(uat));


			AsyncSendBuff(version ,sizeof(version));	



}


void CXfireCore::ParseMessage(unsigned char *pBuffer  ,USHORT dwMsgSize)
{


	unsigned short  cPacketID;
	cPacketID=*(pBuffer+0);

	WCHAR buf[222];
	wsprintfW(buf,L"pktid=%d",cPacketID);

	DbgMsg(buf);

	switch(cPacketID){


		case 138:
			//CApp::PutLogList("got buddy invitation\n");
			//XfMobileHandle_BuddyInitation((unsigned char*)pBuffer,dwMsgSize);

			
			break;
		case 350:
			//CApp::PutLogList("received chat room topic change\n");
		
			//XfMobileHandle_TopicChanage((unsigned char*)pBuffer,dwMsgSize);
		break;

		case 351:
			//CApp::PutLogList( "received chat room join info\n");

			//XfMobileHandle_JoinRoom((unsigned char*)pBuffer,dwMsgSize);
		
		break;

		case 353:
			//CApp::PutLogList(  "received chat room, user join message\n");

			//XfMobileHandle_ChatUserJoin((unsigned char*)pBuffer,dwMsgSize);
		
		break;

		case 354:
			//CApp::PutLogList(  "received chat room, user leave message\n");
	    	//XfMobileHandle_ChatUserPart((unsigned char*)pBuffer,dwMsgSize);
		break;

		case 355:
			//CApp::PutLogList(  "got chat room message\n");

			//XfMobileHandle_ChatIM((unsigned char*)pBuffer,dwMsgSize);

		
		
		break;

		case 356:
			//CApp::PutLogList(  "received chat room invite\n");
			//	XfMobileHandle_ChatInvite((unsigned char*)pBuffer,dwMsgSize);
		
		
			
		
		break;

		case 357:
			//CApp::PutLogList(  "chat room buddy permission changed\n");
	
		break;

		case 358:
			//CApp::PutLogList(  "persistent chat room infos received\n");
		
		break;

		case 359:
			//CApp::PutLogList(  "chat room buddy kicked notification received\n");
				break;

		case 368:
		//	CApp::PutLogList(  "received chat room info (buddy list)\n");
			
		//	XfMobileHandle_ChatBuddys((unsigned char*)pBuffer,dwMsgSize);
		
			
		break;

		case 370:
			//CApp::PutLogList( "chat room default permission change received\n");
			
		break;

		case 374:
			//CApp::PutLogList(  "chat room motd changed\n");

		//	XfMobileHandle_ChatMOTD((unsigned char*)pBuffer,dwMsgSize);
		
		break;

		case 385:
			//CApp::PutLogList(  "chat room password change received\n");
			
		break;

		case 386:
	//	CApp::PutLogList( "chat room accessibility change received\n");
			
		break;

		case 387:
		//	CApp::PutLogList(  "received chat room reject confirmation\n");
		break;

		case 388:
		//	CApp::PutLogList(  "chat room silenced change received\n");
			
		break;


		case XFIRE_PACKET_CONTACTS:

OutputDebugString(L"CXfireCore::XFIRE_PACKET_CONTACTS\n");
			HandleContacts((unsigned char*)pBuffer,dwMsgSize);
			break;


		case XFIRE_PACKET_AUTH_ID:
			OutputDebugString(L"CXfireCore::XFIRE_PACKET_AUTH_ID\n");

			HandleAuth(pBuffer+1,dwMsgSize);

			break;
		case XFIRE_LOGIN_FAILED_ID:


			OutputDebugString(L"CXfireCore::XFIRE_LOGIN_FAILED_ID\n");

			m_fConnected = FALSE;

			::SendMessage(g_hLoginWnd,WM_CONNECTION_STATUS,(LPARAM)XFIRE_LOGIN_FAILED_ID,0);
			::SendMessage(g_hContactsWnd,WM_CONNECTION_STATUS,(LPARAM)XFIRE_LOGIN_FAILED_ID,0);


			AfxMessageBox(L"Your Xfire Name and password were not recongnised.\nPlease try again.");


		


			break;
		case XFIRE_LOGIN_SUCCESS_ID:
			m_fConnected=TRUE;
			OutputDebugString(L"CXfireCore::XFIRE_LOGIN_SUCCESS_ID\n");
			//m_bIsConnected=TRUE;
			// [m_pLoginController SwitchToContactsView];
			handleLoginSuccessPacket((unsigned char*)(pBuffer),dwMsgSize);
			::SendMessage(g_hLoginWnd,WM_CONNECTION_STATUS,(LPARAM)XFIRE_LOGIN_SUCCESS_ID,0);
			::SendMessage(g_hMainDlg,WM_CONNECTION_STATUS,(LPARAM)XFIRE_LOGIN_SUCCESS_ID,0);
			MessageOfTheDay ("Xfire on windows mobile");
			break;
		case XFIRE_BUDDY_STATUS_ID:
			OutputDebugString(L"CXfireCore::XFIRE_BUDDY_STATUS_ID\n");

			HandleStatus((unsigned char*)(pBuffer),dwMsgSize);
			break;

		case XFIRE_RECV_IM_ID:
			//NSLog(@"XFIRE_RECV_IM_ID");

			HandleIM((unsigned char*)(pBuffer),dwMsgSize);

			break;
		case XFIRE_RECV_NICKNAMECHANGE_ID:

			break;

		case XFIRE_VERSION_MISMATCH_ID:

			OutputDebugString(L"CXfireCore::XFIRE_VERSION_MISMATCH_ID\n");

			HandleMismatchVersion((unsigned char*)pBuffer,dwMsgSize);

			break;



		case 135:
            
			HandlePlayingGame((unsigned char*)(pBuffer),dwMsgSize);
			
			break;
		case 136:
			
			break;
		case 144:
			
		
			break;
		case 145:	

			::SendMessage(g_hLoginWnd,WM_CONNECTION_STATUS,(LPARAM)XFIRE_LOGIN_FAILED_ID,0);
			::SendMessage(g_hContactsWnd,WM_CONNECTION_STATUS,(LPARAM)XFIRE_LOGIN_FAILED_ID,0);
            ::SendMessage(g_hMainDlg,WM_CONNECTION_STATUS,(LPARAM)XFIRE_LOGIN_FAILED_ID,0);


			AfxMessageBox(L"Someone is online with your account.!");	


			break;

		case XFIRE_CLAN_PACKET:

			
			Handle_Clans((unsigned char*)(pBuffer),dwMsgSize);


			break;
		case XFIRE_CLAN_BUDDYS_NAMES_ID:
			
			
			Handle_ClansNames((unsigned char*)(pBuffer),dwMsgSize);

			break;




		case 154:
			HandleStatusMessage((unsigned char*)(pBuffer),dwMsgSize);
			break;



		default:


			break;

	}



}


void CXfireCore::MsgProcess()
{
	unsigned char * pData;
	DWORD  dwMsgSize;

	//int    iClientH;

	ZeroMemory(m_pMsgBuffer, DEF_MSGBUFFERSIZE);

	pData = (unsigned char *)m_pMsgBuffer;

	while (bGetMsgQuene( pData, &dwMsgSize) == TRUE) {



		ParseMessage(pData,dwMsgSize);



		ZeroMemory(m_pMsgBuffer, DEF_MSGBUFFERSIZE);
	}


}


BOOL CXfireCore::ShutDown(
						  int nHow  
						  )
{


	
	return TRUE;

}

void CXfireCore::OnClose(
						 int nErrorCode 
						 )
{

	if (m_fConnected) {
	
		m_fConnected = FALSE;
	    ShutDown();
     	Close();

	}



}




void CXfireCore::OnConnect(
						   int nErrorCode 
						   ) 
{


	OutputDebugString(L"CXfireCore::OnConnect\n");
	if (0 != nErrorCode)
	{
		m_fConnected = FALSE;
		switch( nErrorCode )
		{
		case WSAEADDRINUSE: 
			AfxMessageBox(L"The specified address is already in use.\n");
			break;
		case WSAEADDRNOTAVAIL: 
			AfxMessageBox(L"The specified address is not available from the local machine.\n");
			break;
		case WSAEAFNOSUPPORT: 
			AfxMessageBox(L"Addresses in the specified family cannot be  used with this socket.\n");
			break;
		case WSAECONNREFUSED: 
			AfxMessageBox(L"The attempt to connect was forcefully rejected.\n");
			break;
		case WSAEDESTADDRREQ: 
			AfxMessageBox(L"A destination address is required.\n");
			break;
		case WSAEFAULT: 
			AfxMessageBox(L"The lpSockAddrLen argument is incorrect.\n");
			break;
		case WSAEINVAL: 
			AfxMessageBox(L"The socket is already bound to an  address.\n");
			break;
		case WSAEISCONN: 
			AfxMessageBox(L"The socket is already connected.\n");
			break;
		case WSAEMFILE: 
			AfxMessageBox(L"No more file descriptors are available.\n");
			break;
		case WSAENETUNREACH: 
			AfxMessageBox(L"The network cannot be reached from this host   at this time.\n");
			break;
		case WSAENOBUFS: 
			AfxMessageBox(L"No buffer space is available. The socket cannot be connected.\n");
			break;
		case WSAENOTCONN: 
			AfxMessageBox(L"The socket is not connected.\n");
			break;
		case WSAENOTSOCK: 
			AfxMessageBox(L"The descriptor is a file, not a socket.\n");
			break;
		case WSAETIMEDOUT: 
			AfxMessageBox(L"The attempt to connect timed out without establishing a connection. \n");
			break;
		default:
			TCHAR szError[256];
			wsprintf(szError,L"OnConnect error: %d", nErrorCode);
			AfxMessageBox(szError);
			break;

			return;
		}

	}else{


		m_fConnected = TRUE;
		OutputDebugString(L"CXfireCore::OnConnected\n");

	}
	CAsyncSocket::OnConnect(nErrorCode);

	this->Login();

}







void CXfireCore::OnReceive(
						   int nErrorCode 
						   )
{


	
	int nRead = 0;

	// data needs to be read (which should be all the time when this is called)
	if (m_nBytesRecv < m_nRecvDataLen) 
	{

		// make sure we're reading 2 bytes for data length
		if (m_bReadDataLength) {
			ASSERT(m_nRecvDataLen == 2);
		}

		// receive buffer max size is MAX_BUFF
		// We must have enough room available in buffer AND
		// the expected packet size must be less or equal to MAX_BUFF
		ASSERT(m_nBytesRecv < MAX_BUFF && m_nRecvDataLen <= MAX_BUFF);

		// read all the data
		nRead = Receive(
			m_recvBuff + m_nBytesRecv,
			m_nRecvDataLen-m_nBytesRecv);

		// if something was read
		if (nRead > 0) 
		{
			m_nBytesRecv += nRead;

			// if all the data was read

			if (m_nBytesRecv == m_nRecvDataLen) 
			{


				// extract data length from packet
				if (m_bReadDataLength) 
				{
					m_nRecvDataLen = (short) ( (*((short*)m_recvBuff)) )-2;




					m_nBytesRecv = 0;
				} 
				else 
				{
					// extract data from buffer and pass data to the upper layer.
					// We append the body of the packet with a string terminator.

					
					bPutMsgQuene(m_recvBuff,m_nRecvDataLen); 
					//ParseMessage(m_recvBuff,m_nRecvDataLen);  //PURE DATA without 2 bytes size header

					// re-initializaton
					m_nRecvDataLen = 2;
					m_nBytesRecv = 0;

					//AfxGetMainWnd()->SendMessage(WM_NEWMESSAGE, (WPARAM)m_recvBuff);
				}
				// alternate between reading 2 byte data length and the data itself
				m_bReadDataLength = m_bReadDataLength ? FALSE : TRUE;
			}
		} 
		else 
		{
			// else error occurred
			if (GetLastError() != WSAEWOULDBLOCK) 
			{
				m_nBytesRecv = m_nRecvDataLen;
				AfxMessageBox(L"Socket Error. Unable to read data.");
			} 
			else
				OutputDebugString(L"CConnectSoc: WARNING: WSAEWOULDBLOCK on a Receive in OnReceive\n");
		}
	}



}

void CXfireCore::OnSend(
						int nErrorCode 
						)
{



	if (m_fConnected) {
		DoAsyncSendBuff();

	}

	CAsyncSocket::OnSend(nErrorCode);

}



int CXfireCore::Receive(void* lpBuf, int nBufLen, int nFlags) 
{
	//OutputDebugString(L"CConnectSoc::Receive\n");	
	return CAsyncSocket::Receive(lpBuf, nBufLen, nFlags);
}



int CXfireCore::Send(const void* lpBuf, int nBufLen, int nFlags) 
{
	//OutputDebugString(L"CConnectSoc::Send\n");
	return CAsyncSocket::Send(lpBuf, nBufLen, nFlags);
}



void CXfireCore::AsyncSendBuff(void* lpBuf, int nBufLen)
{


	// We don't queue up data here.
	// If you are going to queue up data packet, it would be better to limit the size
	// of the queue and remember to clear up the queue whenever the current packet has been sent.
	if (m_nSendDataLen != 0 || nBufLen > MAX_BUFF)
	{
		TCHAR szError[256];
		wsprintf(szError, L"CConnectSoc::AsyncSendBuff() can't accept more data\n");
		AfxMessageBox (szError);
		return;
	}
	else
	{
		if (nBufLen > MAX_BUFF)
		{
			TCHAR szError[256];
			wsprintf(szError, L"CConnectSoc::AsyncSendBuff() oversize buffer.\n");
			AfxMessageBox (szError);
			return;
		}
		// body
		memcpy(m_sendBuff, lpBuf, nBufLen);
		m_nSendDataLen = nBufLen ;
		m_nBytesSent = 0;
		DoAsyncSendBuff();
	}
}

// Send the data left in the buffer.
// If TCP stack can not accept more data and gives error of WSAEWOULDBLOCK,
// we breaks out of the while loop. Whenever TCP stack can accept more data,
// our CConnectSoc::OnSend() will be called.
void CXfireCore::DoAsyncSendBuff()
{

	while (m_nBytesSent < m_nSendDataLen)  
	{
		int nBytes;

		if ((nBytes = Send((LPCTSTR)m_sendBuff + m_nBytesSent, m_nSendDataLen - m_nBytesSent))
			== SOCKET_ERROR)
		{
			if (GetLastError() == WSAEWOULDBLOCK) 
				break;
			else
			{
				TCHAR szError[256];
				wsprintf(szError, L"Server Socket failed to send: %d", GetLastError());
				Close();	
				AfxMessageBox (szError);
				//m_pThread->PostThreadMessage(WM_QUIT,0,0);
				m_nBytesSent = 0;

				return;
			}
		}
		else
		{
			m_nBytesSent += nBytes;
		}
	}

	if (m_nBytesSent == m_nSendDataLen)
	{
		m_nBytesSent = m_nSendDataLen = 0;
	}
}



