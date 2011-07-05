/*
 * Main.java
 *
 * © <your company here>, <year>
 * Confidential and proprietary.
 */

//import com.gamepe.admax.sdk.xfmobile.AdMaxLog;
//import com.gamepe.admax.sdk.xfmobile.AdMaxManager;

import net.rim.device.api.system.ApplicationDescriptor;
import net.rim.device.api.system.CodeModuleManager;
import net.rim.device.api.ui.*;

class iBlaze extends UiApplication // implements KeyListener

{

	LoginScreen _screen;
	ContactsScreen _contactsScrn;

	/*
	 * static EncodedImage mImageIndicator =
	 * EncodedImage.getEncodedImageResource("bb_icon.png"); static
	 * ApplicationIcon mIconIndicator = new ApplicationIcon(mImageIndicator);
	 * static ApplicationIcon mIcon = mIconIndicator;
	 */

	static int _mMsgRecived = 0;

	static boolean _isIndicatorRegisterd = false;
	static boolean _isMinimized = false;

	public static void main(String[] args) {
		// Create a new instance of the application and make the currently
		// running thread the application's event dispatching thread.

		iBlaze app = new iBlaze();
		
	  
		app.enterEventDispatcher();
		// 
	}

	// Constructor
	public iBlaze() {

		_screen = new LoginScreen();

		pushScreen(_screen);

	}

	static void updateIndicatorValue(boolean update) {

		/*
		 * if (_isIndicatorRegisterd==false) registerIndicator();
		 * 
		 * try {
		 * 
		 * if (update==false){
		 * 
		 * unregisterIndicator(); _mMsgRecived=0; return; }
		 * 
		 * else _mMsgRecived++;
		 * 
		 * ApplicationIndicatorRegistry reg = ApplicationIndicatorRegistry
		 * .getInstance(); ApplicationIndicator appIndicator =
		 * reg.getApplicationIndicator(); appIndicator.setValue(_mMsgRecived); }
		 * catch (Exception e) {
		 * 
		 * }
		 */
	}

	/*
	 * void updateIcon(ApplicationIcon icon) { /* try {
	 * ApplicationIndicatorRegistry reg = ApplicationIndicatorRegistry
	 * .getInstance(); ApplicationIndicator appIndicator =
	 * reg.getApplicationIndicator(); appIndicator.setIcon(icon); } catch
	 * (Exception e) { } }
	 * 
	 * static private void registerIndicator() { /* try {
	 * ApplicationIndicatorRegistry reg = ApplicationIndicatorRegistry
	 * .getInstance(); ApplicationIndicator indicator = reg.register(mIcon,
	 * false, true); _isIndicatorRegisterd=true; } catch (Exception e) {
	 * 
	 * System.out.println("registerIndicator Exception"); } }
	 * 
	 * static public void unregisterIndicator() { /* try {
	 * ApplicationIndicatorRegistry reg = ApplicationIndicatorRegistry
	 * .getInstance(); reg.unregister(); _isIndicatorRegisterd=false; } catch
	 * (Exception e) { } } /*
	 * 
	 * 
	 * 
	 * public void activate() {
	 * 
	 * 
	 * // com.flurry.blackberry.FlurryAgent.onStartApp("J1WS1S3S7NHW9KTELIBC");
	 * 
	 * _isMinimized=false; updateIndicatorValue(false); } /** Provides access to
	 * this application's UI screen
	 * 
	 * @return This application's UI screen.
	 */

	public boolean keyUp(int keycode, int time) {

		return false;
	}

	public boolean keyRepeat(int keycode, int time) {

		return false;
	}

	public boolean keyChar(char key, int status, int time) {

		return false;
	}

	public boolean keyStatus(int keycode, int time) {

		return false;

	}

	ContactsScreen allocContactsScreen() {
		if (_contactsScrn != null)
			return _contactsScrn;
		_contactsScrn = new ContactsScreen();
		return _contactsScrn;
	}

	ContactsScreen getContactsScreen() {

		return _contactsScrn;
	}

	LoginScreen getScreen() {
		return _screen;
	}
}
