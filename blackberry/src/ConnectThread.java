/*
 * ConnectThread.java
 *
 * Copyright © 1998-2009 Research In Motion Ltd.
 * 
 * Note: For the sake of simplicity, this sample application may not leverage
 * resource bundles and resource strings.  However, it is STRONGLY recommended
 * that application developers make use of the localization features available
 * within the BlackBerry development platform to ensure a seamless application
 * experience across a variety of languages and geographies.  For more information
 * on localizing your application, please refer to the BlackBerry Java Development
 * Environment Development Guide associated with this release.
 */

import java.io.*;
import javax.microedition.io.*;

import net.rim.device.api.ui.*;

import java.util.Timer;
import java.util.TimerTask;

import javax.microedition.io.Connector;
import javax.microedition.io.SocketConnection;





// import net.rim.device.api.io.SocketConnectionEnhanced; 
/**
 * A thread class to handle communication with the server component.
 */

public class ConnectThread extends Thread {

	
	public static final int  INT_TYPE      =2;
	public static final int  STRING_TYPE   =1;
	public static final int  SID_TYPE      =3;
	public static final int  GSID_TYPE     =6;
	public static final int  BOOL_TYPE     =8;
	public static final int  ARRAY_TYPE    =4;
	public static final int  CHILDS_TYPE   =5;


	public static final int  AVATAR_TYPE   =0x34; //INT
	public static final int  USERID_TYPE   =1;
	public static final int  AVATAR_NUMBER =0x1F;

	public static final int  VIDEO_INDEX   =0x93;

	public static final int  FILESIZE_TYPE =0x55;
	public static final int  ResolutionX_TYPE    =0x95;
	public static final int  ResolutionY_TYPE    =0x96;
	public static final int  Videoframes_TYPE    =0x97;
	public static final int  VideoFPS_TYPE       =0x98;
	public static final int  GameId_TYPE         =0x21;
	public static final int  Timestamp_TYPE      =0x50;
	public static final int  VIDEO_COMMENT       =0x54;
	public static final int  VIDEO_TITLE         =0x94;
	public static final int  CLANID_TYPE         =0x6C;
	public static final int  CLAN_NICKNAME_TYPE  =0x02;
	public static final int  CLAN_REALNAME_TYPE  =0x72;
	public static final int  CLANS_USERIDS_TYPE   =1;
	public static final int  MSG_OF_THEDAY       =0x2E;
	
	
	public static final int XFIRE_CLAN_PACKET = 158;
	public static final int XFIRE_RECVPREFSPACKET = 141;

	public static final int XFIRE_CLAN_BUDDYS_NAMES_ID = 159;
	public static final int XFIRE_CONTACT_STATUS_MSG = 154;

	public static final int XFIRE_VERSION_MISMATCH_ID = 134;
	public static final int XFIRE_RECV_IM_ID = 133;
	public static final int XFIRE_RECV_NICKNAMECHANGE_ID = 161;
	public static final int XFIRE_BUDDY_STATUS_ID = 0x84;
	public static final int XFIRE_LOGIN_FAILED_ID = 0x81;
	public static final int XFIRE_LOGIN_SUCCESS_ID = 130;
	public static final int XFIRE_PACKET_AUTH_ID = 0x80;
	public static final int XFIRE_PACKET_CONTACTS = 0x83;
	public static final int XFIRE_PACKET_CONTACTS_ONLINE = 0x82;
	public static final int DEF_XSOCKSTATUS_READINGHEADER = 11;
	public static final int DEF_XSOCKSTATUS_READINGBODY = 12;
	public static final int XFIRE_OBJECT_TYPE_ID = 0x01;
	public static final int DEF_MSGBUFFERSIZE = 0xFFFF;
	public static final int DEF_MSGFROM_XFIRESERVER = 5;
	public static final int DEF_MSGQUENESIZE = 256;
	private DataInputStream _in;
	private DataOutputStream _out;
	SocketConnection connection = null;

	private LoginScreen _screen;
	private ContactsScreen _contacts;
	private int _uStatus;
	private int _dwReadSize;
	private int _dwTotalReadSize;
	private byte[] _pRcvBuffer;
	private boolean _isThreadRunning;
	private boolean _forcequit;
	int _nIndex;
	static String _myNickname;// =new String();

	int m_iQueneHead;
	int m_iQueneTail;
	MsgQue[] m_pMsgQuene = new MsgQue[DEF_MSGQUENESIZE];

	Timer _timer = new Timer();

	static String s_img_url;
	static String s_redirect_url;
	static String s_metrics_url;
	static String s_ad_text;
	Timer _KAtimer = new Timer();
	private EventListener FriendsListener = null;

	
	
	
	
	int read_attribute(byte []Buffer,int offset,String name,int type,byte[] data)
	{


		int attb_len=name.length();
		if (Buffer[offset]!=attb_len ) return -1;
//|| memcmp(&Buffer[offset+1],name,attb_len)!=0
		offset++;
		offset+=attb_len;

		if (Buffer[offset]!=type) return -1;

		offset++;

		byte array_attribute_type;
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

				
				array_attribute_len = (0xFF & ((byte)Buffer[offset+1]) << 8) | (0xFF & ((byte)Buffer[offset]));  

				offset+=2;

				{

					int objects_count=array_attribute_len;


					int total_strings_size=0;
					int string_length=0;

				
	                int start_buffer_indx=offset;
					while(objects_count!=0){

						string_length = (0xFF & ((byte)Buffer[offset+1]) << 8) | (0xFF & ((byte)Buffer[offset]));  


						offset+=string_length+2;


						total_strings_size+=string_length+2;


						objects_count--;
					}



					if (data==null) return total_strings_size;
					if (total_strings_size!=0){
					System.arraycopy(Buffer,start_buffer_indx,data,0,total_strings_size);
					}

					break;

				}



			case INT_TYPE:
				
				array_attribute_len = (0xFF & ((byte)Buffer[offset+1]) << 8) | (0xFF & ((byte)Buffer[offset]));  

				offset+=2;
				if (data==null) return 4*array_attribute_len;

				System.arraycopy(Buffer,offset,data,0,4*array_attribute_len);

				offset+=4*array_attribute_len;

				break;

		
			case  SID_TYPE:
				
				
				
				
				array_attribute_len = (0xFF & ((byte)Buffer[offset+1]) << 8) | (0xFF & ((byte)Buffer[offset]));  

				offset+=2;
				
				if (data==null) return 16*array_attribute_len;
				
				System.arraycopy(Buffer,offset,data,0,16*array_attribute_len);
				
				offset+=16*array_attribute_len;

				break;

		

			default:
				break;
			}


			break;

		case STRING_TYPE:

				
			string_len = (0xFF & ((byte)Buffer[offset+1]) << 8) | (0xFF & ((byte)Buffer[offset]));  
			
			if (data==null) return string_len+2;
			//memcpy(data,&Buffer[offset],string_len+2);
			System.arraycopy(Buffer,offset,data,0,string_len+2);
			offset+=string_len+2;

			
			break;

		case GSID_TYPE:

		//	memcpy(data,&Buffer[offset],21);
			System.arraycopy(Buffer,offset,data,0,21);
			offset+=21;
			break;

		case SID_TYPE:

			//memcpy(data,&Buffer[offset],16);
			System.arraycopy(Buffer,offset,data,0,16);
			offset+=16;
			break;

		case INT_TYPE:

			//memcpy(data,&Buffer[offset],4);
			
			System.arraycopy(Buffer,offset,data,0,4);
			
			offset+=4;


			break;
		case CHILDS_TYPE:
			 data[0]=Buffer[offset];
			 offset+=1;

			break;

		default:
			offset=-1;
			break;
		}
		return offset;

	}

	int read_attribute_noname(byte []Buffer,int offset,int type,byte[] data)
	{

		int subtype;

		byte array_attribute_type;
		int array_attribute_len=0;
	   

		switch(Buffer[offset])
		{

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
		
		case CLAN_REALNAME_TYPE:
		case 2:
		case CLANID_TYPE:
		case FILESIZE_TYPE:
		case 4:
	
		case 0x0D:
		
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
					
						
					array_attribute_len = (0xFF & ((byte)Buffer[offset+1]) << 8) | (0xFF & ((byte)Buffer[offset]));  
					
					
					offset+=2;

					{

						int objects_count=array_attribute_len;


						int total_strings_size=0;
						int string_length=0;


					    int start_buffer_indx=offset;

						while(objects_count!=0){

							string_length = (0xFF & ((byte)Buffer[offset+total_strings_size+1]) << 8) | (0xFF & ((byte)Buffer[offset+total_strings_size]));  
							
					

							total_strings_size+=string_length+2;


							objects_count--;
						}



						if (data==null) return total_strings_size;

						if (total_strings_size!=0) {
						
							//memcpy(data,start_buffer,total_strings_size);
							System.arraycopy(Buffer,start_buffer_indx,data,0,total_strings_size);
							
						}
						
						return total_strings_size+offset;

						

					}
					
                   case  SID_TYPE:
					
					offset++;
					array_attribute_len = (0xFF & ((byte)Buffer[offset+1]) << 8) | (0xFF & ((byte)Buffer[offset]));  
						
					offset+=2;
					if (data==null) return 16*array_attribute_len;
					System.arraycopy(Buffer,offset,data,0,16*array_attribute_len);
					offset+=16*array_attribute_len;
					
					return offset;
 
				case INT_TYPE:
					offset++;
				//	memcpy(&array_attribute_len,&Buffer[offset],2);
					//System.arraycopy(Buffer,offset,array_attribute_len,0,2);
					
					array_attribute_len = (0xFF & ((byte)Buffer[offset+1]) << 8) | (0xFF & ((byte)Buffer[offset]));  
					
					
					offset+=2;
					
					if (data==null) return 4*array_attribute_len;

					//memcpy(data,&Buffer[offset],4*array_attribute_len);
					
					System.arraycopy(Buffer,offset,data,0,4*array_attribute_len);
					

					offset+=4*array_attribute_len;

					return offset;

				default:
					break;
				}


				break;


			case INT_TYPE:

				offset++;
				//memcpy(data,&Buffer[offset],4);
				System.arraycopy(Buffer,offset,data,0,4);
				
				
				offset+=4;
				return offset;

			case STRING_TYPE:

				{

					offset++;
					int string_length=0;
					
					string_length = (0xFF & ((byte)Buffer[offset+1]) << 8) | (0xFF & ((byte)Buffer[offset]));  
					
					
					if (data==null) return 2+string_length;

					
					System.arraycopy(Buffer,offset,data,0,2+string_length);
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
	// Constructor
	public ConnectThread() {

		_screen = ((iBlaze) UiApplication.getUiApplication()).getScreen();

		_contacts = ((iBlaze) UiApplication.getUiApplication())
				.allocContactsScreen();

		FriendsListener = _contacts;
		_contacts.init();

		_pRcvBuffer = new byte[DEF_MSGBUFFERSIZE];

		_uStatus = DEF_XSOCKSTATUS_READINGHEADER;

		_dwReadSize = 2;

		_dwTotalReadSize = 0;

		_isThreadRunning = true;
		_forcequit = false;

		m_iQueneHead = 0;
		m_iQueneTail = 0;

		int i;
		for (i = 0; i < DEF_MSGQUENESIZE; i++) {
			m_pMsgQuene[i] = null;
		}

		_nIndex = 0;

		_timer.schedule(new MsgTask(), 100, 100);
		///_KAtimer.schedule(new KeepAliveTask(), 0, 1000 * 240);

	}

	class KeepAliveTask extends TimerTask {
		public void run() {

			try {

				if (_out == null)
					return;

				System.out.println("sending KeepAliveTask");

				KeepAlive();

			}

			catch (Exception e) {
				System.err.println(e.toString());
			} finally {

			}

		}
	}

	public EventListener getFriendsEventListener() {

		return FriendsListener;
	}

	class MsgTask extends TimerTask {
		public void run() {

			while (bGetMsgQuene()) {

				// System.out.println("MsgTask TIMER");

			}

		}
	}

	boolean bGetMsgQuene() // /:(char*)pFrom Data:(char*)pData Size:(unsigned
	// short*)szMsgSize Index:(int*)pIndex
	// Key:(char*)pKey
	{

		if (m_pMsgQuene[m_iQueneHead] == null) {

			return false;

		}

		ParsePacket(m_pMsgQuene[m_iQueneHead].bGet_data());

		m_pMsgQuene[m_iQueneHead] = null;

		m_iQueneHead++;
		if (m_iQueneHead >= DEF_MSGQUENESIZE)
			m_iQueneHead = 0;

		return true;
	}

	boolean bPutMsgQuene(boolean isSending, byte[] pData, int szMsgSize) {

		if (m_pMsgQuene[m_iQueneTail] != null) {

			return false;

		}

		m_pMsgQuene[m_iQueneTail] = new MsgQue();

		int type = 0;

		if (isSending)
			type = 1;

		if (m_pMsgQuene[m_iQueneTail].bPut(type, pData, szMsgSize) == false) {

			return false;
		}

		m_iQueneTail++;
		if (m_iQueneTail >= DEF_MSGQUENESIZE)
			m_iQueneTail = 0;

		return true;

	}

	void HandleGameChanaged(byte[] pBuffer, int MsgSize) {

		int gameid;
		short usercount;

		int ptr = 0;

		ptr += 6;

		if (pBuffer[ptr + 0] == 's' && pBuffer[ptr + 1] == 'i'
				&& pBuffer[ptr + 2] == 'd') {

			ptr += 5;

			usercount = (short) pBuffer[(ptr + 1)]; // 16
			usercount <<= 8;
			usercount |= (short) (0xFF & pBuffer[(ptr)]); // 15

			ptr += 2;
			byte[] sid = new byte[16 * usercount];

			for (int k = 0; k < usercount; k++) {

				System.arraycopy(pBuffer, ptr, sid, k * 16, 16);
				ptr += 16;

			}

			ptr += 1;

			// 
			if (pBuffer[ptr + 0] == 'g' && pBuffer[ptr + 1] == 'a'
					&& pBuffer[ptr + 2] == 'm' && pBuffer[ptr + 3] == 'e'
					&& pBuffer[ptr + 4] == 'i' && pBuffer[ptr + 5] == 'd') {

				ptr += 8;

				short gameidscount;

				gameidscount = (short) pBuffer[(ptr + 1)]; // 16
				gameidscount <<= 8;
				gameidscount |= (short) (0xFF & pBuffer[(ptr)]); // 15

				ptr += 2;

				for (int i = 0; i < gameidscount; i++) {

					gameid = (int) pBuffer[(ptr + 3)] & 0xFF; // 16
					gameid <<= 8;
					gameid |= (int) (0xFF & pBuffer[(ptr + 2)]); // 15

					gameid <<= 8;
					gameid |= (int) (0xFF & pBuffer[(ptr + 1)]); // 15

					gameid <<= 8;
					gameid |= (int) (0xFF & pBuffer[(ptr)]); // 15

					byte[] usersid = new byte[16];

					System.arraycopy(sid, i * 16, usersid, 0, 16);

					getFriendsEventListener().friendGameStateChanged(usersid,
							gameid);

				}

			}

		}

	}

	void HandleStatusMessageChanaged(byte[] pBuffer, int MsgSize) {

		int ptr = 0;

		byte[] status_msg;// =new byte[0x100];

		ptr += 6;

		if (pBuffer[ptr + 0] == 's' && pBuffer[ptr + 1] == 'i'
				&& pBuffer[ptr + 2] == 'd') {

			ptr += 3;

			ptr += 2;

			short sids_count = (short) (pBuffer[ptr + 1] & 0xFF); // 16
			sids_count <<= 8;
			sids_count |= (short) (0xFF & pBuffer[(ptr)]); // 15

			byte[] sid = new byte[16 * sids_count];

			ptr += 2;

			for (int k = 0; k < sids_count; k++) {

				System.arraycopy(pBuffer, ptr, sid, k * 16, 16);

				ptr += 16;

			}

			ptr += 1;

			if (pBuffer[ptr + 0] == 'm' && pBuffer[ptr + 1] == 's'
					&& pBuffer[ptr + 2] == 'g') {

				ptr += 3;

				ptr += 2;

				short msgs_count = (short) (pBuffer[ptr + 1] & 0xFF); // 16
				msgs_count <<= 8;
				msgs_count |= (short) (0xFF & pBuffer[(ptr)]); // 15

				ptr += 2;

				for (int i = 0; i < msgs_count; i++) {

					short msg_len = (short) pBuffer[ptr + 1]; // 16
					msg_len <<= 8;
					msg_len |= (short) (0xFF & pBuffer[ptr]); // 15

					ptr += 2;

					status_msg = new byte[msg_len];

					System.arraycopy(pBuffer, ptr, status_msg, 0, msg_len);

					ptr += msg_len;

					byte[] usersid = new byte[16];

					System.arraycopy(sid, i * 16, usersid, 0, 16);

					if (msg_len == 0)
						continue;

					String smsg;
					try {

						smsg = new String(status_msg, "UTF-8");

						getFriendsEventListener().friendStatusChanged(usersid,
								smsg);

					} catch (UnsupportedEncodingException e) {

						e.printStackTrace();
					}

				}

			}

		}

	}

	private void HandleStatusChanaged(byte[] pBuffer, int MsgSize) {


		
		
		byte[] sid_zero = new byte[16];

		int ptr;
		ptr = 5;
		
		
		int users_id_buffersize=read_attribute_noname(pBuffer,ptr,ARRAY_TYPE,null);
		if (users_id_buffersize==-1){
			
			
			System.out
			.println("HandleBuddyStatus attribute userid not found");
			return;
		}
		
		byte []users_id_ptr= new byte[users_id_buffersize];
		
		ptr=read_attribute_noname(pBuffer,ptr,ARRAY_TYPE,users_id_ptr);
	
		
		int users_sid_buffersize=read_attribute_noname(pBuffer,ptr,3,null);
		if (users_sid_buffersize==-1){
			
			
			
			System.out
			.println("HandleBuddyStatus attribute usersid not found");
			return;
		}
		
		byte []users_sid_ptr= new byte[users_sid_buffersize];
		
		ptr=read_attribute_noname(pBuffer,ptr,3,users_sid_ptr);
		
	
		for (int t = 0; t < 16; t++) {

			sid_zero[t] = 0;

		}
		
		for (int i=0; i<users_sid_buffersize/16; i++){
			
			boolean bOnline=false;
			
			
			for (int t = 0; t < 16; t++) {
				
				if (users_sid_ptr[i+t] != 0) {

					bOnline = true;
					break;

				}

			}
			
			
			int dwUserID = (int) users_id_ptr[(i*4 + 3)] & 0xFF; // 16

			dwUserID <<= 8;
			dwUserID |= (int) (0xFF & users_id_ptr[(i*4 + 2)]); // 15

			dwUserID <<= 8;
			dwUserID |= (int) (0xFF & users_id_ptr[(i*4 + 1)]); // 15

			dwUserID <<= 8;
			dwUserID |= (int) (0xFF & users_id_ptr[(i*4)]); // 15
			
			
			XfireContact xcontact = null;
		//	xcontact = CoreService.getContactByID(dwUserID);
			
			
			xcontact=_contacts.getContactByID(dwUserID);
			
			
			
		

			if (xcontact == null) {

				System.out
						.println("call to get Clan memberrrrrr return NULL");

				return;

			}
			
			xcontact._imindex = 0;
			System.arraycopy(users_sid_ptr, i*16, xcontact._sid, 0, 16);

			if (bOnline==false) {

				
					
					getFriendsEventListener().Removefriend( dwUserID, "");
					

			} else {

				
					getFriendsEventListener().Addfriend(dwUserID, "", "");
					
				

			}

			
		
		}
		
		
		

	}

	private void HandleContacts(byte[] pBuffer, int MsgSize) {

		short uNumOfFriends, uFriendNameLength, uNumOfNicks, uNickNameLength, uNumOfUserID;

		short cp = 6;

		if (pBuffer[cp] == 'f' && pBuffer[cp + 1] == 'r'
				&& pBuffer[cp + 2] == 'i' && pBuffer[cp + 3] == 'e'
				&& pBuffer[cp + 4] == 'n' && pBuffer[cp + 5] == 'd'
				&& pBuffer[cp + 6] == 's') {

			cp += 7;

			uNumOfFriends = (short) (pBuffer[cp + 3] & 0xFF); // 16
			uNumOfFriends <<= 8;
			uNumOfFriends |= (short) (0xFF & pBuffer[cp + 2]); // 15

			_contacts._nTotalContacts = uNumOfFriends;

			cp += 2;
			short i = 0;

			for (i = 0; i < uNumOfFriends; i++) {

				short ptr = (short) ((i + 1) * 2 + cp);

				uFriendNameLength = (short) pBuffer[(ptr + 1)]; // 18
				uFriendNameLength <<= 8;
				uFriendNameLength |= (short) (0xFF & pBuffer[(ptr)]); // 17

				byte[] cFriend = new byte[uFriendNameLength];

				for (short t = 0; t < uFriendNameLength; t++) {

					cFriend[t] = pBuffer[ptr + 2 + t];

				}

				_contacts._listContacts.addElement(new XfireContact());

				XfireContact xcontact = (XfireContact) _contacts._listContacts
						.elementAt(i);

				xcontact._cNickname = null;

				xcontact._cUsername = new byte[uFriendNameLength];

				System.arraycopy(cFriend, 0, xcontact._cUsername, 0,
						uFriendNameLength);

				_contacts._listContacts.setElementAt(xcontact, i);

				cp += uFriendNameLength;

			}

			cp += ((i + 1) * 2);

			cp += 1;

			if (pBuffer[cp] == 'n' && pBuffer[cp + 1] == 'i'
					&& pBuffer[cp + 2] == 'c' && pBuffer[cp + 3] == 'k') {

				cp += 4;

				cp += 2;

				uNumOfNicks = (short) (pBuffer[(cp + 1)] & 0xFF); // 16
				uNumOfNicks <<= 8;
				uNumOfNicks |= (short) (0xFF & pBuffer[cp]); // 15

				cp += 2;

				for (i = 0; i < uNumOfNicks; i++) {

					short ptr = (short) (i * 2 + cp);

					uNickNameLength = (short) ((short) pBuffer[ptr + 1] & 0xFF); // 18
					uNickNameLength <<= 8;
					uNickNameLength |= (short) (0xFF & pBuffer[ptr]); // 17

					byte[] nickname = new byte[uNickNameLength];

					for (short t = 0; t < uNickNameLength; t++) {

						nickname[t] = (byte) pBuffer[ptr + 2 + t];

					}
					XfireContact xcontact = (XfireContact) _contacts._listContacts
							.elementAt(i);

					if (uNickNameLength != 0) {

						xcontact._cNickname = new byte[uNickNameLength];

						System.arraycopy(nickname, 0, xcontact._cNickname, 0,
								uNickNameLength);
					} else {

						xcontact._cNickname = new byte[xcontact._cUsername.length];

						System.arraycopy(new String(xcontact._cUsername)
								.getBytes(), 0, xcontact._cNickname, 0,
								xcontact._cUsername.length);

					}

					_contacts._listContacts.setElementAt(xcontact, i);

					cp += uNickNameLength;

				}

				cp += i * 2;

				cp += 1;

				if (pBuffer[cp + 0] == 'u' && pBuffer[cp + 1] == 's'
						&& pBuffer[cp + 2] == 'e' && pBuffer[cp + 3] == 'r'
						&& pBuffer[cp + 4] == 'i' && pBuffer[cp + 5] == 'd') {

					cp += 6;

					cp += 2;

					uNumOfUserID = (short) pBuffer[(cp + 1)]; // 16
					uNumOfUserID <<= 8;
					uNumOfUserID |= (short) (0xFF & pBuffer[(cp)]); // 15

					cp += 2;

					for (i = 0; i < uNumOfUserID; i++) {

						int dwUserID = (int) pBuffer[(cp + 3)] & 0xFF; // 16

						dwUserID <<= 8;
						dwUserID |= (int) (0xFF & pBuffer[(cp + 2)]); // 15

						dwUserID <<= 8;
						dwUserID |= (int) (0xFF & pBuffer[(cp + 1)]); // 15

						dwUserID <<= 8;
						dwUserID |= (int) (0xFF & pBuffer[(cp)]); // 15

						XfireContact xcontact = (XfireContact) _contacts._listContacts
								.elementAt(i);

						xcontact._userid = dwUserID;
						xcontact._uStatus = 0;
						_contacts._listContacts.setElementAt(xcontact, i);

						cp += 4;

					}

				}

			}

		}

	}

	private void HandleMismatchVersion(byte[] pBuffer, int MsgSize)
			throws IOException

	{

		byte[] version = { 0x12, 0x00, 0x03, 0x00, 0x01, 0x07, 0x76, 0x65,
				0x72, 0x73, 0x69, 0x6f, 0x6e, // version
				0x02, 0x00, 0x00, // 1.87
				0x00, 0x00 };

		// cp+=2;

		char[] version_type = new char[8];
		StringBuffer stringBuffer = new StringBuffer(new String(pBuffer));
		stringBuffer.getChars(6, 14, version_type, 0);

		if (version_type[0] == 'v' && version_type[1] == 'e'
				&& version_type[2] == 'r' && version_type[3] == 's'
				&& version_type[4] == 'i' && version_type[5] == 'o'
				&& version_type[6] == 'n') {

			version[14] = pBuffer[6 + 7 + 4];

			_out.write(version, 0, version.length);
			_out.flush();

		}

	}

	private void Login() throws IOException {

		byte[] uat = { 0x55, 0x41, 0x30, 0x31 };

		byte[] version = { 0x12, 0x00, 0x03, 0x00, 0x01, 0x07, 0x76, 0x65,
				0x72, 0x73, 0x69, 0x6f, 0x6e, // version
				0x02, 0x57, 0x00, // 1.87
				0x00, 0x00 };

		_out.write(uat, 0, 4);
		_out.write(version, 0, 18);
		_out.flush();

	}

	void quit() {

		_forcequit = true;
		try {
			_in.close();
			_out.close();
			connection.close();
		} catch (IOException e) {
			System.err.println(e.toString());
		}
		_isThreadRunning = false;
	}

	String cryptPassword(String username, String password, char[] salt) {

		String result = new String();

		String code = username + password + "UltimateArena";

		result = SHA1.calcSHA1(code);

		char[] saltcode = new char[40];

		System.arraycopy(salt, 0, saltcode, 0, 40);

		result += new String(saltcode);

		result = SHA1.calcSHA1(result);

		return result;

	}

	void sendIMPacket(byte[] pSid, char[] pBuffer) throws IOException {

		StringBuffer stringBuffer = new StringBuffer(new String(pBuffer));
		byte[] pkt = new byte[0x400];

		int ptr = 2;
		pkt[ptr++] = 2; // packet id
		pkt[ptr++] = 0;
		pkt[ptr++] = 2; // attrib number

		// SID
		pkt[ptr++] = 3;
		pkt[ptr++] = 's';
		pkt[ptr++] = 'i';
		pkt[ptr++] = 'd';
		pkt[ptr++] = 3;

		System.arraycopy(pSid, 0, pkt, ptr, 16);
		ptr += 16;

		// PEERMSG
		pkt[ptr++] = 7;
		pkt[ptr++] = 'p';
		pkt[ptr++] = 'e';
		pkt[ptr++] = 'e';
		pkt[ptr++] = 'r';
		pkt[ptr++] = 'm';
		pkt[ptr++] = 's';
		pkt[ptr++] = 'g';

		pkt[ptr++] = 5;
		pkt[ptr++] = 3;

		// /MSGTYPE
		pkt[ptr++] = 7;

		pkt[ptr++] = 'm';
		pkt[ptr++] = 's';
		pkt[ptr++] = 'g';
		pkt[ptr++] = 't';
		pkt[ptr++] = 'y';
		pkt[ptr++] = 'p';
		pkt[ptr++] = 'e';

		pkt[ptr++] = 2;

		pkt[ptr++] = 0;
		pkt[ptr++] = 0;
		pkt[ptr++] = 0;
		pkt[ptr++] = 0;

		// IMINDEX
		pkt[ptr++] = 7;
		pkt[ptr++] = 'i';
		pkt[ptr++] = 'm';
		pkt[ptr++] = 'i';
		pkt[ptr++] = 'n';
		pkt[ptr++] = 'd';
		pkt[ptr++] = 'e';
		pkt[ptr++] = 'x';

		pkt[ptr++] = 2;

		XfireContact xcontact = _contacts.getContactBySID(pSid);

		if (xcontact == null) {

			xcontact = _contacts.getClanMemberBySID(pSid);
		}

		if (xcontact == null) {

			System.out.println("No contact was found sending msg failed");
			return;

		}

		xcontact._imindex++;

		int imindex = xcontact._imindex;

		pkt[ptr++] = (byte) (imindex >> 0 & 0xFF);
		pkt[ptr++] = (byte) ((imindex >> 8) & 0xFF);
		pkt[ptr++] = (byte) ((imindex >> 16) & 0xFF);
		;
		pkt[ptr++] = (byte) ((imindex >> 24) & 0xFF);
		;

		pkt[ptr++] = 2;

		pkt[ptr++] = 'i';
		pkt[ptr++] = 'm';

		pkt[ptr++] = 1;
		int msg_len = pBuffer.length;
		pkt[ptr++] = (byte) (msg_len >> 0 & 0xFF);
		pkt[ptr++] = (byte) ((msg_len >> 8) & 0xFF);

		System.arraycopy(stringBuffer.toString().getBytes(), 0, pkt, ptr,
				pBuffer.length);

		ptr += pBuffer.length;

		msg_len = ptr;
		pkt[0] = (byte) (msg_len >> 0 & 0xFF);
		pkt[1] = (byte) ((msg_len >> 8) & 0xFF);

		_out.write(pkt, 0, ptr);
		_out.flush();

	}

	void HandleMessage(byte[] pBuffer, int MsgSize) throws IOException {

		byte[] output = new byte[0x100];
		byte[] cMsg;
		byte[] sid = new byte[16];
		int msgtype;

		int imIndex;

		int ptr = 0;

		ptr += 6;

		if (pBuffer[ptr + 0] == 's' && pBuffer[ptr + 1] == 'i'
				&& pBuffer[ptr + 2] == 'd') {

			ptr += 3;
			ptr += 1;

			System.arraycopy(pBuffer, ptr, sid, 0, 16);

			ptr += 16;

			ptr += 1;

			/* get peer message */
			if (pBuffer[ptr + 0] == 'p' && pBuffer[ptr + 1] == 'e'
					&& pBuffer[ptr + 2] == 'e' && pBuffer[ptr + 3] == 'r'
					&& pBuffer[ptr + 4] == 'm' && pBuffer[ptr + 5] == 's'
					&& pBuffer[ptr + 6] == 'g') {

				ptr += 7;

				ptr += 1;

				ptr += 2;

				if (pBuffer[ptr + 0] == 'm' && pBuffer[ptr + 1] == 's'
						&& pBuffer[ptr + 2] == 'g' && pBuffer[ptr + 3] == 't'
						&& pBuffer[ptr + 4] == 'y' && pBuffer[ptr + 5] == 'p'
						&& pBuffer[ptr + 6] == 'e') {

					ptr += 7;// "strlen("msgtype_type")

					ptr += 1;

					msgtype = (int) pBuffer[(ptr + 3)] & 0xFF; // 16

					msgtype <<= 8;
					msgtype |= (int) (0xFF & pBuffer[(ptr + 2)]); // 15

					msgtype <<= 8;
					msgtype |= (int) (0xFF & pBuffer[(ptr + 1)]); // 15

					msgtype <<= 8;
					msgtype |= (int) (0xFF & pBuffer[(ptr + 0)]); // 15

					if (msgtype == 3) {

						getFriendsEventListener().switchToTypingMode();
						return;
					}

					if (msgtype == 0) {// IM MSG

						ptr += 4;

						ptr += 1;

						if (pBuffer[ptr + 0] == 'i' && pBuffer[ptr + 1] == 'm'
								&& pBuffer[ptr + 2] == 'i'
								&& pBuffer[ptr + 3] == 'n'
								&& pBuffer[ptr + 4] == 'd'
								&& pBuffer[ptr + 5] == 'e'
								&& pBuffer[ptr + 6] == 'x') {

							ptr += 7;

							ptr += 1;

							imIndex = (int) pBuffer[(ptr + 3)] & 0xFF; // 16

							imIndex <<= 8;
							imIndex |= (int) (0xFF & pBuffer[(ptr + 2)]); // 15

							imIndex <<= 8;
							imIndex |= (int) (0xFF & pBuffer[(ptr + 1)]); // 15

							imIndex <<= 8;
							imIndex |= (int) (0xFF & pBuffer[(ptr)]); // 15

							ptr += 4;

							ptr += 1;

							if (pBuffer[ptr + 0] == 'i'
									&& pBuffer[ptr + 1] == 'm') {

								ptr += 2;
								ptr += 1;

								short msg_len = (short) pBuffer[(ptr + 1)]; // 16
								msg_len <<= 8;
								msg_len |= (short) (0xFF & pBuffer[(ptr)]); // 15

								ptr += 2;

								cMsg = new byte[msg_len];

								System
										.arraycopy(pBuffer, ptr, cMsg, 0,
												msg_len);

								getFriendsEventListener().messageReceived(sid,
										"", new String(cMsg, "UTF-8"), false);

								XfireContact xcontact = _contacts
										.getContactBySID(sid);

								xcontact._imindex = imIndex;

								System.arraycopy(pBuffer, 0, output, 0, 62);

								output[0] = 62;
								output[1] = 0;
								output[2] = 2;
								output[3] = 0;

								output[35] = 0x02;
								output[45] = 0x01;

								_out.write(output, 0, 62);
								_out.flush();

							}

						}

					}

				}

			}

		}

	}

	void sendAddContactPacket(char[] pBuddyName) throws IOException {

		byte[] pkt = new byte[200];
		int ptr = 0;

		ptr += 2;

		pkt[ptr++] = 6;
		pkt[ptr++] = 0;
		pkt[ptr++] = 2;

		pkt[ptr++] = 4;
		pkt[ptr++] = 'n';
		pkt[ptr++] = 'a';
		pkt[ptr++] = 'm';
		pkt[ptr++] = 'e';

		pkt[ptr++] = 0x01;

		pkt[ptr++] = (byte) pBuddyName.length;

		pkt[ptr++] = 0;

		System.arraycopy(pBuddyName, 0, pkt, ptr, pBuddyName.length);
		ptr += pBuddyName.length;

		pkt[ptr++] = 3;// strlen(msg)

		pkt[ptr++] = 'm';
		pkt[ptr++] = 's';
		pkt[ptr++] = 'g';

		pkt[ptr++] = 1;
		pkt[ptr++] = 0;
		pkt[ptr++] = 0;

		pkt[0] = (byte) ptr;
		pkt[1] = 0x00;

		_out.write(pkt, 0, ptr);
		_out.flush();

	}

	void sendMyStatusMessagePacket(char[] pStatusMsg) throws IOException {

		byte[] cMyStatusPkt = new byte[0x100];

		int ptr = 2;

		StringBuffer stringBuffer = new StringBuffer(new String(pStatusMsg));

		cMyStatusPkt[ptr++] = 0x20;
		cMyStatusPkt[ptr++] = 0x00;

		cMyStatusPkt[ptr++] = 0x01;

		cMyStatusPkt[ptr++] = 0x2E;
		cMyStatusPkt[ptr++] = 0x01;

		cMyStatusPkt[ptr++] = (byte) pStatusMsg.length;
		cMyStatusPkt[ptr++] = 0x00;

		System.arraycopy(stringBuffer.toString().getBytes(), 0, cMyStatusPkt,
				ptr, pStatusMsg.length);

		ptr += pStatusMsg.length;

		cMyStatusPkt[0] = (byte) (pStatusMsg.length + 9);
		cMyStatusPkt[1] = 0x00;

		_out.write(cMyStatusPkt, 0, (pStatusMsg.length + 9));
		_out.flush();

	}

	void HandleClansContacts(byte[] pBuffer, int MsgSize) {

		int ptr = 0;

		if (_contacts._nTotalClans > 10)
			return;
		ptr += 7;

		int clanID = (int) pBuffer[(ptr + 3)] & 0xFF; // 16

		clanID <<= 8;
		clanID |= (int) (0xFF & pBuffer[(ptr + 2)]); // 15

		clanID <<= 8;
		clanID |= (int) (0xFF & pBuffer[(ptr + 1)]); // 15

		clanID <<= 8;
		clanID |= (int) (0xFF & pBuffer[(ptr)]); // 15

		int nClanIndex = _contacts.getClanIndexByID(clanID);

		if (nClanIndex == -1)
			return;

		ptr += 4;

		ptr += 3;

		short clan_friends_count = (short) pBuffer[(ptr + 1)]; // 16
		clan_friends_count <<= 8;
		clan_friends_count |= (short) (0xFF & pBuffer[(ptr)]); // 15

		_contacts._ClansList[nClanIndex]._usercount = clan_friends_count;

		_contacts._ClansList[nClanIndex]._listContacts.removeAllElements();
		ptr += 2;

		int userid;
		for (int i = 0; i < clan_friends_count; i++) {

			userid = (int) pBuffer[(ptr + 3)] & 0xFF; // 16

			userid <<= 8;
			userid |= (int) (0xFF & pBuffer[(ptr + 2)]); // 15

			userid <<= 8;
			userid |= (int) (0xFF & pBuffer[(ptr + 1)]); // 15

			userid <<= 8;
			userid |= (int) (0xFF & pBuffer[(ptr)]); // 15

			ptr += 4;

			_contacts._ClansList[nClanIndex]._listContacts
					.addElement(new XfireContact());

			XfireContact xcontact = (XfireContact) _contacts._ClansList[nClanIndex]._listContacts
					.elementAt(i);

			xcontact._userid = userid;

			_contacts._ClansList[nClanIndex]._listContacts.setElementAt(
					xcontact, i);

		}

		ptr += 5;

		byte[] cUsername = new byte[0x100];

		for (int i = 0; i < clan_friends_count; i++) {

			for (int j = 0; j < 0x100; j++) {

				cUsername[j] = 0;

			}

			short nUserLen = (short) pBuffer[(ptr + 1)]; // 16
			nUserLen <<= 8;
			nUserLen |= (short) (0xFF & pBuffer[(ptr)]); // 15

			ptr += 2;

			System.arraycopy(pBuffer, ptr, cUsername, 0, nUserLen);

			XfireContact xcontact = (XfireContact) _contacts._ClansList[nClanIndex]._listContacts
					.elementAt(i);

			xcontact._cUsername = new byte[nUserLen + 1];
			System.arraycopy(cUsername, 0, xcontact._cUsername, 0, nUserLen);

			_contacts._ClansList[nClanIndex]._listContacts.setElementAt(
					xcontact, i);
			ptr += nUserLen;

		}

		ptr += 5;

		byte[] cNickname = new byte[0x100];

		for (int i = 0; i < clan_friends_count; i++) {

			for (int j = 0; j < 0x100; j++) {
				cNickname[j] = 0;
			}

			short nNickLen = (short) pBuffer[(ptr + 1)]; // 16
			nNickLen <<= 8;
			nNickLen |= (short) (0xFF & pBuffer[(ptr)]); // 15

			ptr += 2;

			System.arraycopy(pBuffer, ptr, cNickname, 0, nNickLen);

			XfireContact xcontact = (XfireContact) _contacts._ClansList[nClanIndex]._listContacts
					.elementAt(i);

			xcontact._cNickname = new byte[nNickLen + 1];
			if (nNickLen == 0)
				xcontact._cNickname[0] = 0;
			System.arraycopy(cNickname, 0, xcontact._cNickname, 0, nNickLen);

			_contacts._ClansList[nClanIndex]._listContacts.setElementAt(
					xcontact, i);
			ptr += nNickLen;

		}

	}

	void HandleClans(byte[] pBuffer, int MsgSize) {

		int ptr = 0;

		ptr += 5;

		short clan_count = (short) pBuffer[(ptr + 4)]; // 16
		clan_count <<= 8;
		clan_count |= (short) (0xFF & pBuffer[(ptr + 3)]); // 15

		_contacts._nTotalClans = clan_count;

		if (_contacts._nTotalClans > 10)
			return;

		int i;

		for (i = 0; i < clan_count; i++) {
			_contacts._ClansList[i] = new XfireClan();
			_contacts._ClansList[i]._listContacts.removeAllElements();
		}

		ptr = ptr + 5;

		for (i = 0; i < clan_count; i++) {

			int clanID = (int) pBuffer[(ptr + 3)] & 0xFF; // 16

			clanID <<= 8;
			clanID |= (int) (0xFF & pBuffer[(ptr + 2)]); // 15

			clanID <<= 8;
			clanID |= (int) (0xFF & pBuffer[(ptr + 1)]); // 15

			clanID <<= 8;
			clanID |= (int) (0xFF & pBuffer[(ptr)]); // 15

			_contacts._ClansList[i]._id = clanID;

			ptr += 4;

		}
		ptr += 5;

		byte[] cClanName = new byte[0x100];

		for (i = 0; i < clan_count; i++) {

			for (int j = 0; j < 0x100; j++) {

				cClanName[j] = 0;

			}

			short clan_name_len = (short) pBuffer[(ptr + 1)]; // 16
			clan_name_len <<= 8;
			clan_name_len |= (short) (0xFF & pBuffer[(ptr)]); // 15

			ptr += 2;

			System.arraycopy(pBuffer, ptr, cClanName, 0, clan_name_len);

			System.arraycopy(cClanName, 0, _contacts._ClansList[i]._name, 0,
					clan_name_len);

			ptr += clan_name_len;

			getFriendsEventListener().addClanGroup(_contacts._ClansList[i]._id);

		}

		System.out.println("Leave handleClansPacket");

		ptr += 5;

	}

	public void KeepAlive() throws Exception {

		byte[] pkt = new byte[0x100];
		int ptr = 0;

		ptr += 2;

		pkt[ptr++] = 13;
		pkt[ptr++] = 0;
		pkt[ptr++] = 2;

		pkt[ptr++] = 0x05;
		pkt[ptr++] = 'v';
		pkt[ptr++] = 'a';
		pkt[ptr++] = 'l';
		pkt[ptr++] = 'u';
		pkt[ptr++] = 'e';

		pkt[ptr++] = 0x02;
		pkt[ptr++] = 0x00;
		pkt[ptr++] = 0x00;
		pkt[ptr++] = 0x00;
		pkt[ptr++] = 0x00;

		pkt[ptr++] = 0x05;
		pkt[ptr++] = 's';
		pkt[ptr++] = 't';
		pkt[ptr++] = 'a';
		pkt[ptr++] = 't';
		pkt[ptr++] = 's';

		pkt[ptr++] = 0x04;
		pkt[ptr++] = 0x02;
		pkt[ptr++] = 0x00;
		pkt[ptr++] = 0x00;

		pkt[0] = (byte) ptr;
		pkt[1] = 0x00;

		if (_out != null) {

			_out.write(pkt, 0, ptr);
			_out.flush();
		}

	}

	/*
	 * private void ModifyNick(String nickname) throws Exception
	 * 
	 * {
	 * 
	 * byte[] cPkt = new byte[0x100]; int ptr = 0; ptr += 2;
	 * 
	 * cPkt[ptr++] = 0x0E; cPkt[ptr++] = 0x00; cPkt[ptr++] = 0x01; cPkt[ptr++] =
	 * 0x04;
	 * 
	 * cPkt[ptr++] = 'n'; cPkt[ptr++] = 'i'; cPkt[ptr++] = 'c'; cPkt[ptr++] =
	 * 'k';
	 * 
	 * cPkt[ptr++] = 0x01;
	 * 
	 * cPkt[ptr++] = (byte) (nickname.length());
	 * 
	 * cPkt[ptr++] = 0;
	 * 
	 * System.arraycopy(nickname.getBytes(), 0, cPkt, ptr, nickname.length());
	 * 
	 * ptr += (byte) (nickname.length()); cPkt[0] = (byte) ptr; cPkt[1] = 0x00;
	 * 
	 * _out.write(cPkt, 0, ptr); _out.flush();
	 * 
	 * }
	 */

	private void OnSuccessLogin(byte[] pBuffer, int MsgSize) {

		System.out.println("Enter OnSuccessLogin");
		int ptr = 0;

		ptr += 5; // header

		ptr += 7; // "userid"

		ptr += 4;

		ptr += 5; // sid

		ptr += 18;

		byte[] cNickname = new byte[0x100];

		for (int j = 0; j < 0x100; j++)
			cNickname[j] = 0;

		_myNickname = "Me";

		if (pBuffer[ptr] == 'n' && pBuffer[ptr + 1] == 'i'
				&& pBuffer[ptr + 2] == 'c' && pBuffer[ptr + 3] == 'k') {

			ptr += 4;

			ptr += 1;

			short nUserLen = (short) pBuffer[(ptr + 1)]; // 16
			nUserLen <<= 8;
			nUserLen |= (short) (0xFF & pBuffer[(ptr)]); // 15

			ptr += 2;

			System.arraycopy(pBuffer, ptr, cNickname, 0, nUserLen);

			System.out.println("NICK FOUND  cNickname= "
					+ new String(cNickname, 0, nUserLen));

			_myNickname = new String(cNickname, 0, nUserLen);

		}

		ptr += 5;

	}

	void HandleAuth(byte[] pBuffer, int MsgSize) throws IOException {

		char[] salt = new char[5];

		// 2 bytes length
		// 1 byte type
		// 2 byte length

		StringBuffer stringBuffer = new StringBuffer(new String(pBuffer));
		stringBuffer.getChars(6, 11, salt, 0);

		byte[] cPacket = new byte[0x400];

		if (salt[0] == 's' && salt[1] == 'a' && salt[2] == 'l'
				&& salt[3] == 't') {

			char[] saltcode = new char[41];

			stringBuffer.getChars(13, 54, saltcode, 0);

			cPacket[0] = (byte) (_screen.getUsername().length() + 0x61);
			cPacket[1] = 0x00;
			cPacket[2] = 0x01;
			cPacket[3] = 0x00;
			cPacket[4] = 0x03;
			cPacket[5] = 0x04;

			byte[] name = { 'n', 'a', 'm', 'e' };

			System.arraycopy(name, 0, cPacket, 6, 4);

			cPacket[10] = 0x01;

			cPacket[11] = (byte) (_screen.getUsername().length());

			cPacket[12] = 0;

			System.arraycopy(_screen.getUsername().getBytes(), 0, cPacket, 13,
					_screen.getUsername().length());

			cPacket[12 + _screen.getUsername().length() + 1] = 0x08;

			byte[] password = { 'p', 'a', 's', 's', 'w', 'o', 'r', 'd' };

			System.arraycopy(password, 0, cPacket, 12 + _screen.getUsername()
					.length() + 2, 8);

			cPacket[12 + _screen.getUsername().length() + 2 + 8] = 0x01;
			cPacket[12 + _screen.getUsername().length() + 2 + 8 + 1] = 0x28;
			cPacket[12 + _screen.getUsername().length() + 2 + 8 + 1 + 1] = 0x00;

			String cryptPass = cryptPassword(_screen.getUsername(), _screen
					.getPassword(), saltcode);

			System.arraycopy(cryptPass.getBytes(), 0, cPacket, 12
					+ _screen.getUsername().length() + 2 + 8 + 1 + 1 + 1, 40);

			_out.write(cPacket, 0, (_screen.getUsername().length() + 0x61));
			_out.flush();

		}

	}

	private void ParsePacket(byte[] pBuffer) {

		int dwMsgSize;

		int ptr = 0;

		dwMsgSize = (0xFF & ((byte) pBuffer[1]) << 8)
				| (0xFF & ((byte) pBuffer[0]));

		short cPacketID = (short) pBuffer[ptr + 3]; // 16
		cPacketID <<= 8;
		cPacketID |= (short) (0xFF & pBuffer[ptr + 2]);

		if (cPacketID == XFIRE_VERSION_MISMATCH_ID) {

			try {

				HandleMismatchVersion(pBuffer, dwMsgSize);

			} catch (IOException e) {

			}

			return;

		}

		if (cPacketID == 135) {

			HandleGameChanaged(pBuffer, dwMsgSize);
			return;
		}

		if (cPacketID == XFIRE_CONTACT_STATUS_MSG) {

			HandleStatusMessageChanaged(pBuffer, dwMsgSize);

			return;

		}

		if (cPacketID == XFIRE_CLAN_PACKET) {

			HandleClans(pBuffer, dwMsgSize);
			return;

		}

		if (cPacketID == XFIRE_CLAN_BUDDYS_NAMES_ID) {

			HandleClansContacts(pBuffer, dwMsgSize);
			return;
		}
		if (cPacketID == XFIRE_LOGIN_SUCCESS_ID) {

			OnSuccessLogin(pBuffer, dwMsgSize);

			_screen.showContacts();
			return;

		}

		if (cPacketID == 144) {

			System.out.println("PONG PONG POOOOOOOOOOOOOOOOOONG");

			try {
				KeepAlive();
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		//	ConnectThread
			//		.get_ad("http://cus.adwhirl.com/custom.php?appid=c9cdeb0f2be24227b24992bf401db791&uuid=00000000000000000000000000000000&country_code=en_US&appver=200&client=4");

		}

		if (cPacketID == 145) {

			_isThreadRunning = false;
			// _screen.LoggedOnDifferentMachine();

			getFriendsEventListener()
					.connectionError(
							"You were logged off because you logged in on a different computer.");
			System.out.println("ERROR: someone is online with our account");
			return;
		}

		if (cPacketID == XFIRE_LOGIN_FAILED_ID) {

			_isThreadRunning = false;

			System.out.println("XFIRE_LOGIN_FAILED_ID");

			getFriendsEventListener()
					.connectionError(
							"Your Xfire Name and password were not recongnised.\nPlease try again.");
			// _screen.OnLoginFailed();
			return;

		}

		if (cPacketID == XFIRE_BUDDY_STATUS_ID) {

			System.out.println("XFIRE_BUDDY_STATUS_ID");

			HandleStatusChanaged(pBuffer, dwMsgSize);
			return;

		}

		if (cPacketID == XFIRE_PACKET_CONTACTS) {

			HandleContacts(pBuffer, dwMsgSize);
			return;

		}

		if (cPacketID == XFIRE_RECV_IM_ID) {
			try {

				HandleMessage(pBuffer, dwMsgSize);

			} catch (IOException e) {

				System.out.println("XFIRE_RECV_IM_ID ERROR");
				System.err.println(e.toString());
			}
			return;
		}
		if (cPacketID == XFIRE_PACKET_AUTH_ID) {

			try {

				HandleAuth(pBuffer, dwMsgSize);

			} catch (IOException e) {

				System.err.println(e.toString());

			}

			return;
		}

	}

	private void onread() throws IOException {

		// if (!_in.ready()) return;

		if (_uStatus == DEF_XSOCKSTATUS_READINGHEADER) {

			int nBytesRead = _in.read(_pRcvBuffer, _dwTotalReadSize,
					_dwReadSize);

			if (nBytesRead == -1)
				return;

			_dwReadSize -= nBytesRead;
			_dwTotalReadSize += nBytesRead;

			if (_dwReadSize == 0) {

				_uStatus = DEF_XSOCKSTATUS_READINGBODY;

				int wp = 0;// (0xFF & ((byte)_pRcvBuffer[1]) << 8) | (0xFF &
				// ((byte)_pRcvBuffer[0]));

				wp = _pRcvBuffer[1];
				wp <<= 8;

				wp |= (0xFF & ((byte) _pRcvBuffer[0]));

				_dwReadSize = wp - 2;

				if (_dwReadSize == 0) {

					_uStatus = DEF_XSOCKSTATUS_READINGHEADER;
					_dwReadSize = 2;
					_dwTotalReadSize = 0;

				}
			}
		}

		if (_uStatus == DEF_XSOCKSTATUS_READINGBODY) {

			int nBytesRead = _in.read(_pRcvBuffer, _dwTotalReadSize,
					_dwReadSize);

			if (nBytesRead == -1)
				return;

			_dwReadSize -= nBytesRead;
			_dwTotalReadSize += nBytesRead;

			if (_dwReadSize == 0) {

				bPutMsgQuene(false, _pRcvBuffer, _dwTotalReadSize + 2);
				_dwReadSize = 2;
				_dwTotalReadSize = 0;

				_uStatus = DEF_XSOCKSTATUS_READINGHEADER;

			}

			return;
		}

	}
/*
	static public void SendMetricImpressionsNotificatio() {

		HttpConnection conn = null;

		String url = "http://met.adwhirl.com/exmet.php?appid=c9cdeb0f2be24227b24992bf401db791&type=9&nid=b390f1f6a43945d8852c72f1a8fa0352&uuid=00000000000000000000000000000000&country_code=en_US&appver=200&client=5";

		try

		{
			url = url + Utility.getConnectionString();
			conn = (HttpConnection) Connector.open(url);
			conn.setRequestMethod(HttpConnection.GET);
			conn.setRequestProperty("User-Agent",
					"Profile/MIDP-2.0 Configuration/CLDC-1.0");

			// Getting the response code will open the connection,
			// send the request, and read the HTTP response headers.
			// The headers are stored until requested.

//			int rc = conn.getResponseCode();
			if (rc != HttpConnection.HTTP_OK) {
				System.out.println("HTTP response code: " + rc);
				throw new IOException("HTTP response code: " + rc);
			}

			System.out.println("SendMetricImpressionsNotificatio OK");

		} catch (IOException e1) {

			if (conn != null)
				try {
					conn.close();
					conn = null;
				} catch (Exception e) {
				}

		} finally {

			if (conn != null)
				try {
					conn.close();
				} catch (Exception e) {
				}

		}

		return;
	}

	static public void SendMetricClickNotification() {

		HttpConnection conn = null;

		String url = "http://met.adwhirl.com/exclick.php?appid=c9cdeb0f2be24227b24992bf401db791&type=9&nid=b390f1f6a43945d8852c72f1a8fa0352&&uuid=00000000000000000000000000000000&country_code=en_US&appver=200&client=5";

		try

		{
			url = url + Utility.getConnectionString();
			conn = (HttpConnection) Connector.open(url);
			conn.setRequestMethod(HttpConnection.GET);
			conn.setRequestProperty("User-Agent",
					"Profile/MIDP-2.0 Configuration/CLDC-1.0");

			// Getting the response code will open the connection,
			// send the request, and read the HTTP response headers.
			// The headers are stored until requested.

			int rc = conn.getResponseCode();
			if (rc != HttpConnection.HTTP_OK) {

				System.out.println("HTTP response code: " + rc);

				throw new IOException("HTTP response code: " + rc);
			}

			System.out.println("SendMetricClickNotification OK");

		} catch (IOException e1) {

			if (conn != null)
				try {
					conn.close();
					conn = null;
				} catch (Exception e) {
				}

		} finally {

			if (conn != null)
				try {
					conn.close();
				} catch (Exception e) {
				}

		}

		return;
	}

	/*static public void get_ad(String url) {

		HttpConnection conn = null;
		InputStream inputStream = null;

		StringBuffer b = new StringBuffer();

		try

		{
			url = url + Utility.getConnectionString();
			conn = (HttpConnection) Connector.open(url);
			conn.setRequestMethod(HttpConnection.GET);
			conn.setRequestProperty("User-Agent",
					"Profile/MIDP-2.0 Configuration/CLDC-1.0");

			// Getting the response code will open the connection,
			// send the request, and read the HTTP response headers.
			// The headers are stored until requested.

			int rc = conn.getResponseCode();
			if (rc != HttpConnection.HTTP_OK) {

				throw new IOException("HTTP response code: " + rc);
			}

			inputStream = conn.openInputStream();

			int ch;
			while ((ch = inputStream.read()) != -1) {

				b.append((char) ch);
			}

			try {

				JSONObject json = new JSONObject(b.toString());

				ConnectThread.s_img_url = json.getString("img_url");
				ConnectThread.s_redirect_url = json.getString("redirect_url");
				ConnectThread.s_metrics_url = json.getString("metrics_url");
				ConnectThread.s_ad_text = json.getString("ad_text");

				System.out.println(ConnectThread.s_img_url);

				WebBitmapField.getImage(ConnectThread.s_img_url);

			}

			catch (JSONException e) {

			}

		} catch (IOException e1) {

			if (conn != null)
				try {
					conn.close();
					conn = null;
				} catch (Exception e) {
				}
			if (inputStream != null)
				try {
					inputStream.close();
					inputStream = null;
				} catch (Exception e) {
				}
		} finally {

			if (conn != null)
				try {
					conn.close();
				} catch (Exception e) {
				}
			if (inputStream != null)
				try {
					inputStream.close();
				} catch (Exception e) {
				}

		}

		return;
	}

	/**
	 * Implementation of Thread.
	 */
	public void run() {

		try {

			// ConnectThread.get_keywords("http://www.xf-mobile.com/download/keywords_bb.php");

		//	ConnectThread
			//		.get_ad("http://cus.adwhirl.com/custom.php?appid=c9cdeb0f2be24227b24992bf401db791&uuid=00000000000000000000000000000000&country_code=en_US&appver=200&client=4");

			//SendMetricImpressionsNotificatio();

			_forcequit = false;
			String url = null;

			
			//+ ";connectiontimeout=15000;deviceside=true" + Utility.getConnectionString2();

			//url = "socket://cs.xfire.com:25999" + ";connectiontimeout=15000;deviceside=true"+ Utility.getConnectionString2();

			url = "socket://cs.xfire.com:25999" + Utility.getConnectionString();

			if (_screen.isTCP()) {
				
				url = "socket://cs.xfire.com:25999" + Utility.getConnectionString2();
				//url = "socket://" + "cs.xfire.com" + ":25999"
					//	+ ";deviceside=true";

			}

			// url="socket://cs.xfire.com:25999;WAPGatewayIP=wap.metropcs.net;WAPGatewayAPN=carrier.com.gprs";

			connection = (SocketConnection) Connector.open(url,
					Connector.READ_WRITE, false);

			_in = new DataInputStream(connection.openInputStream());// ,"ISO-8859-1");

			_out = new DataOutputStream(connection.openOutputStream());// ,"ISO-8859-1");

			Login();
			while (_isThreadRunning) {

				onread();

			}
			_in.close();
			_out.close();
			connection.close();

		} catch (IOException e)

		{

			if (_forcequit == false) {
				_screen.OnNoConnection(e.toString());
			}
			System.err.println(e.toString());
		} finally {
			// _screen.setThreadRunning(false);
		}
	}
}
