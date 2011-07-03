package xfire;

/*
 * MsgQue.java
 *
 * � <your company here>, <year>
 * Confidential and proprietary.
 */






/**
 * 
 */
public class MsgQue {
    
    
    byte             []m_pData;
    int                m_dwSize=0;
    
    int                m_type;

 
    

  
    
    
public int bGet_type()
{
    
    
    return m_type;
    
  

     
}
    
public byte[] bGet_data()
{
    
    
    return m_pData;
    
  

     
}

public int   bGet_size()
{
    
    
    return m_dwSize;
    
 
}


public boolean  bPut(int type, byte [] pData, int  dwSize)
{
    
    
        m_pData=null;
        
         m_pData=new byte[dwSize];
      
      
         m_type=type;
         for (int i=0; i<dwSize; i++){
         
               m_pData[i]=0;    
         }
         
         
          for (int i=0; i<dwSize; i++){
         
               m_pData[i]=pData[i];    
         }
         
         
         
         
          m_dwSize = dwSize;
        
       
         
         return true;
   
   
}


} 












