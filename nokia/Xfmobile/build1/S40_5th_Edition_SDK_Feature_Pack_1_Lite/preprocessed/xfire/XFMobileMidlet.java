package xfire;

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

import com.flurry.javame.FlurryAgent;
import component.MainCanvas;
import component.MessageForm;
import javax.microedition.midlet.*;
import java.util.Vector; //ÓÉlist¸ÄÎªVector 2004/5/29 ceze
import java.util.Hashtable;//ÓÉMap¸ÄÎªHashtable 2004/5/29 ceze
import java.util.Enumeration;//Iterator¸ÄÎªEnmeration 2004/5/29 ceze

import java.util.Date;

import javax.microedition.midlet.MIDlet;
import javax.microedition.lcdui.*;
import javax.microedition.midlet.MIDletStateChangeException;


//import com.tomclaw.tcui.gui.Screen;

import javax.microedition.lcdui.Display;
import javax.microedition.midlet.*;
import javax.microedition.rms.RecordStoreException;
import InnerActiveSDK.IASDK;

/**
 * @author Moti
 */
public class XFMobileMidlet extends MIDlet  {




    public static ConnectThread   _connectThread;


    public static XFMobileMidlet  instance = null;


    public static  MainCanvas      mainCanava;

    private Display display = null;
    private Displayable current = null;


     public XFMobileMidlet() {
           instance = this;
    }


    protected void destroyApp(boolean unconditional) {
    }

    protected void pauseApp() {
    }

    public static void quitApp() {


        FlurryAgent.onDestroyApp();
        instance.destroyApp(true);
        instance.notifyDestroyed();
    }


     /**
     * Convenient method to switch ui.
     */

    public static void switchUI(Displayable d) {
        instance.current = d;
        instance.display.setCurrent(d);
    }


     /**
     * Convenient method to get a Display instance.
     */
    public static Display getDisplay() {
        return instance.display;
    }

   



     public void exitMIDlet()
	 {


               try {


			IASDK.exitApp();


		}
		catch (Exception ex) {

			ex.printStackTrace();
		}
		
		 notifyDestroyed();

	 }
    public void startApp()
    {
      

   // for NOKIA 6230i ,instead of the this block ,use the next one
		try {
			byte retVal = IASDK.start(this);

		}
		catch (Throwable ex) {
			System.out.println("Error in IASDK.start " + ex);
		}


        FlurryAgent.onStartApp(this, "RNUE7K4F6T7FRQLIYX85");
        if(display==null) {
            display = Display.getDisplay(this);
            current = new SplashCanvas();


         //  
        }
       display.setCurrent(current);

        

            

       

    }

    
 


    
}
