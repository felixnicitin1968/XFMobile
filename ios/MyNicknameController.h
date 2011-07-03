//
//  MyNicknameController.h
//  iXfire
//
//  Created by Moti Joseph on 10/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactsViewController.h"

@interface MyNicknameController : UIViewController {

	
	ContactsViewController                 *m_pContactsController;
	
	IBOutlet UITextView                     *m_myNicknameTextField;
}


@property(assign) ContactsViewController        *m_pContactsController;

@property (nonatomic, retain)   IBOutlet UITextView                   *m_myNicknameTextField;      


- (void)setParent:(ContactsViewController *)controller;


@end
