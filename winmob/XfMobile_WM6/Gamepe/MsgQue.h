// Msg.h: interface for the CMsg class.
//
//////////////////////////////////////////////////////////////////////


#pragma once

#define DEF_MSGFROM_CLIENT			1


#define DEF_MSGFROM_XFIRESERVER	    2
#define DEF_MSGFROM_GATESERVER		3
#define DEF_MSGFROM_LOGINSERVER		4


class CMsg  								 
{
public:
	void Get( unsigned char * pData, DWORD * pSize);
	BOOL bPut( unsigned char * pData, DWORD dwSize);
	CMsg();
	virtual ~CMsg();

	

	unsigned char * m_pData;
	DWORD  m_dwSize;


	char                   pad[4];
};
