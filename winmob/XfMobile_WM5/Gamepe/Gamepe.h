// Gamepe.h : main header file for the PROJECT_NAME application
//

#pragma once

#ifndef __AFXWIN_H__
	#error "include 'stdafx.h' before including this file for PCH"
#endif

#ifdef POCKETPC2003_UI_MODEL
#include "resourceppc.h"
#endif 

// CGamepeApp:
// See Gamepe.cpp for the implementation of this class
//

class CGamepeApp : public CWinApp
{
public:
	CGamepeApp();
	
// Overrides
public:
	virtual BOOL InitInstance();
		
// Implementation

	DECLARE_MESSAGE_MAP()
};

extern CGamepeApp theApp;
