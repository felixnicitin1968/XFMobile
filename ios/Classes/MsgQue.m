//
//  MsgQue.m
//  iXfire
//
//  Created by Moti Joseph on 4/1/09.
//  Copyright 2009 Gamepe. All rights reserved.
//

#import "MsgQue.h"


@implementation MsgQue



- (id)init
{
	

	m_pData  = NULL;
	m_dwSize = 0;
	return self;
}



- (void)dealloc {
	
   	if (m_pData != NULL) free(m_pData);	
	m_pData=NULL;
	[super dealloc];
}





-(void) bGet:(char *) pFrom  Data:(char *) pData Size:(unsigned short*)  pSize   Index:(int *) pIndex Key: (char *) pKey
{
	*pFrom  = m_cFrom;
	memcpy(pData, m_pData, m_dwSize);
	*pSize  = m_dwSize;
	*pIndex = m_iIndex;
	*pKey   = m_cKey;

	
}




-(int)  bPut:(char) cFrom    Data: (char *) pData  Size:(unsigned short) dwSize   Index:(int) iIndex  Key:( char) cKey
{
	
	m_pData =malloc(dwSize );
	
	if (m_pData == NULL) return FALSE;
	
	memset(m_pData,0,dwSize); 


	memcpy(m_pData, pData, dwSize);
	

	m_dwSize = dwSize;
	
	
	m_cFrom  = cFrom;
	m_iIndex = iIndex;
	m_cKey   = cKey;
	return TRUE;
	
}
@end
