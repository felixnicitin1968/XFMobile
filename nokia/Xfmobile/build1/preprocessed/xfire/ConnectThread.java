package xfire;


import component.CoreService;

import  component.*;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.Reader;
import java.io.UnsupportedEncodingException;
import java.io.Writer;
import java.util.Timer;
import java.util.TimerTask;
import java.util.Vector;

import javax.microedition.io.Connector;
import javax.microedition.io.SocketConnection;

class Main {

    public static void debug(String s) {
        System.out.println(s);
    }

}

/*
	void sendIMPacket(byte[] pSid, char[] pBuffer) throws IOException {

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

		XfireContact xcontact = null;

		xcontact = CoreService.getContactBySID(pSid);

		if (xcontact == null) {

			xcontact = ContactScreen.getClanMemberbySID(pSid);
		}
		if (xcontact == null)
			return;

		int imindex = 0;

		imindex = xcontact._imindex;
		xcontact._imindex++;

		// imindex data
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

		System.arraycopy(new String(pBuffer).getBytes(), 0, pkt, ptr,
				pBuffer.length);

		ptr += pBuffer.length;

		msg_len = ptr;
		pkt[0] = (byte) (msg_len >> 0 & 0xFF);
		pkt[1] = (byte) ((msg_len >> 8) & 0xFF);



		_out.write(pkt, 0, ptr);
		_out.flush();

		Log.v(TAG, "Leave sendIMPacket");

	}
*/
class SendingThread extends Thread {

    private volatile boolean running = false;

    private Writer writer;
    private Vector queue = new Vector();
  //  private JabberService service;

    public boolean isRunning() { return running; }

   // public void setEventListener(JabberService service) {
   //     this.service = service;
   // }

    public void shutdown() {
        running = false;
        this.interrupt();
    }

    public void sendNow(String xml) {
       // Main.debug("sendNow: " + xml);
        synchronized(queue) {
            queue.insertElementAt(xml, 0);
            queue.notify();
        }
    }

    public void sendLater(String xml) {
        Main.debug("sendLater: " + xml);
        synchronized(queue) {
            queue.addElement(xml);
            queue.notify();
        }
    }

    static void blockWriteToken(Writer writer, String token) throws IOException {
        Main.debug("send: " + token);
        writer.write(token);
        writer.flush();
    }

    public void run() {
        Main.debug("sending thread start...");
        running = true;
        while(running) {
            String xml = null;
            synchronized(queue) {
                if(queue.size()==0) {
                    try {
                        queue.wait();
                    } catch (InterruptedException ie) {
                        if(!running)
                            break;
                    }
                }
                xml = queue.firstElement().toString();
                queue.removeElementAt(0);
            }
            // send:
            try {
                blockWriteToken(writer, xml);
            } catch (IOException e) {
                Main.debug("[Sending Thread IOException]" + e.getMessage());
             //   service.getEventListener().connectionError("IOException");
                break;
            }
        }
        Main.debug("sending thread ended.");
    }

     public SendingThread(Writer writer/*, JabberService service*/) {
        this.writer = writer;
       // this.service = service;
    }

}

public class ConnectThread extends Thread {

	public static final int OBJECT_SHELL_SIZE = 8;
	public static final int OBJREF_SIZE = 4;
	public static final int LONG_FIELD_SIZE = 8;
	public static final int INT_FIELD_SIZE = 4;
	public static final int SHORT_FIELD_SIZE = 2;
	public static final int CHAR_FIELD_SIZE = 2;
	public static final int BYTE_FIELD_SIZE = 1;
	public static final int BOOLEAN_FIELD_SIZE = 1;
	public static final int DOUBLE_FIELD_SIZE = 8;
	public static final int FLOAT_FIELD_SIZE = 4;
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
        private Reader reader = null;
        private Writer writer = null;

	SocketConnection connection = null;

         public  static boolean   _isConnected=false;

	private int _uStatus;
	private int _dwReadSize;
	private int _dwTotalReadSize;
	private byte[] _pRcvBuffer;
	private boolean _isThreadRunning;
	private boolean _forcequit;
	int _nIndex;
	static String _keywords;

	static String _myNickname = new String();

	int m_iQueneHead;
	int m_iQueneTail;
	MsgQue[] m_pMsgQuene = new MsgQue[DEF_MSGQUENESIZE];

	Timer _timer = new Timer();
	Timer _KAtimer = new Timer();

	String _username;
	String _password;

	// Constructor
	public ConnectThread() {

		// _screen=((iBlaze) UiApplication.getUiApplication()).getScreen();

		// _contacts=xfmobile._xfmobileObject.allocContactsScreen();

		// _contacts.init();

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
		_KAtimer.schedule(new KeepAliveTask(), 0, 1000 * 240);

	}

	public void setLogin(String user, String pass) {

		_username = "injice";
		_password = "111111";
	}

	class KeepAliveTask extends TimerTask {
		public void run() {

			try {

				System.out.println("Sending PING packets");
				 KeepAlive();

			}

			catch (Exception e) {
				System.err.println(e.toString());
			} finally {

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

		// char []p=m_pMsgQuene[m_iQueneHead].bGet_data();

	//	ParsePacket(m_pMsgQuene[m_iQueneHead].bGet_data());

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

	class MsgTask extends TimerTask {
		public void run() {

			while (bGetMsgQuene()) {

			}

		}
	}

	private boolean onread() throws IOException {

		// if (!_in.ready()) return;

		if (_uStatus == DEF_XSOCKSTATUS_READINGHEADER) {

			int nBytesRead = _in.read(_pRcvBuffer, _dwTotalReadSize,
					_dwReadSize);

			if (nBytesRead == -1)
				return false;

			_dwReadSize -= nBytesRead;
			_dwTotalReadSize += nBytesRead;

			if (_dwReadSize == 0) {

				_uStatus = DEF_XSOCKSTATUS_READINGBODY;

				int wp = 0;// (0xFF & ((byte)_pRcvBuffer[1]) << 8) | (0xFF &
							// ((byte)_pRcvBuffer[0]));

				wp = _pRcvBuffer[1];
				wp <<= 8;

				wp |= (0xFF & ((char) _pRcvBuffer[0]));

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
				return false;

			_dwReadSize -= nBytesRead;
			_dwTotalReadSize += nBytesRead;

			if (_dwReadSize == 0) {

				bPutMsgQuene(false, _pRcvBuffer, _dwTotalReadSize + 2);
				_dwReadSize = 2;
				_dwTotalReadSize = 0;

				_uStatus = DEF_XSOCKSTATUS_READINGHEADER;

			}

		}

		return true;

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

			cPacket[0] = (byte) (_username.length() + 0x61);
			cPacket[1] = 0x00;
			cPacket[2] = 0x01;
			cPacket[3] = 0x00;
			cPacket[4] = 0x03;
			cPacket[5] = 0x04;

			byte[] name = { 'n', 'a', 'm', 'e' };

			System.arraycopy(name, 0, cPacket, 6, 4);

			cPacket[10] = 0x01;

			cPacket[11] = (byte) (_username.length());

			cPacket[12] = 0;

			System.arraycopy(_username.getBytes(), 0, cPacket, 13, _username
					.length());

			cPacket[12 + _username.length() + 1] = 0x08;

			byte[] password = { 'p', 'a', 's', 's', 'w', 'o', 'r', 'd' };

			System.arraycopy(password, 0, cPacket, 12 + _username.length() + 2,
					8);

			cPacket[12 + _username.length() + 2 + 8] = 0x01;
			cPacket[12 + _username.length() + 2 + 8 + 1] = 0x28;
			cPacket[12 + _username.length() + 2 + 8 + 1 + 1] = 0x00;

			String cryptPass = cryptPassword(_username, _password, saltcode);

			System.arraycopy(cryptPass.getBytes(), 0, cPacket, 12
					+ _username.length() + 2 + 8 + 1 + 1 + 1, 40);

			_out.write(cPacket, 0, (_username.length() + 0x61));
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

	}

	
	void handleContactStatusMessagePacket(byte[] pBuffer, int MsgSize) {

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

					String smsg;
					try {

						smsg = new String(status_msg, "UTF-8");
						
						System.out.println("status msg="+smsg+"\n");
					//	ContactScreen.updateContactStatus(usersid, smsg);

					} catch (UnsupportedEncodingException e) {

			
					
					}

				}

			}

		} else {

		
			// Log.v(TAG,byteArrayToHexString(new
			// String(pBuffer).getBytes(),MsgSize));

		}
		// Log.v(TAG,"leave handleContactStatusMessagePacket "+MsgSize);

	}

	
	
	private void KeepAlive() throws Exception {

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

		_out.write(pkt, 0, ptr);
		_out.flush();

	}
/*
	private void ParsePacket(byte[] pBuffer) {

		int dwMsgSize;

		dwMsgSize = (0xFF & ((byte) pBuffer[1]) << 8)
				| (0xFF & ((byte) pBuffer[0]));

		int ptr = 0;

		short cPacketID = (short) pBuffer[ptr + 3]; // 16
		cPacketID <<= 8;
		cPacketID |= (short) (0xFF & pBuffer[ptr + 2]);

		// _screen.updateDisplay("ParsePacket type nID="+nID);

		if (cPacketID == XFIRE_VERSION_MISMATCH_ID) {

			System.out.println("XFIRE_VERSION_MISMATCH_ID\n");

                       
			try {

				HandleMismatchVersion(pBuffer, dwMsgSize);

			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

		}

		if (cPacketID == 135) {

			// handleContactPlayingGame(pBuffer,dwMsgSize-2);
		}

		if (cPacketID == XFIRE_CONTACT_STATUS_MSG) {

			handleContactStatusMessagePacket(pBuffer,dwMsgSize);
			System.out.println("received away status packet.\n");

		}

		if (cPacketID == XFIRE_CLAN_PACKET) {

			System.out.println("XFIRE_CLAN_PACKET");
			handleClanPacket(pBuffer, dwMsgSize);

		}

		if (cPacketID == XFIRE_CLAN_BUDDYS_NAMES_ID) {

			System.out.println("XFIRE_CLAN_BUDDYS_NAMES_ID");
			handleClanBuddyNamesPacket(pBuffer);
		}
		if (cPacketID == XFIRE_LOGIN_SUCCESS_ID) {

			System.out.println("XFIRE_LOGIN_SUCCESS_ID");
			// handleLoginSuccessPacket(pBuffer,dwMsgSize-2);
			

                        _isConnected=true;
                         XFMobileMidlet.switchUI(new MainCanvas("",""));

                       
                     
		
			
		}

		if (cPacketID == 144) {

			System.out.println("PONG PONG POOOOOOOOOOOOOOOOOONG");

		}

		if (cPacketID == 145) {

		}

		if (cPacketID == XFIRE_LOGIN_FAILED_ID) {

			// _screen.updateDisplay("XFIRE_LOGIN_FAILED_ID");

			System.out.println("XFIRE_LOGIN_FAILED_ID");

                        _isConnected=false;
                        
			quit();

                     //   XFMobileMidlet.loginFrame.OnLoginFailed();

	     
			
		

		}

		if (cPacketID == XFIRE_BUDDY_STATUS_ID) {

			System.out.println("XFIRE_BUDDY_STATUS_ID");

			HandleBuddyStatus(pBuffer, dwMsgSize);

		}

		if (cPacketID == XFIRE_PACKET_CONTACTS) {

			System.out.println("XFIRE_PACKET_CONTACTS");
			handleContactsPacket(pBuffer, (short) dwMsgSize);

		}

		if (cPacketID == XFIRE_RECV_IM_ID) {

			return;
		}

		if (cPacketID == XFIRE_PACKET_AUTH_ID) {

			// _screen.updateDisplay("XFIRE_PACKET_AUTH_ID");
			System.out.println("XFIRE_PACKET_AUTH_ID");

			try {

				HandleAuth(pBuffer, dwMsgSize);

			} catch (IOException e) {
				System.err.println(e.toString());
			} finally {

			}

		}

	}

	private void handleClanBuddyNamesPacket(byte[] pBuffer)

	{
		// TODO Auto-generated method stub

		int ptr = 0;

		ptr += 7;

		int clanID = (int) pBuffer[(ptr + 3)] & 0xFF; // 16

		clanID <<= 8;
		clanID |= (int) (0xFF & pBuffer[(ptr + 2)]); // 15

		clanID <<= 8;
		clanID |= (int) (0xFF & pBuffer[(ptr + 1)]); // 15

		clanID <<= 8;
		clanID |= (int) (0xFF & pBuffer[(ptr)]); // 15

		int nClanIndex = CoreService.getClanIndexByID(clanID);
		ptr += 4;

		ptr += 3;

		short clan_friends_count = (short) pBuffer[(ptr + 1)]; // 16
		clan_friends_count <<= 8;
		clan_friends_count |= (short) (0xFF & pBuffer[(ptr)]); // 15

		CoreService._Clans[nClanIndex]._usercount = clan_friends_count;

		CoreService._Clans[nClanIndex]._Contacts.removeAllElements();
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

			CoreService._Clans[nClanIndex]._Contacts
					.addElement(new XfireContact());

			XfireContact xcontact = (XfireContact) CoreService._Clans[nClanIndex]._Contacts
					.elementAt(i);

			xcontact._userid = userid;

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

			XfireContact xcontact = (XfireContact) CoreService._Clans[nClanIndex]._Contacts
					.elementAt(i);

			xcontact._cUsername = new byte[nUserLen + 1];
			System.arraycopy(cUsername, 0, xcontact._cUsername, 0, nUserLen);

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

			XfireContact xcontact = (XfireContact) CoreService._Clans[nClanIndex]._Contacts
					.elementAt(i);

			xcontact._cNickname = new byte[nNickLen + 1];
			System.arraycopy(cNickname, 0, xcontact._cNickname, 0, nNickLen);

			ptr += nNickLen;

		}

	}

	private void handleClanPacket(byte[] pBuffer, int i)

	{

		System.out.println("Enter handleClanPacket ");

		int ptr = 0;

		ptr += 5;

		short clan_count = (short) pBuffer[(ptr + 4)]; // 16
		clan_count <<= 8;
		clan_count |= (short) (0xFF & pBuffer[(ptr + 3)]); // 15

		CoreService._nTotalClans = clan_count;

		System.out.println("handleClanPacket clan_count= " + clan_count);

		ptr = ptr + 5;

		for (i = 0; i < clan_count; i++) {

			int clanID = (int) pBuffer[(ptr + 3)] & 0xFF; // 16

			clanID <<= 8;
			clanID |= (int) (0xFF & pBuffer[(ptr + 2)]); // 15

			clanID <<= 8;
			clanID |= (int) (0xFF & pBuffer[(ptr + 1)]); // 15

			clanID <<= 8;
			clanID |= (int) (0xFF & pBuffer[(ptr)]); // 15

			CoreService._Clans[i] = new XfireClan();

			CoreService._Clans[i]._id = clanID;

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

			System.arraycopy(cClanName, 0, CoreService._Clans[i]._name, 0,
					clan_name_len);

			ptr += clan_name_len;

		}

		// ContactScreen.addClans();
		System.out.println("PONG PONG handleClanPacket");

		ptr += 5;

	}

	private void HandleBuddyStatus(byte[] pBuffer, int MsgSize) {

		// Log.v(TAG,"Enter HandleBuddyStatus "+pBuffer.length);

		int dwNumOfUserid, dwNumOfSid;
		int dwUserID;
		byte[] sid = new byte[16];

		int ptr;
		ptr = 6;

		if (pBuffer[ptr + 0] == 'u' && pBuffer[ptr + 1] == 's'
				&& pBuffer[ptr + 2] == 'e' &&

				pBuffer[ptr + 3] == 'r' && pBuffer[ptr + 4] == 'i'
				&& pBuffer[ptr + 5] == 'd') {

			ptr += 6;

			ptr += 2;

			dwNumOfUserid = (short) pBuffer[ptr + 1] & 0xFF; // 16
			dwNumOfUserid <<= 8;
			dwNumOfUserid |= (short) (0xFF & pBuffer[(ptr)]); // 15

			ptr += 2;

			int[] pUsersid = new int[dwNumOfUserid + 1];

			for (int i = 0; i < dwNumOfUserid; i++) {

				dwUserID = (int) pBuffer[(ptr + 3)] & 0xFF; // 16

				dwUserID <<= 8;
				dwUserID |= (int) (0xFF & pBuffer[(ptr + 2)]); // 15

				dwUserID <<= 8;
				dwUserID |= (int) (0xFF & pBuffer[(ptr + 1)]); // 15

				dwUserID <<= 8;
				dwUserID |= (int) (0xFF & pBuffer[(ptr)]); // 15

				pUsersid[i] = dwUserID;

				ptr += 4;

			}

			ptr += 1;

			if (pBuffer[ptr + 0] == 's' && pBuffer[ptr + 1] == 'i'
					&& pBuffer[ptr + 2] == 'd') {

				ptr += 3;

				ptr += 2;
				dwNumOfSid = (short) pBuffer[(ptr + 1)]; // 16
				dwNumOfSid <<= 8;
				dwNumOfSid |= (short) (0xFF & pBuffer[(ptr)]); // 15

				ptr += 2;

				for (short j = 0; j < dwNumOfSid; j++) {

					for (int t = 0; t < 16; t++) {

						sid[t] = 0;

					}

					System.arraycopy(pBuffer, ptr, sid, 0, 16);

					boolean isZero = true;

					for (int t = 0; t < 16; t++) {
						if (sid[t] != 0) {

							isZero = false;
							break;

						}

					}

					XfireContact xcontact = null;
					xcontact = CoreService.getContactByUSERID(pUsersid[j]);

					if (xcontact == null) {

						xcontact = CoreService
								.getClanContactByUSERID(pUsersid[j]);

					}

					if (xcontact == null) {

						System.out
								.println("call to get Clan memberrrrrr return NULL");

						continue;

					}

					xcontact._imindex = 0;
					System.arraycopy(pBuffer, ptr, xcontact._sid, 0, 16);

					if (isZero) {

						if (CoreService._nTotalOnlineContacts > 0) {

							CoreService._nTotalOnlineContacts--;
						}
						
						String name = null;

						if (xcontact._cNickname[0] == 0) {

							name = new String(xcontact._cUsername);
							// ContactScreen.addContact(pUsersid[j], false);

						} else {

							try {
								name = new String(xcontact._cNickname, "UTF-8");

							} catch (UnsupportedEncodingException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							}

							// ContactScreen.addContact(pUsersid[j], false);

						}

					} else {

						CoreService._nTotalOnlineContacts++;
							String name = null;

						if (xcontact._cNickname != null) {

							try {
								name = new String(xcontact._cNickname, "UTF-8");

								// ContactScreen.addContact( pUsersid[j],
								// true);

							} catch (UnsupportedEncodingException e) {
								e.printStackTrace();
							}

						}

					}

					ptr += 16;
				}
			}

		}

		// Log.v(TAG,"Leave HandleBuddyStatus "+pBuffer.length);
	}

	private void handleContactsPacket(byte[] pBuffer, short MsgSize)

	{

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

			CoreService._nTotalContacts = uNumOfFriends;

			System.out.println("_nTotalContacts->" + uNumOfFriends + "\n");
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

				CoreService._Contacts.addElement(new XfireContact());

				XfireContact xcontact = (XfireContact) CoreService._Contacts
						.elementAt(i);

				xcontact._cNickname = null;

				xcontact._cUsername = new byte[uFriendNameLength];

				System.arraycopy(cFriend, 0, xcontact._cUsername, 0,
						uFriendNameLength);

				// CoreService._onlineFriendsList.set(i, xcontact);

				CoreService._Contacts.setElementAt(xcontact, i);

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

					XfireContact xcontact = (XfireContact) CoreService._Contacts
							.elementAt(i);

					if (uNickNameLength != 0) {

						xcontact._cNickname = new byte[uNickNameLength];

						System.arraycopy(nickname, 0, xcontact._cNickname, 0,
								uNickNameLength);
					} else {

						xcontact._cNickname = new byte[xcontact._cUsername.length];

						System.arraycopy(xcontact._cUsername, 0,
								xcontact._cNickname, 0,
								xcontact._cUsername.length);

					}

					CoreService._Contacts.setElementAt(xcontact, i);

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

					System.out.println("uNumOfUserID->" + uNumOfUserID + "\n");

					for (i = 0; i < uNumOfUserID; i++) {

						int dwUserID = (int) pBuffer[(cp + 3)] & 0xFF; // 16

						dwUserID <<= 8;
						dwUserID |= (int) (0xFF & pBuffer[(cp + 2)]); // 15

						dwUserID <<= 8;
						dwUserID |= (int) (0xFF & pBuffer[(cp + 1)]); // 15

						dwUserID <<= 8;
						dwUserID |= (int) (0xFF & pBuffer[(cp)]); // 15

						XfireContact xcontact = (XfireContact) CoreService._Contacts
								.elementAt(i);

						xcontact._userid = dwUserID;
						xcontact._uStatus = 0;
						//System.out.println(i + "->userid->" + dwUserID + "\n");

						CoreService._Contacts.setElementAt(xcontact, i);

						cp += 4;

					}

				}

			}

		}

	}

	private void HandleMismatchVersion(byte[] pBuffer, int MsgSize)
			throws IOException

	{

		char ver;
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

			// 00000035 7d 00 86 00 05 07 76 65 72 73 69 6f 6e 04 02 01 }.....ve
			// rsion...
			// 00000045 00 6f 00 00 00 04 66 69 6c 65 04 01 01 00 33 00 .o....

			version[14] = pBuffer[6 + 7 + 4];

			_out.write(version, 0, version.length);

		}

	}

	void quit() {

		_forcequit = true;

		_isThreadRunning = false;
	}

	private void handleLoginSuccessPacket(byte[] pBuffer, int MsgSize) {

		System.out.println("Enter handleLoginSuccessPacket");
		int ptr = 0;

		ptr += 5; // header

		ptr += 7; // "userid"

		ptr += 4;

		ptr += 5; // sid

		ptr += 18;

		byte[] cNickname = new byte[0x100];

		for (int j = 0; j < 0x100; j++)
			cNickname[j] = 0;

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

	public void run() {

		try {

			System.out.println("ENTER RUN THREAD");
			_forcequit = false;
			String url;

			// get_keywords("http://www.xf-mobile.com/download/keywords_bb.php");
			url = "socket://cs.xfire.com:25999";

			// if (_screen.isTCP()){
			// url = "socket://" + "cs.xfire.com" + ":25999" +
			// ";deviceside=true";
			// }
			connection = (SocketConnection) Connector.open(url,
					Connector.READ_WRITE, false);

			_in = new DataInputStream(connection.openInputStream());// ,"ISO-8859-1");

			_out = new DataOutputStream(connection.openOutputStream());// ,"ISO-8859-1");

			Login();

			while (_forcequit==false) {

				onread();
			}
			_in.close();
			_out.close();
			connection.close();

			System.out.println("LEAVE RUN THREAD");

		} catch (IOException e)

		{

			System.out.println("LEAVE RUN THREAD[IOException]");

			if (_forcequit == false) {

				// _screen.OnNoConnection(e.toString());
			}

		}

	}*/
}