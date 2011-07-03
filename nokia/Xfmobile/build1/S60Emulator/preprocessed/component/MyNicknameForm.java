/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package component;



import java.io.IOException;
import javax.microedition.lcdui.Alert;
import javax.microedition.lcdui.AlertType;
import javax.microedition.lcdui.Command;
import javax.microedition.lcdui.CommandListener;
import javax.microedition.lcdui.Display;
import javax.microedition.lcdui.Displayable;
import javax.microedition.lcdui.Form;
import javax.microedition.lcdui.TextField;
import xfire.XFMobileMidlet;

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author Moti
 */


public class MyNicknameForm extends Form  implements CommandListener , Runnable
{


    private MainCanvas mainCanvas;
    private TextField tb;//Type new message here

    Command ok;//Send Command


    private Thread waitingThread;

    public MyNicknameForm(MainCanvas obj)
    {

        super("set nickname");
        mainCanvas=obj;


        tb = new TextField(null, "", 2000, TextField.ANY);

        append(tb);

        ok = new Command("OK", Command.OK, 0);

        addCommand(ok);
        setCommandListener(this);


    }

    public void show()
    {


		XFMobileMidlet.getDisplay().setCurrent(this);

                XFMobileMidlet.getDisplay().setCurrentItem(tb);


    }
    public void commandAction(Command c, Displayable d) {

        if (c==ok){


             try {

                 if (tb.getString().length()<1) {

                      XFMobileMidlet.switchUI(XFMobileMidlet.mainCanava);
                      
                     return;
                 }
                 mainCanvas.sendMyNicknamePacket(tb.getString().toCharArray());

                     Alert error = new Alert("set nickname",
                                          "Your nickname chanaged", null,
                                          AlertType.INFO);
	                             error.setTimeout(2000);
	                             error.setType(AlertType.INFO);
                                     XFMobileMidlet.switchUI(error);

            } catch (IOException ex) {
                ex.printStackTrace();
            }

              waitingThread = new Thread(this);
              waitingThread.start();


        }
    }

     public void run() {

        
        try
        {
               
            Thread.sleep(2000);

        }
        catch(InterruptedException e) {}

             XFMobileMidlet.switchUI(XFMobileMidlet.mainCanava);
    }
}
