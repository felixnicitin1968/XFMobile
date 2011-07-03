//
//  XfireCore.m
//  iXfire
//
//  Created by Moti Joseph on 4/1/09.
//  Copyright 2009 Gamepe. All rights reserved.
//
#import "AsyncSocket.h"
#import "iXfireAppDelegate.h"
#import "LoginViewControlller.h"
#import "ContactsViewController.h"
#import "XfireCore.h"
#import "MsgQue.h"
#import "sha1.h"
#import "global.h"
#import    "UIImage+Resize.h"

#import "ScreenshotsCategoryController.h"
#import "XGroupChannel.h"

#import "MockPhotoSource.h"

#define FORMAT(format, args...) [NSString stringWithFormat:format, args]





@implementation NUSERID

@synthesize     m_userid;


-(int)             getUserid
{
	
	return m_userid;
}


-(void)             setUserid:(int) userid
{

	m_userid=userid;
	
}


@end
@implementation XfireCore



@synthesize     m_pSearchedFriendVC;
@synthesize     m_pLoginController;
@synthesize     m_bIsConnected;
@synthesize     m_pContacts;
@synthesize     m_pClans;


-(BOOL)           IsConnecetd

{
	
	return m_bIsConnected;

}


-(void) XfMobile_KeepAlive
{
	
	

	
	uint8 packet[0x400];
	uint32 ptr=5;
	
	uint32 value=0;
	ptr=write_attribute(packet,ptr,"value",INT_TYPE,(uint8*)&value);
	
	ptr=write_array_attribute(packet,ptr,"stats",INT_TYPE,0,0);
	
	add_header(packet,ptr,13,2);
	
	
	[self sendPacketMsg:packet length:ptr];
	
}


-(void) XfMobile_Typing:(uint8 *)sid  Imindex:(uint32) imindex  Typing:(uint32) typing
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
	
	[self sendPacketMsg:packet length:ptr];
	
	
}

-(void) XfMobile_SendIM:(uint8 *)sid  Imindex:(uint32) imindex msg:(char *)Message
{
	
	
	uint8 packet[0x400];
	uint32 ptr=5;
	
	ptr=write_attribute(packet,ptr,"sid",SID_TYPE,(uint8*)sid);
	
	
	uint8 peermsg=3; //number of child attribute
	ptr=write_attribute(packet,ptr,"peermsg",CHILDS_TYPE,&peermsg);
	
	
	uint32 msgtype=0;
	ptr=write_attribute(packet,ptr,"msgtype",INT_TYPE,(uint8*)&msgtype);
	
	int index=0 ;
	
	XFireContact *pContact=[self getContactBySid:sid];
	
	if (pContact) {
		
		index=pContact->imIndex;
		
		pContact->imIndex++;
		
	}
	
	else{
		
		pContact=[self getClanContactBySid:sid];
		
		if (pContact) {
			index=pContact->imIndex;
			
			pContact->imIndex++;
			
		}
		
	}
	
	

	
	ptr=write_attribute(packet,ptr,"imindex",INT_TYPE,(uint8*)&index);
	
	ptr=write_attribute(packet,ptr,"im",STRING_TYPE,(uint8*)Message);
	
	add_header(packet,ptr,0x0002,2);
	
	
	char cXfireMobile[0x100];
	
	strcpy(cXfireMobile,_myNickname);
	strcat(cXfireMobile,"[XFMobile]");
	
	/*if (g_bIsDisableSignature==FALSE){
		
		[self XfMobile_NewNickname:cXfireMobile];
	}*/
	
	[self sendPacketMsg:packet length:ptr];		
	
	/*if (g_bIsDisableSignature==FALSE){
		
		
		[self XfMobile_NewNickname:_myNickname];
		
	}*/
	

	
	
}



-(void) XfMobile_SearchFreinds:(char *)friend   view:(SearchViewController*)vc

{
	
	m_pSearchedFriendVC=vc;
	uint8 packet[0x100];
	
	uint32 ptr=5;
	
	ptr=write_attribute(packet,ptr,"name",STRING_TYPE,(uint8*)friend);
	
	ptr=write_attribute(packet,ptr,"fname",STRING_TYPE,(uint8*)"");
	ptr=write_attribute(packet,ptr,"lname",STRING_TYPE,(uint8*)"");
	ptr=write_attribute(packet,ptr,"email",STRING_TYPE,(uint8*)"");
	add_header(packet,ptr,0x000C,4);
	
	
	[self sendPacketMsg:packet length:ptr];	
	
	
}



-(void) XfMobile_GetData:(int)userid

{
	
	
	uint8 packet[0x100];
	
	uint32 ptr=5;
	
	ptr=write_attribute_noname(packet,ptr,1,(uint8*)&userid);
	
	add_header(packet,ptr,0x0025,1);
	
	
	[self sendPacketMsg:packet length:ptr];	
	
	
}


-(void) XfMobile_NewNickname:(char *)nickname
{
	
	
	uint8 packet[0x100];

	uint32 ptr=5;
	
	
	ptr=write_attribute(packet,ptr,"nick",STRING_TYPE,(uint8*)nickname);
	
	add_header(packet,ptr,0x000E,1);
	
	
	[self sendPacketMsg:packet length:ptr];	
	
	
	
}





-(void) XfMobile_AddFriend:(char *)Friend msg:(char *)Message
{
	
	uint8 packet[0x100];
	uint32 ptr=5;
	
	
	ptr=write_attribute(packet,ptr,"name",STRING_TYPE,(uint8*)Friend);
	
	
	ptr=write_attribute(packet,ptr,"msg",STRING_TYPE,(uint8*)Message);
	
	add_header(packet,ptr,0x0006,2);
	
	
	[self sendPacketMsg:packet length:ptr];	
	
	
	
	
	
}

-(void) XfMobile_MessageOfTheDay:(char *)Message
{
	
	
	uint8 packet[0x100];
	uint32 ptr=5;
	ptr=write_attribute_noname(packet,ptr,MSG_OF_THEDAY,(uint8*)Message);
	
	add_header(packet,ptr,0x0020,1);
	
	
	[self sendPacketMsg:packet length:ptr];	
	
	
	
	
	
	
}



-(void) XfMobileHandle_Clans:(unsigned char *)pBuffer MsgSize:(unsigned short) dwMsgSize
{
	
		
	uint32 ptr=3;
	
	
	uint32 clans_id_buffersize=read_attribute_noname(pBuffer,ptr,CLANID_TYPE,NULL);
	
	uint32 clans_count=clans_id_buffersize/4;
	
	
	if (clans_count==0)  {
		
		
		
		return;
	}
	
	if (m_pClans!=NULL){
	
		free(m_pClans);
		m_pClans=NULL;
	}
	
	m_pClans=malloc(sizeof(XfireClan)*clans_count);
	
	if (m_pClans==NULL) return;
	
	memset(m_pClans,0,sizeof(XfireClan)*clans_count);
	
	
	m_nTotalClans=clans_count;
	


	uint32 *clans_id_buffer=(uint32*)malloc(clans_id_buffersize);
	
	ptr=read_attribute_noname(pBuffer,ptr,CLANID_TYPE,(uint8*)clans_id_buffer);
	
	
	for (uint32 i=0; i<clans_count; i++){
	
		uint32 clanid;
		
		memcpy(&clanid,clans_id_buffer+i,4);
	    m_pClans[i].id=clanid;
	
		
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
			
			//CApp::PutLogList((char*)clan_nickname);
			
			memcpy(m_pClans[i].name,clan_nickname,clan_nicknamelen+1);
			
			
			
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
	
}





-(void) XfMobileHandle_ClansNames:(unsigned char *)pBuffer  MsgSize:(unsigned short) dwMsgSize
{
	
	uint32 ptr=3;

	
	uint32 clanid;
	ptr=read_attribute_noname(pBuffer,ptr,CLANID_TYPE,(uint8*)&clanid);
	
	
	XfireClan *pXfireClans=[self getClanById:clanid];
	
	if (pXfireClans==nil){
		
		
		NSLog(@"critical error handleClanBuddyNamesPacket getClanById=nil");
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
	
	
	pXfireClans->userscount=clans_usersid_count;
	NSLog(@"clan members count =%d %s",clans_usersid_count,pXfireClans->name);
	
	if (pXfireClans->users!=NULL){
	
		free(pXfireClans->users);
		pXfireClans->users=NULL;
	}
	pXfireClans->users=malloc(sizeof(XFireContact)*clans_usersid_count);
	

	
	
	for (uint32 i=0; i<clans_usersid_count; i++)
	{
		
	
		uint32 userid;
		memcpy(&userid,clans_usersid_buffer+i,4);
		
		
		pXfireClans->users[i].userid=userid;
		pXfireClans->users[i].uStatus=MISTATUS_OFFLINE;
		pXfireClans->users[i].Messageslist=nil;
		
		
		
		pXfireClans->users[i]. image=[self newImageFromResource:@"offline.png"];
		
		

		
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
			
			
			memcpy(pXfireClans->users[i].cUsername,clan_realname,clan_realnamelen+1);
			
			
			
			
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
			memcpy(pXfireClans->users[i].cNickname,clan_nickname,clan_nicknamelen+1);
			
		    free(clan_nickname);
		}
		clans_nickname_startbuffer+=clan_nicknamelen;
	}
	
	
	
	free(clans_realnames_buffer);
	free(clans_nicknames_buffer);
	free(clans_usersid_buffer);
	
	
	
	
}

-(XfireClan*)                  getClanById:(unsigned int)clanid
{
	
	for (int i=0; i<m_nTotalClans; i++) {
		
		if (m_pClans[i].id==clanid) return &m_pClans[i];
		
		
	}
	
	return nil;
	
}


-(void) sortClanContacts
{
	

	

	int nTotalOffline=0;
	for (int i=0; i<m_nTotalClans; i++){
		
		
		nTotalOffline=0;
		for (int j=0; j<m_pClans[i].userscount; j++) {
		
			//if (m_pClans[i].userscount>CLAN_MAX_MEMBERS) continue;
			
			
			
			if (m_pClans[i].users[j].uStatus==MISTATUS_OFFLINE){
				
				nTotalOffline++;
				XFireContact tmpContact;
				
				if (m_pClans[i].userscount<=(j+1)) {
					
	
					break; 
				}
				
				
				for (int n=(j+1); n<m_pClans[i].userscount; n++){
					
					if (m_pClans[i].users[n].uStatus==MISTATUS_ONLINE){
						
						
						
						memcpy(&tmpContact,&m_pClans[i].users[n],sizeof(XFireContact)); //online guy
						
						memcpy(&m_pClans[i].users[n],&m_pClans[i].users[j],sizeof(XFireContact));  //offline guy
						
						
						memcpy(&m_pClans[i].users[j],&tmpContact,sizeof(XFireContact));
						
						break;
						
						
					}
					
				}
				
				
			}
		}
		
		m_pClans[i].online_userscount= m_pClans[i].userscount-nTotalOffline;
	}
				
	

}


- (UIImage *)newImageFromResource:(NSString *)filename  
{  
    NSString *imageFile = [[NSString alloc] initWithFormat:@"%@/%@",  
                           [[NSBundle mainBundle] resourcePath], filename];  
    UIImage *image = nil;  
    image = [[UIImage alloc] initWithContentsOfFile:imageFile];  
    [imageFile release];  
    return image;  
}  

-(void) sortContacts
{
	NSLog(@"*****************");
	
	int nTotalOffline=0;
	
	for (int i=0; i<m_nTotalContacts; i++)
	{
	
		if (m_pContacts[i].uStatus==MISTATUS_OFFLINE){
		
			nTotalOffline++;
			XFireContact tmpContact;
			
			if (m_nTotalContacts<=(i+1)) {
			
			
				g_nTotalOnlineUsers=m_nTotalContacts-nTotalOffline+1;
				NSLog(@"g_nTotalOnlineUsers =%d  nTotalOffline=%d m_nTotalContacts=%d",g_nTotalOnlineUsers,nTotalOffline,m_nTotalContacts);

				return; 
			}
			
				
			for (int j=(i+1); j<m_nTotalContacts; j++){
				
			    if (m_pContacts[j].uStatus==MISTATUS_ONLINE){
				
					
					
					memcpy(&tmpContact,&m_pContacts[i],sizeof(XFireContact));
					memcpy(&m_pContacts[i],&m_pContacts[j],sizeof(XFireContact));
					memcpy(&m_pContacts[j],&tmpContact,sizeof(XFireContact));
					break;
					
					
				}
				
			}
			
		
		}
		
			
	}
	
	g_nTotalOnlineUsers=m_nTotalContacts-nTotalOffline+1;
	NSLog(@"g_nTotalOnlineUsers =%d  nTotalOffline=%d",g_nTotalOnlineUsers,nTotalOffline);

	
}


-(XFireContact*) getContactByUsername:(char *)szUsername
{
	
	for (int i=0; i<m_nTotalContacts; i++){
		
		if (memcmp(m_pContacts[i].cUsername,szUsername,strlen(m_pContacts[i].cUsername) )==0)
			
			return &m_pContacts[i];
		
	}
	return NULL;
	
	
}
	



-(void) loadContactsAvatars
{
	
	for (int i=0; i<m_nTotalContacts; i++){
		
		 		
		id path = [NSString stringWithFormat:@"http://screenshot.xfire.com/avatar/160/%s.jpg", m_pContacts[i].cUsername];
		NSURL *url = [NSURL URLWithString:path];
		NSData *data = [NSData dataWithContentsOfURL:url];
		if (data!=nil){
		
		UIImage *img = [[UIImage alloc] initWithData:data];
		
		m_pContacts[i].avatar= [img scaleToSize:CGSizeMake(32.0f,32.0f)];
		
		}
	}
	
	
}





-(void) reloadContactsAvatars
{
	
	for (int i=0; i<m_nTotalContacts; i++){
		
		if (m_pContacts[i].avatar!=nil){
			
			[m_pContacts[i].avatar release];
		    m_pContacts[i].avatar=nil;
		}
		
	}
	
	
}


-(void) clearContactInvite
{
	
	for (int i=0; i<m_nTotalContacts; i++){
		
		m_pContacts[i].invited=FALSE;
		
	}
	
	for (int i=0; i<m_nTotalClans; i++)
	{
			
		if (m_pClans[i].users!=NULL){
			
			for (int j=0; j<m_pClans[i].userscount; j++) 
			{
				
				
				
				
				m_pClans[i].users[j].invited=FALSE;
				
				
				
		    }
		}
	}
	
	

	
}

-(XFireContact*) getContactByUserid:(unsigned long) userid
{
	
	for (int i=0; i<m_nTotalContacts; i++){
		
				if (m_pContacts[i].userid==userid) return &m_pContacts[i];
		
	}
	
	return NULL;
	
}

-(XFireContact *) getContactBySid:(unsigned char *)psid
{
	
	for (int i=0; i<m_nTotalContacts; i++){
		
		
		if (memcmp(m_pContacts[i].sid,psid,16)==0) return &m_pContacts[i];
		
	}
	
	return NULL;
	
}
-(uint32)               getTotalClans

{
	 
	  return m_nTotalClans;


}



-(uint32 )              getTotalContacts
{
	
	
	return m_nTotalContacts;
	
}


-(XFireContact *) getClanContactByUserid:(uint32) userid
{
	
	
	//NSLog(@"ENTER getClanContactByUserid");
	for (int i=0; i<m_nTotalClans; i++)
	{
			//	if (m_pClans[i].userscount>CLAN_MAX_MEMBERS) continue;
		
		if (m_pClans[i].users!=NULL){
			
		   for (int j=0; j<m_pClans[i].userscount; j++) 
		   {
	
			
			 
						   
			   if (m_pClans[i].users[j].userid==userid) return &m_pClans[i].users[j];
			   
			   
			   
		    }
		}
	}
	
	return NULL;
	
}

-(XFireContact *) getClanContactBySid:(unsigned char *)psid
{
	
	for (int i=0; i<m_nTotalClans; i++){
		
		//if (m_pClans[i].userscount>CLAN_MAX_MEMBERS) continue;
		if (m_pClans[i].users)
		for (int j=0; j<m_pClans[i].userscount; j++) {
		
			 if (memcmp(m_pClans[i].users[j].sid,psid,16)==0) return &m_pClans[i].users[j];
		
		}
	}
	
	return NULL;
	
}



-(void) HandleSearchFriends:(unsigned char *)pBuffer MsgSize:(unsigned short) dwMsgSize
{
	
	
	NSLog(@"Enter HandleSearchFriends");
	int ptr=0;
	ptr+=3;
	
	if (pBuffer[ptr++]!=4) return;
	
	
	ptr+=4;
	
	//name
	ptr+=2;
	
	short friends_count= (short)pBuffer[(ptr+1)]; //16
	friends_count<<=8;
	
	friends_count|=(short)(0xFF & pBuffer[(ptr)]); //15
	ptr+=2;
	

	short i=0;
	memset(g_xfireSearchedFriends,0,sizeof(g_xfireSearchedFriends));
	
	if (friends_count>0x80) return;
	
	for ( i=0; i<friends_count; i++)
	{
		
		short uFriendNameLength= (short)pBuffer[(ptr+1)]; //18
		uFriendNameLength<<=8;
		
		uFriendNameLength|=(short)(0xFF & pBuffer[(ptr)]) ; //17
		ptr+=2;
		
		memcpy(g_xfireSearchedFriends[i].cUsername,&pBuffer[ptr],uFriendNameLength);
		//System.arraycopy(pBuffer,ptr, cFriend,0,uFriendNameLength);
	
		
		NSLog([NSString stringWithUTF8String:g_xfireSearchedFriends[i].cUsername]);
		ptr+=uFriendNameLength;
		
	}
	if (pBuffer[ptr++]!=5) return;
	ptr+=5;
	
	//name
	ptr+=2;
	
	friends_count= (short)pBuffer[(ptr+1)]; //16
	friends_count<<=8;
	friends_count|=(short)(0xFF & pBuffer[(ptr)]); //15
	ptr+=2;

	for ( i=0; i<friends_count; i++)
	{
				
		short uFriendNameLength= (short)pBuffer[(ptr+1)]; //18
		uFriendNameLength<<=8;
		
		uFriendNameLength|=(short)(0xFF & pBuffer[(ptr)]) ; //17
		ptr+=2;
		
		if (uFriendNameLength!=0){
			
			
			memcpy(g_xfireSearchedFriends[i].fname,&pBuffer[ptr],uFriendNameLength);
		
		
		}
		
		ptr+=uFriendNameLength;
			
	}
	
	if (pBuffer[ptr++]!=5) return;
	ptr+=5;
	
	//name
	ptr+=2;
	
	friends_count= (short)pBuffer[(ptr+1)]; //16
	friends_count<<=8;
	
	friends_count|=(short)(0xFF & pBuffer[(ptr)]); //15
	ptr+=2;

	for ( i=0; i<friends_count; i++)
	{
		

		short uFriendNameLength= (short)pBuffer[(ptr+1)]; //18
		uFriendNameLength<<=8;
		
		uFriendNameLength|=(short)(0xFF & pBuffer[(ptr)]) ; //17
		ptr+=2;
		
		if (uFriendNameLength!=0){
		
			
			memcpy(g_xfireSearchedFriends[i].lname,&pBuffer[ptr],uFriendNameLength);
			
		}
		ptr+=uFriendNameLength;	
	}
	g_nXfireSearchedFriendCount=friends_count;
	
	[m_pSearchedFriendVC refresh];
	
	
	NSLog(@"Leave  HandleSearchFriends");
	
}





-(void)              handlsRequestForInformation:(unsigned char*) pBuffer MsgSize:(unsigned short) dwMsgSize;
{
	
	
	


	
	NSLog(@"Enter handlsRequestForInformation");
	
	iXfireAppDelegate *delegate = [[UIApplication sharedApplication] delegate];

//	[delegate.m_pNavController.visibleViewController startLoadingAnimation];
	
	int ptr=0;
	
	ptr+=3;//header  skip size
	
	ptr+=2;
	
	
	g_xScreenShotCount=0;
	
	int userid= (int)pBuffer[ptr+3]&0xFF;       //16
	
	
	userid<<=8; 
	userid|=(int)(0xFF & pBuffer[(ptr+2)]);  //15
	
	userid<<=8; 
	userid|=(int)(0xFF & pBuffer[(ptr+1)]);  //15
	
	
	userid<<=8; 
	userid|=(int)(0xFF & pBuffer[(ptr+0)]);  //15
	
	
	ptr+=4;
	
    NSLog(@"user id =%d",userid);
	
	
	if (pBuffer[ptr++]!=0x5C) return;
	
	
	ptr+=2;
	
	unsigned short unklen;
	unklen= (short)pBuffer[ptr+1];       //16
	unklen<<=8; 
	unklen|=(short)(0xFF & pBuffer[ptr]);  //15
	
	//printf("unklen=%08X\n",unklen);
	
	ptr+=2;
	ptr+=unklen*4;   //UNKNOWN 4 BYTES DATA SKIP
	
	
	if (pBuffer[ptr++]!=0x21) return;
	
	ptr+=2;
	
	
	unsigned short nGamdID= (short)pBuffer[ptr+1];       //16
	nGamdID<<=8; 
	nGamdID|=(short)(0xFF & pBuffer[ptr]);  //15
	
	ptr+=2;
	
	//printf("nGamdID=%08X\n",nGamdID);
	
  
	
	
	if (nGamdID==0) {
	
		
		UIActionSheet *actionSheet = [[UIActionSheet alloc] 
									  initWithTitle:@"No screenshots." 
									  delegate:nil 
									  cancelButtonTitle:@"Cancel"
									  destructiveButtonTitle:nil 
									  otherButtonTitles:nil];
		
		actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	//	[actionSheet InView:delegate.m_pNavController.visibleViewController.view];
		[actionSheet release];
		
		
		
	//	[delegate.m_pNavController.visibleViewController  stopLoadingAnimation];
		

		return;
		
	}
	
	if (g_xScreenShot!=NULL) {
		free(g_xScreenShot);
		g_xScreenShot=NULL;
	}
	
	g_xScreenShot=malloc(sizeof(XScreenShot)*nGamdID);

	memset(g_idGamesCategory,0,sizeof(g_idGamesCategory));
	int    countGamesCatergory=0;
	
	  NSLog(@"nGamdID id =%d",nGamdID);//NSLog(@"** handlsRequestForInformation nGamdID="+nGamdID); 
	for (int i=0; i<nGamdID; i++){
		
		
		
		int gameid= (int)pBuffer[ptr+3]&0xFF;       //16
		
		
		gameid<<=8; 
		gameid|=(int)(0xFF & pBuffer[(ptr+2)]);  //15
		
		gameid<<=8; 
		gameid|=(int)(0xFF & pBuffer[(ptr+1)]);  //15
		
		
		gameid<<=8; 
		gameid|=(int)(0xFF & pBuffer[(ptr+0)]);  //15
		
		
		for (int i=0; i<sizeof(g_idGamesCategory)/sizeof(int); i++){
			
			
			if (g_idGamesCategory[i]==gameid) break;
			
			
			if (g_idGamesCategory[i]==0) {
		
			   g_idGamesCategory[i]=gameid;
			
	
			   countGamesCatergory++;
				
				break;
			}
			
		
		}
		
		g_xScreenShot[i].userid=userid;
		g_xScreenShot[i].gameid=gameid;
		
	//	printf("game id=%d\n",gameid);
		
			
		ptr+=4;
		
		
		
	}
	
	if (countGamesCatergory>sizeof(g_idGamesCategory)/sizeof(int)) {
	
			
			free(g_xScreenShot);
			g_xScreenShot=NULL;
	//	[delegate.m_pNavController.visibleViewController stopLoadingAnimation];
		

		
		return;
	}
	
	NSLog(@"countGamesCatergory =%d",countGamesCatergory);
	if (pBuffer[ptr++]!=0x22) return;
	
	
	ptr+=2;
	
	unklen= (short)pBuffer[ptr+1];       //16
	unklen<<=8; 
	unklen|=(short)(0xFF & pBuffer[ptr]);  //15
	
	//printf("unklen=%08X\n",unklen);
	
	ptr+=2;
	ptr+=unklen*4;   //UNKNOWN 4 BYTES DATA SKIP
	
	
	
	if (pBuffer[ptr++]!=0x23) return;
	
	
	ptr+=2;
	
	unklen= (short)pBuffer[ptr+1];       //16
	unklen<<=8; 
	unklen|=(short)(0xFF & pBuffer[ptr]);  //15
	
	//printf("unklen=%08X\n",unklen);
	
	ptr+=2;
	ptr+=unklen*4;   //UNKNOWN 4 BYTES DATA SKIP
	
	
	
	
	
	if (pBuffer[ptr++]!=0x54) return;
	
	
	ptr+=2;
	
	
	int numScreenShotDesc;
	
	numScreenShotDesc= (short)pBuffer[ptr+1];       //16
	numScreenShotDesc<<=8; 
	numScreenShotDesc|=(short)(0xFF & pBuffer[ptr]);
	
	ptr+=2;
	
	 NSLog(@"numScreenShotDesc id =%d",numScreenShotDesc);
	for (int i=0; i<numScreenShotDesc; i++){
		
		int DescLen;
		
		DescLen= (short)pBuffer[ptr+1];       //16
		DescLen<<=8; 
		DescLen|=(short)(0xFF & pBuffer[ptr]);  //15
		
		if (DescLen==0){//No description.
			
			strcpy(g_xScreenShot[i].cComment,"No comment");
			ptr+=2;
			
			continue;
		}
		
		ptr+=2;
		
		
		char *pDesc=(char*)malloc(DescLen+1);
		memset(pDesc,0,DescLen+1);
		memcpy((void*)pDesc,(void*)& pBuffer[ptr],DescLen);
		
		strcpy(g_xScreenShot[i].cComment,pDesc);
		
		//printf("desc ln=%s\n",pDesc);
		
		free(pDesc);
		
		ptr+=DescLen;
		
	}
	
	if (pBuffer[ptr++]!=0x50) return;
	
	
	ptr+=2;
	
	
	int nTimestamps;
	
	nTimestamps= (short)pBuffer[ptr+1];       //16
	nTimestamps<<=8; 
	nTimestamps|=(short)(0xFF & pBuffer[ptr]);
	
	ptr+=2;
	
	//printf("nTimestamps=%d\n",nTimestamps);
	for (int i=0; i<nTimestamps; i++){
		
		
		
		unsigned int timestamp= (int)pBuffer[ptr+3]&0xFF;       //16
		
		
		timestamp<<=8; 
		timestamp|=(int)(0xFF & pBuffer[(ptr+2)]);  //15
		
		timestamp<<=8; 
		timestamp|=(int)(0xFF & pBuffer[(ptr+1)]);  //15
		
		
		timestamp<<=8; 
		timestamp|=(int)(0xFF & pBuffer[(ptr+0)]);  //15
		
		
		
		//__time32_t ltime=timestamp;
		
		
	//	printf( "The time is %s\n", _ctime32( &ltime ) );
		
		
	
		
		ptr+=4;
	}
	
	
	
	if (pBuffer[ptr++]!=0x5E) return;
	
	ptr+=2;
	
	
	unsigned short nGUID= (short)pBuffer[ptr+1];       //16
	nGUID<<=8; 
	nGUID|=(short)(0xFF & pBuffer[ptr]);  //15
	
	
	ptr+=2;
	
	
	unsigned short nDatalen= (short)pBuffer[ptr+1];       //16
	nDatalen<<=8; 
	nDatalen|=(short)(0xFF & pBuffer[ptr]);  //15
	
	
	ptr+=2;
	


	
	for (int i=0; i<nGUID; i++){
		
		char sha1[100]={0};
		hashSha1(&pBuffer[ptr],nDatalen,sha1);
		
		
		
		strcpy(g_xScreenShot[i].cURL,sha1);
		NSLog(@"http://screenshot.xfire.com/screenshot/large/%s.jpg",sha1);
		ptr+=nDatalen;
		
		
		ptr+=2;
	
		
	
		
	}
	//[delegate.m_pNavController.visibleViewController stopLoadingAnimation];
	

 
	g_idGamesCategoryCunt=countGamesCatergory;
	g_xScreenShotCount=nGUID;

	
	ScreenshotsCategoryController    *PScreenshotsCategoryController=[[ScreenshotsCategoryController alloc] initWithNibName:@"ScreenshotsCategoryController"
																													 bundle:nil ];
	
	
	
	

	[delegate.m_pNavController  pushViewController:PScreenshotsCategoryController animated:YES];
	
	
	[PScreenshotsCategoryController release];
	
	
		
}

	
		



/*
 
 ClanPacket 
 
 clancounts  2 bytes
 clans id 
 clans names 
 
 
 */






-(void) cleanup
{

	
	[self reloadContactsAvatars];
	if (m_pContacts==NULL){
	
	   free(m_pContacts);
	   m_pContacts=NULL;
	
	}
	
	for (int i=0; i<m_nTotalClans; i++){
	
		
		free(m_pClans[i].users);
		m_pClans[i].users=NULL;
		
	}
	
	if (m_pClans){
		
		free(m_pClans);
		m_pClans=NULL;
		
	}
	
	
}






-(void) HandleAuth:(unsigned char *)pBuffer MsgSize:(uint32) dwMsgSize
{
	
	#if defined(DEBUG_XFIRE)
	NSLog(@"Enter HandleAuth" );
    #endif
	unsigned char *cp=pBuffer;
	
	cp+=2;
	
	unsigned char cPacket[0x100];
	
	if (memcmp(cp+1,"salt",*cp)==0){
		
		cp=cp+*cp+1+3;
		unsigned char salt[40];
		memcpy(salt,cp,40);
		cp=cPacket;
		*cp++=0x61+strlen(m_cUserName);
		*cp++=0;
		*cp++=1;
		*cp++=0;
		*cp++=3;
		*cp++=4;
		memcpy(cp,"name",4);
		cp+=4;
		*cp++=1;
		*cp++=strlen(m_cUserName);
		*cp++=0;
		memcpy(cp,m_cUserName,strlen(m_cUserName));
		cp+=strlen(m_cUserName);
		
		*cp++=0x08;
		memcpy(cp,"password",8);
		cp+=8;
		*cp++=1;
		*cp++=0x28;
		*cp++=0;
		
		memcpy(cp,cryptPassword(m_cUserName,m_cPassword,salt),40);
		
		[self sendPacketMsg:cPacket length:*(unsigned short*)cPacket];
		
				
	}
	#if defined(DEBUG_XFIRE)
	NSLog(@"Leave HandleAuth" );

	
#endif
}


-(char*)          username
{
	
	return m_cUserName;
}

-(XfireClan*)     clans
{
	
	return m_pClans;
}


-(XFireContact*)     contacts
{
	
	return m_pContacts;
}




-(void)          setLogin:(const char*)Username Password:(const char*)Password
{
	
	
	
	m_nTotalContacts=0;
	
	strcpy(m_cUserName,Username);
	strcpy(m_cPassword,Password);
	
	
	
}
-(void)              setNickname:(char*)nickname
{

	strcpy(_myNickname,nickname);
	
}
-(char*)              mynickname
{
	

	return _myNickname;
	
}

- (void) keepAliveTimer: (id) timer

{
	
	
	

	[self XfMobile_KeepAlive];
	
}	

- (id)init
{
	
		
	
	m_cStatus   = DEF_XSOCKSTATUS_READINGHEADER;      
	m_dwReadSize = 2;    
	m_dwTotalReadSize = 0;
	m_bIsConnected=FALSE;
	m_iQueneHead  = 0;
	m_iQueneTail  = 0;
	m_pContacts=NULL;
	m_pClans=NULL;
	m_nTotalContacts=0;
	m_nTotalClans=0;
	
	
	
	m_pRcvBuffer=malloc(DEF_MSGBUFFERSIZE);
	m_dwBufferSize = DEF_MSGBUFFERSIZE;


	
	int i;
	for ( i = 0; i < DEF_MSGQUENESIZE; i++)  {
		m_pMsgQuene[i] = NULL;
	}
	
	
	
	[NSTimer scheduledTimerWithTimeInterval: 180
	 
									 target: self
	 
								   selector: @selector(keepAliveTimer:)
	 
								   userInfo: nil
	 
									repeats: YES];
	

	
	
	 [NSTimer scheduledTimerWithTimeInterval: 0.5
				
												target: self
				
											  selector: @selector(handleTimer:)
				
											  userInfo: nil
				
											   repeats: YES];
	
	
	
	if(self = [super init])
	{
	   coreSocket = [[AsyncSocket alloc] initWithDelegate:self];
	}
	
	m_pXfGroupChannel=malloc(sizeof(XfGroupChannel));
	
	m_pXfGroupChannel->users=[[NSMutableArray alloc] initWithObjects:nil]; 
	m_pXfGroupChannel->messages=[[NSMutableArray alloc] initWithObjects:nil]; 

	
	return self;
}




- (void)dealloc {
   
	
	//NSLog(@"XfireCore dealloc");
	
	if (m_pXfGroupChannel!=NULL){
		
	
		[m_pXfGroupChannel->users release];
		[m_pXfGroupChannel->messages release];
		
		free(m_pXfGroupChannel);
		m_pXfGroupChannel=NULL;
	}
	
	
	[self cleanup];
	free(m_pRcvBuffer);
	[coreSocket release];
    [super dealloc];
}





-(void) XfMobile_HandleContacts:(unsigned char *)pBuffer  MsgSize:(unsigned short) dwMsgSize
{
	
	
	
	
	uint32 ptr=3;
	
	uint32 friends_usernames_buffersize=read_attribute(pBuffer,ptr,"friends",ARRAY_TYPE,0);
	
	if (friends_usernames_buffersize==-1){
		
	
		return;
	}
	
   	uint8   *friends_usernames_ptr=(uint8*)malloc(friends_usernames_buffersize);
	
	
	ptr=read_attribute(pBuffer,ptr,"friends",ARRAY_TYPE,(uint8*)friends_usernames_ptr);
	
	{
	
	uint32  username_count=0;
	
	uint8  *friends_username_ptr_start=friends_usernames_ptr;
	
	while(friends_username_ptr_start!=(friends_usernames_ptr+friends_usernames_buffersize)){
		
		
		uint16 username_len=0;
		memcpy(&username_len,friends_username_ptr_start,2);
		friends_username_ptr_start+=2;
		
		
		friends_username_ptr_start+=username_len;
		username_count++;
		
		
		
		
	}
		
	//	NSLog(@"XfMobile_HandleContacts number of conatcts %d!",username_count);
		
		if ( m_pContacts!=NULL && m_nTotalContacts!=0){
			
			m_pContacts=realloc(m_pContacts,sizeof(XFireContact)*(m_nTotalContacts+username_count));
			
			m_nTotalContacts+=username_count;
			
		
		}
		else{
		
		
		if (m_pContacts!=NULL){
		
			free(m_pContacts);
			m_pContacts=NULL;
		}
		m_pContacts=malloc(sizeof(XFireContact)*username_count);
		memset(m_pContacts,0,sizeof(XFireContact)*username_count);
		m_nTotalContacts=username_count;
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
		
		
		memcpy(m_pContacts[username_count].cUsername,username,username_len+1);
		
	
		free(username);
		
		friends_username_ptr_start+=username_len;
		username_count++;
		
		
		
		
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
			
			memcpy(m_pContacts[nickname_count].cNickname,nickname,nickname_len+1);
			//NSLog(@"nick=%s user=%s",m_pContacts[nickname_count].cNickname,m_pContacts[nickname_count].cUsername);

			
			free(nickname);
		}else{
			
			//CApp::PutLogList((char*)"no nickname");
			
		}
		nickname_count++;
		friends_nickname_ptr_start+=nickname_len;
		
		
		
		
	}
	
	
	
    uint32 friends_usersid_buffersize=read_attribute(pBuffer,ptr,"userid",ARRAY_TYPE,0);
	
	if (friends_usersid_buffersize!=-1) {
		
		uint32   *friends_users_id_ptr=(uint32*)malloc(friends_usersid_buffersize);
		
		ptr=read_attribute(pBuffer,ptr,"userid",ARRAY_TYPE,(uint8*)friends_users_id_ptr);
		
		
		for (int i=0; i<friends_usersid_buffersize/4; i++)
		{
			
			
			uint32 userid;
			
			
			memcpy(&userid,friends_users_id_ptr+i,4);
			
			//NSLog(@"XfMobile_HandleContacts userid %08X!",userid);
			
			m_pContacts[i].uStatus=MISTATUS_OFFLINE;
			m_pContacts[i]. image=[self newImageFromResource:@"offline.png"];
			m_pContacts[i].Messageslist=nil;
			m_pContacts[i].nTotalRecivedMessages=0;
			m_pContacts[i].userid=userid;
			
			
			
			
		}
		free(friends_users_id_ptr);
		
	}
	
	
	
	
	
	free(friends_nicknames_ptr);
	free(friends_usernames_ptr);
	
	
	[self sortContacts];
}


-(void) XfMobile_HandleSuccessLogin:(unsigned char *)pBuffer  MsgSize:(unsigned short) dwMsgSize
{
	
	uint32 ptr=3;
	
	uint32 my_userid;
	ptr=read_attribute(pBuffer,ptr,"userid",INT_TYPE,(uint8*)&my_userid);
	
	_myuserid=my_userid;
	
	g_myuserid=_myuserid;
	
	uint8 my_sid[16];
	
	ptr=read_attribute(pBuffer,ptr,"sid",SID_TYPE,(uint8*)&my_sid);
	
	memcpy(_mysid,my_sid,16); 
	
	uint32 nickname_length=read_attribute(pBuffer,ptr,"nick",STRING_TYPE,0);
	
	
	
	char *nickname=(char*)malloc(nickname_length);
	
	ptr=read_attribute(pBuffer,ptr,"nick",STRING_TYPE,(uint8*)nickname);
	
	//[length]nickname
	
	
	uint16 nicklen;
	memcpy(&nicklen,nickname,2);
	
	if (nicklen!=0){
	
	   memcpy(_myNickname,nickname+2,nicklen);
	
	}
	free(nickname);
	
	
	//CApp::PutLogList(byteArrayToHexString(my_sid,16));
	
	
	
	
	
}




-(void) XfMobile_HandleIM:(unsigned char *)pBuffer  MsgSize:(unsigned short) dwMsgSize
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
			
			
		{uint32 imindex;
			ptr=read_attribute(pBuffer,ptr,"imindex",INT_TYPE,(uint8*)&imindex);
			
			uint32 im_buffer_size=read_attribute(pBuffer,ptr,"im",STRING_TYPE,0);
			
			uint8 *imbuffer_ptr=(uint8*)malloc(im_buffer_size+1);
			memset(imbuffer_ptr,0,im_buffer_size+1);
			
			ptr=read_attribute(pBuffer,ptr,"im",STRING_TYPE,imbuffer_ptr);
			
			
			if (strlen(imbuffer_ptr+2)>4){
				NSLog(@"msg====%s",imbuffer_ptr+2);
				if (memcmp(imbuffer_ptr+2,"/me",3)==0){
				
					imbuffer_ptr[0+2]=' ';
					imbuffer_ptr[2+2]=' ';
					imbuffer_ptr[2+1]='*';
					
				
					
					
				}
				
			}
			
			
			
			
			XFireContact *pXfireContact=[self  getContactBySid:user_sid];
			
			if (pXfireContact==NULL){
				
				pXfireContact=[self getClanContactBySid:user_sid];
			}
			
			
			if (pXfireContact!=NULL){
			
				
			
				[self.m_pLoginController.m_pContactsController OnRecvMessage:pXfireContact->userid Msg:(imbuffer_ptr+2)];
				
			}
			
			
			
			
			
			
			free(imbuffer_ptr);
			
			
			char im_ACK[] = {
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
			
		
			[self sendPacketMsg:im_ACK length:0x3E];
			
			
		}
			break;
			
		case TYPING_MSG:
		{
			
			uint32 imindex;
			ptr=read_attribute(pBuffer,ptr,"imindex",INT_TYPE,(uint8*)&imindex);
			
			uint32  typing;
			ptr=read_attribute(pBuffer,ptr,"typing",INT_TYPE,(uint8*)&typing);
			
			

			
			XFireContact *pXfireContact=[self  getContactBySid:user_sid];
			
			if (pXfireContact==NULL){
				
				pXfireContact=[self getClanContactBySid:user_sid];
			}
			
			
			if (pXfireContact){
				
				
				[self.m_pLoginController.m_pContactsController OnTypingMessage:pXfireContact->userid];
				
			}
			
			
			
			break;
		}
			
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
			
			
			
			free(saltbuffer_ptr);
			
			
			/*
			struct sockaddr_in 	local_myAddr;
			local_myAddr.sin_addr.s_addr=htonl(local_ip);
			
			struct sockaddr_in 	public_myAddr;
			
			public_myAddr.sin_addr.s_addr=htonl(public_ip);
			
			
			
			wsprintf(dbgmsg,"PUBLIC_INET   ADDRESS is: %s:%d ",inet_ntoa(public_myAddr.sin_addr),public_port);
			CApp::PutLogList(dbgmsg);
			
			
			wsprintf(dbgmsg,"LOCAL_INET   ADDRESS is: %s:%d ",inet_ntoa(local_myAddr.sin_addr),local_port);
			CApp::PutLogList(dbgmsg);
		    wsprintf(dbgmsg,"STATUS %d",status);
			CApp::PutLogList(dbgmsg); */
			
			
			
			
			
		}
			
			
			break;
			
			
			
		default:
			break;
	}
	

	
	
	
	
}


char* byteArrayToHexString(unsigned char *Buffer,unsigned short Size) {
	
	
	unsigned char ch = 0x00;
	int i = 0; 
	
	
	char *pseudo[] = {"0", "1", "2",
		"3", "4", "5", "6", "7", "8",
		"9", "A", "B", "C", "D", "E",
		"F"};
	
	static char out[256];
	
	memset(out,0,sizeof(out));
	
	
	while (i < Size) {
		ch = (unsigned char) (Buffer[i] & 0xF0); // Strip off high nibble
		ch = (unsigned char) (ch >> 4);
		// shift the bits down
		ch = (unsigned char) (ch & 0x0F);    
		// must do this is high order bit is on!
		strcat(out,(pseudo[ (int) ch])); // convert thenibble to a String Character
		ch =  (Buffer[i] & 0x0F); // Strip offlow nibble 
		strcat(out,(pseudo[ (int) ch])); // convert thenibble to a String Character
		i++;
	}
	
	return out;
}    





-(void) XfMobile_HandleBuddyStatus:(unsigned char *)pBuffer  MsgSize:(unsigned short) dwMsgSize
{
	
	
		
	
	uint32 ptr=3;
	
	
	uint8 zerosid[16];
	memset(zerosid,0,sizeof(zerosid));
	
	
	
	
	
	uint32 users_id_buffersize=read_attribute_noname(pBuffer,ptr,ARRAY_TYPE,0);
	
	if (users_id_buffersize==-1){
		
		NSLog(@"HandleBuddyStatus attribute userid not found");
		return;
	}
	
	uint8   *users_id_ptr=(uint8*)malloc(users_id_buffersize);
	
	ptr=read_attribute_noname(pBuffer,ptr,ARRAY_TYPE,(uint8*)users_id_ptr);
	
	
	
	uint32 users_sid_buffersize=read_attribute_noname(pBuffer,ptr,3,0);
	
	if (users_sid_buffersize==-1) {
		
		NSLog(@"HandleBuddyStatus attribute sid not found");
		return;
	}
	
	uint8   *users_sid_ptr=(uint8*)malloc(users_sid_buffersize);
	
	ptr=read_attribute_noname(pBuffer,ptr,3,users_sid_ptr);
	
	
	for (uint32 i=0; i<users_sid_buffersize/16; i++){
		
		bool bOnline;
		if (memcmp(zerosid,users_sid_ptr+i*16,16)==0){
			
			//user goes offline
			bOnline=FALSE;
			
			
		}else{
			
			bOnline=TRUE;
				
		}
		
		
		uint32 userid;
		
		memcpy(&userid,users_id_ptr+i*4,4);
		NSLog(@"XfMobile_HandleBuddyStatus userid=%08X !",userid);
		
		uint8 sid[16];
		memcpy(sid,users_sid_ptr+i*16,16);
		
		XFireContact *xcontact=[self getContactByUserid:userid];
		if (xcontact ) {
			
		    	memcpy(xcontact->sid,sid,16);
			
				[self.m_pLoginController.m_pContactsController UpdateContact:userid isOnline:bOnline];
		}
		
		
			
			XFireContact *clan_xcontact=[self getClanContactByUserid:userid];
			if (clan_xcontact) 
			{
				memcpy(clan_xcontact->sid,sid,16);
			
					[self.m_pLoginController.m_pContactsController UpdateContact:userid isOnline:bOnline];
			}
		
	
		
		
		
		
		
	}
	
	free(users_id_ptr);
	free(users_sid_ptr);
	
	
	
	
	
	
}




-(void) XfMobile_HandlePlayingGame:(unsigned char *)pBuffer  MsgSize:(unsigned short) dwMsgSize
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
		
		
		uint8 sid[16];
		memcpy(sid, users_sid_ptr+i*16, 16);
		XFireContact*pFriend=[self getContactBySid:sid];
		if (pFriend!=nil){
			
			pFriend->gameid=gameid;
			
			char *pName=GetGameName(gameid);
			if (pName)  {
				
				
				strcpy(pFriend->cGamename,pName);
				
				[self.m_pLoginController.m_pContactsController UpdateContactsGameName:pFriend];
				
				
				
			}

			
		}
		
		pFriend=[self getClanContactBySid:sid];
		if (pFriend!=nil){
			
			
			pFriend->gameid=gameid;
			
			char *pName=GetGameName(gameid);
			if (pName)  {
				
				
				strcpy(pFriend->cGamename,pName);
				
				[self.m_pLoginController.m_pContactsController UpdateContactsGameName:pFriend];
				
				
				
			}
		}
		

		
	}
	
	free(users_sid_ptr);
	free(users_gameids_buffer);
	
	
	
	
	
	
}

-(void) XfMobileHandle_SystemBroadcast:(unsigned char *)pBuffer  MsgSize:(unsigned short) dwMsgSize
{
	
	
}
-(void) XfMobileHandleHeartbeat:(unsigned char *)pBuffer  MsgSize:(unsigned short) dwMsgSize
{
	
	
	
	
	uint32 ptr=3;
	uint8 did[21];
	ptr=read_attribute(pBuffer,ptr,"did",GSID_TYPE,(uint8*)did);
	
	if (ptr==-1)  return;
	

	

}

-(void) XfMobile_HandleNewNickName:(unsigned char *)pBuffer  MsgSize:(unsigned short) dwMsgSize
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

-(void) XfMobileHandle_AvatarInfo:(unsigned char *)pBuffer  MsgSize:(unsigned short) dwMsgSize
{
	
	
	uint32 ptr=3;
	
	uint32 userid;
	ptr=read_attribute_noname(pBuffer,ptr,USERID_TYPE,(uint8*)&userid);
	
	
	
	uint32 avatar_type;
	
	ptr=read_attribute_noname(pBuffer,ptr,AVATAR_TYPE,(uint8*)&avatar_type);
	
	uint32 avatar_number;
	
	ptr=read_attribute_noname(pBuffer,ptr,AVATAR_TYPE,(uint8*)&avatar_number);
	
	
	
	
	
	
	
	
}


-(void) XfMobile_HandleMismatchVersion:(unsigned char *)pBuffer  MsgSize:(unsigned short) dwMsgSize
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
	

	
	[self sendPacketMsg:version length:sizeof(version)];
	
	
}

-(void) XfMobile_HandleStatusMessage:(unsigned char *)pBuffer  MsgSize:(unsigned short) dwMsgSize
{
	
	
	
	uint32 ptr=3;
	
	uint32 users_sid_buffersize=read_attribute(pBuffer,ptr,"sid",ARRAY_TYPE,0);
	
    uint8   *users_sid_ptr=(uint8*)malloc(users_sid_buffersize);
	
	ptr=read_attribute(pBuffer,ptr,"sid",ARRAY_TYPE,users_sid_ptr);
	
	for (uint32 i=0; i<users_sid_buffersize/16; i++){
		
		
	}
	
	
	uint32 friends_msgs_buffersize=read_attribute(pBuffer,ptr,"msg",ARRAY_TYPE,0);
	
	if (friends_msgs_buffersize==-1){
		
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
			
			uint8 sid[16];
			memcpy(sid,users_sid_ptr+msgs_count*16,16);
			msgs_count++;
			
			XFireContact *pXfireContact=[self getContactBySid:sid];
			
			
			if (pXfireContact==nil){
				
				pXfireContact=[self getClanContactBySid:sid];
			}
			
			if (pXfireContact) {
				
				
				memset(pXfireContact->cStatusMsg,0,sizeof(pXfireContact->cStatusMsg));
				memcpy(pXfireContact->cStatusMsg,msg,msg_len+1);
				
				
				if (memcmp(pXfireContact->cStatusMsg,"(AFK)",5)==0){
					
					
					pXfireContact->uStatus=MISTATUS_AWAY;
					
					if (pXfireContact->image!=nil){
						
						
						[pXfireContact->image release];
						pXfireContact-> image=[self newImageFromResource:@"away.png"];
						
					}
					
					
				}
				
				
				
				
				[self.m_pLoginController.m_pContactsController UpdateContactsStatusMessage];
			}
				
			
			free(msg);
		}else{
			
			
		}
		
		friends_msgs_ptr_start+=msg_len;
		
		
		
		
	}
	
	
	free(friends_msgs_ptr);
	free(users_sid_ptr);
	
	
	
}




-(bool) removeGroupUser:(uint32)userid
{
	
	for (uint32 i=0; i<[m_pXfGroupChannel->users count]; i++)
	{
		
		
		
		XGroupUser *pGroupUser=[m_pXfGroupChannel->users objectAtIndex:i];
		
		if (pGroupUser->userid==userid) {
			
			[m_pXfGroupChannel->users removeObjectAtIndex:i];
			
			NSLog(@"user was removed");
			return true;
			
		}
		
	}
	
	return false;
	
}

-(XGroupUser*) getGroupUser:(uint32)userid
{

	for (uint32 i=0; i<[m_pXfGroupChannel->users count]; i++)
	{
		
	
		
		XGroupUser *pGroupUser=[m_pXfGroupChannel->users objectAtIndex:i];
		
		if (pGroupUser->userid==userid) {
		
			//NSLog(@"user was found");
			return pGroupUser;
		
		}
		
	}
	
	return nil;
	
}

-(void) XfMobileGChat_HandleBuddys:(unsigned char *)pBuffer  MsgSize:(unsigned short) dwMsgSize

{
	

	NSLog(@"Enter XfMobileGChat_HandleBuddys" );
	
	
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
	
	[m_pXfGroupChannel->users removeAllObjects];
	
	for (uint32 i=0; i<clans_usersid_count; i++)
	{
		
		XGroupUser *pGroupUser=[XGroupUser alloc];
		
		pGroupUser->userid=*(users_id_buffer+i);

	//	NSLog(@"Adding user %08X to group chat",pGroupUser->userid);
		
		[m_pXfGroupChannel->users addObject:pGroupUser];
		
		
		[pGroupUser release];
		
		

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
		
		
		    XGroupUser *pGroupUser=[m_pXfGroupChannel->users objectAtIndex:i];
		
			if (clan_realnamelen!=0){
			
			uint8 *clan_realname=(uint8*)malloc(clan_realnamelen+1);
			
			memset(clan_realname,0,clan_realnamelen+1);
			memcpy(clan_realname,clans_realname_startbuffer,clan_realnamelen);
			
			memcpy(pGroupUser->name,clan_realname,clan_realnamelen+1);
			
		     [m_pXfGroupChannel->users replaceObjectAtIndex:i withObject:pGroupUser];
			
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
		
		
			
		XGroupUser *pGroupUser=[m_pXfGroupChannel->users objectAtIndex:i];
		
		
		
		if (clan_nicknamelen!=0){
			
			
			
			uint8 *clan_nickname=(uint8*)malloc(clan_nicknamelen+1);
			
			memset(clan_nickname,0,clan_nicknamelen+1);
			memcpy(clan_nickname,clans_nickname_startbuffer,clan_nicknamelen);
			
			memcpy(pGroupUser->nick,clan_nickname,clan_nicknamelen+1);
			
			
			
			[m_pXfGroupChannel->users replaceObjectAtIndex:i withObject:pGroupUser];
			
			
			
			
			free(clan_nickname);
		}
		clans_nickname_startbuffer+=clan_nicknamelen;
	}
	
	
	
	free(clans_realnames_buffer);
	free(clans_nicknames_buffer);
	
	
	
	free(users_permissions_buffer);
	
    free(users_id_buffer);
	
	
	iXfireAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	
	[self.m_pLoginController.m_pContactsController.m_GroupController  setGroup:[self getActiveGroup]];
	
	self.m_pLoginController.m_pContactsController.title=@"☚";
	if (delegate.m_pNavController.visibleViewController==self.m_pLoginController.m_pContactsController.m_GroupController ) {
		
		return;
	}
	
	
	
	[self.m_pLoginController.m_pContactsController  addNewGroupChat];
	
	
	[delegate.m_pNavController  pushViewController:self.m_pLoginController.m_pContactsController.m_GroupController  animated:YES];
	
	
	
	[self.m_pLoginController.m_pContactsController.m_GroupController refreshContacts];
	
	NSLog(@"Leave XfMobileGChat_HandleBuddys" );

}



-(void) XfMobileGChat_Leave:(unsigned char *)gsid
{
	
	uint32 ptr=5;
	
	unsigned char packet[0x400];
	uint32 climsg = 0x4CF5;
	
	ptr=write_attribute(packet,ptr,
						
						"climsg",INT_TYPE,(uint8*)&climsg);
	uint8 msgattrib=1;
	
	ptr=write_attribute(packet,ptr,
						
						"msg",0x09,(uint8*)&msgattrib);
	ptr=write_attribute_noname(packet,ptr,0x04,(uint8*)gsid);
	
	add_header(packet,ptr,0x19,2);
	
	[self sendPacketMsg:packet length:ptr];
	

	
}



-(void) XfMobileGChat_HandleMOTD:(unsigned char *)pBuffer  MsgSize:(unsigned short) dwMsgSize

{
	
	
	
	uint32 ptr=3;
	

	
	
	uint8 gsid[21]={0};
	ptr=read_attribute_noname(pBuffer,ptr,GROUP_SID,gsid);
	
   	
	uint8 motd[0x100]={0};
	ptr=read_attribute_noname(pBuffer,ptr,0x2E,(uint8*)motd);
	

	
	
}

-(void) XfMobileHandle_Invitation_Accept:(char *)p_name
{
	
	uint8 packet[0x400];
	
	uint32 ptr=5;
	
	ptr=write_attribute(packet,ptr,
						
						"name",STRING_TYPE,(uint8*)_user_pending_invite);
	add_header(packet,ptr,0x07,1);
	
	
	[self sendPacketMsg:packet length:ptr];
	
	return ;
}

-(void) XfMobileHandle_Invitation_Reject:(char *)p_name
{
	
	uint8 packet[0x400];
	
	uint32 ptr=5;
	
	ptr=write_attribute(packet,ptr,"name",STRING_TYPE,(uint8*)_user_pending_invite);
	add_header(packet,ptr,0x08,1);
	
    [self sendPacketMsg:packet length:ptr];
	return ;
}



-(void) XfMobileHandle_BuddyInitation:(unsigned char *)pBuffer  MsgSize:(unsigned short) dwMsgSize
{
	
	
	uint32 ptr=3;
	
	uint32 friends_usernames_buffersize=read_attribute(pBuffer,ptr,"name",ARRAY_TYPE,0);
	if (friends_usernames_buffersize==-1){
		return;
	}
	
	uint8 *friends_usernames_ptr=(uint8*)malloc(friends_usernames_buffersize);
	
	ptr=read_attribute(pBuffer,ptr,"name",ARRAY_TYPE,(uint8*)friends_usernames_ptr);
	
	char name[0x100]={0};
	
	uint32 username_count=0;
	
	uint8 *friends_username_ptr_start=friends_usernames_ptr;
	
	while(friends_username_ptr_start!=(friends_usernames_ptr+friends_usernames_buffersize)){
		uint16 username_len=0;
		
		memcpy(&username_len,friends_username_ptr_start,2);
		
		friends_username_ptr_start+=2;
		
		uint8 *username=(uint8*)malloc(username_len+1);
		
		memset(username,0,username_len+1);
		
		memcpy(username,friends_username_ptr_start,username_len);
	
		memcpy(name,username,username_len);
		
		// XfMobileHandle_Invitation_Accept((char*)username);
		free(username);
		
		friends_username_ptr_start+=username_len;
		
		break;
		
	}
	
	uint32 friends_nicknames_buffersize=read_attribute(pBuffer,ptr,
													   
													   "nick",ARRAY_TYPE,0);
	if (friends_nicknames_buffersize==-1){
		return;
	}
	
	uint8 *friends_nicknames_ptr=(uint8*)malloc(friends_nicknames_buffersize);
	
	ptr=read_attribute(pBuffer,ptr,
					   
					   "nick",ARRAY_TYPE,(uint8*)friends_nicknames_ptr);
	uint32 nickname_count=0;
	char nick[0x100]={0};
	uint8 *friends_nickname_ptr_start=friends_nicknames_ptr;
	
	while(friends_nickname_ptr_start!=(friends_nicknames_ptr+friends_nicknames_buffersize)){
		uint16 nickname_len=0;
		
		memcpy(&nickname_len,friends_nickname_ptr_start,2);
		
		friends_nickname_ptr_start+=2;
		
		if (nickname_len){
			uint8 *nickname=(uint8*)malloc(nickname_len+1);
			
			memset(nickname,0,nickname_len+1);
			
			memcpy(nickname,friends_nickname_ptr_start,nickname_len);
			memcpy(nick,nickname,nickname_len);
			
			free(nickname);
			break;
		}
		
		else{
			//CApp::PutLogList((char*)"no nickname");
		}
		
		friends_nickname_ptr_start+=nickname_len;
		
		break;
		
	}
	
	uint32 msg_buffersize=read_attribute(pBuffer,ptr,
										 
										 "msg",ARRAY_TYPE,0);
	if (msg_buffersize==-1){
		return;
	}
	
	uint8 *msg_ptr=(uint8*)malloc(msg_buffersize);
	
	ptr=read_attribute(pBuffer,ptr,"msg",ARRAY_TYPE,(uint8*)msg_ptr);
	uint8 *msg_ptr_start=msg_ptr;
	file://localhost/Users/motijoseph/Desktop/XfMobile%20Pro/PreferencesViewController.m
	while(msg_ptr_start!=(msg_ptr+msg_buffersize)){
		uint16 msg_len=0;
		
		memcpy(&msg_len,msg_ptr_start,2);
		
		msg_ptr_start+=2;
		
		if (msg_len){
			
			
			uint8 *msg=(uint8*)malloc(msg_len+1);
			
			memset(msg,0,msg_len+1);
			
			memcpy(msg,msg_ptr_start,msg_len);
			
			char invite[0x100];
			
			strcpy(_user_pending_invite,name);
			sprintf(invite,"user=%s nick=%s\n %s",name,nick,msg);
			
			
			[self.m_pLoginController.m_pContactsController showBuddyinvite:invite ];

			free(msg);
			break;
			
		}
		
		else{
			//CApp::PutLogList((char*)"no nickname");
		}
		
		msg_ptr_start+=msg_len;
		
	}
	
	free(msg_ptr);
	
	free(friends_usernames_ptr);
	

}

-(void) XfMobileGChat_BuddyJoin:(unsigned char *)pBuffer  MsgSize:(unsigned short) dwMsgSize

{
	
	uint32 ptr=3;
	
	
    uint8 gsid[21]={0};
	ptr=read_attribute_noname(pBuffer,ptr,GROUP_SID,gsid);
	
    uint32 userid;
	
	ptr=read_attribute_noname(pBuffer,ptr,0x01,(uint8*)&userid);
	
	if (userid==_myuserid) return;
	
	uint8 name[0x100];
	
	ptr=read_attribute_noname(pBuffer,ptr,0x02,(uint8*)name);
	
	uint8 nick[0x100];
	
	ptr=read_attribute_noname(pBuffer,ptr,0x0D,(uint8*)nick);
	
	uint32 perm = 0;
	
	ptr=read_attribute_noname(pBuffer,ptr,0x12,(uint8*)&perm);
	
	
	XGroupUser *pGroupUser=[XGroupUser alloc];

	pGroupUser->userid=userid;
	
	pGroupUser->permissions=perm;
	memset(pGroupUser->name,0,sizeof(pGroupUser->name));
	memcpy(pGroupUser->name,name+2,*(unsigned short*)name);
	
	
	memset(pGroupUser->nick,0,sizeof(pGroupUser->nick));
	memcpy(pGroupUser->nick,nick+2,*(unsigned short*)nick);

	
	NSLog(@"new user join %s ",pGroupUser->name);
	
	
	char msg[0x200]={0};
	
	
	sprintf(msg,"☛%s join the chat.",pGroupUser->name);
	
	
	
	[m_pXfGroupChannel->messages addObject:[NSString stringWithUTF8String:msg]];

	
	
	
	[m_pXfGroupChannel->users addObject:pGroupUser];
	
	[self.m_pLoginController.m_pContactsController.m_GroupController refreshContacts];
	
	[pGroupUser release];
	
	
}


-(void) XfMobileGChat_BuddyPart:(unsigned char *)pBuffer  MsgSize:(unsigned short) dwMsgSize
{
    
	uint32 ptr=3;
	

    uint8 gsid[21]={0};
	ptr=read_attribute_noname(pBuffer,ptr,GROUP_SID,gsid);
	
    uint32 userid;
	
	ptr=read_attribute_noname(pBuffer,ptr,0x01,(uint8*)&userid);
	
	if (userid==_myuserid) return;
	
	XGroupUser*user= [self getGroupUser:userid];
	
	if (user!=NULL){
	
		
		NSLog(@"user %s left the channel",user->name);
		
		
		char msg[0x200]={0};
		
		
		sprintf(msg,"☛%s left the chat.",user->name);
		
		
		
		[m_pXfGroupChannel->messages addObject:[NSString stringWithUTF8String:msg]];
		
		
	}
	
	[self removeGroupUser:userid];
	
	
	
	[self.m_pLoginController.m_pContactsController.m_GroupController refresh];
	
	
	[self.m_pLoginController.m_pContactsController.m_GroupController refreshContacts];
	
	
}


-(void) XfMobileGChat_SendIM:(unsigned char *)gsid  msg:(char*) message
{
	
	
	uint32 ptr=5;
	
	unsigned char packet[0x400]; 
	
	uint32 climsg = 0x4CF6;
	
	ptr=write_attribute(packet,ptr,"climsg",INT_TYPE,(uint8*)&climsg);
	
	uint8 msgattrib=2;
	ptr=write_attribute(packet,ptr,"msg",0x09,(uint8*)&msgattrib);
	
	ptr=write_attribute_noname(packet,ptr,0x04,(uint8*)gsid);
	
	
	ptr=write_attribute_noname(packet,ptr,0x2E,(uint8*)message);
	
	
    add_header(packet,ptr,0x19,2);
	
	
[self sendPacketMsg:packet length:ptr];
	
	
}


-(void) XfMobileGChat_AcceptInvite:(unsigned char *)gsid  roomName:(char*) room  passRoom:(char*)pass
{

	
	uint32 ptr=5;
	
	unsigned char packet[0x100]; 
	
	uint32 climsg =0x4CF4;
	
	ptr=write_attribute(packet,ptr,"climsg",INT_TYPE,(uint8*)&climsg);
	
	
	uint8 msgattrib=6;
	ptr=write_attribute(packet,ptr,"msg",0x09,(uint8*)&msgattrib);
	
	ptr=write_attribute_noname(packet,ptr,0x04,(uint8*)gsid);
	
	
	uint32 requestIndex = 1;
	
	ptr=write_attribute_noname(packet,ptr,0x0B,(uint8*)&requestIndex);
	
	
	uint32 chatRoomType = 1;
	
	ptr=write_attribute_noname(packet,ptr,0xAA,(uint8*)&chatRoomType);
	
	
	ptr=write_attribute_noname(packet,ptr,0x05,(uint8*)room);
	
	ptr=write_attribute_noname(packet,ptr,0x5F,(uint8*)pass);
	
	uint8 autoName = 0;
	ptr=write_attribute_noname(packet,ptr,0xA7,(uint8*)&autoName);
	
	
	
	add_header(packet,ptr,0x19,2);
	
	
//	[m_pXfGroupChannel->messages removeAllObjects];
	
	[self sendPacketMsg:packet length:ptr];

	
}


-(void) XfMobileGChat_HandleIM:(unsigned char *)pBuffer  MsgSize:(unsigned short) dwMsgSize
{

	
	
	uint32 ptr=3;

    uint8 gsid[21]={0};
	
	ptr=read_attribute_noname(pBuffer,ptr,GROUP_SID,gsid);
	
	
	uint32 userid;
	
	ptr=read_attribute_noname(pBuffer,ptr,0x01,(uint8*)&userid);
	
	
	uint8 message[0x200]={0};
	ptr=read_attribute_noname(pBuffer,ptr,0x2E,(uint8*)message);
	
	
	XGroupUser *user=[ self getGroupUser:userid];
	
	if (user!=NULL) {
	
		
	
	char msg[0x200]={0};
	
	sprintf(msg,"%s says: %s",user->name,(char*)message+2);
	
	
	
	
	[m_pXfGroupChannel->messages addObject:[NSString stringWithUTF8String:msg]];
	
	

	[self.m_pLoginController.m_pContactsController.m_GroupController refresh];
	
	}
	
	
	
}


-(void) XfMobileGChat_SendMOTD:( uint8 *)gsid  p_motd:( char*) motd
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
	
	
	
	[self sendPacketMsg:packet length:ptr];

	
	
}

-(void) XfMobileGChat_CreateRoom:(char *)room  password:(char*) pass
{
	
	
	unsigned char packet[65535*2];
	
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
		
	[self sendPacketMsg:packet length:ptr];
	

}

-(void) XfMobileGChat_SendInvite:(uint8*) sid
{
	
	
	NSLog(@"Enter XfMobileGChat_SendInvite");
	
	unsigned char packet[0x200];
	uint32 ptr=5;
	
	uint32 climsg =0x4CF7;
	
	ptr=write_attribute(packet,ptr,"climsg",INT_TYPE,(uint8*)&climsg);
	uint8 msgattrib=3;
	
	ptr=write_attribute(packet,ptr,"msg",0x09,(uint8*)&msgattrib);
	NSLog(@"Enter ptr %d",ptr);
	

	
	ptr=write_attribute_noname(packet,ptr,4,(uint8*)m_pXfGroupChannel->gsid);
	NSLog(@"Enter ptr %d",ptr);


	
	ptr=write_attribute_noname(packet,ptr,0x11,(uint8*)sid);
	
	NSLog(@"Enter ptr %d",ptr);

	uint32 id=0;
	
	ptr=write_attribute_noname(packet,ptr,0x47,(uint8*)&id);
	NSLog(@"Enter ptr %d",ptr);

	add_header(packet,ptr,0x19,2);
	
	[self sendPacketMsg:packet length:ptr];
	
	

	
}
-(void) XfMobileGChat_RejectInvite:(uint8 *)gsid
{
	
	
	
	unsigned char packet[0x100]; 
	
	uint32 ptr=5;
	
	uint32 climsg =0x4CFF;
	
	ptr=write_attribute(packet,ptr,"climsg",INT_TYPE,(uint8*)&climsg);
	
	
	uint8 msgattrib=1;
	ptr=write_attribute(packet,ptr,"msg",0x09,(uint8*)&msgattrib);
	
	
	ptr=write_attribute_noname(packet,ptr,4,(uint8*)gsid);
	
	
	add_header(packet,ptr,0x19,2);
	
	
	
	[self sendPacketMsg:packet length:ptr];

	
	
	
	return ;
}



-(char*)   getGroupName
{
	
	return m_pXfGroupChannel->room;
}

-(XfGroupChannel*)   getActiveGroup
{
	
	return m_pXfGroupChannel;
}


-(void) LeaveGroupChat
{

	
	[self XfMobileGChat_Leave:m_pXfGroupChannel->gsid ];
}





-(void) AcceptGroupInvite
{
		[self XfMobileGChat_AcceptInvite:m_pXfGroupChannel->gsid roomName:m_pXfGroupChannel->room passRoom:""];
}





-(void) XfMobileGChat_TopicChange:(unsigned char *)pBuffer  MsgSize:(unsigned short) dwMsgSize
{
	
	uint32 ptr=3;
	
	uint8 gsid[21]={0};
	
	ptr=read_attribute_noname(pBuffer,ptr,GROUP_SID,gsid);
	
	uint8 topic[0x100]={0};
	
	ptr=read_attribute_noname(pBuffer,ptr,0x05,(uint8*)topic);
	
	 
	
	char msg[0x200]={0};
		
	
	sprintf(msg,"☛T room title is now  %s",((char*)topic+2));
	
	memset(m_pXfGroupChannel->room,0,sizeof(m_pXfGroupChannel->room));
	memcpy(m_pXfGroupChannel->room,(char*)topic+2,*(unsigned short*)topic);
	
	NSLog([NSString stringWithUTF8String:msg]);
	
	[m_pXfGroupChannel->messages addObject:[NSString stringWithUTF8String:msg]];
	
	
	
	[self.m_pLoginController.m_pContactsController.m_GroupController refresh];

	
	
	
}

-(void) XfMobileGChat_MotdChange:(unsigned char *)pBuffer  MsgSize:(unsigned short) dwMsgSize
{
	

	uint32 ptr=3;

	uint8 gsid[21]={0};
	
	ptr=read_attribute_noname(pBuffer,ptr,GROUP_SID,gsid);
	
	uint8 motd[0x100]={0};
	
	ptr=read_attribute_noname(pBuffer,ptr,0x2E,(uint8*)motd);
    char msg[0x200]={0};

    sprintf(msg," ☛Today's Message: %s",(char*)((char*)motd+2));

	NSLog(@"%s",msg);
	
    [m_pXfGroupChannel->messages addObject:[NSString stringWithUTF8String:msg]];
	[self.m_pLoginController.m_pContactsController.m_GroupController refresh];


}

-(void) XfMobileGChat_JoinRoom:(unsigned char *)pBuffer  MsgSize:(unsigned short) dwMsgSize
{
	
	
	uint32 ptr=3;
	
			
	uint8 gsid[21]={0};
	
	ptr=read_attribute_noname(pBuffer,ptr,GROUP_SID,gsid);
	
	memcpy(m_pXfGroupChannel->gsid,gsid,21);
	

	
	//XfMobileHandle_SendInvite(x,0xCBFAE4);
}

-(void) XfMobileGChat_HandleInvite:(unsigned char *)pBuffer  MsgSize:(unsigned short) dwMsgSize
{
	
    
	uint32 ptr=3;
	
	uint8 gsid[21]={0};
	
	ptr=read_attribute_noname(pBuffer,ptr,GROUP_SID,gsid);

	uint32 unknown;
	ptr=read_attribute_noname(pBuffer,ptr,0xAA,(uint8*)&unknown);
	
	uint32 userid;
	
	
	ptr=read_attribute_noname(pBuffer,ptr,1,(uint8*)&userid);
	
	
	uint8 name[0x100]={0};
	
	ptr=read_attribute_noname(pBuffer,ptr,2,(uint8*)name);
	
	
	uint8 nick[0x100]={0};
	
	ptr=read_attribute_noname(pBuffer,ptr,0x0D,(uint8*)nick);
	
	
	uint8 room[0x100]={0};
	
	ptr=read_attribute_noname(pBuffer,ptr,0x05,(uint8*)room);

	memcpy(m_pXfGroupChannel->gsid,gsid,21);
	
	m_pXfGroupChannel->owner_userid=userid;
	memset(m_pXfGroupChannel->host,0,sizeof(m_pXfGroupChannel->host));
	memset(m_pXfGroupChannel->room,0,sizeof(m_pXfGroupChannel->room));

	memcpy(m_pXfGroupChannel->host,name+2,*(unsigned short*)name);
	memcpy(m_pXfGroupChannel->room,room+2,*(unsigned short*)room);

	
	
	[self.m_pLoginController.m_pContactsController showGoupChatinvite:m_pXfGroupChannel ];
	
	
	
}


#define XFIRE_PACKET_SCREENSHOTS 0x00AC


-(void) send_push_token
{
	
	
	// create the request
	
	char post_token[0x100];
	
	sprintf(post_token,"http://www.xf-mobile.com/download/set_token.php?username=%s&token=%s",m_cUserName,push_token_id);
	
	NSLog(@"sending token =%s",post_token);
	
	NSString* escapedUrl = [[NSString stringWithFormat:@"%s",post_token]   
							stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; 
	
	NSLog(@"%@",escapedUrl);
	
	NSURL *url = [NSURL URLWithString:escapedUrl];
	NSURLRequest *request = [NSURLRequest requestWithURL: url];
	NSHTTPURLResponse *response;
	[NSURLConnection sendSynchronousRequest: request returningResponse: &response error: nil];
	
	NSLog(@"code=%d",[response  statusCode]);
	
}

-(void) ParseMessage:(unsigned char *)pBuffer  MsgSize:(unsigned short) dwMsgSize
{
	
	
	unsigned short cPacketID;
	cPacketID=*(unsigned short*)pBuffer;
	
	switch(cPacketID){
			
		case 138:
			
			NSLog(@"received buddy invite\n");
			
			[self XfMobileHandle_BuddyInitation:pBuffer MsgSize:dwMsgSize];	
			
			break;
			
		case 350:
	
			
			NSLog(@"received chat room topic change\n");
			
			[self XfMobileGChat_TopicChange:pBuffer MsgSize:dwMsgSize];	
			
			break;
			
		case 351:
			NSLog(@"received chat room join info\n");
			
			
			[self XfMobileGChat_JoinRoom:pBuffer MsgSize:dwMsgSize];	
			
			break;
			
		case 353:
			NSLog(@ "received chat room, user join message\n");
			
		 [self XfMobileGChat_BuddyJoin:pBuffer MsgSize:dwMsgSize];
			

			break;
			
		case 354:
			NSLog(@ "received chat room, user leave message\n");
			
			
			[self XfMobileGChat_BuddyPart:pBuffer MsgSize:dwMsgSize];

			break;
			
		case 355:
		NSLog(@  "got chat room message\n");
			
			[self XfMobileGChat_HandleIM:pBuffer MsgSize:dwMsgSize];
			
		
			break;
			
		case 356:
			NSLog(@  "received chat room invite\n");
			
			[self XfMobileGChat_HandleInvite:pBuffer MsgSize:dwMsgSize];
	
			
			
			break;
			
		case 357:
			NSLog(@ "chat room buddy permission changed\n");
			
			break;
			
		case 358:
			NSLog(@  "persistent chat room infos received\n");
			
			break;
			
		case 359:
	         NSLog(@ "chat room buddy kicked notification received\n");
			break;
			
		case 368:
			NSLog(@  "received chat room info (buddy list)\n");
			
			[self XfMobileGChat_HandleBuddys:pBuffer MsgSize:dwMsgSize];			
			
			break;
			
		case 370:
			NSLog(@"chat room default permission change received\n");
			
			break;
			
		case 374:
			NSLog(@ "chat room motd changed\n");
			
			[self XfMobileGChat_MotdChange:pBuffer MsgSize:dwMsgSize];	
			
			break;
			
		case 385:
		NSLog(@ "chat room password change received\n");
			
			break;
			
		case 386:
			NSLog(@ "chat room accessibility change received\n");
			
			break;
			
		case 387:
			NSLog(@ "received chat room reject confirmation\n");
			
			break;
			
		case 388:
			NSLog(@"chat room silenced change received\n");
			
			break;
			
			
			
			
		case XFIRE_PACKET_SCREENSHOTS:
			
			
			[self handlsRequestForInformation :pBuffer  MsgSize:dwMsgSize-1];
		
			break;
			
		case 0x8F:
			
			[self HandleSearchFriends:pBuffer  MsgSize:dwMsgSize-1];
			
			break;
			
		case XFIRE_PACKET_CONTACTS:
			
			
			NSLog(@"XFIRE_PACKET_CONTACTS");

			[self XfMobile_HandleContacts:pBuffer MsgSize:dwMsgSize];
			break;
			
			
		case XFIRE_PACKET_AUTH_ID:

			[self HandleAuth:pBuffer+1  MsgSize:dwMsgSize-1];
			break;
		case XFIRE_LOGIN_FAILED_ID:
			
			

			m_bIsConnected=FALSE;
			
			[m_pLoginController OnConnectionFailed];
					

			
			break;
		case XFIRE_LOGIN_SUCCESS_ID:
			NSLog(@"XFIRE_LOGIN_SUCCESS_ID");
			[self XfMobile_HandleSuccessLogin:pBuffer MsgSize:dwMsgSize];
			
			[self send_push_token];
			
			m_bIsConnected=TRUE;
	        [m_pLoginController SwitchToContactsView];
			
			break;
		case XFIRE_BUDDY_STATUS_ID:
			
			
			
			NSLog(@"XFIRE_BUDDY_STATUS_ID");
            
			[self XfMobile_HandleBuddyStatus:pBuffer MsgSize:dwMsgSize];
			break;
			
		case XFIRE_RECV_IM_ID:
	    	
			[self XfMobile_HandleIM:pBuffer MsgSize: dwMsgSize];
			
			break;
		case XFIRE_RECV_NICKNAMECHANGE_ID:
			
			break;
			
		case XFIRE_VERSION_MISMATCH_ID:
			
			
			NSLog(@"XFIRE_VERSION_MISMATCH_ID");
			
		    [self XfMobile_HandleMismatchVersion:pBuffer MsgSize:dwMsgSize];
			
		
			break;
	
			
	
		
		case XFIRE_FRIENDS_PLAYING_GAME:
			
			[self  XfMobile_HandlePlayingGame:pBuffer MsgSize:dwMsgSize];
			
			break;
		case 136:
			NSLog(@"list of friends of friends");
			
			break;
		case 144:
		
			NSLog(@"PONG PONG PONG KEEP ALIVE");
			break;
		case 145:	
		  
			
			[m_pLoginController OnLoggedInDifferentMachine];
		
			
			break;
			
		case XFIRE_CLAN_PACKET:
			
			 
			
			[self XfMobileHandle_Clans:pBuffer MsgSize:dwMsgSize];

			
			break;
		case XFIRE_CLAN_BUDDYS_NAMES_ID:
		
			
			[self XfMobileHandle_ClansNames:pBuffer MsgSize:dwMsgSize];

			break;
			

		case XFIRE_MESSAGE_OF_THEDAY:
		
			[self  XfMobile_HandleStatusMessage:pBuffer MsgSize:dwMsgSize];
			break;
			
			
			
			
			
	 default:
			
			
			break;
			
	}
	
	
	
	
}


- (void) handleTimer: (id) timer

{
	
 
			
	unsigned short MsgSize;
	unsigned char           *pData;
	char cFrom;
	char           cKey;
	uint32 iClientH;
	
	unsigned char            Data[DEF_MSGBUFFERSIZE];
	pData=Data;

	while([self bGetMsgQuene:&cFrom Data:pData Size:&MsgSize Index:&iClientH Key:&cKey]==TRUE){
		
		
			//NSLog(@"call to  bGetMsgQuene  %d" ,cFrom);
		if (cFrom==DEF_MSGFROM_XFIRESERVER) {
			
			
			
			[self ParseMessage:pData MsgSize:MsgSize];
			
		}
	
		memset(pData,0, DEF_MSGBUFFERSIZE);
		
	}
	
	
	
	
	
	
}


-(BOOL) bGetMsgQuene:(char*)pFrom Data:(unsigned char*)pData Size:(unsigned short*)szMsgSize Index:(uint32*)pIndex Key:(char*)pKey
{
	
	
	
	if (m_pMsgQuene[m_iQueneHead] == NULL)  {
	
		
		return FALSE;
		
	}

	[m_pMsgQuene[m_iQueneHead] bGet:pFrom Data:pData Size:szMsgSize Index:pIndex Key:pKey];
	
	
	//free( m_pMsgQuene[m_iQueneHead]);
	
	[m_pMsgQuene[m_iQueneHead] release];
	
	m_pMsgQuene[m_iQueneHead] = NULL;
	
	
	m_iQueneHead++;
	if (m_iQueneHead >= DEF_MSGQUENESIZE) m_iQueneHead = 0;
	
		
	return TRUE;
}



-(BOOL) bPutMsgQuene:(char)cFrom Data:(unsigned char*)pData Size:(unsigned short)szMsgSize Index:(uint32) iIndex Key:(char)cKey
{
	
	
	if (m_pMsgQuene[m_iQueneTail] != NULL)  {
		
		
		NSLog(@"ERROR bPutMsgQuene m_pMsgQuene[m_iQueneTail] != NULL");
		return FALSE;
		
	}
	
	m_pMsgQuene[m_iQueneTail]= [MsgQue alloc];           //(MsgQue*)malloc(sizeof(MsgQue));
	
	if (m_pMsgQuene[m_iQueneTail] == NULL) return FALSE;
	
	
	if ([m_pMsgQuene[m_iQueneTail] bPut:cFrom Data:pData Size:szMsgSize Index:iIndex Key:cKey]==FALSE) return FALSE;
		m_iQueneTail++;
	if (m_iQueneTail >= DEF_MSGQUENESIZE) m_iQueneTail = 0;
	

	return TRUE;
	
}



-(void) OnRead
{
	
	unsigned short dwMsgSize;
	unsigned char * pData;
	
	
	unsigned short * wp;
	
	
	wp = (unsigned short *)(m_pRcvBuffer + 0);

	
	dwMsgSize=*wp-2;
	
	pData=m_pRcvBuffer + 2;
	
	
 	if ([self bPutMsgQuene:5 Data:pData Size:dwMsgSize Index:0 Key:0]==FALSE){
	
		NSLog(@"######### CRITICAL ERROR in MsgQuene!!! ########");
	}
 

		
}

-(void)           Disconnect

{
	
	[coreSocket disconnect];
	
}

-(void) Login
{
	
	char uat[] = {
	0x55, 0x41, 0x30, 0x31 };
	
	char version[] = {
		0x12, 0x00, 0x03, 0x00, 0x01,
		0x07, 0x76, 0x65, 0x72, 0x73, 0x69, 0x6f,0x6e,  //version
		0x02, 0xCC, 0xCC,   //1.87
	0xCC, 0xCC };
	
	
	[self sendPacketMsg:uat length:sizeof(uat)];
	[self sendPacketMsg:version length:sizeof(version)];	
	[coreSocket readDataToLength:2 withTimeout:-1 tag:0];

	
}

-(void)sendPacketMsg:(const void *)bytes length:(NSUInteger)length
{
	
	#if defined(DEBUG_XFIRE)
	NSLog(@"Enter sendPacketMsg");
#endif
	
	NSData *pData=[[NSData alloc] initWithBytes:bytes length:length];
	[coreSocket writeData:pData withTimeout:-1 tag:0];
	
	[pData release];
	#if defined(DEBUG_XFIRE)
	NSLog(@"Leave sendPacketMsg");

#endif
	
}


- (void)Connect

{
	NSLog(@"XfireCore:Connect");	
	
	NSError *error = nil;
	if (![coreSocket isConnected]){
		[coreSocket connectToHost:@"cs.xfire.com" onPort:25999 error:&error]	;
	}else{
	
		NSLog(@"Already connected tring again...");
		[coreSocket disconnect];
		[coreSocket connectToHost:@"cs.xfire.com" onPort:25999 error:&error];
	}
	
	
}


- (void)onSocket:(AsyncSocket *)sock didAcceptNewSocket:(AsyncSocket *)newSocket
{


	NSLog(@"onSocket:didAcceptNewSocket");
	
}
//he socket sends this message when it is about to connect to a remote socket.
-(BOOL)onSocketWillConnect:(AsyncSocket *)sock

{

	
	NSLog(@"onSocketWillConnect");
	return TRUE;
}






//The socket sends this message when it is connected and ready for reading or writing.
- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
	

	[self Login];


}
//The sender sends this message when a write operation has successfully completed. It may send this message before the invoked write method returns, or later.
- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{

	
	
//	NSLog(@"didReadData");
	
	unsigned short *wp;
	
    if (m_cStatus == DEF_XSOCKSTATUS_READINGHEADER) {
	
		
		
	memcpy(m_pRcvBuffer+m_dwTotalReadSize,[data bytes],m_dwReadSize);
	

	m_dwReadSize      -= [data length];
	m_dwTotalReadSize += [data length];
		
	if (m_dwReadSize == 0) {
	
	    m_cStatus = DEF_XSOCKSTATUS_READINGBODY;
		wp = (unsigned short *)(m_pRcvBuffer + 0);
		
				
		
		m_dwReadSize = (uint32)(*wp - 2);
			
		
		if (m_dwReadSize == 0) {
			m_cStatus        = DEF_XSOCKSTATUS_READINGHEADER;
			m_dwReadSize      = 2;
			m_dwTotalReadSize = 0;
		
			
			[self OnRead];
			//return DEF_XSOCKEVENT_READCOMPLETE;
		}
		
		
		[coreSocket readDataToLength:m_dwReadSize withTimeout:-1 tag:0];
		return;

	
	}
	}
		
	
		
		if (m_cStatus == DEF_XSOCKSTATUS_READINGBODY) {
			

			memcpy(m_pRcvBuffer+m_dwTotalReadSize,[data bytes],m_dwReadSize);
			//NSLog(FORMAT(@"DEF_XSOCKSTATUS_READINGBODY: size =%08X",m_dwReadSize));
			m_dwReadSize      -= [data length];
			m_dwTotalReadSize += [data length];
		
				if (m_dwReadSize == 0) {
				m_cStatus        = DEF_XSOCKSTATUS_READINGHEADER;
				m_dwReadSize      = 2;
				m_dwTotalReadSize = 0;
				
				
				[self OnRead];
				////return DEF_XSOCKEVENT_READCOMPLETE;
			}
			[coreSocket readDataToLength:m_dwReadSize withTimeout:-1 tag:0];
			return;
		}
		

		
	
}
//The sender sends this message when a write operation has successfully completed. It may send this message before the invoked write method returns, or later.
- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
	

	
	

    NSLog(@"onSocket:didWriteDataWithTag");
	

	
	
}


//n the event of an error, the socket is disconnected. The socket sends this message before disconnection.
- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
	

	NSLog(@"onSocket:willDisconnectWithError");	
	
		
	m_bIsConnected=FALSE;
		
	
}


//The socket sends this message is called after it has disconnected.

- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
	NSLog(@"onSocket:onSocketDidDisconnect");

	
	m_bIsConnected=FALSE;
	[m_pLoginController OnDisconnect];

}
@end
