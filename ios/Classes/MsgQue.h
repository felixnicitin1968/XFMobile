//
//  MsgQue.h
//  iXfire
//
//  Created by Moti Joseph on 4/1/09.
//  Copyright 2009 Gamepe. All rights reserved.
//

#import <Foundation/Foundation.h>





@interface MsgQue : NSObject {

	
	char   m_cFrom;
	char *          m_pData;
	unsigned short  m_dwSize;
	int              m_iIndex;
	char             m_cKey;   // v1.4

}

-(void) bGet:(char *) pFrom  Data:(char *) pData Size:(unsigned short*)  pSize   Index:(int *) pIndex Key: (char *) pKey;
-(int)  bPut:(char) cFrom    Data: (char *) pData  Size:(unsigned short) dwSize   Index:(int) iIndex  Key:( char) cKey;


@end
