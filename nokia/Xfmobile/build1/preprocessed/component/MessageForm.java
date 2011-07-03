package component;

import javax.microedition.lcdui.Command;
import javax.microedition.lcdui.CommandListener;
import javax.microedition.lcdui.Display;
import javax.microedition.lcdui.Displayable;
import javax.microedition.lcdui.Form;
import javax.microedition.lcdui.Item;
import javax.microedition.lcdui.ItemCommandListener;
import javax.microedition.lcdui.TextField;
import xfire.XFMobileMidlet;


public class MessageForm extends Form  implements CommandListener, ItemCommandListener{



        private MainCanvas mainCanvas;
	private Display d;
	private TextField tb;//Type new message here

	private RichText statusHolder;
	Command send;//Send Command
	Command toList;//Close roster Command

        int userid;
	
	
	public MessageForm(Display d,MainCanvas mainCanvas,int userid) {
		
                super("xfmobile chat");
		
                setTitle( "Chatting..." );
                this.mainCanvas = mainCanvas;
                this.userid=userid;
		this.d = d;
		
		statusHolder = new RichText(d);

		statusHolder.setCanvasWidth(getWidth());

		//statusHolder.finish();
		tb = new TextField(null, "", 2000, TextField.ANY);
		append(statusHolder);
		append(tb);
		send = new Command("Send", Command.OK, 0);
		
		toList = new Command("Friends", Command.EXIT, 0);
		addCommand(toList);
                addCommand(send);
		setCommandListener(this);
		// TODO Auto-generated constructor stub

              
	}

	
	/**
	 * @param s Input string
	 * @return returns modified for history viewing String
	 */
	public String enlargeStr(String s)
	{
		return s+"\n";
	}
	
	/**
	 * Starts form
	 */

        public void AddConv(int userid,String message)
	{


             XfireContact xfcontact=CoreService.getContactByUSERID(userid);

             if (xfcontact==null) return;

             xfcontact._messages[xfcontact._nTotalMessages]=new String(xfcontact._cNickname)+":"+enlargeStr(message);

             xfcontact._nTotalMessages++;


             if (xfcontact._nTotalMessages==10){


              xfcontact._nTotalMessages=0;


             }

	    if (this.userid==userid){


                     statusHolder.addContent(new String(xfcontact._cNickname)+":"+enlargeStr(message));
            }
                 

                          
                     



                  
                    

                
	}

        public void loadHistry()
        {

               reset();
              XfireContact xfcontact=CoreService.getContactByUSERID(this.userid);

                      if (xfcontact!=null){

                          for (int i=0; i<xfcontact._nTotalMessages; i++){

                              statusHolder.addContent(xfcontact._messages[i]);

                          }

                      }
               d.setCurrentItem(tb);
              

        }
        public void reset()
	{

		statusHolder.reset();
	}

        public void setUserID(int userid)
	{

		this.userid=userid;
	}
	public void startForm()
	{


		d.setCurrent(this);
		loadHistry();
                d.setCurrentItem(tb);

                System.out.println("Current set");
	}

	public void commandAction(Command arg0, Displayable arg1) {
		// TODO Auto-generated method stub
		if(arg0.equals(send)&&!tb.getString().trim().equals(""))
		{
			/*
			 * Send Command pushed and TextField is not empty.
			 * Sends typed message by sending apropriate jabber packet
			 * */

                    String msg = tb.getString();
                    if(!msg.equals("")) {


                      XfireContact xfcontact=CoreService.getContactByUSERID(userid);

                      if (xfcontact!=null){

                        System.out.println("user was found sending message......");

                          xfcontact._messages[xfcontact._nTotalMessages]=XfireService._myNickname+":"+enlargeStr(tb.getString());

                           xfcontact._nTotalMessages++;


                         if (xfcontact._nTotalMessages==10){


                             xfcontact._nTotalMessages=0;

                         }
                        statusHolder.addContent(XfireService._myNickname+":"+enlargeStr(tb.getString()));
			tb.setString(""); //Clear TextField for new message typing
                         mainCanvas.sendMessage(userid,"", "", msg);



                       }
                    }

                     
			return;
		}
		if(arg0.equals(toList))
		{

                        XFMobileMidlet.switchUI(XFMobileMidlet.mainCanava);
			return;
			//Close form
		}
	}

	
	private int findPosition(Item it)
	{
		for(int i=2; i<this.size(); i++)
		{
			if(this.get(i).equals(it))
				return i-2;
		}
		return -1;
	}
	
	
	public void commandAction(Command arg0, Item arg1) {
		// TODO Auto-generated method stub
		int pos = findPosition(arg1);
		if(pos==-1)
			return;
		d.setCurrentItem(tb);

	}

	

	
	
}
