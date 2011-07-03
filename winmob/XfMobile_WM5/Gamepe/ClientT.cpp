// ClientT.cpp : implementation file
//
// Microsoft Technical Support, Developer Support
// Copyright (c) 1998 Microsoft Corporation. All rights reserved.

#include "stdafx.h"

#include "ClientT.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CClientThread

IMPLEMENT_DYNCREATE(CClientThread, CWinThread)

CClientThread::CClientThread()
{
		// count of all threads running
	//if (InterlockedIncrement(&nThreadCount) == 1)
	//	termEvent.ResetEvent();	// only one reset needed
    
	
	OutputDebugString(L"CClientThread::CClientThread()");
	
}

CClientThread::~CClientThread()
{
	// this notifies parent thread when all threads have been deleted
	// note that it's still not terminated at this point, but it's close enough
//	if (InterlockedDecrement(&nThreadCount) == 0)
	//	termEvent.SetEvent(); // possibly called twice, but no harm done
}

BOOL CClientThread::InitInstance()
{



	OutputDebugString(L"CClientThread::InitInstance()\n");


    if (!AfxSocketInit())
	{

		return FALSE;
	}



	m_socket.Create();
		
	// Try to connect to the peer
	OutputDebugString(L"Try to connect to the peer");
	if (m_socket.Connect(L"206.220.42.147", 25999) == 0)
	{
		if (GetLastError() != WSAEWOULDBLOCK)
		{
			//error in the connection process, terminate myself

			OutputDebugString(L"CClientThread::InitInstance() m_socket Failed");
			::PostQuitMessage(0);
		}
	}

     OutputDebugString(L"End CClientThread::InitInstance()");
	
	return TRUE;
}

int CClientThread::ExitInstance()
{
	// Send message to the main thread that this socket connection has closed
	
//	AfxGetMainWnd()->SendMessage(WM_CONNECTIONCLOSE);
	return CWinThread::ExitInstance();
}

BEGIN_MESSAGE_MAP(CClientThread, CWinThread)
	//{{AFX_MSG_MAP(CClientThread)
		// NOTE - the ClassWizard will add and remove mapping macros here.
	//}}AFX_MSG_MAP
	ON_THREAD_MESSAGE(WM_TERM_THREAD, OnTermThread)
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CClientThread message handlers

// User defined message will be posted by parent thread when parent thread's
// main window is going to close.
void CClientThread::OnTermThread(UINT, LONG)
{

	OutputDebugString(L"CClientThread::OnTermThread()");
	// active close
	if (m_socket.m_fConnected)
	{
		m_socket.m_fConnected = FALSE;
		m_socket.ShutDown();
		m_socket.Close();
	}

	::PostMessage(g_hLoginWnd,WM_CONNECTION_STATUS,0,0);

	::PostMessage(g_hContactsWnd,WM_CONNECTION_STATUS,0,0);


	//::PostQuitMessage(0);
}
