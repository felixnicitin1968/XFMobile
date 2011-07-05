
public interface EventListener

{

	void connectionEstablished();

	void connectionClosed();

	void connectionError(final String err);

	void messageReceived(byte[] usersid, String email, String message,
			boolean bMe);

	void messageError(final String id);

	void Addfriend(final int userid, String email, String name);

	void Removefriend(final int userid, String email);

	void friendStateChanged(String email, int state);

	void friendStatusChanged(byte[] usersid, String smsg);

	void friendGameStateChanged(byte[] usersid, int gameid);

	void addClanGroup(final int clanid);

	void switchToTypingMode();

}
