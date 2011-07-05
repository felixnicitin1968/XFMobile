/*
 * CustomMainScreen.java
 *
 * © <your company here>, <year>
 * Confidential and proprietary.
 */

import net.rim.device.api.system.*;
import net.rim.device.api.ui.*;

import net.rim.device.api.ui.container.*;

import net.rim.device.api.ui.Manager;

class CustomMainScreen extends MainScreen {

	private VerticalFieldManager _container;

	CustomMainScreen() {
		super(Manager.NO_VERTICAL_SCROLL | Manager.NO_VERTICAL_SCROLLBAR);

		VerticalFieldManager internalManager = new VerticalFieldManager(
				Manager.NO_VERTICAL_SCROLL | Manager.NO_VERTICAL_SCROLLBAR) {

			protected void paint(Graphics graphics) {
				graphics.setColor(Color.WHITE);
				super.paint(graphics);
			}

			public void paintBackground(Graphics g) {
				g.clear();
				int color = g.getColor();
				g.setColor(0x12283f);
				g.fillRect(0, 0, Display.getWidth(), Display.getHeight());
				g.setColor(color);

			}

			protected void sublayout(int maxWidth, int maxHeight) {
				Field titleField = getMyTitleField();
				int titleFieldHeight = 0;
				if (titleField != null) {
					titleFieldHeight = titleField.getHeight();
				}

				int displayWidth = Display.getWidth(); // I would probably make
														// these global
				int displayHeight = Display.getHeight();

				super.sublayout(displayWidth, displayHeight - titleFieldHeight);
				setExtent(displayWidth, displayHeight - titleFieldHeight);
			}

		};
		_container = new VerticalFieldManager(Manager.VERTICAL_SCROLL
				| Manager.VERTICAL_SCROLLBAR);
		internalManager.add(_container);
		super.add(internalManager);
	}

	public void add(Field field) {
		_container.add(field);
	}

	public void delete(Field field) {
		_container.delete(field);
	}

	public void deleteAll() {
		_container.deleteAll();
	}

	private Field getMyTitleField() {
		Manager delegate = getDelegate();
		Field titleField = null;
		try {
			titleField = delegate.getField(0);
		} catch (IndexOutOfBoundsException ioobe) {
			//
		}
		return titleField;
	}
}
