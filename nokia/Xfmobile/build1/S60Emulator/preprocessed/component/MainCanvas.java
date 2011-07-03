package component;

/**
 * Copyright 2006 the original author or authors.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import java.io.IOException;
import  xfire.XFMobileMidlet;
import  xfire.*;
import  javax.microedition.lcdui.*;
import InnerActiveSDK.IASDK;
//import com.javaeedev.midp.gtalk.component.*;
//import Xfmobile.src.component.component.*;

/**
 * Main interface.
 * 
 * @author Michael Liao (askxuefeng@gmail.com)
 */
public class MainCanvas extends Canvas implements EventListener, CommandListener {

    private final Font font;
    private final int width;
    private final int height;

    public static int COLOR_BACKGROUND;
    public static int COLOR_FOREGROUND;
    public static int COLOR_BORDER;

    public static int COLOR_HIGHLIGHTED_BACKGROUND;
    public static int COLOR_HIGHLIGHTED_FOREGROUND;
    public static int COLOR_HIGHLIGHTED_BORDER;

    public static int BORDER_STYLE;
    public static int BORDER_STYLE_HIGHLIGHTED;

    // commands:
    private Command cancelLogin = new Command("Cancel", Command.CANCEL, 0);
    private Command back = new Command("Options", Command.BACK, 0);
    private Command newMessage = new Command("New Msg", Command.OK, 0);
    private Command openMessage = new Command("Open Msg", Command.OK, 0);
    private Command GoTofriends = new Command("Friends", Command.EXIT, 0);

    final static int DISPLAY_AD = 2;
    final static int IDLE = 0;
    // core service:
    private boolean loggedIn = false;
    private String processMessage = "Signing in...";
    private XfireService service;
    private MessageForm  msgform=null;


    // ui components:
    TabSelect tab;
    ScrollBar scroll;
    FriendList friendList;
    MessageList messageList;
    ClansList   clansList;
    ConvList    convList;
    EmptyPanel empty;
  


    public MainCanvas(String username, String password) {
        setCommandListener(this);
        // init canvas constants:

      //  setTitle( "Friends" );
        width = getWidth();
        height = getHeight();

        // init colors & styles:
        Display display =XFMobileMidlet.getDisplay();
        COLOR_BACKGROUND = display.getColor(Display.COLOR_BACKGROUND);
        COLOR_FOREGROUND = display.getColor(Display.COLOR_FOREGROUND);
        COLOR_BORDER = display.getColor(Display.COLOR_BORDER);
        COLOR_HIGHLIGHTED_BACKGROUND = display.getColor(Display.COLOR_HIGHLIGHTED_BACKGROUND);
        COLOR_HIGHLIGHTED_FOREGROUND = display.getColor(Display.COLOR_HIGHLIGHTED_FOREGROUND);
        COLOR_HIGHLIGHTED_BORDER = display.getColor(Display.COLOR_HIGHLIGHTED_BORDER);

        // init font:
        font = Font.getFont(Font.FACE_SYSTEM, Font.STYLE_PLAIN, Font.SIZE_MEDIUM);

        BORDER_STYLE = display.getBorderStyle(false);
        BORDER_STYLE_HIGHLIGHTED = display.getBorderStyle(true);

        // init ui components:
        // tab's hight is 23:
        final int BASE_TOP = 24;
        final int SCROLL_WIDTH = 15;
        final int SCALE_WIDTH = width - SCROLL_WIDTH;
        final int SCALE_HEIGHT = height - BASE_TOP;

        scroll = new ScrollBar(SCALE_WIDTH, BASE_TOP, SCALE_HEIGHT, font);
        scroll.setVisible(true);

        Image[] status = new Image[4];
        try {
            for(int i=0; i<4; i++) {
                status[i] = Image.createImage("/img/s" + i + ".png");
            }
        }
        catch(Exception e) {
            throw new Error("Failed loading resource.");
        }
        friendList = new FriendList(0, BASE_TOP, SCALE_WIDTH, SCALE_HEIGHT, font, status, scroll);

        convList = new ConvList(0, BASE_TOP, SCALE_WIDTH, SCALE_HEIGHT, font, status, scroll);

        clansList=new ClansList(0, BASE_TOP, SCALE_WIDTH, SCALE_HEIGHT, font, status, scroll);
        

        messageList = new MessageList(0, BASE_TOP, SCALE_WIDTH, SCALE_HEIGHT, font, scroll);

        empty = new EmptyPanel(0, BASE_TOP, width, SCALE_HEIGHT, font);

        tab = new TabSelect(
                0, 1, width, font,
                new ComponentUI[] {messageList, friendList,convList , clansList}
        );
        tab.setVisible(true);

        // init service:
        service = new XfireService(this);
        msgform=new MessageForm(XFMobileMidlet.getDisplay(),this,-1);
        service.connect(username, password);
      
    }


     public void sendMyNicknamePacket(char []nickname) throws IOException {


        service.sendChangeNickPacket(nickname);

    }

       public void sendMyStatusPacket(char []status) throws IOException {


        service.sendChanageMyStatusPacket(status);

    }



    public void sendMessage(int userid,String name, String email, String message) {

         System.out.println("sendMessage: userid=" + userid+"\n");


        service.sendIMPacker(userid,email, message);
        messageList.addSentMessage(name, message);
    }

    protected void keyPressed(int key) {
        if(!loggedIn)
            return;
        boolean selectionChanged = false;
        boolean needRepaint = false;
        switch(getGameAction(key)) {
        case Canvas.LEFT:
              if(convList.getVisible())
                    repaint();

            selectionChanged = tab.moveLeft();
            break;
        case Canvas.RIGHT:
              if(convList.getVisible())
                    repaint();

            selectionChanged = tab.moveRight();
            break;
        case Canvas.UP:



            if(convList.getVisible())
                needRepaint = convList.moveUp();
            if(friendList.getVisible())
                needRepaint = friendList.moveUp();
            else if(messageList.getVisible())
                needRepaint = messageList.moveUp();
            break;
        case Canvas.DOWN:

             if(convList.getVisible())
                needRepaint = convList.moveDown();
            if(friendList.getVisible())
                needRepaint = friendList.moveDown();
            else if(messageList.getVisible())
                needRepaint = messageList.moveDown();
            break;
        }
        if(selectionChanged) {
            switch(tab.getSelection()) {
            case 1:
                removeCommand(GoTofriends);
                removeCommand(openMessage);
                addCommand(back);
                addCommand(newMessage);
                break;
            case 2:
                removeCommand(back);
                addCommand(openMessage);
                addCommand(GoTofriends);
                removeCommand(newMessage);
                break;
            default:
                removeCommand(GoTofriends);
                removeCommand(openMessage);
                removeCommand(newMessage);
            }
        }
        if(selectionChanged || needRepaint) {
            repaint();
        }
    }

    protected void paint(Graphics g) {

        
        g.setFont(font);
        g.setColor(COLOR_BACKGROUND);
        g.fillRect(0, 0, width, height);

        
     
        if(loggedIn){//XfireService. _isConnected) {
            loggedIn = true;
            tab.paint(g);
        }
        else {
            // show log in...
             addCommand(cancelLogin);
            g.setColor(COLOR_FOREGROUND);
            g.drawString(processMessage, width/2, height/2, Graphics.BASELINE|Graphics.HCENTER);
        }
    }

    public void connectionClosed() {
        System.out.println("connectionClosed.");
    }

    public void connectionError(String err) {
        setToErrorMode(err);
        System.out.println("connectionError: " + err);
    }

    public void connectionEstablished() {
      
           System.out.println("connectionEstablished.");
           setToChatMode();
    }

    private void setToChatMode() {


        System.out.println("setToChatModesetToChatMode\n");
        loggedIn = true;
        removeCommand(cancelLogin);
        addCommand(newMessage);
        addCommand(back);
    
      
        repaint();
     
       /* new Thread() {
            public void run() {
                service.getRoster();
                service.setState(Friend.NORMAL);
            }
        }.start();*/
    }

    private void setToErrorMode(String err) {
        loggedIn = false;
        processMessage = err;
        removeCommand(cancelLogin);
        removeCommand(newMessage);
         removeCommand(openMessage);
        addCommand(back);
        repaint();
    }


    public  void Removefriend(int userid,String email)
    {

        
        friendList.removeFriend(email);
         if(friendList.getVisible())
            repaint();



    }
    public void friendFound(int userid,String email, String name) {
        friendList.addFriend(userid,email, name);
       
        if(friendList.getVisible()){
          System.out.println("repaint\n");
            repaint();
        }
        System.out.println("friendFound: " + email);
    }


    public void friendGameStateChanged(int userid,int gameid)
    {


       
        String gamename="game";// Utility.GetGameName(gameid);

        if (gamename==null) return;

        friendList.setFriendStatus(userid, 1,gamename);
        if(friendList.getVisible())
            repaint();
    

    }
    public void friendStateChanged(int userid, int state,String smsg)
    {

        convList.setFriendStatus(userid, state);
        if(convList.getVisible())
            repaint();

         System.out.println("friendStateChanged----> " + smsg);
        friendList.setFriendStatus(userid, state,smsg);
        if(friendList.getVisible())
            repaint();
    }
    public void friendStateChanged(String email, int state) {
        friendList.setFriendStatus(email, state);
        if(friendList.getVisible())
            repaint();
        System.out.println("friendStateChanged: " + email);
    }



    public void messageError(String id) {
        System.out.println("messageError: " + id);
    }

    public void messageReceived(int userid,String email, String message) {


        System.out.println("messageReceived: " + message);
        Friend f = friendList.findFriend(userid);
        if(f!=null) {
            boolean scrollDown = messageList.shouldScrollDown();
            messageList.addReceivedMessage(f.getName(), email, message);
            if(scrollDown) {
                while(messageList.moveDown());
            }
            if(messageList.getVisible())
                repaint();
        }
        System.out.println("play sound...");
        AlertType.INFO.playSound(XFMobileMidlet.getDisplay());
        System.out.println("play sound done.");

        if(f!=null  && XFMobileMidlet.getDisplay().getCurrent()!=msgform) {
            f.AddPendingMessage();
            convList.addFriend(userid,f.getEmail(), f.getName()+"(+"+f.getPendingMessages()+")");
        }
        if(convList.getVisible())
              repaint();

        msgform.AddConv(userid, message);
    }

    public void commandAction(Command c, Displayable d) {
        if(c==cancelLogin) {
            service.shutdown();
            XFMobileMidlet.switchUI(new LoginForm());
        }
        if(c==back) {

              XFMobileMidlet.switchUI(new menuCanvas(service,this));
              return;
          //  XFMobileMidlet.switchUI(new LoginForm());
            //service.shutdown();
        }

        if (GoTofriends==c){

            tab.moveLeft();
             repaint();
        }
        if (c==openMessage)
        {
          
            Friend f = convList.getSelectedFriend();
            if(f!=null && f.getState()!=Friend.OFFLINE){


                   Friend fl=friendList.findFriend(f.userid);

                   if (fl !=null) {
                     fl.RemovAllPendingMessage();
                   
                   }


                   msgform.setUserID(f.userid);
                   convList.removeFriend(f.getEmail());


                   msgform.startForm();

            }



        }
        if(c==newMessage) {

           
            Friend f = friendList.getSelectedFriend();
            if(f!=null && f.getState()!=Friend.OFFLINE)

                   convList.removeFriend(f.getEmail());
                   f.RemovAllPendingMessage();
                 

                   msgform.setUserID(f.userid);
                   msgform.startForm();
              //  XFMobileMidlet.switchUI(new SendMessageTextBox(this,f.userid, f.getName(), f.getEmail()));
        }
    }

}
