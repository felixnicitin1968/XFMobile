//
//  PreferencesViewController.h
//  iXfire
//
//  Created by Moti Joseph on 4/25/09.
//  Copyright 2009 Gamepe. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PreferencesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{

/*	IBOutlet  UISwitch  *m_pDisableSignature;
	IBOutlet  UISwitch  *m_pShowUsernamesFriends;
	IBOutlet  UISwitch  *m_pShowOfflineFriends;
	IBOutlet  UISwitch  *m_pClanGroups;
	IBOutlet  UISwitch  *m_pPlayRecvIMSound;
*/
	
	
	
	IBOutlet        UITableView        *m_pOptionsTableView;
	NSMutableArray                     *m_pMutableOptionslist;
	



}

@property (nonatomic, retain)   IBOutlet UITableView              *m_pOptionsTableView;

-(void) showPushHelp;

-(IBAction) OnSwitchChanged:(id)sender;


@end


