/**
* Copyright 2006 the original author or authors.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*      http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/
package component;

import java.io.*;
import java.util.Timer;
import java.util.TimerTask;
import java.util.Vector;
import javax.microedition.io.*;
import xfire.*;

/**
* Core background service that handles all network communications over ssl.
*
* @author Michael Liao (askxuefeng@gmail.com)
*/
public class XfireService {

	public static final String STATE_ONLINE  = "Online";
	public static final String STATE_OFFLINE = "Offline";
	public static final String STATE_BUSY    = "Busy";

	private static final String XML_START = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<stream:stream to=\"gmail.com\" version=\"1.0\" xmlns=\"jabber:client\" xmlns:stream=\"http://etherx.jabber.org/streams\">";
	private static final String XML_END = "</stream:stream>";



	private Thread         connectingThread = null;

	public  static boolean   _isConnected=false;

	private SendingThread   sendingThread = null;
	private ReceivingThread receivingThread = null;
        public static String _myNickname ;


	public String username;
	public String password;

	private volatile String sessionId = null;

	private EventListener listener = null;

	private SocketConnection connection = null;
	private Reader reader = null;
	private Writer writer = null;
	private DataInputStream _in=null;
	private DataOutputStream _out=null;

	public XfireService(EventListener listener) {
		this.listener = listener;
	}

	public EventListener getEventListener() {
		return listener;
	}

	/**
	* Send a message and return this message's ID for future check.
	*
	* @param email Like "username@gmail.com".
	* @param message Text message.
	* @return Message id.
	*/

        void sendChangeNickPacket(char[] nickname) throws IOException {

		byte[] nick_pkt = new byte[0x100];

		int ptr = 2;
		nick_pkt[ptr++] = 0x0e;
		nick_pkt[ptr++] = 0x00;
		nick_pkt[ptr++] = 0x01;
		nick_pkt[ptr++] = 0x04;// nick strlen
		nick_pkt[ptr++] = 0x6e;// n
		nick_pkt[ptr++] = 0x69;// i
		nick_pkt[ptr++] = 0x63;// c
		nick_pkt[ptr++] = 0x6b;// k
		nick_pkt[ptr++] = 0x01;
		nick_pkt[ptr++] = (byte) nickname.length;
		nick_pkt[ptr++] = 0x00;

		System.arraycopy(new String(nickname).getBytes(), 0, nick_pkt, ptr,
				nickname.length);

		ptr += nickname.length;

		nick_pkt[0] = (byte) ptr;
		nick_pkt[1] = 0x00;

		_out.write(nick_pkt, 0, ptr);
		_out.flush();

	}

	void sendChanageMyStatusPacket(char[] pStatusMsg) throws IOException {

		byte[] cMyStatusPkt = new byte[0x100];

		int ptr = 2;

		cMyStatusPkt[ptr++] = 0x20;
		cMyStatusPkt[ptr++] = 0x00;

		cMyStatusPkt[ptr++] = 0x01;
		cMyStatusPkt[ptr++] = 0x2E;
		cMyStatusPkt[ptr++] = 0x01;

		cMyStatusPkt[ptr++] = (byte) pStatusMsg.length;
		cMyStatusPkt[ptr++] = 0x00;

		System.arraycopy(new String(pStatusMsg).getBytes(), 0, cMyStatusPkt,
				ptr, pStatusMsg.length);

		ptr += pStatusMsg.length;

		cMyStatusPkt[0] = (byte) (pStatusMsg.length + 9);
		cMyStatusPkt[1] = 0x00;

		_out.write(cMyStatusPkt, 0, (pStatusMsg.length + 9));
		_out.flush();

	}
        
	public String sendIMPacker(int userid,String email, String message) {


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

                XfireContact xcontact = null;

		xcontact = CoreService.getContactByUSERID(userid);

                if (xcontact==null) return "";


		System.arraycopy(xcontact._sid, 0, pkt, ptr, 16);
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

		int msg_len = message.toCharArray().length;
		pkt[ptr++] = (byte) (msg_len >> 0 & 0xFF);
		pkt[ptr++] = (byte) ((msg_len >> 8) & 0xFF);

		System.arraycopy(new String(message.toCharArray()).getBytes(), 0, pkt, ptr,
				message.toCharArray().length);

		ptr += message.toCharArray().length;

		msg_len = ptr;
		pkt[0] = (byte) (msg_len >> 0 & 0xFF);
		pkt[1] = (byte) ((msg_len >> 8) & 0xFF);
        try {
            _out.write(pkt, 0, ptr);
            _out.flush();

        } catch (IOException ex) {
            ex.printStackTrace();
        }
		


              
		return "";
	}

	private String encode(String message) {
		StringBuffer sb = new StringBuffer(message.length());
		for(int i=0; i<message.length(); i++) {
			char c = message.charAt(i);
			if(c=='<')
				sb.append("&lt;");
			else if(c=='>')
				sb.append("&gt;");
			else if(c=='&')
				sb.append("&amp;");
			else
				sb.append(c);
		}
		return sb.toString();
	}



	public String setState(int state) {
		String s = "Available";
		if(state==Friend.BUSY)
			s = "Busy";
		else if(state==Friend.IDLE)
			s = "sdnd";


		return s;
	}



	public void connect(String username, String password) {

		if(connection==null && connectingThread==null)
                {

			this.username = username;
			this.password = password;

			connectingThread = new ConnectingThread(this);
			connectingThread.start();

		}
		else
                {
			Main.debug("error: already connecting now.");
		}
	}

	public String getSessionId() {
		return sessionId;
	}

	public void shutdown() {


		Main.debug("shutdown now...");
		if(connectingThread!=null)
                {
			
			connectingThread.interrupt();
			try {
				connectingThread.join();
			}
			catch (InterruptedException ie) {}
		}
		if(connection!=null)
                {
			
			// sendingThread.shutdown();
			receivingThread.shutdown();
			try
                        {

				
				if(writer!=null)
                                {
					try { writer.close(); } catch (Exception e) {}
				}

				if(reader!=null)
                                {
					try { reader.close(); } catch (Exception e) {}
				}
				
				try { connection.close(); } catch(Exception e) {}
			}
			catch(Exception e)
                        {
				Main.debug(e.getMessage());
			}
			
			connection = null;
			listener.connectionClosed();
		}
		Main.debug("Application end.");
	}


	

	class ConnectingThread extends Thread {

		private XfireService service;

		public ConnectingThread(XfireService service)
                {
			this.service = service;
		}
		public void run() {
			try {
				Main.debug("begin xfire connection...");

				String  url = "socket://cs.xfire.com:25999";
				connection =  (SocketConnection) Connector.open(url,
					Connector.READ_WRITE, false);



				connection.setSocketOption(SocketConnection.LINGER, 5);
				Main.debug("socket connected.");


				_in = new DataInputStream(connection.openInputStream());// ,"ISO-8859-1");

				_out = new DataOutputStream(connection.openOutputStream());// ,"ISO-8859-1");



				receivingThread = new ReceivingThread(_in,_out, service);

                                sendingThread=new SendingThread(_out,service);

				//Main.debug("receivingThread start....");
                                sendingThread.start();
				receivingThread.start();
				// notify that connection is established:

				//connectingThread = null;

                                    byte[] uat = { 0x55, 0x41, 0x30, 0x31 };

				byte[] version = { 0x12, 0x00, 0x03, 0x00, 0x01, 0x07, 0x76, 0x65,
					0x72, 0x73, 0x69, 0x6f, 0x6e, // version
					0x02, 0x77, 0x77, // 1.87
					0x77, 0x77 };
        try {
            _out.write(uat, 0, 4);
            _out.write(version, 0, 18);

				_out.flush();
        } catch (IOException ex) {
            ex.printStackTrace();
        }




				


			}

			catch (Exception e) {
				Main.debug(e.getMessage());
				e.printStackTrace();
				connection = null;
				// notify connection error:
				listener.connectionError(e.getMessage());
				return;
			}


			Main.debug("connecting thread ended normally.");
		}
	}

}

class SendingThread extends Thread {

	private volatile boolean running = false;

	private DataOutputStream writer;
	private Vector queue = new Vector();
	private XfireService service;

	public boolean isRunning() { return running; }

	public void setEventListener(XfireService service) {
		this.service = service;
	}

	public void shutdown() {
		running = false;
		this.interrupt();
	}

	public void sendNow(String xml) {
		///Main.debug("sendNow: " + xml);
		synchronized(queue) {
			queue.insertElementAt(xml, 0);
			queue.notify();
		}
	}

	public void sendLater(String xml) {
		//Main.debug("sendLater: " + xml);
		synchronized(queue) {
			queue.addElement(xml);
			queue.notify();
		}
	}

	static void blockWriteToken(DataOutputStream writer, String token) throws IOException {
		Main.debug("send: " + token);
	        writer.write(token.getBytes());
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
				service.getEventListener().connectionError("IOException");
				break;
			}
		}
		Main.debug("sending thread ended.");
	}

	public SendingThread(DataOutputStream writer, XfireService service) {
		this.writer = writer;
		this.service = service;
	}

}

class ReceivingThread extends Thread {


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

	private int             _uStatus;
	private int             _dwReadSize;
	private int             _dwTotalReadSize;
	private byte[]          _pRcvBuffer;
	String                   _username;
	String                   _password;

	int _nIndex;

	
	int m_iQueneHead;
	int m_iQueneTail;

	public MsgQue[] m_pMsgQuene = new MsgQue[DEF_MSGQUENESIZE];

	Timer _timer = new Timer();
	Timer _KAtimer = new Timer();






	private volatile boolean running = false;

	private DataInputStream  reader;
	private DataOutputStream writer;
	private XfireService     service;

	public boolean isRunning() { return running; }

	public void shutdown() {
		running = false;
		this.interrupt();
	}



	public void run() {
		Main.debug("receving thread start...");
		running = true;

            

		try {
			while(onread());
		}
		catch (IOException e) {
			e.printStackTrace();
			Main.debug("[Receiving Thread IOException]" + e.getMessage());
			service.getEventListener().connectionError("IOException");
		}
		Main.debug("receiving thread ended.");
	}

	public ReceivingThread(DataInputStream reader,DataOutputStream writer, XfireService service)
	{
		this.reader = reader;
		this.writer = writer;
		this.service = service;

		_username=service.username;
		_password=service.password;

		_pRcvBuffer = new byte[DEF_MSGBUFFERSIZE];

		_uStatus = DEF_XSOCKSTATUS_READINGHEADER;

		_dwReadSize = 2;

		_dwTotalReadSize = 0;


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

	boolean onread() throws IOException {


		if (_uStatus == DEF_XSOCKSTATUS_READINGHEADER) {

			int nBytesRead = reader.read(_pRcvBuffer, _dwTotalReadSize,
				_dwReadSize);

			if (nBytesRead == -1) {

                            Main.debug("on read error header...");
                            return false;
                    }

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

			int nBytesRead = reader.read(_pRcvBuffer, _dwTotalReadSize,
				_dwReadSize);

			if (nBytesRead == -1) {

                             Main.debug("on read error data...");
                            return false;
                    }

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

		writer.write(pkt, 0, ptr);
		writer.flush();

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

				writer.write(version, 0, version.length);

		}

	}


	private void ParsePacket(byte[] pBuffer)
        {



		int dwMsgSize;

		dwMsgSize = (0xFF & ((byte) pBuffer[1]) << 8)
			| (0xFF & ((byte) pBuffer[0]));

		int ptr = 0;

		short cPacketID = (short) pBuffer[ptr + 3]; // 16
		cPacketID <<= 8;
		cPacketID |= (short) (0xFF & pBuffer[ptr + 2]);

		// _screen.updateDisplay("ParsePacket type nID="+nID);




                if (cPacketID == XFIRE_PACKET_CONTACTS) {

			System.out.println("XFIRE_PACKET_CONTACTS");
			handleContactsPacket(pBuffer, (short) dwMsgSize);

		}

                
		if (cPacketID == XFIRE_VERSION_MISMATCH_ID) {

			System.out.println("XFIRE_VERSION_MISMATCH_ID\n");


			try {

				HandleMismatchVersion(pBuffer, dwMsgSize);

			} catch (IOException e)
                        {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

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

                        handleLoginSuccessPacket(pBuffer,dwMsgSize);


			XfireService. _isConnected=true;
			
			service.getEventListener().connectionEstablished();





		}
               if (cPacketID == 135) {

			handleContactPlayingGame(pBuffer,dwMsgSize);
		}
		if (cPacketID == 144) {

			System.out.println("PONG PONG POOOOOOOOOOOOOOOOOONG");

		}

		if (cPacketID == 145) {

                      XfireService. _isConnected=false;
                      service.shutdown();
                      XFMobileMidlet.switchUI(new LoginForm());
		}

		if (cPacketID == XFIRE_LOGIN_FAILED_ID) {

			// _screen.updateDisplay("XFIRE_LOGIN_FAILED_ID");

			 System.out.println("XFIRE_LOGIN_FAILED_ID");

			 XfireService. _isConnected=false;

                         service.shutdown();
                         XFMobileMidlet.switchUI(new LoginForm());

			


			




		}

		if (cPacketID == XFIRE_BUDDY_STATUS_ID) {

			System.out.println("XFIRE_BUDDY_STATUS_ID");

			HandleBuddyStatus(pBuffer, dwMsgSize);
                        return;

		}

		
		if (cPacketID == XFIRE_RECV_IM_ID) {
         
                    try {
                handleReciveIMPacket(pBuffer, dwMsgSize);
            } catch (IOException ex) {
                ex.printStackTrace();
            }
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

                         
                            //CoreService._Clans[i]=new XfireClan();
                        CoreService._Clans[i]._name=new byte[clan_name_len+1];
                            
			System.arraycopy(cClanName, 0, CoreService._Clans[i]._name, 0,
					clan_name_len);

			ptr += clan_name_len;

		}



		ptr += 5;
                         System.out.println("Leave handleClanPacket ");
	}


         private void handleClanBuddyNamesPacket(byte[] pBuffer)

	{
		// TODO Auto-generated method stub

               System.out.println("handleClanBuddyNamesPacket\n ");
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

                if (nClanIndex==-1)  return;
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

	void handleContactPlayingGame(byte[] pBuffer, int MsgSize)
        {

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

					// System.out.println("call to updatePlayingGame");
					//ContactScreen.updatePlayingGame(usersid, gameid);

                                         XfireContact xcontact= CoreService.getContactBySID(usersid);

                                         if (xcontact!=null){

                                             service.getEventListener().friendGameStateChanged(xcontact._userid, gameid);
                                         }

				}

			}

		}

		// Log.v(TAG,"leave handleContactPlayingGame");

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



                                                  XfireContact xcontact= CoreService.getContactBySID(usersid);



                                                  boolean isaway=false;

                                                if (smsg.length()>5){

                                                    if (smsg.charAt(0)=='(' && smsg.charAt(1)=='A'&&smsg.charAt(2)=='F'&&smsg.charAt(3)=='K'
                                                            &&smsg.charAt(4)==')') {
                                                           

                                                              xcontact= CoreService.getContactBySID(usersid);

                                                             if (xcontact!=null){
                                                               
                                                              service.getEventListener().friendStateChanged(xcontact._userid, 3,"AFK");
                                                              isaway=true;

                                                             }
                                                    }



                                                }
                                                  if (isaway==false){

                                                        if (xcontact!=null){

                                                           service.getEventListener().friendStateChanged(xcontact._userid, 1,smsg);

                                                         }


                                                  }
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

				XfireService._myNickname = new String(cNickname, 0, nUserLen);

		}

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

                                                                name = new String(xcontact._cUsername);


                                                                  System.out.println("service.getEventListener().Removefriend\n");

                                                                 service.getEventListener().Removefriend( pUsersid[j],name);



								

							} else {

								CoreService._nTotalOnlineContacts++;
								String name = new String(xcontact._cUsername);

								if (xcontact._cNickname != null) {

									try {
										name = new String(xcontact._cNickname, "UTF-8");



                                                                              

									} catch (UnsupportedEncodingException e) {
										e.printStackTrace();
									}

								}

                                                                  System.out.println("service.getEventListener().friendFound\n");

                                                                 service.getEventListener().friendFound( pUsersid[j], new String(xcontact._cUsername), name);


							}

							ptr += 16;
						}
				}

		}

		// Log.v(TAG,"Leave HandleBuddyStatus "+pBuffer.length);

                 System.out.println("Leave HandleBuddyStatus \n");

	}

	private void handleContactsPacket(byte[] pBuffer, short MsgSize)

	{

             System.out.println("Enter  handleContactsPacket \n");

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

                            
                               //  new CoreService();
                                 
				CoreService._nTotalContacts = uNumOfFriends;

                                
                                CoreService._Contacts.removeAllElements();
                                
				System.out.println("_nTotalContacts->" + uNumOfFriends + "\n");
				cp += 2;
				short i = 0;

				for (i = 0; i < uNumOfFriends; i++)
                                {

					short ptr = (short) ((i + 1) * 2 + cp);

					uFriendNameLength = (short) pBuffer[(ptr + 1)]; // 18
					uFriendNameLength <<= 8;
					uFriendNameLength |= (short) (0xFF & pBuffer[(ptr)]); // 17

					byte[] cFriend = new byte[uFriendNameLength];

					for (short t = 0; t < uFriendNameLength; t++) {

						cFriend[t] = pBuffer[ptr + 2 + t];

					}




					CoreService._Contacts.addElement(new XfireContact());

					XfireContact xcontact = (XfireContact) CoreService._Contacts.elementAt(i);

					xcontact._cNickname = null;

					xcontact._cUsername = new byte[uFriendNameLength];

					System.arraycopy(cFriend, 0, xcontact._cUsername, 0,uFriendNameLength);

					
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

                 System.out.println("Leave  handleContactsPacket \n");

	}


        	void handleReciveIMPacket(byte[] pBuffer, int MsgSize) throws IOException {

		byte[] output = new byte[0x100];
		byte[] cMsg ;
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

						XfireContact xcontact = CoreService
								.getContactBySID(sid);

						


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

                                                                XfireContact xcontact = CoreService
.getContactBySID(sid);

                                                             
                                                                
								if (msg_len < 0x100) {


                                                                        cMsg=new byte[msg_len];
									System.arraycopy(pBuffer, ptr, cMsg, 0,
											msg_len);



                                                                        System.out.print(new String(cMsg, "UTF-8"));


                                                                    


                                                                        service.getEventListener().messageReceived(xcontact._userid, _username, new String(cMsg, "UTF-8"));
									//ContactScreen.AddConversions(sid,
										//	new String(cMsg, "UTF-8"), false);

								}

								

								

								xcontact._imindex = imIndex;

								System.arraycopy(pBuffer, 0, output, 0, 62);

								output[0] = 62;
								output[1] = 0;
								output[2] = 2;
								output[3] = 0;

								output[35] = 0x02;
								output[45] = 0x01;

								writer.write(output, 0, 62);
								writer.flush();

							}

						}

					}

				}

			}

		}


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

				writer.write(cPacket, 0, (_username.length() + 0x61));
				writer.flush();

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

	class MsgTask extends TimerTask {
		public void run() {

			while (bGetMsgQuene()) {

			}

		}
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
}

class Main {

	public static void debug(String s) {
		System.out.println(s);
	}

}
