package component;



import java.util.Vector;
import javax.microedition.lcdui.Form;

 class XfireContact  extends Object

{


	
        int               _messages_count;
        String          []_messages=new String[100];
        byte            []_cUsername;
        byte            []_cNickname;  
        String            _cStatusMsg;
        int               _gameid;
        int               _userid;
        byte            []_sid=new byte[16];
        int               _uStatus;
        boolean           _bIsPendingMessages;
        int               _nTotalMessages;
        char            []_cGamename= new char[200];
        int                _nNodeID;
        boolean             _bRecvNewMsg;
        int                 _imindex;
     //   Bitmap                       _picGame;




}

class XfireClan
{

        byte             [] _name;
        int              _id;
        short            _usercount;
        
        Vector           _Contacts = new Vector();
        
        int              _nNodeID;

      


}


public class CoreService  

{

	  public static final int XFIRE_STATUS_OFFLINE= 0;
      public static final int XFIRE_STATUS_ONLINE= 1;
      public static final int XFIRE_STATUS_AWAY= 2; 
      
      static XfireClan                     []_Clans=new XfireClan[32];
      static int                             _nTotalContacts;
      static int                             _nTotalClans;
      
      static int                             _nTotalChatSessions;
      static int                             _nTotalOnlineContacts;   
      
      static Vector                          _Contacts = new Vector();
      
      
      
      
     
      
	    static int   getClanIndexByID(int nClanID)
	    {

	            for (int i=0; i<_nTotalClans; i++)   {

	                    if (_Clans[i]._id==nClanID) {


	                            return i;
	                   }

	            }

	            return -1;
	    }
	    
      
      static XfireContact   getContactBySID(byte[] sid)
      {





              boolean bOK=false;



              for (int i=0; i<_Contacts.size(); i++)   {

                      XfireContact xcontact=(XfireContact) _Contacts.elementAt(i);
           
                       bOK=false;

                      for (int j=0; j<16; j++){



                              if ( xcontact._sid[j]!=sid[j]){

                                      bOK=true;

                                      break;

                              }



                      }

                      if (!bOK) return  xcontact;


              }

              return getClanContactBySID(sid);
      }



      
      

      static XfireContact   getContactByUSERID(int userid)
      {

              for (int i=0; i<_Contacts.size(); i++)   {
                    
                    
                    
                     XfireContact xcontact=(XfireContact) _Contacts.elementAt(i);
           

        
                      if (xcontact._userid==userid) {


                              return xcontact; 
                      } 

              }

              return getClanContactByUSERID(userid);
      }
      

  
     
      
      static XfireContact getClanContactByUSERID( int userid)
      {
          
          
          
            boolean bOK=false;
            for (int i=0; i<_nTotalClans; i++){
               
                   for (int j=0; j<_Clans[i]._usercount; j++){
                       
                        XfireContact clan_xcontact= (XfireContact) _Clans[i]._Contacts.elementAt(j);
                      
                  

                               if ( clan_xcontact._userid==userid){

                                     return clan_xcontact;

                               }  
                       
              }
           
            }
            
            return null;
      }
      
      static XfireContact getClanContactBySID( byte[] sid)
      {
          
          
          
            boolean bOK=false;
            for (int i=0; i<_nTotalClans; i++){
               
                   for (int j=0; j<_Clans[i]._usercount; j++){
                       
                        XfireContact clan_xcontact= (XfireContact) _Clans[i]._Contacts.elementAt(j);
                      
                      bOK=false;

                       for (int t=0; t<16; t++){



                               if ( clan_xcontact._sid[t]!=sid[t]){

                                       bOK=true;

                                       break;

                               }



                       }

                       if (!bOK) return  clan_xcontact;
                       
                       
              }
           
            }
            
            return null;
      }
	
}

