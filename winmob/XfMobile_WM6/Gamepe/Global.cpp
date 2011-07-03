#include "stdafx.h"
#include <windows.h>
#include "Global.h"
#include "resourceppc.h"
#include "ChatViewDlg.h"
// {0E1432D8-2E4D-4d0f-8C2D-C972A8933A63}
#define INITGUID 
#include <initguid.h> 
#include <imaging.h> 
#include "Json/json.h"


int      AD_HEIGHT=55;



wchar_t* wcschr(const wchar_t* str, wchar_t ch)
{
	while ((*str)!=0)
	{
		if ((*str)==ch)
		{
			return((wchar_t *)str);
		}
		str++;
	}
	return(NULL);
}


static const GUID CLSID_Application = 
{ 0xe1432d8, 0x2e4d, 0x4d0f, { 0x8c, 0x2d, 0xc9, 0x72, 0xa8, 0x93, 0x3a, 0x63 } };

IImagingFactory* g_pImageFactory;

WCHAR            g_wzDeviceUDID[0x100];

WCHAR            g_wzUserAgent[0x400];

WCHAR            g_szPathToAdImage[0x1000];

WCHAR            g_szLinkToAdImage[0x1000];

WCHAR            g_szLinkToAd[0x1000];

WCHAR            g_szTextAd[0x1000];

char             g_ad_result[0x1000];

HWND             g_hAdHWND;

BOOL             g_isDisconnected=TRUE;



BOOL SendURLRequest(LPWSTR pServer,LPWSTR pObject)
{



	DbgMsg(pObject);


	UINT uRetVal;
	DWORD dwBufSize=MAX_PATH;


	BOOL fOK=FALSE;

	HINTERNET hSession ,hConnection,hRequest;




	while(1)
	{
		hSession = InternetOpen(L"XfMobileADRequest",
			INTERNET_OPEN_TYPE_DIRECT,
			NULL,
			NULL,
			0);

		if (!hSession) break;

		hConnection = InternetConnect(hSession, 
			pServer,  // Server
			INTERNET_DEFAULT_HTTP_PORT,
			NULL,     // Username
			NULL,     // Password
			INTERNET_SERVICE_HTTP,
			0,        // Synchronous
			NULL);    // No Context

		if (!hConnection)  break;;




		hRequest = HttpOpenRequest(hConnection, 
			L"GET",
			pObject,
			NULL,    // Default HTTP Version
			NULL,    // No Referer
			0, // Accept
			// anything
			0,       // Flags
			NULL);   // No Context

		if (!hRequest) break;


		WCHAR szUserAgent[400];

		wcscpy(szUserAgent,L"User-Agent: ");

		wcscat(szUserAgent,g_wzUserAgent);

		wcscat(szUserAgent,L"\r\n");

		if (!HttpAddRequestHeaders(hRequest, 

			szUserAgent, 

			(DWORD)-1, HTTP_ADDREQ_FLAG_ADD | HTTP_ADDREQ_FLAG_REPLACE ) ) {



				return false;

		}



		HttpSendRequest(hRequest,
			NULL,    // No extra headers
			0,       // Header length
			NULL,    // No Body
			0);      // Body length





		break;
	}


	InternetCloseHandle (hSession);
	InternetCloseHandle (hConnection);
	InternetCloseHandle(hRequest);






	return 0;//fOK;

}

UINT __cdecl GetNewADThread( LPVOID pParam )
{


    



	WCHAR adRequest[0x400];


	wsprintf(adRequest,L"/custom.php?appid=6a1398aa684c41649104e62ed784a5d9");//&uuid=%ws&country_code=en_US&appver=200&client=5",g_wzDeviceUDID);

	wcscat(adRequest,L"&uuid=");
	wcscat(adRequest,g_wzDeviceUDID);

	wcscat(adRequest,L"&country_code=");
	wcscat(adRequest,L"en_US");

	wcscat(adRequest,L"&appver=");
	wcscat(adRequest,L"200");

	wcscat(adRequest,L"&client=");
	wcscat(adRequest,L"5");

	DownloadXMLFromADGateway(L"cus.adwhirl.com",adRequest);


	if (g_szLinkToAdImage[0]==0) return -1;


	DownloadImage(GetForegroundWindow(),g_szLinkToAdImage);


	::ShowWindow(g_hAdHWND,SW_HIDE);

	::ShowWindow(g_hAdHWND,SW_SHOW);

	return 0;


}




UINT __cdecl MetricClickNotificationThread( LPVOID pParam )
{

	/*


	A metrics request should be sent after each impression and click.

	Endpoint:
	Impressions: http://met.adwhirl.com/exmet.php
	Clicks: http://met.adwhirl.com/exclick.php
	Client->Server: appid, nid, type, uuid, country_code, appver, client
	Server->Client: HTTP Status 200 (no content)

	*/


	WCHAR adRequest[0x400];
	wsprintf(adRequest,L"/exclick.php?appid=6a1398aa684c41649104e62ed784a5d9&type=9&nid=b390f1f6a43945d8852c72f1a8fa0352");


	wcscat(adRequest,L"&uuid=");
	wcscat(adRequest,g_wzDeviceUDID);

	wcscat(adRequest,L"&country_code=");
	wcscat(adRequest,L"en_US");

	wcscat(adRequest,L"&appver=");
	wcscat(adRequest,L"200");

	wcscat(adRequest,L"&client=");
	wcscat(adRequest,L"5");

	SendURLRequest(L"met.adwhirl.com",adRequest);



	return 0;

}


UINT __cdecl MetricImpressionsNotificationThread( LPVOID pParam )
{

	/*
	A metrics request should be sent after each impression and click.

	Endpoint:
	Impressions: http://met.adwhirl.com/exmet.php
	Clicks: http://met.adwhirl.com/exclick.php
	Client->Server: appid, nid, type, uuid, country_code, appver, client
	Server->Client: HTTP Status 200 (no content)

	*/

	WCHAR adRequest[0x400];


	wsprintf(adRequest,L"/exmet.php?appid=6a1398aa684c41649104e62ed784a5d9&type=9&nid=b390f1f6a43945d8852c72f1a8fa0352");
	wcscat(adRequest,L"&uuid=");
	wcscat(adRequest,g_wzDeviceUDID);

	wcscat(adRequest,L"&country_code=");
	wcscat(adRequest,L"en_US");

	wcscat(adRequest,L"&appver=");
	wcscat(adRequest,L"200");

	wcscat(adRequest,L"&client=");
	wcscat(adRequest,L"5");

		
		
	SendURLRequest(L"met.adwhirl.com",adRequest);



	return 0;




}



VOID CALLBACK GetNewADTimerProc(
								__in  HWND hwnd,
								__in  UINT uMsg,
								__in  UINT_PTR idEvent,
								__in  DWORD dwTime
								)
{
	if (g_isDisconnected) return;




	WCHAR adRequest[0x400];


	//wsprintf(adRequest,L"/custom.php?appid=6a1398aa684c41649104e62ed784a5d9&uuid=00000000000000000000000000000000&country_code=en_US&appver=200&client=5");



	wsprintf(adRequest,L"/custom.php?appid=6a1398aa684c41649104e62ed784a5d9");//&uuid=%ws&country_code=en_US&appver=200&client=5",g_wzDeviceUDID);

	wcscat(adRequest,L"&uuid=");
	wcscat(adRequest,g_wzDeviceUDID);

	wcscat(adRequest,L"&country_code=");
	wcscat(adRequest,L"en_US");

	wcscat(adRequest,L"&appver=");
	wcscat(adRequest,L"200");

	wcscat(adRequest,L"&client=");
	wcscat(adRequest,L"5");

	DownloadXMLFromADGateway(L"cus.adwhirl.com",adRequest);


	if (g_szLinkToAdImage[0]==0) return;


	DownloadImage(GetForegroundWindow(),g_szLinkToAdImage);


	::ShowWindow(g_hAdHWND,SW_HIDE);

	::ShowWindow(g_hAdHWND,SW_SHOW);





}



void DisplayImage(HWND hWnd,HDC hdc)
{


	if (!g_pImageFactory) return;

	ImageInfo imageInfo={0};
	IImage *pImage = NULL;
	HBITMAP hBitmap=NULL;


	IBitmapImage* pBitmapImage = 0;

	BitmapData bitmapData = {0};


	if (SUCCEEDED(g_pImageFactory->CreateImageFromFile(g_szPathToAdImage, &pImage))

		&& SUCCEEDED(pImage->GetImageInfo(&imageInfo)))
	{



		if (SUCCEEDED(g_pImageFactory->CreateBitmapFromImage(pImage, 

			0,0, imageInfo.PixelFormat, InterpolationHintDefault, &pBitmapImage)))
		{


			UINT imageWidth, imageHeight;

			imageWidth=imageInfo.Width;

			imageHeight=imageInfo.Height;


			RECT rc;
			GetWindowRect(hWnd,&rc);

			UINT Width, Height;

			Width=rc.right-rc.left;




			Height=rc.bottom-rc.top;


			if (1){//imageWidth>Width || imageHeight>Height) {


				BitmapData bitmapData = {0};


				RECT rect = {0, 0, imageInfo.Width, imageInfo.Height};

				bitmapData.Width = imageInfo.Width;

				bitmapData.Height = imageInfo.Height;

				bitmapData.PixelFormat = imageInfo.PixelFormat;


				pBitmapImage->LockBits(&rect, ImageLockModeRead, PixelFormat16bppRGB565, &bitmapData);

				hBitmap = CreateBitmap(bitmapData.Width, bitmapData.Height, 1,
					GetPixelFormatSize(bitmapData.PixelFormat), bitmapData.Scan0);   


				HDC bmpDC = CreateCompatibleDC(hdc);

				HGDIOBJ hOldBitmap = SelectObject(bmpDC, hBitmap);

				StretchBlt(hdc,0,0,Width,Height,
					bmpDC,0,0,imageInfo.Width, imageInfo.Height, SRCCOPY);





				SelectObject(bmpDC, hOldBitmap);


				pBitmapImage->UnlockBits(&bitmapData);

			}else{


				RECT rect = {(Width-imageWidth)/2,  (Height-imageHeight)/2, imageInfo.Width, imageInfo.Height};


				SetBkColor(hdc,RGB(0,0,0));

				HBRUSH black_brush = (HBRUSH)GetStockObject (BLACK_BRUSH);



				SelectObject (hdc, black_brush);


				Rectangle(hdc, 0,0, 
					rc.right, rc.bottom); 


				BitmapData bitmapData = {0};



				bitmapData.Width = imageInfo.Width;

				bitmapData.Height = imageInfo.Height;

				bitmapData.PixelFormat = imageInfo.PixelFormat;


				pBitmapImage->LockBits(&rect, ImageLockModeRead, PixelFormat16bppRGB565, &bitmapData);

				hBitmap = CreateBitmap(bitmapData.Width, bitmapData.Height, 1,
					GetPixelFormatSize(bitmapData.PixelFormat), bitmapData.Scan0);   


				HDC bmpDC = CreateCompatibleDC(hdc);

				HGDIOBJ hOldBitmap = SelectObject(bmpDC, hBitmap);

				//itBlt(hdc,(Width-imageWidth)/2,  (Height-imageHeight)/2,Width,Height,
				//	bmpDC,0,0, SRCCOPY);




				BitBlt(hdc,0, 0,imageInfo.Width,imageInfo.Height,
					bmpDC,0,0, SRCCOPY);



				SelectObject(bmpDC, hOldBitmap);


				pBitmapImage->UnlockBits(&bitmapData);



				//pImage->Draw(hdc, &rect, 0);
			}




			if (pImage)
				pImage->Release();
			if (pBitmapImage)
				pBitmapImage->Release();


		}
	}

}

BOOL   DownloadImage(HWND hWnd,WCHAR *szURL)
{



	UINT uRetVal;
	DWORD dwBufSize=MAX_PATH;
	WCHAR lpPathBuffer[MAX_PATH]=L"\\Application Data\\XFMOBILE\\xfmobilead";

	WCHAR *tExtension=wcsrchr(szURL,L'.');

	if (!tExtension) return FALSE;

	wcscat(lpPathBuffer,tExtension);



	DbgMsg(lpPathBuffer);


	DeleteUrlCacheEntry(szURL);

	DeleteFile(lpPathBuffer);

	HRESULT  sOK=URLDownloadToFile(NULL,szURL,lpPathBuffer,0,NULL);

	if (sOK==S_OK){



		wcscpy (g_szPathToAdImage,lpPathBuffer);


		return TRUE;


	}

	memset(g_szPathToAdImage,0,sizeof(g_szPathToAdImage));

	return FALSE;
}



void GetIMEI()
{



	TCHAR	szDeviceID[GETDEVICEUNIQUEID_V1_OUTPUT];
	DWORD	dwSize	= GETDEVICEUNIQUEID_V1_OUTPUT;

	HRESULT	hr		= GetDeviceUniqueID((LPBYTE)&CLSID_Application,sizeof(GUID),1,(LPBYTE)szDeviceID,&dwSize);

	CString	strTemp;
	CString	strID(TEXT("GetDeviceUniqueID failed!!!"));
	if(SUCCEEDED(hr))
	{

		strID.Empty();

		for(DWORD dwIndex=0; dwIndex<dwSize; ++dwIndex)
		{
			strTemp.Format(TEXT("%d"),szDeviceID[dwIndex]);

			strID	+= strTemp;
		}

		wcscpy(g_wzDeviceUDID,strID);

		OutputDebugString(g_wzDeviceUDID);
	}



}


//http://soma.smaato.net/oapi/reqAd.jsp?adspace=0&pub=0&beacon=true&device=winmo&format=IMG&position=top&adcount=1&response=HTML&height=30&width=240");
//=


void getDeviceType()
{

	DbgMsg(L"\ngetDeviceTypen");

	CString deviceType("");

	TCHAR tszOemInfo[128] = {0};
	SystemParametersInfo(SPI_GETOEMINFO, sizeof(tszOemInfo)/sizeof(*tszOemInfo),tszOemInfo,0);

	DbgMsg(tszOemInfo);


}

BOOL  GetUserAgent(void)
{







	WCHAR wUserAgent[0x200]={0};

	HKEY hKey=NULL;
	if (RegOpenKeyEx(HKEY_LOCAL_MACHINE,
		L"\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\\5.0\\User Agent",0,

		KEY_READ ,&hKey)!=ERROR_SUCCESS){

			return FALSE;

	}


	WCHAR wDefault[0x100];
	DWORD dwSize=sizeof(wDefault);

	if (RegQueryValueEx(hKey,0,NULL,
		NULL,(LPBYTE )wDefault,&dwSize)!=ERROR_SUCCESS){

			return FALSE;

	}


	WCHAR wVersion[0x100];
	dwSize=sizeof(wVersion);

	if (RegQueryValueEx(hKey,L"Version",NULL,
		NULL,(LPBYTE )wVersion,&dwSize)!=ERROR_SUCCESS){

			return FALSE;

	}


	WCHAR wPlatform[0x100];
	dwSize=sizeof(wPlatform);

	if (RegQueryValueEx(hKey,L"Platform",NULL,
		NULL,(LPBYTE )wPlatform,&dwSize)!=ERROR_SUCCESS){

			return FALSE;

	}

	// Get the device name from the registry
	HKEY Regkey;
	wchar_t Value[255]={0};
	if (RegOpenKeyEx(HKEY_LOCAL_MACHINE, L"\\Ident", 0, 0, &Regkey) == ERROR_SUCCESS)
	{
		DWORD dwSize = 255;


		if (RegQueryValueEx(Regkey,L"Name",NULL,NULL,(LPBYTE)&Value,&dwSize) == ERROR_SUCCESS &&
			wcslen(Value) > 0)
		{

			wcscat(g_wzUserAgent,Value);
			wcscat(g_wzUserAgent,L" ");


		}
		RegCloseKey(Regkey);
	}


	wcscat(g_wzUserAgent,wDefault);

	wcscat(g_wzUserAgent,L"(compatible; ");

	wcscat(g_wzUserAgent,wVersion);

	wcscat(g_wzUserAgent,L"; ");

	wcscat(g_wzUserAgent,wPlatform);

	wcscat(g_wzUserAgent,L")");



	DbgMsg(L"\n--------------------------\n");


	DbgMsg(g_wzUserAgent);



	DbgMsg(L"\n--------------------------\n");

	RegCloseKey(hKey);

	return TRUE;


}



BOOL  GetXFMobileVersion(WCHAR* lpvBuffer,DWORD lpdwBufferLength)
{


	//InternetQueryDataAvailable
	BOOL fOK=FALSE;
	WCHAR lpvSomeBuffer[0x100];
	DWORD dwSize=sizeof(lpvSomeBuffer);
	HINTERNET hSession;
	hSession=InternetOpen(L"XFMobile",INTERNET_OPEN_TYPE_DIRECT, NULL, NULL, 0);
	if (!hSession)  return fOK;

	HINTERNET hConnect=NULL;
	hConnect=InternetConnect(hSession, L"www.xf-mobile.com",
		INTERNET_DEFAULT_HTTP_PORT, NULL, NULL, INTERNET_SERVICE_HTTP, 0, 0);

	if (!hConnect){

		DbgMsg(L"GetXFMobileVersion InternetConnect Failed");
		return fOK;

	}
	HINTERNET hRequest=NULL;


	DbgMsg(L"Sending VERSION request ....\n");
	hRequest=HttpOpenRequest(hConnect, NULL,LINK2CHECK_VERSION, NULL, NULL, 0, 0, 0);

	HttpSendRequest(hRequest,0, 0, 0, 0);
	ZeroMemory(lpvSomeBuffer,sizeof(lpvSomeBuffer));

	if (HttpQueryInfo(hRequest, HTTP_QUERY_STATUS_CODE  ,
		lpvSomeBuffer, &dwSize, NULL)){


			DbgMsg(L"HttpQueryInfo result ....\n");
			if (wcsncmp(lpvSomeBuffer,L"200",3)==0) {


				DbgMsg(L"200 OK\n");
				wcscpy(lpvSomeBuffer,L"GVersion");
				dwSize=lpdwBufferLength;
				if (HttpQueryInfo(hRequest, HTTP_QUERY_CUSTOM  ,lpvSomeBuffer, &dwSize, NULL)) {

					if (lpdwBufferLength> dwSize ){

						wcscpy(lpvBuffer,lpvSomeBuffer);
						fOK=TRUE;

					}

				}
			}


	}


	InternetCloseHandle(hRequest);
	InternetCloseHandle(hConnect);
	InternetCloseHandle(hSession);
	return fOK;



}


BOOL DownloadXMLFromADGateway(LPWSTR pServer,LPWSTR pObject)
{


	DbgMsg(L"Enter DownloadXMLFromADGateway\n");

	DbgMsg(pObject);

	DWORD dwBytesWritten; 
	UINT uRetVal;
	DWORD dwBufSize=MAX_PATH;


	BOOL fOK=FALSE;

	HINTERNET hSession ,hConnection,hRequest;


	ZeroMemory(g_ad_result,sizeof(g_ad_result));

	WCHAR lpPathBuffer[MAX_PATH]=L"\\Application Data\\XFMOBILE\\server.html";

	HANDLE hTempFile = CreateFile((LPTSTR) lpPathBuffer, // file name 
		GENERIC_READ | GENERIC_WRITE, // open r-w 
		0,                    // do not share 
		NULL,                 // default security 
		CREATE_ALWAYS,        // overwrite existinge
		FILE_ATTRIBUTE_NORMAL,// normal file 
		NULL);                // no template 


	if (hTempFile == INVALID_HANDLE_VALUE) 
	{ 

		DbgMsg (L"CreateFile failed with error %d.\n", GetLastError());

		return FALSE;
	} 

	while(1)
	{
		hSession = InternetOpen(L"XfMobileADRequest",
			INTERNET_OPEN_TYPE_DIRECT,
			NULL,
			NULL,
			0);

		if (!hSession) break;

		hConnection = InternetConnect(hSession, 
			pServer,  // Server
			INTERNET_DEFAULT_HTTP_PORT,
			NULL,     // Username
			NULL,     // Password
			INTERNET_SERVICE_HTTP,
			0,        // Synchronous
			NULL);    // No Context

		if (!hConnection)  break;;




		hRequest = HttpOpenRequest(hConnection, 
			L"GET",
			pObject,
			NULL,    // Default HTTP Version
			NULL,    // No Referer
			0, // Accept
			// anything
			0,       // Flags
			NULL);   // No Context

		if (!hRequest) break;


		WCHAR szUserAgent[400];

		wcscpy(szUserAgent,L"User-Agent: ");

		wcscat(szUserAgent,g_wzUserAgent);

		wcscat(szUserAgent,L"\r\n");

		if (!HttpAddRequestHeaders(hRequest, 

			szUserAgent, 

			(DWORD)-1, HTTP_ADDREQ_FLAG_ADD | HTTP_ADDREQ_FLAG_REPLACE ) ) {



				return false;

		}



		HttpSendRequest(hRequest,
			NULL,    // No extra headers
			0,       // Header length
			NULL,    // No Body
			0);      // Body length

		DWORD dwContentLen=0;
		DWORD dwBufLen = sizeof(dwContentLen);
		DWORD dwIndex=0;




		dwBufLen = sizeof(dwContentLen);
		dwIndex=0;

		if (HttpQueryInfo(hRequest, 
			HTTP_QUERY_CONTENT_LENGTH | HTTP_QUERY_FLAG_NUMBER, 
			(LPVOID)&dwContentLen,
			&dwBufLen,
			&dwIndex))
		{

			// You have a content length so you can calculate percent complete
			char *pData = (char*)GlobalAlloc(GMEM_FIXED, dwContentLen + 1);

			memset(pData,0,dwContentLen);

			DWORD dwReadSize = dwContentLen / 10;   // We will read 10% of data
			// with each read.

			DWORD cReadCount;
			DWORD dwBytesRead;
			char *pCopyPtr = pData;
			BOOL bWrite;

			char *cp=g_ad_result;

			DWORD dwTotalBytes=0;

			for (cReadCount = 0; cReadCount < 10; cReadCount++)
			{


				InternetReadFile(hRequest, pCopyPtr, dwReadSize, &dwBytesRead);

				//cp+=dwBytesRead;


				bWrite=WriteFile(hTempFile, pCopyPtr,
					dwBytesRead,
					&dwBytesWritten, 
					NULL); 

				dwTotalBytes+=dwBytesRead;

				pCopyPtr = pCopyPtr + dwBytesRead;
			}


			// extra read to account for integer division round off
			InternetReadFile(hRequest,
				pCopyPtr,
				dwContentLen - (pCopyPtr - pData),
				&dwBytesRead);



			dwTotalBytes+=dwBytesRead;

			memcpy(g_ad_result,pData,dwTotalBytes);



			WriteFile(hTempFile, pCopyPtr,
				dwBytesRead,
				&dwBytesWritten, 
				NULL); 



			GlobalFree(pData);
		}else{

			DbgMsg(L"XfMobile getAD HttpQueryInfo:Error %d",GetLastError());


		}


		break;
	}


	InternetCloseHandle (hSession);
	InternetCloseHandle (hConnection);
	InternetCloseHandle(hRequest);

	CloseHandle (hTempFile);


	ParseAdOutput();

	DbgMsg(L"Lesve DownloadXMLFromADGateway\n");


	return 0;//fOK;

}


BOOL ParseAdOutput()
{

	OutputDebugString(L"\n-------ParseAdOutput-----------\n");


	json_object *new_obj;
	json_object *my_array;
	const char *cp;

	if (g_ad_result[0]==0) return FALSE;
	my_array = json_tokener_parse(g_ad_result);

	//if (my_array==0) return 0;

	//if (json_object_array_length(my_array)==0) return FALSE;


	new_obj=json_object_object_get(my_array,"img_url");


	if (new_obj){
		cp=json_object_get_string(new_obj);



		WCHAR img_url[0x400];

		MultiByteToWideChar(CP_UTF8, 0,cp, -1, img_url, 0x400);


		DbgMsg(img_url);

		OutputDebugString(L"\n------------------\n");

		wcscpy(g_szLinkToAdImage,img_url);

	}




	new_obj=json_object_object_get(my_array,"redirect_url");


	if (new_obj){
		cp=json_object_get_string(new_obj);


		WCHAR redirect_url[0x400];

		MultiByteToWideChar(CP_UTF8, 0,cp, -1, redirect_url, 0x400);


		DbgMsg(redirect_url);

		OutputDebugString(L"\n------------------\n");

		wcscpy(g_szLinkToAd,redirect_url);

	}




	new_obj=json_object_object_get(my_array,"metrics_url");

	if (new_obj){
		cp=json_object_get_string(new_obj);


		WCHAR metrics_url[0x400];

		MultiByteToWideChar(CP_UTF8, 0,cp, -1, metrics_url, 0x400);


		DbgMsg(metrics_url);

		OutputDebugString(L"\n------------------\n");
	}



	if (new_obj){
		new_obj=json_object_object_get(my_array,"ad_text");

		cp=json_object_get_string(new_obj);


		WCHAR ad_text [0x400];

		MultiByteToWideChar(CP_UTF8, 0,cp, -1, ad_text , 0x400);


		DbgMsg(ad_text );

		OutputDebugString(L"\n------------------\n");

		wcscpy(g_szTextAd,ad_text);
	}


	new_obj=json_object_object_get(my_array,"ad_type");

	if (new_obj){

		int ad_type=json_object_get_int(new_obj);



		OutputDebugString(L"\n-------a-----------\n");
	}








	return TRUE;
}

void    add_header(uint8 *Buffer,uint16 size,uint16 type ,uint8 attribute_count)
{


	memcpy(Buffer,&size,2);
	memcpy(Buffer+2,&type,2);
	Buffer[4]=attribute_count;



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
		ch = (byte) (Buffer[i] & 0x0F); // Strip offlow nibble 
		strcat(out,(pseudo[ (int) ch])); // convert thenibble to a String Character
		i++;
	}

	return out;
}    



uint32 read_attribute_noname(uint8 *Buffer,uint32 offset,uint32 type,uint8* data)
{

	uint32 subtype;

	unsigned char array_attribute_type;
	int array_attribute_len=0;
	int string_len=0;

	switch(Buffer[offset])
	{

		//case CLANS_USERIDS_TYPE:
	case 0x05:	
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

uint32   write_attributeX(uint8 *Buffer,uint32 offset,char *name,uint32 type,uint8* data,unsigned short x)
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

		string_length=x;
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

	case 0xA7:

		offset++;
		Buffer[offset]=0x08;
		offset++;

		Buffer[offset]=*data;
		offset+=1;

		return offset;


	case 0x47:
	case 0xAA:
	case 0x0B:

		offset++;
		Buffer[offset]=INT_TYPE;
		offset++;

		memcpy(&Buffer[offset],data,4);
		offset+=4;

		return offset;

	case 0x11:

		offset++;
		Buffer[offset]=3;
		offset++;
		memcpy(&Buffer[offset],data,16);
		offset+=16;
		return offset;

		break;
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
HBITMAP             g_hAdImage;
BOOL                g_bIsSoundNotification=TRUE;
CChatViewDlg       *g_pChatWnd;
BOOL                g_bIsHidden;
HTREEITEM           g_hSelectedItem;
BOOL     g_bIsIconNotification=FALSE;
HWND     g_hContactsWnd;
HWND     g_hLoginWnd;
HWND     g_hMainDlg;
HWND     g_hwndMb;
HMENU    g_hMenuBar;
DWORD    g_nActiveThreadID;
HWND     g_hContactsTreeCtrl;
long     g_SelectedUserID;
char     g_myStatusMsg[0x100]="Xfire on windows mobile";
HWND     g_hActiveChatWindow;

SHNOTIFICATIONDATA g_pNotification ;
SHMENUBARINFO      g_mbi;




void AppendMsg(HWND hWnd,WCHAR *wsMsg)
{


	int ndx = ::GetWindowTextLength(hWnd);

	::SendMessage (hWnd, EM_SETSEL, (WPARAM)ndx, (LPARAM)ndx);

	::SendMessage (hWnd, EM_REPLACESEL, 0, (LPARAM)wsMsg);

}

BOOL AddIconNotification(HWND hWnd,HICON hIcon,DWORD dwDuration)
{



	if (!g_bIsIconNotification) return TRUE;

	g_pNotification.cbStruct=sizeof(SHNOTIFICATIONDATA); 
	g_pNotification.npPriority = SHNP_ICONIC; 
	g_pNotification.dwID = 1; 
	g_pNotification.csDuration = dwDuration; 
	g_pNotification.hwndSink = NULL; 
	g_pNotification.pszHTML = NULL; 
	g_pNotification.grfFlags = NULL; 
	g_pNotification.pszTitle = NULL; 
	g_pNotification.hicon =hIcon; 
	g_pNotification.hwndSink=hWnd; 
	LRESULT hr=SHNotificationAdd(&g_pNotification); 

	return (hr==ERROR_SUCCESS);



}

BOOL AddMenuBar(HWND hWnd,UINT ID)
{



	memset(&g_mbi, 0, sizeof(SHMENUBARINFO));
	g_mbi.cbSize     = sizeof(SHMENUBARINFO);
	g_mbi.hwndParent = hWnd;
	g_mbi.nToolBarId = ID;//IDR_MENU1;
	g_mbi.hInstRes   = ::GetModuleHandle(NULL);
	g_mbi.dwFlags = SHCMBF_HMENU;
	if (SHCreateMenuBar(&g_mbi)){

		g_hwndMb          = g_mbi.hwndMB;
		TBBUTTONINFO tbbi = {0};
		tbbi.cbSize       = sizeof(tbbi);
		tbbi.dwMask       = TBIF_LPARAM | TBIF_BYINDEX;

		::SendMessage(g_hwndMb, TB_GETBUTTONINFO,0, (LPARAM)&tbbi);
		g_hMenuBar           = (HMENU)tbbi.lParam;

		//LPARAM lparam = MAKELPARAM(SHMBOF_NODEFAULT | SHMBOF_NOTIFY, SHMBOF_NODEFAULT | SHMBOF_NOTIFY);
       //  ::SendMessage(g_hwndMb, SHCMBM_OVERRIDEKEY, VK_TBACK, lparam);
		// SendMessage(g_hwndMb, SHCMBM_OVERRIDEKEY, VK_TTALK, lparam);

		//	::SendMessage(g_hwndMb, SHCMBM_OVERRIDEKEY, VK_TBACK, 0);

		return TRUE;

	}

	return FALSE;
}

VOID     DbgMsg(LPWSTR szError,...)
{



	//return;
	WCHAR                        szBuff[0x400];
	va_list                     vl;

	va_start(vl, szError);
	wsprintf(szBuff,szError, vl);
	szBuff[sizeof(szBuff)-1]=0;
	OutputDebugString(szBuff);
	va_end(vl);



}

void SetScreenOrientation(DWORD dwOrientation)
{
	DEVMODE deviceMode;

	memset(&deviceMode, 0, sizeof(deviceMode));
	deviceMode.dmSize = sizeof(deviceMode);
	deviceMode.dmFields = DM_DISPLAYORIENTATION;
	deviceMode.dmDisplayOrientation = dwOrientation;

	// Set the DM_DISPLAYORIENTATION property to the
	// specified orientation
	ChangeDisplaySettingsEx(NULL, &deviceMode,
		NULL, CDS_RESET, NULL);
}

DWORD GetScreenOrientation()
{
	DEVMODE deviceMode;

	memset(&deviceMode, 0, sizeof(deviceMode));
	deviceMode.dmSize = sizeof(deviceMode);
	deviceMode.dmFields = DM_DISPLAYORIENTATION;

	// Query the DM_DISPLAYORIENTATION property
	if (ChangeDisplaySettingsEx(NULL, &deviceMode,
		NULL, CDS_TEST, NULL) == DISP_CHANGE_SUCCESSFUL)
		return deviceMode.dmDisplayOrientation;
	else
		return DMDO_DEFAULT;
}

void DbgBufferPrint(unsigned char* pBuffer ,	unsigned int uLength)
{


	unsigned int  i;
	char _t[4096*10],*pTmp;
	WCHAR wTemp[4096*10];
	pTmp=_t;

	for ( i=0; i<uLength; i++){



		sprintf(pTmp,"%02X-",(unsigned char)pBuffer[i]);
		while(*pTmp!='-') pTmp++;
		pTmp++;
		if ((i%6)==0 && i ) {

			MultiByteToWideChar(CP_UTF8, 0, _t, -1, wTemp, 0x100);

			OutputDebugString(wTemp);
			pTmp=_t;


		}


	}
	*(strchr(_t,0)-1)=0;
	MultiByteToWideChar(CP_UTF8, 0, _t, -1, wTemp, 0x100);

	OutputDebugString(wTemp);


}




typedef struct TGame {

	unsigned int gameid;
	char name[200];
}TGame;


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