//
//  ProfileViewController.m
//  iXfire
//
//  Created by Moti Joseph on 4/27/09.
//  Copyright 2009 Gamepe. All rights reserved.
//

#import "ProfileViewController.h"


@implementation ProfileViewController
@synthesize m_webProfilebView;
@synthesize m_pLoadingProfilectivityIndicator;


/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.


- (void)viewWillDisappear:(BOOL)animated
{
	
	
		
}


- (void)webViewDidStartLoad:(UIWebView *)webView
{

	
	
	[m_pLoadingProfilectivityIndicator startAnimating];
	
	
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	
	m_pLoadingProfilectivityIndicator.hidden=TRUE;
	[m_pLoadingProfilectivityIndicator stopAnimating];
	
}

- (void)viewWillAppear:(BOOL)animated

{
	
	//Create a URL object.
	NSURL *url = [NSURL URLWithString:[NSString stringWithUTF8String:m_cProfileURL]];
	
	//URL Requst Object
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	
	
		//Load the request in the UIWebView.
	[m_webProfilebView loadRequest:requestObj];
	
}
- (void)viewDidLoad {
    [super viewDidLoad];
}


-(void) setProfileURL:(char*) pURL
{
	
	strcpy(m_cProfileURL,pURL);
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
	
	[m_pLoadingProfilectivityIndicator release];
	[m_webProfilebView release];
    [super dealloc];
}


@end
