package xfire;

import component.MainCanvas;
import component.MyNicknameForm;
import component.MyStatusForm;
import component.XfireService;
import java.io.*;
import javax.microedition.io.*;
import javax.microedition.midlet.*;
import javax.microedition.lcdui.*;


public class menuCanvas extends Canvas implements CommandListener
{


	public XFMobileMidlet parent;
        private MainCanvas mainCanvas;

	String[] options={"Visit the sponser","Change Status","Change Nickname","Log Off"};
	int  selectedRowPos=0;
	int bgcolor=(255<<16)+(255<<8)+255;
	// Background color - white
	int fgcolor=(0<<16)+(0<<8)+0;
	// Foreground color - black
	int hilightcolor=(84<<16)+(171<<8)+67;
	// Menu highlight color color
	Font bldFont = Font.getFont(Font.FACE_SYSTEM, Font.STYLE_BOLD, Font.SIZE_SMALL);
	// Small Bold
	Font hedFont = Font.getFont(Font.FACE_SYSTEM, Font.STYLE_BOLD, Font.SIZE_MEDIUM); // Medium Bold

       private Command  back = new Command("Cancel", Command.CANCEL, 0);
       private XfireService service;


	public menuCanvas(XfireService service,MainCanvas mainCanvas)
	{
		this.service=service;
                this.mainCanvas=mainCanvas;
                setCommandListener(this);
                addCommand(back);
                

	}



	private void showMainMenu(Graphics g)
	{


		int WIDTH=getWidth();

		int HEIGHT=getHeight();
		int gap=30  ;
		// Set Background and paint the Header
		g.setColor(bgcolor);
		g.fillRect(0,0,WIDTH,HEIGHT);
		g.setColor(fgcolor);
		g.setFont(hedFont);
		g.drawString("Options",5+(WIDTH/2),5,g.TOP|g.HCENTER);
		//Drawing the Menu Options
		g.setFont(bldFont);
		for(int x=0;x<4;x++) {
			g.drawString(options[x],60,65+x*gap,g.TOP|g.LEFT);
		}  // Print the Menu


		//Highlighting the selected menu option

		g.setColor(hilightcolor);

		g.fillRoundRect(2, 55+( selectedRowPos)*gap, WIDTH-2, gap-3, 3, 3);
		g.setColor(fgcolor);
		g.drawString(options[selectedRowPos],60,65+( selectedRowPos)*gap,g.TOP|g.LEFT);
		//Draw Line and paint the Footer
		//g.drawLine(0,HEIGHT-35,WIDTH,HEIGHT-35);
		
	}




	protected void paint(Graphics g) {
		//This methods paints on screen (mandatory)
		showMainMenu(g);


	}



	public void keyPressed(int keyCode)
	{
		switch(getGameAction(keyCode))
		{
		case Canvas.UP:
			if(selectedRowPos >0) selectedRowPos --;
			break;
		case Canvas.DOWN:
			if(selectedRowPos <3) selectedRowPos ++;
			break;
		case Canvas.RIGHT: // Exit
			selectedRowPos =0;
                         System.out.println("fireeeeeeeee");
                      
			// display.setCurrent(new ExitCanvas(this));
			break;
		case Canvas.LEFT: // Select

                      System.out.println("select");
			break;

		case Canvas.FIRE: // Fire

                      System.out.println("fire");
			gotoModule();
			break;
		}
		repaint();
	}

	private void gotoModule() {
		switch(selectedRowPos) {


                    case 0:
                          System.out.println("visit sposner\n");


                              try {
                                  XFMobileMidlet.instance.platformRequest(XfireService.s_redirect_url);
                    } catch (ConnectionNotFoundException ex) {
                          ex.printStackTrace();
                     }
                        break;
			case 1: //display.setCurrent(new Module1Canvas(this));
				// Module1
                              System.out.println("chanage status\n");
                              new MyStatusForm( this.mainCanvas).show();
				break;
			case 2: //display.setCurrent (new Module2Canvas(this));
				//Module2

                              System.out.println("chanage nickname\n");

                              new MyNicknameForm( this.mainCanvas).show();
				break;
			case 3: //display.setCurrent (new Module3Canvas(this));
				//Module13
                             System.out.println("log off\n");
                                XFMobileMidlet.switchUI(new LoginForm());
                                service.shutdown();
				break;
		}
	}

    public void commandAction(Command c, Displayable d)
    {


         System.out.println("commandAction\n");
         if(c==back) {
              XFMobileMidlet.switchUI(XFMobileMidlet.mainCanava);
        }


        
    }


}






