
import net.rim.device.api.ui.Field;
import net.rim.device.api.ui.Manager;

public class ChatLayoutManager extends Manager {

	private Field bottomField;
	private Field mainField;
	private Field titleField;

	public ChatLayoutManager(long style) {
		super(style);
	}

	protected void sublayout(int width, int height) {
		setExtent(width, height);

		int y = 0;
		if (bottomField != null) {
			layoutChild(bottomField, width, height);
			// This goes at the bottom of the screen
			setPositionChild(bottomField, 0, height - bottomField.getHeight());
			height -= bottomField.getHeight();
		}

		if (titleField != null) {
			layoutChild(titleField, width, height);
			// This goes at the top of the screen
			setPositionChild(titleField, 0, 0);
			height -= titleField.getHeight();
			y += titleField.getHeight();
		}

		if (mainField != null) {
			layoutChild(mainField, width, height);
			// This goes just below the title field (if any)
			setPositionChild(mainField, 0, y);
		}

	}

	public void setMainField(Field f) {
		mainField = f;
		add(f);
	}

	public void setBottomField(Field f) {
		bottomField = f;
		add(f);
	}

	public void setTitleField(Field f) {
		titleField = f;
		add(f);
	}
}
