package xfire;

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

import  component.*;
import javax.microedition.lcdui.Alert;
import javax.microedition.lcdui.AlertType;
import javax.microedition.lcdui.Command;
import javax.microedition.lcdui.CommandListener;
import javax.microedition.lcdui.Displayable;
import javax.microedition.lcdui.Form;
import javax.microedition.lcdui.TextField;
import javax.microedition.rms.RecordStore;
import javax.microedition.rms.RecordStoreException;

/**
 * Login form.
 * 
 * @author Michael Liao (askxuefeng@gmail.com)
 */
public class LoginForm extends Form implements CommandListener {



     String _pass="",_user="";
    // a test gmail account, please DO NOT change the password:
    private TextField username = new TextField("username", "", 30, TextField.ANY);
    private TextField password = new TextField("Password", "", 30, TextField.PASSWORD);

    private Command login = new Command("Sign in", Command.OK, 0);
    RecordStore _db ;//

     private Command exitCommand = new Command("Exit", Command.EXIT, 1);



     private void LoadLoginData()

      {
        try {
            _db = RecordStore.openRecordStore("xfire_data", true);
            if (_db.getNumRecords() == 2) {
                byte[] user = _db.getRecord(1);
                _user = new String(user, 0, user.length);
                byte[] pass = _db.getRecord(2);
                _pass = new String(pass, 0, pass.length);

                   username.setString(_user);
                   password.setString(_pass);

            }

             System.out.println("loading record "+_db.getNumRecords());

            _db.closeRecordStore();
      

         

        } catch (RecordStoreException ex) {
            ex.printStackTrace();
          }

      }

       private  void SaveLoginData()
      {

              try {

                         _db = RecordStore.openRecordStore("xfire_data", true);
                         byte _userbytes[] = _user.getBytes();
                         byte _passbytes[] = _pass.getBytes();
                        _db.addRecord(_userbytes, 0, _userbytes.length);
                        _db.addRecord(_passbytes, 0, _passbytes.length);

                        _db.closeRecordStore();


                        System.out.println("saving user/pass");




                    } catch (RecordStoreException ex) {
                        ex.printStackTrace();
                    }

      }
       


    public LoginForm() {
        
        super("Sign in");

        setTitle( "Login" );
      

  
        append(username);
        append(password);
          LoadLoginData();
        addCommand(exitCommand);
        addCommand(login);
        setCommandListener(this);
    }

    public void commandAction(Command c, Displayable d) {


        if (c == exitCommand) {
      XFMobileMidlet.instance.destroyApp(false);
      XFMobileMidlet.instance.notifyDestroyed();
      return;
    }


        if(c==login) {

            _user = username.getString();
            _pass = password.getString();

             if (_pass.length()<1 ||_user.length()<1)
             {

                                    Alert error = new Alert("Login Incorrect",
                                          "Your Xfire name or password is too short.\nPlease try again.", null,
                                          AlertType.ERROR);
	                             error.setTimeout(3000);

	                             error.setType(AlertType.INFO);
                                     XFMobileMidlet.switchUI(error);
                                     return;

              }

               SaveLoginData();

             


               XFMobileMidlet.mainCanava=new MainCanvas(_user,_pass);
               XFMobileMidlet.switchUI( XFMobileMidlet.mainCanava);
        }
    }

}
