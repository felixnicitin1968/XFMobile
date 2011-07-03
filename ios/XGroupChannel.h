//
//  XGroupChannel.h
//  iXfire
//
//  Created by Moti Joseph on 2/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "global.h"


typedef struct XfGroupChannel
{
		
		
		uint8                      gsid[21];
		uint32                     owner_userid;
		char                       host[0x50];
		char                       room[0x50];
	    NSMutableArray             *users;
	    NSMutableArray             *messages;

		
}XfGroupChannel;



//	XGroupUser *pID=[XGroupUser alloc];

//	 users=[[NSMutableArray alloc] initWithObjects:nil]; 

@interface XGroupUser : NSObject 
{

@public
	
	uint32   userid;
	uint32   permissions;
	char     name[0x50];
	char     nick[0x50];
}

@end
