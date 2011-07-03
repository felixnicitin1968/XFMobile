// Msg.cpp: implementation of the CMsg class.
//
//////////////////////////////////////////////////////////////////////
#include "stdafx.h"
#include<windows.h>
#include "MsgQue.h"

// rivital  02 268    
//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CMsg::CMsg()
{
	m_pData  = NULL;
	m_dwSize = NULL;
}

CMsg::~CMsg()						   
{
	if (m_pData != NULL) delete m_pData;

	m_pData=NULL;
}

BOOL CMsg::bPut( unsigned char * pData, DWORD dwSize)
{
	m_pData = new char [dwSize+1];
	if (m_pData == NULL) return FALSE;
	ZeroMemory(m_pData, dwSize);
	memcpy(m_pData, pData, dwSize);

	m_dwSize = dwSize;


	return TRUE;
}



void CMsg::Get( unsigned char * pData, DWORD * pSize)
{

	memcpy(pData, m_pData, m_dwSize);
	*pSize  = m_dwSize;
	
}


