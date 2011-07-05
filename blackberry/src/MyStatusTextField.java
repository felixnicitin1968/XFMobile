
import net.rim.device.api.ui.Manager;
import net.rim.device.api.ui.Field;
import net.rim.device.api.ui.component.EditField;
import net.rim.device.api.system.Display;
import net.rim.device.api.system.Characters;
import net.rim.device.api.ui.Graphics;
import net.rim.device.api.ui.Font;

import java.io.*;

import net.rim.device.api.ui.*;
import net.rim.device.api.ui.component.*;

import net.rim.device.api.ui.FontFamily;

public class MyStatusTextField extends Manager {

	private final static int DEFAULT_LEFT_MARGIN = 10;
	private final static int DEFAULT_RIGHT_MARGIN = 10;
	private final static int DEFAULT_TOP_MARGIN = 5;
	private final static int DEFAULT_BOTTOM_MARGIN = 5;

	private final static int DEFAULT_LEFT_PADDING = 10;
	private final static int DEFAULT_RIGHT_PADDING = 10;
	private final static int DEFAULT_TOP_PADDING = 5;
	private final static int DEFAULT_BOTTOM_PADDING = 5;

	private int topMargin = DEFAULT_TOP_MARGIN;
	private int bottomMargin = DEFAULT_BOTTOM_MARGIN;
	private int leftMargin = DEFAULT_LEFT_MARGIN;
	private int rightMargin = DEFAULT_RIGHT_MARGIN;

	private int topPadding = DEFAULT_TOP_PADDING;
	private int bottomPadding = DEFAULT_BOTTOM_PADDING;
	private int leftPadding = DEFAULT_LEFT_PADDING;
	private int rightPadding = DEFAULT_RIGHT_PADDING;

	private int totalHorizontalEmptySpace = leftMargin + leftPadding
			+ rightPadding + rightMargin;
	private int totalVerticalEmptySpace = topMargin + topPadding
			+ bottomPadding + bottomMargin;

	private int minHeight = getFont().getHeight() + totalVerticalEmptySpace;
	private int width = Display.getWidth();
	private int height = minHeight;

	private EditField editField;

	final FontFamily fontFamily[] = FontFamily.getFontFamilies();

	final Font font10 = fontFamily[0].getFont(0, 18);

	public MyStatusTextField() {
		super(0);

		editField = new EditField() {

			protected void onUnfocus()

			{

				LoginScreen screen = null;
				screen = ((iBlaze) UiApplication.getUiApplication())
						.getScreen();
				try {

					screen._connectThread.sendMyStatusMessagePacket(editField
							.getText().toCharArray());

				} catch (IOException e) {
					Status.show(e.toString());
				} finally {

				}

			}
		};

		add(editField);
		if (font10 != null)
			editField.setFont(font10);

	}

	protected void sublayout(int width, int height) {
		Field field = getField(0);
		layoutChild(field, this.width - totalHorizontalEmptySpace, this.height
				- totalVerticalEmptySpace);
		setPositionChild(field, leftMargin + leftPadding, topMargin
				+ topPadding);
		setExtent(this.width, this.height);
	}

	/*
	 * public void setTopMargin(int topMargin) { this.topMargin = topMargin; }
	 * 
	 * public void setBottomMargin(int bottomMargin) { this.bottomMargin =
	 * bottomMargin; }
	 */

	protected void paint(Graphics graphics) {
		graphics.drawRoundRect(leftMargin, topMargin, width
				- (leftMargin + rightMargin), height
				- (topMargin + bottomMargin), 5, 5);

		EditField ef = (EditField) getField(0);
		String entireText = ef.getText();

		String textToDraw = "";
		Font font = getFont();
		int availableWidth = width - totalHorizontalEmptySpace;
		if (font.getAdvance(entireText) <= availableWidth) {
			textToDraw = entireText;
		} else {
			int endIndex = entireText.length();
			for (int beginIndex = 1; beginIndex < endIndex; beginIndex++) {
				textToDraw = entireText.substring(beginIndex);
				if (font.getAdvance(textToDraw) <= availableWidth) {
					break;
				}
			}
		}

		ef.setText(textToDraw);
		graphics.setColor(0xFFFFFFFF);
		super.paint(graphics);

	}

	public int getPreferredWidth() {
		return width;
	}

	public int getPreferredHeight() {
		return height;
	}

	protected boolean keyChar(char ch, int status, int time) {
		if (ch == Characters.ENTER) {

			return true;
		} else {
			return super.keyChar(ch, status, time);
		}
	}

	/*
	 * public String getText() { return ((EditField)getField(0)).getText(); }
	 */
	public void setText(final String text) {
		((EditField) getField(0)).setText(text);
	}
}
