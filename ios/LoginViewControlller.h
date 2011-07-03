//
//  MainController.h
//  iXfire
//
//  Created by Moti Joseph on 4/1/09.
//  Copyright 2009 Gamepe. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Reachability.h"


@class ContactsViewController;


#define kFilename		     @"data.plist"


#define DEF_ID_SIGNIN        0
#define DEF_ID_SIGNOUT       1
#define DEF_ID_CONTACTS      2

#define kAccelerationThreshold		1.9
#define kUpdateInterval			(1.0f/10.0f)




@interface LoginViewControlller : UIViewController   <UIAccelerometerDelegate>
{
	
	

	ContactsViewController                   *m_pContactsController;
	IBOutlet UITextField                     *m_pUsername;
    IBOutlet UITextField                     *m_pUserPassword;
	
	IBOutlet UILabel                         *m_pUsernameLabel;
	IBOutlet UILabel                         *m_pPasswordLabel;
	IBOutlet UILabel                         *m_ConnectingLabel;
	
	IBOutlet UILabel                         *m_pVersionLabel;
	IBOutlet UIActivityIndicatorView         *m_pSigninActivityIndicator;
	IBOutlet UIView                          *m_pSigninActivityView;
	IBOutlet UIButton                        *m_pURL;
	
	
		
	NetworkStatus remoteHostStatus;
    NetworkStatus internetConnectionStatus;
    NetworkStatus localWiFiConnectionStatus;
}

@property NetworkStatus remoteHostStatus;
@property NetworkStatus internetConnectionStatus;
@property NetworkStatus localWiFiConnectionStatus;

@property (nonatomic, retain) IBOutlet UILabel                      *m_ConnectingLabel;
@property (nonatomic, retain) IBOutlet UILabel                      *m_pUsernameLabel;
@property (nonatomic, retain) IBOutlet UILabel                      *m_pPasswordLabel;

@property (nonatomic, retain) IBOutlet UIButton                      *m_pURL;
@property (nonatomic, retain) IBOutlet UILabel                       *m_pVersionLabel;
@property (nonatomic, retain) IBOutlet UIView                        *m_pSigninActivityView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView       *m_pSigninActivityIndicator;
@property (nonatomic, retain) ContactsViewController                 *m_pContactsController;
@property (nonatomic, retain) IBOutlet UITextField                   *m_pUsername;
@property (nonatomic, retain) IBOutlet UITextField                   *m_pUserPassword;

-(void)                  check_udid;
-(void)                  playSound:(NSString*) name;
- (void)                 checkReachability;
- (NSString *)           hostName;
-(void)                  OnInternalError;
-(void)                  OnLoggedInDifferentMachine;
-(void)                  viewDidLoad; 
- (void)                 viewWillAppear:(BOOL)animated;
-(void)                  OnDisconnect;
-(NSString *)            dataFilePath;
-(void)                  applicationWillTerminate:(NSNotification *)notification;
-(IBAction)              OnSignin;
-(IBAction)              LoginDoneEditing:(id) sender;
-(IBAction)              OnOpenGamepe:(id) sender;
-(void)                  SwitchToContactsView;
-(void)                  OnConnectionFailed;


@end
