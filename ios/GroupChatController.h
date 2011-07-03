//
//  GroupChatController.h
//  iXfire
//
//  Created by Moti Joseph on 2/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XGroupChannel.h"
#import <Three20/Three20.h>

@interface GroupChatController : UIViewController<UITableViewDelegate, UITableViewDataSource>
 {

	IBOutlet        UITableView        *m_pChatMessages;
	IBOutlet        UITextField        *m_pInputField;
	IBOutlet        UIView              *m_pPanelInput;
	IBOutlet        UIView              *m_pPanelChat;
	UIDeviceOrientation                 m_orientation;
	XfGroupChannel                      *m_ActiveGroupChannel;
	TTTabBar* _tabBar1;
	 
}


-(void) refresh;
-(void) refreshContacts;
- (NSString *)getTextForIndexPath:(NSIndexPath *)indexPath;
-(void) setGroup:(XfGroupChannel*)group;

@property (nonatomic, assign)   XfGroupChannel                   *m_ActiveGroupChannel; 
@property (nonatomic, retain)   IBOutlet UIView                   *m_pPanelChat;   
@property (nonatomic, retain)   IBOutlet UIView                   *m_pPanelInput;         
@property (nonatomic, retain)   IBOutlet UITableView              *m_pChatMessages;
@property (nonatomic, retain)   IBOutlet UITextField              *m_pInputField;
@end


