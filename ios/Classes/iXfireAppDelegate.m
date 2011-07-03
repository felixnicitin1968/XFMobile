//
//  iXfireAppDelegate.m
//  iXfire
//
//  Created by Moti Joseph on 4/1/09.
//  Copyright Gamepe 2009. All rights reserved.
//Device Token=<98dd4a81 c3220967 a83397fa 71004ed5 353da3b5 bd30f1fb 90502818 f7387f35>

#import           "iXfireAppDelegate.h"
#import           "LoginViewControlller.h"
#import           "global.h"
#import           "XfireCore.h"

#import            "Three20/Three20.h"
#import           "MyStyleSheetClass.h"

//#import           "FlurryAPI.h"
@implementation   iXfireAppDelegate

@synthesize window;
@synthesize m_pNavController;

@synthesize registered;

void uncaughtExceptionHandler(NSException *exception)
{
   
	[FlurryAPI logError:@"Uncaught" message:@"Crash!" exception:exception];

}
//<9405008e 3fd620cc f3d22769 b352ff3f 74612713 d0094ecc 62bc2fa8 93eee25a>

-(BOOL)isMultitaskingOS
{

BOOL bgSupport=NO;
if ([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)])
	bgSupport=[UIDevice currentDevice].multitaskingSupported;
return bgSupport;


}
-(BOOL)isForeground {
	
	if (![self isMultitaskingOS]) 
	return YES; 
	UIApplicationState state = [UIApplication sharedApplication].applicationState; 
	//return (state==UIApplicationStateActive || state==UIApplicationStateInactive ); 
	return (state==UIApplicationStateActive); 

}
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken { 
	
	
	NSLog(@"*********didRegisterForRemoteNotificationsWithDeviceToken*****");
    NSString *str = [NSString 
					 stringWithFormat:@"%@",deviceToken];
	
	
	//<9405008e 3fd620cc f3d22769 b352ff3f 74612713 d0094ecc 62bc2fa8 93eee25a>

	strcpy(push_token_id,[str UTF8String]);
    NSLog(@"rivka=%s",push_token_id);
	
	
	
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
	
    for (id key in userInfo) {
        NSLog(@"key: %@, value: %@", key, [userInfo objectForKey:key]);
    }    
	
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{	
	NSLog(@"Error in registration. Error: %@", err);
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {    

    // Override point for customization after application launch
	
	NSLog(@"call applicationDidFinishLaunching" );
	
	if ([self isMultitaskingOS]) {
	
			NSLog(@"call isMultitaskingOS SUPPORT" );
	}else{
	
			NSLog(@"call isMultitaskingOS NOT SUPPORT" );
	}
		
		
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:(/*UIRemoteNotificationTypeBadge |*/ UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert)]; 
	
	g_pXfireNetCore=[[XfireCore alloc] init];
	
	UIApplication *thisApp = [UIApplication sharedApplication];
	thisApp.idleTimerDisabled = YES;
	
	NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
	[FlurryAPI startSession:@"QG7TJHINHVHPRR45L74H"];
	// [FlurryAPI startSessionWithLocationServices:@"RMEL8ARIMR7UY1Q2K9YY"];
	
	//NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
	
	[TTStyleSheet setGlobalStyleSheet:
	
	 [[[MyStyleSheetClass alloc] init] autorelease]];
	
	[[UIApplication sharedApplication] setStatusBarHidden:YES animated:NO];
	[window addSubview:m_pNavController.view];

    [window makeKeyAndVisible];
}


- (void)dealloc {
	
    [window release];
	[m_pNavController release];
    [super dealloc];
}


@end



//Your Xfire Name and password were not recongnised .
//Please try again. //Dismiss