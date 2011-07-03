//
//  MainController.m
//  iXfire
//
//  Created by Moti Joseph on 4/1/09.
//  Copyright 2009 Gamepe. All rights reserved.
//

#import "LoginViewControlller.h"

#import "ContactsViewController.h"
#import "iXfireAppDelegate.h"
#import "global.h"
#import   <AudioToolbox/AudioToolbox.h>
#import <Three20/Three20.h>




/*
@implementation UINavigationBar (UINavigationBarCategory)

- (void)drawRect:(CGRect)rect {
	

	UIColor *color =OPAQUE_HEXCOLOR(g_XfNavBarBackgroundColor);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSetFillColor(context, CGColorGetComponents( [color CGColor]));
	
	CGContextFillRect(context, rect);
	
	self.tintColor = color;
	
	/*
	
	//UIImage *image = [UIImage imageNamed: @"pattern.tiff"];
	UIImage *image = nil;
	
	switch (g_nXfMobileSkin){
	
			case  BLUE_SKIN:
			image = [UIImage imageNamed: @"blue.png"];

			break;
			
		case PURPULE_SKIN:
			image = [UIImage imageNamed: @"pattern_purple.png"];

			break;
			
		default:
				break;

			
	}
     [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
	
	
	
}


@end
*/


@implementation LoginViewControlller

@synthesize     m_ConnectingLabel;
@synthesize     m_pPasswordLabel;
@synthesize     m_pUsernameLabel;
@synthesize     m_pSigninActivityView;
@synthesize     m_pContactsController;
@synthesize     m_pUsername;
@synthesize     m_pUserPassword;
@synthesize     m_pSigninActivityIndicator;
@synthesize     m_pVersionLabel;
@synthesize     m_pURL;
@synthesize     remoteHostStatus;
@synthesize     internetConnectionStatus;
@synthesize     localWiFiConnectionStatus;



- (NSString *)dataFilePath
{
	
	
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:kFilename];
	
	
	
}




- (void)reachabilityChanged:(NSNotification *)note
{
   


	NSLog(@"reachabilityChanged");
}


- (void)checkReachability
{
	
	
	
	
    // Query the SystemConfiguration framework for the state of the device's network connections.
	
	
	
	
    self.remoteHostStatus           = [[Reachability sharedReachability] remoteHostStatus];
    self.internetConnectionStatus    = [[Reachability sharedReachability] internetConnectionStatus];	
    self.localWiFiConnectionStatus    = [[Reachability sharedReachability] localWiFiConnectionStatus];
    
	
	
	
    	// 099 527 555   call num 
	
	 if (self.internetConnectionStatus == NotReachable) {
		
			 
		 UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Cannot connect to network" message:@"Internet connectivity is required." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
		 
		 
		 [myAlertView show];
		
		 [myAlertView release];
		 
		return;
		 
        
        }     
	
	
	
	
	if (self.remoteHostStatus == NotReachable ) {
	
		
		UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Cannot connect to server" message:@"Server is unreachable Try again later." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
		
		
		[myAlertView show];
		
		[myAlertView release];

		
	
	}
	

	
}

 - (void)viewWillAppear:(BOOL)animated

{
	
 
	self.navigationController.navigationBar.tintColor =  OPAQUE_HEXCOLOR(g_XfNavBarBackgroundColor);
														 
	self.view.backgroundColor =OPAQUE_HEXCOLOR(g_XfBackgroundColor);
    m_pPasswordLabel.backgroundColor=OPAQUE_HEXCOLOR(g_XfBackgroundColor);
    m_pUsernameLabel.backgroundColor=OPAQUE_HEXCOLOR(g_XfBackgroundColor);
	m_pSigninActivityView.backgroundColor=OPAQUE_HEXCOLOR(g_XfBackgroundColor);	
	m_pSigninActivityIndicator.backgroundColor=OPAQUE_HEXCOLOR(g_XfBackgroundColor);
	
	m_pVersionLabel.backgroundColor=[UIColor clearColor];
	m_pURL.backgroundColor=[UIColor clearColor];
	
	
	m_pUsernameLabel.textColor=OPAQUE_HEXCOLOR(g_XfContactsNameTextColor);
	m_pPasswordLabel.textColor=OPAQUE_HEXCOLOR(g_XfContactsNameTextColor);
	m_pVersionLabel.textColor=OPAQUE_HEXCOLOR(g_XfContactsNameTextColor);
	m_ConnectingLabel.textColor=OPAQUE_HEXCOLOR(g_XfContactsNameTextColor);
	
	
	UIColor *color=OPAQUE_HEXCOLOR(g_XfContactsNameTextColor) ;

	[m_pURL setTitleColor:color forState:UIControlStateNormal];	
	
	
	[[Reachability sharedReachability] setHostName:[self hostName]];
	[self checkReachability];
	
	
	char signatureURL[0x100];
	
	sprintf(signatureURL,"http://miniprofile.xfire.com/bg/sh/type/1/%s.png",[m_pUsername.text  UTF8String]);
	
	
	//m_signatureImage.image=[UIImage imageWithData: [NSData dataWithContentsOfURL: [NSURL URLWithString: [NSString stringWithFormat:@"%s",signatureURL]]]];
	
	//[self.navigationController.navigationBar setTintColor:[UIColor clearColor]];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:@"kNetworkReachabilityChangedNotification" object:nil];
	
	if ([g_pXfireNetCore IsConnecetd]){

			
		self.navigationItem.rightBarButtonItem.title=@"Contacts";
		self.navigationItem.rightBarButtonItem.tag=DEF_ID_CONTACTS;
	
		
		if (self.navigationItem.leftBarButtonItem==nil) {
			
			
		UIBarButtonItem *sigoutButton=[[UIBarButtonItem alloc]
									   initWithTitle:@"Sign-out"
									   style:UIBarButtonItemStyleBordered
									   target:self
									   action:@selector(OnDisconnect)];
		
		
		self.navigationItem.leftBarButtonItem=sigoutButton;
		[sigoutButton release];
			
		}
		
	}else{
		
	
	     self.navigationItem.rightBarButtonItem.title=@"Sign-in";
		 self.navigationItem.rightBarButtonItem.tag=DEF_ID_SIGNIN;
	
		
	}
	
	[m_pUsername becomeFirstResponder];

	
}




- (void)dealloc 
{
	
	
	[m_ConnectingLabel release];
	[m_pPasswordLabel  release];
	[m_pUsernameLabel  release];
	[m_pURL release];
	[m_pVersionLabel release];
	[m_pSigninActivityIndicator release];
	[m_pContactsController release];
	[m_pSigninActivityView release];
	
	[m_pUsername release];
	[m_pUserPassword release];
	[super dealloc];
}




-(void)playSound:(NSString*) name
{
	
	NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"wav"];
	SystemSoundID soundID;
	AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:path], &soundID);
	AudioServicesPlaySystemSound (soundID);		
}






- (void)applicationWillTerminate:(NSNotification *)notification
{
	
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	[prefs setObject:m_pUsername.text forKey:@"XfUsername"];
	
	[prefs setObject:m_pUserPassword.text forKey:@"XfPassword"];
	
	[prefs setInteger:g_XfBackgroundColor forKey:@"XfBackgroundColor"];
	
	[prefs setInteger:g_XfContactsNameTextColor forKey:@"XfContactsNameTextColor"];
	
	[prefs setInteger:g_XfContactsStatusTextColor forKey:@"XfContactsStatusTextColor"];
	
	
	[prefs setInteger:g_XfContactSeparatorColor forKey:@"XfContactsSeparatorColor"];

	
	
	
	[prefs setInteger:g_XfNavBarBackgroundColor forKey:@"XfNavBarBackgroundColor"];
	
	[prefs setInteger:g_XfContactSectionBackgroundTextColor forKey:@"XfContactSectionBackgroundTextColor"];
	
	[prefs setInteger:g_XfContactSectionTextColor forKey:@"XfContactSectionTextColor"];
	
	
	
	
	[prefs setBool:g_bIsClansVisible forKey:@"isCommunityVisible"];
	
	[prefs setBool:g_bIsShowOfflineFriends forKey:@"isShowOfflineFriends"];
	
	[prefs setBool:g_bIsPlayRecvIMSound forKey:@"isPlaySoundOnRecivedIM"];
	
	[prefs setBool:g_bIsUsernamesVisible forKey:@"isUsernamesVisible"];
	
	[prefs synchronize];
	
		
	
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.

- (void)viewDidLoad 
{
		
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSUInteger color;
	
	 color= [prefs integerForKey:@"XfBackgroundColor"];
	if (color) 
		g_XfBackgroundColor=color;
	
	 color= [prefs integerForKey:@"XfContactsNameTextColor"];
	if (color) 
		
		g_XfContactsNameTextColor=color;
	
	 color = [prefs integerForKey:@"XfContactsStatusTextColor"];
	if (color) 
		g_XfContactsStatusTextColor=color;
	
	color = [prefs integerForKey:@"XfNavBarBackgroundColor"];
	if (color) 
		g_XfNavBarBackgroundColor=color;
	
	color = [prefs integerForKey:@"XfContactSectionTextColor"];
	if (color) 
	g_XfContactSectionTextColor=color;
	
	color = [prefs integerForKey:@"XfContactSectionBackgroundTextColor"];
	if (color) 
	g_XfContactSectionBackgroundTextColor=color;
	
	color = [prefs integerForKey:@"XfContactsStatusTextColor"];
	
	g_XfContactsStatusTextColor=color;
	
	
	
	g_bIsClansVisible = [prefs boolForKey:@"isCommunityVisible"];
	g_bIsShowOfflineFriends = [prefs boolForKey:@"isShowOfflineFriends"];
	g_bIsPlayRecvIMSound = [prefs boolForKey:@"isPlaySoundOnRecivedIM"];
	g_bIsUsernamesVisible = [prefs boolForKey:@"isUsernamesVisible"];
	m_pUsername.text= [prefs objectForKey:@"XfUsername"];
	m_pUserPassword.text= [prefs objectForKey:@"XfPassword"];
	
	UIAccelerometer *accel = [UIAccelerometer sharedAccelerometer];
	accel.delegate = self;
	accel.updateInterval = kUpdateInterval;
	
	UIApplication *app = [UIApplication sharedApplication];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(applicationWillTerminate:)
												 name:UIApplicationWillTerminateNotification 
											   object:app];
	
	self.title=@"Login";
	
	m_pVersionLabel.text=@"v4.2";
	
  //  [m_pURL setTitleColor:OPAQUE_HEXCOLOR(0xFF8ABAF1) forState:UIControlStateNormal];	
	
	m_pVersionLabel.textColor=OPAQUE_HEXCOLOR(0xFF8ABAF1);
	
	
	UIBarButtonItem *signinButton=[[UIBarButtonItem alloc]
								   initWithTitle:@"Sign-in"
								   style:UIBarButtonItemStylePlain
								   target:self
								   action:@selector(OnSignin)];
	
	
	self.navigationItem.rightBarButtonItem=signinButton;
	self.navigationItem.rightBarButtonItem.tag=DEF_ID_SIGNIN;
	[signinButton release];
	
		
	
	m_pContactsController=[[ContactsViewController alloc] initWithNibName:@"ContactsViewController"
																   bundle:nil];
	

	TTSearchlightLabel* label = [[[TTSearchlightLabel alloc] init] autorelease];
	label.text = @"             XfMobile Pro";
	label.font = [UIFont systemFontOfSize:25];
	label.textAlignment = UITextAlignmentCenter;
	label.contentMode = UIViewContentModeCenter;
	label.backgroundColor =[UIColor clearColor];
	label.textColor=OPAQUE_HEXCOLOR(g_XfContactsNameTextColor);
	[label sizeToFit];
	//label.frame = CGRectMake(0, 0, self.view.width, label.height+30 );
	[self.view addSubview:label];
	[label startAnimating];
	
	[label release];

	
		
		
	
	
	
	
	[super viewDidLoad];
}




- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
	
	 
	if ([g_pXfireNetCore IsConnecetd]||(m_pSigninActivityView.hidden==FALSE)){
	
		
		return;
	}
	
	if (fabsf(acceleration.x) > kAccelerationThreshold || fabsf(acceleration.y) > kAccelerationThreshold || fabsf(acceleration.z) > kAccelerationThreshold) {
			
		[self OnSignin];
			
	}
	
}




-(IBAction)              OnOpenGamepe:(id) sender
{
	

	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.xf-mobile.com/forum"]];

	
}






-(void) check_udid
{
	
	NSString *udid=[UIDevice currentDevice].uniqueIdentifier;
	
	NSLog(@"--->UDID =%s",[udid UTF8String]);
	
	
	
	if (strcmp([udid UTF8String],"00000000-0000-1000-8000-0016CF53FA9F")==0){
		
		g_bDisableAds=TRUE;
		
		
		
	}
	
	if (strcmp([udid UTF8String],"47539e2d3c8439e727421cba6cc9148f71d48ed8")==0){
		
		g_bDisableAds=TRUE;
		
		
		
	}
	if (strcmp([udid UTF8String],"48537fbc10df86375b0d6379f61469a6b1385542")==0){
		
		g_bDisableAds=TRUE;
		
		
		
	}
	if (strcmp([udid UTF8String],"7ee618c847f789fb8af0fc0bd5701e3e8316d025")==0){
		
		g_bDisableAds=TRUE;
		
		
		
	}
	if (strcmp([udid UTF8String],"a00a24c8be8e565bb4f7d7b3012726ba805853db")==0){
		
		g_bDisableAds=TRUE;
		
		
		
	}
	if (strcmp([udid UTF8String],"400971796bc9ba6cf1ae5e34d658c96eb7d9e10")==0){
		
		g_bDisableAds=TRUE;
		
		
		
	}
	
	// create the request
	
	
	
	/*NSLog(udid);
	 char post_token[0x200];
	 
	 sprintf(post_token,"http://www.xf-mobile.com/download/%s.php",[udid UTF8String]);
	 
	 NSLog(@"sending UDID =%s",post_token);
	 
	 NSString* escapedUrl = [[NSString stringWithFormat:@"%s",post_token]   
	 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; 
	 
	 NSLog(@"%@",escapedUrl);
	 
	 NSURL *url = [NSURL URLWithString:escapedUrl];
	 NSURLRequest *request = [NSURLRequest requestWithURL: url];
	 NSHTTPURLResponse *response;
	 [NSURLConnection sendSynchronousRequest: request returningResponse: &response error: nil];
	 
	 NSLog(@"code=%d",[response  statusCode]);
	 //Tue Mar 23 07:25:36 unknown XfMobile[624] <Warning>: 48537fbc10df86375b0d6379f61469a6b1385542
	 
	 if ([response  statusCode]==200){
	 
	 
	 g_bDisableAds=TRUE;
	 
	 NSLog(@"UDID was found");
	 }else{
	 
	 g_bDisableAds=FALSE;
	 NSLog(@"UDID was not found");
	 
	 }
	 */
	
}


-(void) OnDisconnect
{

	
		
	
	[g_pXfireNetCore  Disconnect];

	
	self.navigationItem.leftBarButtonItem=nil;
	self.navigationItem.rightBarButtonItem.title=@"Sign-in";
	self.navigationItem.rightBarButtonItem.tag=DEF_ID_SIGNIN;
	
	[m_pSigninActivityIndicator stopAnimating];
	m_pSigninActivityView.hidden=TRUE;

	iXfireAppDelegate *delegate = [[UIApplication sharedApplication] delegate];

	[delegate.m_pNavController  popToViewController:self animated:YES];
	[self playSound:@"Logout"];

	
} 




-(IBAction) LoginDoneEditing:(id) sender
{
	 
	[self OnSignin];
	[sender resignFirstResponder];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


-(void) OnConnectionFailed
{
	
	
  
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"Your Xfire Name and password were not recongnised.\nPlease try again."
											 delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];

    [alert show];
    [alert release];
	[self OnDisconnect];
	
	[self playSound:@"Logout"];

}



-(void) SwitchToContactsView
{

	
	[m_pSigninActivityIndicator stopAnimating];

     m_pSigninActivityView.hidden=TRUE;
		
    [self playSound:@"Login"];
	iXfireAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	[delegate.m_pNavController  pushViewController:m_pContactsController animated:YES];
	
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
// Return YES for supported orientations
{	return  NO;// (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/*
//- (void)willAnimateFirstHalfOfRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
- (void)willAnimateSecondHalfOfRotationFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation duration:(NSTimeInterval)duration {
	
	

	
	UIInterfaceOrientation toInterfaceOrientation = self.interfaceOrientation;
	
	[UIView beginAnimations:@"move version" context:nil];
	
	if (toInterfaceOrientation == UIInterfaceOrientationPortrait 
		|| toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
	{
		m_pVersionLabel.frame = CGRectMake(11, 392, 176, 21);
	
	}
	else 
	{
		m_pVersionLabel.frame = CGRectMake(11, 232, 57, 21);
	}
	
	[UIView commitAnimations];
}*/

-(void) OnLoggedInDifferentMachine
{

	
	iXfireAppDelegate *delegate = [[UIApplication sharedApplication] delegate];

    UIActionSheet *actionSheet = [[UIActionSheet alloc] 
							  initWithTitle:@" You were logged off because you logged in on a different computer" 
							  delegate:nil 
							  cancelButtonTitle:@"Ok"
							  destructiveButtonTitle:nil 
							  otherButtonTitles:nil];
    [actionSheet showInView:delegate.m_pNavController.visibleViewController.view];
    [actionSheet release];

	[self OnDisconnect];
	[delegate.m_pNavController  popToViewController:self animated:YES];
		
	
	
}


-(void) OnInternalError
{
	
	
	iXfireAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	
    UIActionSheet *actionSheet = [[UIActionSheet alloc] 
								  initWithTitle:@"XfMobile internal error\n you may have  too many Xfire friends.\ncontact www.xf-mobileƒ.com for help!" 
								  delegate:nil 
								  cancelButtonTitle:@"Ok"
								  destructiveButtonTitle:nil 
								  otherButtonTitles:nil];
    [actionSheet showInView:delegate.m_pNavController.visibleViewController.view];
    [actionSheet release];
	
	[self OnDisconnect];
	
	[delegate.m_pNavController  popToViewController:self animated:YES];
	
	
	
}

- (NSString *)hostName
{
    // Don't include a scheme. 'http://' will break the reachability checking.
    // Change this value to test the reachability of a different host.
    return @"cs.xfire.com";
}


-(IBAction) OnSignin

{
	
	if (strlen([m_pUsername.text  UTF8String])<2) {
		
	
		
		UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Login" message:@"username is too short." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
		
		
		[myAlertView show];
		
		[myAlertView release];
		
		
		return;
	}
	if (strlen([m_pUserPassword.text  UTF8String])<2) {
		
		
		
		UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Login" message:@"password is too short." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
		
		
		[myAlertView show];
		
		[myAlertView release];
		
		
		return;
	}
	
	
	
	[self checkReachability];
	
	
	if (self.navigationItem.rightBarButtonItem.tag==DEF_ID_SIGNOUT){
		
	
	
		[self OnDisconnect];
		
		return;
	}
	
	if ([g_pXfireNetCore IsConnecetd]){
		
	
		[self SwitchToContactsView];
		
		return;
	}
	
	

	[m_pUsername resignFirstResponder];
	[m_pUserPassword resignFirstResponder];
	
	m_pSigninActivityView.hidden=FALSE;
	self.navigationItem.rightBarButtonItem.title=@"Sign-out";
	self.navigationItem.rightBarButtonItem.tag=DEF_ID_SIGNOUT;
	
	
	[m_pContactsController initData];
	[m_pSigninActivityIndicator startAnimating];

	g_pXfireNetCore.m_pLoginController=self; 
		
	
	[g_pXfireNetCore setLogin:[m_pUsername.text  UTF8String] Password:[m_pUserPassword.text UTF8String]];
	
	[g_pXfireNetCore Connect];
	
}
@end
