//
//  AdImageView.m
//  iXfire
//
//  Created by Rivka B on 9/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AdImageView.h"
#import "global.h"
#import "ProfileViewController.h"
#import "iXfireAppDelegate.h"

@implementation AdImageView
- (id)initWithImage:(UIImage *)image
{
    if (self = [super initWithImage:image])
    {
        //init here
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"-- I AM TOUCHED --");
	
	MetricClickNotificationThread();
	
	ProfileViewController      *pProfileView=[[ProfileViewController alloc] initWithNibName:@"ProfileViewController"
																					 bundle:nil ];
	
	
	char cURL[1024];//="http://www.google.com";
	
	sprintf(cURL,g_szLinkToAd);
	
	
	[pProfileView setProfileURL:cURL];
	
	pProfileView.title=@"Sponser";//[NSString stringWithUTF8String:pFriend->cNickname];
	
	
	iXfireAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	[delegate.m_pNavController  pushViewController:pProfileView animated:YES];
	
	[pProfileView release];
	
}

- (void)dealloc
{
    [super dealloc];
}
@end
