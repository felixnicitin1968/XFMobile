//
//  MyStatusController.m
//  iXfire
//
//  Created by Moti Joseph on 10/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MyStatusController.h"
#import "global.h"

#import  "iXfireAppDelegate.h"

@implementation MyStatusController

@synthesize     m_myStatusTextField;


@synthesize      m_pContactsController;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.



-(void) OnMyStatusEditingDone
{

	NSLog(@"doneeee");
	
	
	strcpy(g_cMyStatusMessage,[m_myStatusTextField.text UTF8String]);
	
    [g_pXfireNetCore XfMobile_MessageOfTheDay:g_cMyStatusMessage] ;
	
	
		
	//[mystatus setText:[NSString stringWithUTF8String:g_cMyStatusMessage]];

	iXfireAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	
	[delegate.m_pNavController  popToViewController:m_pContactsController animated:YES];
	

	
	
}




- (void)viewDidLoad {
	
	
    [super viewDidLoad];
	
	
	UIBarButtonItem *doneButton=[[UIBarButtonItem alloc]
								   initWithTitle:@"Done"
								   style:UIBarButtonItemStyleBordered
								   target:self
								   action:@selector(OnMyStatusEditingDone)];
	
	
	self.navigationItem.rightBarButtonItem=doneButton;
	[doneButton release];

	
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/



- (void)viewWillAppear:(BOOL)animated

{

    m_myStatusTextField.text=[NSString stringWithFormat:@"%s",g_cMyStatusMessage];
	[m_myStatusTextField becomeFirstResponder];
	
	
	
}


- (void)setParent:(ContactsViewController *)controller;
{

	
	m_pContactsController=controller;
	
}
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
	[ m_myStatusTextField release];
}


@end
