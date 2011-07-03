// ClientT.h : header file
//
// of Microsoft Technical Support, Developer Support
// Copyright (c) 1998 Microsoft Corporation. All rights reserved.

#if !defined(AFX_CLIENTT_H__B7C54BD2_A555_11D0_8996_00AA00B92B2E__INCLUDED_)
#define AFX_CLIENTT_H__B7C54BD2_A555_11D0_8996_00AA00B92B2E__INCLUDED_

#include "XfireCore.h"	// Added by ClassView
#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000

/////////////////////////////////////////////////////////////////////////////
// CClientThread thread

class CClientThread : public CWinThread
{
	DECLARE_DYNCREATE(CClientThread)
protected:
	CClientThread();           // protected constructor used by dynamic creation

// Attributes
public:

// Operations
public:
	// Used to pass the socket handle from the main thread to this thread.
	//SOCKET m_hSocket;
		
	// CSocket derived class that handles the connection.
	CXfireCore m_socket;


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CClientThread)
	public:
	virtual BOOL InitInstance();
	virtual int ExitInstance();
	//}}AFX_VIRTUAL

// Implementation
protected:
	virtual ~CClientThread();

	// Generated message map functions
	//{{AFX_MSG(CClientThread)
		// NOTE - the ClassWizard will add and remove member functions here.
	//}}AFX_MSG
	afx_msg void OnTermThread(UINT, LONG);
	DECLARE_MESSAGE_MAP()
};

/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Developer Studio will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_CLIENTT_H__B7C54BD2_A555_11D0_8996_00AA00B92B2E__INCLUDED_)
