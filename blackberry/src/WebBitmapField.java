/*
 * WebBitmapField .java
 *
 * © <your company here>, <year>
 * Confidential and proprietary.
 */

import net.rim.device.api.ui.component.BitmapField;
import net.rim.device.api.system.EncodedImage;
import java.io.IOException;
import javax.microedition.io.Connector;
import javax.microedition.io.HttpConnection;
import javax.microedition.lcdui.Graphics;
import javax.microedition.lcdui.Image;

import java.io.InputStream;

import net.rim.device.api.ui.UiApplication;
import net.rim.device.api.system.Bitmap;

import net.rim.device.api.system.*;

import net.rim.device.api.ui.component.*;

import net.rim.device.api.servicebook.*;

public class WebBitmapField extends BitmapField implements WebDataCallback {
	private EncodedImage bitmap = null;

	static WebBitmapField thisObject;

	public WebBitmapField(String url) {

		thisObject = this;
	}

	static public void getImage(String url) {
		try {
			getWebData(url, thisObject);
		} catch (Exception e) {
			System.out.println("WebBitmapField:getImage failed");
		}
	}

	public Bitmap getBitmap() {
		if (bitmap == null)
			return null;
		return bitmap.getBitmap();
	}

	public void callback(final String data) {

		if (data.startsWith("Exception"))
			return;

		try {

			byte[] dataArray = data.getBytes();
			bitmap = EncodedImage.createEncodedImage(dataArray, 0,
					dataArray.length);

			setImage(bitmap);
		} catch (final Exception e) {
		}
	}

	private static String getCarrierBIBSUid() {
		ServiceRecord[] records = ServiceBook.getSB().getRecords();
		int currentRecord;

		for (currentRecord = 0; currentRecord < records.length; currentRecord++) {
			if (records[currentRecord].getCid().toLowerCase().equals("ippp")) {
				if (records[currentRecord].getName().toLowerCase().indexOf(
						"bibs") >= 0) {
					return records[currentRecord].getUid();
				}
			}
		}

		return null;
	}

	private static String getConnectionString() {
		// This code is based on the connection code developed by Mike Nelson of
		// AccelGolf.
		// http://blog.accelgolf.com/2009/05/22/blackberry-cross-carrier-and-cross-network-http-connection
		String connectionString = null;

		// Simulator behavior is controlled by the USE_MDS_IN_SIMULATOR
		// variable.
		if (DeviceInfo.isSimulator()) {

			System.out
					.println("Device is a simulator and USE_MDS_IN_SIMULATOR is false");
			connectionString = ";deviceside=true";

		}

		// Wifi is the preferred transmission method
		else if (WLANInfo.getWLANState() == WLANInfo.WLAN_STATE_CONNECTED) {
			System.out.println("Device is connected via Wifi.");
			connectionString = ";interface=wifi";
		}

		// Is the carrier network the only way to connect?
		else if ((CoverageInfo.getCoverageStatus() & CoverageInfo.COVERAGE_DIRECT) == CoverageInfo.COVERAGE_DIRECT) {
			System.out.println("Carrier coverage.");

			String carrierUid = getCarrierBIBSUid();
			if (carrierUid == null) {
				// Has carrier coverage, but not BIBS. So use the carrier's TCP
				// network
				System.out.println("No Uid");
				connectionString = ";deviceside=true";
			} else {
				// otherwise, use the Uid to construct a valid carrier BIBS
				// request
				System.out.println("uid is: " + carrierUid);
				connectionString = ";deviceside=false;connectionUID="
						+ carrierUid + ";ConnectionType=mds-public";
			}
		}

		// Check for an MDS connection instead (BlackBerry Enterprise Server)
		else if ((CoverageInfo.getCoverageStatus() & CoverageInfo.COVERAGE_MDS) == CoverageInfo.COVERAGE_MDS) {
			System.out.println("MDS coverage found");
			connectionString = ";deviceside=false";
		}

		// If there is no connection available abort to avoid bugging the user
		// unnecssarily.
		else if (CoverageInfo.getCoverageStatus() == CoverageInfo.COVERAGE_NONE) {
			Status.show("There is no available connection.");

		}

		// In theory, all bases are covered so this shouldn't be reachable.
		else {
			System.out.println("no other options found, assuming device.");
			connectionString = ";deviceside=true";
		}

		return connectionString;
	}

	public static void getWebData(final String url,
			final WebDataCallback callback) throws IOException {
		Thread t = new Thread(new Runnable() {
			public void run() {
				HttpConnection connection = null;
				InputStream inputStream = null;

				try {

					String _url = url;

					_url = _url + getConnectionString();
					connection = (HttpConnection) Connector.open(_url);

					inputStream = connection.openInputStream();
					byte[] responseData = new byte[10 * 1024];
					int length = 0;
					StringBuffer rawResponse = new StringBuffer();
					while (-1 != (length = inputStream.read(responseData))) {
						rawResponse.append(new String(responseData, 0, length));
					}

					int responseCode = connection.getResponseCode();
					if (responseCode != HttpConnection.HTTP_OK) {
						throw new IOException("HTTP response code: "
								+ responseCode);
					}

					final String result = rawResponse.toString();
					UiApplication.getUiApplication().invokeLater(
							new Runnable() {
								public void run() {
									callback.callback(result);
								}
							});
				} catch (final Exception ex) {
					UiApplication.getUiApplication().invokeLater(
							new Runnable() {
								public void run() {
									callback.callback("Exception ("
											+ ex.getClass() + "): "
											+ ex.getMessage());
								}
							});
				} finally {
					try {
						inputStream.close();
						inputStream = null;
						connection.close();
						connection = null;
					} catch (Exception e) {
					}
				}
			}
		});
		t.start();
	}
}
