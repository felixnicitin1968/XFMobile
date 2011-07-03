//
//  MyStatusController.h
//  iXfire
//
//  Created by Moti Joseph on 10/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ContactsViewController.h"

@interface MyStatusController : UIViewController {
	
	
	 ContactsViewController                 *m_pContactsController;
	
     IBOutlet UITextView                     *m_myStatusTextField;
}

@property(assign) ContactsViewController        *m_pContactsController;

@property (nonatomic, retain)   IBOutlet UITextView                   *m_myStatusTextField;      

-(IBAction)              MyStatusDoneEditing:(id) sender;

- (void)setParent:(ContactsViewController *)controller;

@end


