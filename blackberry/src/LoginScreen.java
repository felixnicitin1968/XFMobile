/*
 * LoginScreen.java
 *
 * © Moti Joseph 2009
 * Confidential and proprietary.
 */
//javaloader -usb load <module>

//javaloader -usb erase -f <module>

import net.rim.device.api.system.*;
import net.rim.device.api.ui.*;
import net.rim.device.api.ui.component.*;
import net.rim.device.api.ui.container.*;

import net.rim.blackberry.api.invoke.*;

class LoginScreen extends CustomMainScreen implements FieldChangeListener {

	HorizontalFieldManager _fieldManagerTop;
	VerticalFieldManager _fieldManagerMiddle;
	GridFieldManager _fieldManagerBottom;
	ConnectThread _connectThread;
	BitmapField _bitmap;
	Bitmap _iBlazeLogo;
	private BasicEditField _usernameField;
	private PasswordEditField _passwordField;
	private ButtonField _loginbutton;
	private ButtonField _logoffbutton;

	LabelField _version = new LabelField("v6.0");
	CheckboxField _chkDirectTCP = new CheckboxField("Force Direct TCP", false);

	boolean _bDirectTCP = false;
	String _username;
	String _password;
	boolean _isConnected;
	boolean _isTringToConnect;

	private static PersistentObject _store;

	static {

		_store = PersistentStore.getPersistentObject(0x7d3bef58d4736530L);

	}

	LoginScreen() {

		LabelField title = new LabelField("Xfire login", LabelField.ELLIPSIS
				| LabelField.USE_ALL_WIDTH | LabelField.FIELD_VCENTER);
		setTitle(title);

		setCookie("login");

		_isTringToConnect = false;
		_isConnected = false;

		_fieldManagerTop = new HorizontalFieldManager() {

			public void paint(Graphics graphics) {
				graphics.setBackgroundColor(0x12283f);
				graphics.clear();
				super.paint(graphics);
			}

		};

		_fieldManagerMiddle = new VerticalFieldManager() {

			public void paint(Graphics graphics) {
				graphics.setBackgroundColor(0x12283f);
				graphics.clear();
				super.paint(graphics);
			}

		};

		_fieldManagerBottom = new GridFieldManager(1, 0) {

			public void paint(Graphics graphics) {
				graphics.setBackgroundColor(0x12283f);
				graphics.clear();
				super.paint(graphics);
			}

		};

		add(_fieldManagerTop);
		add(new SeparatorField());
		add(_fieldManagerMiddle);

		add(_fieldManagerBottom);

		_bitmap = new BitmapField();
		_iBlazeLogo = Bitmap.getBitmapResource("logoxf.png");
		_bitmap.setBitmap(_iBlazeLogo);
		_fieldManagerTop.add(_bitmap);

		_usernameField = new BasicEditField("username: ", "");
		_passwordField = new PasswordEditField("password: ", "");

		_fieldManagerMiddle.add(_usernameField);
		_fieldManagerMiddle.add(_passwordField);
		_fieldManagerMiddle.add(new SeparatorField());

		_fieldManagerMiddle.add(_chkDirectTCP);

		_fieldManagerMiddle.add(_version);

		_loginbutton = new ButtonField("Login", Field.FIELD_HCENTER);

		_logoffbutton = new ButtonField("Logoff", Field.FIELD_HCENTER);

		_fieldManagerBottom.add(_loginbutton);

		_logoffbutton.setChangeListener(this);
		_loginbutton.setChangeListener(this);

		synchronized (_store) {

			if (_store.getContents() == null) {

			} else {

				String[] userinfo = (String[]) _store.getContents();
				_password = userinfo[1];
				_username = userinfo[0];

				_usernameField.setText(userinfo[0]);
				_passwordField.setText(userinfo[1]);
			}

		}

	}

	public boolean trackwheelClick(int status, int time) {

		if (_loginbutton.isFocus()) {

			login();

		} else if (_logoffbutton.isFocus()) {

			logoff();
		}
		return true;
	}

	protected boolean onSavePrompt() {

		return true;
	}

	protected void makeMenu(Menu menu, int instance)

	{

		menu.deleteAll();

		menu.add(new MenuItem("Send us email", 102, 102) {

			public void run() {

				MessageArguments mArgs = new MessageArguments(
						MessageArguments.ARG_NEW, "moti@gamepe.com",
						"XfMobile BB support", "");
				Invoke.invokeApplication(Invoke.APP_TYPE_MESSAGES, mArgs);

			}

		});

		menu.add(new MenuItem("Minimize", 103, 103) {

			public void run() {

				iBlaze._isMinimized = true;

				UiApplication.getUiApplication().requestBackground();

			}

		});

		menu.add(new MenuItem("Exit", 104, 104) {

			public void run() {
				// iBlaze.unregisterIndicator();
				System.exit(0);

			}

		});

		// super.makeMenu(menu, instance);

	}

	boolean isTCP() {

		return _chkDirectTCP.getChecked();
	}

	void OnNoConnection(final String str)

	{

		_isTringToConnect = false;
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
				Dialog
						.alert("Cannot connect to network internet connectivity is required.");
				if (_logoffbutton.getIndex() == (_loginbutton.getIndex() + 1)) {

					_fieldManagerBottom.delete(_logoffbutton);

				}

				while (true) { // popup all screens

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

			}
		});
	}

	String getPassword() {

		return _password;

	}

	String getUsername() {

		return _username.toLowerCase();
	}

	protected void onFocusNotify(boolean focus)

	{

		if (_isConnected) {

			if (_logoffbutton.getIndex() != _loginbutton.getIndex() + 1) {

				_fieldManagerBottom.insert(_logoffbutton, _loginbutton
						.getIndex() + 1);

			}

			_loginbutton.setLabel("Contacts");

			_isTringToConnect = false;

		} else {

			_loginbutton.setLabel("Login");

		}
	}

	void showContacts() {

		if (_isConnected == true)
			return;

		_isConnected = true;
		UiApplication.getUiApplication().invokeAndWait(new Runnable() {
			public void run() {

				UiApplication.getUiApplication().pushScreen(
						((iBlaze) UiApplication.getUiApplication())
								.getContactsScreen());

			}
		});
	}

	public void logoff() {

		if (_connectThread != null) {
			_loginbutton.setLabel("Login");
			_connectThread.quit();
			_connectThread = null;
			_isConnected = false;

		}

		if (_logoffbutton.getIndex() == (_loginbutton.getIndex() + 1)) {

			_fieldManagerBottom.delete(_logoffbutton);

		}

	}

	public void login() {

		_username = _usernameField.getText();
		_password = _passwordField.getText();

		if (_username.length() == 0 || _password.length() == 0)
			return;

		String[] userinfo = { _username, _password };

		synchronized (_store) {

			_store.setContents(userinfo);

			_store.commit();

		}

		if (_isTringToConnect) {

			System.out.println("Tring to connect");
			return;

		}

		_isTringToConnect = true;

		if (!_isConnected) {

			_connectThread = new ConnectThread();
			_connectThread.start();

		} else {

			UiApplication.getUiApplication().pushScreen(
					((iBlaze) UiApplication.getUiApplication())
							.getContactsScreen());

		}

	}

	public void fieldChanged(Field field, int context) // respond to button
														// events
	{

		if (field == _logoffbutton) {

			logoff();

		}

		if (field == _loginbutton) // if first button selected
		{

			login();

		}

	}

	public void close() {

		iBlaze._isMinimized = true;

		// AdMaxManager.exit();

		UiApplication.getUiApplication().requestBackground();

		// super.close();

	}
}
