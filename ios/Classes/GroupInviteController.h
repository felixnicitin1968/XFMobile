//
//  GroupInviteController.h
//  iXfire
//
//  Created by Moti Joseph on 2/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Three20/Three20.h>
@interface GroupInviteController : UIViewController  <UITableViewDelegate, UITableViewDataSource>{

	
	 IBOutlet        UITableView              *_users;
}

@property (nonatomic, retain)   IBOutlet UITableView                   *_users;     
- (void)addActivityLabelWithStyle:(TTActivityLabelStyle)style  ;
- (void) hideActivityInviteLabel: (id) timer;
@end
