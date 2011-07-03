//
//  global.m
//  iXfire
//
//  Created by Moti Joseph on 4/25/09.
//  Copyright 2009 Gamepe. All rights reserved.
//  18 77 121

#import "global.h"
#import "XfireCore.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>

// states
#define S_h     (1)
#define S_t1    (2)
#define S_t2    (3)
#define S_p     (4)
#define S_s     (5)
#define S_col  (6)

// Lower-case alpha only.  tolower() will be used
// when searching for legal characters.
char *legal_chars =
"abcdefghijklmnopqrstuvwxyz0123456789"
"./\\~#%&()_-+=;?";


int _state;


char*  get_url(char *s) 

{
	char *p,*mark;
	
	static char url[4096];
	memset(url,0,sizeof(url));
	int i=0;
	_state=0;
	for(p=s;*p;p++) {
		switch(_state) {
			case 0:
				if(*p=='h') {
					_state=S_h;
					mark=p;
				}
				break;
			case S_h:
				if(*p=='t')
					_state=S_t1;
				else
					_state=0;
				break;
			case S_t1:
				if(*p=='t')
					_state=S_t2;
				else
					_state=0;
				break;
			case S_t2:
				if(*p=='p')
					_state=S_p;
				else
					_state=0;
				break;
			case S_p:
				if(*p==':')
					_state=S_col;
				else
					if(*p=='s')
						_state=S_s;
					else
						_state=0;
				break;
			case S_s:
				if(*p==':')
					_state=S_col;
				else
					_state=0;
				break;
			case S_col:
				if(strchr(legal_chars,tolower(*p))==NULL) {
					while(mark<p) {
						
						url[i++]=*mark;
						//fputc(*mark,stdout);
						mark++;
					}
				//	fputc('\n',stdout);
					_state=0;
					p--; // backtrack
				}
		}
	}
	if(_state) {
		while(mark<p) {
			url[i++]=*mark;
		//	fputc(*mark,stdout);
			mark++;
		}
	}
	
	return url;
}


//184063

NSUInteger    g_XfContactSeparatorColor=0xFFFFFFFF;
NSUInteger    g_XfNavBarBackgroundColor=0xFF12283f;
NSUInteger    g_XfContactSectionTextColor=0xFF8ABAFF;
NSUInteger    g_XfContactSectionBackgroundTextColor=0x144083;//0xFF8ABAFF;
NSUInteger    g_XfBackgroundColor=     0xFF12283f;   //184063
NSUInteger    g_XfContactsStatusTextColor=0xFF8ABAF1;
NSUInteger    g_XfContactsNameTextColor=0xFFFFFFFF;

char g_szLinkToAdImage[1024];
char g_szLinkToAd[1024];
char g_szTextAd[1024];

char g_ad_result[4096];

char           push_token_id[0x100]="<CCCCCCCC CCCCCCCC CCCCCCCC CCCCCCCC CCCCCCCC CCCCCCCC CCCCCCCC CCCCCCCC>";
int           g_myuserid;
XfireCore     *g_pXfireNetCore;
int            g_nXfireSearchedFriendCount;
XScreenShot    *g_xScreenShot;
int            g_xScreenShotCount;
int            g_idGamesCategory[50];
int            g_idGamesCategoryCunt;
int            g_nXfMobileSkin=0;
TXfireFriend   g_xfireSearchedFriends[0x80];
BOOL           g_bDisableAds=FALSE;
BOOL           g_bIsTokenSent=FALSE;
int            g_nTotalOnlineUsers=0;
BOOL           g_bIsDisableSignature=TRUE;
BOOL           g_bIsUsernamesVisible=0;
BOOL           g_bIsClansVisible=0;
BOOL           g_bIsShowOfflineFriends=FALSE;
BOOL           g_bIsPlayRecvIMSound=1;
char           g_cMyStatusMessage[0x100]="Xfire on the iPhone (XfMobile)";

 UIDeviceOrientation g_orientation=UIDeviceOrientationPortrait;


typedef struct TGame {
	
	unsigned int gameid;
	char name[70];
}TGame;

void MetricImpressionsNotificationThread()

{
	
	
	return;
	

	NSString  *url=[NSString  stringWithFormat:
					@	
					"http://met.adwhirl.com/exmet.php?appid=6c40182b6b7d4bc6973e57ae23995394&type=9&nid=b390f1f6a43945d8852c72f1a8fa0352&uuid=%@&country_code=en_US&appver=200&client=1"
					,
						[UIDevice currentDevice].uniqueIdentifier];
	
	
	NSURL *nsurl = [NSURL URLWithString:url];
	NSURLRequest *request = [NSURLRequest requestWithURL:nsurl];
	
	

	
	NSHTTPURLResponse *response;
	[NSURLConnection sendSynchronousRequest: request returningResponse: &response error: nil];
	
	NSLog(@"code=%d",[response  statusCode]);
	//Tue Mar 23 07:25:36 unknown XfMobile[624] <Warning>: 48537fbc10df86375b0d6379f61469a6b1385542
	
	if ([response  statusCode]==200){
		
		NSLog(@"MetricImpressionsNotificationThread was found");
	}else{
		
		NSLog(@"MetricImpressionsNotificationThread was not found");
		
	}
	
}



void MetricClickNotificationThread()

{
	
		

	
	NSString  *url=[NSString  stringWithFormat:
					@	
					"http://met.adwhirl.com/exclick.php?appid=6c40182b6b7d4bc6973e57ae23995394&type=9&nid=b390f1f6a43945d8852c72f1a8fa0352&uuid=%@&country_code=en_US&appver=200&client=1"
					,
					[UIDevice currentDevice].uniqueIdentifier];
	
	

	
	
	NSString* escapedUrl = [[NSString stringWithFormat:@"%@",url]   
							stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; 
	
	
	NSLog(escapedUrl);
	
	NSURL *nsurl = [NSURL URLWithString:escapedUrl];
	NSURLRequest *request = [NSURLRequest requestWithURL:nsurl];
	
	
	NSHTTPURLResponse *response;
	[NSURLConnection sendSynchronousRequest: request returningResponse: &response error: nil];
	
	NSLog(@"code=%d",[response  statusCode]);
	//Tue Mar 23 07:25:36 unknown XfMobile[624] <Warning>: 48537fbc10df86375b0d6379f61469a6b1385542
	
	if ([response  statusCode]==200){
		
		
		
		
		NSLog(@"MetricClickNotificationThread was sent");
	}else{
	
		NSLog(@"MetricClickNotificationThread was not sent");
		
	}
	
}

void    add_header(uint8 *Buffer,uint16 size,uint16 type ,uint8 attribute_count)
{
	
	
	memcpy(Buffer,&size,2);
	memcpy(Buffer+2,&type,2);
	Buffer[4]=attribute_count;
	
	
	
}




char* cryptPassword(char *pUserName,char *pPassword,unsigned char *pSalt)

{
	
	
	static  char cResult[0x200];
	char cCode[0x100];
	char temp[81];
	
	strcpy(cCode,pUserName);
	strcat(cCode,pPassword);
	strcat(cCode,"UltimateArena");
	
	hashSha1(cCode,strlen(cCode),cResult);
	
	
	memcpy(temp,cResult,40);
	memcpy(temp+40,pSalt,40);
	temp[80] = 0x00;
	hashSha1(temp,strlen(temp),cResult);
	return cResult;
	
}
uint32 read_attribute_noname(uint8 *Buffer,uint32 offset,uint32 type,uint8* data)
{
	
	uint32 subtype;
	
	unsigned char array_attribute_type;
	int array_attribute_len=0;

	
	switch(Buffer[offset])
	{
			
			//case CLANS_USERIDS_TYPE:
		case 0x2e:
		case 0x12:
		case 0x43:
		case 0x42:
		case 0x44:
		case 0x17:
		case 0x33:
		case 0x14:
		case 0x4E:
		case 0x49:
		case 0x4D:
		case 5:
		case 0xAA:
		case CLAN_REALNAME_TYPE:
		case 2:
		case CLANID_TYPE:
		case FILESIZE_TYPE:
		case 4:
		case VIDEO_TITLE:
		case 0x0D:
		case VIDEO_INDEX:
		case AVATAR_NUMBER:
		case AVATAR_TYPE:
		case 1:
		case 3:
			
			offset++;
			
			
			subtype=Buffer[offset];
			switch(subtype)
		{
				
			case ARRAY_TYPE:
				
				
				offset++;
				array_attribute_type=Buffer[offset];
				
				
				
				switch(array_attribute_type)
			{
					
				case STRING_TYPE:
					
					offset++;
					memcpy(&array_attribute_len,&Buffer[offset],2);
					offset+=2;
					
				{
					
					uint32 objects_count=array_attribute_len;
					
					
					uint16 total_strings_size=0;
					uint16 string_length=0;
					
					
					uint8 *start_buffer=&Buffer[offset];
					
					while(objects_count){
						
						memcpy(&string_length,&Buffer[offset]+total_strings_size,2);
						
						
						
						
						
						total_strings_size+=string_length+2;
						
						
						objects_count--;
					}
					
					
					
					if (data==NULL) return total_strings_size;
					
					if (total_strings_size) {
						
						memcpy(data,start_buffer,total_strings_size);
					}
					
					return total_strings_size+offset;
					
					
					
				}
					
				case  SID_TYPE:
					
					offset++;
					memcpy(&array_attribute_len,&Buffer[offset],2);
					offset+=2;
					if (data==NULL) return 16*array_attribute_len;
					memcpy(data,&Buffer[offset],16*array_attribute_len);
					offset+=16*array_attribute_len;
					
					return offset;
					
					
					
					
				case INT_TYPE:
					
					offset++;
					memcpy(&array_attribute_len,&Buffer[offset],2);
					offset+=2;
					if (data==NULL) return 4*array_attribute_len;
					
					memcpy(data,&Buffer[offset],4*array_attribute_len);
					
					offset+=4*array_attribute_len;
					
					return offset;
					
				default:
					
					NSLog(@"	errrrroorr");
					break;
			}
				
				
				break;
				
				
			case GSID_TYPE:
				offset++;
				memcpy(data,&Buffer[offset],21);
				offset+=21;
				return offset;
			case INT_TYPE:
				
				offset++;
				memcpy(data,&Buffer[offset],4);
				offset+=4;
				return offset;
				
			case STRING_TYPE:
				
			{
				
				offset++;
				uint32 string_length=0;
				memcpy(&string_length,&Buffer[offset],2);
				if (data==NULL) return 2+string_length;
				
				memcpy(data,&Buffer[offset],2+string_length);
				
				offset+=2+string_length;
				return  offset;
				
				
				
			}
				
				
			default:
				
				return -1;
				
		}
			
			
			
			break;
			
		default:
			break;
			
	}
	
	return -1;
}



uint32 read_attribute(uint8 *Buffer,uint32 offset,char *name,uint32 type,uint8* data)
{
	
	
	uint32 attb_len=strlen(name);
	if (Buffer[offset]!=attb_len || memcmp(&Buffer[offset+1],name,attb_len)!=0) return -1;
	
	offset++;
	offset+=attb_len;
	
	if (Buffer[offset]!=type) return -1;
	
	offset++;
	
	unsigned char array_attribute_type;
	int array_attribute_len=0;
    int string_len=0;
	
	switch(type)
	{
			
		case ARRAY_TYPE:
			
			
			array_attribute_type=Buffer[offset];
			offset++;
			switch(array_attribute_type)
		{
				
			case STRING_TYPE:
				
				memcpy(&array_attribute_len,&Buffer[offset],2);
				offset+=2;
				
			{
				
				uint32 objects_count=array_attribute_len;
				
				
				uint16 total_strings_size=0;
				uint16 string_length=0;
				
				
                uint8 *start_buffer=&Buffer[offset];
				while(objects_count){
					
					memcpy(&string_length,&Buffer[offset],2);
					
					offset+=string_length+2;
					
					
					total_strings_size+=string_length+2;
					
					
					objects_count--;
				}
				
				
				
				
				if (data==NULL) return total_strings_size;
				if (total_strings_size)
					memcpy(data,start_buffer,total_strings_size);
				
				break;
				
			}
				
				
				
				break;
				
			case INT_TYPE:
				memcpy(&array_attribute_len,&Buffer[offset],2);
				offset+=2;
				if (data==NULL) return 4*array_attribute_len;
				
				memcpy(data,&Buffer[offset],4*array_attribute_len);
				
				offset+=4*array_attribute_len;
				
				break;
				
				
			case  SID_TYPE:
				
				memcpy(&array_attribute_len,&Buffer[offset],2);
				offset+=2;
				if (data==NULL) return 16*array_attribute_len;
				memcpy(data,&Buffer[offset],16*array_attribute_len);
				offset+=16*array_attribute_len;
				
				break;
				
				
				
			default:
				break;
		}
			
			
			break;
			
		case STRING_TYPE:
			
			memcpy(&string_len,&Buffer[offset],2);
			
			if (data==NULL) return string_len+2;
			memcpy(data,&Buffer[offset],string_len+2);
			offset+=string_len+2;
			
			
			break;
			
		case GSID_TYPE:
			
			memcpy(data,&Buffer[offset],21);
			offset+=21;
			break;
			
		case SID_TYPE:
			
			memcpy(data,&Buffer[offset],16);
			offset+=16;
			break;
			
		case INT_TYPE:
			
			memcpy(data,&Buffer[offset],4);
			offset+=4;
			
			
			break;
		case CHILDS_TYPE:
			*data=Buffer[offset];
			offset+=1;
			
			break;
			
		default:
			offset=-1;
			break;
	}
	return offset;
	
}

uint32   write_array_attribute(uint8 *Buffer,uint32 offset,char *name,uint32 type,uint8* data,uint16 datalen)
{
	
	
	Buffer[offset]=strlen((char*)name);
	offset++;
	
	memcpy(&Buffer[offset],name,Buffer[offset-1]);
	
	offset+=strlen((char*)name);
	
	
	Buffer[offset++]=ARRAY_TYPE;
	
	switch(type){
			
		case INT_TYPE:
			
			Buffer[offset]=INT_TYPE;
			offset++;
			
			memcpy(&Buffer[offset],&datalen,0);
			
			offset+=2;
			
			memcpy(&Buffer[offset],data,datalen);
			
			offset+=datalen;
			
			return offset;
			
		case STRING_TYPE: 
			
			Buffer[offset]=STRING_TYPE;
			offset++;
			
			memcpy(&Buffer[offset],&datalen,0);
			
			offset+=2;
			
			memcpy(&Buffer[offset],data,datalen);
			
			offset+=datalen;
			
		default:
			
			break;
			
	}
	
	
	return -1;
	
}

uint32   write_attribute(uint8 *Buffer,uint32 offset,char *name,uint32 type,uint8* data)
{
	
	
	Buffer[offset]=strlen((char*)name);
	offset++;
	
	memcpy(&Buffer[offset],name,Buffer[offset-1]);
	
	offset+=strlen((char*)name);
	
	uint16 string_length;
	
	switch(type)
	{
			
		case 9:
			
			Buffer[offset]=9;
			offset++;
			memcpy(&Buffer[offset],data,1);
			offset++;
			
			return offset;
			
			
		case GSID_TYPE:
			
			Buffer[offset]=GSID_TYPE;
			offset++;
			memcpy(&Buffer[offset],data,21);
			offset++;
			
			return offset;
			
			
			break;
		case CHILDS_TYPE:
			
			Buffer[offset]=CHILDS_TYPE;
			offset++;
			memcpy(&Buffer[offset],data,1);
			offset++;
			
			return offset;
			
			break;
		case SID_TYPE:
			
			Buffer[offset]=SID_TYPE;
			offset++;
			
			memcpy(&Buffer[offset],data,16);
			offset+=16;
			return offset;
			
		case INT_TYPE:
			
			Buffer[offset]=INT_TYPE;
			offset++;
			
			memcpy(&Buffer[offset],data,4);
			offset+=4;
			return offset;
			
		case STRING_TYPE:
			
			Buffer[offset]=STRING_TYPE;
			offset++;
			
			string_length=strlen((char*)data);
			memcpy(&Buffer[offset],&string_length,2);
			offset+=2;
			
			memcpy(&Buffer[offset],(uint8*)data,string_length);
			
			offset+=string_length;
			return offset;
			
		default:
			
			break;
	}
	
	
	
	
	
	return -1;
	
}



uint32   write_array_attribute_noname(uint8 *Buffer,uint32 offset,uint32 type,uint8* data,uint16 datalen)
{
	
	
	
	Buffer[offset++]=ARRAY_TYPE;
	
	switch(type){
			
		case INT_TYPE:
			
			Buffer[offset]=INT_TYPE;
			offset++;
			
			memcpy(&Buffer[offset],&datalen,0);
			
			offset+=2;
			
			memcpy(&Buffer[offset],data,datalen);
			
			offset+=datalen;
			
			return offset;
			
		case STRING_TYPE: 
			
			Buffer[offset]=STRING_TYPE;
			offset++;
			
			memcpy(&Buffer[offset],&datalen,0);
			
			offset+=2;
			
			memcpy(&Buffer[offset],data,datalen);
			
			offset+=datalen;
			
		default:
			
			break;
			
	}
	
	
	return -1;
	
}

uint32  write_attribute_noname(uint8 *Buffer,uint32 offset,uint32 type,uint8* data)

{
	
	Buffer[offset]=type;
	
	uint16 string_length=0;
	switch (type)
	{
	
		case 0x11:
			
			offset++;
			Buffer[offset]=3;
			offset++;
			memcpy(&Buffer[offset],data,16);
			offset+=16;
			return offset;
			
			
			break;
		
		case 0xA7:
			
			offset++;
			Buffer[offset]=0x08;
			offset++;
			
			Buffer[offset]=*data;
			offset+=1;
			
			return offset;
		
		case 0x47:
		case 1:	
		case 0xAA:
		case 0x0B:
			
			offset++;
			Buffer[offset]=INT_TYPE;
			offset++;
			
			memcpy(&Buffer[offset],data,4);
			offset+=4;
			
			return offset;
			
		case 4:
			
			offset++;
			Buffer[offset]=6;
			offset++;
			memcpy(&Buffer[offset],data,21);
			offset+=21;
			return offset;
			
			break;
			
		case 5:
		case 0x5F:
		case 0x2E:
			
			offset++;
			Buffer[offset]=STRING_TYPE;
			offset++;
			string_length=strlen((char*)data);
			memcpy(&Buffer[offset],&string_length,2);
			offset+=2;
			
			memcpy(&Buffer[offset],data,string_length);
			
			offset+=string_length;
			
			return offset;
			
			
			break;
			
		default:
			break;
	}
	
	return -1;
	
	
}

void dumpbuffer(char *pBuffer,unsigned short size)
{
	
	
	char cMsg[32];
	
	char output[8096*4]={0};
	
	for (int i=0; i<size; i++){
		
		
		sprintf(cMsg,"%02x ",(unsigned char)pBuffer[i]);
		if (i%16 ==0){
			
			strcat(output,"\n");
		}
		
		strcat(output,cMsg);
		
		
	}
	
	
	NSLog(@"%s",output);
	
	
	
	
	
}


TGame  g_gameslist[]={
{2,"America's Army: Special Forces"} ,
{3,"Unreal Tournament"} ,
{4,"Unreal Tournament 2003"} ,
{5,"Counter-Strike 1.6"} ,
{32,"TeamSpeak"} ,
{33,"Ventrilo"} ,
{34,"Mumble"} ,
{4096,"The Temple of Elemental Evil"} ,
{4097,"Wolfenstein: Enemy Territory"} ,
{4098,"Dark Age of Camelot"} ,
{4099,"Dark Age of Camelot - Shrouded Isles"} ,
{4100,"Dungeon Siege"} ,
{4284,"StarCraft Brood War"} ,
{4101,"StarCraft"} ,
{4285,"Diablo II - Lord of Destruction"} ,
{4102,"Diablo II"} ,
{4103,"XEvil"} ,
{4104,"Meridian 59"} ,
{4105,"Battlefield 1942"} ,
{4106,"Everquest"} ,
{4107,"Halo"} ,
{4108,"Neverwinter Nights"} ,
{4109,"Star Wars Galaxies: An Empire Divided"} ,
{4110,"PlanetSide"} ,
{4111,"Quake III Arena"} ,
{4112,"Warcraft III"} ,
{4113,"Lineage"} ,
{4114,"Medal of Honor Allied Assault"} ,
{4115,"Diablo"} ,
{4116,"Quake II"} ,
{4117,"Legends of Mir II"} ,
{4118,"Final Fantasy XI Online"} ,
{4119,"Call of Duty Single Player"} ,
{4120,"Call of Duty Multiplayer"} ,
{4121,"Star Wars Knights of the Old Republic"} ,
{4122,"Need For Speed: Underground"} ,
{4123,"RollerCoaster Tycoon 2"} ,
{4124,"Age of Empires II"} ,
{4125,"Savage: The Battle for Newerth"} ,
{4126,"Civilization III"} ,
{4127,"SimCity 4"} ,
{4128,"C&C Red Alert 2"} ,
{4129,"C&C Generals"} ,
{4130,"Gunbound"} ,
{4131,"Fallout Tactics"} ,
{4132,"Age of Wonders: Shadow Magic"} ,
{4133,"Warlords IV: Heroes of Etheria"} ,
{4134,"PartyPoker.com"} ,
{4135,"Rise of Nations"} ,
{4136,"Tribes 2"} ,
{4137,"Unreal II XMP"} ,
{4138,"Unreal II: The Awakening SP"} ,
{4139,"Age of Mythology"} ,
{4140,"Age of Mythology - The Titans Expansion"} ,
{4141,"Raven Shield"} ,
{4142,"Madden NFL 2004"} ,
{4143,"Tiger Woods PGA Tour 2004"} ,
{4144,"Civilization III Conquests"} ,
{4145,"Civilization III Play the World"} ,
{4146,"FIFA 2003"} ,
{4147,"Spider Solitaire"} ,
{4148,"Solitaire"} ,
{4149,"Minesweeper"} ,
{4150,"Medal of Honor Allied Assault - Breakthrough"} ,
{4151,"Soldier of Fortune II Multiplayer"} ,
{4152,"Medal of Honor Allied Assault - Spearhead"} ,
{4153,"Soldier of Fortune II Single Player"} ,
{4154,"Ghost Recon"} ,
{4155,"Delta Force Black Hawk Down"} ,
{4156,"C&C Generals - Zero Hour"} ,
{4157,"Star Wars Jedi Knight: Jedi Academy Single Player"} ,
{4158,"Star Wars Jedi Knight: Jedi Academy Multiplayer"} ,
{4159,"Silent Storm"} ,
{4160,"Jedi Knight II Multiplayer"} ,
{4161,"Jedi Knight II Single Player"} ,
{4162,"Unreal Tournament 2004 Demo"} ,
{4163,"Savage: The Battle for Newerth DEMO 2.0"} ,
{4164,"Natural Selection"} ,
{4165,"Day of Defeat 1.3"} ,
{4166,"Deathmatch Classic (Steam)"} ,
{4167,"Half-Life (Steam)"} ,
{4168,"Opposing Force (Steam)"} ,
{4169,"Ricochet (Steam)"} ,
{4170,"Team Fortress Classic (Steam)"} ,
{4171,"Vietcong"} ,
{4172,"Aliens vs. Predator 2"} ,
{4173,"Return to Castle Wolfenstein Single Player"} ,
{4174,"Return to Castle Wolfenstein Multiplayer"} ,
{4175,"Dark Age of Camelot - Trials of Atlantis"} ,
{4176,"Tron 2.0"} ,
{4177,"Red Faction II"} ,
{4178,"C&C Renegade"} ,
{4179,"Second Life"} ,
{4180,"Far Cry"} ,
{4181,"Unreal Tournament 2004"} ,
{4182,"Battlefield Vietnam"} ,
{4183,"Soldat"} ,
{4184,"Combat Flight Simulator 3"} ,
{4185,"Midnight Club 2"} ,
{4186,"Counter-Strike 1.5"} ,
{4187,"Counter-Strike: Condition Zero"} ,
{4188,"Carom 3D"} ,
{4189,"The Specialists"} ,
{4190,"Star Trek Elite Force II"} ,
{4191,"NetGammon"} ,
{4192,"Empire Earth"} ,
{4193,"Condition Zero: Deleted Scenes"} ,
{4194,"Splinter Cell Pandora Tomorrow Single Player"} ,
{4195,"Splinter Cell Pandora Tomorrow Multiplayer"} ,
{4196,"Chrome MP Demo 2004"} ,
{4197,"Ragnarok Online"} ,
{4198,"Breed"} ,
{4393,"Painkiller Battle out of Hell"} ,
{4199,"Painkiller"} ,
{4200,"Chrome"} ,
{4201,"Lock On"} ,
{4202,"Sacred"} ,
{4203,"Tactical Ops"} ,
{4204,"Starsiege Tribes"} ,
{4205,"NASCAR Racing 3"} ,
{4206,"NASCAR Racing 4"} ,
{4207,"NASCAR Racing 2003 Season"} ,
{4208,"Star Trek Voyager: Elite Force Multiplayer"} ,
{4209,"Star Trek Armada"} ,
{4210,"Universal Combat Single Player"} ,
{4211,"Universal Combat Multiplayer"} ,
{4212,"Operation Flashpoint"} ,
{4213,"Operation Flashpoint Resistance"} ,
{4214,"IL-2 Sturmovik Collection"} ,
{4215,"Lineage II"} ,
{4216,"World of Warcraft"} ,
{4217,"City of Heroes"} ,
{4218,"Rise of Nations - Thrones & Patriots"} ,
{4219,"Manhunt"} ,
{4220,"Hitman 2 - Silent Assassin"} ,
{4221,"Hitman Contracts"} ,
{4222,"Iron Storm"} ,
{4223,"Rogue Spear"} ,
{4224,"Rogue Spear - Urban Operations"} ,
{4225,"Star Trek Voyager: Elite Force Single Player"} ,
{4226,"Asheron's Call 2"} ,
{4227,"Legends of Mir III"} ,
{4228,"JX Online"} ,
{4229,"Karma Online"} ,
{4230,"Legends of Mir"} ,
{4231,"Mu Online"} ,
{4232,"Prince of Qin Online"} ,
{4233,"The World of Legend"} ,
{4234,"Soldner Beta Demo"} ,
{4235,"GLQuake"} ,
{4236,"QuakeWorld"} ,
{4237,"There"} ,
{4238,"Red Faction"} ,
{4239,"Halo Custom Edition"} ,
{4240,"Freelancer"} ,
{4241,"Deus Ex"} ,
{4242,"True Crime - Streets of LA"} ,
{4243,"The Saga of Ryzom"} ,
{4244,"Shadowbane"} ,
{4245,"MechWarrior 4 Vengeance"} ,
{4246,"MechWarrior Mercenaries"} ,
{4247,"Serious Sam - The Second Encounter"} ,
{4248,"Joint Operations: Typhoon Rising"} ,
{4249,"Thief - Deadly Shadows"} ,
{4250,"Rune"} ,
{4251,"GetAmped"} ,
{4252,"Mabinogi"} ,
{4253,"Priston Tale"} ,
{4254,"Istaria: Chronicles of the Gifted"} ,
{4255,"Ultima Online"} ,
{4256,"Hidden & Dangerous"} ,
{4257,"Hidden & Dangerous 2"} ,
{4258,"C&C Yuri's Revenge"} ,
{4259,"Empires Dawn of the Modern World"} ,
{4260,"Medieval - Total War"} ,
{4261,"Soldner - Secret Wars"} ,
{4262,"A3"} ,
{4263,"John Deere American Farmer"} ,
{4264,"MapleStory"} ,
{4265,"GunZ: The Duel"} ,
{4266,"Grand Theft Auto III"} ,
{4267,"Grand Theft Auto: Vice City"} ,
{4268,"MameUI"} ,
{4269,"Tony Hawk's Pro Skater 3"} ,
{4270,"Warcraft III - The Frozen Throne"} ,
{4271,"Doom 3"} ,
{4272,"Tony Hawk's Pro Skater 4"} ,
{4273,"Toca Race Driver 2"} ,
{4274,"Vietcong Fist Alpha"} ,
{4275,"Rainbow Six 3 - Athena Sword"} ,
{4276,"Half-Life 1.5"} ,
{4277,"Day of Defeat 1.5"} ,
{4278,"Team Fortress Classic 1.5"} ,
{4279,"Opposing Force 1.5"} ,
{4280,"Deathmatch Classic 1.5"} ,
{4281,"Ricochet 1.5"} ,
{4282,"Red Orchestra"} ,
{4283,"Ground Control II"} ,
{4286,"Take-Out Weight Curling"} ,
{4287,"Take-Out Weight Curling 2"} ,
{4288,"Delta Force"} ,
{4289,"Delta Force 2"} ,
{4290,"XIII"} ,
{4291,"SpellForce - The Order of Dawn"} ,
{4292,"Gore - Ultimate Soldier"} ,
{4293,"The Sims"} ,
{4294,"Max Payne 2"} ,
{4295,"Codename Gordon"} ,
{4296,"Earth's Special Forces"} ,
{4297,"Digital Paintball"} ,
{4298,"Firearms"} ,
{4299,"Sven Co-op"} ,
{4300,"Warhammer 40,000 Dawn of War Beta"} ,
{4301,"Frag Ops"} ,
{4302,"Troopers: Dawn of Destiny"} ,
{4303,"Counter-Strike: Source (Beta)"} ,
{4304,"Medal of Honor Pacific Assault"} ,
{4305,"No One Lives Forever 2"} ,
{4306,"4x4 Evolution"} ,
{4307,"Max Payne"} ,
{4308,"SimCity 3000 Unlimited"} ,
{4309,"The Lord of the Rings - The Battle for Middle-Earth"} ,
{4310,"Call of Duty United Offensive Single Player"} ,
{4311,"Call of Duty United Offensive Multiplayer"} ,
{4312,"The Elder Scrolls III: Morrowind"} ,
{4313,"Warlords Battlecry III"} ,
{4314,"Colin Mcrae Rally 04"} ,
{4315,"MotoGP 2"} ,
{4316,"Unreal"} ,
{4317,"Nox"} ,
{4318,"Total Annihilation Kingdoms"} ,
{4319,"Tribes Vengeance Multiplayer Demo"} ,
{4320,"Eve Online"} ,
{4321,"EverQuest II Beta"} ,
{4322,"The Sims 2"} ,
{4323,"Star Wars Battlefront"} ,
{4324,"Dawn of War"} ,
{4325,"Rome: Total War"} ,
{4326,"Call of Duty United Offensive Single Player Demo"} ,
{4327,"Anarchy Online"} ,
{4328,"Full Spectrum Warrior"} ,
{4329,"Kohan II Kings of War"} ,
{4330,"Tribes Vengeance"} ,
{4331,"Counter-Strike: Source"} ,
{4332,"Star Wars Galaxies - The Jump to Lightspeed Beta"} ,
{4333,"Gotcha!"} ,
{4334,"Leisure Suit Larry - Magna Cum Laude"} ,
{4335,"Stepmania CVS"} ,
{4336,"Trackmania"} ,
{4337,"Tony Hawk's Underground 2"} ,
{4338,"Dawn of War Demo"} ,
{4339,"Men of Valor MP Demo"} ,
{4340,"Madden NFL 2005"} ,
{4341,"Tiger Woods PGA Tour 2005"} ,
{4342,"NHL 2005"} ,
{4343,"Evil Genius"} ,
{4621,"RollerCoaster Tycoon 3 Soaked"} ,
{4693,"RollerCoaster Tycoon 3 Wild"} ,
{4344,"RollerCoaster Tycoon 3"} ,
{4345,"Guild Wars"} ,
{4346,"Medal of Honor Pacific Assault MP Demo"} ,
{4347,"Axis & Allies"} ,
{4348,"The Simpsons Hit & Run"} ,
{4349,"ShellShock Nam67"} ,
{4350,"Deus Ex Invisible War"} ,
{4351,"Kingpin Life of Crime"} ,
{4352,"EverQuest II"} ,
{4353,"Need for Speed: Underground 2"} ,
{4354,"FIFA Soccer 2005"} ,
{4355,"NBA Live 2005"} ,
{4356,"Flight Simulator 2004"} ,
{4357,"Half-Life 2"} ,
{4358,"Half-Life: Source"} ,
{4359,"Sid Meier's Pirates!"} ,
{4360,"Joint Operations: Escalation"} ,
{4361,"Hidden & Dangerous 2 Sabre Squadron"} ,
{4362,"Vampire - The Masquerade Bloodlines"} ,
{4363,"Half-Life 2: Deathmatch"} ,
{5670,"Zoo Tycoon 2: Ultimate Collection"} ,
{5457,"Zoo Tycoon 2: Extinct Animals"} ,
{4933,"Zoo Tycoon 2: Marine Mania"} ,
{4839,"Zoo Tycoon 2 African Adventure"} ,
{4704,"Zoo Tycoon 2: Endangered Species"} ,
{4364,"Zoo Tycoon 2"} ,
{4365,"Prince of Persia Warrior Within"} ,
{4366,"Men of Valor"} ,
{4367,"Worms 3D"} ,
{4368,"The Chronicles of Riddick: Escape from Butcher Bay"} ,
{4369,"System Shock 2"} ,
{4370,"Armed and Dangerous"} ,
{4371,"Armies of Exigo"} ,
{4372,"Codename: Panzers, Phase 1"} ,
{4373,"Dungeon Siege Legends of Aranna"} ,
{4374,"SAS Into the Lion's Den"} ,
{4375,"Action Unreal Tournament 2004"} ,
{4376,"Age of Empires II: The Conquerors Expansion"} ,
{4377,"Kill.Switch"} ,
{4378,"Soldier of Fortune"} ,
{4379,"Risk Your Life"} ,
{4380,"Jedi Knight"} ,
{4381,"No One Lives Forever"} ,
{4636,"C&C Tiberian Sun Firestorm"} ,
{4382,"C&C Tiberian Sun"} ,
{4383,"Knight Online"} ,
{4384,"Star Wars Galactic Battlegrounds"} ,
{4385,"Star Wars Galactic Battlegrounds - Clone Campaigns"} ,
{4386,"Star Wars Knights of the Old Republic II: The Sith Lords"} ,
{4387,"Armies of Exigo Single Player Demo"} ,
{4388,"Homeworld"} ,
{4389,"Homeworld 2"} ,
{4390,"Warcraft II"} ,
{4391,"Wulfram 2"} ,
{4392,"ProQuake"} ,
{4394,"R.O.S.E. Online Evolution"} ,
{4395,"Dark Age of Camelot - Catacombs"} ,
{4396,"Splinter Cell Chaos Theory Versus Beta"} ,
{4397,"Worms Armageddon"} ,
{4398,"Battlefield 2 Demo"} ,
{4399,"Star Wars Republic Commando Demo"} ,
{4400,"The Punisher"} ,
{4401,"Postal 2 Share the Pain"} ,
{4402,"SWAT 4 MP Beta"} ,
{4403,"Winning Eleven 7 INTERNATIONAL"} ,
{4404,"The Settlers: Heritage of Kings Demo"} ,
{4405,"City of Heroes EU"} ,
{4406,"Hearts of Iron II"} ,
{4407,"R.Y.L. Path of the Emperor"} ,
{4408,"Splinter Cell Chaos Theory Single Player Demo"} ,
{4409,"4x4 Evo2"} ,
{4410,"Star Wars Republic Commando"} ,
{4411,"The Sims 2 University"} ,
{4412,"Freedom Force vs The 3rd Reich"} ,
{4413,"Black & White"} ,
{4414,"The Matrix Online"} ,
{4415,"NASCAR SimRacing"} ,
{4416,"Brothers in Arms"} ,
{4417,"FlatOut"} ,
{4418,"Silent Hunter III"} ,
{4419,"Nexus - The Jupiter Incident"} ,
{4420,"Act of War: Direct Action"} ,
{4421,"Prince of Persia - The Sands of Time"} ,
{4422,"Colin Mcrae Rally 05"} ,
{4423,"Playboy - The Mansion"} ,
{4424,"Splinter Cell Chaos Theory Single Player"} ,
{4425,"Splinter Cell Chaos Theory Multiplayer"} ,
{4426,"Giants: Citizen Kabuto"} ,
{4427,"Icewind Dale"} ,
{4428,"Icewind Dale - Heart of Winter"} ,
{4429,"Doom 3 Resurrection of Evil"} ,
{4430,"Darwinia Demo"} ,
{4431,"Darwinia"} ,
{4432,"SWAT 4"} ,
{4433,"Worms World Party"} ,
{4434,"Driv3r"} ,
{4435,"Gaming Club Poker"} ,
{4436,"Winning Eleven 8"} ,
{4437,"Tropico"} ,
{4438,"Tropico 2 Pirate Cove"} ,
{4439,"Kal Online"} ,
{4440,"Project Snowblind Single Player"} ,
{4441,"Splinter Cell"} ,
{4442,"Grand Theft Auto 2"} ,
{4443,"Caesar 3"} ,
{4444,"Pharaoh"} ,
{4445,"Lego Star Wars"} ,
{4446,"Close Combat First to Fight"} ,
{4447,"Empire Earth II"} ,
{4448,"Stronghold 2"} ,
{4449,"The Settlers: Heritage of Kings"} ,
{4450,"Delta Force Xtreme"} ,
{4451,"StillLife"} ,
{4452,"Dungeon Siege II Demo"} ,
{4553,"Psychonauts"} ,
{4554,"GTR"} ,
{4555,"Pariah"} ,
{4556,"Psychotoxic"} ,
{4557,"Immortal Cities: Children of The Nile"} ,
{4558,"Championship Manager 5"} ,
{4559,"Football Manager 2005"} ,
{4560,"Total Club Manager 2005"} ,
{4561,"Soldiers - Heroes of World War II"} ,
{4562,"Plan of Attack"} ,
{4563,"Total Annihilation"} ,
{4564,"Pro Evolution Soccer 4"} ,
{4565,"Age of Empires"} ,
{4566,"Trackmania Sunrise"} ,
{4567,"PokerStars.com"} ,
{4568,"PokerRoom.com"} ,
{4569,"EmpirePoker.com"} ,
{4570,"TruePoker.com"} ,
{4571,"Project Snowblind Multiplayer"} ,
{5731,"Grand Theft Auto: San Andreas Multiplayer"} ,
{4572,"Grand Theft Auto: San Andreas"} ,
{4573,"Cossacks II"} ,
{4574,"Serious Sam"} ,
{4575,"Universal Combat AWA Single Player"} ,
{4576,"Universal Combat AWA Multiplayer"} ,
{4577,"Imperial Glory"} ,
{4578,"Battlefield 2"} ,
{4579,"18 Wheels of Steel Pedal to the Metal"} ,
{4580,"Area 51"} ,
{4581,"Universal Combat Gold Single Player"} ,
{4582,"Universal Combat Gold Multiplayer"} ,
{4583,"Mojo Master"} ,
{4584,"Juiced"} ,
{4585,"Zoo Tycoon"} ,
{4586,"Need for Speed II SE"} ,
{4587,"Need for Speed: High Stakes"} ,
{4588,"Need for Speed III: Hot Pursuit"} ,
{4589,"Need for Speed: Porsche Unleashed"} ,
{4590,"Need for Speed: Hot Pursuit 2"} ,
{4591,"Half-Life 2: Capture the Flag"} ,
{4592,"Half-Life 2: Substance"} ,
{4593,"Garry's Mod"} ,
{4594,"CounterStrike 2D"} ,
{4595,"Continuum"} ,
{4596,"Mafia"} ,
{4597,"Cold Fear"} ,
{4598,"COR"} ,
{4599,"Silent Hill 2"} ,
{4600,"Silent Hill 3"} ,
{4601,"Silent Hill 4"} ,
{4602,"Baldur's Gate"} ,
{4603,"X-Wing vs. TIE Fighter"} ,
{4604,"Stronghold"} ,
{4605,"Stronghold Crusader"} ,
{4606,"Gothic II"} ,
{4607,"The Sims Online"} ,
{4608,"Magic Online"} ,
{4609,"Thief"} ,
{4610,"Thief 2 The Metal Age"} ,
{4611,"Live for Speed"} ,
{4612,"Spartan"} ,
{4613,"Gates of Troy"} ,
{4614,"Age of Empires: The Rise of Rome"} ,
{4615,"Sudden Strike II"} ,
{4616,"Scrapland"} ,
{4617,"Mortyr 2"} ,
{4618,"Homeworld Cataclysm"} ,
{4619,"Fate"} ,
{4620,"Dungeon Siege II"} ,
{4622,"Blue Shift"} ,
{4623,"Control Monger"} ,
{4624,"FEAR SP Demo"} ,
{4625,"Madden NFL 2006"} ,
{4626,"The Bard's Tale"} ,
{4627,"Half-Life: Blue Shift (Steam)"} ,
{4628,"Legion Arena"} ,
{4629,"NTE"} ,
{4630,"Grim Fandango"} ,
{4631,"1602 A.D."} ,
{4632,"Conquer Online"} ,
{4633,"Age of Empires III Trial"} ,
{4634,"Dystopia"} ,
{4635,"Toontown Online"} ,
{4637,"Serious Sam 2 Demo"} ,
{4638,"Fallout"} ,
{4639,"Fallout 2"} ,
{4640,"Superpower 2"} ,
{4641,"Enter the Matrix"} ,
{4642,"Rollercoaster Tycoon"} ,
{4643,"Railroad Tycoon 3"} ,
{4644,"Codename: Panzers, Phase 2"} ,
{4645,"Blitzkrieg"} ,
{4646,"NHL 06"} ,
{4647,"MVP Baseball 2005"} ,
{4648,"Fable - The Lost Chapters"} ,
{4649,"Dawn of War Winter Assault"} ,
{4650,"Beats of Rage"} ,
{4651,"Tiger Woods PGA Tour 06"} ,
{4652,"The Sims 2 Nightlife"} ,
{4653,"Day of Defeat: Source"} ,
{4654,"Sacred Underworld"} ,
{4655,"Star Wars Battlefront II"} ,
{4656,"Call of Duty 2 Single Player Demo"} ,
{4657,"Brothers in Arms EIB Demo"} ,
{4658,"FEAR Multiplayer Demo"} ,
{4659,"Rome: Total War: Barbarian Invasion"} ,
{4660,"Dragonshard"} ,
{4661,"Brothers in Arms EIB"} ,
{4662,"Serious Sam 2"} ,
{4663,"Black & White 2"} ,
{4664,"FIFA Soccer 06"} ,
{4665,"NBA Live 06"} ,
{4666,"Rag Doll Kung Fu"} ,
{4667,"FEAR Single Player"} ,
{4668,"MotoGP URT 3"} ,
{4669,"Ultimate Spider-Man"} ,
{4670,"X-Men Legends 2"} ,
{4671,"Blitzkrieg 2"} ,
{4672,"18 Wheels of Steel Convoy"} ,
{4673,"Gangland"} ,
{4674,"Risk II"} ,
{4675,"Bet on Soldier"} ,
{4676,"Descent FreeSpace"} ,
{4677,"Prison Tycoon"} ,
{4678,"Quake 4"} ,
{4679,"Age of Empires III"} ,
{4680,"Richard Burns Rally"} ,
{4681,"Indigo Prophecy"} ,
{4682,"Vietcong 2"} ,
{4683,"Call of Duty 2 Single Player"} ,
{4684,"Call of Duty 2 Multiplayer"} ,
{4685,"Civilization IV"} ,
{4686,"LOTR Return of the King"} ,
{4687,"City of Villains"} ,
{4688,"Heroes of the Pacific"} ,
{4689,"Fahrenheit"} ,
{4690,"City of Villains EU"} ,
{4691,"Shattered Union"} ,
{4692,"X2 - The Threat"} ,
{4694,"Half-Life 2: Lost Coast"} ,
{4695,"Gun"} ,
{4696,"The Movies"} ,
{4697,"The Matrix - The Path of Neo"} ,
{4698,"Contract JACK"} ,
{4699,"BloodRayne"} ,
{4700,"BloodRayne 2"} ,
{4701,"Sourceforts"} ,
{4702,"Need for Speed: Most Wanted"} ,
{4703,"John Deere North American Farmer"} ,
{4705,"Worms 4 Mayhem"} ,
{4706,"Earth 2160"} ,
{4707,"Sniper Elite"} ,
{4708,"Peter Jackson's King Kong"} ,
{4709,"Crime Life"} ,
{4710,"Empire Earth II Art of Supremacy"} ,
{4711,"Quake 4 Demo"} ,
{4712,"Silkroad Online"} ,
{4713,"Flyff"} ,
{4714,"Prince of Persia The Two Thrones"} ,
{4715,"WarRock"} ,
{4716,"X3 - The Reunion"} ,
{4717,"Stubbs the Zombie"} ,
{4718,"Pro Evolution Soccer 5"} ,
{4719,"Football Manager 2006"} ,
{4720,"Star Trek Bridge Commander"} ,
{4721,"Advent Rising"} ,
{4722,"UFO Aftershock"} ,
{4723,"NavyField"} ,
{4724,"Rubies of Eventide"} ,
{4725,"FIFA Manager 06"} ,
{4726,"Star Wars Empire at War"} ,
{4727,"Metal Gear Solid2 Substance"} ,
{4728,"KumaWar"} ,
{4729,"Heroes of Might and Magic III"} ,
{4730,"Heroes of Might and Magic III Armageddon's Blade"} ,
{4731,"Rakion Chaos Force"} ,
{4732,"Midtown Madness"} ,
{4733,"Midtown Madness 2"} ,
{4734,"Monster Truck Madness 2"} ,
{4735,"Motocross Madness 2"} ,
{4736,"Rainbow Six Lockdown Demo"} ,
{4737,"Star Wars Empire at War Demo"} ,
{4738,"Final Fantasy VII"} ,
{4739,"Final Fantasy VIII"} ,
{4740,"Battle for Middle-earth II Beta"} ,
{4741,"Heroes of Might and Magic V Beta"} ,
{4742,"MX vs ATV Unleashed Demo"} ,
{4743,"FSW Ten Hammers"} ,
{4744,"MX vs ATV Unleashed"} ,
{4745,"Freecell"} ,
{4746,"Hearts"} ,
{4747,"Pinball"} ,
{4748,"Devastation"} ,
{4749,"Heroes of Might and Magic IV"} ,
{4750,"Rainbow Six Lockdown"} ,
{4751,"Marc Ecko's Getting Up - Contents Under Pressure"} ,
{4752,"GT Legends"} ,
{4753,"Trackmania Nations"} ,
{4754,"C&C Red Alert"} ,
{4755,"Command & Conquer"} ,
{4756,"SpaceCowboy"} ,
{4757,"Battle for Middle-earth II"} ,
{4758,"Toca Race Driver 3"} ,
{4759,"RF Online"} ,
{4760,"Cabela's Big Game Hunter 2006"} ,
{4761,"Deer Hunter 2003"} ,
{4762,"Deer Hunter 2004"} ,
{4763,"Deer Hunter 2005"} ,
{4764,"Myst"} ,
{4765,"Riven"} ,
{4766,"Myst III Exile"} ,
{4767,"Myst IV Revelation"} ,
{4768,"Myst V End of Ages"} ,
{4769,"Auto Assault"} ,
{4770,"Dungeons & Dragons Online: Eberron Unlimited"} ,
{4771,"The Sims 2 Open for Business"} ,
{4772,"SWAT 4 - The Stetchkov Syndicate"} ,
{4773,"NCAA Championship Run 2006"} ,
{4774,"The Elder Scrolls IV: Oblivion"} ,
{4775,"Dark Age of Camelot - Darkness Rising"} ,
{4776,"The Godfather"} ,
{4777,"Red Orchestra Ostfront 41-45 (Steam)"} ,
{4778,"Galactic Civilizations II"} ,
{4779,"Galactic Civilizations"} ,
{4780,"Galactic Civilizations - The Altarian Prophecy"} ,
{4781,"18 Wheels of Steel Across America"} ,
{4782,"Sin (Steam)"} ,
{4783,"Sin Multiplayer (Steam)"} ,
{4784,"SpellForce2 - Shadow Wars"} ,
{4785,"Commandos Strikeforce"} ,
{4786,"Tomb Raider - Legend"} ,
{4787,"The Sims 2 Family Fun Stuff"} ,
{5591,"Sword of the Stars: A Murder of Crows"} ,
{5439,"Sword of the Stars Collectors' Edition"} ,
{4788,"Sword of the Stars"} ,
{4789,"True Crime - New York City"} ,
{4790,"Shattered Galaxy"} ,
{4791,"WWII Online"} ,
{4792,"Blazing Angels"} ,
{4793,"Heroes of Might and Magic V Demo"} ,
{4794,"Titan Quest Demo"} ,
{4795,"Condemned - Criminal Origins"} ,
{4796,"2006 FIFA World Cup"} ,
{4797,"Dangerous Waters"} ,
{4798,"Dune 2000"} ,
{4799,"Emperor - Battle for Dune"} ,
{4800,"Ghost Recon Advanced Warfighter Demo"} ,
{4801,"Sid Meier's Alpha Centauri"} ,
{4802,"Winning Eleven 9"} ,
{4803,"Ghost Recon Advanced Warfighter"} ,
{4804,"Call of Cthulhu DCoTE"} ,
{4805,"The Settlers IV"} ,
{4806,"Hearts of Iron II Doomsday"} ,
{4807,"UberSoldier"} ,
{4808,"Dungeon Keeper 2"} ,
{4809,"Tycoon City - New York"} ,
{4810,"Crashday"} ,
{4811,"Titan Quest"} ,
{4812,"Tony Hawk's American Wasteland"} ,
{4813,"Rise of Legends"} ,
{4814,"Sin Episodes - Emergence"} ,
{4815,"Heroes of Might and Magic V"} ,
{4816,"City of Heroes Test Server"} ,
{4817,"City of Villains Test Server"} ,
{4818,"Dreamfall"} ,
{4819,"DawnOfMen"} ,
{4820,"GameTap"} ,
{4821,"Hitman Blood Money"} ,
{4822,"Half-Life 2: Episode One"} ,
{4823,"Black & White 2 Battle of the Gods"} ,
{4824,"The Longest Journey"} ,
{4825,"Shadowgrounds"} ,
{4826,"The Da Vinci Code"} ,
{4827,"Star Trek Armada II"} ,
{4828,"Star Trek Away Team"} ,
{4829,"Hidden: Source"} ,
{4830,"Goldeneye: Source"} ,
{4831,"Kreedz Climbing"} ,
{4832,"Empires"} ,
{4833,"Rogue Squadron"} ,
{4834,"Star Wars Starfighter"} ,
{4835,"Stacked"} ,
{4836,"Asheron's Call"} ,
{4837,"The Movies Stunts & Effects"} ,
{4838,"SimCity 3000"} ,
{4840,"Game Tycoon"} ,
{4841,"Total Overdose"} ,
{4842,"Rush For Berlin"} ,
{4843,"Xpand Rally"} ,
{4844,"Locomotion"} ,
{4845,"Dungeon Lords"} ,
{4846,"Trainz Railroad Simulator 2006"} ,
{4847,"Freedom Fighters"} ,
{4848,"Prey Demo"} ,
{4849,"Onimusha 3"} ,
{4850,"Warsow"} ,
{4851,"Albatross18"} ,
{4852,"Sprint Cars: Road to Knoxville"} ,
{4853,"Hitman - Codename 47"} ,
{4854,"The Suffering Ties That Bind"} ,
{4855,"Rise & Fall"} ,
{4856,"City Life"} ,
{4857,"Rogue Trooper"} ,
{4858,"Prey"} ,
{4859,"NFL Head Coach"} ,
{4860,"Act of War - High Treason"} ,
{4861,"The Ship"} ,
{4862,"X-Wing Alliance"} ,
{4863,"Hero Online"} ,
{4864,"Land of the Dead"} ,
{4865,"Sword of the Stars Demo"} ,
{4866,"Civilization IV - Warlords"} ,
{4867,"CivCity Rome"} ,
{4868,"OutRun2006 Coast 2 Coast"} ,
{4869,"Glory of the Roman Empire"} ,
{4870,"Sacrifice"} ,
{4871,"MechWarrior 3"} ,
{4872,"Dawn of War Dark Crusade"} ,
{4873,"MechWarrior 4 Black Knight"} ,
{4874,"Dungeon Siege II Broken World"} ,
{4875,"Flatout 2"} ,
{4876,"Untold Legends: Dark Kingdom"} ,
{4877,"Hellgate: London"} ,
{4878,"Company of Heroes Multiplayer Beta"} ,
{4879,"FEAR Multiplayer"} ,
{4880,"Battlefield 2142"} ,
{4881,"Monopoly Tycoon"} ,
{4882,"Madden NFL 07"} ,
{4883,"Company of Heroes Single Player Demo"} ,
{4884,"Dawn of War Dark Crusade Demo"} ,
{5143,"Company of Heroes: Opposing Fronts"} ,
{4885,"Company of Heroes"} ,
{4886,"Lego Star Wars II"} ,
{4887,"Mall Tycoon"} ,
{4888,"Mall Tycoon 2"} ,
{4889,"Mall Tycoon 3"} ,
{4890,"School Tycoon"} ,
{4891,"Airport Tycoon"} ,
{4892,"Prison Tycoon 2"} ,
{4893,"First Battalion"} ,
{4894,"Faces of War"} ,
{4895,"Patriots: A Nation Under Fire"} ,
{4896,"Caesar 4 Demo"} ,
{4897,"Dark Messiah Multiplayer Open Beta"} ,
{4898,"FEAR Extraction Point SP Demo"} ,
{4899,"Mage Knight Apocalypse"} ,
{4900,"Caesar 4"} ,
{4901,"NBA Live 07"} ,
{4902,"NHL 07"} ,
{4903,"Just Cause"} ,
{4904,"The Sims 2 Glamour Life Stuff"} ,
{4905,"FIFA 07"} ,
{4906,"Disciples 2 - Gallean's Return"} ,
{4907,"Disciples 2 - Rise of the Elves"} ,
{4908,"Joint Task Force"} ,
{4909,"Battlefield 2142 Demo"} ,
{4910,"GTR 2"} ,
{4911,"Scarface"} ,
{4912,"Archlord"} ,
{4913,"Medieval II Total War Demo SE"} ,
{4914,"War Front - Turning Point"} ,
{4915,"Gothic III"} ,
{4916,"Tiger Woods PGA Tour 07"} ,
{4917,"El Matador"} ,
{4918,"Paraworld"} ,
{4919,"Frets on Fire"} ,
{4920,"Defcon"} ,
{4921,"Championship Manager 2006"} ,
{4922,"Age of Empires III: The WarChiefs"} ,
{4923,"Microsoft Flight Simulator X"} ,
{4924,"BZFlag"} ,
{4925,"The Sims 2 Pets"} ,
{4926,"Sid Meier's Railroads"} ,
{4927,"The Guild 2"} ,
{4928,"Neocron 2"} ,
{4929,"Devil May Cry 3 Special Edition"} ,
{4930,"Space Empires IV Deluxe"} ,
{4931,"Space Empires V"} ,
{4932,"Shot Online"} ,
{4934,"Star Wars Empire at War Forces of Corruption"} ,
{4935,"Phantasy Star Universe Online"} ,
{4936,"Dark Messiah Multiplayer"} ,
{4937,"Dark Messiah Single Player"} ,
{4938,"FEAR Extraction Point"} ,
{4939,"Stronghold Legends"} ,
{4940,"Perimeter"} ,
{4941,"Perimeter Emperor's Testament"} ,
{4942,"Neverwinter Nights 2"} ,
{4943,"Need for Speed Carbon"} ,
{4944,"Marvel Ultimate Alliance"} ,
{4945,"Need for Speed Carbon Demo"} ,
{4946,"Pro Evolution Soccer 6"} ,
{4947,"Football Manager 2007"} ,
{4948,"Championship Manager 2007"} ,
{4949,"Splinter Cell Double Agent Single Player"} ,
{4950,"Splinter Cell Double Agent Multiplayer"} ,
{4951,"SkillGround.com"} ,
{4952,"1701 A.D."} ,
{4953,"Medieval II Total War"} ,
{4954,"Panzer Command"} ,
{4955,"Warhammer Mark of Chaos"} ,
{4956,"Heroes of Might and Magic V - Hammers of Fate"} ,
{4957,"Falcon 4.0 Allied Force"} ,
{4958,"Eragon"} ,
{4959,"The Settlers II - 10th Anniversary"} ,
{4960,"Reservoir Dogs"} ,
{4961,"Digital Paint: Paintball 2"} ,
{4962,"The Lord of the Rings, The Rise of the Witch-king"} ,
{4963,"Rappelz Epic3"} ,
{4964,"Star Trek Legacy"} ,
{4965,"Tom Clancy's Rainbow Six Vegas"} ,
{4966,"ijji GunZ"} ,
{4967,"Vanguard - Saga of Heroes"} ,
{4968,"CABAL Online (Europe)"} ,
{4969,"Trickster Revolution"} ,
{4970,"Pirates of the Caribbean"} ,
{4971,"Dark Age of Camelot - Labyrinth of the Minotaur"} ,
{4972,"Battlefield 1942 Multiplayer Demo"} ,
{4973,"Battlefield 1942 Singleplayer Demo"} ,
{4974,"Battlefield 1942 Secret Weapons of WWII Demo"} ,
{4975,"Titan Quest Immortal Throne"} ,
{4976,"Supreme Commander"} ,
{4977,"Goonzu Online"} ,
{4978,"25 to Life"} ,
{4979,"Battlestations Midway"} ,
{4980,"Bad Day LA"} ,
{4981,"Let's Ride! - Silver Buckle Stables"} ,
{4982,"James Bond 007 Nightfire"} ,
{4983,"Mythos"} ,
{4984,"Soldier Front"} ,
{4985,"The Sims Life Stories"} ,
{4986,"Maelstrom"} ,
{4987,"The Curse of Monkey Island"} ,
{4988,"Escape from Monkey Island"} ,
{4989,"TMNT Demo"} ,
{4990,"Warhammer Mark of Chaos MP Demo"} ,
{4991,"Trackmania United Forever"} ,
{4992,"Absolute Poker.com"} ,
{4993,"Doyles Room.com"} ,
{4994,"Everest Poker.com"} ,
{4995,"Full Tilt Poker.com"} ,
{4996,"Paradise Poker.com"} ,
{4997,"PKR.com"} ,
{4998,"Ultimate Bet.com"} ,
{4999,"WPTOnline.com"} ,
{5000,"Command & Conquer 3 Tiberium Wars Demo"} ,
{5001,"Jade Empire"} ,
{5002,"The Sims 2 Seasons"} ,
{5003,"Space Rangers 2"} ,
{5004,"Railroad Tycoon II"} ,
{5005,"Railroad Tycoon II Platinum"} ,
{5006,"Sonic Riders"} ,
{5007,"Sonic Heroes"} ,
{5008,"Source SDK Base"} ,
{5009,"S.T.A.L.K.E.R. - Shadow of Chernobyl"} ,
{5010,"TMNT"} ,
{5011,"Silent Hunter Wolves of the Pacific"} ,
{5012,"Silverfall"} ,
{5013,"Command & Conquer 3 Tiberium Wars"} ,
{5014,"Test Drive Unlimited"} ,
{5015,"18 Wheels of Steel Haulin"} ,
{5016,"rFactor"} ,
{5017,"Half-Life Deathmatch: Source"} ,
{5018,"Baseball Mogul 2008"} ,
{5019,"Genesis Rising"} ,
{5020,"Call of Juarez"} ,
{5021,"The Lord of the Rings Online"} ,
{5720,"The Sims 2 Double Deluxe"} ,
{5022,"The Sims 2 Celebration! Stuff"} ,
{5023,"ArmA"} ,
{5024,"Tortuga - Two Treasures"} ,
{5025,"Europa Universalis III"} ,
{5026,"Winning Eleven Pro Evolution Soccer 2007"} ,
{5027,"Race - The WTCC Game"} ,
{5028,"Resident Evil 4"} ,
{5029,"Ancient Wars - Sparta"} ,
{5030,"Spider-Man 3"} ,
{5031,"Frontline - Fields of Thunder"} ,
{5032,"Broken Sword - The Angel of Death"} ,
{5033,"Cricket 07"} ,
{5034,"Chess Titans"} ,
{5035,"Inkball"} ,
{5036,"Mahjong Titans"} ,
{5037,"Purble Place"} ,
{5038,"Hold 'Em"} ,
{5039,"Brian Lara International Cricket 2007"} ,
{5040,"LMA Manager 2007"} ,
{5041,"UEFA Champions League 2006-2007"} ,
{5042,"FIFA Manager 07"} ,
{5043,"Virtua Tennis 3"} ,
{5044,"Boiling Point"} ,
{5045,"Cellfactor Revolution"} ,
{5046,"Infernal"} ,
{5047,"Crazy Taxi"} ,
{5048,"Last Chaos USA"} ,
{5049,"The Sims 2 Deluxe"} ,
{5050,"Harry Potter and the Prisoner of Azkaban"} ,
{5051,"Broken Sword - The Sleeping Dragon"} ,
{5052,"Syberia"} ,
{5053,"Syberia2"} ,
{5054,"Voyage Century Online"} ,
{5055,"Sauerbraten"} ,
{5056,"Dogz 4"} ,
{5057,"Freeciv - beta"} ,
{5058,"Tibia"} ,
{5059,"UFO - Extraterrestrial"} ,
{5060,"Pirates of the Caribbean - At World's End"} ,
{5061,"Halo 2"} ,
{5062,"Attack on Pearl Harbor"} ,
{5063,"Red Alert: A Path Beyond"} ,
{5064,"Entropia Universe"} ,
{5065,"World of Padman"} ,
{5066,"Populous - The Beginning"} ,
{5067,"Populous - The Beginning - Undiscovered Worlds"} ,
{5068,"Tomb Raider - Anniversary"} ,
{5069,"Baldur's Gate II"} ,
{5070,"Birth of America"} ,
{5071,"Neverwinter Nights 2 AMD 64 Version"} ,
{5073,"Harry Potter and the Sorcerer's Stone"} ,
{5074,"Harry Potter - Quidditch World Cup"} ,
{5075,"Sword of the Stars - Born of Blood"} ,
{5076,"Audition"} ,
{5077,"DiRT"} ,
{5078,"Scions of fate"} ,
{5079,"Tremulous"} ,
{5080,"Enemy Territory: QUAKE Wars"} ,
{5081,"Catz (Deprecated)"} ,
{5082,"Dogz (Deprecated)"} ,
{5083,"The Sims 2 H&M Fashion Stuff"} ,
{5084,"The Sims Pet Stories"} ,
{5085,"Overlord"} ,
{5086,"Monster Madness - Battle for Suburbia"} ,
{5087,"Lost Planet Extreme Condition"} ,
{5088,"Harry Potter and the Order of the Phoenix"} ,
{5089,"D.i.R.T. - Origin of the Species"} ,
{5090,"Hospital Tycoon"} ,
{5091,"Mount & Blade"} ,
{5092,"World in Conflict - BETA"} ,
{5093,"Mysteries of the Sith"} ,
{5094,"Sword of the New World"} ,
{5095,"Transformers - The Game"} ,
{5096,"Insurgency - Modern Infantry Combat"} ,
{5097,"Ghost Recon Advanced Warfighter 2"} ,
{5098,"Kwonho"} ,
{5099,"Penumbra Overture Ep1"} ,
{5100,"Taito Legends 2"} ,
{5101,"Dungeon Runners"} ,
{5102,"3D Model Trains"} ,
{5103,"Civilization IV - Beyond the Sword"} ,
{5104,"Baseball Mogul 2007"} ,
{5105,"MicroMachines V4"} ,
{5106,"Catz"} ,
{5107,"Dogz"} ,
{5108,"Rappelz Epic5"} ,
{5109,"Metin 2"} ,
{5110,"Tabula Rasa"} ,
{5111,"Warhammer Online Beta"} ,
{5112,"Avencast"} ,
{5113,"2Moons"} ,
{5114,"DANCE! Online"} ,
{5115,"Madden NFL 08"} ,
{5116,"Shadowrun"} ,
{5117,"FreeStyle Street Basketball"} ,
{5118,"BioShock Demo"} ,
{5119,"BioShock"} ,
{5120,"Medal of Honor: Airborne"} ,
{5121,"Medal of Honor: Airborne - Demo"} ,
{5122,"World in Conflict - DEMO"} ,
{5123,"Two Worlds Demo"} ,
{5124,"Two Worlds"} ,
{5125,"Medieval II Total War: Kingdoms"} ,
{5126,"Tiger Woods PGA Tour 08"} ,
{5127,"Desperate Housewives"} ,
{5128,"Urban Terror"} ,
{5129,"Pet Vet 3D Animal Hospital"} ,
{5130,"The Sims 2 Bon Voyage"} ,
{5131,"Enemy Territory: QUAKE Wars Demo"} ,
{5132,"World in Conflict Single Player"} ,
{5133,"World in Conflict Multiplayer"} ,
{5134,"Team Fortress 2"} ,
{5135,"Peggle Extreme"} ,
{5136,"Mayhem Intergalactic"} ,
{5137,"Mayhem Intergalactic Demo"} ,
{5138,"Crysis MP Beta"} ,
{5139,"Frontlines: Fuel of War Beta"} ,
{5140,"Drift City"} ,
{5141,"John Woo Presents Stranglehold"} ,
{5142,"NHL 08"} ,
{5144,"Blazing Angels 2: Secret Missions of WWII"} ,
{5145,"Big Mutha Truckers 2"} ,
{5146,"Fortress Forever"} ,
{5147,"The Settlers: Rise of an Empire"} ,
{5148,"Babo Violent 2"} ,
{5149,"CodeNameD: BlueShift"} ,
{5150,"KartRider"} ,
{5151,"CSI: Hard Evidence"} ,
{5152,"UFO: Afterlight"} ,
{5153,"Portal"} ,
{5154,"Half-Life 2: Episode Two"} ,
{5155,"FIFA 08"} ,
{5156,"Loki"} ,
{5157,"Call of Duty 4: Modern Warfare Demo"} ,
{5158,"Unreal Tournament 3 Demo"} ,
{5159,"Project Torque"} ,
{5160,"Sid Meier's SimGolf"} ,
{5161,"Legends"} ,
{5162,"Brain Spa"} ,
{5163,"Heroes of Might and Magic V: Tribes of the East"} ,
{5164,"Fury"} ,
{5165,"Hellgate: London Demo"} ,
{5166,"City Life Deluxe"} ,
{5167,"Galactic Civilizations II: Dark Avatar"} ,
{5168,"CSPromod Beta"} ,
{5169,"8BallClub"} ,
{5170,"Worldwide Soccer Manager 2008"} ,
{5171,"Football Manager 2008"} ,
{5172,"Clive Barker's Jericho"} ,
{5173,"Age of Empires III: The Asian Dynasties"} ,
{5174,"Dynasty Warriors 4 Hyper"} ,
{5175,"Crysis SP Demo"} ,
{5176,"Painkiller: Overdose"} ,
{5177,"SunAge"} ,
{5178,"Luminary: Rise of Goonzu"} ,
{5179,"The Witcher"} ,
{5180,"TimeShift"} ,
{5181,"Happy Feet"} ,
{5182,"NBA Live 08"} ,
{5183,"Taito Legends"} ,
{5184,"Perfect World"} ,
{5185,"Call of Duty 4: Modern Warfare Single Player"} ,
{5186,"Call of Duty 4: Modern Warfare Multiplayer"} ,
{5187,"Supreme Commander: Forged Alliance"} ,
{5188,"Empire Earth III"} ,
{5189,"FEAR Perseus Mandate"} ,
{5190,"Gears of War"} ,
{5191,"Dawn of War: Soulstorm"} ,
{5192,"Pro Evolution Soccer 2008"} ,
{5193,"Chessmaster Grandmaster Edition"} ,
{5194,"Crysis"} ,
{5195,"Dawn of Magic"} ,
{5196,"You Are Empty"} ,
{5197,"Guitar Hero III"} ,
{5198,"Need for Speed ProStreet"} ,
{5199,"Beowulf"} ,
{5873,"Simcity Societies Destinations"} ,
{5200,"Simcity Societies"} ,
{5201,"Pinball Wizards: Balls of Steel Demo"} ,
{5202,"Spider-Man: Friend or Foe"} ,
{5203,"BlackSite: Area 51"} ,
{5204,"Soldier of Fortune: Payback"} ,
{5205,"Viva Pinata"} ,
{5206,"WolfTeam International"} ,
{5207,"Fantasy Wars"} ,
{5208,"Unreal Tournament 3"} ,
{5209,"Avencast: Rise of The Mage"} ,
{5210,"Next Life"} ,
{5211,"Risk"} ,
{5212,"Instinct"} ,
{5213,"Gothic"} ,
{5214,"Kane and Lynch: Dead Men"} ,
{5215,"Exteel"} ,
{5216,"The Office"} ,
{5217,"Escape From Paradise City"} ,
{5218,"Catz 2"} ,
{5219,"Dogz 2"} ,
{5220,"Horsez 2"} ,
{5221,"BMW M3 Challenge"} ,
{5222,"Dofus"} ,
{5223,"Quake"} ,
{5224,"SEGA Rally Revo"} ,
{5225,"Planeshift"} ,
{5226,"Alpha Prime"} ,
{5227,"Ghost in the Sheet"} ,
{5228,"Ascension"} ,
{5229,"Speedball 2 - Tournament"} ,
{5230,"Alvin and the Chipmunks"} ,
{5231,"Fiesta"} ,
{5232,"Universe At War: Earth Assault"} ,
{5233,"RACE 07"} ,
{5234,"Battle for the Pacific"} ,
{5235,"Warmonger - Operation: Downtown Destruction"} ,
{5236,"Arcanum: Of Steamworks and Magick Obscura"} ,
{5237,"Shogun: Total War"} ,
{5238,"Shaiya"} ,
{5239,"The Golden Compass"} ,
{5240,"Dream Of Mirror Online"} ,
{5241,"PKRCasino"} ,
{5242,"Twelve Sky"} ,
{5243,"Regnum Online"} ,
{5244,"Beyond Divinity"} ,
{5245,"Geometry Wars: Retro Evolved"} ,
{5246,"Kane and Lynch: Dead Men Demo"} ,
{5247,"Hard To Be a God Demo"} ,
{5248,"Indiana Jones and the Emperors Tomb"} ,
{5249,"Grand Theft Auto"} ,
{5250,"Peggle Deluxe"} ,
{5251,"Juiced 2: Hot Import Nights"} ,
{5252,"Phantasy Star Universe: Ambition of the Illuminus"} ,
{5253,"Pirates of the Burning Sea"} ,
{5254,"Battlestar Galactica"} ,
{5255,"Puzzle Quest: Challenge of the Warlords"} ,
{5256,"Dawn of War: Soulstorm Demo"} ,
{5257,"Teeworlds"} ,
{5258,"Metal Gear Solid"} ,
{5259,"Indiana Jones and the Infernal Machine"} ,
{5260,"Divine Divinity"} ,
{5261,"Rising Eagle"} ,
{5262,"Hard Truck: 18 Wheels of Steel"} ,
{5263,"Stranded II"} ,
{5264,"Pirates of the Caribbean Online"} ,
{5265,"Wild Metal Country"} ,
{5266,"GGPO.net"} ,
{5267,"Jewel Quest"} ,
{5268,"9Dragons"} ,
{5269,"Feeding Frenzy 2 Deluxe"} ,
{5270,"Bejeweled Deluxe"} ,
{5271,"Bejeweled 2 Deluxe"} ,
{5272,"Chuzzle Deluxe"} ,
{5273,"Insaniquarium Deluxe"} ,
{5274,"AstroPop Deluxe"} ,
{5275,"Iggle Pop Deluxe"} ,
{5276,"Zuma Deluxe"} ,
{5277,"Dynomite Deluxe"} ,
{5278,"Big Money Deluxe"} ,
{5279,"Heavy Weapon Deluxe"} ,
{5280,"Pizza Frenzy Deluxe"} ,
{5281,"Hammer Heads Deluxe"} ,
{5282,"Typer Shark Deluxe"} ,
{5283,"Rail Simulator"} ,
{5284,"Bookworm Deluxe"} ,
{5285,"Bookworm Adventures Deluxe"} ,
{5726,"Sins of a Solar Empire: Entrenchment"} ,
{5286,"Sins of a Solar Empire"} ,
{5287,"The Sims Castaway Stories"} ,
{5288,"Thrillville: Off the Rails"} ,
{5289,"Secret of the Solstice"} ,
{5290,"CABAL Online: The Revolution of Action"} ,
{5291,"Holic"} ,
{5292,"Racer Beta"} ,
{5293,"FIFA Manager 08"} ,
{5294,"The Spiderwick Chronicles"} ,
{5295,"Conflict: Denied Ops"} ,
{5296,"Harley-Davidson Race to the Rally"} ,
{5297,"Manga Fighter"} ,
{5298,"Audiosurf"} ,
{5299,"Impossible Creatures"} ,
{5300,"Resident Evil 3: Nemesis"} ,
{5301,"Theme Hospital"} ,
{5302,"AirRivals"} ,
{5303,"RuneScape"} ,
{5304,"Penumbra: Black Plague"} ,
{5305,"Hello Kitty Cutie World"} ,
{5306,"Beyond Good & Evil"} ,
{5307,"The Club"} ,
{5308,"Europa 1400: The Guild (Gold)"} ,
{5309,"Red Stone"} ,
{5310,"Frontlines: Fuel of War"} ,
{5311,"Grand Chase (Asia)"} ,
{5312,"Grand Chase"} ,
{5313,"The Sims 2 FreeTime"} ,
{5314,"Turning Point: Fall of Liberty"} ,
{5315,"Lost: Via Domus"} ,
{5316,"Phun"} ,
{5317,"SpaceForce Captains"} ,
{5318,"NASCAR Racing 2002 Season"} ,
{5319,"Darkeden"} ,
{5320,"The Experiment"} ,
{5321,"FairyLand"} ,
{5322,"Fritz 8"} ,
{5323,"Bots"} ,
{5324,"Crusaders: Thy Kingdom Come"} ,
{5325,"Crusaders: Thy Kingdom Come Multiplayer"} ,
{5326,"Cal Ripken's Real Baseball"} ,
{5327,"Pirates, Vikings and Knights II"} ,
{5328,"Worms 2"} ,
{5329,"Savage 2: A Tortured Soul"} ,
{5330,"Phantasy Star Online: Blue Burst"} ,
{5331,"Pirateville"} ,
{5332,"Upshift StrikeRacer"} ,
{5333,"Glest"} ,
{5334,"WorldShift Beta"} ,
{5335,"Seven Kingdoms: Conquest"} ,
{5336,"Powerboat GT"} ,
{5337,"Chessmaster 10th Edition"} ,
{5338,"Red Baron Arcade"} ,
{5339,"The Shield"} ,
{5340,"Mind Quiz"} ,
{5341,"Ricochet Infinity"} ,
{5342,"Command & Conquer 3: Kane's Wrath"} ,
{5343,"Lost Empire: Immortals"} ,
{5344,"Hard Truck 2"} ,
{5345,"Lights Out"} ,
{5346,"SWAT 3"} ,
{5347,"The Sims Carnival: BumperBlast"} ,
{5348,"The Sims Carnival: SnapCity"} ,
{5349,"Toribash"} ,
{5350,"Osu!"} ,
{5351,"Pet Luv Spa and Resort Tycoon"} ,
{5352,"Perfect Dark: Source"} ,
{5353,"Trials 2: Second Edition"} ,
{5354,"Synergy"} ,
{5355,"Rohan: Blood Feud"} ,
{5356,"Warriors Orochi"} ,
{5357,"Alien Arena 2008"} ,
{5358,"Ninja Reflex: Steamworks Edition"} ,
{5359,"Lunia"} ,
{5360,"Uplink"} ,
{5361,"Slayers Online"} ,
{5362,"Second Sight"} ,
{5363,"Imperium Romanum"} ,
{5364,"Yu-Gi-Oh! Online: Duel Evolution"} ,
{5365,"Assassin's Creed"} ,
{5366,"Terra: Battle for the Outlands"} ,
{5367,"Darkstar One"} ,
{5368,"OpenTTD"} ,
{5369,"NosTale EU"} ,
{5370,"Jagged Alliance 2 Gold"} ,
{5371,"American McGee's Alice"} ,
{5372,"Skulltag"} ,
{5373,"Saga"} ,
{5374,"Trackmania Nations Forever"} ,
{5375,"Tom Clancy's Rainbow Six Vegas 2"} ,
{5376,"The Sims 2 Kitchen & Bath Interior Design Stuff"} ,
{5377,"Kung Fu Panda Demo"} ,
{5378,"Melty Blood: Act Cadenza"} ,
{5379,"Seal Online USA"} ,
{5380,"Magic Online III"} ,
{5381,"Ultimate Doom"} ,
{5382,"Master Levels of Doom"} ,
{5383,"Final Doom"} ,
{5384,"Doom 2"} ,
{5385,"Cabela's Dangerous Hunts 2"} ,
{5386,"Turok"} ,
{5387,"Clive Barker's Undying"} ,
{5388,"Lumines"} ,
{5389,"Europa Universalis: Rome"} ,
{5390,"Planescape: Torment"} ,
{5391,"Dirty Dancing: The Video Game"} ,
{5392,"Age of Conan: Hyborian Adventures"} ,
{5393,"The House of the Dead 3"} ,
{5394,"The House of the Dead 2"} ,
{5395,"Iron Man"} ,
{5396,"Sherlock Holmes: Nemesis"} ,
{5397,"Galactic Civilizations II: Twilight of the Arnor"} ,
{5398,"Imperialism II"} ,
{5399,"Star Wars: Battle for Naboo"} ,
{5400,"Grand Prix 4"} ,
{5401,"Tomb Raider II"} ,
{5402,"Commandos 3: Destination Berlin"} ,
{5403,"Capitalism II"} ,
{5404,"Tales of Pirates Online"} ,
{5405,"Bet and Race"} ,
{5406,"Commandos: Behind Enemy Lines"} ,
{5407,"Magic The Gathering: Battlegrounds"} ,
{5408,"Everyday Shooter"} ,
{5409,"Graal Online"} ,
{5410,"Heretic II"} ,
{5411,"Conflict: Global Terror"} ,
{5412,"Jack Keane"} ,
{5413,"Shogo: Mobile Armor Division"} ,
{5414,"Cossacks: The Art Of War"} ,
{5415,"Requiem: Bloodymare"} ,
{5416,"Hello Kitty Online"} ,
{5417,"On the Rain-Slick Precipice of Darkness, Episode One"} ,
{5418,"PseudoQuest"} ,
{5419,"Mortimer Beckett and the Secrets of Spooky Manor"} ,
{5420,"Silent Hunter II"} ,
{5421,"Flanker 2.5"} ,
{5422,"The Continuum"} ,
{5423,"Great War Nations: The Spartans"} ,
{5424,"Shadowgrounds Survivor"} ,
{5425,"Mass Effect"} ,
{5426,"Lost Planet: Extreme Condition Colonies Edition"} ,
{5427,"G-Police"} ,
{5428,"Heroes of Might and Magic III Complete"} ,
{5429,"GRID Demo"} ,
{5430,"Icewind Dale II"} ,
{5431,"Day of Defeat: Source Beta"} ,
{5432,"Spaceinvasion"} ,
{5433,"ChaosCars"} ,
{5434,"Gladiators II"} ,
{5435,"Seafight"} ,
{5436,"DarkOrbit"} ,
{5437,"Lego Indiana Jones: The Original Adventures"} ,
{5438,"GRID"} ,
{5440,"Guilty Gear x2 Reload"} ,
{5441,"Nitro Stunt Race Stage 1"} ,
{5442,"MTV's Virtual World"} ,
{5443,"Kung Fu Panda"} ,
{5444,"Aliens versus Predator Gold Edition"} ,
{5445,"Turok 2: Seeds of Evil Singleplayer"} ,
{5446,"Turok 2: Seeds of Evil Multiplayer"} ,
{5447,"Wonderland Online"} ,
{5448,"Devil May Cry 4 Trial"} ,
{5449,"Blokus World Tour"} ,
{5450,"Star Sonata"} ,
{5451,"Bullet Candy"} ,
{5452,"Bus Driver"} ,
{5453,"The Incredible Hulk"} ,
{5454,"Stronghold Crusader Extreme"} ,
{5455,"Marble Blast Gold"} ,
{5456,"UEFA Euro 2008"} ,
{5458,"Little Farm"} ,
{5459,"SPORE Creature Creator"} ,
{5460,"Psi-Ops: The Mindgate Conspiracy"} ,
{5461,"Zu Online"} ,
{5462,"Angels Online"} ,
{5463,"Dreamlords: The Reawakening"} ,
{5464,"Alien Shooter"} ,
{5465,"WALL-E"} ,
{5466,"Alone In The Dark"} ,
{5467,"Crazy Machines 2"} ,
{5468,"Out of the Park Baseball 9"} ,
{5469,"The Sims 2 IKEA Home Stuff"} ,
{5470,"World of Kung Fu"} ,
{5471,"Making History: The Calm and The Storm"} ,
{5472,"Freelanc3r"} ,
{5473,"Genleo: The Land of Eratica"} ,
{5474,"Seeds of Time Online"} ,
{5475,"Oil Imperium"} ,
{5476,"Combat Arms"} ,
{5477,"Cardmaster Conflict"} ,
{5478,"Freedom Force"} ,
{5479,"Ultimate Pimpin'"} ,
{5480,"Safari Photo Africa: Wild Earth"} ,
{5481,"Supreme Ruler 2020"} ,
{5482,"The Political Machine 2008"} ,
{5483,"CS-Manager"} ,
{5484,"Devil May Cry 4"} ,
{5485,"Immune Attack"} ,
{5486,"Carmageddon II: Carpocalypse Now!"} ,
{5487,"Panzer Elite"} ,
{5488,"Dark Colony"} ,
{5489,"Enclave"} ,
{5490,"Carmageddon TDR2000"} ,
{5491,"Rayman Raving Rabbids"} ,
{5492,"Rigs of Rods"} ,
{5493,"7 Wonders of the Ancient World"} ,
{5494,"Eternal Lands"} ,
{5495,"The Golden Horde"} ,
{5496,"Roogoo"} ,
{5497,"Bomberman Online"} ,
{5498,"Elements"} ,
{5499,"The Wonderful End of the World"} ,
{5500,"Halo Trial"} ,
{5501,"Space Chimps"} ,
{5502,"7 Wonders II"} ,
{5503,"Sacred Gold"} ,
{5504,"UniBall"} ,
{5505,"Warrior Epic"} ,
{5506,"World of Warcraft: Wrath of the Lich King Beta"} ,
{5507,"Jutland Beta"} ,
{5508,"IGI-2: Covert Strike"} ,
{5509,"CQC: Close Quarter Combat"} ,
{5510,"Q-World"} ,
{5511,"Majesty Gold Edition"} ,
{5512,"Majesty Gold Edition: The Northern Expansion"} ,
{5513,"I.G.I.: I'm Going In"} ,
{5514,"Transport Giant"} ,
{5515,"Command & Conquer: Red Alert 3 Beta"} ,
{5516,"The Settlers III"} ,
{5517,"Beijing 2008"} ,
{5518,"Eschalon Book I"} ,
{5519,"Sudden Strike 3: Arms for Victory"} ,
{5520,"Project Powder Beta"} ,
{5521,"Xiah Rebirth"} ,
{5522,"Asda Story"} ,
{5523,"Dream Pinball 3D"} ,
{5524,"Sho Online"} ,
{5525,"Space Siege"} ,
{5526,"Shattered Suns"} ,
{5527,"Harino"} ,
{5528,"Pro Cycling Manager Season 2008"} ,
{5529,"QPang"} ,
{5530,"FATE: Undiscovered Realms"} ,
{5531,"Dracula: Origin"} ,
{5532,"The Sims 2 Apartment Life"} ,
{5533,"Hunting Unlimited 2009"} ,
{5534,"FlatOut: Ultimate Carnage"} ,
{5535,"Battlefield Heroes"} ,
{5536,"4Story"} ,
{5537,"Legend: Hand of God"} ,
{5538,"Pi Story"} ,
{5539,"Mercenaries 2: World in Flames"} ,
{5540,"SPORE"} ,
{5541,"Dracula 3: The Path of the Dragon"} ,
{5542,"Demigod"} ,
{5543,"Rome: Total War: Alexander"} ,
{5544,"Arca Sim Racing"} ,
{5545,"Oddworld: Abe's Exoddus"} ,
{5546,"Oddworld: Abe's Oddysee"} ,
{5547,"FIFA 09 Demo"} ,
{5548,"S.T.A.L.K.E.R.: Clear Sky"} ,
{5549,"Warhammer Online: Age of Reckoning"} ,
{5550,"Crysis Warhead"} ,
{5551,"Crysis Wars"} ,
{5552,"Romance of the Three Kingdoms XI"} ,
{5553,"Pure"} ,
{5554,"Source SDK Base: Orange Box"} ,
{5555,"Lego Batman"} ,
{5556,"Strong Bad's Cool Game for Attractive People Episode 1: Homestar Ruiner"} ,
{5557,"Strong Bad's Cool Game for Attractive People Episode 2: Strong Badia the Free"} ,
{5558,"Civilization IV: Colonization"} ,
{5559,"Perfect World International"} ,
{5560,"Multiwinia"} ,
{5561,"City Life 2008"} ,
{5562,"King's Bounty: The Legend"} ,
{5563,"1701 A.D.: The Sunken Dragon"} ,
{5564,"The Suffering"} ,
{5565,"Russia's Army"} ,
{5566,"Atlantica Online"} ,
{5567,"Men of War Beta"} ,
{5568,"Ultima Online: Kingdom Reborn"} ,
{5569,"Pro Evolution Soccer 2009 Demo"} ,
{5570,"Sacred 2 - Fallen Angel"} ,
{5571,"Brothers In Arms: Hell's Highway"} ,
{5572,"Hinterland"} ,
{5573,"Age of Chivalry"} ,
{5574,"Zombie Panic! Source"} ,
{5575,"D.I.P.R.I.P. Warm Up"} ,
{5576,"Shocking Void"} ,
{5577,"HighStreet 5"} ,
{5578,"FIFA Soccer 09"} ,
{5579,"World of Goo"} ,
{5580,"Line Rider 2"} ,
{5581,"The Guild 2 Venice"} ,
{5582,"Nostradamus - The Last Prophecy"} ,
{5583,"NHL 09"} ,
{5584,"Dead Space"} ,
{5585,"Guitar Hero: Aerosmith"} ,
{5586,"Baseball Mogul 2009"} ,
{5587,"Dark Horizon"} ,
{5588,"S4 League"} ,
{5589,"Miniconomy"} ,
{5590,"Far Cry 2"} ,
{5592,"Spectraball"} ,
{5593,"NBA 2K9"} ,
{5594,"Bully: Scholarship Edition"} ,
{5595,"X3: Terran Conflict"} ,
{5596,"Exodus From The Earth (Single player game)"} ,
{5597,"Exodus From The Earth (Network game)"} ,
{5598,"Space Trader"} ,
{5599,"Fallout 3"} ,
{5600,"Call of Duty: World at War Beta Multiplayer"} ,
{5601,"Command & Conquer: Red Alert 3"} ,
{5602,"MotoGP 08"} ,
{5603,"Euro Truck Simulator"} ,
{5604,"My Sims"} ,
{5605,"Interstate '76"} ,
{5606,"Football Manager 2009 Demo"} ,
{5607,"Spider-Man: Web of Shadows"} ,
{5608,"Combat Wings: Battle of Britain"} ,
{5609,"Cesar Millan's Dog Whisperer"} ,
{5610,"Endless Online"} ,
{5611,"OceanWar"} ,
{5612,"Quantum of Solace"} ,
{5830,"GCP PES 2009"} ,
{5613,"Pro Evolution Soccer 2009"} ,
{5614,"On the Rain-Slick Precipice of Darkness, Episode Two"} ,
{5615,"Left 4 Dead Demo"} ,
{5616,"Legacy of Kain: Defiance"} ,
{5617,"Legacy of Kain: Soul Reaver"} ,
{5618,"Silent Hill Homecoming"} ,
{5619,"Avatar: Path of Zuko"} ,
{5620,"Galactic Bowling"} ,
{5621,"Sniper- Art of Victory"} ,
{5622,"Deer Hunter Tournament"} ,
{5623,"Call of Duty: World at War Singleplayer"} ,
{5624,"Call of Duty: World at War Multiplayer"} ,
{5625,"Deadliest Catch Alaskan Storm"} ,
{5626,"Everlight of Magic & Power"} ,
{5627,"Rhiannon: Curse of the Four Branches"} ,
{5628,"Hell's Kitchen"} ,
{5629,"Grand Prix Legends"} ,
{5630,"Tomb Raider: Underworld Demo"} ,
{5631,"Rumble Fighter"} ,
{5632,"Avatar: Legends of the Arena"} ,
{5633,"Left 4 Dead"} ,
{5634,"Worldwide Soccer Manager 2009"} ,
{5635,"Need for Speed Undercover"} ,
{5636,"The Sims 2: Mansion and Garden Stuff"} ,
{5637,"Tomb Raider: Underworld"} ,
{5638,"Madagascar: Escape 2 Africa"} ,
{5639,"Lords of Evil"} ,
{5640,"Street Gears"} ,
{5641,"Dynasty Warriors 6"} ,
{5642,"FIFA Manager 09"} ,
{5643,"Pokemon World Online"} ,
{5644,"Eets"} ,
{5645,"Bodog Poker"} ,
{5646,"Mr. Robot"} ,
{5647,"AssaultCube"} ,
{5648,"Pyroblazer"} ,
{5649,"Mosby's Confederacy"} ,
{5650,"Eudemons Online"} ,
{5651,"Gothic III - Forsaken Gods"} ,
{5652,"Cross Fire"} ,
{5653,"Football Manager 2009"} ,
{5654,"Grand Theft Auto IV"} ,
{5655,"Shin Megami Tensei Imagine Online"} ,
{5656,"Shaun White Snowboarding"} ,
{5657,"Legendary"} ,
{5658,"Zero Online"} ,
{5659,"I-Fluid"} ,
{5660,"Desperados: Wanted Dead or Alive"} ,
{5661,"Defense Grid: The Awakening"} ,
{5662,"Jazz Jackrabbit 2"} ,
{5663,"Prince of Persia"} ,
{5664,"A Vampyre Story"} ,
{5665,"Secret Service: In Harm's Way"} ,
{5666,"Runes of Magic"} ,
{5667,"Iron Grip Warlord"} ,
{5668,"Florensia"} ,
{5669,"Rise of the Argonauts"} ,
{5671,"CSI: NY"} ,
{5672,"Depths of Peril"} ,
{5673,"BattleForge Beta"} ,
{5674,"Legacy"} ,
{5675,"Shaiya DE"} ,
{5676,"Mach 1 Demo"} ,
{5677,"Saints Row 2"} ,
{5678,"MashON SPORE Comic Book Creator"} ,
{5679,"Operation 7"} ,
{5680,"SecondEarth: Faction Wars"} ,
{5681,"Secondearth MMO"} ,
{5682,"Mirror's Edge"} ,
{5683,"The Lord of the Rings: Conquest"} ,
{5684,"La Tale"} ,
{5685,"The Chronicles of Spellborn"} ,
{5686,"Wizard 101"} ,
{5687,"Warhammer 40,000: Dawn of War II - Beta"} ,
{5688,"F.E.A.R. 2: Project Origin SP Demo"} ,
{5689,"Aquaria"} ,
{5690,"EDuke32"} ,
{5691,"PangYa"} ,
{5692,"18 Wheels of Steel American Long Haul"} ,
{5693,"MLB Front Office Manager"} ,
{5694,"Commander In Chief - Geopolitical Simulator 2009"} ,
{5695,"Tantra Global"} ,
{5696,"Colin McRae Rally 3"} ,
{5697,"Nexuiz"} ,
{5698,"Colin McRae Rally 2"} ,
{5699,"Jewel Quest 2"} ,
{5700,"Jewel Quest Solitaire"} ,
{5701,"Jewel Quest Solitaire 2"} ,
{5702,"Bejeweled Twist"} ,
{5703,"Kega Fusion"} ,
{5704,"Burnout Paradise: The Ultimate Box"} ,
{5705,"Galactic Civilizations II: Ultimate Edition"} ,
{5706,"X-Blades"} ,
{5707,"Everonia"} ,
{5708,"F.E.A.R. 2: Project Origin"} ,
{5709,"Perimeter 2: New Earth"} ,
{5710,"Neopets Puzzle Adventure"} ,
{5711,"Poker For Dummies"} ,
{5712,"Operation Mania"} ,
{5713,"Ace Online"} ,
{5714,"Littlest Pet Shop"} ,
{5715,"Multi Theft Auto: San Andreas"} ,
{5716,"Project of Planets"} ,
{5717,"Talisman Online"} ,
{5718,"Roblox"} ,
{5719,"Warhammer 40,000: Dawn of War II"} ,
{5721,"Drakensang: The Dark Eye"} ,
{5722,"ShellShock 2: Blood of Trails"} ,
{5723,"Tom Clancy's EndWar"} ,
{5724,"Puzzle Quest: Galactrix"} ,
{5725,"Driver: Parallel Lines"} ,
{5727,"Empire: Total War Demo"} ,
{5728,"Tom Clancy's H.A.W.X Demo"} ,
{5729,"The Last Remnant Demo"} ,
{5730,"Empire: Total War"} ,
{5732,"Football Manager Live"} ,
{5733,"Watchmen: The End Is Nigh"} ,
{5734,"ijji Splash Fighters"} ,
{5735,"Global Agenda Beta"} ,
{5736,"Major League Baseball 2K9"} ,
{5737,"Command & Conquer Red Alert 3: Uprising"} ,
{5738,"Darkfall"} ,
{5739,"Age of Booty"} ,
{5740,"Codename: Panzers - Cold War"} ,
{5741,"Grey's Anatomy"} ,
{5742,"Three Kingdoms"} ,
{5743,"The Story of Legends"} ,
{5799,"Men of War Multiplayer"} ,
{5744,"Men of War"} ,
{5745,"Tom Clancy's H.A.W.X. (DX10)"} ,
{5746,"Tom Clancy's H.A.W.X. (DX9)"} ,
{5747,"Ceville"} ,
{5748,"Priston Tale 2"} ,
{5749,"Magica Online"} ,
{5750,"Wanted: Weapons of Fate"} ,
{5751,"BattleForge"} ,
{5752,"The Last Remnant"} ,
{5753,"Wheelman"} ,
{5754,"Stormrise"} ,
{5755,"Fantasy Tennis 2"} ,
{5756,"Theatre of War"} ,
{5757,"Atmosphir Beta"} ,
{5758,"The Maw"} ,
{5759,"Dark Sector"} ,
{5760,"Wallace and Gromit Ep1: Fright of the Bumblebees"} ,
{5761,"Grand Ages Rome"} ,
{5762,"Trainz Simulator 2009: World Builder Edition"} ,
{5763,"The Chronicles of Riddick: Assault on Dark Athena"} ,
{5764,"Leisure Suit Larry: Box Office Bust"} ,
{5765,"Monsters vs. Aliens"} ,
{5766,"The Godfather II"} ,
{5767,"Penumbra: Requiem"} ,
{5768,"FLOCK!"} ,
{5769,"Braid"} ,
{5770,"Artifact"} ,
{5771,"Quake Live"} ,
{6015,"Elven Legacy: Siege"} ,
{5772,"Elven Legacy"} ,
{5773,"And Yet It Moves"} ,
{5774,"DCS: Black Shark"} ,
{5775,"Hard To Be a God"} ,
{5776,"Fistful of Frags"} ,
{5777,"Zeno Clash"} ,
{5778,"Free Realms"} ,
{5779,"X-Com Enforcer"} ,
{5780,"X-Com Interceptor"} ,
{5781,"Aion"} ,
{5782,"Battle Realms"} ,
{5783,"Scarygirl"} ,
{5784,"Cryostasis"} ,
{5785,"Age of Wonders II: The Wizard's Throne"} ,
{5786,"Velvet Assassin"} ,
{5787,"Stalin vs. Martians"} ,
{5788,"SnowBound Online"} ,
{5789,"X-Men Origins: Wolverine"} ,
{5790,"Dofus Arena"} ,
{5791,"Dragon Fable"} ,
{5792,"Plants Vs Zombies"} ,
{5793,"Ogame"} ,
{5794,"Football Superstars"} ,
{5795,"Puzzle Kingdoms"} ,
{5796,"Adventure Quest"} ,
{5797,"NecroVision"} ,
{5798,"MechQuest"} ,
{5800,"Dragonica"} ,
{5801,"ArchKnight"} ,
{5802,"Ikariam.org"} ,
{5803,"Battlestations Pacific"} ,
{5804,"Killing Floor"} ,
{5805,"Duels"} ,
{5806,"Travian"} ,
{5807,"Crayon Physics Deluxe"} ,
{5808,"Ikariam.com"} ,
{5809,"Muniz Online"} ,
{5810,"RockFREE"} ,
{5811,"Taikodom"} ,
{5812,"Terminator Salvation"} ,
{5813,"Legends of Zork"} ,
{5814,"Gaia Online"} ,
{5815,"Gladius II"} ,
{5816,"The Pimps"} ,
{5817,"Desktop Tower Defense"} ,
{5818,"Bebees"} ,
{5819,"Mafia 1930"} ,
{5820,"Tunnel Rats 1968"} ,
{5821,"UP"} ,
{5822,"Damnation"} ,
{5823,"Helldorado"} ,
{5824,"Death Track: Resurrection"} ,
{5825,"I Wanna Be the Guy"} ,
{5826,"Neo Steam"} ,
{5827,"Yosumin"} ,
{5828,"The Sims 3"} ,
{5829,"Rappelz Epic6"} ,
{5831,"After-Death"} ,
{5832,"Ether Saga Online"} ,
{5833,"Twelve Sky 2"} ,
{5834,"Dragonsky"} ,
{5835,"Officers"} ,
{5836,"Ys Online"} ,
{5837,"Damoria"} ,
{5838,"Prototype"} ,
{5839,"Age of Pirates 2"} ,
{5840,"Mo Siang Online (Singapore)"} ,
{5841,"Luna Online (Singapore)"} ,
{5842,"Spongebob"} ,
{5843,"Ghostbusters"} ,
{5844,"America's Army 3"} ,
{5845,"MLB Dugout Heroes"} ,
{5846,"Kicks Online"} ,
{5847,"Jade Dynasty"} ,
{5848,"Super Orbulite World"} ,
{5849,"New Grounds"} ,
{5850,"Kongregate"} ,
{5851,"SPORE Galactic Adventures"} ,
{5852,"Delta Force: Xtreme 2"} ,
{5853,"Transformers: Revenge of the Fallen"} ,
{5854,"Overlord II"} ,
{5855,"Unsigned"} ,
{5856,"ARMA 2"} ,
{5857,"Astro Empires"} ,
{5858,"Call of Juarez: Bound in Blood"} ,
{5859,"Ice Age: Dawn of the Dinosaurs"} ,
{5860,"Harry Potter and the Half-Blood Prince"} ,
{5861,"Sudden Attack"} ,
{5862,"ARMA 2 Demo"} ,
{5863,"WolfTeam"} ,
{5864,"Anno 1404: Dawn of Discovery"} ,
{5865,"Street Fighter IV"} ,
{5866,"Wordtrotter"} ,
{5867,"Trine"} ,
{5868,"Smashball"} ,
{5869,"Virtua Tennis 2009"} ,
{5870,"AddictingGames.com"} ,
{5871,"Dragonica EU"} ,
{5872,"Evony"} ,
{5874,"Galactic Arms Race"} ,
{5875,"Blood Bowl"} ,
{5876,"Fuel"} ,
{5877,"Droplitz"} ,
{5878,"Pro Cycling Manager Season 2009"} ,
{5879,"The Secret of Monkey Island"} ,
{5880,"Tribal Wars"} ,
{5881,"Luna Online"} ,
{5882,"Guitar Hero World Tour"} ,
{5883,"FunOrb"} ,
{5884,"Section 8 Beta"} ,
{5885,"InstantAction.com"} ,
{5886,"Wrestling MPire 2008 (Career Edition)"} ,
{5887,"Miniclip.com"} ,
{5888,"Mini Fighter"} ,
{5889,"Bejeweled 2"} ,
{5890,"NeoTokyo"} ,
{5891,"JamLegend"} ,
{5892,"Bionic Commando Rearmed"} ,
{5893,"Bionic Commando"} ,
{5894,"Allegiance"} ,
{5895,"Monato Esprit"} ,
{5896,"Watchmen: The End Is Nigh Part 2"} ,
{5897,"Bookworm Adventures Volume 2"} ,
{5898,"The Battle for Wesnoth"} ,
{6040,"East India Company: Battle of Trafalgar"} ,
{5990,"East India Company: Privateer"} ,
{5899,"East India Company"} ,
{5900,"Sudeki"} ,
{5901,"StarTopia"} ,
{5902,"Doukutsu Monogatari"} ,
{5903,"Alien Arena 2009"} ,
{5904,"Foreign Legion: Buckets of Blood"} ,
{5905,"Hearts of Iron III"} ,
{5906,"Nikopol: Secrets of the Immortals"} ,
{5907,"Huxley The Dystopia"} ,
{5908,"Zuma"} ,
{5909,"Peggle World of Warcraft Edition"} ,
{5910,"Heroes of Newerth"} ,
{5911,"Smash Online"} ,
{5912,"Freespace 2"} ,
{5913,"Wolfenstein Single Player"} ,
{5914,"Wolfenstein Multiplayer"} ,
{5915,"Champions Online"} ,
{5916,"Joint Operations: Combined Arms Gold"} ,
{5917,"Still Life 2"} ,
{5918,"The Sims 2 University Life Collection"} ,
{5919,"AI War"} ,
{5920,"CrimeCraft"} ,
{5921,"Divinity II: Ego Draconis"} ,
{5922,"Runaway Gift"} ,
{5923,"Raven Squad"} ,
{5924,"Tales Runner"} ,
{5925,"The Path"} ,
{5926,"XIII Century Gold Edition"} ,
{5927,"Section 8"} ,
{5928,"Mini Ninjas"} ,
{5929,"Berserk-Online"} ,
{5930,"ARENA Online"} ,
{5931,"AaaaaAAaaaAAAaaAAAAaAAAAA!!! - A Reckless Disregard for Gravity"} ,
{5932,"Camorra World"} ,
{5933,"Batman: Arkham Asylum"} ,
{5934,"Need for Speed SHIFT"} ,
{5935,"Red Faction: Guerrilla"} ,
{5936,"Darkest of Days"} ,
{5937,"Majesty 2: The Fantasy Kingdom Sim"} ,
{5938,"Resident Evil 5"} ,
{5939,"Krazy Aces"} ,
{5940,"Fallen Earth"} ,
{5941,"Dungeon Fighter Online"} ,
{5942,"Alliance of Valiant Arms"} ,
{5943,"Dekaron"} ,
{5944,"K.O.S. Secret Operations"} ,
{5945,"Ran Online"} ,
{5946,"League of Legends"} ,
{5947,"Operation Flashpoint: Dragon Rising"} ,
{5948,"Order of War"} ,
{5949,"Evochron Legends"} ,
{5950,"Risen"} ,
{5951,"Star Wars The Clone Wars: Republic Heroes"} ,
{5952,"FIFA 10"} ,
{5953,"Dragon Oath"} ,
{5954,"Soul of the Ultimate Nation"} ,
{5955,"Cities XL"} ,
{5956,"Madballs in... Babo:Invasion"} ,
{5957,"Heroes Over Europe"} ,
{5958,"NBA 2K10"} ,
{5959,"Prison Tycoon 3: Lockdown"} ,
{5960,"Return to Mysterious Island 2"} ,
{5961,"FATE - The Traitor Soul"} ,
{5962,"NosTale"} ,
{5963,"Tiny Tanks Online"} ,
{5964,"Red War: Edem's Curse"} ,
{5965,"Tropico 3"} ,
{5966,"Celtic Kings"} ,
{5967,"Parabellum"} ,
{5968,"Pro Evolution Soccer 2010 Demo"} ,
{5969,"Lucidity"} ,
{5970,"Pro Evolution Soccer 2010"} ,
{5971,"Borderlands"} ,
{5972,"World of Zoo"} ,
{5973,"Heroes of Gaia"} ,
{5974,"FarmVille"} ,
{5975,"Left 4 Dead 2 Demo"} ,
{5976,"Torchlight"} ,
{5977,"CSI: Deadly Intent"} ,
{5978,"Saw"} ,
{5979,"MDK"} ,
{5980,"MDK 2"} ,
{5981,"Football Manager 2010"} ,
{5982,"4 Elements"} ,
{5983,"FIFA Manager 10"} ,
{5984,"Painkiller: Resurrection"} ,
{5985,"Dragon Age: Origins"} ,
{5986,"Dragon Age Journeys"} ,
{5987,"Star Wars: The Force Unleashed"} ,
{5988,"Around the World in 80 Days"} ,
{5989,"Shattered Horizon"} ,
{5991,"LEGO Star Wars: The Complete Saga"} ,
{5992,"Call of Duty: Modern Warfare 2 Singleplayer"} ,
{5993,"Call of Duty: Modern Warfare 2 Multiplayer"} ,
{5994,"Jagged Alliance 2 Wildfire"} ,
{5995,"Championship Manager 2010"} ,
{5996,"Cricket Revolution"} ,
{5997,"Haegemonia"} ,
{5998,"Manhunt 2"} ,
{5999,"Mercenary Wars"} ,
{6000,"Bright Shadow"} ,
{6001,"Dreamkiller"} ,
{6002,"Fishdom"} ,
{6003,"Left 4 Dead 2"} ,
{6004,"The Sims 3: World Adventures"} ,
{6005,"Lego Indiana Jones 2: The Adventure Continues"} ,
{6006,"The Princess and the Frog"} ,
{6007,"18 Wheels of Steel Extreme Trucker"} ,
{6008,"Gyromancer"} ,
{6009,"Star Trek: D-A-C"} ,
{6010,"Allods Online"} ,
{6011,"911: First Responders"} ,
{6012,"Machinarium"} ,
{6013,"King's Bounty: Armored Princess"} ,
{6014,"The Chosen"} ,
{6016,"Mafia Wars"} ,
{6017,"Happy Aquarium"} ,
{6018,"Serious Sam HD: The First Encounter"} ,
{6019,"Rogue Warrior"} ,
{6020,"WorldShift"} ,
{6021,"James Cameron's AVATAR"} ,
{6022,"Tomb Raider: The Angel Of Darkness"} ,
{6023,"Osmos"} ,
{6024,"SpellForce2 - Dragon Storm"} ,
{6025,"Blood Bowl: Dark Elves Edition"} ,
{6026,"King Arthur - The Role-playing Wargame"} ,
{6027,"Hunting Unlimited 2008"} ,
{6028,"Earthworm Jim 3D"} ,
{6029,"Grand Fantasia"} ,
{6030,"Twin Sector"} ,
{6031,"The Saboteur"} ,
{6032,"DiRT2"} ,
{6033,"The Three Musketeers"} ,
{6034,"Zombie Driver"} ,
{6035,"Swashbucklers"} ,
{6036,"A.I.M. 2 Clan Wars"} ,
{6037,"War and Peace, 1796-1815"} ,
{6038,"The Warlords"} ,
{6039,"Elven Legacy: Magic"} ,
{6041,"Nodiatis"} ,
{6042,"Samoroft 2"} ,
{6043,"CakeMania 3"} ,
{6044,"eJay Techno 5"} ,
{6045,"Horse Racing Manager"} ,
{6046,"Wings Over Europe: Cold War Gone Hot"} ,
{6047,"Wonder King"} ,
};

char * GetGameName(unsigned int gameid)
{
	

	
	for (int i=0; i<sizeof(g_gameslist)/sizeof(TGame); i++){
		
		
		if (g_gameslist[i].gameid==gameid) return g_gameslist[i].name;
		
	}
	
	return 0;
}
/**
 

 //list was  stop at 4403 
 LongName=Superpower 2
ShortName=spower2
LauncherDirKey=HKEY_CURRENT_USER\Software\GolemLabs\Superpower2\Installdir
LauncherEXE=joshua.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4641]
LongName=Enter the Matrix
ShortName=etm
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{9CD92DB1-1B3B-4296-9456-93EA6BCAA4C5}\InstallLocation
LauncherEXE=Matrix.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=DISABLE_FOR_VISTA|USE_PRESENT|USE_SWAPCHAIN|ENABLE_MOUSE|USE_DINPUT_MOUSE


[4642]
LongName=Rollercoaster Tycoon
ShortName=rct
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Fish Technology Group\RollerCoaster Tycoon Setup\Path
LauncherEXE=rct.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=DDRAW2
InGameFlags=USE_DINPUT1


[4643]
LongName=Railroad Tycoon 3
ShortName=rrt3
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\RT3.EXE\Path
LauncherEXE=rt3.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
;InGameRenderer=D3D8


[4644_1]
LongName=Codename: Panzers, Phase 2
ShortName=panzers2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\CDV Software Entertainment AG\PANZERS - Phase2\English\target folder
LauncherDirAppend=\run
LauncherExe=PANZERS_PHASE_2.EXE
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=DISABLE_FOR_VISTA|USE_PRESENT|USE_SWAPCHAIN|ENABLE_MOUSE


[4644_2]
LongName=Codename: Panzers, Phase 2
ShortName=panzers2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\CDV Software Entertainment AG\PANZERS - Phase2\Deutsch\target folder
LauncherDirAppend=\run
LauncherExe=PANZERS_PHASE_2.EXE
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=DISABLE_FOR_VISTA|USE_PRESENT|USE_SWAPCHAIN|ENABLE_MOUSE


[4645]
LongName=Blitzkrieg
ShortName=blitz
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\CDV Software Entertainment AG\Blitzkrieg\English\target folder
LauncherDirAppend=\run
LauncherEXE=game.exe
InstallHint=bltzkrg.spy
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4646]
LongName=NHL 06
ShortName=nhl06
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\EA SPORTS\NHL06\Install Dir
LauncherExe=nhl06.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4647]
LongName=MVP Baseball 2005
ShortName=mvpb05
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\EA SPORTS\MVP Baseball 2005\Install Dir
LauncherExe=mvp2005.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4648]
LongName=Fable - The Lost Chapters
ShortName=fable
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft Games\Fable\1.0\SetupPath
LauncherExe=fable.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE


[4649_1]
LongName=Dawn of War Winter Assault
ShortName=wh40kwa
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{DD8408E9-9421-484F-979D-DB6361E3E828}\InstallLocation
LauncherExe=W40kWA.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_WINDOWS_INPUT
ChangeTolerance=6


[4649_2]
LongName=Dawn of War Winter Assault
ShortName=wh40kwa
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{83F12F73-D52E-40C0-93B1-463C311C4E17}\InstallLocation
LauncherExe=W40kWA.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_WINDOWS_INPUT
ChangeTolerance=6


[4649_3]
LongName=Dawn of War Winter Assault
ShortName=wh40kwa
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\THQ\Dawn of War\InstallLocation
LauncherExe=WinterAssault.exe
DetectExe[0]=WinterAssault.exe
DetectExe[1]=W40kWA.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE
ChangeTolerance=6


[4650_1]
LongName=Beats of Rage
ShortName=bor
LauncherDirDefault=C:\games\bor
LauncherEXE=beatsofrage.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4650_2]
LongName=Beats of Rage
ShortName=bor
LauncherDirDefault=C:\games\bor
LauncherEXE=bor.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4651]
LongName=Tiger Woods PGA Tour 06
ShortName=tw06
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\EA SPORTS\Tiger Woods PGA TOUR 06\Install Dir
LauncherDirAppend=\bin
LauncherExe=TW2006.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4652]
LongName=The Sims 2 Nightlife
ShortName=sims2n
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\EA GAMES\The Sims 2 Nightlife\Install Dir
LauncherExe=TSBin\Sims2EP2.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[4653]
LongName=Day of Defeat: Source
ShortName=dods
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\day of defeat source\HL2.exe
;LauncherPasswordArgs=+password %UA_GAME_HOST_PASSWORD%
LauncherNetworkArgs=+connect %UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT%"
InstallHint=steamapps\day of defeat source.gcf
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 300 %UA_LAUNCHER_EXTRA_ARGS%%UA_LAUNCHER_NETWORK_ARGS%
ServerStatusType=SOURCE
ServerGameName=Day of Defeat: Source
ServerEncodingType=UTF8
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE|USE_PRESENT|DISABLE_RELEASE


[4654]
LongName=Sacred Underworld
ShortName=sacredu
LauncherDirKey=HKEY_CURRENT_USER\Software\Ascaron Entertainment\Sacred Underworld\InstallLocation
LauncherExe=sacred.exe
InstallHint=bin\Addon\NetScript\QuestCode.bin
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4655]
LongName= 
ShortName=swbf2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{3D374523-CFDE-461A-827E-2A102E2AB365}\InstallLocation
LauncherDirAppend=\GameData
LauncherExe=BattlefrontII.exe
LauncherPasswordArgs=+Password %UA_GAME_HOST_PASSWORD%
LauncherNetworkArgs=+connect "%UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT%" %UA_LAUNCHER_PASSWORD_ARGS%
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
ServerStatusType=GS2
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|DISABLE_RELEASE|ENABLE_MOUSE|USE_DINPUT_MOUSE
ExcludeIPPorts=29900


[4656]
LongName=Call of Duty 2 Single Player Demo
ShortName=cod2spd
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Activision\Call of Duty 2 Demo\InstallPath
LauncherExe=cod2sp_s.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE
RunElevated=1


[4657]
LongName=Brothers in Arms EIB Demo
ShortName=biaeibd
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Ubisoft\Gearbox Software\BrothersInArmsEiBDemo\Folder
LauncherDirAppend=\system
LauncherExe=EiB.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_PRESENT


[4658]
LongName=FEAR Multiplayer Demo
ShortName=fearmpd
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{0C8CD594-4C26-4AD9-AEAB-C6245D8EA9EE}\InstallLocation
LauncherExe=FEARMPDemo.exe
LauncherPasswordArgs=+password %UA_GAME_HOST_PASSWORD%
LauncherNetworkArgs=+join %UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT% %UA_LAUNCHER_PASSWORD_ARGS%
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=DISABLE_RELEASE|USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE
ServerStatusType=GS
RunElevated=1


[4659]
LongName=Rome - Barbarian Invasion
ShortName=rtwbi
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\The Creative Assembly\Rome - Total War\InstallPath
LauncherExe=RomeTW-BI.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameRenderer=D3D8
InGameFlags=USE_PRESENT


[4660]
LongName=Dragonshard
ShortName=dshard
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Liquid Entertainment\Dragonshard\Install Path
LauncherExe=Dragonshard.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_WINDOWS_INPUT


[4661]
LongName=Brothers in Arms EIB
ShortName=biaeib
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Ubisoft\Gearbox Software\BrothersInArmsEiB\Folder
LauncherDirAppend=\system
LauncherExe=EiB.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_PRESENT


[4662]
LongName=Serious Sam 2
ShortName=ssam2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\SeriousSam2\UninstallString
LauncherDirTruncAt=Uninstall.exe
LauncherExe=sam2.exe
InstallHint=..\All_PC_01.gro
LauncherNetworkArgs=+connect %UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT% %UA_LAUNCHER_PASSWORD_ARGS%
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE
ServerStatusType=UT



[4666]
LongName=Rag Doll Kung Fu
ShortName=rdkungfu
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\rag doll kung fu\Rag_Doll_Kung_Fu_Steam.exe
InstallHint=steamapps\rag doll kung fu.gcf
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 1002 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|DISABLE_RELEASE


[4668]
LongName=MotoGP URT 3
ShortName=mgp3
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\THQ\MotoGP3\InstallPath
LauncherExe=motogp.exe
LauncherNetworkArgs=-connect %UA_GAME_HOST_NAME%
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
ServerStatusType=GS
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|DISABLE_RELEASE|ENABLE_MOUSE


[4669]
LongName=Ultimate Spider-Man
ShortName=uspidermn
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Activision\Ultimate Spider-Man\InstallPath
LauncherExe=USM.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4670]
LongName=X-Men Legends 2
ShortName=xmenl2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Activision\X-Men Legends 2\InstallPath
LauncherExe=XMen2.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=DISABLE_RELEASE|DISABLE_FOR_VISTA|ENABLE_MOUSE


[4671]
LongName=Blitzkrieg 2
ShortName=blitz2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\CDV Software Entertainment AG\Blitzkrieg 2\English\target folder
LauncherDirAppend=\EXE\bin
LauncherEXE=game.exe
InstallHint=B2_MAPEDITOR.EXE
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=DISABLE_RELEASE|DISABLE_FOR_VISTA|USE_PRESENT|USE_SWAPCHAIN|ENABLE_MOUSE


[4672]
LongName=18 Wheels of Steel Convoy
ShortName=18wosc
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\ValuSoft\18 WoS Convoy\TargetPath
LauncherDirTruncAt=convoy.exe
LauncherExe=convoy.exe
DetectExe=prism3d.exe
InstallHint=convoy.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL
InGameOGLTextureOffset=32000
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE


[4673]
LongName=Gangland
ShortName=gland
LauncherDirKey=HKEY_CURRENT_USER\Software\MediaMobsters\GANGLAND\Keys\InstallPath
LauncherDirAppend=\GangLand
LauncherExe=GANGLAND.EXE
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL
InGameOGLTextureOffset=32000


[4674]
LongName=Risk II
ShortName=risk2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\DEEPRED\GAMES\RISKII\PATH
LauncherExe=RISKII.EXE
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
LobbyGUID={FA868461-5093-11D2-A073-000C09595CC3}
LobbyType=DP


[4675]
LongName=Bet on Soldier
ShortName=bos
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Bet on Soldier_is1\InstallLocation
LauncherExe=bos.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=DISABLE_RELEASE|DISABLE_FOR_VISTA|USE_PRESENT|USE_SWAPCHAIN|ENABLE_MOUSE|USE_DINPUT_MOUSE


[4676]
LongName=Descent FreeSpace
ShortName=descentfs
LauncherDirDefault=C:\Games\Freespace
LauncherExe=fs.exe
InstallHint=freespace.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4677]
LongName=Prison Tycoon
ShortName=ptycoon
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valu Soft\Prison Tycoon\Directory
LauncherDirAppend=\data
LauncherExe=Prison Tycoon.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE


[4678]
LongName=Quake 4
ShortName=quake4
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\id\Quake 4\InstallPath
LauncherExe=Quake4.exe
LauncherRconArgs=+net_clientRemoteConsolePassword "%UA_GAME_RCON_PASSWORD%"
LauncherPasswordArgs=+password "%UA_GAME_HOST_PASSWORD%"
LauncherNetworkArgs=%UA_LAUNCHER_PASSWORD_ARGS% %UA_LAUNCHER_RCON_ARGS% +connect %UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT%
Launch=%UA_LAUNCHER_EXE_PATH% +disconnect %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
ServerStatusType=Q4
ServerGameName=Quake4 Final
ServerBroadcastPort=28004:4
InGameRenderer=OGL
InGameFlags=USE_DINPUT1|VERIFY_THREADID|ENABLE_MOUSE|USE_DINPUT_MOUSE
InGameOGLTextureOffset=32000
ExcludeIPPorts=1127,27650,50671
IdGameStatsClass=Quake 4 WinConsole
IdGameStatsCmd=ui_name;echo "timestamp:%TIMESTAMP%";condump %IDLOGFILENAME%;
IdGameStatsTimer=20000
GameClientDataType=GAMESTATS
IdLogFileName=xfire_stats.log
IdLogFileModDir=q4mp
ParseIdClientSide=1
DisableRawUpload=1
RunElevated=1


[4679]
LongName=Age of Empires III
ShortName=aoe3
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft Games\Age of Empires 3\1.0\SetupPath
LauncherEXE=age3.EXE
InstallHint=Campaign\Age 3 Tutorial\age3tutorial1.age3scn
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|CHECK_LISTENER|ENABLE_MOUSE


[4680_1]
LongName=Richard Burns Rally
ShortName=rbr
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\SCi Games\Richard Burns Rally\InstallPath\
LauncherExe=RichardBurnsRally.exe
DetectExe=RichardBurnsRally_SSE.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|DISABLE_RELEASE|DISABLE_FOR_VISTA


[4680_2]
LongName=Richard Burns Rally
ShortName=rbr
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\SCi Games\Richard Burns Rally\InstallPath\
LauncherExe=RichardBurnsRally.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|DISABLE_RELEASE|DISABLE_FOR_VISTA


[4681]
LongName=Indigo Prophecy
ShortName=indigop
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{A5C3379D-9638-40CE-B46C-015280B5801F}\InstallLocation
LauncherExe=Indigo Prophecy.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE|USE_PRESENT|BLOCK_ASYNC


[4682]
LongName=Vietcong 2
ShortName=vcong2
LauncherDirKey=HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Uninstall\Vietcong 2\UninstallString
LauncherDirTruncAt=uninstall.exe
LauncherExe=vietcong2.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
;InGameRenderer=D3D9
;InGameFlags=USE_PRESENT


[4683_1]
LongName=Call of Duty 2 Single Player
ShortName=cod2sp
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\common\call of duty 2\cod2sp_s.exe
InstallHint=steamapps\call of duty 2 content.ncf
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 2635 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE
RunElevated=1
 [4686]
LongName=LOTR Return of the King
ShortName=rotk
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\EA GAMES\LOTR The Return of the King tm\Install Dir
LauncherExe=ROTK.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE


[4687]
LongName=City of Villains
ShortName=cov
LauncherDirKey=HKEY_CURRENT_USER\Software\Cryptic\COH\Installation Directory
LauncherExe=CovUpdater.exe
DetectExe=cityofheroes.exe
InstallHint=CovUpdater.exe
CommandLineMustContain[0]=-project "Coh" -cov
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL
InGameOGLTextureOffset=32000
InGameFlags=ENABLE_MOUSE
DetectServer=FALSE
GameClientDataType=COH
RunElevated=1


[4688]
LongName=Heroes of the Pacific
ShortName=hotp
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Ubisoft\Heroes Of The Pacific\InstallPath
LauncherExe=Heroes.exe
InstallHint=Heroes of the Pacific.url
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE


[4689]
LongName=Fahrenheit
ShortName=fahrenheit
LauncherDirKey=HKEY_CURRENT_USER\Software\Atari\Fahrenheit\InstallDirectory
LauncherExe=Fahrenheit.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9


[4690]
LongName=City of Villains EU
ShortName=coveu
LauncherDirKey=HKEY_CURRENT_USER\Software\Cryptic\EUCOH\Installation Directory
LauncherExe=Covupdater.EU.exe
DetectExe=cityofheroes.exe
InstallHint=CovUpdater.EU.exe
CommandLineMustContain[0]=-project "EUCoh" -cov
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL
InGameOGLTextureOffset=32000
InGameFlags=ENABLE_MOUSE
DetectServer=FALSE
GameClientDataType=COH
RunElevated=1


[4691]
LongName=Shattered Union
ShortName=su
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\ShatteredUnion.exe\Path
LauncherExe=ShatteredUnion.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[4692]
LongName=X2 - The Threat
ShortName=x2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\X2 Key\Path
LauncherExe=X2.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4694_1]
LongName=Half-Life 2: Lost Coast
ShortName=hl2lc
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\half-life 2 lostcoast\hl2.exe
InstallHint=steamapps\lostcoast content.gcf
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 340 -console %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE


[4694_2]
LongName=Half-Life 2: Lost Coast
ShortName=hl2lc
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\lostcoast\HL2.exe
InstallHint=steamapps\lostcoast content.gcf
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 340 -console %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE


[4695]
LongName=Gun
ShortName=gun
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Activision\GUN\InstallPath
LauncherExe=Gun.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE|USE_PRESENT


[4696]
LongName=The Movies
ShortName=movies
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Lionhead Studios Ltd\TheMovies\InstallPath
LauncherExe=Movies.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE|DISABLE_RELEASE


[4697]
LongName=The Matrix - The Path of Neo
ShortName=mtpon
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{E571E8B1-9771-465D-9DE0-3BA2D1BDAE99}\InstallLocation
LauncherExe=Matrix3.exe
DetectExe=Matrix3W32S.bin
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=DISABLE_RELEASE|ENABLE_MOUSE|USE_DINPUT_MOUSE


[4698]
LongName=Contract JACK
ShortName=cjack
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\ContractJACK.exe\Path
LauncherExe=ContractJack.exe
DetectExe=Lithtech.exe
InstallHint=contractjack.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[4699]
LongName=BloodRayne
ShortName=brayne
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\rayne.exe\PATH
LauncherExe=rayne.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4700]
LongName=BloodRayne 2
ShortName=brayne2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{04CB9967-A8BB-468C-ABA6-CE87328712BE}\InstallLocation
LauncherExe=rayne2.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4701]
LongName=Sourceforts
ShortName=hl2sf
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=Steamapps\*\half-life 2 deathmatch\HL2.exe
InstallHint=steamapps\SourceMods\sourceforts\resource\sourceforts.ico
CommandLineMustContain="\sourcemods\Sourceforts"
LauncherPasswordArgs=+password %UA_GAME_HOST_PASSWORD%
LauncherNetworkArgs="%UA_LAUNCHER_PASSWORD_ARGS% +connect %UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT%"
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 320 -game "%UA_LAUNCHER_EXE_DIR%\steamapps\sourcemods\Sourceforts" %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
ServerStatusType=SOURCE
ServerGameName=SourceForts 1.9.4
ServerEncodingType=UTF8
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE


[4702]
LongName=Need for Speed: Most Wanted
ShortName=nfsmw
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\EA GAMES\Need for Speed Most Wanted\Install Dir
LauncherExe=speed.exe
InstallHint=NFSMW_icon.ico
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|DISABLE_RELEASE|ENABLE_MOUSE|USE_DINPUT_MOUSE


[4703]
LongName=John Deere North American Farmer
ShortName=jdnaf
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\JohnDeereNAF\Path
LauncherExe=JDNAF.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS%


[4705]
LongName=Worms 4 Mayhem
ShortName=worms4m
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Team17 Software Ltd\Worms 4 Mayhem\InstallDir
LauncherExe=launcher.exe
DetectExe=Worms 4 Mayhem.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4706]
LongName=Earth 2160
ShortName=e2160
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Reality Pump\Earth2160\FileSystem\OutputDir
LauncherExe=Earth2160_START.exe
DetectExe=Earth2160_SSE.exe
InstallHint=Earth2160_START.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[4707]
LongName=Sniper Elite
ShortName=snipere
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\SniperElite.exe\Path
LauncherExe=SniperElite.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE


[4708_1]
LongName=Peter Jackson's King Kong
ShortName=kkong
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{111E336D-30BF-4CD4-8D69-4541732AFB27}\InstallLocation
LauncherExe=SettingsApplication.exe
DetectExe=KingKong9.exe
InstallHint=KingKong9.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=BLOCK_ASYNC|ENABLE_MOUSE|USE_DINPUT_MOUSE


[4708_2]
LongName=Peter Jackson's King Kong
ShortName=kkong
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{111E336D-30BF-4CD4-8D69-4541732AFB27}\InstallLocation
LauncherExe=SettingsApplication.exe
DetectExe=KingKong8.exe
InstallHint=KingKong8.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=BLOCK_ASYNC|ENABLE_MOUSE|USE_DINPUT_MOUSE


[4709]
LongName=Crime Life
ShortName=clife
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{66ADCA6F-7107-4834-B96A-90ECDCAB7231}\InstallLocation
LauncherExe=crimelife.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4710]
LongName=Empire Earth II Art of Supremacy
ShortName=ee2aos
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{DF315348-721C-40B8-BAE2-58C6C7D935A2}\InstallLocation
LauncherExe=ee2x.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[4711]
LongName=Quake 4 Demo
ShortName=quake4dem
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\id\Quake 4 Demo\InstallPath
LauncherExe=Quake4.exe
InstallHint=Docs\QUAKE4_demo_readme.txt
LauncherRconArgs=+net_clientRemoteConsolePassword "%UA_GAME_RCON_PASSWORD%"
LauncherPasswordArgs=+password "%UA_GAME_HOST_PASSWORD%"
LauncherNetworkArgs=%UA_LAUNCHER_PASSWORD_ARGS% %UA_LAUNCHER_RCON_ARGS% +connect %UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT%
Launch=%UA_LAUNCHER_EXE_PATH% +disconnect %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
ServerStatusType=Q4
InGameRenderer=OGL
InGameFlags=USE_DINPUT1|ENABLE_MOUSE|USE_DINPUT_MOUSE
InGameOGLTextureOffset=32000
ExcludeIPPorts=1127,27650,50671
RunElevated=1


[4712]
LongName=Silkroad Online
ShortName=sro
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Joymax\Silkroad\InstallPath
LauncherExe=Silkroad.exe
;PlayingDetectType=ByWindow
;ProcessWindowTitle=SRO_Client
DetectExe=SRO_Client.exe
InstallHint=Silkroad.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
;InGameFlags=USE_PRESENT|VALIDATE_USING_EXE_NAME|DISABLE_DIRECT_INPUT_HOOK|ENABLE_MOUSE|USE_DINPUT_MOUSE|BLOCK_ASYNC|SKIP_DEVICE_RELEASE|DISABLE_RELEASE
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE|BLOCK_ASYNC|FORCE_REHOOK
DetectServer=FALSE
RunElevated=1


[4713_1]
LongName=Flyff
ShortName=flyff
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\GalaNet\Flyff\App Path
LauncherExe=flyff.exe
DetectExe=Neuz.exe
PlayingDetectType=ByWindow
ProcessWindowTitle=FLYFF
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|VALIDATE_USING_EXE_NAME|DISABLE_DIRECT_INPUT_HOOK|REINSTALL_KEYBOARD_HOOK|ENABLE_MOUSE|DISABLE_FOR_VISTA
DetectServer=FALSE
RunElevated=1


[4713_2]
LongName=Flyff
ShortName=flyff
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\GalaNetEu\Flyff\App Path
LauncherExe=flyff.exe
DetectExe=Neuz.exe
PlayingDetectType=ByWindow
ProcessWindowTitle=FLYFF
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|VALIDATE_USING_EXE_NAME|DISABLE_DIRECT_INPUT_HOOK|REINSTALL_KEYBOARD_HOOK|ENABLE_MOUSE|DISABLE_FOR_VISTA
DetectServer=FALSE
RunElevated=1


[4714]
LongName=Prince of Persia The Two Thrones
ShortName=popttt
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Ubisoft\Prince of Persia The Two Thrones\1.00.999\Product_Path
LauncherExe=PrinceOfPersia.exe
DetectExe=pop3.exe
InstallHint=pop3.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=DISABLE_RELEASE|DISABLE_FOR_VISTA|USE_PRESENT|USE_SWAPCHAIN|ENABLE_MOUSE|USE_DINPUT_MOUSE


[4715_1]
LongName=WarRock
ShortName=wrock
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Dream execution\WarRock\Executable
LauncherDirTruncAt=WRLauncher.exe
LauncherExe=wrlauncher.exe
DetectExe=System\WarRock.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE|BLOCK_ASYNC
DetectServer=False
RunElevated=1


[4715_2]
LongName=WarRock
ShortName=wrock
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\K2 Network\War Rock\install path
LauncherDirTruncAt=WRLauncher.exe
LauncherExe=WRLauncher.exe
DetectExe=System\WarRock.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE|BLOCK_ASYNC
DetectServer=False
RunElevated=1


[4715_3]
LongName=WarRock
ShortName=wrock
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{E397F6F0-AEE4-4236-BB05-1351350F8365}\InstallLocation
LauncherDirTruncAt=WRLauncher.exe
LauncherExe=WRLauncher.exe
DetectExe=System\WarRock.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE|BLOCK_ASYNC
DetectServer=False
RunElevated=1


[4716]
LongName=X3 - The Reunion
ShortName=x3
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{A8E414A8-9E31-40E6-B13B-5F1FCA00EF9F}\InstallLocation
LauncherExe=x3.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|DISABLE_RELEASE|ENABLE_MOUSE|USE_DINPUT_MOUSE


[4717]
LongName=Stubbs the Zombie
ShortName=stz
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Stubbs.exe\Path
LauncherExe=Stubbs.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE
InGameOGLTextureOffset=32000


[4718]
LongName=Pro Evolution Soccer 5
ShortName=pes5
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\KONAMIPES5\PES5\installdir
LauncherExe=PES5.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE


[4719]
LongName=Football Manager 2006
ShortName=fm2006
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{49CFD5D9-0556-4037-B7D6-E13ED4BEA4C5}\InstallLocation
LauncherExe=fm.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4720]
LongName=Star Trek Bridge Commander
ShortName=stbc
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Activision\Star Trek: Bridge Commander\V1.0\INSTALLPATH
LauncherExe=stbc.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=DDRAW
InGameFlags=USE_DINPUT1|DDRAW_FLIP_MODE|ENABLE_MOUSE|USE_DINPUT_MOUSE


[4721_1]
LongName=Advent Rising
ShortName=ar
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\common\advent rising\System\advent.exe
InstallHint=steamapps\advent rising content1.ncf
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 3800 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=ENABLE_MOUSE|USE_PRESENT



[4721_2]
LongName=Advent Rising
ShortName=ar
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Advent\UninstallString
LauncherDirTruncAt=Setup.exe uninstall "Advent"
LauncherExe=advent.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=ENABLE_MOUSE|USE_PRESENT


[4722]
LongName=UFO Aftershock
ShortName=ufoa
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\ALTAR\UFO Aftershock\Path
LauncherExe=UFO.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE
InGameOGLTextureOffset=32000


[4723_1]
LongName=NavyField
ShortName=nf
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\SDEnterNET\NAVYFIELDUS\Path
LauncherExe=NavyFIELD Launcher.exe
DetectExe=NAVYFIELD.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=DDRAW
InGameFlags=ENABLE_MOUSE
DetectServer=False


[4723_2]
LongName=NavyField
ShortName=nf
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\D:\NF\NavyFIELD.exe\Path
LauncherExe=NAVYFIELD.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=DDRAW
InGameFlags=ENABLE_MOUSE
DetectServer=False


[4724]
LongName=Rubies of Eventide
ShortName=roe
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Cyber Warrior\LithtechRubies\SourceDirectory
LauncherExe=Rubies.exe
DetectExe=Lithtech.exe
InstallHint=RubiesLauncher.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
DetectServer=False
InGameRenderer=D3D8
InGameFlags=USE_DINPUT1|ENABLE_MOUSE


[4725]
LongName=FIFA Manager 06
ShortName=fifam06
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\EA SPORTS\FIFA Manager 06\Install Dir
LauncherExe=fifam06.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=USE_DINPUT1|DISABLE_RELEASE|ENABLE_MOUSE|SUBCLASS_WNDPROC|USE_DINPUT_MOUSE


[4726]
LongName=Star Wars Empire at War
ShortName=sweaw
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\LucasArts\Star Wars Empire at War\1.0\ExePath
LauncherDirTruncAt=sweaw.exe
LauncherExe=sweaw.exe
InstallHint=PerceptionFunctionG.dll
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=DISABLE_RELEASE|USE_PRESENT|ENABLE_MOUSE


[4727]
LongName=Metal Gear Solid2 Substance
ShortName=mgs2s
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{2184D9EA-4E5B-43FD-914E-4563CF028C94}\InstallLocation
LauncherDirAppend=\bin
LauncherExe=mgs2.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=USE_PRESENT|DISABLE_RELEASE|ENABLE_MOUSE


[4728]
LongName=KumaWar
ShortName=kw
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Kuma\installed_dir
LauncherExe=KumaWar.exe
LauncherNetworkArgs=-c %UA_GAME_HOST_NAME% %UA_LAUNCHER_PASSWORD_ARGS%
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
ServerStatusType=GS2
InGameRenderer=D3D9
InGameFlags=BLOCK_ASYNC|DISABLE_RELEASE|ENABLE_MOUSE|USE_DINPUT_MOUSE|USE_DINPUT1|USE_PRESENT
ExcludeIPPorts=28900


[4729]
LongName=Heroes of Might and Magic III
ShortName=homm3
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\heroes3.exe\Path
LauncherExe=heroes3.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
LobbyGUID={8b743aa0-53b2-11d2-808a-00600895fb43}
LobbyType=DP


[4730]
LongName=Heroes of Might and Magic III Armageddon's Blade
ShortName=homm3ab
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\h3blade.exe\Path
LauncherExe=h3blade.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
LobbyGUID={19BD0A20-5B10-11D3-B7C6-005004B1F94B}
LobbyType=DP


[4731]
LongName=Rakion Chaos Force
ShortName=rcf
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Softnyx\RakionIS\Location
LauncherExe=NyxLauncher.exe
InstallHint=bin\rakion.bin
PlayingDetectType=ByWindow
ProcessWindowTitle=Rakion
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
RunElevated=1


[4732]
LongName=Midtown Madness
ShortName=mmad
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft Games\Midtown Madness\1.0\path
LauncherExe=midtown.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
LobbyGUID={6C9983A7-C037-11d2-A8DA-00A0C970AF5D}
LobbyType=DP


[4733]
LongName=Midtown Madness 2
ShortName=mmad2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft Games\Midtown Madness\2.0\InstallationDirectory
LauncherExe=Midtown2.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
LobbyGUID={46F6DDE2-0886-11d3-A8DA-00A0C970AF5D}
LobbyType=DP


[4734]
LongName=Monster Truck Madness 2
ShortName=mtmad2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft Games\Monster Truck Madness\2.0\InstalledPath
LauncherExe=Monster.EXE
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
LobbyGUID={6cd1c6e0-96fb-11d1-a268-00a02f29c995}
LobbyType=DP


[4735]
LongName=Motocross Madness 2
ShortName=mcmad2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft Games\Motocross Madness 2\HardDriveRootPath
LauncherExe=MCM2.EXE
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
LobbyGUID={184dbbc1-ff39-11cf-b112-00A0C90AEAB6}
LobbyType=DP


[4736]
LongName=Rainbow Six Lockdown Demo
ShortName=r6ld
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{70D52D20-82A5-43CC-85C1-C994FA2EC591}\InstallLocation
LauncherExe=lockdown.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE
RunElevated=1


[4737]
LongName=Star Wars Empire at War Demo
ShortName=sweawdem
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\LucasArts\Star Wars Empire at War Demo\1.0\ExePath
LauncherDirTruncAt=sweaw.exe
LauncherExe=sweaw.exe
InstallHint=PerceptionFunctionDemo.dll
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=DISABLE_RELEASE|USE_PRESENT|ENABLE_MOUSE


[4738]
LongName=Final Fantasy VII
ShortName=ff7
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Square Soft, Inc.\Final Fantasy VII\AppPath
LauncherExe=ff7.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4739]
LongName=Final Fantasy VIII
ShortName=ff8
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Square Soft, Inc\FINAL FANTASY VIII\1.00\AppPath
LauncherExe=ff8.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4740]
LongName=Battle for Middle-earth II Beta
ShortName=bfme2b
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Electronic Arts\Electronic Arts\The Battle for Middle-earth II Beta\InstallPath
LauncherExe=lotrbfme2beta.exe
DetectExe=game.dat
InstallHint=lotrbfme2beta.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|DISABLE_RELEASE|ENABLE_MOUSE


[4741]
LongName=Heroes of Might and Magic V Beta
ShortName=homm5b
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\H5_Game.exe\Path
LauncherDirAppend=\bin
LauncherExe=H5_Game.exe
InstallHint=system.pdb
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT


[4742]
LongName=MX vs ATV Unleashed Demo
ShortName=mxvsatvd
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{5E77082C-5DFC-42EF-9B16-64AD165F6BE2}\InstallLocation
LauncherExe=MXvsATV.exe
InstallHint=directx9\DXSETUP.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE


[4743]
LongName=FSW Ten Hammers
ShortName=fsw2th
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Full Spectrum Warrior 2\Path
LauncherExe=fsw2.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
;InGameRenderer=D3D9
;InGameFlags=USE_PRESENT


[4744]
LongName=MX vs ATV Unleashed
ShortName=mxvsatv
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\THQ\MXvsATV\Install\Path
LauncherExe=MXvsATV.exe
InstallHint=Unleashed Editor.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE


[4745_1]
LongName=Freecell
ShortName=winfcell
LauncherDirDefault=%ProgramW6432%\Microsoft Games\FreeCell
LauncherExe=FreeCell.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4745_2]
LongName=Freecell
ShortName=winfcell
LauncherDirDefault=%WINDIR%\system32
LauncherExe=freecell.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4745_3]
LongName=Freecell
ShortName=winfcell
LauncherDirDefault=%WINDIR%
LauncherExe=freecell.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4745_4]
LongName=Freecell
ShortName=winfcell
LauncherDirDefault=%ProgramFiles%\Microsoft Games\Freecell
LauncherExe=freecell.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4746_1]
LongName=Hearts
ShortName=winhearts
LauncherDirDefault=%ProgramW6432%\Microsoft Games\Hearts
LauncherExe=Hearts.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4746_2]
LongName=Hearts
ShortName=winhearts
LauncherDirDefault=%WINDIR%\system32
LauncherExe=mshearts.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4746_3]
LongName=Hearts
ShortName=winhearts
LauncherDirDefault=%WINDIR%
LauncherExe=mshearts.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4746_4]
LongName=Hearts
ShortName=winhearts
LauncherDirDefault=%ProgramFiles%\Microsoft Games\Hearts
LauncherExe=hearts.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4747]
LongName=Pinball
ShortName=winpball
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\pinball.exe\Path
LauncherExe=pinball.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4748]
LongName=Devastation
ShortName=devst
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\digitalo\Devastation\GamePath
LauncherExe=Devastation.exe
LauncherPasswordArgs=?Password=%UA_GAME_HOST_PASSWORD%
LauncherNetworkArgs=%UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT%%UA_LAUNCHER_PASSWORD_ARGS%
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE
ServerStatusType=ASE


[4749]
LongName=Heroes of Might and Magic IV
ShortName=homm4
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\New World Computing\Heroes of Might and Magic IV\1.0\AppPath
LauncherExe=heroes4.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4750]
LongName=Rainbow Six Lockdown
ShortName=r6l
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{3BB33584-3860-4772-AEE9-D8E61F552896}\InstallLocation
LauncherExe=lockdown.exe
LauncherNetworkArgs=-client %UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT%%UA_LAUNCHER_PASSWORD_ARGS%
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE
ServerStatusType=UT2K3
RunElevated=1


[4751]
LongName=Marc Ecko's Getting Up - Contents Under Pressure
ShortName=getup
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{B8F941EA-FC3E-4915-B5EB-E91A47BF3394}\InstallLocation
LauncherExe=_Bin\GettingUp.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[4752]
LongName=GT Legends
ShortName=gtl
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\10tacle Studios\GTL\InstallDir
LauncherExe=GTL.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE


[4753]
LongName=Trackmania Nations
ShortName=tmanian
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\TmNations_is1\Inno Setup: App Path
LauncherExe=TmNationsESWC.exe
LauncherLoginArgs=/internet /login=%UA_GAME_LOGIN_NAME% /password=%UA_GAME_LOGIN_PASSWORD%
LauncherNetworkArgs=/join=%UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT%
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_LOGIN_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE


[4754_1]
LongName=C&C Red Alert
ShortName=ccra
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Westwood\Red Alert Windows 95 Edition\InstallPath
LauncherDirTruncAt=RA95.EXE
LauncherExe=RA95.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4754_2]
LongName=C&C Red Alert
ShortName=ccra
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Electronic Arts\EA Games\Command and Conquer The First Decade\ra_folder
LauncherExe=RA95.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4755_1]
LongName=Command & Conquer
ShortName=cc
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Westwood\Command & Conquer Windows 95 Edition\InstallPath
LauncherDirTruncAt=C&C95.EXE
LauncherExe=C&C95.exe
Launch=%UA_LAUNCHER_EXE_PATH% -cdcovert %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4755_2]
LongName=Command & Conquer
ShortName=cc
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Electronic Arts\EA Games\Command and Conquer The First Decade\cc_folder
LauncherExe=C&C95.exe
Launch=%UA_LAUNCHER_EXE_PATH% -cdcovert %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4756_1]
LongName=SpaceCowboy
ShortName=spacecow
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{52A690A0-DC0A-4B80-B4D2-4E6D5C1C9B9C}\InstallLocation
LauncherExe=SpaceCowboy.exe
DetectExe=SpaceCowboy.atm
InstallHint=SpaceCowboy.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
DetectServer=FALSE


[4756_2]
LongName=SpaceCowboy
ShortName=spacecow
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{25877E67-56B9-47AE-B90C-3F47ACD10C52}\InstallLocation
LauncherExe=SpaceCowboy.exe
DetectExe=SpaceCowboy.atm
InstallHint=SpaceCowboy.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
DetectServer=FALSE


[4757]
LongName=Battle for Middle-earth II
ShortName=bfme2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Electronic Arts\Electronic Arts\The Battle for Middle-earth II\InstallPath
LauncherExe=lotrbfme2.exe
DetectExe=game.dat
InstallHint=lotrbfme2.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|DISABLE_RELEASE|ENABLE_MOUSE


[4758]
LongName=Toca Race Driver 3
ShortName=toca3
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Codemasters\Race Driver 3\PATH_APPLICATION
LauncherExe=RD3.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|DISABLE_FOR_VISTA|USE_SWAPCHAIN|ENABLE_MOUSE|USE_DINPUT_MOUSE
ExcludeIPPorts=27900


[4759_1]
LongName=RF Online
ShortName=rfo
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\RFOnline\DisplayIcon
LauncherDirTruncAt=RF.exe
LauncherExe=RF.exe
DetectExe=RF_Online.bin
InstallHint=Fireguard\fggm.ico
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=BLOCK_ASYNC|USE_PRESENT|ENABLE_MOUSE
RunElevated=1
DetectServer=FALSE


[4759_2]
LongName=RF Online
ShortName=rfo
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Codemasters\RF Online\ApplicationPath
LauncherExe=RF.exe
DetectExe=RF_Online.bin
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=BLOCK_ASYNC|USE_PRESENT|USE_WINDOWS_INPUT|USE_SWAPCHAIN|ENABLE_MOUSE
DetectServer=FALSE


[4760]
LongName=Cabela's Big Game Hunter 2006
ShortName=cbgh06
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Activision Value\Magic Wand\Cabela's Big Game Hunter 2006 Season\Path1
LauncherExe=bin\Bgh2006.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=USE_PRESENT|DISABLE_RELEASE|CHECK_LISTENER|ENABLE_MOUSE


[4761]
LongName=Deer Hunter 2003
ShortName=dh03
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Infogrames\Deer Hunter 2003\Install Path
LauncherDirAppend=\bin
LauncherExe=GameEXE.exe
InstallHint=Deer Hunter 2003.chm
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL
InGameFlags=DISABLE_RELEASE|ENABLE_MOUSE
InGameDelay=60000


[4762]
LongName=Deer Hunter 2004
ShortName=dh04
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Deer Hunter 2004_is1\Inno Setup: App Path
LauncherExe=DH2004.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[4763]
LongName=Deer Hunter 2005
ShortName=dh05
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Deer Hunter 2005_is1\Inno Setup: App Path
LauncherExe=DH2005.exe
LauncherPasswordArgs=-password:%UA_GAME_HOST_PASSWORD%
LauncherNetworkArgs=-connect:%UA_GAME_HOST_NAME% %UA_LAUNCHER_PASSWORD_ARGS%
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=USE_PRESENT|ENABLE_MOUSE
ServerStatusType=DH2K5


[4764]
LongName=Myst
ShortName=myst
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Myst.exe\Path
LauncherExe=Myst.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4765]
LongName=Riven
ShortName=riven
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Riven.exe\Path
LauncherExe=Riven.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4766]
LongName=Myst III Exile
ShortName=myst3
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\M3.exe\Path
LauncherDirAppend=\bin
LauncherExe=m3.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4767]
LongName=Myst IV Revelation
ShortName=myst4
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{96F702F3-7CA4-41B5-A70A-4F348DF99A9A}\InstallLocation
LauncherDirAppend=\bin
LauncherExe=myst4.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
;InGameRenderer=D3D9
;InGameFlags=USE_PRESENT


[4768]
LongName=Myst V End of Ages
ShortName=myst5
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\1947ed9c549f680a9ed3f1fdbb9337a4\UninstallString
LauncherDirTruncAt=_uninst\uninstaller.exe
LauncherExe=eoa.exe
InstallHint=MystV.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE|USE_PRESENT


[4769]
LongName=Auto Assault
ShortName=aa
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\NetDevilAutoAssault_is1\InstallLocation
LauncherExe=patcher\apppatcher.exe
DetectExe=exe\AutoAssault.exe
InstallHint=exe\AutoAssault.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT
DetectServer=FALSE


[4770]
LongName=Dungeons & Dragons Online - Stormreach
ShortName=ddo
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\15b35190-c6f9-11d9-9669-0800200c9a66_is1\InstallLocation
LauncherExe=dndlauncher.exe
DetectExe=dndclient.exe
InstallHint=dndclient.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_WINDOWS_INPUT|USE_PRESENT|USE_SWAPCHAIN|ENABLE_MOUSE|DISABLE_RELEASE
DetectServer=FALSE


[4771]
LongName=The Sims 2 Open for Business
ShortName=sims2ofb
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\EA GAMES\The Sims 2 Open For Business\Install Dir
LauncherExe=TSBin\Sims2EP3.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[4772]
LongName=SWAT 4 - The Stetchkov Syndicate
ShortName=swat4tss
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Sierra\SWAT 4 - The Stetchkov Syndicate\InstallPath
LauncherDirAppend=ContentExpansion\System
LauncherExe=Swat4X.exe
LauncherPasswordArgs=?Password=%UA_GAME_HOST_PASSWORD%
LauncherNetworkArgs=%UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT%%UA_LAUNCHER_PASSWORD_ARGS%
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
ServerStatusType=SWAT4
ServerEncodingType=UTF8
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE
ExcludeIPPorts=27900


[4773]
LongName=NCAA Championship Run 2006
ShortName=ncaacr06
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\WT007231\InstallLocation
LauncherExe=Basketball2006.exe
InstallHint=blimp\blimp.WTACTOR
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|DISABLE_RELEASE
DetectServer=FALSE


[4774]
LongName=The Elder Scrolls IV: Oblivion
ShortName=oblivion
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Bethesda Softworks\Oblivion\Installed Path
LauncherExe=OblivionLauncher.exe
DetectExe=Oblivion.exe
InstallHint=OblivionLauncher.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE
InGameDelay=20000
AlwaysFullScreen=1


[4775_1]
LongName=Dark Age of Camelot - Darkness Rising
ShortName=daocdr
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Dark Age of Camelot - Darkness Rising_is1\InstallLocation
LauncherExe=Camelot.exe
DetectExe=game.dll
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=BLOCK_ASYNC|USE_PRESENT|DISABLE_RELEASE|ENABLE_MOUSE|USE_DINPUT1
DetectServer=FALSE


[4775_2]
LongName=Dark Age of Camelot - Darkness Rising
ShortName=daocdr
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Dark Age of Camelot - Epic Edition_is1\InstallLocation
LauncherExe=Camelot.exe
DetectExe=game.dll
InstallHint=darkness.dat
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=BLOCK_ASYNC|USE_PRESENT|DISABLE_RELEASE|ENABLE_MOUSE|USE_DINPUT1
DetectServer=FALSE


[4776]
LongName=The Godfather
ShortName=godfthr
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Electronic Arts\The Godfather The Game\Install Dir
LauncherExe=godfather.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|DISABLE_RELEASE|ENABLE_MOUSE|USE_DINPUT_MOUSE


[4777_1]
LongName=Red Orchestra Ostfront 41-45 (Steam)
ShortName=ros
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=Steam.exe
LauncherPasswordArgs=?Password=%UA_GAME_HOST_PASSWORD%
LauncherNetworkArgs=%UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT%%UA_LAUNCHER_PASSWORD_ARGS%
DetectExe=SteamApps\common\red orchestra\System\RedOrchestra.exe
InstallHint=SteamApps\redorchestraclient.ncf
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 1200 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
ServerStatusType=UT2K3
InGameRenderer=D3D9
InGameFlags=USE_PRESENT
ExcludeIPPorts=80,6667,28902


[4777_2]
LongName=Red Orchestra Ostfront 41-45 (Steam)
ShortName=ros
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=Steam.exe
LauncherPasswordArgs=?Password=%UA_GAME_HOST_PASSWORD%
LauncherNetworkArgs=%UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT%%UA_LAUNCHER_PASSWORD_ARGS%
DetectExe=SteamApps\*\red orchestra\System\RedOrchestra.exe
InstallHint=SteamApps\redorchestraclient.gcf
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 1200 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
ServerStatusType=UT2K3
InGameRenderer=D3D9
InGameFlags=USE_PRESENT
ExcludeIPPorts=80,6667,28902


[4778]
LongName=Galactic Civilizations II
ShortName=gciv2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Stardock\Drengin.net\GalCiv2\Path
LauncherExe=GalCiv2.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|DISABLE_RELEASE|ENABLE_MOUSE


[4779]
LongName=Galactic Civilizations
ShortName=gciv
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Stardock\Drengin.net\GalCiv\Path
LauncherExe=galciv.exe
InstallHint=sfx\explosion1.wav
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4780]
LongName=Galactic Civilizations - The Altarian Prophecy
ShortName=gcivap
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Galactic Civilizations: The Altarian Prophecy\UninstallString
LauncherDirTruncAt=UNWISE.EXE E:\games\ALTARI~1\INSTALL.LOG
LauncherExe=galciv.exe
InstallHint=Lib3D.dll
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4781]
LongName=18 Wheels of Steel Across America
ShortName=18wosaa
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\ValuSoft\18 WoS AA\TargetPath
LauncherDirTruncAt=aa.exe
LauncherExe=aa.exe
DetectExe=prism3d.exe
InstallHint=prism3d.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL
InGameOGLTextureOffset=32000
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE


[4782_1]
LongName=Sin (Steam)
ShortName=sins
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=Steam.exe
DetectExe=SteamApps\*\valve test app 1313\sin.exe
InstallHint=SteamApps\sin 1 content.gcf
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 1313 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE
InGameOGLTextureOffset=32000


[4782_2]
LongName=Sin (Steam)
ShortName=sins
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=Steam.exe
DetectExe=SteamApps\*\sin 1\sin.exe
InstallHint=SteamApps\sin 1 content.gcf
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 1313 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE
InGameOGLTextureOffset=32000


[4783]
LongName=Sin Multiplayer (Steam)
ShortName=sinmps
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=Steam.exe
DetectExe=SteamApps\*\sin 1 multiplayer\sin.exe
InstallHint=SteamApps\sin 1 content.gcf
LauncherRconArgs=+rcon_password "%UA_GAME_RCON_PASSWORD%"
LauncherPasswordArgs=+password "%UA_GAME_HOST_PASSWORD%"
LauncherNetworkArgs=+connect %UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT% %UA_LAUNCHER_PASSWORD_ARGS% %UA_LAUNCHER_RCON_ARGS%
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 1309 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE
InGameOGLTextureOffset=32000


[4784]
LongName=SpellForce2 - Shadow Wars
ShortName=sforce2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{1A4E47DC-6701-4A85-AA16-C1F99A44598C}\InstallLocation
LauncherExe=spellforce2.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|DISABLE_RELEASE|ENABLE_MOUSE


[4785]
LongName=Commandos Strikeforce
ShortName=commsf
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{544DB849-AB59-4C12-A333-2F214E24870F}\InstallLocation
LauncherExe=CommXPC.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|DISABLE_RELEASE|ENABLE_MOUSE|USE_DINPUT_MOUSE


[4786]
LongName=Tomb Raider - Legend
ShortName=traidrl
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Crystal Dynamics\Tomb Raider: Legend\InstallPath
LauncherExe=trl.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|USE_SWAPCHAIN|ENABLE_MOUSE|USE_DINPUT_MOUSE


[4787]
LongName=The Sims 2 Family Fun Stuff
ShortName=sims2ffs
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\EA GAMES\The Sims 2 Family Fun Stuff\Install Dir
LauncherExe=TSBin\Sims2SP1.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5591]
LongName=Sword of the Stars: A Murder of Crows
ShortName=sotsmoc
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Sword of the Stars\InstallDir
LauncherExe=Sword of the Stars.exe
InstallHint=\Maps\Vortex.csv
LauncherNetworkArgs=/join %UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT%
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE
ServerStatusType=SOTS


[5439]
LongName=Sword of the Stars Collectors' Edition
ShortName=sotsce
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Sword of the Stars\InstallDir
LauncherExe=Sword of the Stars.exe
InstallHint=Sword of the Stars CE Manual.pdf
LauncherNetworkArgs=/join %UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT%
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE
ServerStatusType=SOTS


[4788_1]
LongName=Sword of the Stars
ShortName=sots
LauncherDirKey=HKEY_CURRENT_USER\Software\Sword of the Stars\InstallDir
LauncherExe=Sword of the Stars.exe
LauncherNetworkArgs=/join %UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT%
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|DISABLE_RELEASE|ENABLE_MOUSE|USE_DINPUT_MOUSE
ServerStatusType=SOTS


[4788_2]
LongName=Sword of the Stars
ShortName=sots
LauncherDirKey=HKEY_CURRENT_USER\Software\Sword of the Stars Beta Test\InstallDir
LauncherExe=Sword of the Stars.exe
LauncherNetworkArgs=/join %UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT%
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|DISABLE_RELEASE|ENABLE_MOUSE
ServerStatusType=SOTS


[4788_3]
LongName=Sword of the Stars
ShortName=sots
LauncherDirDefault=C:\games\Sword of the Stars
LauncherExe=Sword of the Stars.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|DISABLE_RELEASE|ENABLE_MOUSE
ServerStatusType=SOTS


[4788_4]
LongName=Sword of the Stars
ShortName=sots
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Sword of the Stars\UninstallString
LauncherDirTruncAt=Uninstall.exe
LauncherExe=Sword of the Stars.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|DISABLE_RELEASE|ENABLE_MOUSE
ServerStatusType=SOTS


[4789]
LongName=True Crime - New York City
ShortName=tcrimenyc
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Aspyr\True Crime New York City\Install\Path
LauncherDirTruncAt=\Data
LauncherExe=True Crime® New York City.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
;InGameRenderer=D3D8
;InGameFlags=DISABLE_RELEASE


[4790]
LongName=Shattered Galaxy
ShortName=shgal
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Nexon\TacticalCommanders\InstallFolder
LauncherExe=SG.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4791]
LongName=WWII Online
ShortName=ww2o
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Playnet\apps\appid5\instance1\Path
LauncherExe=Playgate.exe
DetectDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Playnet\apps\appid1\instance1\Path
DetectExe[0]=WW2_x86.exe
DetectExe[1]=ww2_sse2.exe
DetectExe[2]=WW2.exe
Launch=%UA_LAUNCHER_EXE_PATH% 1 1%UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4792]
LongName=Blazing Angels
ShortName=blang
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{2CBE667E-1193-47DC-852E-2CB4747C12E3}\InstallLocation
LauncherExe=CheckApplication.exe
DetectExe=bin\MainR.exe
InstallHint=bin\BlazingAngels Manual.pdf
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4793]
LongName=Heroes of Might and Magic V Demo
ShortName=homm5d
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{1898B8E5-43E2-4BCA-AD6A-B9FBE0C93F84}\InstallLocation
LauncherDirAppend=\bin
LauncherExe=H5_Game.exe
InstallHint=ss.bin
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT


[4794]
LongName=Titan Quest Demo
ShortName=tquestd
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Iron Lore\Titan Quest Demo\Install Location
LauncherExe=titan quest demo.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=DISABLE_RELEASE|USE_PRESENT|ENABLE_MOUSE


[4795]
LongName=Condemned - Criminal Origins
ShortName=condemned
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Monolith Productions\Condemned - Criminal Origins\1.00.0000\InstallDir
LauncherExe=Condemned.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4796]
LongName=2006 FIFA World Cup
ShortName=fifawc06
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\EA SPORTS\2006 FIFA World Cup\Install Dir
LauncherExe=FIFAWC06.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
;InGameRenderer=D3D8
;InGameFlags=USE_DINPUT1|DISABLE_RELEASE


[4797]
LongName=Dangerous Waters
ShortName=dwaters
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Sonalysts Combat Simulations\Dangerous Waters\1.0\cdInstallPath
LauncherExe=dangerouswaters.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4798]
LongName=Dune 2000
ShortName=d2000
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\DUNE2000.EXE\Path
LauncherExe=DUNE2000.EXE
DetectExe=dune2000.dat
InstallHint=DUNE2000.EXE
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=DDRAW2
InGameFlags=DDRAW_FLIP_MODE


[4799]
LongName=Emperor - Battle for Dune
ShortName=empbfd
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Emperor\UninstallString
LauncherDirTruncAt=Uninstll.EXE
LauncherExe=EMPEROR.EXE
DetectExe=Game.exe
InstallHint=emperor.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D7
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE|USE_DINPUT1


[4800]
LongName=Ghost Recon Advanced Warfighter Demo
ShortName=grawd
LauncherDirShortcut=CSIDL_PROGRAMS\Ubisoft\Ghost Recon Advanced Warfighter Demo\Play Ghost Recon Advanced Warfighter Demo.lnk
LauncherDirTruncAt=\GRAW_demo.exe
LauncherExe=GRAW_demo.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=DISABLE_RELEASE|ENABLE_MOUSE|USE_DINPUT_MOUSE|USE_PRESENT


[4801]
LongName=Sid Meier's Alpha Centauri
ShortName=smac
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\terran.exe\Path
LauncherExe=terran.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4802]
LongName=Winning Eleven 9
ShortName=we9
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\KONAMIWE9\WE9\installdir
LauncherExe=we9.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[4803_1]
LongName=Ghost Recon Advanced Warfighter
ShortName=graw
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Ubisoft\Ghost Recon Advanced Warfighter\InstalledPath
LauncherExe=GRAW.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=DISABLE_RELEASE|ENABLE_MOUSE|USE_DINPUT_MOUSE|USE_PRESENT
ServerStatusType=GS2


[4803_2]
LongName=Ghost Recon Advanced Warfighter
ShortName=graw
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\ghost recon advanced warfighter\graw.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 13640 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT
ServerStatusType=GS2


[4804]
LongName=Call of Cthulhu DCoTE
ShortName=coc
LauncherDirKey=HKEY_CURRENT_USER\Software\Bethesda Softworks\Call Of Cthulhu DCoTE\Settings\Executable
LauncherDirTruncAt=CoCMainWin32.exe
LauncherExe=CoCMainWin32.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[4805]
LongName=The Settlers IV
ShortName=settlers4
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\s4.exe\Path
LauncherExe=S4.exe
DetectExe=Exe\s4_main.exe
InstallHint=Exe\s4_main.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4806]
LongName=Hearts of Iron II Doomsday
ShortName=hoi2d
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Paradox Interactive\Doomsday\path
LauncherExe=hoi2.exe
InstallHint=\scenarios\1938.eug
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=DDRAW2
InGameFlags=DDRAW_FLIP_MODE


[4807]
LongName=UberSoldier
ShortName=ubers
LauncherDirShortcut=CSIDL_PROGRAMS\UberSoldier\UberSoldier.lnk
LauncherDirTruncAt=\xtend.exe
LauncherExe=xtend.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=DISABLE_RELEASE|ENABLE_MOUSE|USE_DINPUT_MOUSE


[4808]
LongName=Dungeon Keeper 2
ShortName=dkeeper2
LauncherDirShortcut=CSIDL_PROGRAMS\Bullfrog\Dungeon Keeper 2\Dungeon Keeper 2.lnk
LauncherDirTruncAt=\DKII.exe
LauncherExe=DKII.exe
DetectExe=DKII.icd
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4809]
LongName=Tycoon City - New York
ShortName=tcny
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{A5101403-2C42-40E0-8D9E-5E49E7C3B89E}\InstallLocation
LauncherExe=TycoonCity.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[4810]
LongName=Crashday
ShortName=cday
LauncherDirShortcut=CSIDL_PROGRAMS\Atari\Crashday\Crashday.lnk
LauncherDirTruncAt=\crashday.exe
LauncherExe=Crashday.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4811_1]
LongName=Titan Quest
ShortName=tquest
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Iron Lore\Titan Quest\Install Location
LauncherExe=Titan QuestD.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=DISABLE_RELEASE|USE_PRESENT|ENABLE_MOUSE


[4811_2]
LongName=Titan Quest
ShortName=tquest
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Iron Lore\Titan Quest\Install Location
LauncherExe=titan quest.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=DISABLE_RELEASE|USE_PRESENT|ENABLE_MOUSE


[4812]
LongName=Tony Hawk's American Wasteland
ShortName=thaw
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Aspyr\Tony Hawk's American Wasteland\Install\Path
LauncherExe=launcher.exe
DetectExe=game\thaw.exe
InstallHint=game\thaw.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4813]
LongName=Rise of Legends
ShortName=rol
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft Games\Rise Of Legends\SetupPath
LauncherExe=legends.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9


[4814]
LongName=Sin Episodes - Emergence
ShortName=sine1
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\sin episodes emergence\SinEpisodes.exe
InstallHint=steamapps\sinepisodes emergence.gcf
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 1300 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE|DISABLE_RELEASE


[4815_1]
LongName=Heroes of Might and Magic V
ShortName=homm5
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Ubisoft\Heroes of Might and Magic V\US\InstallPath
LauncherDirAppend=\bin
LauncherExe=H5_Game.exe
InstallHint=zlib1.dll
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[4815_2]
LongName=Heroes of Might and Magic V
ShortName=homm5
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Ubisoft\Heroes of Might and Magic V Collector Edition\US Limited\InstallPath
LauncherDirAppend=\bin
LauncherExe=H5_Game.exe
InstallHint=zlib1.dll
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[4815_3]
LongName=Heroes of Might and Magic V
ShortName=homm5
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Ubisoft\Heroes of Might and Magic V Collector Edition\European Collector\InstallPath
LauncherDirAppend=\bin
LauncherExe=H5_Game.exe
InstallHint=zlib1.dll
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[4815_4]
LongName=Heroes of Might and Magic V
ShortName=homm5
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\heroes of might and magic 5\bin\H5_Game.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 15170 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT


[4816]
LongName=City of Heroes Test Server
ShortName=cohts
LauncherDirKey=HKEY_CURRENT_USER\Software\Cryptic\CohTest\Installation Directory
LauncherExe=CohUpdater.exe
DetectExe=cityofheroes.exe
InstallHint=CohTest.checksum
CommandLineMustNotContain[0]=-project "CohTest" -cov
Launch=%UA_LAUNCHER_EXE_PATH% -test %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL
InGameOGLTextureOffset=32000
InGameFlags=ENABLE_MOUSE
DetectServer=FALSE
GameClientDataType=COH
RunElevated=1


[4817]
LongName=City of Villains Test Server
ShortName=covts
LauncherDirKey=HKEY_CURRENT_USER\Software\Cryptic\CohTest\Installation Directory
LauncherExe=CovUpdater.exe
DetectExe=cityofheroes.exe
InstallHint=CohTest.checksum
CommandLineMustContain[0]=-project "CohTest" -cov
Launch=%UA_LAUNCHER_EXE_PATH% -test %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL
InGameOGLTextureOffset=32000
DetectServer=FALSE
GameClientDataType=COH
RunElevated=1


[4818]
LongName=Dreamfall
ShortName=dfall
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{D751B34C-058F-42EF-BE95-14EBB0D2C585}\InstallLocation
LauncherExe=dreamfall.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[4819]
LongName=DawnOfMen
ShortName=dom
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\dawnofmen.exe\
LauncherDirTruncAt=DawnOfMen.exe
LauncherExe=DawnOfMen.exe
LauncherPasswordArgs=%UA_SPACE% -password %UA_GAME_HOST_PASSWORD%
LauncherNetworkArgs=%UA_SPACE% -connect IP:%UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT%%UA_LAUNCHER_PASSWORD_ARGS%
Launch=%UA_LAUNCHER_EXE_PATH% -online %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9


[4820]
LongName=GameTap
ShortName=gtap
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{67E158AF-8856-4337-B483-EA21930786AF}\DisplayIcon
LauncherDirTruncAt=gametap.exe
LauncherExe=gametap.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4821]
LongName=Hitman Blood Money
ShortName=htmnbm
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Eidos\Hitman Blood Money\InstallDir
LauncherExe=HitmanBloodMoney.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE|DISABLE_RELEASE


[4822]
LongName=Half-Life 2: Episode One
ShortName=hl2e1
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\half-life 2 episode one\HL2.exe
InstallHint=steamapps\half-life 2 episode one.gcf
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 380 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE


[4823]
LongName=Black & White 2 Battle of the Gods
ShortName=bw2bg
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\BattleOfTheGods.exe\Path
LauncherExe=BattleOfTheGods.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=DISABLE_RELEASE|USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[4824]
LongName=The Longest Journey
ShortName=tlj
LauncherDirKey=HKEY_CURRENT_USER\Software\Paper Sun\Roots\Program
LauncherExe=game.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4825_1]
LongName=Shadowgrounds
ShortName=shadowg
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Shadowgrounds_is1\InstallLocation
LauncherExe=Shadowgrounds.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=DISABLE_RELEASE|ENABLE_MOUSE|USE_DINPUT_MOUSE


[4825_2]
LongName=Shadowgrounds
ShortName=shadowg
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\common\shadowgrounds\shadowgrounds.exe
InstallHint=steamapps\shadowgrounds content.ncf
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 2500 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=DISABLE_RELEASE|ENABLE_MOUSE|USE_DINPUT_MOUSE


[4826]
LongName=The Da Vinci Code
ShortName=tdvc
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{851367C1-2F9F-4087-B3E8-8DECFE328370}\InstallLocation
LauncherDirAppend=\_bin
LauncherExe=Slayer.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4827]
LongName=Star Trek Armada II
ShortName=starm2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Activision\Star Trek Armada II\v1.0\INSTALLPATH
LauncherExe=armada2.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8


[4828]
LongName=Star Trek Away Team
ShortName=stat
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Activision\Star Trek Away Team\v1.0\INSTALLPATH
LauncherExe=Star Trek.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4829]
LongName=Hidden: Source
ShortName=hl2hs
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\source sdk base\HL2.exe
CommandLineMustContain[0]="\SourceMods\hidden"
InstallHint=steamapps\SourceMods\hidden\resource\Hidden.ttf
LauncherPasswordArgs=+password %UA_GAME_HOST_PASSWORD%
LauncherNetworkArgs="%UA_LAUNCHER_PASSWORD_ARGS% +connect %UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT%"
Launch=%UA_LAUNCHER_EXE_PATH% -gameidlaunch 9826266959967158487 -game "%UA_LAUNCHER_EXE_DIR%\steamapps\sourcemods\hidden" %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
ServerStatusType=SOURCE
ServerGameName=Hidden : Source B4
ServerEncodingType=UTF8
InGameRenderer=D3D9


[4830_1]
LongName=Goldeneye: Source
ShortName=hl2ge
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\source sdk base\HL2.exe
CommandLineMustContain[0]="\sourcemods\gesource"
InstallHint=steamapps\SourceMods\gesource\resource\gesource.ttf
LauncherPasswordArgs=+password %UA_GAME_HOST_PASSWORD%
LauncherNetworkArgs="%UA_LAUNCHER_PASSWORD_ARGS% +connect %UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT%"
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 215 -game "%UA_LAUNCHER_EXE_DIR%\steamapps\sourcemods\gesource" %UA_LAUNCHER_EXTRA_ARGS% a%UA_LAUNCHER_NETWORK_ARGS%
ServerStatusType=SOURCE
ServerGameName=GES-DM
ServerEncodingType=UTF8
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE|USE_PRESENT


[4830_2]
LongName=Goldeneye: Source
ShortName=hl2ge
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\half-life 2\HL2.exe
CommandLineMustContain[0]="\SourceMods\Goldeneye"
InstallHint=steamapps\SourceMods\Goldeneye\resource\gesource.ttf
LauncherPasswordArgs=+password %UA_GAME_HOST_PASSWORD%
LauncherNetworkArgs="%UA_LAUNCHER_PASSWORD_ARGS% +connect %UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT%"
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 220 -game "%UA_LAUNCHER_EXE_DIR%\steamapps\sourcemods\goldeneye" %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
ServerStatusType=SOURCE
ServerGameName=GES-DM
ServerEncodingType=UTF8
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE|USE_PRESENT


[4831]
LongName=Kreedz Climbing
ShortName=hl2kc
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\source sdk base\HL2.exe
CommandLineMustContain[0]="\sourcemods\kzmod"
InstallHint=steamapps\SourceMods\kzmod\resource\kzmod.tga
LauncherPasswordArgs=+password %UA_GAME_HOST_PASSWORD%
LauncherNetworkArgs="%UA_LAUNCHER_PASSWORD_ARGS% +connect %UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT%"
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 215 -game "%UA_LAUNCHER_EXE_DIR%\steamapps\sourcemods\kzmod" %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
ServerStatusType=SOURCE
ServerGameName=Kreedz Climbing Beta 4.1
ServerEncodingType=UTF8
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE
RunElevated=1


[4832_1]
LongName=Empires
ShortName=hl2emp
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\source sdk base 2007\HL2.exe
CommandLineMustContain[0]="\SourceMods\empires"
InstallHint=steamapps\SourceMods\Empires\resource\empiresd.ttf
LauncherPasswordArgs=+password %UA_GAME_HOST_PASSWORD%
LauncherNetworkArgs="%UA_LAUNCHER_PASSWORD_ARGS% +connect %UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT%"
Launch=%UA_LAUNCHER_EXE_PATH% -gameidlaunch 9672256695522296026 -game "%UA_LAUNCHER_EXE_DIR%\SteamApps\SourceMods\empires" %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
ServerStatusType=SOURCE
ServerGameName=Empires v2.22
ServerEncodingType=UTF8
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE


[4832_2]
LongName=Empires
ShortName=hl2emp
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\source sdk base\HL2.exe
CommandLineMustContain[0]="\SourceMods\empires"
InstallHint=steamapps\SourceMods\Empires\resource\empiresd.ttf
LauncherPasswordArgs=+password %UA_GAME_HOST_PASSWORD%
LauncherNetworkArgs="%UA_LAUNCHER_PASSWORD_ARGS% +connect %UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT%"
Launch=%UA_LAUNCHER_EXE_PATH% -gameidlaunch 14521852205289439447 -game "%UA_LAUNCHER_EXE_DIR%\SteamApps\SourceMods\empires" %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
ServerStatusType=SOURCE
ServerGameName=Empires v2.22
ServerEncodingType=UTF8
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE


[4833]
LongName=Rogue Squadron
ShortName=swrs
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\LucasArts Entertainment Company LLC\Rogue Squadron\v1.0\Install Path
LauncherExe=Rogue Squadron.EXE
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4834]
LongName=Star Wars Starfighter
ShortName=swsf
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\LucasArts Entertainment Company LLC\Star Wars Starfighter\1.0\Install Path
LauncherDirAppend=\game
LauncherExe=europa.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[4835]
LongName=Stacked
ShortName=stacked
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Stacked with Daniel Negreanu_is1\InstallLocation
LauncherExe=Stacked.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[4836]
LongName=Asheron's Call
ShortName=ashc
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{01501EBA-EC35-4F9F-8889-3BE346E5DA13}\InstallSource
LauncherExe=aclauncher.exe
DetectExe=acclient.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
DetectServer=FALSE


[4837]
LongName=The Movies Stunts & Effects
ShortName=moviesse
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Lionhead Studios Ltd\TheMovies Stunts & Effects\InstallPath
LauncherExe=MoviesSE.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE|DISABLE_RELEASE


[4838]
LongName=SimCity 3000
ShortName=sc3
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\SC3.exe\Path
LauncherExe=SC3.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4840]
LongName=Game Tycoon
ShortName=gtycoon
LauncherDirShortcut=CSIDL_PROGRAMS\Game Tycoon\Game Tycoon.lnk
LauncherDirTruncAt=\Game_Tycoon.exe
LauncherExe=Game_Tycoon.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE|USE_PRESENT


[4841]
LongName=Total Overdose
ShortName=tod
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Eidos\Total Overdose\InstallDir
LauncherExe=TOD.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[4842]
LongName=Rush For Berlin
ShortName=rfb
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\RushForBerlin.exe\Path
LauncherExe=RushForBerlin.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|DISABLE_FOR_VISTA|USE_SWAPCHAIN|ENABLE_MOUSE


[4843]
LongName=Xpand Rally
ShortName=xrally
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{252436F1-9583-4AD7-AA11-619AFFB96543}\InstallLocation
LauncherExe=xpandrally.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE|DISABLE_RELEASE


[4844]
LongName=Locomotion
ShortName=loco
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Atari\Locomotion Setup\Path
LauncherExe=Loco.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4845]
LongName=Dungeon Lords
ShortName=dlords
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{F41D7749-D973-42E7-BD80-64309766C39E}\InstallLocation
LauncherExe=dlords.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT


[4846]
LongName=Trainz Railroad Simulator 2006
ShortName=trs2006
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\TRS2006.exe\Path
LauncherExe=bin\Trainz.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE
InGameOGLTextureOffset=32000


[4847]
LongName=Freedom Fighters
ShortName=ffighters
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Electronic Arts\Freedom\InstallDir
LauncherExe=Freedom.Exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE


[4848]
LongName=Prey Demo
ShortName=preyd
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{C6E70A7A-2A2F-4E3E-B99A-C4B488314306}\InstallLocation
LauncherExe=prey.exe
InstallHint=base\demo00.pk4
LauncherPasswordArgs=+password "%UA_GAME_HOST_PASSWORD%"
LauncherNetworkArgs=%UA_LAUNCHER_PASSWORD_ARGS% %UA_LAUNCHER_RCON_ARGS% +connect %UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT%
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL
InGameFlags=USE_DINPUT1|ENABLE_MOUSE|USE_DINPUT_MOUSE
InGameOGLTextureOffset=32000
ServerStatusType=Q4
RunElevated=1


[4849]
LongName=Onimusha 3
ShortName=oni3
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\CAPCOM\ONIMUSHA3 PC\1.00.000\InstallPath
LauncherExe=oni3.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[4850]
LongName=Warsow
ShortName=warsow
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{24508D50-EB8F-4FE6-B69D-B4935D8745EF}_is1\Inno Setup: App Path
LauncherExe=warsow_x86.exe
LauncherRconArgs=+rcon_password "%UA_GAME_RCON_PASSWORD%"
LauncherPasswordArgs=+password "%UA_GAME_HOST_PASSWORD%"
LauncherNetworkArgs=+connect %UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT% %UA_LAUNCHER_PASSWORD_ARGS% %UA_LAUNCHER_RCON_ARGS%
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
ServerStatusType=Q2
InGameRenderer=OGL
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE|USE_DINPUT1
InGameOGLTextureOffset=32000


[4851]
LongName=Albatross18
ShortName=alb18
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\OGPlanet\Albatross18\Install_Dir
LauncherExe=Update.exe
DetectExe=ProjectG.exe
PlayingDetectType=ByWindowSubstr
ProcessWindowTitle=Albatross18
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=VALIDATE_USING_EXE_NAME|DISABLE_DIRECT_INPUT_HOOK|DISABLE_RELEASE
RunElevated=1


[4852]
LongName=Sprint Cars: Road to Knoxville
ShortName=scrtk
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{86076752-37A4-41E6-BFC4-73186683AF7B}\InstallLocation
LauncherExe=sc2007.exe
LauncherUsernameArgs=-name %UA_GAME_HOST_USERNAME%
LauncherNetworkArgs=-connect %UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT% %UA_LAUNCHER_USERNAME_ARGS% %UA_LAUNCHER_PASSWORD_ARGS%
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
ServerStatusType=SCRTK
ServerGameName=sc2007
ServerBroadcastPort=37020:10
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[4853]
LongName=Hitman - Codename 47
ShortName=htmnc47
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\hitman.exe\
LauncherDirTruncAt=hitman.exe
LauncherExe=Hitman.Exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4854]
LongName=The Suffering Ties That Bind
ShortName=tsttb
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Surreal\Suffering2\Installation
LauncherExe=SufferingTTB.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[4855]
LongName=Rise & Fall
ShortName=rfcaw
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{D078226E-83F2-45FD-9CDE-5DA66E5ADB51}\InstallLocation
LauncherExe=RiseAndFall.exe
Launch=%UA_LAUNCHER_EXE_PATH%  -datapath "data\" -redistpath "redist\" -nodump %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4856_1]
LongName=City Life
ShortName=citylife
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\common\city life\BIN\citylife.exe
InstallHint=steamapps\city life content.ncf
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 4400 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|DISABLE_FOR_VISTA|ENABLE_MOUSE|USE_DINPUT_MOUSE


[4856_2]
LongName=City Life
ShortName=citylife
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Monte Cristo\City Life\HD_PATH
LauncherDirAppend=\bin
LauncherExe=citylife.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|DISABLE_FOR_VISTA|ENABLE_MOUSE|USE_DINPUT_MOUSE


[4857]
LongName=Rogue Trooper
ShortName=roguet
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Eidos\Rogue Trooper\Directory
LauncherExe=RogueTrooper.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[4858_1]
LongName=Prey
ShortName=prey
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\common\prey\prey.exe
InstallHint=steamapps\prey content.ncf
LauncherPasswordArgs=+password "%UA_GAME_HOST_PASSWORD%"
LauncherNetworkArgs=%UA_LAUNCHER_PASSWORD_ARGS% %UA_LAUNCHER_RCON_ARGS% +connect %UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT%
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 3970 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL
InGameOGLTextureOffset=32000
InGameFlags=USE_DINPUT1|ENABLE_MOUSE|USE_DINPUT_MOUSE
ServerStatusType=Q4
ExcludeIPPorts=27650
RunElevated=1


[4858_2]
LongName=Prey
ShortName=prey
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Human Head Studios\Prey\InstallExe
LauncherDirTruncAt=prey.exe
LauncherExe=prey.exe
InstallHint=base\game00.pk4
LauncherPasswordArgs=+password "%UA_GAME_HOST_PASSWORD%"
LauncherNetworkArgs=%UA_LAUNCHER_PASSWORD_ARGS% %UA_LAUNCHER_RCON_ARGS% +connect %UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT%
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL
InGameOGLTextureOffset=32000
InGameFlags=USE_DINPUT1|ENABLE_MOUSE|USE_DINPUT_MOUSE
ServerStatusType=Q4
ExcludeIPPorts=27650
RunElevated=1


[4859]
LongName=NFL Head Coach
ShortName=nflhc
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\EA SPORTS\NFL Head Coach\Install Dir
LauncherExe=CoachFinal.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[4860]
LongName=Act of War - High Treason
ShortName=actwarht
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{C08EBBFD-C565-472F-9354-5593B9873705}\DisplayIcon
LauncherDirTruncAt=ActOfWar_HighTreason.exe
LauncherExe=ActOfWar_HighTreason.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[4861]
LongName=The Ship
ShortName=ship
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\the ship\Ship.exe
InstallHint=steamapps\the ship.gcf
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 2400 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[4862]
LongName=X-Wing Alliance
ShortName=xwinga
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Alliance.EXE\Path
LauncherExe=XWINGALLIANCE.EXE
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=DDRAW2
InGameFlags=DDRAW_FLIP_MODE


[4863]
LongName=Hero Online
ShortName=heroo
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Hero.exe\Path
LauncherExe=launcher.exe
DetectExe=Hero.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|DISABLE_FOR_VISTA|ENABLE_MOUSE|BLOCK_ASYNC
DetectServer=FALSE


[4864]
LongName=Land of the Dead
ShortName=lotd
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Unreal Technology\Installed Apps\LandOfTheDead\Folder
LauncherDirAppend=\system
LauncherExe=lotd.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_NETWORK_ARGS% %UA_LAUNCHER_EXTRA_ARGS%
ServerStatusType=UT2K3
InGameRenderer=D3D8
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE


[4865]
LongName=Sword of the Stars Demo
ShortName=sotsd
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Sword of the Stars Demo\UninstallString
LauncherDirTruncAt=Uninstall.exe
LauncherExe=Sword of the Stars Demo.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|DISABLE_RELEASE|DISABLE_FOR_VISTA|ENABLE_MOUSE


[4866_1]
LongName=Civilization IV - Warlords
ShortName=civ4w
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Firaxis Games\Sid Meier's Civilization 4 - Warlords\INSTALLDIR
LauncherExe=Civ4Warlords.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[4866_2]
LongName=Civilization IV - Warlords
ShortName=civ4w
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Firaxis Games\Sid Meier's Civilization 4 Gold\INSTALLDIR
LauncherDirAppend=\Warlords
LauncherExe=Civ4Warlords.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[4867]
LongName=CivCity Rome
ShortName=civcr
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\civcity rome.exe\Path
LauncherExe=CivCity Rome.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[4868]
LongName=OutRun2006 Coast 2 Coast
ShortName=or06c2c
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{839911F0-D9CB-400F-AE78-5D8264F38C42}\InstallLocation
LauncherExe=OR2006C2C.EXE
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[4869]
LongName=Glory of the Roman Empire
ShortName=gotre
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\CDV Software Entertainment AG\Glory of the Roman Empire\English\target folder
LauncherDirAppend=\run
LauncherExe=Glory.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=VALIDATE_USING_EXE_NAME|USE_PRESENT|USE_SWAPCHAIN|ENABLE_MOUSE


[4870]
LongName=Sacrifice
ShortName=sfice
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Shiny Entertainment\Sacrifice\InstallDir
LauncherExe=Sacrifice.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4871]
LongName=MechWarrior 3
ShortName=mw3
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\MicroProse\MechWarrior 3\1.0\Program
LauncherExe=Mech3.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
LobbyGUID={9F878D00-6CBB-11D1-9ABD-0060089877F0}
LobbyType=DP


[4872]
LongName=Dawn of War Dark Crusade
ShortName=wh40kdc
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\THQ\Dawn Of War - Dark Crusade\InstallLocation
LauncherExe=DarkCrusade.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_WINDOWS_INPUT
ChangeTolerance=6


[4873]
LongName=MechWarrior 4 Black Knight
ShortName=mw4bk
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft Games\MechWarrior Black Knight\EXE Path
LauncherDirAppend=\mw4x
LauncherExe=mw4x.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
LobbyGUID={6C63E49C-8BFC-44d4-A4E5-2E55472A93D3}
LobbyType=DP


[4874]
LongName=Dungeon Siege II Broken World
ShortName=ds2bw
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\2K Games\Dungeon Siege 2 Broken World\InstallationDirectory
LauncherExe=DungeonSiege2.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[4875_1]
LongName=Flatout 2
ShortName=fo2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{4E6D2462-AB33-40BB-AA9F-3FA3E0DD0290}\InstallLocation
LauncherExe=flatout2.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|REINSTALL_KEYBOARD_HOOK
DetectServer=FALSE


[4875_2]
LongName=Flatout 2
ShortName=fo2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\flatout2\FlatOut2.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 2990 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|REINSTALL_KEYBOARD_HOOK
DetectServer=FALSE


[4876]
LongName=Untold Legends: Dark Kingdom
ShortName=uldk


[4877_1]
LongName=Hellgate: London
ShortName=hgl
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Flagship Studios\Hellgate London\HellgateKey
LauncherExe=Launcher.exe
DetectExe[0]=MP_x86\hellgate_mp_dx9_x86.exe
DetectExe[1]=MP_x86\hellgate_mp_dx10_x86.exe
DetectExe[2]=SP_x86\hellgate_sp_dx9_x86.exe
DetectExe[3]=SP_x86\hellgate_sp_dx10_x86.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer[0]=D3D9
InGameRenderer[1]=D3D10
InGameRenderer[2]=D3D9
InGameRenderer[3]=D3D10
InGameFlags[0]=USE_PRESENT|USE_SWAPCHAIN|DISABLE_RELEASE|ENABLE_MOUSE|SUBCLASS_WNDPROC|BLOCK_ASYNC
InGameFlags[1]=ENABLE_MOUSE|SUBCLASS_WNDPROC|BLOCK_ASYNC
InGameFlags[2]=USE_PRESENT|USE_SWAPCHAIN|DISABLE_RELEASE|ENABLE_MOUSE|SUBCLASS_WNDPROC|BLOCK_ASYNC
InGameFlags[3]=ENABLE_MOUSE|SUBCLASS_WNDPROC|BLOCK_ASYNC
DetectServer=FALSE
AlwaysFullScreen=1
DetectServer=FALSE


[4877_2]
LongName=Hellgate: London
ShortName=hgl
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Flagship Studios\Hellgate London\HellgateKey
LauncherExe=Launcher.exe
DetectExe[0]=MP_x64\hellgate_mp_dx9_x64.exe
DetectExe[1]=MP_x64\hellgate_mp_dx10_x64.exe
DetectExe[2]=SP_x64\hellgate_sp_dx9_x64.exe
DetectExe[3]=SP_x64\hellgate_sp_dx10_x64.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer[0]=D3D9
InGameRenderer[1]=D3D10
InGameRenderer[2]=D3D9
InGameRenderer[3]=D3D10
InGameFlags[0]=USE_PRESENT|USE_SWAPCHAIN|DISABLE_RELEASE|ENABLE_MOUSE|SUBCLASS_WNDPROC|BLOCK_ASYNC
InGameFlags[1]=ENABLE_MOUSE|SUBCLASS_WNDPROC|BLOCK_ASYNC
InGameFlags[2]=USE_PRESENT|USE_SWAPCHAIN|DISABLE_RELEASE|ENABLE_MOUSE|SUBCLASS_WNDPROC|BLOCK_ASYNC
InGameFlags[3]=ENABLE_MOUSE|SUBCLASS_WNDPROC|BLOCK_ASYNC
DetectServer=FALSE
AlwaysFullScreen=1
DetectServer=FALSE


[4878]
LongName=Company of Heroes Multiplayer Beta
ShortName=cherosmpb
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\THQ\Company of Heroes BETA\InstallLocation
LauncherExe=RelicCOH.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_PRESENT|USE_SWAPCHAIN


[4879_1]
LongName=FEAR Multiplayer
ShortName=fearmp
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{2B653229-9854-4989-B780-D978F5F13EAB}\InstallLocation
LauncherExe=FEARMP.exe
LauncherPasswordArgs=+password %UA_GAME_HOST_PASSWORD%
LauncherNetworkArgs=+join %UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT% %UA_LAUNCHER_PASSWORD_ARGS%
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
ServerStatusType=GS
ExcludeIPPorts=28910
InGameRenderer=D3D9
InGameFlags=DISABLE_RELEASE|USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE
RunElevated=1


[4879_2]
LongName=FEAR Multiplayer
ShortName=fearmp
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{75E607CF-7BAE-4B88-84B3-97F3DF44BA28}\InstallLocation
LauncherExe=FEARMP.exe
LauncherPasswordArgs=+password %UA_GAME_HOST_PASSWORD%
LauncherNetworkArgs=+join %UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT% %UA_LAUNCHER_PASSWORD_ARGS%
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
ServerStatusType=GS
ExcludeIPPorts=28910
InGameRenderer=D3D9
InGameFlags=DISABLE_RELEASE|USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE
RunElevated=1


[4880_1]
LongName=Battlefield 2142
ShortName=bf2142
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Electronic Arts\EA Games\Battlefield 2142\InstallDir
LauncherExe=BF2142Pace.exe
LauncherLoginArgs=+eaAccountName %UA_GAME_LOGIN_NAME% +eaAccountPassword %UA_GAME_LOGIN_PASSWORD% +soldierName %UA_GAME_LOGIN_EXTRA1%
LauncherPasswordArgs=+password %UA_GAME_HOST_PASSWORD%
LauncherNetworkArgs=+joinServer %UA_GAME_HOST_NAME% +port %UA_GAME_HOST_PORT% %UA_LAUNCHER_PASSWORD_ARGS%
Launch=%UA_LAUNCHER_EXE_PATH% +menu 1 +fullscreen 1 %UA_LAUNCHER_LOGIN_ARGS% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=DISABLE_RELEASE|BLOCK_ASYNC|ENABLE_MOUSE|USE_DINPUT_MOUSE|USE_PRESENT|USE_SWAPCHAIN
ExcludeIPPorts=80,28910,29900,29901,29902,29903,29904
ServerStatusType=BF2142
RunElevated=1


[4880_2]
LongName=Battlefield 2142
ShortName=bf2142
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Electronic Arts\EA Games\Battlefield 2142\InstallDir
LauncherExe=BF2142.exe
LauncherLoginArgs=+eaAccountName %UA_GAME_LOGIN_NAME% +eaAccountPassword %UA_GAME_LOGIN_PASSWORD% +soldierName %UA_GAME_LOGIN_EXTRA1%
LauncherPasswordArgs=+password %UA_GAME_HOST_PASSWORD%
LauncherNetworkArgs=+joinServer %UA_GAME_HOST_NAME% +port %UA_GAME_HOST_PORT% %UA_LAUNCHER_PASSWORD_ARGS%
Launch=%UA_LAUNCHER_EXE_PATH% +menu 1 +fullscreen 1 %UA_LAUNCHER_LOGIN_ARGS% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=DISABLE_RELEASE|BLOCK_ASYNC|ENABLE_MOUSE|USE_DINPUT_MOUSE|USE_PRESENT|USE_SWAPCHAIN
ExcludeIPPorts=80,28910,29900,29901,29902,29903,29904
ServerStatusType=BF2142
RunElevated=1


[4881]
LongName=Monopoly Tycoon
ShortName=mtycoon
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Infogrames Interactive\Monopoly Tycoon\PATH
LauncherExe=mc.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=USE_DINPUT1|ENABLE_MOUSE
RunElevated=1


[4882_1]
LongName=Madden NFL 07
ShortName=mddn2k7
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\EA SPORTS\Madden NFL 07\Install Dir
LauncherExe=mainapp.exe
InstallHint=Madden07.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=DISABLE_RELEASE|ENABLE_MOUSE|USE_DINPUT_MOUSE|USE_PRESENT


[4882_2]
LongName=Madden NFL 07
ShortName=mddn2k7
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\EA SPORTS\Madden NFL 07\Install Dir
LauncherExe=madden07.exe
DetectExe=mainappPACe.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=DISABLE_RELEASE|ENABLE_MOUSE|USE_DINPUT_MOUSE|USE_PRESENT


[4883]
LongName=Company of Heroes Single Player Demo
ShortName=cherosspd
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\THQ\Company of Heroes Single Player Demo\InstallDir
LauncherExe=RelicCOH.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_PRESENT|USE_SWAPCHAIN


[4884]
LongName=Dawn of War Dark Crusade Demo
ShortName=wh40kdcd
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{73B5C5C0-FEF4-4DC1-89F3-C45DC11957DF}\InstallLocation
LauncherExe=DarkCrusade.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_WINDOWS_INPUT|ENABLE_MOUSE
ChangeTolerance=6


[5143_1]
LongName=Company of Heroes: Opposing Fronts
ShortName=cheroof
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Company of Heroes\InstallLocation
LauncherExe=RelicCOH.exe
InstallHint=CoHOF.ico
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer[0]=D3D9
InGameRenderer[1]=D3D10
InGameFlags[0]=ENABLE_MOUSE|USE_PRESENT|USE_SWAPCHAIN
InGameFlags[1]=ENABLE_MOUSE|USE_PRESENT|USE_SWAPCHAIN


[5143_2]
LongName=Company of Heroes: Opposing Fronts
ShortName=cheroof
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\common\company of heroes\RelicCOH.exe
InstallHint=steamapps\common\company of heroes\CoHOF.ico
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 9340 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer[0]=D3D9
InGameRenderer[1]=D3D10
InGameFlags[0]=ENABLE_MOUSE|USE_PRESENT|USE_SWAPCHAIN
InGameFlags[1]=ENABLE_MOUSE|USE_PRESENT|USE_SWAPCHAIN


[4885_1]
LongName=Company of Heroes
ShortName=cheros
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\THQ\Company of Heroes\InstallDir
LauncherExe=RelicCOH.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer[0]=D3D9
InGameRenderer[1]=D3D10
InGameFlags[0]=ENABLE_MOUSE|USE_PRESENT|USE_SWAPCHAIN
InGameFlags[1]=ENABLE_MOUSE|USE_PRESENT|USE_SWAPCHAIN


[4885_2]
LongName=Company of Heroes
ShortName=cheros
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Company of Heroes\InstallLocation
LauncherExe=RelicCOH.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer[0]=D3D9
InGameRenderer[1]=D3D10
InGameFlags[0]=ENABLE_MOUSE|USE_PRESENT|USE_SWAPCHAIN
InGameFlags[1]=ENABLE_MOUSE|USE_PRESENT|USE_SWAPCHAIN


[4886]
LongName=Lego Star Wars II
ShortName=legosw2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{578FA426-47C0-4A3F-98A4-01ACD26B7556}\InstallLocation
LauncherExe=LegoStarWarsII.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[4887]
LongName=Mall Tycoon
ShortName=mtcoon
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\mall.Exe\Path
LauncherExe=Mall.exe
InstallHint=malltyc.res
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4888]
LongName=Mall Tycoon 2
ShortName=mtcoon2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Global Star Software\Mall Tycoon 2 Deluxe\Directory
LauncherExe=Mall.exe
InstallHInt=fmod.dll
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[4889]
LongName=Mall Tycoon 3
ShortName=mtcoon3
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Cat Daddy Games\MallTycoon3\InstallDir
LauncherExe=Mall3.exe
DetectExe=Mall3Game.exe
InstallHint=mall3game.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4890]
LongName=School Tycoon
ShortName=schtcoon
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{266F34CA-580F-4615-80FE-BDFBD56B748F}\InstallLocation
LauncherExe=SchoolTycoon.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4891]
LongName=Airport Tycoon
ShortName=airtcoon
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Airport.exe\Path
LauncherExe=Airport.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=DDRAW4
InGameFlags=DDRAW_FLIP_MODE|BLOCK_ASYNC


[4892]
LongName=Prison Tycoon 2
ShortName=ptycoon2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\ValuSoft\Prison Tycoon 2\Directory
LauncherDirAppend=\data
LauncherExe=Prison_Tycoon_2.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[4893]
LongName=First Battalion
ShortName=firstbat
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{8ACDE065-ECA5-4ABC-9CF3-8BFE256BE728}\InstallLocation
LauncherExe=pea.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=ENABLE_MOUSE|USE_PRESENT


[4894]
LongName=Faces of War
ShortName=fow
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{2C2F85C4-62C3-4F59-A5E1-AB60E5F76ADF}_is1\InstallLocation
LauncherExe=facesofwar.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[4895]
LongName=Patriots: A Nation Under Fire
ShortName=panuf
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Patriots: A Nation Under Fire\UninstallString
LauncherDirTruncAt=UNWISE.EXE
LauncherExe=Patriots.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4896]
LongName=Caesar 4 Demo
ShortName=caesar4d
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{56C3017A-6E09-4101-8B35-EAC40DA86A9E}\InstallLocation
LauncherExe=CaesarIVDemo.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|USE_SWAPCHAIN|DISABLE_RELEASE|ENABLE_MOUSE


[4897]
LongName=Dark Messiah Multiplayer Open Beta
ShortName=dmmob
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\dark messiah multiplayer open beta\mm.exe
InstallHint=steamapps\dark messiah multiplayer open beta.gcf
LauncherPasswordArgs=+password %UA_GAME_HOST_PASSWORD%
LauncherNetworkArgs="%UA_LAUNCHER_PASSWORD_ARGS% +connect %UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT%"
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 2110 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
ServerStatusType=SOURCE


[4898]
LongName=FEAR Extraction Point SP Demo
ShortName=fearepspd
LauncherDirDefault=C:\Program Files\Sierra\FEAR Extraction Point SP Demo
LauncherExe=FEARXP-SPDemo.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=DISABLE_RELEASE|USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE
RunElevated=1


[4899]
LongName=Mage Knight Apocalypse
ShortName=mka
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\NAMCO BANDAI Games\Mage Knight\InstallDir
LauncherExe=MageKnight.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE


[4900]
LongName=Caesar 4
ShortName=caesar4
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{B7666229-351B-47D9-AA6F-DF777CF04BBF}\InstallLocation
LauncherExe=CaesarIV.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|USE_SWAPCHAIN|DISABLE_RELEASE|ENABLE_MOUSE

[4906_1]
LongName=Disciples 2 - Gallean's Return
ShortName=dis2gr
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Strategy First\Disciples2\InstallPathD2GoldGallean
LauncherExe=Discipl2.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=DDRAW4
InGameFlags=DDRAW_FLIP_MODE


[4906_2]
LongName=Disciples 2 - Gallean's Return
ShortName=dis2gr
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\disciples ii galleans return\Discipl2.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 1640 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=DDRAW4
InGameFlags=DDRAW_FLIP_MODE


[4907_1]
LongName=Disciples 2 - Rise of the Elves
ShortName=dis2rote
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Strategy First\Disciples2\InstallPathROTE
LauncherExe=Discipl2.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=DDRAW4
InGameFlags=DDRAW_FLIP_MODE


[4907_2]
LongName=Disciples 2 - Rise of the Elves
ShortName=dis2rote
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\disciples ii rise of the elves\Discipl2.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 1630 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=DDRAW4
InGameFlags=DDRAW_FLIP_MODE


[4908]
LongName=Joint Task Force
ShortName=jtf
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{BCB9DF93-537D-433D-AF3B-36025DEF5798}\InstallLocation
LauncherExe=jtf.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[4909]
LongName=Battlefield 2142 Demo
ShortName=bf2142d
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Electronic Arts\EA Games\Battlefield 2142 Demo\InstallDir
LauncherExe=BF2142.exe
InstallHint=rotate_demo.cfg
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_LOGIN_ARGS% +menu 1 +fullscreen 1 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=DISABLE_RELEASE|BLOCK_ASYNC|ENABLE_MOUSE|USE_DINPUT_MOUSE|USE_PRESENT|USE_SWAPCHAIN
ExcludeIPPorts=80,28910,29900,29901,29902,29903,29904
ServerStatusType=BF2142
RunElevated=1


[4910]
LongName=GTR 2
ShortName=gtr2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\10tacle Studios\GTR2\InstallDir
LauncherExe=GTR2.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE


[4911]
LongName=Scarface
ShortName=sface
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{28142407-ACAD-4ECD-A6B6-9FA8471F6062}\InstallLocation
LauncherExe=Scarface.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[4912]
LongName=Archlord
ShortName=alord
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\ArchLord\InstallPath
LauncherExe=Archlord.exe
DetectExe=Alefclient.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|DISABLE_RELEASE|BLOCK_ASYNC|ENABLE_MOUSE
RunElevated=1
DetectServer=FALSE


[4913]
LongName=Medieval II Total War Demo SE
ShortName=m2twd
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{8A5359C9-7B27-45C0-B41C-666798A75752}\InstallLocation
LauncherExe=medieval2.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT


[4914]
LongName=War Front - Turning Point
ShortName=warf
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\10TACLE STUDIOS AG\War Front - Turning Point\English\target folder
LauncherDirAppend=\Run
LauncherExe=WarFront.exe
LobbyJoinString=/client %UA_GAME_HOST_NAME%
LobbyHostString=/host
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_LOBBY_ARGS%
;InGameRenderer=D3D9
InGameFlags=USE_PRESENT
LobbyType=CMD


[4915_1]
LongName=Gothic III
ShortName=goth3
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\JoWooD Productions Software AG\Gothic III\INSTALL_DIR
LauncherExe=Gothic3.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[4915_2]
LongName=Gothic III
ShortName=goth3
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Software\JoWooD Productions Software AG\Gothic III\RUN_CMD
LauncherDirTruncAt=gothic3.exe
LauncherExe=gothic3.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[4916]
LongName=Tiger Woods PGA Tour 07
ShortName=tw07
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\EA SPORTS\Tiger Woods PGA TOUR 07\Install Dir
LauncherDirAppend=\bin
LauncherExe=TW2007.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[4917]
LongName=El Matador
ShortName=elmat
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{1C507D78-9D78-4169-8555-A2D87BD2B81C}\InstallLocation
LauncherExe=pc_matador.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|USE_DINPUT1


[4918]
LongName=Paraworld
ShortName=paraw
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{EAA01BA0-6991-4296-A404-4FFF2DAC2225}\InstallLocation
LauncherDirAppend=\bin
LauncherExe=Paraworld.exe
DetectExe=pwclient.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[4919]
LongName=Frets on Fire
ShortName=fof
LauncherDirDefault=c:\games\fretsonfire
LauncherExe=FretsOnFire.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL
InGameFlags=USE_DINPUT1|ENABLE_MOUSE|USE_DINPUT_MOUSE|DISABLE_FOR_VISTA


[4920_1]
LongName=Defcon
ShortName=defcon
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\common\defcon\defcon.exe
InstallHint=steamapps\defcon content.ncf
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 1520 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE


[4920_2]
LongName=Defcon
ShortName=defcon
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Defcon_is1\InstallLocation
LauncherExe=defcon.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE


[4921]
LongName=Championship Manager 2006
ShortName=cm2006
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Eidos\Championship Manager 2006\InstallDir
LauncherExe=CM2006.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8


[4922]
LongName=Age of Empires III: The WarChiefs
ShortName=aoe3twc
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft Games\Age of Empires 3\1.0\SetupPath
LauncherEXE=age3x.EXE
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|CHECK_LISTENER|ENABLE_MOUSE


[4923_1]
LongName=Microsoft Flight Simulator X
ShortName=fsx
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft Games\flight simulator\10.0\SetupPath
LauncherExe=fsx.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4923_2]
LongName=Microsoft Flight Simulator X
ShortName=fsx
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\GameUX\GamesToFindOnWindowsUpgrade\{638327AB-DD8F-4604-A6BC-9768D8A8AE2B}\GameInstallPath
LauncherExe=fsx.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4924_1]
LongName=BZFlag
ShortName=bzf
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\BZFlag2.0.8\UninstallString
LauncherDirTruncAt=\uninstall.exe
LauncherExe=bzflag.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE


[4924_2]
LongName=BZFlag
ShortName=bzf
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\BZFlag2.0.10\Install_Dir
LauncherExe=bzflag.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE


[4925_1]
LongName=The Sims 2 Pets
ShortName=sims2p
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\EA GAMES\The Sims 2 Pets\Install Dir
LauncherDirAppend=\TSBin
LauncherExe=Sims2EP4.exe
DetectExe=Sims2EP4_DRM.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[4925_2]
LongName=The Sims 2 Pets
ShortName=sims2p
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\EA GAMES\The Sims 2 Pets\Install Dir
LauncherDirAppend=\TSBin
LauncherExe=Sims2EP4.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[4926]
LongName=Sid Meier's Railroads
ShortName=smrr
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Firaxis Games\Sid Meier's Railroads!\INSTALLDIR
LauncherExe=RailRoads.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=DISABLE_RELEASE|ENABLE_MOUSE|USE_PRESENT


[4927_1]
LongName=The Guild 2
ShortName=guild2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\TheGuild2\eng\GamePath
LauncherExe=GuildII.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|DISABLE_RELEASE|ENABLE_MOUSE


[4927_2]
LongName=The Guild 2
ShortName=guild2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\The Guild 2 - Pirates of the European Seas\UninstallString
LauncherDirTruncAt=uninstall.exe
LauncherExe=GuildII.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|DISABLE_RELEASE|ENABLE_MOUSE|USE_DINPUT_MOUSE


[4928]
LongName=Neocron 2
ShortName=neocr2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{1259D05F-D20C-4E07-845E-5728C0E164B2}_is1\Inno Setup: App Path
LauncherExe=NeocronLauncher.exe
DetectExe=Client.exe
InstallHint=neocronlauncher.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[4929]
LongName=Devil May Cry 3 Special Edition
ShortName=dmc3se
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\CAPCOM\Devil May Cry 3 Special Edition\Mov
LauncherExe=dmc3se.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=DISABLE_RELEASE|USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[4930_1]
LongName=Space Empires IV Deluxe
ShortName=se4dlx
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\space empires iv deluxe\se4\se4.exe
InstallHint=SteamApps\space empires iv deluxe.gcf
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 1610 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4930_2]
LongName=Space Empires IV Deluxe
ShortName=se4dlx
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Strategy First\Space Empires IV Deluxe\Install Path
LauncherExe=Se4.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4931_1]
LongName=Space Empires V
ShortName=se5
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\common\spaceempiresv\se5\se5.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 1690 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4931_2]
LongName=Space Empires V
ShortName=se5
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Strategy First\Space Empires V\Install Path
LauncherExe=SE5.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4932]
LongName=Shot Online
ShortName=shoto
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\ShotOnline International.exe\
LauncherDirTruncAt=ShotOnline International.exe
LauncherExe=ShotOnline.exe
DetectExe=shot.exe
PlayingDetectType=ByWindowSubstr
ProcessWindowTitle=Shot
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
;InGameRenderer=D3D8
RunElevated=1


[4934]
LongName=Star Wars Empire at War Forces of Corruption
ShortName=sweawfoc
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\LucasArts\Star Wars Empire at War Forces of Corruption\1.0\InstallPath
LauncherExe=swfoc.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=DISABLE_RELEASE|USE_PRESENT|ENABLE_MOUSE


[4935]
LongName=Phantasy Star Universe Online
ShortName=psu
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\PHANTASY STAR UNIVERSE_is1\UninstallString
LauncherDirTruncAt=uninst\unins000.exe
LauncherExe=online.exe
DetectExe=psu.exe
PlayingDetectType=ByWindow
ProcessWindowTitle=Phantasy Star Universe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=VALIDATE_USING_EXE_NAME|USE_DINPUT1|DISABLE_FOR_VISTA
RunElevated=1


[4936]
LongName=Dark Messiah Multiplayer
ShortName=dmmp
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\dark messiah might and magic multi-player\mm.exe
InstallHint=steamapps\mm_mp_engine.gcf
LauncherPasswordArgs=+password %UA_GAME_HOST_PASSWORD%
LauncherNetworkArgs="%UA_LAUNCHER_PASSWORD_ARGS% +connect %UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT%"
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 2130 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
ServerStatusType=SOURCE
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|DISABLE_FOR_VISTA|USE_SWAPCHAIN|ENABLE_MOUSE|USE_DINPUT_MOUSE


[4937_1]
LongName=Dark Messiah Single Player
ShortName=dmsp
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\dark messiah might and magic single player\mm.exe
InstallHint=steamapps\mm_media.gcf
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 2100 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|DISABLE_FOR_VISTA|USE_SWAPCHAIN|ENABLE_MOUSE|USE_DINPUT_MOUSE


[4937_2]
LongName=Dark Messiah Single Player
ShortName=dmsp
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Ubisoft\Dark Messiah of Might and Magic\Install Location
LauncherExe=mm.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|DISABLE_FOR_VISTA|USE_SWAPCHAIN|ENABLE_MOUSE|USE_DINPUT_MOUSE


[4938]
LongName=FEAR Extraction Point
ShortName=fearep
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Monolith Productions\FEAR\1.00.0000\InstallDir
LauncherDirAppend=fearxp
LauncherExe=FEARxp.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=DISABLE_RELEASE|USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE
RunElevated=1


[4939]
LongName=Stronghold Legends
ShortName=sholdleg
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\strongholdlegends.exe\Path
LauncherExe=StrongholdLegends.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|DISABLE_RELEASE|ENABLE_MOUSE|USE_DINPUT_MOUSE


[4940]
LongName=Perimeter
ShortName=perim
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Codemasters\Perimeter\INSTALL_PATH
LauncherExe=perimeter.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
;InGameRenderer=D3D9
;InGameFlags=USE_PRESENT|DISABLE_RELEASE


[4941]
LongName=Perimeter Emperor's Testament
ShortName=perimet
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\1C\PerimeterET\Install_Path
LauncherExe=PerimeterET.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
;InGameRenderer=D3D9
;InGameFlags=USE_PRESENT|DISABLE_RELEASE


[4942]
LongName=Neverwinter Nights 2
ShortName=nwn2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Obsidian\NWN 2\Neverwinter\Location
LauncherExe=nwn2main.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS% %UA_LAUNCHER_PASSWORD_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE|DISABLE_RELEASE


[4943_1]
LongName=Need for Speed Carbon
ShortName=nfsc
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Electronic Arts\Need for Speed Carbon\Install Dir
LauncherExe=nfsc.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=DISABLE_RELEASE|USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[4943_2]
LongName=Need for Speed Carbon
ShortName=nfsc
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Electronic Arts\Need for Speed Carbon\Install Dir
LauncherExe=NFSC_Launcher.exe
DetectExe=NFSC_LINK.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=DISABLE_RELEASE|USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[4944]
LongName=Marvel Ultimate Alliance
ShortName=mua
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Activision\Marvel Ultimate Alliance\InstallPath
LauncherExe=mua.exe
DetectExe=game.exe
InstallHint=mua.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=DISABLE_RELEASE|USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[4945]
LongName=Need for Speed Carbon Demo
ShortName=nfscd
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Electronic Arts\Need for Speed Carbon Demo\Install Dir
LauncherExe=nfsc_demo.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=DISABLE_RELEASE|ENABLE_MOUSE|USE_DINPUT_MOUSE|USE_PRESENT


[4946]
LongName=Pro Evolution Soccer 6
ShortName=pes6
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\KONAMIPES6\PES6\installdir
LauncherExe=PES6.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=USE_PRESENT|DISABLE_RELEASE|ENABLE_MOUSE|USE_DINPUT_MOUSE


[4947]
LongName=Football Manager 2007
ShortName=fm2007
LauncherDirKey=HKEY_CURRENT_USER\Software\Sports Interactive Ltd\Installs\Football Manager 2007\Path
LauncherExe=fm.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4948]
LongName=Championship Manager 2007
ShortName=cm2007
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Eidos\Championship Manager 2007\InstallDir
LauncherExe=CM2007.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=USE_PRESENT|DISABLE_RELEASE|ENABLE_MOUSE|USE_DINPUT_MOUSE


[4949]
LongName=Splinter Cell Double Agent Single Player
ShortName=scdasp
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Ubisoft\Tom Clancy's Splinter Cell Double Agent\InstallDir
LauncherDirAppend=\SCDA-Offline
LauncherExe=System\SplinterCell4.exe
Launch=%UA_LAUNCHER_EXE_PATH% menu.unr -ll %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[4950]
LongName=Splinter Cell Double Agent Multiplayer
ShortName=scdamp
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Ubisoft\Tom Clancy's Splinter Cell Double Agent\InstallDir
LauncherDirAppend=\SCDA-Online
LauncherExe=System\SCDA_online.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4951]
LongName=SkillGround.com
ShortName=skillground
LauncherDirKey=HKEY_CURRENT_USER\Software\SkillGround\InstallFolder
LauncherExe=SkillGround.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4952_1]
LongName=1701 A.D.
ShortName=1701ad
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{A2433A63-5F5D-40E5-B529-9123C2B3E734}\InstallLocation
LauncherExe=1701.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|DISABLE_RELEASE|ENABLE_MOUSE


[4952_2]
LongName=1701 A.D.
ShortName=1701ad
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{A2433A63-5F5D-40E5-B529-9123C2B3E734}\InstallLocation
LauncherExe=Anno1701.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|DISABLE_RELEASE|ENABLE_MOUSE


[4953_1]
LongName=Medieval II Total War
ShortName=m2tw
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\common\medieval ii total war\medieval2.exe
InstallHint=steamapps\medieval ii total war content.ncf
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 4700 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|DISABLE_RELEASE|ENABLE_MOUSE


[4953_2]
LongName=Medieval II Total War
ShortName=m2tw
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\medieval2.exe\Path
LauncherExe=medieval2.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|DISABLE_RELEASE|ENABLE_MOUSE


[4954]
LongName=Panzer Command
ShortName=panzerc
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Matrix Games\Panzer Command Operation Winter Storm\installed to
LauncherExe=PCOWS.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|DISABLE_RELEASE|ENABLE_MOUSE|USE_DINPUT_MOUSE


[4955]
LongName=Warhammer Mark of Chaos
ShortName=whmoc
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\NamcoBandai\Warhammer: Mark of Chaos\InstallPath
LauncherExe=Warhammer.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|DISABLE_RELEASE|ENABLE_MOUSE


[4956_1]
LongName=Heroes of Might and Magic V - Hammers of Fate
ShortName=homm5hof
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Ubisoft\Heroes of Might and Magic V: Hammers of Fate\US\InstallPath
LauncherDirAppend=\bina1
LauncherExe=H5_Game.exe
InstallHint=UpgradeLauncher.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT


[4956_2]
LongName=Heroes of Might and Magic V - Hammers of Fate
ShortName=homm5hof
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\heroes of might and magic 5\bina1\testapp.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 15380 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT


[4957]
LongName=Falcon 4.0 Allied Force
ShortName=falcon4
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Lead Pursuit\Battlefield Operations\Falcon\baseDir
LauncherExe=FalconAF.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D7
InGameFlags=USE_DINPUT1|DISABLE_FOR_VISTA


[4958]
LongName=Eragon
ShortName=eragon
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Sierra\Eragon\InstallDir
LauncherExe=Eragon.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|DISABLE_RELEASE|ENABLE_MOUSE


[4959]
LongName=The Settlers II - 10th Anniversary
ShortName=s210th
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Ubisoft\Funatics\S2TNG\InstallDir
LauncherDirAppend=\bin
LauncherExe=S2DNG.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|DISABLE_RELEASE|BLOCK_ASYNC|ENABLE_MOUSE


[4960]
LongName=Reservoir Dogs
ShortName=resdogs
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Eidos\Reservoir Dogs\Location
LauncherExe=resdogs.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[4961]
LongName=Digital Paint: Paintball 2
ShortName=paintball2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Digital Paint\Paintball2\INSTDIR
LauncherExe=paintball2.exe
LauncherRconArgs=+rcon_password "%UA_GAME_RCON_PASSWORD%"
LauncherPasswordArgs=+password "%UA_GAME_HOST_PASSWORD%"
LauncherNetworkArgs=+connect %UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT% %UA_LAUNCHER_PASSWORD_ARGS% %UA_LAUNCHER_RCON_ARGS%
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
ServerStatusType=Q2
ServerBroadcastPort=27910
ServerGameName=*
InGameRenderer=OGL
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE
InGameOGLTextureOffset=32000


[4962]
LongName=The Lord of the Rings, The Rise of the Witch-king
ShortName=bfme2wk
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Electronic Arts\The Lord of the Rings, The Rise of the Witch-king\Install Dir
LauncherExe=lotrbfme2ep1.exe
DetectExe=game.dat
InstallHint=lotrbfme2ep1.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|DISABLE_RELEASE|ENABLE_MOUSE|USE_DINPUT_MOUSE
DetectServer=FALSE


[4963]
LongName=Rappelz Epic3
ShortName=rappelz
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{141E4A1C-4D02-4B72-96D6-D2AC08D6DA59}\InstallLocation
LauncherExe=launcher.exe
DetectExe=sframe.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|DISABLE_RELEASE|DISABLE_FOR_VISTA


[4964]
LongName=Star Trek Legacy
ShortName=stlegacy
LauncherDirShortcut=CSIDL_PROGRAMS\Bethesda Softworks\Star Trek Legacy\Star Trek Legacy.lnk
LauncherDirTruncAt=\Legacy.exe
LauncherExe=Legacy.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|DISABLE_RELEASE|ENABLE_MOUSE|USE_DINPUT_MOUSE


[4965]
LongName=Tom Clancy's Rainbow Six Vegas
ShortName=tcrsixv
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Ubisoft\Rainbow Six Vegas\Executable
LauncherDirTruncAt=R6Vegas_Launcher.exe
LauncherExe=R6Vegas_Game.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_PRESENT
RunElevated=1


[4966]
LongName=ijji GunZ
ShortName=gunzna
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\HanGame.Com\ENGLISH\U_GUNZ\DestDir
LauncherExe=GunzLauncher.exe
DetectExe=Gunz.exe
InstallHint=GunzUS.ini
PlayingDetectType=ByWindow
ProcessWindowTitle=Gunz
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|VALIDATE_USING_EXE_NAME|ENABLE_MOUSE|USE_DINPUT_MOUSE|DISABLE_RELEASE
ChangeTolerance=6
RunElevated=1


[4967_1]
LongName=Vanguard - Saga of Heroes
ShortName=vanguardb
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Vanguard.exe\Path
LauncherExe=Vanguard.exe
DetectExe=\bin\vgclient.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|DISABLE_RELEASE|ENABLE_MOUSE|USE_DINPUT_MOUSE
RunElevated=1


[4967_2]
LongName=Vanguard - Saga of Heroes
ShortName=vanguardb
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\LaunchPad.exe\Path
LauncherExe=LaunchPad.exe
DetectDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Vanguard.exe\Path
DetectExe=\bin\vgclient.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|DISABLE_RELEASE|ENABLE_MOUSE|USE_DINPUT_MOUSE
RunElevated=1


[4967_3]
LongName=Vanguard - Saga of Heroes
ShortName=vanguardb
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\LaunchPad2.exe\Path
LauncherExe=launchpad.exe
DetectDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Sony Online Entertainment\LaunchPad2\KnownInstallLocations\vanguard-live-en_US
DetectExe=\bin\vgclient.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|DISABLE_RELEASE|ENABLE_MOUSE|USE_DINPUT_MOUSE
RunElevated=1


[4967_4]
LongName=Vanguard - Saga of Heroes
ShortName=vanguardb
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Sony Online Entertainment\LaunchPad2\BasePath
LauncherExe=StationLauncher.exe
DetectDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\bin\VGClient.exe\Path
DetectExe=\bin\VGClient.exe
Launch=%UA_LAUNCHER_EXE_PATH%  --game VGD %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|DISABLE_RELEASE|ENABLE_MOUSE|USE_DINPUT_MOUSE
RunElevated=1


[4968]
LongName=CABAL Online (Europe)
ShortName=cabalo
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\CABAL Online(Europe)_is1\Inno Setup: App Path
LauncherExe=cabal.exe
DetectExe=CabalMain.exe
PlayingDetectType=ByWindow
ProcessWindowTitle=CABAL
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=VALIDATE_USING_EXE_NAME|DISABLE_DIRECT_INPUT_HOOK|USE_PRESENT
RunElevated=1


[4969]
LongName=Trickster Revolution
ShortName=trickstero
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Ntreev\TricksterEng\InstallDir
LauncherExe=splash.exe
DetectExe=trickster.bin
PlayingDetectType=ByWindowSubstr
ProcessWindowTitle=Trickster
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=VALIDATE_USING_EXE_NAME|USE_PRESENT|USE_SWAPCHAIN|ENABLE_MOUSE
RunElevated=1


[4970]
LongName=Pirates of the Caribbean
ShortName=piratesotc
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{9D9A73EA-B2D5-42CF-BB54-5CC4D9F08134}\InstallLocation
LauncherExe=PiratesLoJS.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=USE_PRESENT|DISABLE_RELEASE|ENABLE_MOUSE|USE_DINPUT_MOUSE


[4971]
LongName=Dark Age of Camelot - Labyrinth of the Minotaur
ShortName=daoclm
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Dark Age of Camelot - Labyrinth of the Minotaur_is1\Inno Setup: App Path
LauncherExe=Camelot.exe
DetectExe=game.dll
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=BLOCK_ASYNC|USE_PRESENT|DISABLE_RELEASE|ENABLE_MOUSE|USE_DINPUT1
DetectServer=FALSE


[4972]
LongName=Battlefield 1942 Multiplayer Demo
ShortName=bf1942mpd
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\EA GAMES\Battlefield 1942 Multiplayer Demo\GAMEDIR
LauncherExe=BF1942Demo.exe
DetectExe=BF1942Demo.exe
LauncherPasswordArgs=+password %UA_GAME_HOST_PASSWORD%
LauncherNetworkArgs=+joinServer %UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT% %UA_LAUNCHER_PASSWORD_ARGS%
Launch=%UA_LAUNCHER_EXE_PATH% +restart 1 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
ServerStatusType=BF1942
ServerGameName=bfield1942
ServerBroadcastPort=22000:11
InGameRenderer=D3D8
InGameFlags=BLOCK_ASYNC|USE_PRESENT|DISABLE_RELEASE|ENABLE_MOUSE|USE_DINPUT_MOUSE
RunElevated=1


[4973]
LongName=Battlefield 1942 Singleplayer Demo
ShortName=bf1942spd
LauncherDirKey=HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\App Paths\BF1942.exe\Path
LauncherExe=BF1942.exe
InstallHint=lexiconAll.dat
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=BLOCK_ASYNC|USE_PRESENT|DISABLE_RELEASE|ENABLE_MOUSE|USE_DINPUT_MOUSE


[4974]
LongName=Battlefield 1942 Secret Weapons of WWII Demo
ShortName=bf1942swd
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\EA GAMES\Battlefield 1942 Secret Weapons of WWII Demo\GAMEDIR
LauncherExe=BF1942.exe
LauncherPasswordArgs=+password %UA_GAME_HOST_PASSWORD%
LauncherNetworkArgs=+joinServer %UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT% %UA_LAUNCHER_PASSWORD_ARGS%
Launch=%UA_LAUNCHER_EXE_PATH% +restart 1 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
ServerStatusType=BF1942
ServerGameName=bfield1942
ServerBroadcastPort=22000:11
InGameRenderer=D3D8
InGameFlags=BLOCK_ASYNC|USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE
ExcludeIPPorts=23000,23001,23002,23003,23004,28900
RunElevated=1


[4975_1]
LongName=Titan Quest Immortal Throne
ShortName=tquestit
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Iron Lore\Titan Quest Immortal Throne\Install Location
LauncherExe=Tqit.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=DISABLE_RELEASE|USE_PRESENT|ENABLE_MOUSE


[4975_2]
LongName=Titan Quest Immortal Throne
ShortName=tquestit
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\common\titan quest immortal throne\Tqit.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 4550 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|DISABLE_RELEASE|ENABLE_MOUSE|USE_DINPUT_MOUSE


[4975_3]
LongName=Titan Quest Immortal Throne
ShortName=tquestit
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Iron Lore\Titan Quest Immortal Throne\Install Location
LauncherExe=TqitD.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=DISABLE_RELEASE|USE_PRESENT|ENABLE_MOUSE


[4976]
LongName=Supreme Commander
ShortName=supcomb
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{25A1E6A4-2DBD-4AC0-8650-8EA9A45B183D}\InstallLocation
LauncherDirAppend=\Supreme Commander\bin
LauncherExe=SupremeCommander.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|BLOCK_ASYNC|ENABLE_MOUSE|USE_DINPUT_MOUSE


[4977]
LongName=Goonzu Online
ShortName=goonzu
LauncherDirKey=HKEY_CURRENT_USER\Software\NDOORS\GoonzuEng\PATH
LauncherExe=Goonzu.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4978]
LongName=25 to Life
ShortName=25tolife
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{B8FE7CDD-61D0-445D-9209-E809780B51DD}\InstallLocation
LauncherExe=TTL.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE|BLOCK_ASYNC|HIDE_CURSOR


[4979_1]
LongName=Battlestations Midway
ShortName=bsmidway
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=steamapps\common\battlestations midway\Battlestationsmidway.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 6870 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|DISABLE_RELEASE|ENABLE_MOUSE|USE_DINPUT_MOUSE


[4979_2]
LongName=Battlestations Midway
ShortName=bsmidway
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Eidos\Battlestations Midway\ApplicationDir
LauncherExe=Battlestationsmidway.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|DISABLE_RELEASE|ENABLE_MOUSE|USE_DINPUT_MOUSE


[4980]
LongName=Bad Day LA
ShortName=bdla
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Enlight Software\Bad Day LA\Path
LauncherExe=BadDayLA.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|DISABLE_RELEASE|ENABLE_MOUSE|USE_DINPUT_MOUSE


[4981]
LongName=Let's Ride! - Silver Buckle Stables
ShortName=lrsbs
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{DD576CB2-4328-4302-88F1-8BD3234EA825}\InstallLocation
LauncherExe=LetsRide.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=ENABLE_MOUSE


[4982]
LongName=James Bond 007 Nightfire
ShortName=bondnf
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\GEARBOX\NIGHTFIRE\directory
LauncherExe=Bond.exe
LauncherPasswordArgs=+Password %UA_GAME_HOST_PASSWORD%
LauncherNetworkArgs=+connect "%UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT%" %UA_LAUNCHER_PASSWORD_ARGS%
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=BLOCK_ASYNC|USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE
ServerStatusType=JBNF


[4983]
LongName=Mythos
ShortName=mythos
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{A2453998-F3D8-426D-B96F-0777B120E388}\InstallLocation
LauncherDirAppend=bin
LauncherExe=MYTHOS.EXE
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=VALIDATE_USING_EXE_NAME|DISABLE_RELEASE|DISABLE_DIRECT_INPUT_HOOK|USE_PRESENT|USE_SWAPCHAIN|ENABLE_MOUSE|SUBCLASS_WNDPROC
DetectServer=FALSE
AlwaysFullScreen=1


[4984]
LongName=Soldier Front
ShortName=sfront
LauncherDirKey=HKEY_CURRENT_USER\Software\Dragonfly\soldierfront\installPath
LauncherUrl=http://sfront.ijji.com/index.nhn?from=desktop
DetectExe=soldierfront.exe
InstallHint=soldierfront.exe
PlayingDetectType=ByWindow
ProcessWindowTitle=Soldier Front
Launch=%UA_LAUNCHER_URL% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
RunElevated=1


[4985]
LongName=The Sims Life Stories
ShortName=simsls
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\SimsLS.exe\
LauncherDirTruncAt=SimsLS.exe
LauncherExe=SimsLS.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[4986]
LongName=Maelstrom
ShortName=maelstrom
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Codemasters\Maelstrom\Install_Path
LauncherExe=Maelstrom.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4987]
LongName=The Curse of Monkey Island
ShortName=comi
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\LucasArts Entertainment Company\Curse of Monkey Island\v1.0\Executable
LauncherDirTruncAt=comi.exe
LauncherExe=curse.exe
DetectExe=comi.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4988]
LongName=Escape from Monkey Island
ShortName=efmi
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\LucasArts Entertainment Company LLC\Monkey4\Retail\Executable
LauncherDirTruncAt=Monkey4.exe
LauncherExe=Monkey4.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4989]
LongName=TMNT Demo
ShortName=tmntd
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Ubisoft\TMNT Demo\InstallDir
LauncherExe=TMNT.exe
DetectExe=TMNTGame.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE


[4990]
LongName=Warhammer Mark of Chaos MP Demo
ShortName=whmocmpd
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{AD23C034-CDE2-4C9C-BFCE-E04E551F9067}\InstallLocation
LauncherExe=Warhammer.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[4991_1]
LongName=Trackmania United Forever
ShortName=tmaniau
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\TmUnitedForever_is1\Inno Setup: App Path
LauncherExe=TmForeverLauncher.exe
DetectExe=TmForever.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[4991_2]
LongName=Trackmania United Forever
ShortName=tmaniau
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=Steam.exe
DetectExe=SteamApps\*\trackmania united\TmForever.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 7200 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT


[4992]
LongName=Absolute Poker.com
ShortName=abpoker
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Innoco\Casino\absolute\common\INSTALLINFO_AP
LauncherExe=mainclient.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4993_1]
LongName=Doyles Room.com
ShortName=droom
LauncherDirShortcut=CSIDL_PROGRAMS\Doyles Room Poker\Doyles Room Poker.lnk
LauncherDirTruncAt=client.exe
LauncherExe=client.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4993_2]
LongName=Doyles Room.com
ShortName=droom
LauncherDirDefault=C:\Program Files\DoylesRoomMPP
LauncherExe=MPPoker.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4994]
LongName=Everest Poker.com
ShortName=evpoker
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Everest Poker\UninstallString
LauncherDirTruncAt=cstart.exe /uninstall
LauncherExe=cstart.exe
DetectExe=Everest Poker.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%



[4995]
LongName=Full Tilt Poker.com
ShortName=ftpoker
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{D4C9692E-4EFA-4DA0-8B7F-9439466D9E31}\InstallLocation
LauncherExe=FullTiltPoker.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%



[4996_1]
LongName=Paradise Poker.com
ShortName=parpoker
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{D4C9692E-4EFA-4DA0-8B7F-9439466D9E31}\InstallLocation
LauncherExe=ParadisePoker.exe
MatchExe=paradisepoker.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
DetectServer=False


[4996_2]
LongName=Paradise Poker.com
ShortName=parpoker
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Paradise Poker\UninstallString
LauncherDirTruncAt=UNWISE.EXE
LauncherExe=ParadisePoker.exe
MatchExe=paradisepoker.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
DetectServer=False


[4996_3]
LongName=Paradise Poker.com
ShortName=parpoker
LauncherDirDefault=C:\Program Files\ParadisePoker
LauncherExe=poker.exe
DetectExe[0]=poker.exe
DetectExe[1]=browser.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
DetectServer=False


[4997]
LongName=PKR.com
ShortName=pkpoker
LauncherDirShortcut=CSIDL_PROGRAMS\pkr\play pkr.lnk
LauncherDirTruncAt=pkr.exe
LauncherExe=pkr.exe
DetectExe=pokerapp.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
RunElevated=1


[4998]
LongName=Ultimate Bet.com
ShortName=ubpoker
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\UltimateBet\DisplayIcon
LauncherDirTruncAt=ubcustom.ico
LauncherExe=UltimateBet.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4999_1]
LongName=WPTOnline.com
ShortName=wptpoker
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\WPTonline\UninstallString
LauncherDirTruncAt=uninstall.exe
LauncherExe=bin\wptupgrader.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[4999_2]
LongName=WPTOnline.com
ShortName=wptpoker
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\WorldPokerTour\WorldPokerTour\1.00\TARGET
LauncherExe=Poker.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5000]
LongName=Command & Conquer 3 Tiberium Wars Demo
ShortName=cc3twd
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Electronic Arts\Electronic Arts\Command and Conquer 3 Demo\InstallPath
LauncherExe=CNC3Demo.exe
DetectExe=DemoGame.dat
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5001_1]
LongName=Jade Empire
ShortName=jempire
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=steamapps\common\jade empire\JadeEmpire.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 7110 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5001_2]
LongName=Jade Empire
ShortName=jempire
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\BioWare\Jade Empire\Path
LauncherExe=JadeEmpire.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5002_1]
LongName=The Sims 2 Seasons
ShortName=sims2s
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\EA GAMES\The Sims 2 Seasons\Install Dir
LauncherExe=TSBin\Sims2EP5.exe
DetectExe=TSBin\Sims2EP5_DRM.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5002_2]
LongName=The Sims 2 Seasons
ShortName=sims2s
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\EA GAMES\The Sims 2 Seasons\Install Dir
LauncherExe=TSBin\Sims2EP5.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5003]
LongName=Space Rangers 2
ShortName=srangers2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Elemental Games\Space Rangers 2\Path
LauncherExe=Rangers.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5004]
LongName=Railroad Tycoon II
ShortName=rt2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Poptop Software\Railroad Tycoon II\1.0\AppPath
LauncherExe=RT2.EXE
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5005]
LongName=Railroad Tycoon II Platinum
ShortName=rt2p
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\RT2_PLAT.EXE\Path
LauncherExe=RT2_PLAT.EXE
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5006]
LongName=Sonic Riders
ShortName=sonicr
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Sonic Riders_is1\InstallLocation
LauncherExe=launcher.exe
MatchExe=SonicRiders.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
;InGameRenderer=D3D8
;InGameFlags=USE_PRESENT


[5007]
LongName=Sonic Heroes
ShortName=sonich
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\SONICHEROES\UninstallString
LauncherDirTruncAt=unsetup.exe
LauncherExe=launcher.exe
DetectExe=Tsonic_win.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5008]
LongName=Source SDK Base
ShortName=hl2sdk
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\source sdk base\HL2.exe
CommandLineMustNotContain[0]="\sourcemods\dystopia_v1"
CommandLineMustNotContain[1]="\sourcemods\insurgency"
CommandLineMustNotContain[2]="\sourcemods\FortressForever"
CommandLineMustNotContain[3]="\sourcemods\kzmod"
CommandLineMustNotContain[4]="\sourcemods\cspromod"
CommandLineMustNotContain[5]="\sourcemods\pvkii"
CommandLineMustNotContain[6]="\sourcemods\hidden"
CommandLineMustNotContain[7]="\sourcemods\pdark"
CommandLineMustNotContain[8]="\sourcemods\synergy"
InstallHint=steamapps\source sdk base.gcf
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 215 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE


[5009]
LongName=S.T.A.L.K.E.R. - Shadow of Chernobyl
ShortName=stalker
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\GSC Game World\STALKER-SHOC\InstallPath
LauncherDirAppend=\bin
LauncherExe=XR_3DA.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|DISABLE_RELEASE|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5010]
LongName=TMNT
ShortName=tmnt
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{B3583D27-C12A-483E-98B8-235506F71502}\InstallLocation
LauncherExe=TMNT.exe
DetectExe=TMNTGame.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5011]
LongName=Silent Hunter Wolves of the Pacific
ShortName=sh4wotp
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Ubisoft\SilentHunter4\{0D005F09-A5F4-473B-A901-5735C6AF5628}\Installation path
LauncherExe=sh4.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5012_1]
LongName=Silverfall
ShortName=slvrfl
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=steamapps\common\silverfall\Silverfall.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 4420 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|DISABLE_RELEASE|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5012_2]
LongName=Silverfall
ShortName=slvrfl
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Monte Cristo\Silverfall_PATH\PATH
LauncherExe=Silverfall.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|DISABLE_RELEASE|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5013]
LongName=Command & Conquer 3 Tiberium Wars
ShortName=cc3tw
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Electronic Arts\Electronic Arts\Command and Conquer 3\InstallPath
LauncherExe=CNC3.exe
DetectExe=RetailExe\*\cnc3game.dat
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5014]
LongName=Test Drive Unlimited
ShortName=tdu
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Atari\TDU\install_path
LauncherExe=TestDriveUnlimited.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5015]
LongName=18 Wheels of Steel Haulin
ShortName=18wosh
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\18 Wheels of Steel: Haulin'\UninstallString
LauncherDirTruncAt=uninst.exe
LauncherExe=haulin.exe
DetectExe=prism3d.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL
InGameOGLTextureOffset=32000
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE


[5016]
LongName=rFactor
ShortName=rfactor
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\rFactor\UninstallString
LauncherDirTruncAt=Uninstall.exe
LauncherExe=rfactor.exe
LauncherNetworkArgs=+connect %UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT%
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5017]
LongName=Half-Life Deathmatch: Source
ShortName=hldms
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\half-life deathmatch source\HL2.exe
InstallHint=steamapps\half-life deathmatch source.gcf
LauncherPasswordArgs=+password %UA_GAME_HOST_PASSWORD%
LauncherNetworkArgs="%UA_LAUNCHER_PASSWORD_ARGS% +connect %UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT%"
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 360 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
ServerStatusType=SOURCE
ServerGameName=Deathmatch
ServerEncodingType=UTF8
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE


[5018]
LongName=Baseball Mogul 2008
ShortName=bbmog08
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Baseball Mogul 2008\InstallLocation
LauncherExe=BB2K8.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5019]
LongName=Genesis Rising
ShortName=genris
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Genesis Rising_is1\InstallLocation
LauncherDirAppend=bin
LauncherExe=GenesisRising.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE
DetectServer=FALSE


[5020_1]
LongName=Call of Juarez
ShortName=coj
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Techland\CallOfJuarez\DestinationDir
LauncherExe=CoJ_DX10.exe
InstallHint=CoJ_DX10.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D10
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE


[5020_2]
LongName=Call of Juarez
ShortName=coj
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Techland\CallOfJuarez\DestinationDir
LauncherExe=CoJ.exe
DetectExe=CoJ.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE


[5021_1]
LongName=The Lord of the Rings Online
ShortName=lotro
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\12bbe590-c890-11d9-9669-0800200c9a66_is1\InstallLocation
LauncherExe=TurbineInvoker.exe
DetectExe=lotroclient.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_WINDOWS_INPUT|USE_PRESENT|USE_SWAPCHAIN|ENABLE_MOUSE
DetectServer=FALSE


[5021_2]
LongName=The Lord of the Rings Online
ShortName=lotro
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\4f6dcc3b-179d-4b1b-80f0-b6083a0b3ce6_is1\InstallLocation
LauncherExe=TurbineInvoker.exe
DetectExe=lotroclient.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_WINDOWS_INPUT|USE_PRESENT|USE_SWAPCHAIN|ENABLE_MOUSE
DetectServer=FALSE


[5720]
LongName=The Sims 2 Double Deluxe
ShortName=sims2dd
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Sims2.exe\Path
LauncherDirTruncAt=\Base
LauncherExe=SP4\TSBin\Sims2Launcher.exe
DetectExe=SP4\TSBin\Sims2SP4.exe
InstallHint=Sims2DoubleDeluxe_uninst.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5022_1]
LongName=The Sims 2 Celebration! Stuff
ShortName=sims2cs
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Sims2SP4.exe\Path
LauncherExe=TSBin\Sims2SP4.exe
DetectExe=TSBin\Sims2SP4_DRM.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5022_2]
LongName=The Sims 2 Celebration! Stuff
ShortName=sims2cs
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Sims2SP4.exe\Path
LauncherExe=TSBin\Sims2SP4.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5023_1]
LongName=ArmA
ShortName=arma
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Bohemia Interactive Studio\ArmA Queen's Gambit\MAIN
LauncherExe=armaGold.bat
DetectExe=arma.exe
LauncherNetworkArgs=-connect=%UA_GAME_HOST_NAME% %UA_GAME_HOST_PORT%
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5023_2]
LongName=ArmA
ShortName=arma
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Bohemia Interactive Studio\ArmA\MAIN
LauncherExe=arma.exe
LauncherNetworkArgs=-connect=%UA_GAME_HOST_NAME% %UA_GAME_HOST_PORT%
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5024]
LongName=Tortuga - Two Treasures
ShortName=ttt
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Tortuga - Two Treasures_is1\InstallLocation
LauncherExe=Tortuga-TwoTreasures.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|BLOCK_ASYNC|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5025]
LongName=Europa Universalis III
ShortName=eu3
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Paradox Interactive\Europa Universalis III\path
LauncherExe=eu3.exe
DetectExe=eu3game.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5026]
LongName=Winning Eleven Pro Evolution Soccer 2007
ShortName=we2007
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\KONAMIWEXU\WEXU\installdir
LauncherExe=we2007.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5027]
LongName=Race - The WTCC Game
ShortName=race
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\race\Race_Steam.exe
InstallHint=steamapps\race files.gcf
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 4230 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5028]
LongName=Resident Evil 4
ShortName=re4
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\CAPCOM\resident evil 4\PATH
LauncherExe=launcher.exe
DetectExe=game.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5029]
LongName=Ancient Wars - Sparta
ShortName=aws
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{554532CE-43E2-4B4F-BBDE-27742A32C236}\InstallLocation
LauncherExe=AWE.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5030]
LongName=Spider-Man 3
ShortName=sm3tg
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Activision\Spider-Man 3\InstallPath
LauncherExe=Spider-Man 3.exe
DetectExe=game.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5031]
LongName=Frontline - Fields of Thunder
ShortName=ffot
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Nival Interactive\Frontline - Fields of Thunder\InstallFolder
LauncherDirAppend=\bin\
LauncherExe=Game.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5032]
LongName=Broken Sword - The Angel of Death
ShortName=bstaod
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\THQ\Revolution Software Ltd\Broken Sword - The Angel of Death\InstallDirectory
LauncherExe=bs4pc.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|DISABLE_FOR_VISTA|USE_SWAPCHAIN|ENABLE_MOUSE


[5033]
LongName=Cricket 07
ShortName=crkt07
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Cricket07.exe\Path
LauncherExe=Cricket07.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=USE_PRESENT|USE_DINPUT1|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5034_1]
LongName=Chess Titans
ShortName=chstn
LauncherDirDefault=%ProgramW6432%\Microsoft Games\Chess
LauncherExe=Chess.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5034_2]
LongName=Chess Titans
ShortName=chstn
LauncherDirDefault=%ProgramFiles%\Microsoft Games\Chess
LauncherExe=chess.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5035_1]
LongName=Inkball
ShortName=inkbl
LauncherDirDefault=%ProgramW6432%\Microsoft Games\inkball
LauncherExe=inkball.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5035_2]
LongName=Inkball
ShortName=inkbl
LauncherDirDefault=%ProgramFiles%\Microsoft Games\inkball
LauncherExe=inkball.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5036_1]
LongName=Mahjong Titans
ShortName=mjtn
LauncherDirDefault=%ProgramW6432%\Microsoft Games\Mahjong
LauncherExe=Mahjong.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5036_2]
LongName=Mahjong Titans
ShortName=mjtn
LauncherDirDefault=%ProgramFiles%\Microsoft Games\Mahjong
LauncherExe=Mahjong.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5037_1]
LongName=Purble Place
ShortName=prblplc
LauncherDirDefault=%ProgramW6432%\Microsoft Games\Purble Place
LauncherExe=PurblePlace.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5037_2]
LongName=Purble Place
ShortName=prblplc
LauncherDirDefault=%ProgramFiles%\Microsoft Games\Purble Place
LauncherExe=PurblePlace.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5038]
LongName=Hold 'Em
ShortName=hldem
LauncherDirDefault=%ProgramFiles%\Microsoft Games\HoldEm
LauncherExe=HoldEm.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5039]
LongName=Brian Lara International Cricket 2007
ShortName=blic07
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Codemasters\International Cricket 2007\PATH_APPLICATION
LauncherExe=ICC2007.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5040]
LongName=LMA Manager 2007
ShortName=lmam07
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Codemasters\LMA Manager 2007\PATH_APPLICATION
LauncherExe=LMA_2007.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_PRESENT


[5041]
LongName=UEFA Champions League 2006-2007
ShortName=uefacl07
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\CL07.exe\Path
LauncherExe=CL07.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=USE_PRESENT|USE_DINPUT1
DetectServer=FALSE


[5042]
LongName=FIFA Manager 07
ShortName=fifam07
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Manager07.exe\Path
LauncherExe=Manager07.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5043]
LongName=Virtua Tennis 3
ShortName=vt3
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{9B63540D-D942-4C38-B42E-A48AE0145970}\InstallLocation
LauncherExe=VT3.EXE
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5044]
LongName=Boiling Point
ShortName=bprth
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{58AC967F-CE64-4065-AF54-FA66BAF31FE8}\InstallLocation
LauncherExe=Xenus.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE|USE_DINPUT1


[5045]
LongName=Cellfactor Revolution
ShortName=cfrev
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Cellfactor Revolution\UninstallString
LauncherDirTruncAt=uninst.exe
LauncherDirAppend=System
LauncherExe=Reality.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5046]
LongName=Infernal
ShortName=infrnl
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\InfernalGame\InstallPath
LauncherDirAppend=game
LauncherExe=game.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5047]
LongName=Crazy Taxi
ShortName=crzytx
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Crazy_Taxi_PC.exe\Path
LauncherExe=CRAZY_TAXI_PC.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=ENABLE_MOUSE


[5048]
LongName=Last Chaos USA
ShortName=lcusa
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\LastChaosUSA\DestDir
LauncherExe=LC.exe
DetectExe=Bin\Nksp.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE
DetectServer=FALSE


[5049]
LongName=The Sims 2 Deluxe
ShortName=sims2d
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\EA GAMES\The Sims 2 Deluxe\Install Dir
LauncherExe=EP2\TSBin\Sims2EP2.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5050]
LongName=Harry Potter and the Prisoner of Azkaban
ShortName=hppoa
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\hppoa.exe\Path
LauncherDirAppend=\system
LauncherExe=hppoa.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5051]
LongName=Broken Sword - The Sleeping Dragon
ShortName=bstsd
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\REVOLUTION\BSTSD\TargetDir
LauncherExe=BS3PC.EXE
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=USE_PRESENT|DISABLE_FOR_VISTA|USE_SWAPCHAIN|ENABLE_MOUSE


[5052]
LongName=Syberia
ShortName=syber
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microids\Syberia DVD\CurrentPath
LauncherDirAppend=\Syberia
LauncherExe=Syberia.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5053]
LongName=Syberia2
ShortName=syber2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microids\Syberia DVD\CurrentPath
LauncherDirAppend=\Syberia2
LauncherExe=Syberia2.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5054]
LongName=Voyage Century Online
ShortName=vconline
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\SnailGame\voyage_EN_US\InstallDir
LauncherExe=voyagecentury.exe
DetectExe=voyage\Core.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE
DetectServer=FALSE


[5055]
LongName=Sauerbraten
ShortName=sauer
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Sauerbraten\Install_Dir
LauncherExe=\bin\sauerbraten.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE


[5056_1]
LongName=Dogz 4
ShortName=dogz4
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Petz 4.exe\Path
LauncherExe=Petz 4.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5056_2]
LongName=Dogz 4
ShortName=dogz4
LauncherDirDefault=C:\Program Files\PF.Magic\Petz 4
LauncherExe=Petz 4.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5057]
LongName=Freeciv - beta
ShortName=fcivbeta
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Freeciv-2.1.0-beta4-gtk2\Install_Dir
LauncherExe=civclient.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5058]
LongName=Tibia
ShortName=tibia
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Tibia_is1\Inno Setup: App Path
LauncherExe=Tibia.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|DISABLE_SCREENSHOTS|ENABLE_MOUSE


[5059]
LongName=UFO - Extraterrestrial
ShortName=ufoet
LauncherDirDefault=C:\Tri Synergy\UFO Extraterrestrials
LauncherExe=UFO_ET.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
;InGameRenderer=D3D9
;InGameFlags=USE_PRESENT


[5060]
LongName=Pirates of the Caribbean - At World's End
ShortName=potcawe
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\At Worlds End.exe\Path
LauncherExe=At Worlds End.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
;InGameRenderer=D3D9
;InGameFlags=USE_PRESENT


[5061]
LongName=Halo 2
ShortName=halo2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft Games\Halo 2\1.0\GameInstallDir
LauncherExe=halo2.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5062]
LongName=Attack on Pearl Harbor
ShortName=aoph
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Attack on Pearl Harbor\UninstallString
LauncherDirTruncAt=Uninstall.exe
LauncherExe=Attack On Pearl Harbor.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5063]
LongName=Red Alert: A Path Beyond
ShortName=raapb
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Red Alert - A Path Beyond\UninstallString
LauncherDirTruncAt=uninst.exe
LauncherExe=renalert.exe
LauncherPasswordArgs=+pass %UA_GAME_HOST_PASSWORD%
LauncherNetworkArgs=+connect %UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT% %UA_LAUNCHER_PASSWORD_ARGS%
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
ServerStatusType=RNG
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE
DisconnectTolerance=8


[5064_1]
LongName=Entropia Universe
ShortName=enuniv
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Project Entropia\InstallLocation
LauncherExe=ClientLoader.exe
DetectExe=entropia.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
VistaInGameFlags=ENABLE_MOUSE|DISABLE_RELEASE|DISABLE_SCREENSHOTS
InGameFlags=USE_PRESENT|USE_SWAPCHAIN|ENABLE_MOUSE|DISABLE_RELEASE


[5064_2]
LongName=Entropia Universe
ShortName=enuniv
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Entropia Universe\InstallLocation
LauncherExe=ClientLoader.exe
DetectExe=entropia.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
VistaInGameFlags=ENABLE_MOUSE|DISABLE_RELEASE|DISABLE_SCREENSHOTS
InGameFlags=USE_PRESENT|USE_SWAPCHAIN|ENABLE_MOUSE|DISABLE_RELEASE


[5065]
LongName=World of Padman
ShortName=wop
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\World of Padman\Path
LauncherExe=wop.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE|USE_DINPUT1
InGameOGLTextureOffset=32000


[5066]
LongName=Populous - The Beginning
ShortName=popu
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Bullfrog Productions Ltd\Populous: The Beginning\InstallPath
LauncherExe=populous_menu.exe
DetectExe[0]=D3DPopTB.exe
DetectExe[1]=popTB.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5067]
LongName=Populous - The Beginning - Undiscovered Worlds
ShortName=popu2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Bullfrog Productions Ltd\Populous: The Beginning\InstallPath
LauncherExe=populous_menu.exe
DetectExe[0]=D3DPopTBUW.exe
DetectExe[1]=popTBUW.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5068_1]
LongName=Tomb Raider - Anniversary
ShortName=tombra
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Crystal Dynamics\Tomb Raider: Anniversary\InstallPath
LauncherExe=tra.exe
InstallHint=uninsttra.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5068_2]
LongName=Tomb Raider - Anniversary
ShortName=tombra
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=Steam.exe
DetectExe=SteamApps\*\tomb raider anniversary\tra.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 8000 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE


[5069]
LongName=Baldur's Gate II
ShortName=baldur2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\BG2Main.Exe\Path
LauncherExe=baldur.exe
DetectExe=BGMain.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5070]
LongName=Birth of America
ShortName=bofa
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\BoA.exe\Path
LauncherExe=BoA.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5071]
LongName=Neverwinter Nights 2 AMD 64 Version
ShortName=nwn2amd
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Obsidian\NWN 2\Neverwinter\Location
LauncherExe=nwn2main_amdxp.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS% %UA_LAUNCHER_PASSWORD_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE|DISABLE_RELEASE


[5073]
LongName=Harry Potter and the Sorcerer's Stone
ShortName=hpotter
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\EA GAMES\Harry Potter\Install Dir
LauncherDirAppend=\system
LauncherExe=Hp.exe
DetectExe=Hp.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D7
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE|USE_DINPUT1


[5074]
LongName=Harry Potter - Quidditch World Cup
ShortName=hpqwc
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\QWC.exe\Path
LauncherExe=QWC.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5075]
LongName=Sword of the Stars - Born of Blood
ShortName=sotsbob
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Sword of the Stars\InstallDir
LauncherExe=Born of Blood.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5076]
LongName=Audition
ShortName=aud
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{6CB9AF08-79AE-4020-84A8-29CF15C67BD5}\InstallLocation
LauncherExe=Patcher.exe
DetectExe=Audition.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
;InGameRenderer=D3D9
;InGameFlags=DISABLE_RELEASE
RunElevated=1


[5077]
LongName=DiRT
ShortName=dirt
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Codemasters\DIRT\PATH_APPLICATION
LauncherExe=DiRT.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
;InGameRenderer=D3D9
;InGameFlags=USE_PRESENT


[5078]
LongName=Scions of fate
ShortName=scions
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{7F57DD27-15B3-4B13-B38C-714EA4456FA0}\InstallLocation
LauncherExe=launcher.exe
DetectExe=Client\Client.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|DISABLE_FOR_VISTA|USE_WINDOWS_INPUT|BLOCK_ASYNC|ENABLE_MOUSE
RunElevated=1


[5079]
LongName=Tremulous
ShortName=trem
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Tremulous\InstallDir
LauncherExe=tremulous.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE|USE_DINPUT1
InGameOGLTextureOffset=32000


[5080_1]
LongName=Enemy Territory: QUAKE Wars
ShortName=etqw
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Id\ET - QUAKE Wars\InstallPath
LauncherExe=etqw.exe
LauncherLoginArgs=+set net_accountName %UA_GAME_LOGIN_NAME% +set net_accountPassword %UA_GAME_LOGIN_PASSWORD%
LauncherRconArgs=+set net_ClientRemoteConsolePassword "%UA_GAME_RCON_PASSWORD%"
LauncherPasswordArgs=+set password %UA_GAME_HOST_PASSWORD%
LauncherNetworkArgs=+set net_autoConnectServer %UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT% %UA_LAUNCHER_PASSWORD_ARGS% %UA_LAUNCHER_RCON_ARGS%
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_LOGIN_ARGS% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
ServerStatusType=ETQW
InGameRenderer=OGL
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE
InGameOGLTextureOffset=32000
RunElevated=1


[5080_2]
LongName=Enemy Territory: QUAKE Wars
ShortName=etqw
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=Steam.exe
DetectExe=SteamApps\*\enemy territory quake wars\etqw.exe
LauncherLoginArgs=+set net_accountName %UA_GAME_LOGIN_NAME% +set net_accountPassword %UA_GAME_LOGIN_PASSWORD%
LauncherRconArgs=+set net_ClientRemoteConsolePassword "%UA_GAME_RCON_PASSWORD%"
LauncherPasswordArgs=+set password %UA_GAME_HOST_PASSWORD%
LauncherNetworkArgs=+set net_autoConnectServer %UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT% %UA_LAUNCHER_PASSWORD_ARGS% %UA_LAUNCHER_RCON_ARGS%
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 10000 %UA_LAUNCHER_LOGIN_ARGS% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
ServerStatusType=ETQW
InGameRenderer=OGL
InGameOGLTextureOffset=32000
RunElevated=1


[5081]
LongName=Catz (Deprecated)
ShortName=catzd


[5082]
LongName=Dogz (Deprecated)
ShortName=dogzd


[5083]
LongName=The Sims 2 H&M Fashion Stuff
ShortName=sims2hm
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Sims2SP5.exe\Path
LauncherExe=TSBin\Sims2SP5.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5084]
LongName=The Sims Pet Stories
ShortName=sims2ps
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\SimsPS.exe\Path
LauncherExe=TSBin\SimsPS.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5085]
LongName=Overlord
ShortName=ovrlrd
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Codemasters\Overlord\InstallPath
LauncherExe=Overlord.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=DISABLE_RELEASE|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5086]
LongName=Monster Madness - Battle for Suburbia
ShortName=mmbfs
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\ArtificialStudios\MonsterMadness\GamePath
LauncherExe=MonsterLauncher.exe
DetectExe=MonsterGame.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
;InGameRenderer=D3D9
;InGameFlags=USE_PRESENT


[5087]
LongName=Lost Planet Extreme Condition
ShortName=lpec
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=Steam.exe
DetectExe=SteamApps\*\lost planet extreme condition\LostPlanetDx9.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 6510 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT


[5088]
LongName=Harry Potter and the Order of the Phoenix
ShortName=hpop
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\hp.exe\Path
LauncherExe=hp.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5089]
LongName=D.i.R.T. - Origin of the Species
ShortName=dirtos
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{BCF89692-CD8B-4427-B408-8BE9EE7B973B}\InstallLocation
LauncherExe=NuEnginePC.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5090]
LongName=Hospital Tycoon
ShortName=hosty
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\HospitalTycoon\UninstallString
LauncherDirTruncAt=Uninstall.exe
LauncherExe=HospitalTycoon.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE


[5091_1]
LongName=Mount & Blade
ShortName=mb
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Mount&Blade\UninstallString
LauncherDirTruncAt=uninstall.exe
LauncherExe=mount&blade.exe
InstallHint=uninstall.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5091_2]
LongName=Mount & Blade
ShortName=mb
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\mount and blade\mount&blade.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 22100 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
;InGameRenderer=D3D9
;InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE|DISABLE_RELEASE


[5092]
LongName=World in Conflict - BETA
ShortName=wicb
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Massive Entertainment AB\World in Conflict - BETA\InstallPath
LauncherExe=wic.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
DetectServer=FALSE
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5093]
LongName=Mysteries of the Sith
ShortName=mots
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\LucasArts Entertainment Company LLC\Mysteries of the Sith\v1.0\Install Path
LauncherExe=JKM.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5094]
LongName=Sword of the New World
ShortName=sotnw
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Sword of The New World_is1\Inno Setup: App Path
LauncherExe=ge.exe
DetectExe=release\ge.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|DISABLE_RELEASE|ENABLE_MOUSE
DetectServer=FALSE


[5095]
LongName=Transformers - The Game
ShortName=ttg
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Activision\Transformers\InstallPath
LauncherExe=Transformers.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
;InGameRenderer=D3D9
;InGameFlags=USE_PRESENT|CHECK_LISTENER


[5096_1]
LongName=Insurgency - Modern Infantry Combat
ShortName=insmic
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\source sdk base\HL2.exe
CommandLineMustContain[0]="\sourcemods\insurgency"
InstallHint=steamapps\SourceMods\insurgency\resource\insurgency.ttf
LauncherPasswordArgs=+password %UA_GAME_HOST_PASSWORD%
LauncherNetworkArgs="%UA_LAUNCHER_PASSWORD_ARGS% +connect %UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT%"
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 215 -game "%UA_LAUNCHER_EXE_DIR%\steamapps\sourcemods\insurgency" %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
ServerStatusType=SOURCE
ServerGameName=Insurgency
ServerEncodingType=UTF8
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5096_2]
LongName=Insurgency - Modern Infantry Combat
ShortName=insmic
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\insurgency\HL2.exe
InstallHint=steamapps\*\insurgency\insurgency\resource\Insurgency.ttf
LauncherPasswordArgs=+password %UA_GAME_HOST_PASSWORD%
LauncherNetworkArgs="%UA_LAUNCHER_PASSWORD_ARGS% +connect %UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT%"
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 17700 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
ServerStatusType=SOURCE
ServerGameName=Insurgency
ServerEncodingType=UTF8
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5097_1]
LongName=Ghost Recon Advanced Warfighter 2
ShortName=graw2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\ghost recon advanced warfighter 2\graw2.exe
InstallHint=SteamApps\*\ghost recon advanced warfighter 2\installscript.vdf
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 13510 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|BLOCK_ASYNC


[5097_2]
LongName=Ghost Recon Advanced Warfighter 2
ShortName=graw2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Ubisoft\Ghost Recon Advanced Warfighter 2\InstalledPath
LauncherExe=graw2.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5098]
LongName=Kwonho
ShortName=kwonho
LauncherDirKey=HKEY_CURRENT_USER\Software\HanGame.Com\ENGLISH\RadioGames\U_KwonHoOnline\Install_Dir
LauncherExe=Launcher.exe
DetectExe=KwonHoClient.exe
PlayingDetectType=ByWindow
ProcessWindowTitle=KwonHoOnline
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=VALIDATE_USING_EXE_NAME|ENABLE_MOUSE|USE_DINPUT_MOUSE
DetectServer=FALSE


[5099_1]
LongName=Penumbra Overture Ep1
ShortName=poe1
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{2EF0D7ED-F944-4E0D-AC78-7DA00C0B81E4}_is1\Inno Setup: App Path
LauncherDirAppend=\redist
LauncherExe=Penumbra.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
;InGameRenderer=OGL
;InGameOGLTextureOffset=32000


[5099_2]
LongName=Penumbra Overture Ep1
ShortName=poe1
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{79A2AB22-00D8-4F09-A00A-F1CB7DB3E916}_is1\Inno Setup: App Path
LauncherDirAppend=\Overture\redist
LauncherExe=Penumbra.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE
InGameOGLTextureOffset=32000


[5100]
LongName=Taito Legends 2
ShortName=tl2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Empire Interactive\Taito Legends 2\Installation Path
LauncherExe=Taito.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5101]
LongName=Dungeon Runners
ShortName=drs
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\NCsoft\DungeonRunners\InstallPath
LauncherExe=DungeonRunners.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE
DetectServer=FALSE
RunElevated=1


[5102]
LongName=3D Model Trains
ShortName=3dmt
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Abacus\3D Model Trains\InstallDir
LauncherExe=3DMODTRAINS.EXE
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5103_1]
LongName=Civilization IV - Beyond the Sword
ShortName=civ4bts
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Firaxis Games\Sid Meier's Civilization 4 - Beyond the Sword\INSTALLDIR
LauncherExe=Civ4BeyondSword.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE
RunElevated=1


[5103_2]
LongName=Civilization IV - Beyond the Sword
ShortName=civ4bts
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\sid meier's civilization iv beyond the sword\Beyond the Sword
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 8800 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE
RunElevated=1


[5104_1]
LongName=Baseball Mogul 2007
ShortName=bbmog07
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\SportsMogul\BaseballMogul\2007\LastDir
LauncherExe=bb2k7.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
RunElevated=1


[5104_2]
LongName=Baseball Mogul 2007
ShortName=bbmog07
LauncherDirDefault=C:\Program Files\Sports Mogul\Baseball 2007
LauncherExe=bb2k7.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
RunElevated=1


[5105]
LongName=MicroMachines V4
ShortName=mmv4
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Codemasters\MMV4\1.00.0000\installpathname
LauncherExe=launch.exe
DetectExe=MMV4.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|DISABLE_FOR_VISTA|USE_SWAPCHAIN|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5106]
LongName=Catz
ShortName=catz
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Ubisoft\Catz\InstallPath
LauncherExe=Catz.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|DISABLE_RELEASE|USE_PRESENT|ENABLE_MOUSE


[5107]
LongName=Dogz
ShortName=dogz
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Ubisoft\Dogz\InstallPath
LauncherExe=Dogz.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|DISABLE_RELEASE|USE_PRESENT|ENABLE_MOUSE


[5108_1]
LongName=Rappelz Epic5
ShortName=rappelz4
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{E144A786-D2DD-428B-9C1A-0EE3FA3515EA}\InstallLocation
LauncherExe=launcher.exe
DetectExe=sframe.exe
PlayingDetectType=ByWindowSubstr
ProcessWindowTitle=Rappelz
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|SKIP_DEVICE_RELEASE|BLOCK_ASYNC|ENABLE_MOUSE|USE_DINPUT_MOUSE|VALIDATE_USING_EXE_NAME|DISABLE_DIRECT_INPUT_HOOK|REINSTALL_KEYBOARD_HOOK|DISABLE_FOR_VISTA
DetectServer=FALSE
RunElevated=1


[5108_2]
LongName=Rappelz Epic5
ShortName=rappelz4
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{01A8838A-9469-425F-A5FB-FC14D4CF93B9}\InstallLocation
LauncherExe=launcher.exe
DetectExe=sframe.exe
PlayingDetectType=ByWindowSubstr
ProcessWindowTitle=Rappelz
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|SKIP_DEVICE_RELEASE|BLOCK_ASYNC|ENABLE_MOUSE|USE_DINPUT_MOUSE|VALIDATE_USING_EXE_NAME|DISABLE_DIRECT_INPUT_HOOK|REINSTALL_KEYBOARD_HOOK|DISABLE_FOR_VISTA
DetectServer=FALSE
RunElevated=1


[5109]
LongName=Metin 2
ShortName=metin2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\G4Box\Metin2\DestDir
LauncherExe=metin2.exe
DetectExe=metin2.bin
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=ENABLE_MOUSE|USE_PRESENT|DISABLE_FOR_VISTA
DetectServer=FALSE


[5110]
LongName=Tabula Rasa
ShortName=trasa
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\NCsoft\TabulaRasa\InstallPath
LauncherExe=tabula_rasa.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE|DISABLE_RELEASE
DetectServer=FALSE


[5111_1]
LongName=Warhammer Online Beta
ShortName=who
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Warhammer Online - Age of Reckoning BETA 2_is1\InstallLocation
LauncherExe=warpatch.exe
DetectExe=war.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
;InGameRenderer=D3D9
;InGameFlags=USE_PRESENT|USE_WINDOWS_INPUT|DISABLE_RELEASE|DISABLE_SCREENSHOTS
DetectServer=FALSE
RunElevated=1


[5111_2]
LongName=Warhammer Online Beta
ShortName=who
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Warhammer Online - Age of Reckoning BETA 2_is1\InstallLocation
LauncherExe=warpatch.exe
DetectExe=warhammer.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
;InGameRenderer=D3D9
;InGameFlags=USE_PRESENT|USE_WINDOWS_INPUT|DISABLE_RELEASE|DISABLE_SCREENSHOTS
DetectServer=FALSE
RunElevated=1


[5112]
LongName=Avencast
ShortName=aven
LauncherDirDefault=C:\Program Files\Avencast_Beta3
LauncherExe=avencast.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5113]
LongName=2Moons
ShortName=2moo
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{0B69C194-49D3-4A47-A0F9-BBEEAC28E886}\InstallLocation
LauncherExe=minilauncher.exe
PlayingDetectType=ByWindowSubstr
ProcessWindowTitle=2Moons
DetectExe=bin\dekaron.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|USE_SWAPCHAIN|VALIDATE_USING_EXE_NAME|DISABLE_RELEASE|ENABLE_MOUSE|DISABLE_FOR_VISTA
DetectServer=FALSE


[5114]
LongName=DANCE! Online
ShortName=danceo
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{AFE7023B-FADC-4D91-AC95-BFC214060F3E}\InstallLocation
LauncherExe=DANCE!ONLINE.exe
DetectExe=client.bin
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|VALIDATE_USING_EXE_NAME|DISABLE_FOR_VISTA|ENABLE_MOUSE|USE_SWAPCHAIN
DetectServer=FALSE


[5115]
LongName=Madden NFL 08
ShortName=madnfl8
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Madden08.exe\Path
LauncherExe=Madden08.exe
DetectExe=mainapp.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5116]
LongName=Shadowrun
ShortName=shadrun
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft Games\Shadowrun\1.0\SetupPath
LauncherExe=Shadowrun.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE
DetectServer=FALSE


[5117]
LongName=FreeStyle Street Basketball
ShortName=fsb
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{E192E363-0D29-4D22-B034-F2E457CC0660}\InstallLocation
LauncherExe=FSBox.exe
DetectExe=FreeStyle.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5118_1]
LongName=BioShock Demo
ShortName=biosdemo
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{36BBA884-C697-48B6-B496-5F329215E249}\InstallLocation
LauncherDirAppend=\Builds\Release
LauncherExe=Bioshock.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer[0]=D3D9
InGameRenderer[1]=D3D10
InGameFlags[0]=USE_PRESENT|VERIFY_THREADID|ENABLE_MOUSE
InGameFlags[1]=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5118_2]
LongName=BioShock Demo
ShortName=biosdemo
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=Steam.exe
DetectExe=SteamApps\*\bioshock demo\Builds\Release\bioshock.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 7710 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer[0]=D3D9
InGameRenderer[1]=D3D10
InGameFlags[0]=USE_PRESENT|VERIFY_THREADID|ENABLE_MOUSE
InGameFlags[1]=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE

[5122]
LongName=World in Conflict - DEMO
ShortName=wicd
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Massive Entertainment AB\World in Conflict - DEMO\InstallPath
LauncherExe=wic.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE
DetectServer=FALSE


[5123]
LongName=Two Worlds Demo
ShortName=tworsd
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Reality Pump\TwoWorldsDemo\FileSystem\OutputDir
LauncherExe=TwoWorldsDemo.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE
DetectServer=FALSE


[5124]
LongName=Two Worlds
ShortName=twors
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Reality Pump\TwoWorlds\FileSystem\OutputDir
LauncherExe=TwoWorlds.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE
DetectServer=FALSE


[5125_1]
LongName=Medieval II Total War: Kingdoms
ShortName=m2twk
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=Steam.exe
DetectExe=SteamApps\*\medieval ii total war\kingdoms.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 4780 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|DISABLE_RELEASE|ENABLE_MOUSE|DISABLE_FOR_VISTA


[5125_2]
LongName=Medieval II Total War: Kingdoms
ShortName=m2twk
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\SEGA\Medieval II Total War\AppPath
LauncherExe=Launcher.exe
DetectExe=kingdoms.exe
InstallHint=Launcher.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|DISABLE_RELEASE|ENABLE_MOUSE|DISABLE_FOR_VISTA


[5125_3]
LongName=Medieval II Total War: Kingdoms
ShortName=m2twk
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\SEGA\Medieval II Total War\AppPath
LauncherExe=kingdoms.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|DISABLE_RELEASE|ENABLE_MOUSE|DISABLE_FOR_VISTA


[5126]
LongName=Tiger Woods PGA Tour 08
ShortName=twpga08
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\TW2008.exe\Path
LauncherDirAppend=\bin
LauncherExe=TW2008.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT


[5127]
LongName=Desperate Housewives
ShortName=dhwives
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Buena Vista Games\Desperate Housewives\NULL\Install Path
LauncherExe=DesperateHousewives.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT


[5128_1]
LongName=Urban Terror
ShortName=utq3
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Id\Quake III Arena\INSTALLPATH
LauncherExe=quake3.exe
InstallHint=q3ut4\q3ut.ico
LauncherRconArgs=+rconpassword "%UA_GAME_RCON_PASSWORD%"
LauncherPasswordArgs=+password "%UA_GAME_HOST_PASSWORD%"
LauncherNetworkArgs=%UA_LAUNCHER_PASSWORD_ARGS% %UA_LAUNCHER_RCON_ARGS% +connect %UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT%
Launch=%UA_LAUNCHER_EXE_PATH% +set fs_game q3ut4 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
CommandLineMustContain[0]=+set fs_game q3ut4
ServerStatusType=Q3A
ServerGameName=Q3
ServerBroadcastPort=27960:4
InGameRenderer=OGL
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE|USE_DINPUT1
InGameOGLTextureOffset=32000
RunElevated=1


[5128_2]
LongName=Urban Terror
ShortName=utq3
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\ioUrbanTerror\InstallDir
LauncherExe=ioUrbanTerror.exe
LauncherRconArgs=+rconpassword "%UA_GAME_RCON_PASSWORD%"
LauncherPasswordArgs=+password "%UA_GAME_HOST_PASSWORD%"
LauncherNetworkArgs=%UA_LAUNCHER_PASSWORD_ARGS% %UA_LAUNCHER_RCON_ARGS% +connect %UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT%
Launch=%UA_LAUNCHER_EXE_PATH% +set fs_game q3ut4 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
;CommandLineMustContain[0]=+set fs_game q3ut4
ServerStatusType=Q3A
ServerGameName=Q3
ServerBroadcastPort=27960:4
InGameRenderer=OGL
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE|USE_DINPUT1
InGameOGLTextureOffset=32000
RunElevated=1


[5129]
LongName=Pet Vet 3D Animal Hospital
ShortName=pvet
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Pet Vet 3D Animal Hospital_is1\InstallLocation
LauncherExe=Pet Vet 3D Animal Hospital.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5130]
LongName=The Sims 2 Bon Voyage
ShortName=sims2bv
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Sims2EP6.exe\Path
LauncherExe=TSBin\Sims2EP6.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5131]
LongName=Enemy Territory: QUAKE Wars Demo
ShortName=etqwd
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Id\ETQW Demo\InstallPath
LauncherExe=etqw.exe
LauncherNetworkArgs=+connect %UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT%
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
ServerStatusType=ETQW
InGameRenderer=OGL
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE
InGameOGLTextureOffset=32000
RunElevated=1


[5132]
LongName=World in Conflict Single Player
ShortName=wicsp
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Massive Entertainment AB\World in Conflict\InstallPath
LauncherExe=wic.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE
DetectServer=FALSE


[5133]
LongName=World in Conflict Multiplayer
ShortName=wicmp
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Massive Entertainment AB\World in Conflict\InstallPath
LauncherExe=wic_online.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE
DetectServer=FALSE


[5134]
LongName=Team Fortress 2
ShortName=tf2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\team fortress 2\hl2.exe
LauncherPasswordArgs=+password %UA_GAME_HOST_PASSWORD%
LauncherNetworkArgs=%UA_LAUNCHER_PASSWORD_ARGS% +connect %UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT%
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 440 -novid %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
ServerStatusType=SOURCE
ServerGameName=Team Fortress
ServerEncodingType=UTF8
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE|DISABLE_RELEASE|REINSTALL_KEYBOARD_HOOK


[5135]
LongName=Peggle Extreme
ShortName=pegex
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\common\peggle extreme\PeggleExtreme.exe
;MatchExe=popcapgame1.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 3483 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
;InGameRenderer=D3D7
;InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE|DISABLE_FOR_VISTA


[5136]
LongName=Mayhem Intergalactic
ShortName=mayi
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Mayhem Intergalactic\UninstallString
LauncherDirTruncAt=uninst.exe
LauncherExe=mayhemig.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL
InGameFlags=ENABLE_MOUSE
InGameOGLTextureOffset=32000


[5137]
LongName=Mayhem Intergalactic Demo
ShortName=mayid
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Mayhem Intergalactic Demo\UninstallString
LauncherDirTruncAt=uninst.exe
LauncherExe=mayhemig-demo.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL
InGameFlags=ENABLE_MOUSE
InGameOGLTextureOffset=32000


[5138]
LongName=Crysis MP Beta
ShortName=cmpb
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Crytek\Crysis_MP_Beta\InstallDir
LauncherDirAppend=\Bin32
LauncherExe=Crysis.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE


[5139]
LongName=Frontlines: Fuel of War Beta
ShortName=ffowb
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\THQ\Frontlines: Fuel of War Beta\InstallDir
LauncherDirAppend=\Binaries
LauncherExe=FFOW-Beta.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE
DetectServer=FALSE
RunElevated=1
ServerStatusType=FFOW


[5140]
LongName=Drift City
ShortName=dcity
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\DriftCity\Install_Dir_US
LauncherUrl=http://drift.ijji.com
DetectExe=DriftCity.exe
PlayingDetectType=ByWindowSubstr
ProcessWindowTitle=Drift City
Launch=%UA_LAUNCHER_URL% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|VALIDATE_USING_EXE_NAME|ENABLE_MOUSE|DISABLE_FOR_VISTA
DetectServer=FALSE


[5141]
LongName=John Woo Presents Stranglehold
ShortName=sthold
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{86EDEF11-EFE4-46CB-8B08-9CBD4A936B1F}\InstallLocation
LauncherDirAppend=\Binaries
LauncherExe=Retail-Stranglehold.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5142_1]
LongName=NHL 08
ShortName=nhl08
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\EA SPORTS\NHL08\Install Dir
LauncherExe=nhl2008.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT


[5142_2]
LongName=NHL 08
ShortName=nhl08
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\EA SPORTS\NHL08\Install Dir
LauncherExe=nhl2008pal.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT


[5144]
LongName=Blazing Angels 2: Secret Missions of WWII
ShortName=ba2sm
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Ubisoft\BlazingAngels2\{D8768524-DE8D-40D3-904B-B1FCC31CF9F9}\InstallPath
LauncherExe=Launcher.exe
DetectExe=bin\BA2.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5145]
LongName=Big Mutha Truckers 2
ShortName=bmt2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{E5D83C4C-02E3-44D1-8FED-337383F36A54}\InstallLocation
LauncherDirAppend=\bin
LauncherExe=bmt2.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5146]
LongName=Fortress Forever
ShortName=ffever
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\source sdk base\HL2.exe
CommandLineMustContain[0]="\sourcemods\FortressForever"
InstallHint=steamapps\SourceMods\FortressForever\resource\StatusGlyphs.ttf
LauncherPasswordArgs=+password %UA_GAME_HOST_PASSWORD%
LauncherNetworkArgs="%UA_LAUNCHER_PASSWORD_ARGS% +connect %UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT%"
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 215 -game "%UA_LAUNCHER_EXE_DIR%\steamapps\sourcemods\FortressForever" %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
ServerStatusType=SOURCE
ServerGameName=Fortress Forever
ServerEncodingType=UTF8
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5147]
LongName=The Settlers: Rise of an Empire
ShortName=sett6
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Ubisoft\The Settlers 6\GameUpdate\InstallDir
LauncherDirAppend=\base\bin
LauncherExe=Settlers6.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5148_1]
LongName=Babo Violent 2
ShortName=bv2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Babo Violent 2_is1\Inno Setup: App Path
LauncherExe=bv2.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE


[5148_2]
LongName=Babo Violent 2
ShortName=bv2
LauncherDirDefault=C:\Program Files\RndLabs\BaboViolent 2
LauncherExe=Bv2Launcher.exe
DetectExe=bv2.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE


[5149]
LongName=CodeNameD: BlueShift
ShortName=cdblue
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\nioDesign\BlueShift\path
LauncherExe=blueshift.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5150]
LongName=KartRider
ShortName=kartr
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\KartRider\InstallLocation
LauncherExe=KartRider.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|DISABLE_RELEASE|DISABLE_FOR_VISTA
RunElevated=1


[5151]
LongName=CSI: Hard Evidence
ShortName=csihe
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{FC1C2427-5954-451C-9ED8-A92D48ED7E07}\InstallLocation
LauncherExe=GameUpdate.exe
DetectExe=CSI4.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=USE_PRESENT|ENABLE_MOUSE
RunElevated=1


[5152]
LongName=UFO: Afterlight
ShortName=ufoal
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=Steam.exe
DetectExe=SteamApps\*\ufo afterlight\UFO.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 7500 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL
InGameFlags=ENABLE_MOUSE
InGameOGLTextureOffset=32000
RunElevated=1


[5153]
LongName=Portal
ShortName=portal
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\portal\hl2.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 400 -novid %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE
RunElevated=1


[5154]
LongName=Half-Life 2: Episode Two
ShortName=hl2e2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\half-life 2 episode two\hl2.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 420 -novid %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE
RunElevated=1


[5155]
LongName=FIFA 08
ShortName=fifa08
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\EA SPORTS\FIFA 08\Install Dir
LauncherExe=fifa08.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|DISABLE_RELEASE


[5156_1]
LongName=Loki
ShortName=loki
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Loki\UninstallString
LauncherDirTruncAt=unins000.exe
LauncherExe=Loki.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|DISABLE_RELEASE|BLOCK_ASYNC


[5156_2]
LongName=Loki
ShortName=loki
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\loki\Loki.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 7260 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|DISABLE_RELEASE|BLOCK_ASYNC


[5157]
LongName=Call of Duty 4: Modern Warfare Demo
ShortName=cod4mwd
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Activision\CoD4MWDemo\InstallPath
LauncherExe=iw3sp.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|USE_SWAPCHAIN


[5158_1]
LongName=Unreal Tournament 3 Demo
ShortName=ut3
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\UserData\S-1-5-18\Products\9AEF66239E89B8442B53AD6CD3C47E18\InstallProperties\InstallLocation
LauncherExe=Binaries\UT3Demo.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|DISABLE_RELEASE


[5158_2]
LongName=Unreal Tournament 3 Demo
ShortName=ut3
LauncherDirKey=HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Uninstall\InstallShield_{3266FEA9-98E9-448B-B235-DAC63D4CE781}\InstallLocation
LauncherExe=Binaries\UT3Demo.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|DISABLE_RELEASE


[5159]
LongName=Project Torque
ShortName=ptorq
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Invictus-Games\ProjectTorque\InstallDirectory
LauncherExe=ProjectTorque.exe
DetectExe=ProjectTorque.bin
;PlayingDetectType=ByWindowSubstr
;ProcessWindowTitle=Game build
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE
DetectServer=FALSE
RunElevated=1


[5160]
LongName=Sid Meier's SimGolf
ShortName=smsg
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Firaxis Games\Sid Meier's SimGolf\Install_Path
LauncherExe=golf.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5161]
LongName=Legends
ShortName=legend
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Legends\shell\open\command\Path
LauncherDirTruncAt=Legends.exe
LauncherExe=Legends.exe
DetectExe=Win32binary.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE|DISABLE_RELEASE
InGameOGLTextureOffset=32000


[5162]
LongName=Brain Spa
ShortName=bspa
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Brain Spa\UninstallString
LauncherDirTruncAt=Uninstall.exe
LauncherExe=brainspa.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5163_1]
LongName=Heroes of Might and Magic V: Tribes of the East
ShortName=homm5toe
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\H5_Game.exe\Path
LauncherExe=H5_Game.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT


[5163_2]
LongName=Heroes of Might and Magic V: Tribes of the East
ShortName=homm5toe
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\heroes of might and magic 5 tribes of the east\bin\H5_Game.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 15370 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT


[5164]
LongName=Fury
ShortName=fury
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Auran\Fury\InstallPath
LauncherDirAppend=\Binaries
LauncherExe=FuryLauncher.exe
DetectExe[0]=FuryLowSpec.exe
DetectExe[1]=Fury.exe
DetectExe[2]=FuryDX10.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer[0]=D3D9
InGameRenderer[1]=D3D9
InGameRenderer[2]=D3D10
InGameFlags[0]=USE_PRESENT|USE_SWAPCHAIN|ENABLE_MOUSE|USE_DINPUT_MOUSE
InGameFlags[1]=USE_PRESENT|USE_SWAPCHAIN|ENABLE_MOUSE|USE_DINPUT_MOUSE
InGameFlags[2]=USE_PRESENT|USE_SWAPCHAIN|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5165]
LongName=Hellgate: London Demo
ShortName=hgld
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Flagship Studios\Hellgate London Demo\HellgateKey
LauncherExe=Launcher.exe
DetectExe=SP_x86\hellgateDemo_sp_dx9_x86.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|USE_SWAPCHAIN|DISABLE_RELEASE|BLOCK_ASYNC|ENABLE_MOUSE|SUBCLASS_WNDPROC|BLOCK_ASYNC
DetectServer=FALSE
AlwaysFullScreen=1


[5166_1]
LongName=City Life Deluxe
ShortName=citylifed
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\common\city life deluxe\BIN\CLD.exe
InstallHint=steamapps\common\city life deluxe\BIN\dbghelp.dll
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 4410 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE|DISABLE_RELEASE
RunElevated=1


[5166_2]
LongName=City Life Deluxe
ShortName=citylifed
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Path
LauncherDirAppend=\BIN
LauncherExe=CLD.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE|DISABLE_RELEASE
RunElevated=1


[5167]
LongName=Galactic Civilizations II: Dark Avatar
ShortName=gciv2da
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Stardock\Drengin.net\GalCiv2\Path
LauncherDirAppend=\DarkAvatar
LauncherExe=DALaunch.exe
DetectExe=GC2DarkAvatar.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|DISABLE_RELEASE|ENABLE_MOUSE


[5168]
LongName=CSPromod Beta
ShortName=cspro
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\counter-strike source\HL2.exe
CommandLineMustContain[0]="\sourcemods\cspromod"
InstallHint=steamapps\SourceMods\cspromod\serverconfig.vdf
LauncherPasswordArgs=+password %UA_GAME_HOST_PASSWORD%
LauncherNetworkArgs="%UA_LAUNCHER_PASSWORD_ARGS% +connect %UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT%"
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 240 -game "%UA_LAUNCHER_EXE_DIR%\steamapps\sourcemods\cspromod" %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
ServerStatusType=SOURCE
ServerGameName=CSPromod BETA 1.03
ServerEncodingType=UTF8
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE|USE_PRESENT|DISABLE_RELEASE
RunElevated=1


[5169]
LongName=8BallClub
ShortName=ballclub
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\8BallClub\InstallLocation
LauncherExe=GameDirector.exe
DetectExe=EightBall.bin
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE
DetectServer=FALSE


[5170]
LongName=Worldwide Soccer Manager 2008
ShortName=wwsm08
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Worldwide Soccer Manager 2008\InstallLocation
LauncherExe=wsm.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5171]
LongName=Football Manager 2008
ShortName=fm08
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Sports Interactive Ltd\Installs\Football Manager 2008\Path
LauncherExe=fm.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5172_1]
LongName=Clive Barker's Jericho
ShortName=jericho
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Codemasters\Jericho\0.10.0000\DIRECTORY
LauncherDirAppend=\bin
LauncherExe=Jericho.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5172_2]
LongName=Clive Barker's Jericho
ShortName=jericho
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=steamapps\common\clive barker's jericho\bin\Jericho.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 11420 -game %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT


[5173]
LongName=Age of Empires III: The Asian Dynasties
ShortName=aoe3ad
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft Games\Age of Empires 3\1.0\SetupPath
LauncherExe=age3y.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|CHECK_LISTENER


[5174]
LongName=Dynasty Warriors 4 Hyper
ShortName=dw4h
LauncherDirKey=HKEY_CURRENT_USER\Software\Koei\Dynasty Warriors 4 Hyper\Install\InstallInfo
LauncherExe=Launcher.exe
DetectExe=Dynasty Warriors 4 Hyper.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5175]
LongName=Crysis SP Demo
ShortName=crysisd
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Crytek\Crysis_SP_Demo\InstallDir
LauncherDirAppend=\Bin32
LauncherExe=Crysis.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5176]
LongName=Painkiller: Overdose
ShortName=pnklrod
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Painkiller Overdose_is1\InstallLocation
LauncherDirAppend=\bin
LauncherExe=Overdose.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5177]
LongName=SunAge
ShortName=sunage
LauncherDirKey=HKEY_LOCAL_MACHINE\Software\vertex4\SunAge\path
LauncherExe=SunAge.exe
LobbyJoinString=-xfjs:%UA_GAME_HOST_NAME%
LobbyHostString=-xfhs
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_LOBBY_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE
LobbyType=CMD


[5178]
LongName=Luminary: Rise of Goonzu
ShortName=lrgoon
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Luminary - Rise of Goonzu\UninstallString
LauncherDirTruncAt=uninst.exe
LauncherUrl=http://luminary.ijji.com/
DetectExe=Luminary.exe
PlayingDetectType=ByWindow
ProcessWindowTitle=Luminary
Launch=%UA_LAUNCHER_URL% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5179_1]
LongName=The Witcher
ShortName=twitch
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{F138762F-5A1F-4CF0-A5E1-1588EF6088A4}\InstallLocation
LauncherExe=launcher.exe
DetectExe=System\witcher.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|DISABLE_RELEASE|ENABLE_MOUSE


[5179_2]
LongName=The Witcher
ShortName=twitch
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\the witcher enhanced edition\System\witcher.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 20900 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|DISABLE_RELEASE|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5180]
LongName=TimeShift
ShortName=tshift
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Sierra Entertainment\TimeShift\1.00.000\PathToEXE
LauncherDirTruncAt=TimeShift.Exe
LauncherExe=TimeShift.Exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT


[5181]
LongName=Happy Feet
ShortName=hfeet
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{32BFCEAF-99D4-4D00-9A5B-DD818DF3CB93}\InstallLocation
LauncherExe=GameLauncher.exe
DetectExe=EngineImplementation_Retail.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|DISABLE_RELEASE


[5182]
LongName=NBA Live 08
ShortName=nbal08
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\EA SPORTS\NBA LIVE 08\Install Dir
LauncherExe=nbalive08.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_DINPUT1|DISABLE_RELEASE|ENABLE_MOUSE|USE_DINPUT_MOUSE|USE_PRESENT


[5183]
LongName=Taito Legends
ShortName=tl
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Empire Interactive\Taito Legends\Installation Path
LauncherExe=Taito.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5184]
LongName=Perfect World
ShortName=pw
LauncherDirDefault=C:\Perfect World\
LauncherExe=launcher\launcher.exe
DetectExe=element\elementclient.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=USE_PRESENT|ENABLE_MOUSE
RunElevated=1


[5185_1]
LongName=Call of Duty 4: Modern Warfare Single Player
ShortName=cod4sp
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Activision\Call of Duty 4\InstallPath
LauncherExe=iw3sp.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|USE_SWAPCHAIN|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5185_2]
LongName=Call of Duty 4: Modern Warfare Single Player
ShortName=cod4sp
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\call of duty 4\iw3sp.exe
InstallHint=SteamApps\*\call of duty 4\cod4.ico
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 7940 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|USE_SWAPCHAIN|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5186_1]
LongName=Call of Duty 4: Modern Warfare Multiplayer
ShortName=cod4mp
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Activision\Call of Duty 4\InstallPath
LauncherExe=iw3mp.exe
LauncherPasswordArgs=+password "%UA_GAME_HOST_PASSWORD%"
LauncherNetworkArgs=%UA_LAUNCHER_PASSWORD_ARGS% +connect %UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT%
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
ServerStatusType=COD4MW
InGameFlags=USE_PRESENT|USE_SWAPCHAIN|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5186_2]
LongName=Call of Duty 4: Modern Warfare Multiplayer
ShortName=cod4mp
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\call of duty 4\iw3mp.exe
LauncherPasswordArgs=+password "%UA_GAME_HOST_PASSWORD%"
LauncherNetworkArgs=%UA_LAUNCHER_PASSWORD_ARGS% +connect %UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT%
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
ServerStatusType=COD4MW
InGameFlags=USE_PRESENT|USE_SWAPCHAIN|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5187]
LongName=Supreme Commander: Forged Alliance
ShortName=supcofa
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{31D95937-B237-405D-920C-A3EF4E482395}\InstallLocation
LauncherDirAppend=\bin
LauncherExe=ForgedAlliance.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE|BLOCK_ASYNC


[5188]
LongName=Empire Earth III
ShortName=ee3
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Sierra Entertainment\Empire Earth III\InstallPath
LauncherExe=EE3.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|DISABLE_RELEASE


[5189]
LongName=FEAR Perseus Mandate
ShortName=fearpm
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\TimeGate Studios\FEARXP2\1.00.0000\InstallDir
LauncherExe=Launcher.exe
DetectExe=FEARXP2.exe
LauncherPasswordArgs=+password %UA_GAME_HOST_PASSWORD%
LauncherNetworkArgs=+join %UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT% %UA_LAUNCHER_PASSWORD_ARGS%
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT
ServerStatusType=GS2
RunElevated=1


[5190]
LongName=Gears of War
ShortName=gow
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\microsoft games\Gears of War\SetupPath
LauncherExe=Startup.exe
DetectExe=WarGame-G4WLive.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5191]
LongName=Dawn of War: Soulstorm
ShortName=wh40kss
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\THQ\Dawn of War - Soulstorm\InstallLocation
LauncherExe=Soulstorm.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE
ChangeTolerance=6




[5195]
LongName=Dawn of Magic
ShortName=dmagic
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\1C Company\Dawn of Magic\INSTALL_DIR
LauncherExe=DawnOfMagic.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5196]
LongName=You Are Empty
ShortName=yae
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\DSS\You Are Empty\InstallPath
LauncherExe=you_are_empty.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE


[5197]
LongName=Guitar Hero III
ShortName=gh3
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Aspyr\Guitar Hero III\Path
LauncherExe=GH3.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5198]
LongName=Need for Speed ProStreet
ShortName=nfsp
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Electronic Arts\Need for Speed ProStreet\Install Dir
LauncherExe=nfs.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5199]
LongName=Beowulf
ShortName=beowulf
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Ubisoft\Beowulf\GameUpdate\installdir
LauncherDirAppend=\Game
LauncherExe=Beowulf.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5200]
LongName=Simcity Societies
ShortName=scs
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Electronic Arts\SimCity Societies\Install Dir
LauncherExe=SimCitySocieties.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE


[5201]
LongName=Pinball Wizards: Balls of Steel Demo
ShortName=pwbosd
LauncherDirDefault=C:\Program Files\Pinball Wizards\Balls of Steel DEMO v1.3
LauncherExe=bos.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5202]
LongName=Spider-Man: Friend or Foe
ShortName=smanff
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Activision\Spider-ManFoF\InstallPath
LauncherExe=Spider-Man Friend Or Foe.exe
DetectExe=Game.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5203]
LongName=BlackSite: Area 51
ShortName=bsite51
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{8236D2E9-2528-4C5C-ABA3-E0B8B657A297}\InstallLocation
LauncherDirAppend=\Binaries
LauncherExe=BlackSite.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|DISABLE_RELEASE


[5204]
LongName=Soldier of Fortune: Payback
ShortName=sofpb
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Cauldron\SOF3\InstallDir
LauncherExe=sof3.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT


[5205]
LongName=Viva Pinata
ShortName=vivap
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft Games\Viva Pinata\1.0\SetupPath
LauncherExe=Startup.exe
DetectExe=Viva Pinata.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5206]
LongName=WolfTeam
ShortName=wolft
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\WolfTeam International_is1\InstallLocation
LauncherExe=NyxLauncher.exe
DetectExe=Wolfteam.bin
PlayingDetectType=ByWindowSubstr
ProcessWindowTitle=WolfTeam
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
;InGameRenderer=D3D9
;InGameFlags=USE_PRESENT|VALIDATE_USING_EXE_NAME|DISABLE_DIRECT_INPUT_HOOK|REINSTALL_KEYBOARD_HOOK|ENABLE_MOUSE|USE_DINPUT_MOUSE|DISABLE_RELEASE|CHECK_LISTENER
RunElevated=1


[5207]
LongName=Fantasy Wars
ShortName=fwars
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Fantasy Wars_is1\InstallLocation
LauncherExe=fw.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE

[5210]
LongName=Next Life
ShortName=nextl
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Next Life_is1\InstallLocation
LauncherDirAppend=\bin
LauncherExe=NextLife.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5211]
LongName=Risk
ShortName=risk
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Risk\Risk\Install_Dir
LauncherExe=RiskSA.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5212]
LongName=Instinct
ShortName=instinct
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{062A8785-E349-4B26-9495-1E5FBD12F346}\InstallLocation
LauncherExe=instinct.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE


[5213]
LongName=Gothic
ShortName=goth
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\gothic.exe\Path
LauncherDirTruncAt=gothic.exe
LauncherDirAppend=\system
LauncherExe=GOTHIC.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5214]
LongName=Kane and Lynch: Dead Men
ShortName=kanelyn
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Eidos\Kane and Lynch Dead Men\InstallationPath
LauncherExe=kaneandlynch.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE


[5215]
LongName=Exteel
ShortName=exteel
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\NCsoft\Launcher\InstallPath
LauncherDirTruncAt=NCLauncher.exe
LauncherExe=NCLauncher.exe
DetectDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\NCsoft\Exteel\InstallPath
DetectExe=System\Exteel.exe
PlayingDetectType=ByWindowSubstr
ProcessWindowTitle=Exteel
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=VALIDATE_USING_EXE_NAME|DISABLE_DIRECT_INPUT_HOOK|DISABLE_FOR_VISTA


[5216]
LongName=The Office
ShortName=office
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\MumboJumbo\The Office\Install_Dir
LauncherExe=TheOffice.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5217]
LongName=Escape From Paradise City
ShortName=efpc
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Sirius\Paradise City\GameDir
LauncherExe=ParadiseCity.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE


[5218]
LongName=Catz 2
ShortName=catz2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Ubisoft\Catz2\InstallPath
LauncherExe=Catz.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|DISABLE_RELEASE


[5219]
LongName=Dogz 2
ShortName=dogz2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Ubisoft\Dogz2\InstallPath
LauncherExe=Dogz.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|DISABLE_RELEASE


[5220]
LongName=Horsez 2
ShortName=horsez2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Ubisoft\Alexandra Ledermann 8\InstalledPath
LauncherExe=CommonPlayer.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5221]
LongName=BMW M3 Challenge
ShortName=bmw
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Blimey! Games\BMW\InstallDir
LauncherExe=BMW.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5222]
LongName=Dofus
ShortName=dofus
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Ankama\Dofus\Path
LauncherExe=Dofus.exe
DetectExe=Dofus.dll
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
DetectServer=FALSE


[5223]
LongName=Quake
ShortName=quake
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\common\quake\Winquake.exe
InstallHint=steamapps\common\quake\qwcl2.ico
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 2310 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5224_1]
LongName=SEGA Rally Revo
ShortName=rallyrev
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\SEGA\SEGA Rally Revo\installdir
LauncherExe=SEGA Rally Revo Launcher.exe
DetectExe[0]=SEGA Rally Revo.exe
DetectExe[1]=SEGA Rally Revo_SSE1.exe
InstallHint=granny2.dll
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|SUBCLASS_WNDPROC


[5224_2]
LongName=SEGA Rally Revo
ShortName=rallyrev
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe[0]=SteamApps\common\sega rally revo\SEGA Rally Revo.exe
DetectExe[1]=SteamApps\common\sega rally revo\SEGA Rally Revo_SSE1.exe
InstallHint=steamapps\common\sega rally revo\SSEDetector.dll
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 4790 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|SUBCLASS_WNDPROC


[5224_3]
LongName=SEGA Rally Revo
ShortName=rallyrev
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\SEGA\SEGA Rally Revo\installdir
LauncherExe=SEGA Rally Launcher.exe
DetectExe[0]=SEGA Rally.exe
DetectExe[1]=SEGA Rally_SSE1.exe
InstallHint=granny2.dll
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|SUBCLASS_WNDPROC


[5225]
LongName=Planeshift
ShortName=planshft
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\PlaneShift\UninstallString
LauncherDirTruncAt=\Uninstall.exe
LauncherExe=psclient.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL
InGameFlags=ENABLE_MOUSE


[5226]
LongName=Alpha Prime
ShortName=aprime
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\alpha prime\AlphaPrime.exe
InstallHint=SteamApps\*\alpha prime\alphaprime.ico
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 2590 -game %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT
RunElevated=1


[5227]
LongName=Ghost in the Sheet
ShortName=gits
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Tri Synergy\Ghost in the Sheet\installed to
LauncherExe=autorun.exe
DetectExe=gits.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=ENABLE_MOUSE


[5228]
LongName=Ascension
ShortName=ascnsn
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\RenWerX\Ascension\InstallPath
LauncherExe=Ascension.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5229]
LongName=Speedball 2 - Tournament
ShortName=sball2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\common\speedball 2\Speedball2.exe
InstallHint=steamapps\common\speedball 2\ssleay32.dll
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 10700 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT


[5230]
LongName=Alvin and the Chipmunks
ShortName=alvin
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Alvin and the Chipmunks\DisplayIcon
LauncherDirTruncAt=Chipmunks.exe
LauncherExe=Chipmunks.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9


[5231_1]
LongName=Fiesta
ShortName=fiesta
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Outspark.com\Launcher\Path
LauncherExe=outspark.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
CommandLineMustNotContain[0]=solstice
CommandLineMustNotContain[1]=propow
DetectDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Outspark.com\Fiesta\Path
DetectExe=Fiesta.bin
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE
RunElevated=1
DetectServer=FALSE


[5231_2]
LongName=Fiesta
ShortName=fiesta
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Outspark.com\SharpLauncher\path
LauncherExe=OutsparkLauncher.exe
Launch=%UA_LAUNCHER_EXE_PATH% fiesta %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
CommandLineMustNotContain[0]=solstice
CommandLineMustNotContain[1]=propow
DetectDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Outspark.com\Fiesta\Path
MatchExe=Fiesta.bin
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE
RunElevated=1
DetectServer=FALSE


[5232_1]
LongName=Universe At War: Earth Assault
ShortName=uawea
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Petroglyph\UAWEA\GameExe
LauncherDirTruncAt=UAWEA.exe
LauncherExe=LaunchUAW.exe
DetectExe=UAWEA.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE|DISABLE_FOR_VISTA|DISABLE_RELEASE


[5232_2]
LongName=Universe At War: Earth Assault
ShortName=uawea
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe[0]=SteamApps\*\universe at war earth assault\UAWEA.exe
DetectExe[1]=SteamApps\*\universe at war earth assault\LaunchUAW.exe
InstallHint=steamapps\*\universe at war earth assault\mss32.dll
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 10430 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE|DISABLE_RELEASE|DISABLE_FOR_VISTA
RunElevated=1


[5233]
LongName=RACE 07
ShortName=race07
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\race 07\Race_Steam.exe
InstallHint=steamapps\*\race 07\mss32.dll
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 8600 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
RunElevated=1


[5234]
LongName=Battle for the Pacific
ShortName=bftp
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Cauldron\BftP\InstallDir
LauncherExe=bftp.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT


[5235]
LongName=Warmonger - Operation: Downtown Destruction
ShortName=warmon
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Netdevil\Warmonger\Install_Dir
LauncherDirAppend=\Binaries
LauncherExe=WMGame.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5236]
LongName=Arcanum: Of Steamworks and Magick Obscura
ShortName=arcanum
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Sierra Online\Setup\AR_USENG\Directory
LauncherExe=Arcanum.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
RunElevated=1


[5237]
LongName=Shogun: Total War
ShortName=stw
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\The Creative Assembly\Shogun - Total War - Gold Edition\InstallPath
LauncherExe=shogun.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5238]
LongName=Shaiya
ShortName=shaiya
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{8A4D41F3-3EDA-4DAC-9403-839708EA0667}\InstallLocation
LauncherExe=Updater.exe
DetectExe=game.exe
InstallHint=GameGuard.des
PlayingDetectType=ByWindowSubstr
ProcessWindowTitle=Shaiya
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|VALIDATE_USING_EXE_NAME|DISABLE_DIRECT_INPUT_HOOK|ENABLE_MOUSE|USE_DINPUT_MOUSE|BLOCK_ASYNC|DISABLE_FOR_VISTA
RunElevated=1
DetectServer=FALSE


[5239]
LongName=The Golden Compass
ShortName=gcomp
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\The Golden Compass\UninstallString
LauncherDirTruncAt=uninstall.exe
LauncherExe=CompassW32.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5240_1]
LongName=Dream Of Mirror Online
ShortName=domo
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Dream Of Mirror Online\UninstallString
LauncherDirTruncAt=Uninst.exe
LauncherExe=domopatch.exe
DetectExe=Main\DOMO.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|BLOCK_ASYNC
RunElevated=1
DetectServer=FALSE


[5240_2]
LongName=Dream Of Mirror Online
ShortName=domo
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{E7A00EA8-B3C1-4663-AA18-A0F5EFE27E5F}\InstallLocation
LauncherExe=DomoLauncher.exe
DetectExe=Main\DOMO.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
;InGameRenderer=D3D9
;InGameFlags=USE_PRESENT|ENABLE_MOUSE|BLOCK_ASYNC
RunElevated=1
DetectServer=FALSE


[5241]
LongName=PKRCasino
ShortName=pkrc
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\PKRCasino\homedir
LauncherExe=casino.exe
InstallHint=_SetupCasino.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5242]
LongName=Twelve Sky
ShortName=sky
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{4235A9E5-EEFF-42E7-BEC9-9D421DD10ECB}\InstallLocation
LauncherExe=Launcher.exe
DetectExe=TwelveSky.exe
;PlayingDetectType=ByWindowSubstr
;ProcessWindowTitle=TwelveSky
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|VALIDATE_USING_EXE_NAME|DISABLE_DIRECT_INPUT_HOOK|DISABLE_RELEASE|DISABLE_FOR_VISTA
RunElevated=1
DetectServer=FALSE


[5243]
LongName=Regnum Online
ShortName=regnum
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\NGD Studios\RegnumOnline\Install_Dir
LauncherExe=RegnumOnline.exe
DetectExe=LiveServer\ROClientGame.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5244]
LongName=Beyond Divinity
ShortName=beydev
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\LarianStudios\BeyondDivinity\InstallDir
LauncherExe=Div.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|DISABLE_RELEASE|CHECK_LISTENER|USE_DINPUT_MOUSE


[5245]
LongName=Geometry Wars: Retro Evolved
ShortName=geowar
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\geometry wars\GeometryWars.exe
InstallHint=steamapps\*\geometry wars\testapp.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 8400 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE
RunElevated=1


[5246]
LongName=Kane and Lynch: Dead Men Demo
ShortName=kanelynd
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Eidos\Kane and Lynch Dead Men Demo\InstallationPath
LauncherExe=kaneandlynch.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE


[5247]
LongName=Hard To Be a God Demo
ShortName=htbagd
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\BurutCT\HTBAG_Demo\WorkingDirectory
LauncherExe=AWE.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE


[5248]
LongName=Indiana Jones and the Emperors Tomb
ShortName=ijatet
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\LucasArts Entertainment Company LLC\Indiana Jones and the Emperors Tomb\1.0\Install Path
LauncherExe=EmperorsTomb.exe
DetectExe=GameData\bin\indy.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5249_1]
LongName=Grand Theft Auto
ShortName=gta
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Grand Theft Auto.exe\Path
LauncherDirAppend=\WINO
LauncherExe=Grand Theft Auto.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5249_2]
LongName=Grand Theft Auto
ShortName=gta
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\grand theft auto\WINO\Grand Theft Auto.exe
InstallHint=steamapps\*\grand theft auto\WINO\PMPRO32.DLL
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 12170 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
RunElevated=1


[5250]
LongName=Peggle Deluxe
ShortName=pegde
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\peggle deluxe\Peggle.exe
InstallHint=steamapps\*\peggle deluxe\j2k-codec.dll
;MatchExe=popcapgame1.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 3480 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
;InGameRenderer=D3D7
;InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE|DISABLE_FOR_VISTA


[5251_1]
LongName=Juiced 2: Hot Import Nights
ShortName=j2hin
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\juiced 2 hot import nights\Juiced2_HIN.exe
InstallHint=steamapps\*\juiced 2 hot import nights\j2launcher.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 9400 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|BLOCK_ASYNC|DISABLE_FOR_VISTA
DetectServer=FALSE


[5251_2]
LongName=Juiced 2: Hot Import Nights
ShortName=j2hin
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{50E4FCC7-90B9-48C6-9D17-7AE66F282878}\InstallLocation
LauncherExe=j2Launcher.exe
DetectExe=Juiced2_HIN.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|BLOCK_ASYNC|DISABLE_FOR_VISTA
DetectServer=FALSE


[5252]
LongName=Phantasy Star Universe: Ambition of the Illuminus
ShortName=psui
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\PHANTASY STAR UNIVERSE Ambition of the Illuminus_is1\UninstallString
LauncherDirTruncAt=uninst\unins000.exe
LauncherExe=online.exe
DetectExe=PsuIlluminus.exe
PlayingDetectType=ByWindow
ProcessWindowTitle=Phantasy Star Universe: Ambition of the Illuminus
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
RunElevated=1


[5253_1]
LongName=Pirates of the Burning Sea
ShortName=piratebs
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{EF934638-0711-4123-AA92-1512B72C660A}\InstallLocation
LauncherExe=PlayPOTBS.exe
DetectExe=PotBS.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE
RunElevated=1
DetectServer=False


[5253_2]
LongName=Pirates of the Burning Sea
ShortName=piratebs
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{EF934638-0711-4123-AA92-1512B72C660A}\InstallLocation
LauncherExe=PotbsUpdate.exe
DetectExe=PotBS.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE
RunElevated=1
DetectServer=False


[5253_3]
LongName=Pirates of the Burning Sea
ShortName=piratebs
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\pirates of the burning sea\PotBS.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 24140 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE
RunElevated=1
DetectServer=False


[5253_4]
LongName=Pirates of the Burning Sea
ShortName=piratebs
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Sony Online Entertainment\LaunchPad2\BasePath
LauncherExe=StationLauncher.exe
DetectDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\potbs.exe\Path
DetectExe=PotBS.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE
RunElevated=1
DetectServer=False


[5254]
LongName=Battlestar Galactica
ShortName=battlesg
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{9B540CE6-1AA5-4F08-8E47-4127C2A86030}\InstallLocation
LauncherExe=BSG.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5255_1]
LongName=Puzzle Quest: Challenge of the Warlords
ShortName=puzzleq
LauncherDirDefault=C:\Program Files\Puzzle Quest
LauncherExe=Puzzle Quest.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5255_2]
LongName=Puzzle Quest: Challenge of the Warlords
ShortName=puzzleq
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\puzzle quest\Puzzle Quest.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 12500 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5256]
LongName=Dawn of War: Soulstorm Demo
ShortName=wh40kssd
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\THQ\Dawn of War - Soulstorm Demo\InstallLocation
LauncherExe=Soulstorm.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5257]
LongName=Teewars
ShortName=teewars
LauncherDirDefault=C:\Program Files\teewars-0.3.3-win32
LauncherExe=teewars.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE


[5258]
LongName=Metal Gear Solid
ShortName=metalgs
LauncherDirDefault=C:\Program Files\mgsolid\Metal Gear Solid
LauncherExe=MGSI.exe
DetectExe[0]=MGSI.exe
DetectExe[1]=MGSVR.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5259]
LongName=Indiana Jones and the Infernal Machine
ShortName=ijonesim
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\LucasArts Entertainment Company LLC\Indiana Jones and the Infernal Machine\v1.0\Install Path
LauncherExe=Jones3D.exe
DetectExe=\Resource\Indy3D.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5260]
LongName=Divine Divinity
ShortName=divdiv
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\CDV Software Entertainment AG\Divine Divinity\English\target folder
LauncherDirAppend=\Run
LauncherExe=div.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5261]
LongName=Rising Eagle
ShortName=reagle
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\InvasionInteractive\RisingEagle\AppPath\appPath
LauncherExe=RisingEagle.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
LauncherNetworkArgs=%UA_LAUNCHER_PASSWORD_ARGS% %UA_LAUNCHER_RCON_ARGS% -connect %UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT%
ServerStatusType=RE
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5262]
LongName=Hard Truck: 18 Wheels of Steel
ShortName=wos
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\ValueSoft\Hard Truck 18\TargetPath
LauncherDirTruncAt=\Hard Truck 18 Wheels of Steel.exe
LauncherExe=Hard Truck 18 Wheels of Steel.exe
DetectExe=prism3d.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer[0]=D3D8
InGameRenderer[1]=OGL
InGameFlags=USE_PRESENT


[5263]
LongName=Stranded II
ShortName=strand2
LauncherDirDefault=C:\Program Files\stranded2_en
LauncherExe=StrandedII.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5264]
LongName=Pirates of the Caribbean Online
ShortName=potco
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Disney Pirates of the Caribbean Online\UninstallString
LauncherDirTruncAt=uninst.exe
LauncherExe=Launcher1.exe
DetectExe=Pirates.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL
InGameFlags=ENABLE_MOUSE|DISABLE_RELEASE|USE_DINPUT1|USE_DINPUT_MOUSE
DetectServer=FALSE


[5265]
LongName=Wild Metal Country
ShortName=wmc
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\wild metal country\WinEnv\WinEnv.exe
InstallHint=steamapps\*\wild metal country\WinEnv\msseax.m3d
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 12190 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
RunElevated=1


[5266_1]
LongName=GGPO.net
ShortName=ggpo
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{68BD9036-0952-4849-AE7A-963BB53EDB71}\InstallLocation
LauncherExe=ggpo.exe
DetectExe=ggpoair.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5266_2]
LongName=GGPO.net
ShortName=ggpo
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\GGPO\InstallPath
LauncherExe=ggpoClient.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5267]
LongName=Jewel Quest
ShortName=jquest
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\iWin.com Games\Jewel Quest Retail\Jewel Quest\Install_Dir
LauncherExe=JewelQuest.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5268]
LongName=9Dragons
ShortName=dragons
LauncherDirDefault=C:\Program Files\9Dragons
LauncherUrl=http://9dragons.acclaim.com/
DetectExe=NINEDRAGONS.EXE
InstallHint=NDLauncher.exe
PlayingDetectType=ByWindowSubstr
ProcessWindowTitle=9Dragons
Launch=%UA_LAUNCHER_URL% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
DetectServer=False


[5269_1]
LongName=Feeding Frenzy 2 Deluxe
ShortName=ffrenzy2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Feeding Frenzy 2 Deluxe 1.0\UninstallString
LauncherDirTruncAt=PopUninstall.exe
LauncherExe=FeedingFrenzy2.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5269_2]
LongName=Feeding Frenzy 2 Deluxe
ShortName=ffrenzy2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\feeding frenzy 2 deluxe\FeedingFrenzyTwo.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 3390 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5270_1]
LongName=Bejeweled Deluxe
ShortName=bjewel
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Bejeweled Deluxe 1.87\UninstallString
LauncherDirTruncAt=PopUninstall.exe
LauncherExe=Bejeweled.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5270_2]
LongName=Bejeweled Deluxe
ShortName=bjewel
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\bejeweled deluxe\WinBej.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 3350 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5271_1]
LongName=Bejeweled 2 Deluxe
ShortName=bjewel2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Bejeweled 2 Deluxe 1.1\UninstallString
LauncherDirTruncAt=PopUninstall.exe
LauncherExe=Bejeweled2.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5271_2]
LongName=Bejeweled 2 Deluxe
ShortName=bjewel2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\bejeweled 2 deluxe\WinBej2.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 3300 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5272_1]
LongName=Chuzzle Deluxe
ShortName=chuzzle
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Chuzzle Deluxe 1.01\UninstallString
LauncherDirTruncAt=PopUninstall.exe
LauncherExe=Chuzzle.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5272_2]
LongName=Chuzzle Deluxe
ShortName=chuzzle
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\chuzzle deluxe\Chuzzle.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 3310 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5273_1]
LongName=Insaniquarium Deluxe
ShortName=iquarum
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Insaniquarium Deluxe 1.1\UninstallString
LauncherDirTruncAt=PopUninstall.exe
LauncherExe=Insaniquarium.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5273_2]
LongName=Insaniquarium Deluxe
ShortName=iquarum
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\insaniquarium deluxe\InsaniquariumDeluxe.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 3320 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5274_1]
LongName=AstroPop Deluxe
ShortName=astpop
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\AstroPop Deluxe 1.1\UninstallString
LauncherDirTruncAt=PopUninstall.exe
LauncherExe=AstroPop.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5274_2]
LongName=AstroPop Deluxe
ShortName=astpop
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\astropop deluxe\WinAP.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 3340 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5275]
LongName=Iggle Pop Deluxe
ShortName=iggpop
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Iggle Pop Deluxe 1.0\UninstallString
LauncherDirTruncAt=PopUninstall.exe
LauncherExe=IgglePop.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5276_1]
LongName=Zuma Deluxe
ShortName=zuma
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Zuma Deluxe 1.0\UninstallString
LauncherDirTruncAt=PopUninstall.exe
LauncherExe=Zuma.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5276_2]
LongName=Zuma Deluxe
ShortName=zuma
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\zuma deluxe\Zuma.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 3330 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5277]
LongName=Dynomite Deluxe
ShortName=dyno
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Dynomite Deluxe 2.71\UninstallString
LauncherDirTruncAt=PopUninstall.exe
LauncherExe=Dynomite.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5278]
LongName=Big Money Deluxe
ShortName=bmoney
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Big Money Deluxe 1.3\UninstallString
LauncherDirTruncAt=PopUninstall.exe
LauncherExe=BigMoney.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5279]
LongName=Heavy Weapon Deluxe
ShortName=hweapon
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Heavy Weapon Deluxe 1.0\UninstallString
LauncherDirTruncAt=PopUninstall.exe
LauncherExe=HeavyWeapon.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5280]
LongName=Pizza Frenzy Deluxe
ShortName=pizzaf
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Pizza Frenzy Deluxe 1.0\UninstallString
LauncherDirTruncAt=PopUninstall.exe
LauncherExe=PizzaFrenzy.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5281]
LongName=Hammer Heads Deluxe
ShortName=hhead
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Hammer Heads Deluxe 1.1\UninstallString
LauncherDirTruncAt=PopUninstall.exe
LauncherExe=HammerHeads.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5282]
LongName=Typer Shark Deluxe
ShortName=tshark
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Typer Shark Deluxe 1.02\UninstallString
LauncherDirTruncAt=PopUninstall.exe
LauncherExe=TyperShark.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5283]
LongName=Rail Simulator
ShortName=railsm
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{0824EE6D-137F-4B83-9628-8E7B000BEBA6}\InstallLocation
LauncherExe=RailSim.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE
RunElevated=1


[5284]
LongName=Bookworm Deluxe
ShortName=bkworm
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Bookworm Deluxe 1.13\UninstallString
LauncherDirTruncAt=PopUninstall.exe
LauncherExe=Bookworm.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5285]
LongName=Bookworm Adventures Deluxe
ShortName=bkwrmad
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Bookworm Adventures Deluxe 1.0\UninstallString
LauncherDirTruncAt=PopUninstall.exe
LauncherExe=BookwormAdventures.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5726]
LongName=Sins of a Solar Empire: Entrenchment
ShortName=sinssee
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Stardock\Drengin.net\sins\Path
LauncherExe=Sins of a Solar Empire Entrenchment.exe
InstallHint=Sins of a Solar Empire Entrenchment.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE
DetectServer=FALSE


[5286]
LongName=Sins of a Solar Empire
ShortName=sinsse
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Stardock\Drengin.net\sins\Path
LauncherExe=Sins of a Solar Empire.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE
DetectServer=FALSE


[5287]
LongName=The Sims Castaway Stories
ShortName=simscs
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\SimsCS.exe\Path
LauncherExe=TSBin\SimsCS.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5288]
LongName=Thrillville: Off the Rails
ShortName=thrillv
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\LucasArts\Thrillville Off The Rails\InstallDir
LauncherExe=Thrillville07.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5289_1]
LongName=Secret of the Solstice
ShortName=secret
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Outspark.com\Launcher\Path
LauncherExe=outspark.exe
Launch=%UA_LAUNCHER_EXE_PATH% --run solstice %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
CommandLineMustNotContain[0]=fiesta
CommandLineMustNotContain[1]=propow
DetectDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Outspark.com\Solstice\Path
DetectExe=SosClient.exe
DetectServer=FALSE
RunElevated=1


[5289_2]
LongName=Secret of the Solstice
ShortName=secret
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Outspark.com\SharpLauncher\path
LauncherExe=OutsparkLauncher.exe
Launch=%UA_LAUNCHER_EXE_PATH% solstice %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
CommandLineMustNotContain[0]=fiesta
CommandLineMustNotContain[1]=propow
DetectDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{7447292F-C0D3-431C-9B6B-DD1B82CF5261}\InstallLocation
DetectExe=SosClient.exe
DetectServer=FALSE
RunElevated=1


[5290]
LongName=CABAL Online: The Revolution of Action
ShortName=cabalna
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\CABAL Online_is1\Inno Setup: App Path
LauncherExe=cabal.exe
DetectExe=CabalMain.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=VALIDATE_USING_EXE_NAME|DISABLE_DIRECT_INPUT_HOOK|USE_PRESENT|ENABLE_MOUSE
RunElevated=1


[5291]
LongName=Holic
ShortName=holic
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\HolicUSA\InstallPath
LauncherExe=HolicLauncher_USA.exe
DetectExe=HolicUSA.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE|BLOCK_ASYNC
RunElevated=1
DetectServer=FALSE


[5292]
LongName=Racer Beta
ShortName=racerb
LauncherDirDefault=C:\Program Files\racer053b8\racer
LauncherExe=racer.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5293]
LongName=FIFA Manager 08
ShortName=fifam08
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\EA SPORTS\FIFA Manager 08\Install Dir
LauncherExe=Manager08.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=ENABLE_MOUSE|USE_PRESENT


[5294]
LongName=The Spiderwick Chronicles
ShortName=spdwc
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Sierra Entertainment\The Spiderwick Chronicles\InstallPath
LauncherExe=Spiderwick.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE|USE_PRESENT


[5295]
LongName=Conflict: Denied Ops
ShortName=confdo
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Eidos\CDO\InstallPath
LauncherExe=ConflictDeniedOps.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5296]
LongName=Harley-Davidson Race to the Rally
ShortName=hdrttr
LauncherDirDefault=C:\Program Files\Activision Value\Magic Wand\Harley-Davidson Race to the Rally\bin
LauncherExe=Harley7r.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=ENABLE_MOUSE|USE_PRESENT


[5297]
LongName=Manga Fighter
ShortName=mngfght
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\GamesCampus\MangaFighter\InstallPathList\MangaFighter.main
LauncherExe=MangaFighter.exe
DetectExe=MF.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE|USE_PRESENT
RunElevated=1


[5298]
LongName=Audiosurf
ShortName=audios
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\audiosurf\engine\QuestViewer.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 12900 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT


[5299]
LongName=Impossible Creatures
ShortName=icrtrs
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\microsoft games\Impossible Creatures\1.0\EXE Path
LauncherExe=IC.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE


[5300]
LongName=Resident Evil 3: Nemesis
ShortName=re3
LauncherDirDefault=C:\Program Files\Xplosiv\Resident Evil 3
LauncherExe=ResidentEvil3.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=DDRAW
InGameFlags=USE_DINPUT1


[5301]
LongName=Theme Hospital
ShortName=thospit
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Hospital\Path
LauncherExe=Hospital.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5302]
LongName=AirRivals
ShortName=flysis
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\AirRivals\InstallPath
LauncherDirTruncAt=AirRivals.exe
LauncherExe=AirRivals.exe
DetectExe=AirRivals.atm
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE
RunElevated=1


[5303]
LongName=RuneScape
ShortName=scap
LauncherDirDefault=C:\Users\root\Desktop
LauncherExe=runescape.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5304_1]
LongName=Penumbra: Black Plague
ShortName=penbp
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{5052F2A7-5DDE-47F5-BF29-673C10F3DA87}_is1\InstallLocation
LauncherDirAppend=\redist
LauncherExe=Penumbra.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE
InGameOGLTextureOffset=32000


[5304_2]
LongName=Penumbra: Black Plague
ShortName=penbp
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{79A2AB22-00D8-4F09-A00A-F1CB7DB3E916}_is1\Inno Setup: App Path
LauncherDirAppend=\Black Plague\redist
LauncherExe=Penumbra.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE
InGameOGLTextureOffset=32000


[5305]
LongName=Hello Kitty Cutie World
ShortName=kittycw
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\ValuSoft\Hello Kitty Cutie World\1.00.000\Path
LauncherExe=HelloKitty.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5306]
LongName=Beyond Good & Evil
ShortName=byndge
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Ubisoft\Beyond Good & Evil\Install path
LauncherExe=CheckApplication.exe
DetectExe=BGE.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5307_1]
LongName=The Club
ShortName=club
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\SEGA\The Club\ExePath
LauncherDirTruncAt=Launcher.exe
LauncherExe=Launcher.exe
DetectExe=TheClub.exe
InstallHint=TheClub.exe.cfg
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT


[5307_2]
LongName=The Club
ShortName=club
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\the club\TheClub.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 10460 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT


[5308]
LongName=Europa 1400: The Guild (Gold)
ShortName=guilde
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Europa 1400 - Gold Edition\UninstallString
LauncherDirTruncAt=EUROPA~1
LauncherDirAppend=\Europa 1400 - Gold Edition
LauncherExe=Europa1400Gold.exe
DetectExe[0]=Europa1400Gold.exe
DetectExe[1]=Europa1400Gold_TL.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5309]
LongName=Red Stone
ShortName=rstone
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\L&K Logic Korea\Red Stone for USA\path
LauncherExe=Launcher.exe
DetectExe=Red Stone.exe
PlayingDetectType=ByWindow
ProcessWindowTitle=Red Stone - The Lunatic Story
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5310_1]
LongName=Frontlines: Fuel of War
ShortName=ffow
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=Steam.exe
DetectExe=SteamApps\*\frontlines fuel of war\Binaries\FFOW.exe
LauncherNetworkArgs=%UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT%
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 9460 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE|BLOCK_ASYNC
ServerStatusType=FFOW


[5310_2]
LongName=Frontlines: Fuel of War
ShortName=ffow
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\THQ\Frontlines: Fuel of War\InstallDir
LauncherDirAppend=\Binaries
LauncherExe=FFOW.exe
LauncherNetworkArgs=%UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT%
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE|BLOCK_ASYNC
ServerStatusType=FFOW


[5311]
LongName=Grand Chase (Asia)
ShortName=grdchse
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\GrandChaseSingaporeVersion\Path
LauncherExe=grandchase.exe
DetectExe=main.exe
PlayingDetectType=ByWindowSubstr
ProcessWindowTitle=GrandChase v1.00.02
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=VALIDATE_USING_EXE_NAME|DISABLE_DIRECT_INPUT_HOOK|DISABLE_RELEASE|USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5312]
LongName=Grand Chase
ShortName=grdchsn
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Grand Chase\UninstallString
LauncherDirTruncAt=uninst.exe
LauncherExe=grandchase.exe
InstallHint=d3dx9d_30.dll
DetectExe=main.exe
PlayingDetectType=ByWindowSubstr
ProcessWindowTitle=GrandChase v08
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=VALIDATE_USING_EXE_NAME|DISABLE_DIRECT_INPUT_HOOK|ENABLE_MOUSE|USE_DINPUT_MOUSE|DISABLE_FOR_VISTA
DetectServer=False
RunElevated=1


[5313]
LongName=The Sims 2 FreeTime
ShortName=simsft
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Sims2EP7.exe\Path
LauncherDirAppend=\TSBin
LauncherExe=Sims2Launcher.exe
DetectExe=Sims2EP7.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5314]
LongName=Turning Point: Fall of Liberty
ShortName=tpfl
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Codemasters\TurningPoint\InstallPath
LauncherDirAppend=Binaries
LauncherExe=LTCG-TPGame.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5315]
LongName=Lost: Via Domus
ShortName=lostvd
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Ubisoft\Lost Via Domus\InstallDir
LauncherExe=gu.exe
DetectExe=Yeti_Final_Win32.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5316]
LongName=Phun
ShortName=phunb
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Phun_is1\Inno Setup: App Path
LauncherExe=phun.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE


[5317]
LongName=SpaceForce Captains
ShortName=spcfrcc
LauncherDirDefault=C:\WINDOWS\SpaceForce - Captains
LauncherExe=Captains.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE


[5318]
LongName=NASCAR Racing 2002 Season
ShortName=nascar2k2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Papyrus\NASCAR Racing 2002 Season\Directory
LauncherExe=NR2002.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
;InGameRenderer=D3D7


[5319]
LongName=Darkeden
ShortName=deden
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Darkeden.exe\Path
LauncherExe=updater.exe
DetectExe=darkeden.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
RunElevated=1


[5320]
LongName=The Experiment
ShortName=exprmnt
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{3CF44BDE-BDDC-4510-A5CF-EBE97D1B8F73}\InstallLocation
LauncherExe=eXperience112.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE


[5321]
LongName=FairyLand
ShortName=frylnd
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Lager\FairyLand\workpath
LauncherExe=login.exe
DetectExe=Fairyland.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=DDRAW
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE|USE_DINPUT1


[5322]
LongName=Fritz 8
ShortName=fritz8
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\ChessProgram8.exe\Path
LauncherExe=Trailer.exe
DetectExe=ChessProgram8.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5323]
LongName=Bots
ShortName=bots
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Bots\Path
LauncherExe=bots.exe
PlayingDetectType=ByWindowSubstr
ProcessWindowTitle=bots
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5324]
LongName=Crusaders: Thy Kingdom Come
ShortName=crustkc
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\NeoCore Games\Crusaders - Thy Kingdom Come\Path
LauncherExe=Loader.exe
CommandLineMustNotContain[0]=gamestartmode:MultiPlayer
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5325]
LongName=Crusaders: Thy Kingdom Come Multiplayer
ShortName=crustkcm
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\NeoCore Games\Crusaders - Thy Kingdom Come\Path
LauncherExe=Loader.exe
LauncherUsernameArgs=Name:"%UA_GAME_HOST_USERNAME%"
LobbyJoinString=JoinGame IP:%UA_GAME_HOST_NAME%
LobbyHostString=HostGame
CommandLineMustContain[0]=gamestartmode:MultiPlayer
Launch=%UA_LAUNCHER_EXE_PATH% gamestartmode:MultiPlayer %UA_LAUNCHER_USERNAME_ARGS% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_LOBBY_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE
LobbyType=CMD


[5326]
LongName=Cal Ripken's Real Baseball
ShortName=cripknrb
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{41458D43-5C00-44ED-A138-5BC51AF8A773}\InstallLocation
LauncherUrl=http://www.playrealbaseball.com/member/memberlogin.asp
DetectExe=\game\RealBaseball.exe
PlayingDetectType=ByWindowSubstr
ProcessWindowTitle=Cal Ripken's
Launch=%UA_LAUNCHER_URL% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
;InGameRenderer=D3D9
;InGameFlags=USE_PRESENT|VALIDATE_USING_EXE_NAME|DISABLE_DIRECT_INPUT_HOOK|REINSTALL_KEYBOARD_HOOK|ENABLE_MOUSE|DISABLE_FOR_VISTA


[5327]
LongName=Pirates, Vikings and Knights II
ShortName=pvkii
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\source sdk base\HL2.exe
CommandLineMustContain[0]="\sourcemods\pvkii"
InstallHint=steamapps\SourceMods\pvkii\pvkicon.tga
LauncherPasswordArgs=+password %UA_GAME_HOST_PASSWORD%
LauncherNetworkArgs="%UA_LAUNCHER_PASSWORD_ARGS% +connect %UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT%"
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 215 -game "%UA_LAUNCHER_EXE_DIR%\steamapps\sourcemods\pvkii" %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
ServerStatusType=SOURCE
ServerGameName=PVKII Beta 2.2
ServerEncodingType=UTF8
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE
RunElevated=1


[5328]
LongName=Worms 2
ShortName=worms2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\DirectPlay\Applications\worms2\Path
LauncherExe=Frontend.exe
DetectExe=worms2.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=DDRAW
RunElevated=1


[5329]
LongName=Savage 2: A Tortured Soul
ShortName=savats
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Savage2\InstallLocation
LauncherExe=savage2.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE
RunElevated=1


[5330]
LongName=Phantasy Star Online: Blue Burst
ShortName=psobb
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\PHANTASY STAR ONLINE Blue Burst_is1\Inno Setup: App Path
LauncherDirAppend=\PHANTASY STAR ONLINE Blue Burst
LauncherExe=online.exe
DetectExe=PsoBB.exe
PlayingDetectType=ByWindow
ProcessWindowTitle=PHANTASY STAR ONLINE Blue Burst
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
RunElevated=1


[5331]
LongName=Pirateville
ShortName=piratev
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\iWinArcade\Pirateville\InstallDir
LauncherExe=Pirateville.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5332]
LongName=Upshift StrikeRacer
ShortName=upstr
LauncherDirDefault=C:\Program Files\gPotato\Upshift StrikeRacer
LauncherExe=UpShiftRun.exe
DetectExe=usr.exe
InstallHint=Usr.exe.manifest
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
;InGameRenderer=D3D9
;InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE|BLOCK_ASYNC
DetectServer=False


[5333]
LongName=Glest
ShortName=glest
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Glest_is1\InstallLocation
LauncherExe=glest.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL
InGameFlags=ENABLE_MOUSE


[5334]
LongName=WorldShift Beta
ShortName=wrldsftb
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\WorldShift Open Beta\Path
LauncherDirAppend=\bin
LauncherExe=WorldShift.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5335]
LongName=Seven Kingdoms: Conquest
ShortName=svnkmc
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Seven Kingdoms Conquest Key\Path
LauncherExe=Seven Kingdoms Conquest.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_PRESENT


[5336]
LongName=Powerboat GT
ShortName=pwboat
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Arcade Moon\Powerboat GT\InstallPath
LauncherExe=Launcher.exe
DetectExe=Run.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE


[5337]
LongName=Chessmaster 10th Edition
ShortName=chess10
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Ubisoft\Chessmaster 10th Edition\path
LauncherExe=game.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL


[5338]
LongName=Red Baron Arcade
ShortName=rbaron
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Sierra Online\Red Baron Arcade\InstallPath
LauncherExe=Red Baron Arcade.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5339]
LongName=The Shield
ShortName=shield
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Aspyr\The Shield\InstallPath
LauncherExe=Shield.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5340]
LongName=Mind Quiz
ShortName=mndqz
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{24BE40BB-BB08-4725-A13A-C81DF5CB1DD5}\InstallLocation
LauncherDirAppend=\Mind Quiz
LauncherExe=MindQuiz.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
RunElevated=1


[5341]
LongName=Ricochet Infinity
ShortName=rcocheti
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Reflexive Entertainment\Ricochet Infinity\InstallPath
LauncherExe=RicochetInfinity.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5342]
LongName=Command & Conquer 3: Kane's Wrath
ShortName=cckw
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Electronic Arts\Electronic Arts\Command and Conquer 3 Kanes Wrath\InstallPath
LauncherDirTruncAt=\Uninstal.exe
LauncherExe=cnc3ep1.exe
DetectExe=RetailExe\*\cnc3ep1.dat
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5343]
LongName=Lost Empire: Immortals
ShortName=lstempi
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Pollux Gamelabs\Lost Empire - Immortals\AppPath
LauncherExe=Loader.exe
DetectExe=LostEmpire.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5344]
LongName=Hard Truck 2
ShortName=hrdtrck2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\SoftLab-Nsk\Hard Truck 2\2.0\HomeDir
LauncherExe=htruck2.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5345]
LongName=Lights Out
ShortName=lghtout
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Lights Out\UninstallString
LauncherDirTruncAt=\Uninstal.exe
LauncherExe=lightsout.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5346]
LongName=SWAT 3
ShortName=swat3
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Sierra Online\Setup\SWAT3\Directory
LauncherExe=Swat.exe
DetectExe=Swat.icd
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=DDRAW


[5347]
LongName=The Sims Carnival: BumperBlast
ShortName=simscb
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\BumperBlast.exe\Path
LauncherExe=BumperBlast.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
;InGameRenderer=OGL


[5348]
LongName=The Sims Carnival: SnapCity
ShortName=simscsc
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\SnapCity.exe\Path
LauncherExe=SnapCity.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5349_1]
LongName=Toribash
ShortName=tribsh
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Toribash_is1\InstallLocation
LauncherExe=toribash.exe
DetectExe=tb.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE|BLOCK_ASYNC|DISABLE_FOR_VISTA


[5349_2]
LongName=Toribash
ShortName=tribsh
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Toribash\INSTALLPATH\
LauncherExe=toribash.exe
DetectExe=tb.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
;InGameRenderer=OGL
;InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE|BLOCK_ASYNC|DISABLE_FOR_VISTA


[5350]
LongName=Osu!
ShortName=osu
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\osu!\path
LauncherExe=osu!.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|BLOCK_ASYNC
RunElevated=1
DetectServer=False


[5351]
LongName=Pet Luv Spa and Resort Tycoon
ShortName=petluv
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Pet Luv Spa and Resort Tycoon\UninstallString
LauncherDirTruncAt=uninstall.exe
LauncherExe=Pet Luv Spa.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5352]
LongName=Perfect Dark: Source
ShortName=hl2pd
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\source sdk base\HL2.exe
CommandLineMustContain[0]="\SourceMods\pdark"
InstallHint=steamapps\SourceMods\pdark\resource\logo_pdark.ico
LauncherPasswordArgs=+password %UA_GAME_HOST_PASSWORD%
LauncherNetworkArgs="%UA_LAUNCHER_PASSWORD_ARGS% +connect %UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT%"
Launch=%UA_LAUNCHER_EXE_PATH% -gameidlaunch 9640083872897040599 -game "%UA_LAUNCHER_EXE_DIR%\steamapps\sourcemods\pdark" %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
ServerStatusType=SOURCE
ServerEncodingType=UTF8
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE


[5353_1]
LongName=Trials 2: Second Edition
ShortName=trials2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Trials 2 SE\UninstallString
LauncherDirTruncAt=Uninstall.exe
LauncherExe=launcher.exe
DetectExe[0]=trials2.exe
DetectExe[1]=trials2_low.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5353_2]
LongName=Trials 2: Second Edition
ShortName=trials2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe[0]=SteamApps\*\trials 2 second edition\trials2.exe
DetectExe[1]=SteamApps\*\trials 2 second edition\trials2_low.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 16600 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5354_1]
LongName=Synergy
ShortName=hl2sny
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\source sdk base\HL2.exe
CommandLineMustContain[0]="\SourceMods\synergy"
InstallHint=steamapps\SourceMods\synergy\resource\HALFLIFE2.ttf
LauncherPasswordArgs=+password %UA_GAME_HOST_PASSWORD%
LauncherNetworkArgs="%UA_LAUNCHER_PASSWORD_ARGS% +connect %UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT%"
Launch=%UA_LAUNCHER_EXE_PATH% -gameidlaunch 10532528757896380631 -game "%UA_LAUNCHER_EXE_DIR%\steamapps\sourcemods\synergy" %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
ServerStatusType=SOURCE
ServerGameName=Synergy
ServerEncodingType=UTF8
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE|DISABLE_RELEASE


[5354_2]
LongName=Synergy
ShortName=hl2sny
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\synergy\HL2.exe
InstallHint=SteamApps\*\synergy\synergy\resource\synfont.ttf
LauncherPasswordArgs=+password %UA_GAME_HOST_PASSWORD%
LauncherNetworkArgs="%UA_LAUNCHER_PASSWORD_ARGS% +connect %UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT%"
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 17520 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
ServerStatusType=SOURCE
ServerGameName=Synergy
ServerEncodingType=UTF8
InGameRenderer=D3D9
InGameFlags=USE_PRESENT


[5355_1]
LongName=Rohan: Blood Feud
ShortName=rohan
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Rohan_USA\InstallLocation
LauncherExe=Loader.exe
DetectExe=rohanclient.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|DISABLE_FOR_VISTA


[5355_2]
LongName=Rohan: Blood Feud
ShortName=rohan
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Rohan_RBF\InstallLocation
LauncherExe=Loader.exe
DetectExe=rohanclient.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|DISABLE_FOR_VISTA


[5356]
LongName=Warriors Orochi
ShortName=wrrorch
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{7258E9B2-0D13-4938-A105-2847632CD696}\DisplayIcon
LauncherDirTruncAt=OROCHI.exe
LauncherExe=OROCHI.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5357]
LongName=Alien Arena 2008
ShortName=alnarn08
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Alien Arena 2008_is1\InstallLocation
LauncherExe=crx.exe
DetectExe[0]=crx.exe
DetectExe[1]=Galaxy.exe
LauncherNetworkArgs=+connect %UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT%
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE


[5358]
LongName=Ninja Reflex: Steamworks Edition
ShortName=ninjar
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\ninja reflex\NinjaReflex.exe
InstallHint=SteamApps\*\ninja reflex\fmodex.dll
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 13000 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=BLOCK_ASYNC|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5359_1]
LongName=Lunia
ShortName=lunia
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\cdcgames\Lunia\Install_Dir
LauncherExe=Lunia.exe
DetectExe=LuniaClient.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|DISABLE_FOR_VISTA
DetectServer=False


[5359_2]
LongName=Lunia
ShortName=lunia
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Lunia\UninstallString
LauncherDirTruncAt=uninstall.exe
LauncherExe=Lunia.exe
DetectExe=LuniaClient.exe
PlayingDetectType=ByWindowSubstr
ProcessWindowTitle=Lunia
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|VALIDATE_USING_EXE_NAME|ENABLE_MOUSE
DetectServer=False


[5360]
LongName=Uplink
ShortName=uplink
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Uplink\UninstallString
LauncherDirTruncAt=Uninstall.exe
LauncherExe=uplink.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL
InGameFlags=ENABLE_MOUSE


[5361]
LongName=Slayers Online
ShortName=slyro
LauncherDirDefault=C:\Program Files\Slayers Online
LauncherExe=slayersonline.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5362_1]
LongName=Second Sight
ShortName=scndsght
LauncherDirDefault=C:\Program Files\Codemasters\Second Sight
LauncherExe=secondsight.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
;InGameRenderer=D3D9
;InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5362_2]
LongName=Second Sight
ShortName=scndsght
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=steamapps\*\second sight\secondsight.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 11550 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5363]
LongName=Imperium Romanum
ShortName=improman
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Imperium Romanum_is1\InstallLocation
LauncherExe=Imperium Romanum.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5364]
LongName=Yu-Gi-Oh! Online: Duel Evolution
ShortName=yugioh
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\KONAMI\Yu-Gi-Oh_ONLINE\path
LauncherDirTruncAt=yo2.exe
LauncherExe=yo2.exe
Launch=%UA_LAUNCHER_EXE_PATH% -patch %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=ENABLE_MOUSE|USE_DINPUT1|DISABLE_FOR_VISTA
RunElevated=1


[5365_1]
LongName=Assassin's Creed
ShortName=asscrd
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Ubisoft\Assassin's Creed\InstallDir
LauncherExe=AssassinsCreed_Launcher.exe
DetectExe[0]=AssassinsCreed_Dx9.exe
DetectExe[1]=AssassinsCreed_Dx10.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer[0]=D3D9
InGameRenderer[1]=D3D10
InGameFlags[0]=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE|SUBCLASS_WNDPROC
InGameFlags[1]=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE|SUBCLASS_WNDPROC
DetectServer=FALSE


[5365_2]
LongName=Assassin's Creed
ShortName=asscrd
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=Steam.exe
DetectExe[0]=SteamApps\*\assassins creed\AssassinsCreed_Dx9.exe
DetectExe[1]=SteamApps\*\assassins creed\AssassinsCreed_Dx10.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 15100 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer[0]=D3D9
InGameRenderer[1]=D3D10
InGameFlags[0]=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE|SUBCLASS_WNDPROC
InGameFlags[1]=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE|SUBCLASS_WNDPROC
DetectServer=False


[5366]
LongName=Terra: Battle for the Outlands
ShortName=terra
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\66807031-50F8-4462-99AB-7C10DBEB358C\InstallLocation
LauncherExe=launcher.exe
DetectExe=terra.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5367]
LongName=Darkstar One
ShortName=drkstr1
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Ascaron Entertainment\Darkstar One\InstalledTo
LauncherExe=DarkStarOne.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5368]
LongName=OpenTTD
ShortName=ottd
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\OpenTTD\Install Folder
LauncherExe=openttd.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5369]
LongName=NosTale
ShortName=nostale
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Nostale(UK)\DestDir
LauncherExe=Nostale.exe
DetectExe=NostaleX.dat
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE
RunElevated=1


[5370]
LongName=Jagged Alliance 2 Gold
ShortName=jagal2g
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Strategy First\Jagged Alliance 2 Gold\Install Path
LauncherExe=ja2.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
;InGameRenderer=DDRAW4
;InGameFlags=USE_DINPUT1


[5371]
LongName=American McGee's Alice
ShortName=ammcal
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Alice.exe\Path
LauncherExe=alice.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL


[5372]
LongName=Skulltag
ShortName=skultag
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Skulltag\UninstallString
LauncherDirTruncAt=uninstall.exe
LauncherExe=skulltag.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer[0]=OGL
InGameRenderer[1]=D3D9
InGameFlags[0]=DISABLE_RELEASE
InGameFlags[1]=USE_PRESENT|DISABLE_RELEASE


[5373]
LongName=Saga
ShortName=saga
LauncherDirDefault=C:\Program Files\Saga
LauncherExe=SagaPatcher.exe
DetectExe=saga.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL
InGameFlags=ENABLE_MOUSE
RunElevated=1


[5374_1]
LongName=Trackmania Nations Forever
ShortName=tmnf
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\TmNationsForever_is1\Inno Setup: App Path
LauncherExe=TmForeverLauncher.exe
DetectExe=TmForever.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5374_2]
LongName=Trackmania Nations Forever
ShortName=tmnf
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=Steam.exe
DetectExe=SteamApps\*\trackmania nations forever\TmForever.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 11020 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT


[5375_1]
LongName=Tom Clancy's Rainbow Six Vegas 2
ShortName=tcr6v2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Ubisoft\Tom Clancy's Rainbow Six Vegas 2\GameUpdate\installdir
LauncherDirAppend=\Binaries
LauncherExe=R6Vegas2_Launcher.exe
DetectExe=R6Vegas2_Game.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_PRESENT|USE_DINPUT_MOUSE|BLOCK_ASYNC


[5375_2]
LongName=Tom Clancy's Rainbow Six Vegas 2
ShortName=tcr6v2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=Steam.exe
DetectExe=SteamApps\*\rainbow six vegas 2\Binaries\R6Vegas2_Game.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 15120 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT


[5376]
LongName=The Sims 2 Kitchen & Bath Interior Design Stuff
ShortName=sims2kb
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Sims2SP7.exe\Path
LauncherDirAppend=\TSBin
LauncherExe=Sims2Launcher.exe
DetectExe=Sims2SP7.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5377]
LongName=Kung Fu Panda Demo
ShortName=panda
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Activision\Kung Fu Panda Demo\InstallPath
LauncherExe=Kung Fu Panda Game.exe
DetectExe=Game.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5378]
LongName=Melty Blood: Act Cadenza
ShortName=mbac
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\EcoleSoftware\MBACWIN\Path
LauncherExe=mbacPC.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D7
InGameFlags=ENABLE_MOUSE


[5379]
LongName=Seal Online USA
ShortName=sealo
LauncherDirDefault=C:\Program Files\SealOnline
LauncherExe=AutoUpdate.exe
DetectExe=SO3D.exe
PlayingDetectType=ByWindowSubstr
ProcessWindowTitle=SO3D
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=VALIDATE_USING_EXE_NAME|USE_PRESENT|DISABLE_FOR_VISTA
RunElevated=1


[5380]
LongName=Magic Online III
ShortName=mtgo3
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{AF7733C1-FB0B-4FED-9730-E0433AF7A2EF}\InstallLocation
LauncherExe=Renamer.exe
DetectExe=MTGO_NET.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
RunElevated=1


[5381]
LongName=Ultimate Doom
ShortName=ultdoom
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\ultimate doom\base\dosbox.exe
InstallHint=SteamApps\*\ultimate doom\base\ultimatem.conf
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 2280 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5382]
LongName=Master Levels of Doom
ShortName=mldoom
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\master levels of doom\dosbox.exe
InstallHint=SteamApps\*\master levels of doom\master.bat
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 9160 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5383]
LongName=Final Doom
ShortName=fdoom
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\final doom\base\dosbox.exe
InstallHint=SteamApps\*\final doom\base\PLUTONIA.WAD
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 2290 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5384]
LongName=Doom 2
ShortName=doom2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\doom 2\base\dosbox.exe
InstallHint=SteamApps\*\doom 2\base\doom2.conf
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 2300 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5385]
LongName=Cabela's Dangerous Hunts 2
ShortName=dngh2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Activision Value\Magic Wand\Dngh2\Path1
LauncherExe=Launcher.exe
DetectExe=Bin\Main7.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=ENABLE_MOUSE|USE_PRESENT


[5386]
LongName=Turok
ShortName=turok
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Binaries\TurokGame.exe\Path
LauncherDirAppend=\Binaries
LauncherExe=TurokGame.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_PRESENT|SUBCLASS_WNDPROC|USE_DINPUT_MOUSE


[5387]
LongName=Clive Barker's Undying
ShortName=undy
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\undying.exe\Path
LauncherExe=Undying.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
;InGameRenderer=DDRAW
;InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE|DISABLE_RELEASE|BLOCK_ASYNC


[5388]
LongName=Lumines
ShortName=lumines
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\lumines\lumines.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 11900 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=ENABLE_MOUSE|USE_PRESENT


[5389]
LongName=Europa Universalis: Rome
ShortName=eurome
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Rome.exe\Path
LauncherExe=Rome.exe
DetectExe=RomeGame.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_PRESENT|USE_DINPUT_MOUSE


[5390]
LongName=Planescape: Torment
ShortName=plnscpt
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\torment.exe\Path
LauncherExe=Torment.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
;InGameRenderer=DDRAW


[5391]
LongName=Dirty Dancing: The Video Game
ShortName=ddance
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Dirty Dancing\DisplayIcon
LauncherDirTruncAt=DirtyDancing.exe
LauncherExe=DirtyDancing.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5392_1]
LongName=Age of Conan: Hyborian Adventures
ShortName=aoc
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Funcom\Age of Conan\LastInstalledClient
LauncherExe=ConanPatcher.exe
DetectExe[0]=AgeOfConan.exe
DetectExe[1]=AgeOfConanDX10.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE
DetectServer=False


[5392_2]
LongName=Age of Conan: Hyborian Adventures
ShortName=aoc
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Funcom\Installer\LastInstalledClient
LauncherExe=ConanPatcher.exe
DetectExe[0]=AgeOfConan.exe
DetectExe[1]=AgeOfConanDX10.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE
DetectServer=False


[5393]
LongName=The House of the Dead 3
ShortName=hod3
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{B418F434-15CD-4B68-A022-CFE0DB92A6F9}\InstallLocation
LauncherExe=hod3launch.exe
DetectExe=exe\hod3pc.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE|BLOCK_ASYNC


[5394]
LongName=The House of the Dead 2
ShortName=hod2
LauncherDirDefault=C:\Program Files\SEGA\THE HOUSE OF THE DEAD 2
LauncherExe=Hod2.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
;InGameRenderer=D3D7
;InGameFlags=ENABLE_MOUSE|DISABLE_RELEASE


[5395]
LongName=Iron Man
ShortName=ironman
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\SEGA\Iron Man\InstallDir
LauncherExe=GameLauncher.exe
DetectExe=IronMan.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE|BLOCK_ASYNC


[5396]
LongName=Sherlock Holmes: Nemesis
ShortName=shnem
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Frogwares\sh4\installdir
LauncherExe=game.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5397]
LongName=Galactic Civilizations II: Twilight of the Arnor
ShortName=gciv2ta
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Stardock\Drengin.net\GalCiv2\Path
LauncherDirAppend=\Twilight
LauncherExe=TALaunch.exe
DetectExe=GC2TwilightOfTheArnor.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5398]
LongName=Imperialism II
ShortName=imp2
LauncherDirDefault=C:\Program Files\SSI\Imperialism II
LauncherExe=Imperialism II.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5399]
LongName=Star Wars: Battle for Naboo
ShortName=swbfn
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\LucasArts Entertainment Company LLC\Battle for Naboo\Retail\Install Path
LauncherExe=BattleforNaboo.exe
DetectExe=data_pc\BFN.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
;InGameRenderer=D3D7
;InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE


[5400]
LongName=Grand Prix 4
ShortName=gprix4
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Infogrames\Grand Prix 4\1.00\Install Dir\Directory
LauncherExe=GP4.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE|BLOCK_ASYNC|DISABLE_FOR_VISTA


[5401]
LongName=Tomb Raider II
ShortName=traid2
LauncherDirDefault=C:\Program Files\Core Design\Tomb Raider II
LauncherExe=Tomb2.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5402]
LongName=Commandos 3: Destination Berlin
ShortName=comm3db
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\DirectPlay\Applications\Commandos 3 - Destination Berlin\Path
LauncherExe=commandos3.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5403]
LongName=Capitalism II
ShortName=capit2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\DirectPlay\Applications\Capitalism2\Path
LauncherExe=cap2.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5404]
LongName=Tales of Pirates Online
ShortName=topo
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\IGG\Tales of Pirates Online\Settings\InstallPath
LauncherExe=top.exe
DetectExe=system\Game.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5405]
LongName=Bet and Race
ShortName=betrace
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{7E7F7DD7-185B-465F-BA1A-6056B85597AA}_is1\Inno Setup: App Path
LauncherExe=BETANDRACE.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5406]
LongName=Commandos: Behind Enemy Lines
ShortName=cmmdo
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Pyro\Commandos\1.0\DirIns
LauncherExe=Comandos.exe
InstallHint=WARGAME.DIR
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5407]
LongName=Magic The Gathering: Battlegrounds
ShortName=mtgb
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{0C88C4A1-A9D7-4C28-8F06-4C2048765193}\InstallLocation
LauncherDirAppend=\SYSTEM
LauncherExe=MTGBattlegrounds.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5408]
LongName=Everyday Shooter
ShortName=evydyst
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\everyday shooter\EverydayShooter.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 16300 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL
InGameFlags=ENABLE_MOUSE


[5409]
LongName=Graal Online
ShortName=graal
LauncherDirDefault=C:\Graal\
LauncherExe=Graal.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D7
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE


[5410]
LongName=Heretic II
ShortName=hertic2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Raven\Heretic II\FULL_PATH
LauncherDirTruncAt=Heretic2.exe
LauncherExe=Heretic2.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5411]
LongName=Conflict: Global Terror
ShortName=cnfgtr
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Pivotal\Conflict Global\ExePath
LauncherDirTruncAt=ConflictGlobal.exe
LauncherExe=ConflictGlobal.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE|DISABLE_FOR_VISTA


[5412]
LongName=Jack Keane
ShortName=jkeane
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Jack Keane\UninstallString
LauncherDirTruncAt=uninstall.exe
LauncherDirAppend=\bin\release
LauncherExe=JackKeane.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5413]
LongName=Shogo: Mobile Armor Division
ShortName=shogo
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\DirectPlay\Applications\Shogo\Path
LauncherExe=Shogo.exe
DetectExe=Client.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=DDRAW
InGameFlags=USE_DINPUT1|DISABLE_FOR_VISTA


[5414]
LongName=Cossacks: The Art Of War
ShortName=cossaw
LauncherDirDefault=C:\Program Files\Cossacks - The Art of War
LauncherExe=dmcr.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5415]
LongName=Requiem: Bloodymare
ShortName=requiem
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{F9831B39-277F-4F53-BFB0-12DC90C4CB40}\InstallLocation
LauncherExe=UpdaterUsa.exe
DetectExe=\system\Requiem.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE
RunElevated=1
DetectServer=FALSE


[5416]
LongName=Hello Kitty Online
ShortName=hko
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Hello Kitty Online CB v0.1_is1\Inno Setup: App Path
LauncherExe=AutoUpdate.exe
DetectExe=HKO.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
RunElevated=1


[5417_1]
LongName=On the Rain-Slick Precipice of Darkness, Episode One
ShortName=otrspod
LauncherDirDefault=C:\Program Files\Hothead Games\Precipice of Darkness
LauncherExe=RainSlickEp1.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL


[5417_2]
LongName=On the Rain-Slick Precipice of Darkness, Episode One
ShortName=otrspod
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\on the rain-slick precipice of darkness - episode one\RainSlickEp1.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 18000 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL


[5418]
LongName=PseudoQuest
ShortName=psq
External=1
LauncherUrl=http://www.pseudoquest.com/
Launch=%UA_LAUNCHER_URL%


[5419]
LongName=Mortimer Beckett and the Secrets of Spooky Manor
ShortName=beckett
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Mortimer Beckett and the Secrets of Spooky Manor\DisplayIcon
LauncherDirTruncAt=uninstall.exe
LauncherExe=Spooky Manor.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8


[5420]
LongName=Silent Hunter II
ShortName=shunt2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Silent Hunter II\TargetDir
LauncherDirAppend=\shell
LauncherExe=SH2.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5421]
LongName=Flanker 2.5
ShortName=flanker
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Flanker.exe\Path
LauncherExe=Flanker.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=DDRAW
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE


[5422]
LongName=The Continuum
ShortName=contnm


[5423]
LongName=Great War Nations: The Spartans
ShortName=gwnspt
LauncherDirDefault=C:\Program Files\JoWood\Great War Nations The Spartans\
LauncherExe=AWE.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5424]
LongName=Shadowgrounds Survivor
ShortName=sdwsur
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=Steam.exe
DetectExe=SteamApps\*\shadowgrounds survivor\survivor.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 11200 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT


[5425]
LongName=Mass Effect
ShortName=meffect
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\BioWare\Mass Effect\Path
LauncherExe=MassEffectLauncher.exe
DetectExe=Binaries\MassEffect.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT


[5426]
LongName=Lost Planet: Extreme Condition Colonies Edition
ShortName=lpexc
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\CAPCOM\LOST PLANET COLONIES\InstallDir
LauncherExe=LPCLauncher.exe
DetectExe[0]=LostPlanetColoniesDX9.exe
DetectExe[1]=LostPlanetColoniesDX10.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer[0]=D3D9
InGameRenderer[1]=D3D10
InGameFlags[0]=USE_PRESENT|ENABLE_MOUSE|BLOCK_ASYNC
InGameFlags[1]=DISABLE_FOR_VISTA


[5427]
LongName=G-Police
ShortName=gplce
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Gpolice.exe\Path
LauncherExe=gpolice.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5428]
LongName=Heroes of Might and Magic III Complete
ShortName=hmm3c
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Heroes of Might and Magic® III\TargetDir
LauncherExe=HEROES3.EXE
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5429]
LongName=GRID Demo
ShortName=gridd
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{3C850287-4CD5-4FAD-BE39-A4AF7851A7C6}\InstallLocation
LauncherExe=GRID.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5430]
LongName=Icewind Dale II
ShortName=iced2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\IWD2.exe\Path
LauncherExe=IWD2.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5431]
LongName=Day of Defeat: Source Beta
ShortName=dodsb
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=steamapps\*\day of defeat source beta\HL2.exe
;LauncherPasswordArgs=+password %UA_GAME_HOST_PASSWORD%
;LauncherNetworkArgs="%UA_LAUNCHER_PASSWORD_ARGS% +connect %UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT%"
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 302 -novid %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
ServerStatusType=SOURCE
ServerEncodingType=UTF8
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE|USE_PRESENT|DISABLE_RELEASE
ChangeTolerance=6


[5432]
LongName=Spaceinvasion
ShortName=spcinv
External=1
LauncherUrl=http://spaceinvasion.bigpoint.com
Launch=%UA_LAUNCHER_URL%


[5433]
LongName=ChaosCars
ShortName=chscar
External=1
LauncherUrl=http://www.chaoscars.com/
Launch=%UA_LAUNCHER_URL%


[5434]
LongName=Gladiators II
ShortName=glditr2
External=1
LauncherUrl=http://gladiatoren.bigpoint.com/
Launch=%UA_LAUNCHER_URL%


[5435]
LongName=Seafight
ShortName=seaft
External=1
LauncherUrl=http://www.seafight.com/
Launch=%UA_LAUNCHER_URL%


[5436]
LongName=DarkOrbit
ShortName=dorbit
External=1
LauncherUrl=http://www.darkorbit.com/
GameUrl=http://int2.darkorbit.com/
Launch=%UA_LAUNCHER_URL%


[5437]
LongName=Lego Indiana Jones: The Original Adventures
ShortName=legoij
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\LucasArts\IndianaJones_TOA\PathVal
LauncherExe=LEGOIndy.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5438_1]
LongName=GRID
ShortName=grid
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Codemasters\GRID\PATH_APPLICATION
LauncherExe=GRID.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5438_2]
LongName=GRID
ShortName=grid
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\grid\grid.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 12750 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5440]
LongName=Guilty Gear x2 Reload
ShortName=ggx2r
LauncherDirDefault=C:\Program Files\ZOO Digital Publishing\GUILTY GEAR X2 #RELOAD\
LauncherExe=ggx2.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5441]
LongName=Nitro Stunt Race Stage 1
ShortName=nsrs1
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\NSR-Stage 1\DisplayIcon
LauncherDirTruncAt=NSR_S1.exe
LauncherExe=NSR_S1.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|USE_SWAPCHAIN|ENABLE_MOUSE|DISABLE_FOR_VISTA


[5442]
LongName=MTV's Virtual World
ShortName=mtvvw
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\MTV's Virtual World\UninstallString
LauncherDirTruncAt=MTVVWClientUninst.exe
LauncherDirAppend=MTVVWClient
LauncherExe=MTVVWClient.exe
Launch=%UA_LAUNCHER_EXE_PATH% -U -l https://webapps.vmtv.com/loginfromclient/ %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE
DetectServer=FALSE


[5443]
LongName=Kung Fu Panda
ShortName=kfpanda
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Activision\Kung Fu Panda\InstallPath
LauncherExe=Kung Fu Panda Game.exe
DetectExe=Game.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5444]
LongName=Aliens versus Predator Gold Edition
ShortName=avpge
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Fox Interactive\Aliens versus Predator\Path
LauncherExe=avp.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5445]
LongName=Turok 2: Seeds of Evil Singleplayer
ShortName=trok2sp
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Turok2.exe\Path
LauncherExe=Turok2.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5446]
LongName=Turok 2: Seeds of Evil Multiplayer
ShortName=trok2mp
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Turok2.exe\Path
LauncherExe=Turok2MP.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5447]
LongName=Wonderland Online
ShortName=wland
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\IGG\Wonderland Online\Settings\InstallPath
LauncherExe=Main.exe
DetectExe=aLogin.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5448]
LongName=Devil May Cry 4 Trial
ShortName=dmc4
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\CAPCOM\DEVIL MAY CRY 4 TRIAL\InstallDir
LauncherExe=DMC4Launcher_Trial.exe
DetectExe[0]=DevilMayCry4_Trial_DX9.exe
DetectExe[1]=DevilMayCry4_Trial_DX10.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5449]
LongName=Blokus World Tour
ShortName=blokus
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Blokus World Tour\DisplayIcon
LauncherDirTruncAt=uninstall.exe
LauncherExe=Blokus.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=DDRAW
InGameFlags=ENABLE_MOUSE|DISABLE_RELEASE


[5450]
LongName=Star Sonata
ShortName=starsnt
LauncherDirDefault=C:\Program Files\StarSonata
LauncherExe=Star Sonata.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE|DISABLE_FOR_VISTA


[5451]
LongName=Bullet Candy
ShortName=bcandy
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=steamapps\*\bullet candy\BulletCandyV2.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 6600 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE|DISABLE_FOR_VISTA


[5452]
LongName=Bus Driver
ShortName=busdrvr
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Bus Driver\UninstallString
LauncherDirTruncAt=uninst.exe
LauncherExe=launcher.exe
DetectExe=busdriver.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE


[5453]
LongName=The Incredible Hulk
ShortName=hulk
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\The Incredible Hulk\UninstallString
LauncherDirTruncAt=uninstall.exe
LauncherExe=Hulk.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5454]
LongName=Stronghold Crusader Extreme
ShortName=sholdce
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\DirectPlay\Applications\Stronghold Crusader\CurrentDirectory
LauncherExe=Stronghold_Crusader_Extreme.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5455]
LongName=Marble Blast Gold
ShortName=mrbbltg
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Software\RealArcade\Games\marbleblastgold\1\InstallPath
LauncherExe=MarbleBlast.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=DDRAW
InGameFlags=ENABLE_MOUSE|DDRAW_FLIP_MODE|BLOCK_ASYNC


[5456]
LongName=UEFA Euro 2008
ShortName=uefa08
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\EA SPORTS\UEFA EURO 2008\Install Dir
LauncherExe=EURO08.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5458]
LongName=Little Farm
ShortName=lttlfrm
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\little farm\game.dmg
InstallHint=SteamApps\*\little farm\LittleFarm.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 15960 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=USE_PRESENT|ENABLE_MOUSE|DISABLE_RELEASE


[5459]
LongName=SPORE Creature Creator
ShortName=sporecc
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Electronic Arts\SPORE Creature Creator\InstallLoc
LauncherDirAppend=\Sporebin
LauncherExe=SporeCreatureCreator.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5460]
LongName=Psi-Ops: The Mindgate Conspiracy
ShortName=psiops
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Psi-Ops\UninstallString
LauncherDirTruncAt=uninstall.exe
LauncherExe=PsiOps.exe
DetectExe=PsiOps
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5461]
LongName=Zu Online
ShortName=zuo
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{D619E865-AE93-4785-BB20-F3072CE4E8C5}\InstallLocation
LauncherDirAppend=\ZU-ONLINE
LauncherExe=LiveUpdate.exe
DetectExe=ZuOnline.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE
DetectServer=FALSE
RunElevated=1


[5462]
LongName=Angels Online
ShortName=angelso
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Angels Online_is1\InstallLocation
LauncherExe=START.EXE
DetectExe=ANGEL.DAT
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5463]
LongName=Dreamlords: The Reawakening
ShortName=drmldtr
LauncherDirDefault=C:\Program Files\Dreamlords
LauncherExe=dreamlords.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5464]
LongName=Alien Shooter
ShortName=alnshtr
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\BFG-Alien Shooter\InstallPath
LauncherExe=AlienShooter.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5465]
LongName=WALL-E
ShortName=walle
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\WALL-E\GamePath
LauncherExe=WALL-E.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5466]
LongName=Alone In The Dark
ShortName=aitd
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Atari\AITD5\InstallDir
LauncherExe=Alone.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5467_1]
LongName=Crazy Machines 2
ShortName=czymch2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\crazy machines 2\cm2.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 18400 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5467_2]
LongName=Crazy Machines 2
ShortName=czymch2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{30433BBA-5358-4B41-817E-E694092DC178}\InstallLocation
LauncherExe=cm2.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5468]
LongName=Out of the Park Baseball 9
ShortName=ootpb9
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\out of the park baseball 9\ootp9.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 17600 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5469]
LongName=The Sims 2 IKEA Home Stuff
ShortName=sims2ihs
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Sims2SP8.exe\Path
LauncherDirAppend=\TSbin
LauncherExe=Sims2Launcher.exe
DetectExe=Sims2SP8.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5470]
LongName=World of Kung Fu
ShortName=wokf
LauncherDirDefault=C:\Program Files\VestGame\WoKF
LauncherExe=PatcherKf.exe
DetectExe=GongfuClient.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE
RunElevated=1


[5471]
LongName=Making History: The Calm and The Storm
ShortName=mhtcts
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{07B93C0D-7EC9-471A-BE93-05FEF9C6181D}\InstallLocation
LauncherDirAppend=\bin
LauncherExe=makehist.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5472]
LongName=Freelanc3r
ShortName=fla3r
External=1
LauncherUrl=http://www.freelanc3r.org/
GameUrl=http://www.mob-like.com/
Launch=%UA_LAUNCHER_URL%


[5473]
LongName=Genleo: The Land of Eratica
ShortName=genloe
External=1
LauncherUrl=http://www.genleo.net/
Launch=%UA_LAUNCHER_URL%


[5474]
LongName=Seeds of Time Online
ShortName=soto
External=1
LauncherUrl=http://www.seedsoftime.net/
Launch=%UA_LAUNCHER_URL%


[5475]
LongName=Oil Imperium
ShortName=oilimp
External=1
LauncherUrl=http://www.oilimperium.eu/
Launch=%UA_LAUNCHER_URL%


[5476_1]
LongName=Combat Arms
ShortName=cmbtarm
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Combat Arms\InstallLocation
LauncherExe=CombatArms.exe
DetectExe=Engine.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
RunElevated=1


[5476_2]
LongName=Combat Arms
ShortName=cmbtarm
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Combat Arms EU\InstallLocation
LauncherExe=CombatArms.exe
DetectExe=Engine.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
RunElevated=1


[5477]
LongName=Cardmaster Conflict
ShortName=cmc
External=1
LauncherUrl=http://www.cardmasterconflict.com/
Launch=%UA_LAUNCHER_URL%


[5478]
LongName=Freedom Force
ShortName=frdmfrc
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Irrational Games\Freedom Force\InstallDir
LauncherExe=fforce.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=USE_PRESENT


[5479]
LongName=Ultimate Pimpin'
ShortName=ulpimp
External=1
LauncherUrl=http://www.ultimatepimpin.com/
Launch=%UA_LAUNCHER_URL%


[5480]
LongName=Safari Photo Africa: Wild Earth
ShortName=spawe
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\WildEarth.exe\Path
LauncherExe=WildEarth.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5481]
LongName=Supreme Ruler 2020
ShortName=sr2020
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Supreme Ruler 2020_is1\InstallLocation
LauncherExe=SupremeRuler2020.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5482]
LongName=The Political Machine 2008
ShortName=tpm2008
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Stardock\Drengin.net\PolMachine08\Path
LauncherExe=PM2008_Launcher.exe
DetectExe=PolMachine2008.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5483]
LongName=CS-Manager
ShortName=csm
External=1
LauncherUrl=http://www.cs-manager.com/
GameUrl=http://www1.cs-manager.com/
Launch=%UA_LAUNCHER_URL%


[5484]
LongName=Devil May Cry 4
ShortName=demc4
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\CAPCOM\DEVIL MAY CRY 4\InstallDir
LauncherExe=DMC4Launcher.exe
DetectExe[0]=DevilMayCry4_DX9.exe
DetectExe[1]=DevilMayCry4_DX10.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5485]
LongName=Immune Attack
ShortName=immatt
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{C541157F-6CE9-4DD5-A67A-CE9ADB916ED9}\InstallLocation
LauncherExe=Game-r.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5486]
LongName=Carmageddon II: Carpocalypse Now!
ShortName=carma2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\SCi\Carmageddon2\ExecutableLocation
LauncherExe=carma2.exe
DetectExe[0]=Carma2_HW.exe
DetectExe[1]=Carma2_SW.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5487]
LongName=Panzer Elite
ShortName=panze
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Psygnosis\PanzerElite\Source
LauncherExe=Panzer_Elite.exe
DetectExe[0]=gameProject.exe
DetectExe[1]=mymenu.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5488]
LongName=Dark Colony
ShortName=drkclny
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Strategic Simulations Inc.\Dark Colony\1.0\DIRECTORY
LauncherExe=dc.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=DDRAW


[5489]
LongName=Enclave
ShortName=enclave
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Starbreeze\Enclave\InstallPath
LauncherExe=Enclave.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5490]
LongName=Carmageddon TDR2000
ShortName=tdr2000
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\SCi\Carmageddon TDR2000\Path
LauncherExe=TDR2000.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=DDRAW
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE|USE_DINPUT1


[5491]
LongName=Rayman Raving Rabbids
ShortName=rayrav
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{111E336D-30BF-4CD4-8D69-4541732AFB27}\InstallLocation
LauncherExe=CheckApplication.exe
DetectExe=Jade_enr.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT


[5492]
LongName=Rigs of Rods
ShortName=ror
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Rigs of Rods\UninstallString
LauncherDirTruncAt=\uninst.exe
LauncherExe=RoRconfig.exe
DetectExe=RoR.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE|BLOCK_ASYNC


[5493]
LongName=7 Wonders of the Ancient World
ShortName=wndrs7
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\7 Wonders\UninstallString
LauncherDirTruncAt=uninstall.exe
LauncherExe=Wonders.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5494]
LongName=Eternal Lands
ShortName=elnds
LauncherDirDefault=C:\Program Files\Eternal Lands
LauncherExe=el.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL
InGameFlags=ENABLE_MOUSE|DISABLE_SCREENSHOTS


[5495]
LongName=The Golden Horde
ShortName=tghorde
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\JoWood\The Golden Horde\Install
LauncherExe=AWE.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5496]
LongName=Roogoo
ShortName=roogoo
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Spidermonk Entertainment\Roogoo\Install_Dir
LauncherExe=Roogoo.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|BLOCK_ASYNC


[5497]
LongName=Bomberman Online
ShortName=bmow
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{0C9C323B-395D-4483-A444-F7E11EE5B610}_is1\Inno Setup: App Path
LauncherExe=launch.exe
DetectExe=BomberMan.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5498]
LongName=Elements
ShortName=element
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Elements\DisplayIcon
LauncherDirTruncAt=uninstall.exe
LauncherExe=elements.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=DDRAW
InGameFlags=ENABLE_MOUSE


[5499]
LongName=The Wonderful End of the World
ShortName=tweotw
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\the wonderful end of the world\main.exe
InstallHint=SteamApps\*\the wonderful end of the world\the_end_of_the_world_begins.wmb
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 15500 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE|BLOCK_ASYNC


[5500]
LongName=Halo Trial
ShortName=halot
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft Games\Halo Trial\EXE Path
LauncherExe=halo.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5501]
LongName=Space Chimps
ShortName=schimps
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{1256B210-EC20-49E6-8824-40D8F795F5A1}\InstallLocation
LauncherExe=Space Chimps Launcher.exe
DetectExe=SpaceChimps.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE|DISABLE_FOR_VISTA


[5502]
LongName=7 Wonders II
ShortName=wndrs72
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\7 wonders 2\game.dmg
InstallHint=SteamApps\*\7 wonders 2\Read_Me.htm
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 15900 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=ENABLE_MOUSE


[5503]
LongName=Sacred Gold
ShortName=sacredg
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\sacred gold\Sacred.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 12320 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D7
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE


[5504]
LongName=UniBall
ShortName=uniball
LauncherDirDefault=C:\Program Files\Uniball
LauncherExe=UniBall.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=DDRAW


[5505]
LongName=Warrior Epic Closed Beta
ShortName=warepic
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\PSGame_CB\Installation 001
LauncherExe=PSSHELL_CB.exe
InstallHint=\WARRIOR EPIC\dungeon.ddf
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE
AlwaysFullScreen=1


[5506]
LongName=World of Warcraft: Wrath of the Lich King Beta
ShortName=wotlkb
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Blizzard Entertainment\World of Warcraft\3\InstallPath
LauncherExe=Launcher.exe
DetectExe=wow.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_PRESENT
DetectServer=FALSE
Locale=WoW
GameClientDataType=WOW


[5507]
LongName=Jutland Beta
ShortName=jutland
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Albireo\Distant Guns, The First World War at Sea\main_path
LauncherExe=DG_WWIp.exe
LauncherNetworkArgs=mp:"%UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT%"
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5508]
LongName=IGI-2: Covert Strike
ShortName=igi2cs
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\IGI 2 Retail\Installdir\Installdir
LauncherDirAppend=\pc
LauncherExe=igi2.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE|BLOCK_ASYNC


[5509]
LongName=CQC: Close Quarter Combat
ShortName=cqc
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\CQC\DisplayIcon
LauncherDirTruncAt=\Help
LauncherDirAppend=\System
LauncherExe=CqC.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=USE_PRESENT|USE_SWAPCHAIN|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5510]
LongName=Q-World
ShortName=qworld
LauncherDirDefault=C:\Q-World
LauncherExe=\patcher\patcher.exe
DetectExe=\element\elementclient.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=USE_PRESENT|ENABLE_MOUSE
RunElevated=1


[5511]
LongName=Majesty Gold Edition
ShortName=majge
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Majesty.exe\Path
LauncherDirAppend=\Majesty
LauncherExe=Majesty.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5512]
LongName=Majesty Gold Edition: The Northern Expansion
ShortName=majgex
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Majesty.exe\Path
LauncherDirAppend=\MajX
LauncherExe=MajX.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5513]
LongName=I.G.I.: I'm Going In
ShortName=igi2igi
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Eidos Interactive\IGI\Install\Destination
LauncherDirAppend=\pc
LauncherExe=IGI.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D7
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE|USE_DINPUT1


[5514]
LongName=Transport Giant
ShortName=transg
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\JoWood\TransportGiant\InstallPath
LauncherExe=transportgiant.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D7
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE|DISABLE_FOR_VISTA


[5515]
LongName=Command & Conquer: Red Alert 3 Beta
ShortName=ccra3b
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Electronic Arts\EA Games\Red Alert 3 Beta\Install Dir
LauncherExe=RA3Beta.exe
DetectExe=\RetailExe\*\ra3game.dat
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE|NO_HIDE_CURSOR
DetectServer=False


[5516]
LongName=The Settlers III
ShortName=settl3
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\S3.EXE\Path
LauncherExe=s3.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5517]
LongName=Beijing 2008
ShortName=beij08
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\SEGA\Beijing 2008\InstallLocation
LauncherExe=Beijing.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5518_1]
LongName=Eschalon Book I
ShortName=eschb1
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\eschalon book i\eschalon_book_1.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 25600 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer[0]=DDRAW
InGameRenderer[1]=OGL
InGameFlags[0]=ENABLE_MOUSE
InGameFlags[1]=ENABLE_MOUSE
RunElevated=1


[5518_2]
LongName=Eschalon Book I
ShortName=eschb1
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Eschalon Book I_is1\Inno Setup: App Path
LauncherExe=Eschalon Book I.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer[0]=DDRAW
InGameRenderer[1]=OGL
InGameFlags[0]=ENABLE_MOUSE
InGameFlags[1]=ENABLE_MOUSE


[5519]
LongName=Sudden Strike 3: Arms for Victory
ShortName=sstri3
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Fireglow\Sudden Strike 3\Install_Dir
LauncherExe=SS3Game.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5520]
LongName=Project Powder Beta
ShortName=ppowder
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Outspark.com\Launcher\Path
LauncherDirTruncAt=\SharpLauncher
LauncherExe=SharpLauncher\OutsparkLauncher.exe
MatchExe=Run.exe
InstallHint=Project Powder\XTrap\XDataFI0.Xtp
Launch=%UA_LAUNCHER_EXE_PATH% propow %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
CommandLineMustNotContain[0]=solstice
CommandLineMustNotContain[1]=fiesta
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE|BLOCK_ASYNC
RunElevated=1


[5521]
LongName=Xiah Rebirth
ShortName=xiah
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\GamesCampus\Xiah Online\InstallDir
LauncherExe=Xiah.exe
DetectExe=XiahClient.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
;InGameRenderer=D3D9
;InGameFlags=USE_PRESENT|BLOCK_ASYNC


[5522]
LongName=Asda Story
ShortName=asda
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\yourapp.Exe\Path
LauncherExe=GameUpdater.exe
DetectExe=AsdaStory.exe
PlayingDetectType=ByWindowSubstr
ProcessWindowTitle=Asda
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5523]
LongName=Dream Pinball 3D
ShortName=dpin3d
LauncherDirDefault=C:\Program Files\TopWare\Dream Pinball 3D
LauncherExe=dp3d.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5524]
LongName=Sho Online
ShortName=shoo
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\LizardGame\Sho\InstallPath
LauncherExe=Play.exe
DetectExe=game.bin
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE|BLOCK_ASYNC|DISABLE_RELEASE


[5525_1]
LongName=Space Siege
ShortName=spsi
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=steamapps\common\space siege\Space Siege\SpaceSiege.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 10530 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT


[5525_2]
LongName=Space Siege
ShortName=spsi
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\SEGA\Gas Powered Games\Space Siege\InstallationDirectory
LauncherExe=SpaceSiege.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 10530 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT


[5526]
LongName=Shattered Suns
ShortName=shttrsun
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Shattered Suns\InstallLocation
LauncherExe=Shattered Suns.exe
DetectExe=ss\ss.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE
RunElevated=1


[5527]
LongName=Harino
ShortName=harino
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Harino\Harino\Install_Dir
LauncherExe=harino.exe
DetectExe=release\HarinoClient.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5528_1]
LongName=Pro Cycling Manager Season 2008
ShortName=pcms08
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=steamapps\common\pro cycling manager season 2008\PCM.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 11060 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5528_2]
LongName=Pro Cycling Manager Season 2008
ShortName=pcms08
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Cyanide\Pro Cycling Manager 2008\GameDir
LauncherExe=PCM.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5529]
LongName=QPang
ShortName=qpang
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\GameCapital\QPang\InstallPathList\QPangNL.main
LauncherExe=QPang.exe
DetectExe=QPangBin.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE|BLOCK_ASYNC|FORCE_REHOOK
RunElevated=1


[5530]
LongName=FATE: Undiscovered Realms
ShortName=fateur
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\WT050972\InstallLocation
LauncherExe=Fate-WT.exe
DetectExe=Fate.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=USE_PRESENT|ENABLE_MOUSE|DISABLE_FOR_VISTA


[5531]
LongName=Dracula: Origin
ShortName=draclo
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Frogwares\dracula\installdir
LauncherExe=game.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5532]
LongName=The Sims 2 Apartment Life
ShortName=sims2al
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Sims2EP8.exe\Path
LauncherDirAppend=\TSbin
LauncherExe=Sims2Launcher.exe
DetectExe=Sims2EP8.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5533]
LongName=Hunting Unlimited 2009
ShortName=huntu09
LauncherDirDefault=C:\Program Files\Hunting Unlimited 2009
LauncherExe=hu2009.exe
MatchExe=prism3d.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE


[5534_1]
LongName=FlatOut: Ultimate Carnage
ShortName=fouc
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=steamapps\common\flatout ultimate carnage\Fouc.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 12360 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5534_2]
LongName=FlatOut: Ultimate Carnage
ShortName=fouc
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\FlatOut Ultimate Carnage\InstallLocation
LauncherExe=launcher.exe
DetectExe=Fouc.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5535]
LongName=Battlefield Heroes Beta
ShortName=bfhb
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Electronic Arts\EA Games\Battlefield Heroes\Installation Dir
LauncherUrl=http://play.battlefield-heroes.com/
DetectExe=BFHeroes.exe
Launch=%UA_LAUNCHER_URL% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|USE_SWAPCHAIN|ENABLE_MOUSE|USE_DINPUT_MOUSE|DISABLE_SCREENSHOTS|DISABLE_VIDEO_CAPTURE


[5536]
LongName=4Story
ShortName=story4
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Zemi Interactive\4Story_us\pb\directory
LauncherExe=4Story.exe
DetectExe=TClient.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE


[5537]
LongName=Legend: Hand of God
ShortName=lhog
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{FAB5D969-FAC4-4AD2-9565-617A4A2F7159}\InstallLocation
LauncherExe=Starter.exe
DetectExe=legend.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9


[5538]
LongName=Pi Story
ShortName=pistory
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{974B7883-04DC-404D-80F3-CF16BADEA9A1}\InstallLocation
LauncherDirAppend=\bin
LauncherExe=PILauncher.exe
DetectExe=PIStory.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5539]
LongName=Mercenaries 2: World in Flames
ShortName=m2wif
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\EA GAMES\Mercenaries 2 World in Flames\Install Dir
LauncherExe=Mercenaries2.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5540_1]
LongName=SPORE
ShortName=spore
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Electronic Arts\SPORE\InstallLoc
LauncherDirAppend=\Sporebin
LauncherExe=SporeApp.exe
InstallHint=DMCmdPortalClient.dll
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE
VistaInGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5540_2]
LongName=SPORE
ShortName=spore
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=steamapps\*\spore\SporeBin\SporeApp.exe
InstallHint=steamapps\*\spore\SporeBin\steam_api.dll
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 17390 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE
VistaInGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5541]
LongName=Dracula 3: The Path of the Dragon
ShortName=drac3
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Dracula 3_is1\InstallLocation
LauncherExe=Dracula3.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5542]
LongName=Demigod
ShortName=demigb
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Stardock\Drengin.net\Demigod\Path
LauncherDirAppend=\bin
LauncherExe=Demigod.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5543]
LongName=Rome: Total War: Alexander
ShortName=rtwa
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\The Creative Assembly\Rome - Total War - Alexander add-on\InstallPath
LauncherExe=RomeTW-ALX.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=USE_PRESENT|USE_SWAPCHAIN


[5544]
LongName=Arca Sim Racing
ShortName=arcasr
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\ARCA Remax\ARCA Remax\Install_Dir
LauncherExe=ARCA.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE
RunElevated=1


[5545]
LongName=Oddworld: Abe's Exoddus
ShortName=oddae
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=steamapps\common\oddworld abes exoddus\Exoddus.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 15710 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=DDRAW
InGameFlags=DDRAW_FLIP_MODE|DISABLE_RELEASE|DISABLE_SCREENSHOTS|DISABLE_VIDEO_CAPTURE|DISABLE_FOR_VISTA


[5546]
LongName=Oddworld: Abe's Oddysee
ShortName=oddao
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=steamapps\common\oddworld abes oddysee\AbeWin.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 15700 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=DDRAW
InGameFlags=DDRAW_FLIP_MODE|DISABLE_RELEASE|DISABLE_SCREENSHOTS|DISABLE_VIDEO_CAPTURE|DISABLE_FOR_VISTA


[5547]
LongName=FIFA 09 Demo
ShortName=fifa09d
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\EA SPORTS\FIFA 09 Demo\Install Dir
LauncherExe=FIFA09.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5548_1]
LongName=S.T.A.L.K.E.R.: Clear Sky
ShortName=stlkrcs
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\GSC Game World\STALKER-STCS\InstallPath
LauncherExe=bin\xrEngine.exe
InstallHint=unins000.dat
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5548_2]
LongName=S.T.A.L.K.E.R.: Clear Sky
ShortName=stlkrcs
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=steamapps\common\stalker clear sky\bin\xrEngine.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 20510 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5549_1]
LongName=Warhammer Online: Age of Reckoning
ShortName=war
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\warhammer online age of reckoning\WAR.exe
InstallHint=steamapps\*\warhammer online age of reckoning\patcher\splash\english\patch.html
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 17420 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|BLOCK_ASYNC|ENABLE_MOUSE|USE_DINPUT_MOUSE
DetectServer=FALSE
RunElevated=1


[5549_2]
LongName=Warhammer Online: Age of Reckoning
ShortName=war
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Warhammer Online: Age of Reckoning\DisplayIcon
LauncherDirTruncAt=warpatch.exe
LauncherExe=warpatch.exe
DetectExe=WAR.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|BLOCK_ASYNC|ENABLE_MOUSE
DetectServer=FALSE
RunElevated=1


[5549_3]
LongName=Warhammer Online: Age of Reckoning
ShortName=war
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Warhammer Online - Age of Reckoning\DisplayIcon
LauncherDirTruncAt=warpatch.exe
LauncherExe=warpatch.exe
DetectExe=WAR.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|BLOCK_ASYNC|ENABLE_MOUSE
DetectServer=FALSE
RunElevated=1


[5549_4]
LongName=Warhammer Online: Age of Reckoning
ShortName=war
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\WAR\warhammer\InstallPath
LauncherDirTruncAt=warpatch.exe
LauncherExe=warpatch.exe
DetectExe=WAR.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|BLOCK_ASYNC|ENABLE_MOUSE
DetectServer=FALSE
RunElevated=1


[5550_1]
LongName=Crysis Warhead
ShortName=crysisw
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\crysis warhead\Bin32\crysis.exe
InstallHint=SteamApps\*\crysis warhead\runme.dat
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 17330 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer[0]=D3D9
InGameRenderer[1]=D3D10
InGameFlags[0]=USE_PRESENT
InGameFlags[1]=USE_PRESENT


[5550_2]
LongName=Crysis Warhead
ShortName=crysisw
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Crytek\Crysis_WARHEAD\InstallDir
LauncherDirAppend=\Bin32
LauncherExe=Crysis.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|DISABLE_RELEASE


[5551_1]
LongName=Crysis Wars
ShortName=crysiswr
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\crysis wars\Bin32\crysis.exe
InstallHint=SteamApps\*\crysis wars\runme.dat
LauncherLoginArgs=+login "%UA_GAME_LOGIN_NAME%" "%UA_GAME_LOGIN_PASSWORD%"
LauncherNetworkArgs=+connect_crynet %UA_GAME_HOST_NAME% %UA_GAME_HOST_PORT%
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 17340 %UA_LAUNCHER_LOGIN_ARGS% %UA_LAUNCHER_NETWORK_ARGS% %UA_LAUNCHER_PASSWORD_ARGS% %UA_LAUNCHER_EXTRA_ARGS%
InGameRenderer[0]=D3D9
InGameRenderer[1]=D3D10
InGameFlags[0]=USE_PRESENT|DISABLE_FOR_VISTA
InGameFlags[1]=USE_PRESENT


[5551_2]
LongName=Crysis Wars
ShortName=crysiswr
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{3F425F12-3A1B-4511-97B2-E2BB4701B745}\InstallLocation
LauncherDirAppend=\Bin32
LauncherExe=Crysis.exe
LauncherLoginArgs=+login "%UA_GAME_LOGIN_NAME%" "%UA_GAME_LOGIN_PASSWORD%"
LauncherNetworkArgs=+connect_crynet %UA_GAME_HOST_NAME% %UA_GAME_HOST_PORT%
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_LOGIN_ARGS% %UA_LAUNCHER_NETWORK_ARGS% %UA_LAUNCHER_PASSWORD_ARGS% %UA_LAUNCHER_EXTRA_ARGS%
InGameRenderer[0]=D3D9
InGameRenderer[1]=D3D10
InGameFlags[0]=USE_PRESENT|ENABLE_MOUSE|DISABLE_RELEASE
InGameFlags[1]=USE_PRESENT|ENABLE_MOUSE|SUBCLASS_WNDPROC


[5552]
LongName=Romance of the Three Kingdoms XI
ShortName=rottkxi
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\ROMANCE OF THE THREE KINGDOMS XI\ROMANCE OF THE THREE KINGDOMS XI\Install_Dir
LauncherExe=RTKXI.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE


[5553]
LongName=Pure
ShortName=pure
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{FF3C203A-2F19-43A2-9C7C-EC1B5A0FC873}\InstallLocation
LauncherExe=Pure.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE|BLOCK_ASYNC


[5554]
LongName=Source SDK Base: Orange Box
ShortName=sdkob
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\source sdk base 2007\HL2.exe
CommandLineMustNotContain[0]="\SourceMods\fistful_of_frags"
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 218 -novid %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE


[5555_1]
LongName=Lego Batman
ShortName=lbatman
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Warner Bros Interactive Entertainment\LEGOBatman\PathVal
LauncherExe=LEGOBatman.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
;InGameRenderer=D3D9
;InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5555_2]
LongName=Lego Batman
ShortName=lbatman
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\lego batman\LEGOBatman.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 21000 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5556]
LongName=Strong Bad's Cool Game for Attractive People Episode 1: Homestar Ruiner
ShortName=sbcgap1
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Episode 1 - Homestar Ruiner\DisplayIcon
LauncherDirTruncAt=Homestar101.exe
LauncherExe=Homestar101.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5557]
LongName=Strong Bad's Cool Game for Attractive People Episode 2: Strong Badia the Free
ShortName=sbcgap2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Episode 2 - Strong Badia the Free\DisplayIcon
LauncherDirTruncAt=Homestar102.exe
LauncherExe=Homestar102.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5558_1]
LongName=Civilization IV: Colonization
ShortName=civ4c
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Firaxis Games\Sid Meier's Civilization IV Colonization\INSTALLDIR
LauncherExe=Colonization.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5558_2]
LongName=Civilization IV: Colonization
ShortName=civ4c
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\civilization iv colonization\Colonization.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 16810 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE


[5559]
LongName=Perfect World International
ShortName=pwi
LauncherDirDefault=C:\Program Files\Perfect World Entertainment\Perfect World International
LauncherExe=patcher\patcher.exe
DetectExe=element\elementclient.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=USE_PRESENT|ENABLE_MOUSE
RunElevated=1


[5560_1]
LongName=Multiwinia
ShortName=mwinia
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Multiwinia_is1\InstallLocation
LauncherExe=multiwinia.exe
InstallHint=unins000.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE


[5560_2]
LongName=Multiwinia
ShortName=mwinia
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\multiwinia\multiwinia.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 1530 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE


[5561]
LongName=City Life 2008
ShortName=ctylf8
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\City Life 2008_is1\InstallLocation
LauncherDirAppend=\BIN
LauncherExe=Citylife_launcher.exe
DetectExe=CLD.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE
RunElevated=1


[5562]
LongName=King's Bounty: The Legend
ShortName=kbtl
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{E43ED0A0-C85E-40F0-807C-6A8A9D2FAEF3}_is1\Inno Setup: App Path
LauncherExe=kb.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5563_1]
LongName=1701 A.D.: The Sunken Dragon
ShortName=ad1701s
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Sunflowers\Anno 1701\InstallDir
LauncherExe=1701-AddOn.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|DISABLE_RELEASE|ENABLE_MOUSE


[5563_2]
LongName=1701 A.D.: The Sunken Dragon
ShortName=ad1701s
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{905D4F6B-FADC-4CA4-AA41-BD32A2E446CE}\InstallLocation
LauncherExe=Anno1701AddOn.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|DISABLE_RELEASE|ENABLE_MOUSE


[5564]
LongName=The Suffering
ShortName=tsuffer
LauncherDirDefault=C:\Program Files\Midway Home Entertainment\The Suffering
LauncherExe=Suffering.exe
MatchExe=Suffering
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
;InGameRenderer=D3D9
;InGameFlags=BLOCK_ASYNC


[5565]
LongName=Russia's Army
ShortName=rssa
External=1
LauncherUrl=http://www.gamevial.com/russiasarmy.htm
Launch=%UA_LAUNCHER_URL%


[5566]
LongName=Atlantica Online
ShortName=atlano
LauncherDirDefault=C:\nDoors\Atlantica
LauncherExe=AtlanticaRun.exe
DetectExe=Atlantica.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE
RunElevated=1


[5567]
LongName=Men of War Beta
ShortName=mowb
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\"Men of War" Multiplayer Beta_is1\Inno Setup: App Path
LauncherExe=mow.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5568]
LongName=Ultima Online: Kingdom Reborn
ShortName=uokr
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Origin Worlds Online\Ultima Online Kingdom Reborn\1.0\InstCDPath
LauncherExe=uo.exe
DetectExe=UOKR.exe
InstallHint=UOKR.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5569]
LongName=Pro Evolution Soccer 2009 Demo
ShortName=pes09d
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{722AED08-B149-423F-8B86-8453643B61E5}\InstallLocation
LauncherExe=pes2009.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5570_1]
LongName=Sacred 2 - Fallen Angel
ShortName=sac3fa
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\sacred2.exe\Path
LauncherExe=sacred2.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|DISABLE_RELEASE
InGameDelay=60000


[5570_2]
LongName=Sacred 2 - Fallen Angel
ShortName=sac3fa
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\sacred 2\system\sacred2.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 22700 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE
InGameDelay=60000


[5571_1]
LongName=Brothers In Arms: Hell's Highway
ShortName=biahh
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\brothers in arms hells highway\Binaries\biahh.exe
InstallHint=steamapps\*\brothers in arms hells highway\Redist\VC80\vcredist_x86.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 15390 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT


[5571_2]
LongName=Brothers In Arms: Hell's Highway
ShortName=biahh
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Brothers in Arms - Hell's Highway\InstallDir
LauncherDirAppend=\Binaries
LauncherExe=biahh.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE|BLOCK_ASYNC


[5572]
LongName=Hinterland
ShortName=hntld
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\hinterland\Hinterland.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 17140 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE


[5573]
LongName=Age of Chivalry
ShortName=hl2aoc
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\age of chivalry\HL2.exe
InstallHint=steamapps\*\age of chivalry\ageofchivalry\aoc_icon.ico
;LauncherPasswordArgs=+password %UA_GAME_HOST_PASSWORD%
LauncherNetworkArgs=+connect %UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT%
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 17510 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
ServerStatusType=SOURCE
ServerEncodingType=UTF8
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5574]
LongName=Zombie Panic! Source
ShortName=hl2zp
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\zombie panic! source\HL2.exe
InstallHint=steamapps\*\zombie panic! source\zps\ZPSmanual.pdf
;LauncherPasswordArgs=+password %UA_GAME_HOST_PASSWORD%
LauncherNetworkArgs=+connect %UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT%
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 17500 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
ServerStatusType=SOURCE
ServerGameName=ZPS 1.4.1
ServerEncodingType=UTF8
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5575]
LongName=D.I.P.R.I.P. Warm Up
ShortName=hl2dr
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\diprip warm up\HL2.exe
InstallHint=steamapps\*\diprip warm up\diprip\resource\28 days later.ttf
;LauncherPasswordArgs=+password %UA_GAME_HOST_PASSWORD%
LauncherNetworkArgs=+connect %UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT%
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 17530 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
ServerStatusType=SOURCE
ServerEncodingType=UTF8
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5576]
LongName=Shocking Void
ShortName=shkvoid
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\ShockingVoid.Exe\Path
LauncherExe=ShockingVoid.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=DDRAW
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE|DDRAW_FLIP_MODE|USE_DINPUT1|BLOCK_ASYNC
RunElevated=1


[5577]
LongName=HighStreet 5
ShortName=hs5
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\SnailGame\5street\InstallDir
LauncherExe=5street.exe
DetectExe=5street\Launch.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=USE_PRESENT|ENABLE_MOUSE|CLEAR_CLIP_CURSOR


[5578]
LongName=FIFA Soccer 09
ShortName=fifa09
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\EA Sports\FIFA 09\Install Dir
LauncherExe=FIFA09.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5579_1]
LongName=World of Goo
ShortName=wog
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\world of goo\WorldOfGoo.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 22000 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5579_2]
LongName=World of Goo
ShortName=wog
LauncherDirDefault=C:\Program Files\WorldOfGoo
LauncherExe=WorldOfGoo.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5580]
LongName=Line Rider 2
ShortName=lnrdr2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\LineRider2\Install_Dir
LauncherExe=LR2Loader.exe
DetectExe=LineRider2.bbz
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|DISABLE_FOR_VISTA


[5581]
LongName=The Guild 2 Venice
ShortName=guild2v
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{91077588-AC04-4886-B20B-C8CF1A122F27}\InstallLocation
LauncherExe=GuildII Venice.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE|DISABLE_RELEASE|REINSTALL_KEYBOARD_HOOK


[5582]
LongName=Nostradamus - The Last Prophecy
ShortName=nostra
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Nostradamus - The Last Prophecy_is1\Inno Setup: App Path
LauncherExe=Nostradamus.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5583]
LongName=NHL 09
ShortName=nhl2k9
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\EA SPORTS\NHL 09\Install Dir
LauncherExe=nhl2009.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE


[5584_1]
LongName=Dead Space
ShortName=deads
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\dead space\Dead Space.exe
InstallHint=SteamApps\*\dead space\testapp.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 17470 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE|DISABLE_VIDEO_CAPTURE


[5584_2]
LongName=Dead Space
ShortName=deads
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Electronic Arts\Dead Space\Install Dir
LauncherExe=Dead Space.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE|DISABLE_VIDEO_CAPTURE


[5585]
LongName=Guitar Hero: Aerosmith
ShortName=ghaero
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Aspyr\Guitar Hero Aerosmith\Path
LauncherExe=Guitar Hero Aerosmith.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5586]
LongName=Baseball Mogul 2009
ShortName=bbmog09
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Strategy First\Baseball Mogul 2009\Install Path
LauncherExe=BB2K9.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5587]
LongName=Dark Horizon
ShortName=drkhor
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Paradox Interactive\Dark Horizon\Path
LauncherExe=dark_horizon.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5588]
LongName=S4 League
ShortName=s4l
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{D99223D4-1F48-47BD-ADFD-D43C91CDFD00}\InstallLocation
LauncherExe=patcher_s4.exe
DetectExe=S4Client.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE
RunElevated=1


[5589]
LongName=Miniconomy
ShortName=minicy
External=1
LauncherUrl=http://www.miniconomy.com/
Launch=%UA_LAUNCHER_URL%


[5590_1]
LongName=Far Cry 2
ShortName=fc2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Ubisoft\Far Cry 2\InstallDir
LauncherDirAppend=\bin
LauncherExe=FarCry2.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer[0]=D3D9
InGameRenderer[1]=D3D10
InGameFlags[0]=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE
InGameFlags[1]=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5590_2]
LongName=Far Cry 2
ShortName=fc2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\far cry 2\bin\FarCry2.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 19900 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer[0]=D3D9
InGameRenderer[1]=D3D10
InGameFlags[0]=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE
InGameFlags[1]=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5592]
LongName=Spectraball
ShortName=sball
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\spectraball\Spectraball.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 18300 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9


[5593]
LongName=NBA 2K9
ShortName=nba2k9
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\nba 2k9\nba2k9.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 7740 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT


[5594_1]
LongName=Bully: Scholarship Edition
ShortName=bullyse
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{A724605D-B399-4304-B8C7-33B3EF7D4677}\InstallLocation
LauncherExe=Bully.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5594_2]
LongName=Bully: Scholarship Edition
ShortName=bullyse
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\bully scholarship edition\Bully.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 12200 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5595_1]
LongName=X3: Terran Conflict
ShortName=x3tc
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\x3 terran conflict\X3TC.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 2820 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5595_2]
LongName=X3: Terran Conflict
ShortName=x3tc
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\X3TerranConflict_is1\Inno Setup: App Path
LauncherExe=X3TC.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5596]
LongName=Exodus From The Earth (Single player game)
ShortName=exftesp
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Parallax Arts Studio Inc.\Exodus From The Earth\InstallDir
LauncherDirAppend=\Bin
LauncherExe=EFTE.exe
CommandLineMustNotContain[0]=-data ..\net -multiplayer
CommandLineMustContain[0]=-data ..\single
Launch=%UA_LAUNCHER_EXE_PATH% -data ..\single %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5597]
LongName=Exodus From The Earth (Network game)
ShortName=exftemp
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Parallax Arts Studio Inc.\Exodus From The Earth\InstallDir
LauncherDirAppend=\Bin
LauncherExe=EFTE.exe
CommandLineMustNotContain[0]=-data ..\single
CommandLineMustContain[0]=-data ..\net -multiplayer
Launch=%UA_LAUNCHER_EXE_PATH% -data ..\net -multiplayer %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5598]
LongName=Space Trader
ShortName=spct
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\space trader\SpaceTrader.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 11240 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE


[5599_1]
LongName=Fallout 3
ShortName=fo3
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Bethesda Softworks\Fallout3\Installed Path
LauncherExe=FalloutLauncher.exe
DetectExe=Fallout3.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE|HIDE_CURSOR


[5599_2]
LongName=Fallout 3
ShortName=fo3
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Bethesda Softworks\Fallout3\Installed Path
LauncherExe=FalloutLauncher.exe
DetectExe=Fallout3ng.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE|HIDE_CURSOR


[5600]
LongName=Call of Duty: World at War Beta Multiplayer
ShortName=codwaw
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Activision\CODWAWbeta\InstallPath
LauncherExe=CoDWaWbeta.exe
;LauncherPasswordArgs=+password "%UA_GAME_HOST_PASSWORD%"
;LauncherNetworkArgs=%UA_LAUNCHER_PASSWORD_ARGS% +connect %UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT%
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|USE_SWAPCHAIN|ENABLE_MOUSE|USE_DINPUT_MOUSE|BLOCK_ASYNC
;ServerStatusType=COD4MW


[5601]
LongName=Command & Conquer: Red Alert 3
ShortName=ccra3
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Electronic Arts\Electronic Arts\Red Alert 3\Install Dir
LauncherExe=RA3.exe
MatchExe=ra3_1.[0-9]+.game
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|NO_HIDE_CURSOR
DetectServer=False


[5602_1]
LongName=MotoGP 08
ShortName=mgp08
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Capcom\Motogp08\Path
LauncherExe=Launcher.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
;InGameRenderer=D3D9
;InGameFlags=ENABLE_MOUSE|REINSTALL_KEYBOARD_HOOK|DISABLE_RELEASE


[5602_2]
LongName=MotoGP 08
ShortName=mgp08
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\motogp 08\Launcher.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 21610 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5603]
LongName=Euro Truck Simulator
ShortName=etsim
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Euro Truck Simulator\DisplayIcon
LauncherDirTruncAt=eurotrucks.exe
LauncherExe=eurotrucks.exe
DetectExe=game.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer[0]=OGL
InGameRenderer[1]=D3D9
InGameFlags[0]=ENABLE_MOUSE|USE_DINPUT_MOUSE
InGameFlags[1]=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5604]
LongName=My Sims
ShortName=mysims
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Electronic Arts\Sims\MySims\InstallDir
LauncherDirAppend=\bin
LauncherExe=MySims.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE|BLOCK_ASYNC


[5605]
LongName=Interstate '76
ShortName=i76
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\I76.exe\Path
LauncherExe=I76.EXE
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5606]
LongName=Football Manager 2009 Demo
ShortName=fm09d
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\football manager 2009 demo\fm.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 10570 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5607]
LongName=Spider-Man: Web of Shadows
ShortName=smanwos
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Activision\Spider-Man Web of Shadows\InstallPath
LauncherDirAppend=\image\pc
LauncherExe=Spider-Man Launcher.exe
DetectExe=Spider-Man Web of Shadows.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE|DISABLE_VIDEO_CAPTURE


[5608]
LongName=Combat Wings: Battle of Britain
ShortName=cwbob
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Combat Wings - Battle of Britain_is1\Inno Setup: App Path
LauncherExe=game.exe
DetectExe=game.bin
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE


[5609]
LongName=Cesar Millan's Dog Whisperer
ShortName=cmdw
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Ubisoft\Cesar Millan's Dog Whisperer(tm)\InstallPath
LauncherExe=DogWhisperer.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|DISABLE_RELEASE


[5610]
LongName=Endless Online
ShortName=endo
LauncherDirDefault=C:\Program Files\EndlessOnline
LauncherExe=endless.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5611]
LongName=OceanWar
ShortName=oceanwr
External=1
LauncherUrl=http://oceanwar.de/
Launch=%UA_LAUNCHER_URL%


[5612]
LongName=Quantum of Solace
ShortName=qos
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Activision\Quantum of Solace\InstallPath
LauncherExe=JB_Launcher_s.exe
DetectExe=JB_LiveEngine_s.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|USE_SWAPCHAIN|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5613]
LongName=Pro Evolution Soccer 2009
ShortName=pes09
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\KONAMI\PES2009\installdir
LauncherExe=pes2009.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5614]
LongName=On the Rain-Slick Precipice of Darkness, Episode Two
ShortName=otrspo2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\On the Rain-Slick Precipice of Darkness, Episode Two\Path
LauncherExe=RainSlickEp2.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE
InGameOGLTextureOffset=32000


[5615]
LongName=Left 4 Dead Demo
ShortName=l4dd
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\left 4 dead demo\left4dead.exe
LauncherNetworkArgs=+connect %UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT%
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 530 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
ServerStatusType=SOURCE
ServerEncodingType=UTF8
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE


[5616]
LongName=Legacy of Kain: Defiance
ShortName=lokd
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Crystal Dynamics\Legacy of Kain: Defiance\InstallPath
LauncherExe=defiance.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5617]
LongName=Legacy of Kain: Soul Reaver
ShortName=loksr
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Soul Reaver\Path
LauncherExe=kain2.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5618]
LongName=Silent Hill Homecoming
ShortName=shh
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\silent hill homecoming\Bin\SilentHill.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 19000 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5619]
LongName=Avatar: Path of Zuko
ShortName=apoz
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{8671C591-2113-407B-9EB6-0BFBBD0D3A11}\InstallLocation
LauncherExe=Avatar - Path of Zuko.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5620]
LongName=Galactic Bowling
ShortName=gbowl
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\galactic bowling\Game.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 20200 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5621]
LongName=Sniper- Art of Victory
ShortName=saov
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\City Interactive\Sniper - Art of Victory en\Path
LauncherExe=Sniper.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5622]
LongName=Deer Hunter Tournament
ShortName=deerht
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Deer Hunter Tournament_is1\Inno Setup: App Path
LauncherExe=DHT.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5623]
LongName=Call of Duty: World at War Singleplayer
ShortName=codwawsp
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Activision\Call of Duty WAW\InstallPath
LauncherExe=CoDWaW.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|USE_SWAPCHAIN|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5624]
LongName=Call of Duty: World at War Multiplayer
ShortName=codwawmp
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Activision\Call of Duty WAW\InstallPath
LauncherExe=CoDWaWmp.exe
LauncherNetworkArgs=+connect %UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT%
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|USE_SWAPCHAIN|ENABLE_MOUSE|USE_DINPUT_MOUSE
ServerStatusType=COD5


[5625]
LongName=Deadliest Catch Alaskan Storm
ShortName=dcas
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\AlaskanStorm\Install_Dir
LauncherExe=Alaska.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5626]
LongName=Everlight of Magic & Power
ShortName=eomp
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{7990E879-F6D5-45FC-9CC8-B34314ADBF71}\InstallLocation
LauncherExe=everlight.exe
DetectExe=\bin\game.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|DISABLE_FOR_VISTA


[5627]
LongName=Rhiannon: Curse of the Four Branches
ShortName=rcotfb
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Rhiannon\UninstallString
LauncherDirTruncAt=Uninstall.exe
LauncherExe=Rhiannon_splash.exe
DetectExe=Rhiannon.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5628]
LongName=Hell's Kitchen
ShortName=hktg
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Hell's Kitchen\InstallDir
LauncherExe=Hell's Kitchen.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5629]
LongName=Grand Prix Legends
ShortName=gpl
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\gpl.exe\Path
LauncherExe=gpl.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5630]
LongName=Tomb Raider: Underworld Demo
ShortName=trud
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\tomb raider underworld demo\tru.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 8150 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
;InGameRenderer=D3D9
;InGameFlags=USE_PRESENT|USE_SWAPCHAIN|BLOCK_ASYNC|FORCE_REHOOK


[5631]
LongName=Rumble Fighter
ShortName=rumbfght
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\OGPlanet\RumbleFighter\ProgramFolder
LauncherExe=RumbleLauncher.exe
DetectExe=RumbleFighter.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
;InGameRenderer=D3D9
;InGameFlags=USE_PRESENT|USE_SWAPCHAIN|ENABLE_MOUSE
RunElevated=1


[5632]
LongName=Avatar: Legends of the Arena
ShortName=avlota
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{E02C0C32-1103-42E3-B2B3-1630675B778C}\InstallLocation
LauncherExe=AvatarMP.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|USE_SWAPCHAIN|USE_DINPUT1|DISABLE_RELEASE|DISABLE_FOR_VISTA


[5633]
LongName=Left 4 Dead
ShortName=l4d
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\left 4 dead\left4dead.exe
LauncherNetworkArgs=+connect %UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT%
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 500 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
ServerStatusType=SOURCE
ServerGameName=L4D - Versus - Normal,L4D - Versus - Advanced,L4D - Co-op - Normal,L4D - Co-op - Advanced
ServerEncodingType=UTF8
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE


[5634]
LongName=Worldwide Soccer Manager 2009
ShortName=fm09
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\worldwide soccer manager 2009\wsm.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 10560 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|DISABLE_RELEASE


[5635_1]
LongName=Need for Speed Undercover
ShortName=nfsuc
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\need for speed undercover\nfs.exe
InstallHint=SteamApps\*\need for speed undercover\steam_api.dll
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 17430 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5635_2]
LongName=Need for Speed Undercover
ShortName=nfsuc
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\EA GAMES\Need for Speed Undercover\Install Dir
LauncherExe=nfs.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5636]
LongName=The Sims 2: Mansion and Garden Stuff
ShortName=sims2mgs
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Sims2ep9.exe\Path
LauncherExe=TSBin\Sims2Launcher.exe
DetectExe=TSBin\Sims2EP9.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5637_1]
LongName=Tomb Raider: Underworld
ShortName=tru
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Crystal Dynamics\Tomb Raider: Underworld\InstallPath
LauncherExe=tru.exe
InstallHint=uninst.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE


[5637_2]
LongName=Tomb Raider: Underworld
ShortName=tru
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\tomb raider underworld\tru.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 8140 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE|DISABLE_RELEASE


[5638]
LongName=Madagascar: Escape 2 Africa
ShortName=me2a
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Activision\Madagascar2\InstallPath
LauncherExe=Mad2.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE


[5639]
LongName=Lords of Evil
ShortName=loevil
External=1
LauncherUrl=http://lord.webmmo.com/
Launch=%UA_LAUNCHER_URL%


[5640]
LongName=Street Gears
ShortName=strtgrs
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Street Gears_is1\InstallLocation
LauncherExe=Launcher.exe
DetectExe=StreetGear.exe
PlayingDetectType=ByWindowSubstr
ProcessWindowTitle=SG client
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|VALIDATE_USING_EXE_NAME|DISABLE_DIRECT_INPUT_HOOK|REINSTALL_KEYBOARD_HOOK|DISABLE_RELEASE|BLOCK_ASYNC|FORCE_REHOOK
RunElevated=1


[5641]
LongName=Dynasty Warriors 6
ShortName=dw6
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{24D25AC0-E27A-4DD7-A4A0-43491E1428D7}\InstallLocation
LauncherExe=DW6_WIN.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5642]
LongName=FIFA Manager 09
ShortName=fifam09
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\EA Sports\FIFA Manager 09\Install Dir
LauncherExe=Manager09.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE|BLOCK_ASYNC


[5643]
LongName=Pokemon World Online
ShortName=pokwo
LauncherDirDefault=C:\Program Files\Pokemon_World_Online_9021
LauncherExe=Pokemon Game.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5644]
LongName=Eets
ShortName=eets
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\eets\Eets.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 6100 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5645]
LongName=Bodog Poker
ShortName=bodog
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Bodog Poker_is1\Inno Setup: App Path
LauncherExe=BPGame.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5646]
LongName=Mr. Robot
ShortName=mrrobot
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=steamapps\*\mrrobot\MrRobot.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 20710 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE


[5647]
LongName=AssaultCube
ShortName=assc
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\AssaultCube_v1.0\UninstallString
LauncherDirTruncAt=uninstall.exe
LauncherExe=assaultcube.bat
DetectExe=bin_win32\ac_client.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE


[5648]
LongName=Pyroblazer
ShortName=pblazer
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=steamapps\*\pyroblazer\Pyroblazer.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 21500 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5649]
LongName=Mosby's Confederacy
ShortName=mosbconf
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=steamapps\*\mosby's confederacy\MosbysConfederacy.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 17180 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE


[5650]
LongName=Eudemons Online
ShortName=eudemon
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Eudemons Online\Path
LauncherExe=Play.exe
DetectExe=soul.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5651_1]
LongName=Gothic III - Forsaken Gods
ShortName=goth3fg
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{7A308DBD-CFF1-461E-98BE-3A6EE3B4333B}\InstallLocation
LauncherExe=Gothic III Forsaken Gods.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5651_2]
LongName=Gothic III - Forsaken Gods
ShortName=goth3fg
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\JoWood\Gothic III - Götterdämmerung\Install
LauncherExe=Gothic III - Götterdämmerung.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5652]
LongName=Cross Fire
ShortName=crssfre
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Cross Fire_is1\Inno Setup: App Path
LauncherExe=CF_G4box.exe
DetectExe=crossfire.exe
PlayingDetectType=ByWindowSubstr
ProcessWindowTitle=CrossFire
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE|VALIDATE_USING_EXE_NAME|DISABLE_RELEASE|DISABLE_FOR_VISTA
RunElevated=1


[5653_1]
LongName=Football Manager 2009
ShortName=fm09eu
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Sports Interactive Ltd\Installs\FM2009\Path
LauncherExe=fm.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|DISABLE_RELEASE


[5653_2]
LongName=Football Manager 2009
ShortName=fm09eu
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\football manager 2009\fm.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 10540 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|DISABLE_RELEASE


[5654]
LongName=Grand Theft Auto IV
ShortName=gtaiv
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Rockstar Games\Grand Theft Auto IV\InstallFolder
LauncherExe=LaunchGTAIV.exe
DetectExe=GTAIV.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE


[5655]
LongName=Shin Megami Tensei Imagine Online
ShortName=smtio
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Shin Megami Tensei: Imagine Online\UninstallString
LauncherDirTruncAt=Uninst.exe
LauncherExe=ImagineUpdate.exe
DetectExe=ImagineClient.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE
RunElevated=1


[5656_1]
LongName=Shaun White Snowboarding
ShortName=swhitesb
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\shaun white snowboarding\ShaunWhiteSnowboardingUpdater.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 19990 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5656_2]
LongName=Shaun White Snowboarding
ShortName=swhitesb
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Ubisoft\ShaunWhiteSnowboarding\InstallDir
LauncherExe=ShaunWhiteSnowboarding.exe
DetectExe=ShaunWhiteSnowboardingGame.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5657]
LongName=Legendary
ShortName=lgndry
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\legendary\Binaries\Legendary.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 16730 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE|DISABLE_RELEASE


[5658]
LongName=Zero Online
ShortName=zeroo
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\ZeroOnline.exe\Path
LauncherExe=Play.exe
DetectExe=ZeroOnline.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=USE_PRESENT|USE_SWAPCHAIN|ENABLE_MOUSE|BLOCK_ASYNC|DISABLE_RELEASE


[5659]
LongName=I-Fluid
ShortName=ifluid
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\i-fluid\I-Fluid.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 23200 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
;InGameRenderer=D3D9
;InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE


[5660]
LongName=Desperados: Wanted Dead or Alive
ShortName=dwdoa
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Spellbound Software\Desperados 1.0\InstallPath
LauncherExe=Desperados.exe
DetectExe=Game\game.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5661]
LongName=Defense Grid: The Awakening
ShortName=dgta
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\defensegridtheawakening\DefenseGrid.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 18500 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5662_1]
LongName=Jazz Jackrabbit 2
ShortName=jj2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Epic MegaGames\Jazz Jackrabbit 2\InstallDir
LauncherExe=J2oem.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=DDRAW
InGameFlags=ENABLE_MOUSE|DISABLE_FOR_VISTA|DISABLE_VIDEO_CAPTURE


[5662_2]
LongName=Jazz Jackrabbit 2
ShortName=jj2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Epic MegaGames\Jazz Jackrabbit 2\InstallDir
LauncherExe=Jazz2.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=DDRAW
InGameFlags=ENABLE_MOUSE|DISABLE_FOR_VISTA|DISABLE_VIDEO_CAPTURE


[5663_1]
LongName=Prince of Persia
ShortName=prper
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Ubisoft\Prince of Persia\InstallDir
LauncherExe=Launcher\Launcher.exe
DetectExe=Prince of Persia.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5663_2]
LongName=Prince of Persia
ShortName=prper
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\prince of persia\PrinceOfPersia_Launcher.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 19980 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5664]
LongName=A Vampyre Story
ShortName=avamps
;LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\A Vampyre Story\UninstallString
LauncherDirDefault=C:\Program Files\The Adventure Company\A Vampyre Story\game
LauncherExe=main.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|DISABLE_RELEASE


[5665]
LongName=Secret Service: In Harm's Way
ShortName=ssihw
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Activision Value\SecretService\InstallPath
LauncherExe=ss.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|BLOCK_ASYNC


[5666]
LongName=Runes of Magic
ShortName=runeom
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Frogster Interactive Pictures\Runes of Magic\RootDir
LauncherExe=Runes of Magic.exe
DetectExe=client.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE


[5667]
LongName=Iron Grip Warlord
ShortName=igwar
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Isotx\IGWarlord\1.0\SetupPath
LauncherExe=igwarlord.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL
InGameFlags=DISABLE_FOR_VISTA


[5668]
LongName=Florensia
ShortName=flrnsia
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{47F6AD26-2E0E-4F49-9DF3-30392BC1ECE2}\InstallLocation
LauncherDirAppend=Florensia\Bin
LauncherExe=Launcher.exe
DetectExe=FlorensiaEN.bin
PlayingDetectType=ByWindowSubstr
ProcessWindowTitle=Florensia
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
;InGameRenderer=D3D9
;InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE|BLOCK_ASYNC|VALIDATE_USING_EXE_NAME


[5669_1]
LongName=Rise of the Argonauts
ShortName=rota
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\rise of the argonauts\Binaries\RiseOfTheArgonauts.exe
InstallHint=SteamApps\*\rise of the argonauts\installers\dotnetfx.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 12770 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5669_2]
LongName=Rise of the Argonauts
ShortName=rota
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{EC7EBCD9-0CB4-472B-BC64-364CDC3CAC4C}\InstallLocation
LauncherDirAppend=Binaries
LauncherExe=RiseOfTheArgonauts.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5671]
LongName=CSI: NY
ShortName=csiny
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Ubisoft\CSINYUbisoft\GameUpdate\installdir
LauncherExe=gu.exe
DetectExe=csi.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=DDRAW
InGameFlags=ENABLE_MOUSE


[5672]
LongName=Depths of Peril
ShortName=depop
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\depths of peril\DepthsOfPeril.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 23600 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
;InGameRenderer=OGL
;InGameFlags=ENABLE_MOUSE


[5673]
LongName=BattleForge Beta
ShortName=bttlfb
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Electronic Arts\BattleForgeBeta\Install Dir
LauncherExe=Bootstrapper.exe
DetectExe=battleforge.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer[0]=D3D9
InGameRenderer[1]=D3D10
InGameFlags[0]=USE_PRESENT|USE_SWAPCHAIN|ENABLE_MOUSE|USE_DINPUT_MOUSE|DISABLE_FOR_VISTA
InGameFlags[1]=USE_PRESENT|ENABLE_MOUSE|DISABLE_SCREENSHOTS|DISABLE_VIDEO_CAPTURE|USE_DINPUT_MOUSE
RunElevated=1


[5674]
LongName=Legacy
ShortName=legacy
External=1
LauncherUrl=http://www.legacy-game.net/
Launch=%UA_LAUNCHER_URL%


[5675]
LongName=Shaiya DE
ShortName=shaiyade
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{F916C6DF-2601-4385-9500-C45FF398D4CB}\InstallLocation
LauncherExe=Updater.exe
DetectExe=game.exe
;PlayingDetectType=ByWindowSubstr
;ProcessWindowTitle=Shaiya
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|VALIDATE_USING_EXE_NAME|DISABLE_DIRECT_INPUT_HOOK|ENABLE_MOUSE|USE_DINPUT_MOUSE|BLOCK_ASYNC
RunElevated=1
DetectServer=FALSE


[5676]
LongName=Mach 1 Demo
ShortName=mach1d
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Mach 1 Demo\Path
LauncherExe=MachGearDemo.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE


[5677]
LongName=Saints Row 2
ShortName=sntsrw2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\saints row 2\SR2_pc.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 9480 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5678]
LongName=MashON SPORE Comic Book Creator
ShortName=mscbc
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{1F440B7A-6499-3582-37A9-A76B25F8991A}\InstallLocation
LauncherExe=MashON SPORE Comic Book Creator.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5679]
LongName=Operation 7
ShortName=oprt7
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Netgame\OPERATION7\1.000\Path
LauncherUrl=http://op7.netgame.com/
DetectExe=OPERATION7.exe
Launch=%UA_LAUNCHER_URL% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5680]
LongName=SecondEarth: Faction Wars
ShortName=sndefw
External=1
LauncherUrl=http://secondearthfactionwars.com/
Launch=%UA_LAUNCHER_URL%


[5681]
LongName=Secondearth MMO
ShortName=sndemmo
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Secondearth\DisplayIcon
LauncherDirTruncAt=uninst-Secondearth.exe
LauncherDirAppend=bin
LauncherExe=Client.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE


[5682_1]
LongName=Mirror's Edge
ShortName=mirredge
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\EA GAMES\Mirror's Edge\Install Dir
LauncherDirAppend=\Binaries
LauncherExe=MirrorsEdge.exe
InstallHint=DialogLogo128x128.jpg
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE|DISABLE_RELEASE|BLOCK_ASYNC


[5682_2]
LongName=Mirror's Edge
ShortName=mirredge
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\mirrors edge\Binaries\MirrorsEdge.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 17410 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE|DISABLE_RELEASE|BLOCK_ASYNC


[5683]
LongName=The Lord of the Rings: Conquest
ShortName=lotrc
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Electronic Arts\The Lord of the Rings - Conquest\Install Dir
LauncherExe=Conquest.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5684]
LongName=La Tale
ShortName=latale
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{08C5815C-2C6E-44f8-8748-0E61BC9AFB03}\InstallLocation
LauncherExe=LaTaleLauncher.exe
DetectExe=LaTaleClient.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|VALIDATE_USING_EXE_NAME|DISABLE_DIRECT_INPUT_HOOK|ENABLE_MOUSE
DetectServer=FALSE


[5685]
LongName=The Chronicles of Spellborn
ShortName=tcos
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\The Chronicles of Spellborn_is1\Inno Setup: App Path
LauncherExe=sb_patch.exe
DetectExe=bin\client\Sb_client.exe
PlayingDetectType=ByWindowSubstr
ProcessWindowTitle=The Chronicles
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|REINSTALL_KEYBOARD_HOOK|VALIDATE_USING_EXE_NAME|DISABLE_DIRECT_INPUT_HOOK|ENABLE_MOUSE|DISABLE_FOR_VISTA
RunElevated=1


[5686]
LongName=Wizard 101
ShortName=wiz101
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\KingsIsle Entertainment, Inc.\Wizard101\InstallPath
LauncherExe=Wizard101.exe
DetectExe=Bin\WizardGraphicalClient.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5687]
LongName=Warhammer 40,000: Dawn of War II - Beta
ShortName=wh40k2b
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\warhammer 40,000 dawn of war ii - beta\DOW2.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 15660 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=CHECK_LISTENER|ENABLE_MOUSE




[5689]
LongName=Aquaria
ShortName=aqaria
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\aquaria\Aquaria.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 24420 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE|DISABLE_FOR_VISTA


[5690]
LongName=EDuke32
ShortName=eduke
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\eduke32.exe\Path
LauncherExe=eduke32.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
;InGameRenderer=OGL
;InGameFlags=USE_DINPUT1|DISABLE_FOR_VISTA
InGameOGLTextureOffset=32000


[5691]
LongName=PangYa
ShortName=pangya
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Ntreev\Pangya_Eu\Install_Dir
LauncherExe=update_eu.exe
DetectExe=ProjectG.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE|VALIDATE_USING_EXE_NAME|DISABLE_DIRECT_INPUT_HOOK|DISABLE_RELEASE
RunElevated=1


[5692]
LongName=18 Wheels of Steel American Long Haul
ShortName=wosalh
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\18 Wheels of Steel: American Long Haul\DisplayIcon
LauncherDirTruncAt=alh.exe
LauncherExe=alh.exe
DetectExe=prism3d.exe
InstallHint=prism3d.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE
InGameOGLTextureOffset=32000


[5693]
LongName=MLB Front Office Manager
ShortName=mlbfom
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\mlb front office manager\mgr.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 7780 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5694]
LongName=Commander In Chief - Geopolitical Simulator 2009
ShortName=cicgs
LauncherDirDefault=C:\Program Files\Commander In Chief - Geopolitical Simulator
LauncherExe=_start.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5695]
LongName=Tantra Global
ShortName=tantra
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Tantra\Path2
LauncherExe=Tantra.exe
DetectExe=HTLauncher.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5696]
LongName=Colin McRae Rally 3
ShortName=cmr3
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Codemasters\Colin McRae Rally 3\INSTALL_PATH
LauncherExe=Rally_3PC.exe
LauncherNetworkArgs=%UA_GAME_HOST_NAME% %UA_GAME_HOST_PORT% %UA_LAUNCHER_PASSWORD_ARGS%
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
;InGameRenderer=D3D9
;InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5697]
LongName=Nexuiz
ShortName=nexuiz
LauncherDirDefault=C:\Program Files\nexuiz-242\Nexuiz
LauncherExe=nexuiz.exe
DetectExe[0]=nexuiz.exe
DetectExe[1]=nexuiz-sdl.exe
LauncherNetworkArgs=+connect %UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT%
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
;InGameRenderer=OGL
InGameOGLTextureOffset=32000


[5698]
LongName=Colin McRae Rally 2
ShortName=cmr2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Codemasters\Colin McRae Rally 2\Game_HDPath
LauncherExe=CMR2.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
;InGameRenderer=DDRAW
;InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE


[5699]
LongName=Jewel Quest 2
ShortName=jquest2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\iWin.com Games\Jewel Quest2 Retail\Jewel Quest 2\Install_Dir
LauncherExe=JewelQuest2.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5700]
LongName=Jewel Quest Solitaire
ShortName=jquests
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\iWin.com Games\Jewel Quest Solitaire Retail\Jewel Quest Solitaire\Install_Dir
LauncherExe=JQSolitaire.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5701]
LongName=Jewel Quest Solitaire 2
ShortName=jquests2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\iWin.com Games\Jewel Quest Solitaire II Retail\Jewel Quest Solitaire II\Install_Dir
LauncherExe=JQSolitaire2.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5702]
LongName=Bejeweled Twist
ShortName=bjtwst
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\bejeweled twist\BejeweledTwist.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 3560 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5703]
LongName=Kega Fusion
ShortName=kfusn
LauncherDirDefault=C:\Program Files\Fusion36
LauncherExe=Fusion.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
;InGameRenderer=D3D7
;InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE
;AlwaysFullScreen=1


[5704]
LongName=Burnout Paradise: The Ultimate Box
ShortName=bptub
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\EA GAMES\Burnout(TM) Paradise The Ultimate Box\Install Dir
LauncherExe=BurnoutLauncher.exe
DetectExe=BurnoutParadise.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE|DISABLE_RELEASE


[5705]
LongName=Galactic Civilizations II: Ultimate Edition
ShortName=gciv2ue
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Stardock\Drengin.net\GalCiv2UL\Path
LauncherExe=GC2Launch.exe
DetectExe=Twilight\GC2TwilightOfTheArnor.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5706]
LongName=X-Blades
ShortName=xblds
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Gaijin\XBlades\InstallDir
LauncherExe=launcher.exe
DetectExe=xblades.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
;InGameRenderer=D3D9


[5707]
LongName=Everonia
ShortName=evrnia
External=1
LauncherUrl=http://www.everonia.com/
Launch=%UA_LAUNCHER_URL%


[5708]
LongName=F.E.A.R. 2: Project Origin
ShortName=fear2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\fear2\FEAR2.exe
;LauncherNetworkArgs=+join %UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT%
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 16450 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5709_1]
LongName=Perimeter 2: New Earth
ShortName=primtr2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\perimeter 2\Perimeter2.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 12420 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5709_2]
LongName=Perimeter 2: New Earth
ShortName=primtr2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Perimeter 2 - New Earth_is1\InstallLocation
LauncherExe=Perimeter2.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5710]
LongName=Neopets Puzzle Adventure
ShortName=nppa
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\neopets puzzle adventure\NeoPets.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 21620 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5711]
LongName=Poker For Dummies
ShortName=pkrfd
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Poker For Dummies®\InstallLocation
LauncherExe=PokerForDummies.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL
InGameFlags=ENABLE_MOUSE|DISABLE_FOR_VISTA


[5712]
LongName=Operation Mania
ShortName=oprtnm
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Operation Mania.exe\Path
LauncherExe=Operation Mania.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5713]
LongName=Ace Online
ShortName=aceon
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\ACEonline-Suba\ExecutePath
LauncherExe=ACEonline.exe
DetectExe=ACEonline.atm
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
;InGameRenderer=D3D9
;InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE|BLOCK_ASYNC|DISABLE_RELEASE


[5714]
LongName=Littlest Pet Shop
ShortName=ltlps
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Electronic Arts\LITTLEST PET SHOP\Install Dir
LauncherExe=lps.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE|DISABLE_RELEASE
RunElevated=1


[5715]
LongName=Multi Theft Auto: San Andreas
ShortName=mgtasa
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\MTA:SA DM\UninstallString
LauncherDirTruncAt=Uninstall.exe
LauncherExe=Multi Theft Auto.exe
InstallHint=Multi Theft Auto.exe.dat
MatchExe=gta_sa.exe
CommandLineMustContain[0]=-mta
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE|DISABLE_RELEASE


[5716]
LongName=Project of Planets
ShortName=pops
LauncherDirDefault=C:\Program Files\Project of Planets
LauncherExe=popclient.exe
DetectExe=start.bin
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL
InGameFlags=ENABLE_MOUSE|DISABLE_RELEASE
InGameOGLTextureOffset=32000


[5717]
LongName=Talisman Online
ShortName=taliso
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\IFSoft\Ssjx\Settings\euramerican_english\InstallPath
LauncherExe=game.exe
DetectExe=client.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D8
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5718]
LongName=Roblox
ShortName=roblox
LauncherDirDefault=C:\Program Files
LauncherExe=Roblox.exe
MatchExe=RobloxApp.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE
DetectServer=False


[5719_1]
LongName=Warhammer 40,000: Dawn of War II
ShortName=wh40k2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\dawn of war ii - spd\DOW2.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 15680 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE
DetectServer=FALSE


[5719_2]
LongName=Warhammer 40,000: Dawn of War II
ShortName=wh40k2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\dawn of war 2\DOW2.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 15620 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE
DetectServer=FALSE


[5721_1]
LongName=Drakensang: The Dark Eye
ShortName=drakg
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Drakensang_is1\Inno Setup: App Path
LauncherExe=launch.exe
DetectExe=drakensang.exe
InstallHint=ESRB.bmp
Launch=%UA_LAUNCHER_EXE_PATH% drakensang.exe -fullscreen %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5721_2]
LongName=Drakensang: The Dark Eye
ShortName=drakg
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\drakensang\drakensang.exe
InstallHint=SteamApps\*\drakensang\12640_install.vdf
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 12640 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5721_3]
LongName=Drakensang: The Dark Eye
ShortName=drakg
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Drakensang_is1\Inno Setup: App Path
LauncherExe=launch.exe
DetectExe=drakensang.exe
Launch=%UA_LAUNCHER_EXE_PATH% drakensang.exe -fullscreen %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5722]
LongName=ShellShock 2: Blood of Trails
ShortName=shlls2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Eidos\Shellshock2\InstallPath
LauncherExe=Shellshock 2.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE


[5723]
LongName=Tom Clancy's EndWar
ShortName=tcendwr
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Ubisoft\Tom Clancy's EndWar\Home
LauncherExe=Tom Clancy's EndWar Launcher.exe
DetectExe=Binaries\EndWar.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE
DetectServer=False


[5724]
LongName=Puzzle Quest: Galactrix
ShortName=pqgx
LauncherDirDefault=C:\Program Files\Aspyr\Puzzle Quest Galactrix
LauncherExe=Galactrix.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5725_1]
LongName=Driver: Parallel Lines
ShortName=drvpl
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=steamapps\*\driver parallel lines\DriverParallelLines.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 21780 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5725_2]
LongName=Driver: Parallel Lines
ShortName=drvpl
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Ubisoft\Driver: Parallel Lines\Install path
LauncherExe=DriverParallelLines.exe
Launch=%UA_LAUNCHER_EXE_PATH%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5727]
LongName=Empire: Total War Demo
ShortName=etwd
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=steamapps\*\empire total war demo\Empire.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 10620 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5728]
LongName=Tom Clancy's H.A.W.X Demo
ShortName=tchawxd
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{6C596FD6-C378-4399-93F1-43A206759B23}\InstallLocation
LauncherExe=HAWX.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT


[5729]
LongName=The Last Remnant Demo
ShortName=lstrmd
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=steamapps\*\last remnant - demo sei\Binaries\TLRDemo.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 23330 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5730]
LongName=Empire: Total War
ShortName=emptw
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\empire total war\Empire.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 10500 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE
DetectServer=FALSE


[5732]
LongName=Football Manager Live
ShortName=fml
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Football Manager Live fml_live_v1\InstallLocation
LauncherExe=fml_launcher.exe
MatchExe=fml.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5733]
LongName=Watchmen: The End Is Nigh
ShortName=wtmtein
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\watchmen\data\Engine\KapowMulti.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 21010 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5734]
LongName=ijji Splash Fighters
ShortName=islfghs
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\SplashFightersIjji\InstallLocation
LauncherDirAppend=\SplashFightersIjji
LauncherUrl=http://sfighters.ijji.com/
DetectExe=amped.exe
Launch=%UA_LAUNCHER_URL% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
;InGameRenderer=OGL


[5735]
LongName=Global Agenda Beta
ShortName=gagendb
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\valvetestapp17000\Binaries\TgGameClient.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 17000 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE|DISABLE_SCREENSHOTS|DISABLE_VIDEO_CAPTURE


[5736]
LongName=Major League Baseball 2K9
ShortName=mlb2k9
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\2K Sports\MLB 2K9\InstallDir
LauncherExe=mlb2k9.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT


[5737]
LongName=Command & Conquer Red Alert 3: Uprising
ShortName=ccra3u
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Electronic Arts\Electronic Arts\Red Alert 3 Uprising\Install Dir
LauncherExe=RA3EP1.exe
MatchExe=ra3ep1_1.[0-9]+.game
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|NO_HIDE_CURSOR
DetectServer=False


[5738]
LongName=Darkfall
ShortName=darkfall
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Aventurine\Darkfall\ProgramPath
LauncherExe=Lobby.exe
DetectExe=data\darkfall.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5739]
LongName=Age of Booty
ShortName=abooty
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\age of booty\Age of Booty.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 21600 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5740]
LongName=Codename: Panzers - Cold War
ShortName=cpcwar
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Atari\CPCW\InstallDir
LauncherDirAppend=\Home\Game
LauncherExe=CPCW.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|USE_SWAPCHAIN|ENABLE_MOUSE


[5741]
LongName=Grey's Anatomy
ShortName=greysa
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Ubisoft\Grey's Anatomy\Program
LauncherExe=GreysAnatomy.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL
VistaInGameFlags=ENABLE_MOUSE|USE_SWAPCHAIN|USE_DINPUT_MOUSE|DISABLE_SCREENSHOTS
InGameFlags=ENABLE_MOUSE|USE_SWAPCHAIN|USE_DINPUT_MOUSE


[5742]
LongName=Three Kingdoms
ShortName=kingdm3
LauncherDirDefault=C:\Uforia\ThreeKingdoms
LauncherExe=Launcher.exe
DetectExe=ThreeKingdoms.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE|BLOCK_ASYNC


[5743]
LongName=The Story of Legends
ShortName=tsols
LauncherDirDefault=C:\Legends
LauncherExe=Legends.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
;InGameRenderer=DDRAW
;InGameFlags=ENABLE_MOUSE|DISABLE_RELEASE|DISABLE_FOR_VISTA


[5744]
LongName=Men of War
ShortName=mow
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{137D91E1-2347-4EAC-BB0B-CC06C6B92A52}_is1\Inno Setup: App Path
LauncherExe=mow.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5745]
LongName=Tom Clancy's H.A.W.X. (DX10)
ShortName=tchwx10
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{6E36A172-06FB-4BC8-B7FC-D30D219E6776}\InstallLocation
LauncherExe=HAWX_dx10.exe
InstallHint=HAWX_dx10.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D10
InGameFlags=USE_PRESENT


[5746_1]
LongName=Tom Clancy's H.A.W.X. (DX9)
ShortName=tchawx9
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\tom clany's hawx\HAWX.exe
InstallHint=SteamApps\*\tom clany's hawx\directx\Apr2005_d3dx9_25_x86.cab
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 21900 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT


[5746_2]
LongName=Tom Clancy's H.A.W.X. (DX9)
ShortName=tchawx9
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{6E36A172-06FB-4BC8-B7FC-D30D219E6776}\InstallLocation
LauncherExe=HAWX.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT


[5747]
LongName=Ceville
ShortName=ceville
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\ceville\Ceville.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 23460 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5748]
LongName=Priston Tale 2
ShortName=prtl2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Yedang Online\PristonTale2\Directory
LauncherExe=PT2Start.exe
DetectExe=Bin\PT2.exe
PlayingDetectType=ByWindowSubstr
ProcessWindowTitle=PristonTale
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
;InGameRenderer=D3D9
;InGameFlags=USE_PRESENT|ENABLE_MOUSE|DISABLE_RELEASE
DetectServer=False
RunElevated=1


[5749]
LongName=Magica Online
ShortName=mgco
External=1
LauncherUrl=http://z10.invisionfree.com/magicaonline
Launch=%UA_LAUNCHER_URL%


[5750_1]
LongName=Wanted: Weapons of Fate
ShortName=wwof
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Grin\Wanted\InstallDir
LauncherExe=Wanted.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE|DISABLE_FOR_VISTA


[5750_2]
LongName=Wanted: Weapons of Fate
ShortName=wwof
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\wanted - weapons of fate\Wanted.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 21070 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE|DISABLE_FOR_VISTA


[5751]
LongName=BattleForge
ShortName=bttlf
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Electronic Arts\BattleForge\Install Dir
LauncherExe=Bootstrapper.exe
DetectExe=battleforge.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer[0]=D3D9
InGameRenderer[1]=D3D10
InGameFlags[0]=USE_PRESENT|USE_SWAPCHAIN|ENABLE_MOUSE|USE_DINPUT_MOUSE|DISABLE_FOR_VISTA
InGameFlags[1]=USE_PRESENT|ENABLE_MOUSE|DISABLE_SCREENSHOTS|DISABLE_VIDEO_CAPTURE|USE_DINPUT_MOUSE
RunElevated=1


[5752]
LongName=The Last Remnant
ShortName=lstrm
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=steamapps\*\the last remnant\Binaries\TLR.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 23310 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5753]
LongName=Wheelman
ShortName=whlman
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{3604BFF4-6EC8-44D6-B147-92C2D642FEDE}\InstallLocation
LauncherDirAppend=\Binaries
LauncherExe=WheelmanGame-Final.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5754]
LongName=Stormrise
ShortName=strmrise
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\SEGA\Stormrise\installdir
LauncherExe=stormrise.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D10
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE|NO_HIDE_CURSOR|DISABLE_BROWSER


[5755]
LongName=Fantasy Tennis 2
ShortName=ften
LauncherDirDefault=C:\alaplaya\FantasyTennis
LauncherExe=FT_Launcher.exe
DetectExe=FT_Client.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE|DISABLE_RELEASE


[5756]
LongName=Theatre of War
ShortName=thow
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Theatre of War_is1\InstallLocation
LauncherExe=ToW.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL
InGameFlags=ENABLE_MOUSE|USE_DINPUT1


[5757]
LongName=Atmosphir Beta
ShortName=atsphrb
LauncherDirDefault=C:\Program Files\Atmosphir Private BETA 1.5
LauncherExe=Atmosphir.exe
DetectExe=Game.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE|DISABLE_SCREENSHOTS|DISABLE_VIDEO_CAPTURE
AlwaysFullScreen=1
RunElevated=1


[5758]
LongName=The Maw
ShortName=maw
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=steamapps\*\the maw\Maw.bin
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 26000 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5759]
LongName=Dark Sector
ShortName=dsctr
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=steamapps\*\dark sector\DS.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 29900 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5760]
LongName=Wallace and Gromit Ep1: Fright of the Bumblebees
ShortName=wge1fb
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=steamapps\*\wallace and gromit ep1\WallaceGromit101.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 31100 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5761]
LongName=Grand Ages Rome
ShortName=gagesr
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=steamapps\*\grand ages rome\Rome.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 23450 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5762]
LongName=Trainz Simulator 2009: World Builder Edition
ShortName=t09rs
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=steamapps\*\trainz 2009 railroad simulator\bin\trainz.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 24600 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL
InGameFlags=ENABLE_MOUSE


[5763]
LongName=The Chronicles of Riddick: Assault on Dark Athena
ShortName=coraoda
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Atari\The Chronicles of Riddick - Assault on Dark Athena\InstallPath
LauncherExe=DarkAthena_Launcher.exe
DetectExe=System\Win32_x86\DarkAthena.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5764]
LongName=Leisure Suit Larry: Box Office Bust
ShortName=lslbob
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Codemasters\Leisure Suit Larry - Box Office Bust\InstallPath
LauncherDirAppend=Binaries
LauncherExe=LUGame.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE|BLOCK_ASYNC


[5765]
LongName=Monsters vs. Aliens
ShortName=mva
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Activision\MvA\InstallPath
LauncherExe=Launcher.exe
DetectExe=Game.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5766]
LongName=The Godfather II
ShortName=godfthr2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\EA GAMES\The Godfather II\Install Dir
LauncherExe=godfather2.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE|DISABLE_VIDEO_CAPTURE


[5767]
LongName=Penumbra: Requiem
ShortName=prp2
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{79A2AB22-00D8-4F09-A00A-F1CB7DB3E916}_is1\Inno Setup: App Path
LauncherDirAppend=\Black Plague\redist
LauncherExe=Requiem.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE
InGameOGLTextureOffset=32000


[5768]
LongName=FLOCK!
ShortName=flock
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=steamapps\*\flock\Flock.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 21640 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5769_1]
LongName=Braid
ShortName=braid
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Braid_is1\Inno Setup: App Path
LauncherExe=braid.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5769_2]
LongName=Braid
ShortName=braid
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=steamapps\*\braid\braid.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 26800 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5770]
LongName=Artifact
ShortName=artfct
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Artifact_is1\Inno Setup: App Path
LauncherExe=Artifact.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5771]
LongName=Happy Fun Rainbow Ponies FTW
ShortName=quakel


[5772_1]
LongName=Elven Legacy
ShortName=elvlgy
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=steamapps\*\elven legacy\ElvenLegacy.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 25850 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE|DISABLE_RELEASE


[5772_2]
LongName=Elven Legacy
ShortName=elvlgy
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Paradox Interactive\Elven Legacy\1.0\directory
LauncherExe=ElvenLegacy.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE|DISABLE_RELEASE


[5773]
LongName=And Yet It Moves
ShortName=ayim
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=steamapps\*\and yet it moves\And Yet It Moves.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 18700 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=OGL
InGameFlags=ENABLE_MOUSE


[5774]
LongName=DCS: Black Shark
ShortName=dcsbs
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Eagle Dynamics\BlackShark\Path
LauncherExe=\bin\stable\Launcher.exe
DetectExe=\bin\stable\DCS.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|DISABLE_FOR_VISTA


[5775]
LongName=Hard To Be a God
ShortName=htbag
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\BurutCT\HTBAG\WorkingDirectory
LauncherExe=AWE.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE


[5776]
LongName=Fistful of Frags
ShortName=hl2fof
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=SteamApps\*\source sdk base 2007\HL2.exe
CommandLineMustContain[0]="\SourceMods\fistful_of_frags"
InstallHint=steamapps\*\fistful_of_frags\resource\fistful.ttf
LauncherPasswordArgs=+password %UA_GAME_HOST_PASSWORD%
LauncherNetworkArgs="%UA_LAUNCHER_PASSWORD_ARGS% +connect %UA_GAME_HOST_NAME%:%UA_GAME_HOST_PORT%"
Launch=%UA_LAUNCHER_EXE_PATH% -gameidlaunch 10509932406671147226 -game "%UA_LAUNCHER_EXE_DIR%\SteamApps\SourceMods\fistful_of_frags" %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
ServerStatusType=SOURCE
ServerGameName=fistful_of_frags
ServerEncodingType=UTF8
InGameRenderer=D3D9
InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE


[5777]
LongName=Zeno Clash
ShortName=zenclsh
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=steamapps\*\zenoclash\ZenoClash.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 22200 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


[5778]
LongName=Free Realms Beta
ShortName=freerlmsb
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Free Realms Installer\Basepath
;LauncherDirAppend=\Installed Games\Free Realms
LauncherUrl=http://www.freerealms.com/
DetectExe=\Installed Games\Free Realms\FreeRealms.exe
Launch=%UA_LAUNCHER_URL% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE


[5779]
LongName=X-Com Enforcer
ShortName=xcome
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{9690B5DD-E1AE-4C35-87EB-A0AB939F2D26}_is1\InstallLocation
LauncherDirAppend=\System
LauncherExe=XCom.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
;InGameRenderer=DDRAW
;InGameFlags=ENABLE_MOUSE|USE_DINPUT_MOUSE|BLOCK_ASYNC|DISABLE_RELEASE|REINSTALL_KEYBOARD_HOOK|DISABLE_BROWSER


[5780]
LongName=X-Com Interceptor
ShortName=xcomi
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{D0CF6A7C-2367-40CF-A930-8B6E0A6CD4DE}_is1\Inno Setup: App Path
LauncherExe=Interceptor.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
;InGameRenderer=DDRAW


[5781]
LongName=Aion Beta
ShortName=aionb
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\SNDA\AION\Path
LauncherExe=PlayNCLauncher.exe
DetectExe=bin32\AION.bin
PlayingDetectType=ByWindowSubstr
ProcessWindowTitle=AION
Launch=%UA_LAUNCHER_EXE_PATH% /GameID:PlayNCLauncher /StartGameID:AION /LUpdateAddr:nprotect.aion.sdo.com/locallist%UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
;InGameRenderer=D3D9
;InGameFlags=USE_PRESENT|VALIDATE_USING_EXE_NAME|ENABLE_MOUSE|DISABLE_RELEASE|BLOCK_ASYNC|REINSTALL_KEYBOARD_HOOK
RunElevated=1


[5782]
LongName=Battle Realms
ShortName=brealms
LauncherDirDefault=C:\Program Files\Liquid Entertainment\Battle Realms
LauncherExe=Battle_Realms_F.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D7
InGameFlags=ENABLE_MOUSE|DISABLE_RELEASE|USE_DINPUT1|DISABLE_SCREENSHOTS|DISABLE_VIDEO_CAPTURE


[5783]
LongName=Scarygirl
ShortName=scrygrl
External=1
LauncherUrl=http://www.scarygirl.com/
GameUrl=http://www.scarygirl.com/
Launch=%UA_LAUNCHER_URL%


[5784]
LongName=Cryostasis
ShortName=cryosts
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Aspyr\Cryostasis\InstallDir
LauncherExe=cryostasis.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE|DISABLE_RELEASE


[5785]
LongName=Age of Wonders II: The Wizard's Throne
ShortName=aow2wt
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Age of Wonders II\UninstallString
LauncherDirTruncAt=aow2Uninstall.exe
LauncherExe=AoW2.exe
Launch=%UA_LAUNCHER_EXE_PATH% %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%


[5786]
LongName=Velvet Assassin
ShortName=velvass
LauncherDirKey=HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath
LauncherExe=steam.exe
DetectExe=steamapps\*\velvet assassin\Replay.exe
Launch=%UA_LAUNCHER_EXE_PATH% -applaunch 16720 %UA_LAUNCHER_EXTRA_ARGS% %UA_LAUNCHER_NETWORK_ARGS%
InGameRenderer=D3D9
InGameFlags=USE_PRESENT|ENABLE_MOUSE|USE_DINPUT_MOUSE


*/