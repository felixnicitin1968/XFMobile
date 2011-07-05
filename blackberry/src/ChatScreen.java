
import java.io.IOException;

//import com.gamepe.admax.sdk.xfmobile.AdMaxLog;
import net.rim.device.api.ui.Field;
import net.rim.device.api.ui.FieldChangeListener;
import net.rim.device.api.ui.Manager;
import net.rim.device.api.ui.Screen;

import net.rim.device.api.ui.component.RichTextField;
import net.rim.device.api.ui.container.VerticalFieldManager;

import java.io.*;

import net.rim.device.api.system.*;
import net.rim.device.api.ui.*;
import net.rim.device.api.ui.component.*;

import net.rim.device.api.ui.Font;
import net.rim.device.api.ui.FontFamily;

//For RIM 4.5 and lower use paint event to draw background youreself: 

class ExRichTextField extends RichTextField {

	int mTextColor;
	int mBgColor;

	public ExRichTextField(String text, int bgColor, int textColor) {
		super(text);
		mTextColor = textColor;
		mBgColor = bgColor;
	}

	public void setColor(int bgColor, int textColor) {

		mTextColor = textColor;
		mBgColor = bgColor;

	}

	protected void paint(Graphics graphics) {
		graphics.clear();
		graphics.setColor(mBgColor);
		graphics.fillRect(0, 0, getWidth(), getHeight());
		graphics.setColor(mTextColor);
		super.paint(graphics);
	}
}

class TextBoxField extends VerticalFieldManager {

	// define some variables to be used
	// in the class
	private int managerWidth;
	private int managerHeight;
	private ExRichTextField editField;

	final FontFamily[] fontFamily = FontFamily.getFontFamilies();

	final Font font10 = fontFamily[0].getFont(0, 20);

	//  
	public TextBoxField(int width, int height) {

		super(Manager.NO_VERTICAL_SCROLL);
		managerWidth = width;
		managerHeight = height;
		VerticalFieldManager vfm = new VerticalFieldManager(
				Manager.VERTICAL_SCROLL);

		// RIM Color(0x12283f);

		editField = new ExRichTextField("", 0x12283f, Color.WHITE);

		if (font10 != null)
			editField.setFont(font10);

		vfm.add(editField);
		add(vfm);
	}

	public void setColor(int bgColor, int textColor) {

		editField.setColor(bgColor, textColor);

	}

	public void paint(Graphics g) {
		super.paint(g);
		g.setBackgroundColor(Color.BLACK);
		g.drawRect(0, 0, getWidth(), getHeight());
	}

	public void sublayout(int width, int height) {
		if (managerWidth == 0) {
			managerWidth = width;
		}
		if (managerHeight == 0) {
			managerHeight = height;
		}
		super.sublayout(managerWidth, managerHeight);
		setExtent(managerWidth, managerHeight);
	}

	public void setText(String text) {
		editField.setText(text);

		if (editField.getText().length() <= 1)
			return;

		editField.setCursorPosition(editField.getText().length() - 1);
		editField.setFocus();
	}
}

public class ChatScreen extends Screen implements FieldChangeListener

{
	private ChatLayoutManager chatManager;
	private TextBoxField chatView;
	private ContactsScreen _contacts;
	StringBuffer _buf;

	int _userid;
	char[] _usersid = new char[16];

	WebBitmapField wbField = null;

	BasicEditField editField = new BasicEditField("", "") {
		private int iRectX = getFont().getAdvance(getLabel());
		private int iRectWidth = Display.getWidth() - iRectX - 0;

		public void paint(Graphics g) {
			g.setColor(0xFFFFFFFF);
			g.drawRect(iRectX, 0, iRectWidth, Display.getHeight());
			super.paint(g);
		}

	};

	LabelField _title = new LabelField("", LabelField.FOCUSABLE) {

		public void paint(Graphics g) {
			g.setColor(0xFFFFFF);

			super.paint(g);
		}

		protected void paintBackground(net.rim.device.api.ui.Graphics g) {

			g.clear();
			g.getColor();
			g.setColor(Color.BLACK);
			g.fillRect(0, 0, Display.getWidth(), Display.getHeight());
			g.setColor(Color.BLACK);
		}
	};

	public ChatScreen()

	{
		super(new ChatLayoutManager(0), Screen.DEFAULT_CLOSE
				| Screen.DEFAULT_MENU);

		chatManager = (ChatLayoutManager) getDelegate();

		VerticalFieldManager vfm = new VerticalFieldManager(
				Manager.VERTICAL_SCROLL | Manager.VERTICAL_SCROLLBAR);

		editField.setChangeListener(this);

		chatView = new TextBoxField(getWidth(), getHeight()
				- editField.getHeight());

		vfm.add(_title);

		vfm.add(chatView);
		// editField.setChangeListener(this);
		chatManager.setBottomField(editField);
		chatManager.setMainField(vfm);
		_contacts = ((iBlaze) UiApplication.getUiApplication())
				.getContactsScreen();
		setCookie("chat");
		_userid = -1;

	}

	protected void paintBackground(net.rim.device.api.ui.Graphics g) {

		// g.setBackgroundColor(Color.DARKBLUE);
		g.clear();
		g.getColor();
		g.setColor(0x12283f); // 8ABAF1
		g.fillRect(0, 0, Display.getWidth(), Display.getHeight());
		g.setColor(0x12283f);
	}

	protected boolean invokeAction(int action) {

		switch (action) {
		case ACTION_INVOKE:

			// System.out.println( AdMaxLog.getLog());
			if (editField.getText().length() == 0)
				return true;

			XfireContact xcontact = null;//

			xcontact = _contacts.getContactByID(_userid);

			if (xcontact == null) {

				System.out
						.println("ChatScreen:invokeAction no contact was found [ERROR]");
				return super.invokeAction(action);
			}

			_contacts.messageReceived(xcontact._sid, "", editField.getText(),
					true);

			final LoginScreen screen = ((iBlaze) UiApplication
					.getUiApplication()).getScreen();

			try {

				screen._connectThread.sendIMPacket(xcontact._sid, editField
						.getText().toCharArray());

			} catch (IOException e) {
				Status.show(e.toString());
			} finally {

			}

			editField.setText("");
			editField.setFocus();

			return true;
		}
		return super.invokeAction(action);
	}

	protected boolean keyChar(char ch, int status, int time) {

		if (ch == Characters.ENTER) {

			if (editField.getText().length() == 0)
				return true;

			XfireContact xcontact = null;

			xcontact = _contacts.getContactByID(_userid);

			if (xcontact == null) {

				System.out
						.println("ChatScreen:keyChar no contact was found [ERROR]");
				return super.keyChar(ch, status, time);

			}

			_contacts.messageReceived(xcontact._sid, "", editField.getText(),
					true);

			final LoginScreen screen = ((iBlaze) UiApplication
					.getUiApplication()).getScreen();

			try {

				screen._connectThread.sendIMPacket(xcontact._sid, editField
						.getText().toCharArray());
				editField.clear(0);// setText("");
				return true;

			} catch (IOException e) {
				Status.show(e.toString());
			} finally {

			}

		}
		editField.setFocus();

		return super.keyChar(ch, status, time);

	}

	void AddMessage(final int userid, final String msg, final boolean isMe) {

		UiApplication.getUiApplication().invokeLater(new Runnable() {
			public void run() {

				Screen scrn = UiApplication.getUiApplication()
						.getActiveScreen();
				Object obj = scrn.getCookie();

				if (obj instanceof String) {
					String str = (String) obj;

					if (str.equals("chat") && (userid == _userid)) {

						_buf.append(msg);
						_buf.append("\n");

						System.out.println(_buf.toString());

						if (isMe) {
							chatView.setColor(0x12283f, Color.WHITE);

						} else {
							chatView.setColor(0x12283f, Color.WHITE);
						}
						chatView.setText(_buf.toString());

					}

				}

			}
		});

	}

	void UserOffline() {

		UiApplication.getUiApplication().invokeLater(new Runnable() {
			public void run() {

				_buf.append("<This user is now offline>\n");
				chatView.setText(_buf.toString());

			}
		});

	}

	void SetContact(int userid) {

		_userid = userid;

		_buf = null;
		_buf = new StringBuffer();

		LoadHistory();

	}

	void LoadHistory() {

		_contacts = ((iBlaze) UiApplication.getUiApplication())
				.getContactsScreen();

		chatView.setText("");

		XfireContact xcontact = null;

		xcontact = _contacts.getContactByID(_userid);

		if (xcontact == null) {

			xcontact = (XfireContact) _contacts.getClanMemberByID(_userid);
		}

		if (xcontact == null) {

			System.out
					.println("ChstScreeen:LoadHistory no contact was found [ERROR]");
			return;
		}

		StringBuffer buf = new StringBuffer("Chatting with ");

		try {

			buf.append(new String(xcontact._cNickname, "UTF-8"));

			_title.setText(buf.toString());

		} catch (UnsupportedEncodingException e)

		{

		}

		for (int i = 0; i < xcontact._messages_count; i++) {

			_buf.append(xcontact._messages[i]);
			_buf.append("\n");

			chatView.setText(_buf.toString());

		}

	}

	protected void sublayout(int width, int height)

	{
		setPositionDelegate(0, 0);
		layoutDelegate(width, height);
		setPosition(0, 0);
		setExtent(width, height);
	}

	public void fieldChanged(Field field, int context) {

	}

}
