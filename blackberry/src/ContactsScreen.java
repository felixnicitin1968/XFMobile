//import com.gamepe.admax.sdk.xfmobile.AdMaxManager;

import java.io.*;

import net.rim.device.api.system.*;
import net.rim.device.api.ui.*;
import net.rim.device.api.ui.component.*;
import net.rim.device.api.ui.container.*;

import java.util.Vector;

import javax.microedition.media.*;

import net.rim.blackberry.api.browser.*;
import java.util.Timer;
import java.util.TimerTask;

import net.rim.device.api.system.Alert;
import net.rim.device.api.system.AlertListener;
//import net.rim.blackberry.api.advertising.app10162.Banner;

class XfireContact extends Object

{

	int _messages_count;
	String[] _messages = new String[20];
	byte[] _cUsername;
	byte[] _cNickname;// =new char [0x100];
	byte[] _cStatusMsg = new byte[1];
	int _gameid;
	int _userid;
	byte[] _sid = new byte[16];
	int _uStatus;
	boolean _bIsPendingMessages;
	int _nTotalRecivedMessages;
	byte[] _cGamename = new byte[1];
	int _nNodeID;
	boolean _bRecvNewMsg;
	int _imindex;
	Bitmap picGame;

}

/*
 * EncodedImage ei = EncodedImage.getEncodedImageResource("image.png");
 * ei.setScale(2); // divide size by this number BitmapField bmp = new
 * BitmapField(ei.getBitmap()); add(bmp);
 */
class XfireClan {

	byte[] _name = new byte[0x100];;
	int _id;
	short _usercount;

	// XfireContact [] _users=new XfireContact[300];
	Vector _listContacts = new Vector();

	int _nNodeID;

}

class OptionsDialog extends Dialog {

	CheckboxField _chkVibrate = new CheckboxField(
			"Vibrate when IM are received", false);
	CheckboxField _chkSound = new CheckboxField("Sound when IM are received",
			false);
	CheckboxField _chkBlink = new CheckboxField("Blink when IM are received",
			false);

	public OptionsDialog() {
		// super("Search a friend", choices, values, Dialog.OK,
		// Bitmap.getPredefinedBitmap(Bitmap.QUESTION ), Dialog.GLOBAL_STATUS);
		super(Dialog.D_OK, "Preferences", Dialog.D_OK, Bitmap
				.getPredefinedBitmap(Bitmap.INFORMATION), Dialog.GLOBAL_STATUS);

		net.rim.device.api.ui.Manager delegate = getDelegate();
		if (delegate instanceof DialogFieldManager) {
			DialogFieldManager dfm = (DialogFieldManager) delegate;
			net.rim.device.api.ui.Manager manager = dfm.getCustomManager();
			if (manager != null) {

				manager.insert(_chkSound, 0);
				manager.insert(_chkBlink, 0);
				manager.insert(_chkVibrate, 0);
			}
		}

	}

	void setSound(boolean bOn) {

		_chkSound.setChecked(bOn);

	}

	void setVibrade(boolean bOn) {

		_chkVibrate.setChecked(bOn);

	}

	void setBlink(boolean bOn) {

		_chkBlink.setChecked(bOn);

	}

	boolean isSound()

	{
		return _chkSound.getChecked();

	}

	boolean isBlink()

	{
		return _chkBlink.getChecked();

	}

	boolean isVibrate()

	{

		return _chkVibrate.getChecked();

	}

}

class AddContactDialog extends Dialog {

	EditField userNameField = new EditField("username: ", "", 50,
			EditField.EDITABLE);

	public AddContactDialog() {
		// super("Search a friend", choices, values, Dialog.OK,
		// Bitmap.getPredefinedBitmap(Bitmap.QUESTION ), Dialog.GLOBAL_STATUS);
		super(Dialog.D_OK, "Add friend", Dialog.D_OK, Bitmap
				.getPredefinedBitmap(Bitmap.INFORMATION), Dialog.GLOBAL_STATUS);

		net.rim.device.api.ui.Manager delegate = getDelegate();
		if (delegate instanceof DialogFieldManager) {
			DialogFieldManager dfm = (DialogFieldManager) delegate;
			net.rim.device.api.ui.Manager manager = dfm.getCustomManager();
			if (manager != null) {

				manager.insert(userNameField, 0);
			}
		}

	}

	String getUsername() {

		return userNameField.getText();
	}
}

/*





*/

class ContactsScreen extends CustomMainScreen implements TreeFieldCallback,
		AlertListener, EventListener {

	public static final int XFIRE_STATUS_OFFLINE = 0;
	public static final int XFIRE_STATUS_ONLINE = 1;
	public static final int XFIRE_STATUS_AWAY = 2;
	public static final int XFIRE_BG_COLOR = 0x12283f;

	HorizontalFieldManager _fieldManagerTop;
	VerticalFieldManager _fieldManagerMiddle;
	HorizontalFieldManager _fieldManagerBottom;
	TreeField _myContactsTree;
	ChatScreen _chatScrn;
	MyStatusTextField _myStatusTextField;

	// AdMaxField _adfield;

	// WebBitmapField _bitmap;
	Bitmap _iBlazeLogo;

	int _ContactsNode;
	int _ConversionsNode;
	Bitmap _picOnline;
	Bitmap _picAway;
	Bitmap _picPerson;

	static boolean _bIsPlaySound = true;
	static boolean _bIsBlinking = false;
	static boolean _bIsVibrate = false;
	static boolean _bIsNexAgeAds = true;
	static boolean _bIsDownloadKeywords = true;

	int _nTotalContacts;
	XfireClan[] _ClansList = new XfireClan[10]; // array of JUST pointers
	int _nTotalClans;
	int _nTotalChatSessions;
	int _nTotalOnlineContacts;
	final FontFamily fontFamily[] = FontFamily.getFontFamilies();

	final Font _NodeFont = fontFamily[0].getFont(0, 18);

	Vector _listContacts = new Vector();

	void Delete_Conversation() {

		int nCurrentNode = _myContactsTree.getCurrentNode();

		if (nCurrentNode == -1)
			return;

		if (_myContactsTree.getParent(nCurrentNode) == _ConversionsNode) {

			Object obj = _myContactsTree.getCookie(nCurrentNode);
			if (obj instanceof XfireContact)

			{

				XfireContact contact = (XfireContact) obj;
				XfireContact xcontact = getContactByID(contact._userid);

				if (xcontact == null) {

					xcontact = (XfireContact) getClanMemberByID(contact._userid);

				}
				if (xcontact != null) {

					xcontact._bIsPendingMessages = false;

				}

				_myContactsTree.deleteSubtree(nCurrentNode);

			}

		}

	}

	void Open_Conversation() {

		int nCurrentNode = _myContactsTree.getCurrentNode();

		if (nCurrentNode == -1)
			return;
		if (_myContactsTree.getParent(nCurrentNode) != 0) {

			Object obj = _myContactsTree.getCookie(nCurrentNode);
			if (obj instanceof XfireContact)

			{

				XfireContact contact = (XfireContact) obj;

				XfireContact xcontact = getContactByID(contact._userid);

				if (xcontact == null) {

					xcontact = (XfireContact) getClanMemberByID(contact._userid);

				}
				if (xcontact != null) {
					xcontact._bRecvNewMsg = false;

				}

				UiApplication.getUiApplication().pushScreen(_chatScrn);
				if (_bIsNexAgeAds == true)

				{
					// _adfield.setKeyword(ConnectThread._keywords);
				}
				_chatScrn.SetContact(contact._userid);

			}
		}

	}

	protected boolean keyChar(char c, int status, int time) {

		switch (c) {

		case 8:
			System.out.println("***keyChar==8***");
			Delete_Conversation();
			break;

		case Characters.ENTER:

			Open_Conversation();

			break;

		default:

			break;

		}

		return super.keyChar(c, status, time);
	}

	protected boolean invokeAction(int action) {

		switch (action) {
		case ACTION_INVOKE:

			int nCurrentNode = _myContactsTree.getCurrentNode();

			if (nCurrentNode == -1)
				return super.invokeAction(action);

			if (_myContactsTree.getParent(nCurrentNode) != 0) {

				Object obj = _myContactsTree.getCookie(nCurrentNode);
				if (obj instanceof XfireContact)

				{

					XfireContact contact = (XfireContact) obj;

					UiApplication.getUiApplication().pushScreen(_chatScrn);

					XfireContact xcontact = getContactByID(contact._userid);

					if (xcontact == null) {

						xcontact = (XfireContact) getClanMemberByID(contact._userid);

					}

					if (xcontact != null) {

						xcontact._bRecvNewMsg = false;

					}
					if (_bIsNexAgeAds == true)

					{
						// _adfield.setKeyword(ConnectThread._keywords);
					}
					_chatScrn.SetContact(contact._userid);

				}

			}

			return true;
		}
		return super.invokeAction(action);
	}

	public void vibrateDone(int reason) {

		// startVibrate();
	}

	public void audioDone(int reason) {

		// do nothing
	}

	public void buzzerDone(int reason) {

		// do nothing
	}

	ContactsScreen() {

		LabelField title = new LabelField("Friends", LabelField.ELLIPSIS
				| LabelField.USE_ALL_WIDTH | LabelField.FIELD_VCENTER);
		setTitle(title);

		_fieldManagerTop = new HorizontalFieldManager() {

			public void paint(Graphics graphics) {
				graphics.setBackgroundColor(XFIRE_BG_COLOR);
				graphics.clear();
				super.paint(graphics);
			}

		};
		_fieldManagerMiddle = new VerticalFieldManager() {

			public void paint(Graphics graphics) {
				graphics.setBackgroundColor(XFIRE_BG_COLOR);
				graphics.clear();
				super.paint(graphics);
			}

		};
		_fieldManagerBottom = new HorizontalFieldManager() {
			public void paint(Graphics graphics) {
				graphics.setBackgroundColor(XFIRE_BG_COLOR);
				graphics.clear();
				super.paint(graphics);
			}

		};

		add(_fieldManagerTop);

		add(new SeparatorField());

		add(_fieldManagerMiddle);

		add(_fieldManagerBottom);

		// _picOnline=Bitmap.getBitmapResource(s);
		_picOnline = Bitmap.getBitmapResource("online.png");
		_picAway = Bitmap.getBitmapResource("away.png");
		_picPerson = Bitmap.getBitmapResource("person.png");

		// _bitmap = new WebBitmapField(
		// "http://s3.amazonaws.com/adrollo-custom-images/d7465f9f8105ebee51153da2ec30c4e2.jpg");

		// _iBlazeLogo=Bitmap.getBitmapResource("logoxf.png");
		// _bitmap.setBitmap(_iBlazeLogo);

		for (int i = 0; i < 10; i++) {

			_ClansList[i] = new XfireClan();

		}

		_chatScrn = new ChatScreen();

		// Defines the TreeField.
		_myContactsTree = new TreeField(this, TreeField.FOCUSABLE) {

			protected void paintBackground(net.rim.device.api.ui.Graphics g) {

				g.clear();
				g.getColor();
				g.setColor(XFIRE_BG_COLOR);
				g.fillRect(0, 0, Display.getWidth(), Display.getHeight());
				g.setColor(XFIRE_BG_COLOR);

			}
		};

		_ContactsNode = _myContactsTree.addChildNode(0, "Online Friends");
		_ConversionsNode = _myContactsTree.addChildNode(0, "Conversations");

		if (_bIsNexAgeAds == true)

		{

			// _bIsNexAgeAds=false;

			// _adfield = AdMaxManager.generateAdMaxField("Footer", "");

			// _adfield.setKeyword("games,laptops");

			// _asfield.setKeyword("counter+strike+game server,dedicated+game+servers,game+server+hosting,game+server+browser,game+server,game+servers,free+computer+games");

			// _adfield.setCountry("U.S.A");

			// _adfield.setFieldOnFocusColor(0xFF000000);
			// _adfield.setFieldUnFocusColor(XFIRE_BG_COLOR);

			//Banner bannerAd = new Banner(25089, null);
			//bannerAd.setMMASize(Banner.MMA_SIZE_AUTO );
			//_fieldManagerTop.add(bannerAd);

			// _fieldManagerTop.add(_bitmap);

		}

		_fieldManagerMiddle.add(_myContactsTree);

		_myStatusTextField = new MyStatusTextField();

		_myStatusTextField.setText("Xfire on BlackBerry");

		_fieldManagerBottom.add(_myStatusTextField);

		_bIsPlaySound = true;
		_bIsBlinking = false;

	}

	class LCDTask extends TimerTask {
		public void run() {

			LED.setState(LED.STATE_OFF);

		}
	}

	void init() {

		_nTotalContacts = 0;
		_nTotalClans = 0;
		_nTotalChatSessions = 0;
		_nTotalOnlineContacts = 0;

		for (int i = 0; i < _listContacts.size(); i++) {

			XfireContact xcontact = (XfireContact) _listContacts.elementAt(i);

			xcontact._messages_count = 0;
			xcontact._bIsPendingMessages = false;
			xcontact._nNodeID = -1;
			_listContacts.setElementAt(xcontact, i);

		}

		_myContactsTree.deleteAll();
		_ContactsNode = _myContactsTree.addChildNode(0, "Online Contacts");

		_ConversionsNode = _myContactsTree.addChildNode(0, "Conversations");

	}

	public void drawTreeItem(TreeField tree, Graphics g, int node, int y,
			int width, int indent) {
		// Retrieves the user-supplied cookie object
		// for the given node and casts to a string.
		Object obj = tree.getCookie(node);

		if (obj instanceof String)

		{
			String text = (String) obj;

			if (tree.getParent(node) != 0) {

				g.setFont(_NodeFont);
				g.setColor(0x000000FF);// blue
				g.drawBitmap(indent, y + 5, _picOnline.getWidth(), _picOnline
						.getHeight(), _picOnline, 0, 0);
				indent += _picOnline.getWidth() + 5;

			} else {
				g.setColor(0xFF8ABAF1);// SECTION NAME COLOR

			}

			try {

				g.drawText(new String(text.getBytes(), "UTF-8"), indent, y,
						Graphics.ELLIPSIS, width);

			} catch (UnsupportedEncodingException e)

			{

				g.drawText(text, indent, y, Graphics.ELLIPSIS, width);
			}

		}

		if (obj instanceof XfireContact)

		{

			XfireContact contact = (XfireContact) tree.getCookie(node);// obj;
			if (tree.getParent(node) != 0) {

				if (contact._bRecvNewMsg) {
					g.setColor(0xFF8ABAF1);// /blue
				} else {
					g.setColor(Color.WHITE);// /blue
				}

				if (contact._bIsPendingMessages && contact._bRecvNewMsg) {

					g.drawBitmap(indent, y + 2, _picPerson.getWidth(),
							_picPerson.getHeight(), _picPerson, 0, 0);

				} else if (contact._uStatus == XFIRE_STATUS_AWAY) {

					g.drawBitmap(indent, y + 2, _picAway.getWidth(), _picAway
							.getHeight(), _picAway, 0, 0);

				} else {

					g.drawBitmap(indent, y + 2, _picOnline.getWidth(),
							_picOnline.getHeight(), _picOnline, 0, 0);

				}

				if (contact._gameid != 0 && contact._gameid >= 4096
						&& contact._gameid <= 6047)

				{

					if (contact.picGame != null) {

						g.drawBitmap(indent, y + 2, contact.picGame.getWidth(),
								contact.picGame.getHeight(), contact.picGame,
								0, 0);
					}
				}

				indent += _picOnline.getWidth() + 5;
			} else
				g.setColor(0xFF8ABAF1);// black

			StringBuffer buf = new StringBuffer();

			if (contact._cNickname[0] == 0) {

				buf.append(new String(contact._cUsername));

				if (contact._cGamename[0] != 0) {
					buf.append(" [");
					buf.append(new String(contact._cGamename));
					buf.append("]");

				} else

				if (contact._cStatusMsg[0] != 0) {
					buf.append(" [");
					buf.append(new String(contact._cStatusMsg));
					buf.append("]");
				}
				if (_NodeFont != null) {
					g.setFont(_NodeFont);
				}

				try {
					g.drawText(new String(buf.toString().getBytes(), "UTF-8"),
							indent, y, Graphics.ELLIPSIS, width);

				} catch (UnsupportedEncodingException e) {
					g.drawText(buf.toString(), indent, y, Graphics.ELLIPSIS,
							width);

				}
			} else {

				buf.append(new String(contact._cNickname));

				if (contact._cGamename[0] != 0) {

					buf.append(" [" + new String(contact._cGamename) + "]");

				} else if (contact._cStatusMsg[0] != 0) {

					buf.append(" [" + new String(contact._cStatusMsg) + "]");

				}
				if (_NodeFont != null) {
					g.setFont(_NodeFont);
				}

				try {
					g.drawText(new String(buf.toString().getBytes(), "UTF-8"),
							indent, y, Graphics.ELLIPSIS, width);
				} catch (UnsupportedEncodingException e) {

					g.drawText(buf.toString(), indent, y, Graphics.ELLIPSIS,
							width);
				}

			}
		}

	}

	protected boolean navigationClick(int status, int time) {
		// we'll only override unvarnished navigation click behavior
		if ((status & KeypadListener.STATUS_ALT) == 0
				&& (status & KeypadListener.STATUS_SHIFT) == 0) {
			int node = _myContactsTree.getCurrentNode();
			if (node != -1)
				if (_myContactsTree.getFirstChild(node) != -1) {
					// node is an internal node
					_myContactsTree.setExpanded(node, !_myContactsTree
							.getExpanded(node));
					return true;
				} else {
					// click is on a leaf node. Do some default action or else
					// fall through
				}
		}

		return super.navigationClick(status, time);
	}

	void refreshConversions() {

		int nFirstChild = _myContactsTree.getFirstChild(_ConversionsNode);
		if (nFirstChild == -1)
			return;

		do {

			Object obj = _myContactsTree.getCookie(nFirstChild);
			if (obj instanceof XfireContact)

			{

				XfireContact contact = (XfireContact) obj;

				if (contact._uStatus == XFIRE_STATUS_OFFLINE) {

					_myContactsTree.deleteSubtree(nFirstChild);
					return;
				}

			}
			_myContactsTree.invalidateNode(nFirstChild);
			nFirstChild = _myContactsTree.getNextSibling(nFirstChild);

		} while (nFirstChild != -1);

	}

	boolean isConvAddedToTree(int userid) {

		int nFirstChild = _myContactsTree.getFirstChild(_ConversionsNode);
		if (nFirstChild == -1)
			return false;

		do {

			Object obj = _myContactsTree.getCookie(nFirstChild);
			if (obj instanceof XfireContact)

			{

				XfireContact contact = (XfireContact) obj;

				if (contact._userid == userid) {

					return true;
				}

				System.out.println(contact._cNickname);
			}

			nFirstChild = _myContactsTree.getNextSibling(nFirstChild);

		} while (nFirstChild != -1);

		return false;

	}

	boolean isFriendAddedToTree(int userid) {

		int nFirstChild = _myContactsTree.getFirstChild(_ContactsNode);
		if (nFirstChild == -1)
			return false;

		do {

			Object obj = _myContactsTree.getCookie(nFirstChild);
			if (obj instanceof XfireContact)

			{

				XfireContact contact = (XfireContact) obj;

				if (contact._userid == userid) {

					return true;
				}

				System.out.println(contact._cNickname);
			}

			nFirstChild = _myContactsTree.getNextSibling(nFirstChild);

		} while (nFirstChild != -1);

		return false;

	}

	protected void makeMenu(Menu menu, int instance)

	{

		menu.deleteAll();

		menu.add(new MenuItem("Minimize", 109, 109) {

			public void run() {

				iBlaze._isMinimized = true;
				UiApplication.getUiApplication().requestBackground();

			}

		});

		menu.add(new MenuItem("Add  friend", 104, 104) {

			public void run() {

				AddContactDialog pw = new AddContactDialog();
				if (pw.doModal() == Dialog.OK) {

					LoginScreen screen = null;
					screen = ((iBlaze) UiApplication.getUiApplication())
							.getScreen();
					try {
						if (pw.getUsername().length() > 2)
							screen._connectThread.sendAddContactPacket(pw
									.getUsername().toCharArray());

					} catch (IOException e) {
						System.err.println(e.toString());
					}

				}

			}

		});
		menu.add(new MenuItem("Options", 100, 100) {

			public void run() {

				OptionsDialog pw = new OptionsDialog();

				pw.setVibrade(_bIsVibrate);
				pw.setSound(_bIsPlaySound);
				pw.setBlink(_bIsBlinking);
				if (pw.doModal() == Dialog.OK) {

					_bIsPlaySound = pw.isSound();
					_bIsBlinking = pw.isBlink();
					_bIsVibrate = pw.isVibrate();

				}

			}

		});

		menu.add(new MenuItem("View Profile", 100, 100) {

			public void run() {

				int nCurrentNode = _myContactsTree.getCurrentNode();

				if (_myContactsTree.getParent(nCurrentNode) != 0) {

					Object obj = _myContactsTree.getCookie(nCurrentNode);
					if (obj instanceof XfireContact)

					{

						XfireContact contact = (XfireContact) obj;

						System.out.println(new String(contact._cUsername) + " "
								+ contact._userid);

						BrowserSession session = Browser.getDefaultSession();
						session.displayPage("http://www.xfire.com/profile/"
								+ new String(contact._cUsername));
						session.showBrowser();

					}

				}

			}

		});

		menu.addSeparator();

		// super.makeMenu(menu,instance);

	}

	public void AddConvMsg(XfireContact xcontact, String msg, boolean bMe) {

		int msgs_count = xcontact._messages_count;

		if (msgs_count == 20) {

			xcontact._messages_count = 0;
			msgs_count = 0;

		}

		StringBuffer buf = new StringBuffer();

		if (bMe == true) {

			buf.append(ConnectThread._myNickname + " says:");

		} else {

			if (xcontact._cNickname[0] != 0) {

				buf.append(new String(xcontact._cNickname) + " says:");
			} else {
				buf.append(new String(xcontact._cUsername) + " says:");
			}
		}

		buf.append(" ");
		buf.append(msg);
		xcontact._messages[msgs_count] = buf.toString();
		xcontact._messages_count++;

		_chatScrn.AddMessage(xcontact._userid, buf.toString(), bMe);

	}

	void Blink() {

		if (_bIsBlinking == false)
			return;

		LED.setColorConfiguration(1000, 1000, 0x0000ff);

		LED.setState(LED.STATE_BLINKING);

		Timer _timer = new Timer();
		_timer.schedule(new LCDTask(), 1000);

	}

	void Vibrate() {

		if (_bIsVibrate == false)
			return;

		Alert.startVibrate(1500);
	}

	void Typing() {

		if (!_bIsBlinking)
			return;

		LED.setColorConfiguration(1000, 1000, 0xDD00FF);
		LED.setState(LED.STATE_BLINKING);

		Timer _timer = new Timer();
		_timer.schedule(new LCDTask(), 1000);

	}

	void playSound() {

		if (_bIsPlaySound == false)
			return;

		try {

			InputStream is = getClass().getResourceAsStream("/imsound.wav");

			// create an instance of the player from the InputStream
			Player player = javax.microedition.media.Manager.createPlayer(is,
					"audio/x-wav");

			player.realize();
			player.prefetch();
			// start the player
			player.start();

		} catch (Exception e) {

			System.err.println(e.toString());
		}

	}

	XfireContact getContactBySID(byte[] sid) {

		boolean bOK = false;

		for (int i = 0; i < _listContacts.size(); i++) {

			XfireContact xcontact = (XfireContact) _listContacts.elementAt(i);

			bOK = false;

			for (int j = 0; j < 16; j++) {

				if (xcontact._sid[j] != sid[j]) {

					bOK = true;

					break;

				}

			}

			if (!bOK)
				return xcontact;

		}

		return getClanMemberBySID(sid);
	}

	XfireContact getContactByID(int userid) {

		for (int i = 0; i < _listContacts.size(); i++) {

			XfireContact xcontact = (XfireContact) _listContacts.elementAt(i);

			if (xcontact._userid == userid) {

				return xcontact;
			}

		}

		return getClanMemberByID(userid);
	}

	XfireContact getClanMemberBySID(byte[] sid) {

		boolean bOK = false;
		for (int i = 0; i < _nTotalClans; i++) {

			for (int j = 0; j < _ClansList[i]._usercount; j++) {

				XfireContact clan_xcontact = (XfireContact) _ClansList[i]._listContacts
						.elementAt(j);

				bOK = false;

				for (int t = 0; t < 16; t++) {

					if (clan_xcontact._sid[t] != sid[t]) {

						bOK = true;

						break;

					}

				}

				if (!bOK)
					return clan_xcontact;

			}

		}

		return null;
	}

	XfireContact getClanMemberByID(int userid) {

		for (int i = 0; i < _nTotalClans; i++) {

			for (int j = 0; j < _ClansList[i]._usercount; j++) {

				XfireContact clan_xcontact = (XfireContact) _ClansList[i]._listContacts
						.elementAt(j);
				if (clan_xcontact._userid == userid) {

					return clan_xcontact;
				}

			}

		}

		return null;
	}

	int getClanIndexByID(int nClanID) {

		for (int i = 0; i < _nTotalClans; i++) {

			if (_ClansList[i]._id == nClanID) {

				return i;
			}

		}

		return -1;
	}

	void removeClanMember(int userid) {

		XfireContact xcontact = (XfireContact) getClanMemberByID(userid);

		if (xcontact != null) {

			xcontact._uStatus = XFIRE_STATUS_OFFLINE;
			xcontact._bIsPendingMessages = false;

			_myContactsTree.deleteSubtree(xcontact._nNodeID);
			xcontact._nNodeID = 0;

			// _ClansList[i]._listContacts.setElementAt(xcontact,j);

		}

	}

	void addClanMember(int userid) {

		int nNodeID;

		for (int i = 0; i < _nTotalClans; i++) {

			for (int j = 0; j < _ClansList[i]._usercount; j++) {

				XfireContact clan_xcontact = (XfireContact) _ClansList[i]._listContacts
						.elementAt(j);

				if (clan_xcontact._userid == userid) {

					clan_xcontact._uStatus = XFIRE_STATUS_ONLINE;
					clan_xcontact._bIsPendingMessages = false;

					if (clan_xcontact._cNickname[0] == 0) {

						nNodeID = _myContactsTree.addChildNode(
								_ClansList[i]._nNodeID, clan_xcontact);

					} else {
						nNodeID = _myContactsTree.addChildNode(
								_ClansList[i]._nNodeID, clan_xcontact);

					}

					clan_xcontact._nNodeID = nNodeID;

					// _ClansList[i]._listContacts.setElementAt(clan_xcontact,j);

					return;

				}

			}

		}

		System.out.println("Leave Adding clan member ");

	}

	public void Removefriend(final int userid, String email) {
		// TODO Auto-generated method stub

		UiApplication.getUiApplication().invokeAndWait(new Runnable() {
			public void run() {

				removeClanMember(userid);

			}
		});

		final XfireContact xcontact = getContactByID(userid);

		if (xcontact == null) {

			return;

		}

		UiApplication.getUiApplication().invokeAndWait(new Runnable() {
			public void run() {

				_nTotalOnlineContacts--;
				xcontact._uStatus = XFIRE_STATUS_OFFLINE;
				_myContactsTree.deleteSubtree(xcontact._nNodeID);
				xcontact._nNodeID = 0;

				refreshConversions();

				String str = "Online Contacts(" + _nTotalOnlineContacts + ")";

				_myContactsTree.setCookie(_ContactsNode, str);

			}

		});
	}

	public void connectionClosed() {
		// TODO Auto-generated method stub

	}

	public void connectionError(final String err) {
		// TODO Auto-generated method stub

		UiApplication.getUiApplication().invokeLater(new Runnable() {
			public void run() {

				while (true) {

					Screen scrn = UiApplication.getUiApplication()
							.getActiveScreen();
					Object obj = scrn.getCookie();

					if (obj instanceof String)

					{

						String str = (String) obj;

						if (str.equals("login"))
							break;

					}
					UiApplication.getUiApplication().popScreen(scrn);

				}
				// _loginbutton.setLabel("Login");
				// _isConnected=false;
				// _isTringToConnect=false;
				Status.show(err);// " You were logged off because you logged in on a different computer.");

			}
		});

	}

	public void connectionEstablished() {
		// TODO Auto-generated method stub

	}

	public void Addfriend(final int userid, String email, String name) {
		// TODO Auto-generated method stub

		UiApplication.getUiApplication().invokeAndWait(new Runnable() {
			public void run() {

				addClanMember(userid);

			}
		});

		final XfireContact xcontact = getContactByID(userid);

		if (xcontact == null) {

			return;

		}

		UiApplication.getUiApplication().invokeAndWait(new Runnable() {
			public void run() {

				int nNodeID = -1;
				_nTotalOnlineContacts++;
				xcontact._uStatus = 1;

				if (isFriendAddedToTree(xcontact._userid) == false) {

					if (xcontact._cNickname[0] == 0) {

						nNodeID = _myContactsTree.addChildNode(_ContactsNode,
								xcontact);

					} else {

						nNodeID = _myContactsTree.addChildNode(_ContactsNode,
								xcontact);

					}

					xcontact._nNodeID = nNodeID;
					xcontact._uStatus = XFIRE_STATUS_ONLINE;
					xcontact._bIsPendingMessages = false;

					if (xcontact._messages[0] == null) {

						for (int j = 0; j < 20; j++) {

							xcontact._messages[j] = new String();
						}
					}

				}

				String str = "Online Contacts(" + _nTotalOnlineContacts + ")";

				_myContactsTree.setCookie(_ContactsNode, str);

			}
		});
	}

	public void friendGameStateChanged(byte[] sid, int gameid) {
		// TODO Auto-generated method stub

		XfireContact xcontact = getContactBySID(sid);

		if (xcontact == null) {

			System.out.println("updatePlayingGame no contact was found!");
			return;
		}

		String game = Utility.getGameName(gameid);

		if (game == null)
			return;

		xcontact._cGamename = new byte[game.length()];

		xcontact._gameid = gameid;
		xcontact.picGame = Bitmap
				.getBitmapResource("gameid_" + gameid + ".gif");

		System.arraycopy(game.getBytes(), 0, xcontact._cGamename, 0, game
				.length());

	}

	public void friendStateChanged(String email, int state) {
		// TODO Auto-generated method stub

	}

	public void friendStatusChanged(byte[] sid, String msg) {
		// TODO Auto-generated method stub

		XfireContact xcontact = getContactBySID(sid);

		if (xcontact == null)
			return;

		xcontact._gameid = 0;

		if (msg.length() > 5)
			if (msg.charAt(0) == '(' &&

			msg.charAt(1) == 'A' && msg.charAt(2) == 'F'
					&& msg.charAt(3) == 'K' && msg.charAt(4) == ')') {

				xcontact._uStatus = XFIRE_STATUS_AWAY;

			} else {

				xcontact._cStatusMsg = new byte[msg.length() + 1];

				System.arraycopy(msg.getBytes(), 0, xcontact._cStatusMsg, 0,
						msg.length());

				xcontact._uStatus = XFIRE_STATUS_ONLINE;

			}

		if (xcontact._nNodeID == 0 || xcontact._nNodeID == -1)
			return;

		if (_myContactsTree.getParent(xcontact._nNodeID) != 0) {
			_myContactsTree.invalidateNode(xcontact._nNodeID);

		}

	}

	public void messageError(final String id) {
		// TODO Auto-generated method stub

	}

	public void messageReceived(byte[] usersid, String email, String message,
			boolean bMe) {
		// TODO Auto-generated method stub

		XfireContact _xcontact = getContactBySID(usersid);

		if (_xcontact == null) {

			System.out
					.println("ContactScreen:AddConversions contact was not found [ERROR]");
			return;
		}

		final XfireContact xcontact = _xcontact;
		if (bMe == false) {

			Blink();
			Vibrate();
			playSound();

			xcontact._bRecvNewMsg = true;

		}

		AddConvMsg(xcontact, message, bMe);

		if (xcontact._uStatus == XFIRE_STATUS_OFFLINE) {

			_chatScrn.UserOffline();// ( _FriendsList[nIndex]._userid,new
			// String("<This user is now offline>"));
			return;

		}

		UiApplication.getUiApplication().invokeLater(new Runnable() {
			public void run() {

				if (xcontact._bIsPendingMessages == false) {

					if (isConvAddedToTree(xcontact._userid) == false) {

						xcontact._bIsPendingMessages = true;
						_myContactsTree
								.addChildNode(_ConversionsNode, xcontact);

						_myContactsTree.invalidateNode(xcontact._nNodeID);

					}

				}

			}
		});

		refreshConversions();

	}

	public void addClanGroup(final int clanid) {

		UiApplication.getUiApplication().invokeLater(new Runnable() {
			public void run() {

				int i = getClanIndexByID(clanid);

				_ClansList[i]._nNodeID = _myContactsTree.addChildNode(0,
						new String(_ClansList[i]._name));

				_myContactsTree.setExpanded(_ClansList[i]._nNodeID, false);

			}
		});

	}

	public void switchToTypingMode() {
		// TODO Auto-generated method stub

		Typing();
	}

	public void addClanGroup(byte[] name) {
		// TODO Auto-generated method stub

	}

	public void messageReceived(byte[] usersid, String email, String message) {
		// TODO Auto-generated method stub

	}

}
