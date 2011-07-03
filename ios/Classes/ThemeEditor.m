//
//  ThemeEditor.m
//  iXfire
//
//  Created by Moti Joseph on 4/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ThemeEditor.h"
#import "ColorPickerViewController.h"
#import "iXfireAppDelegate.h"
#import "PTColorAlertView.h"
#import "global.h"
@implementation ThemeEditor
@synthesize viewController;
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


int           g_ThemeType;

#define       XF_BACKGROUND_COLOR                 0
#define       XF_CONTACT_NAME_TEXT_COLOR          1
#define       XF_CONTACT_STATUS_TEXT_COLOR        2
#define       XF_CONTACT_SECTION_BACKGROUND_COLOR 3
#define       XF_CONTACT_SECTION_TEXT_COLOR       4
#define       XF_NAVBAR_BACKGROUND_COLOR          5
#define       XF_CONTACT_SEPARATOR_COLOR          6

#define       XF_XFIRE_THEME                      7


- (void)viewWillAppear:(BOOL)animated

{
	

	tblSimpleTable.backgroundColor=OPAQUE_HEXCOLOR(g_XfBackgroundColor);
	
	
	
	
	
	
	
	
}

- (void)viewDidLoad 
{
	
	
	arryXfMobileScreen= [[NSArray alloc] initWithObjects:@"Background Color",@"Xfire Theme",nil];
	arryContactsScreen = [[NSArray alloc] initWithObjects:@"Text Color",@"Status Color",@"Title Background Color",@"Title Text Color",@"Separator Color",nil];
	
	arryNavigationbar= [[NSArray alloc] initWithObjects:@"Background Color",nil];
	
	self.title = @"Theme Editor";
	[super viewDidLoad];
	
	
}




//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	NSString *sectionName = nil;
	
	switch(section)
	{
		case 0:
		  
			sectionName = [NSString stringWithFormat:@"XfMobile"];
			break;
			
		case 1:
			
		
			
			sectionName = [NSString stringWithFormat:@"Contacts Screen"];

			break;
	
			
		case 2:
			
			
			sectionName = [NSString stringWithFormat:@"Navigation Bar"];
		default:
			break;
	}

	
	UILabel *sectionHeader = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)] autorelease];
    sectionHeader.backgroundColor = [UIColor clearColor];
	sectionHeader.font = [UIFont boldSystemFontOfSize:15];
	sectionHeader.textColor = OPAQUE_HEXCOLOR(g_XfContactsNameTextColor);
	sectionHeader.text = sectionName;
		sectionHeader.textAlignment= UITextAlignmentCenter;
	
	return sectionHeader;
	
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	
	return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	
	switch(section)
	{
		case 0:
			
			return [arryXfMobileScreen count];

			
		case 1:
			
			return [arryContactsScreen count];
			
		case 2:
			
			return [arryNavigationbar count];
			
			
			
		default:
			break;
	}
	
	
	
	return 0;

	
	
}

- (void)didPresentAlertView:(UIAlertView *)alertView 
{
	[(PTColorAlertView *)alertView presetSlidersWithColor:[UIColor blueColor]]; 
	//[(PTColorAlertView *)alertView presetSlidersWithRandomValues];
}







- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	
	
	switch (buttonIndex) {
			
			
		case 0: //Cancel
			
			
			break;
			
			
		case 1: //Set
			
			switch (g_ThemeType) {
				case XF_BACKGROUND_COLOR:
					
					g_XfBackgroundColor=[(PTColorAlertView *)alertView getRGBColor];
				   break;
					
				case XF_CONTACT_NAME_TEXT_COLOR:
					g_XfContactsNameTextColor=[(PTColorAlertView *)alertView getRGBColor];
					break;
					
				case XF_CONTACT_STATUS_TEXT_COLOR:
					g_XfContactsStatusTextColor=[(PTColorAlertView *)alertView getRGBColor];
					break;
				case XF_CONTACT_SECTION_BACKGROUND_COLOR:
					g_XfContactSectionBackgroundTextColor=[(PTColorAlertView *)alertView getRGBColor];
					
					break;
					
				case XF_CONTACT_SECTION_TEXT_COLOR:
					g_XfContactSectionTextColor=[(PTColorAlertView *)alertView getRGBColor];
					
					break;
					
				case XF_NAVBAR_BACKGROUND_COLOR:
					
					g_XfNavBarBackgroundColor=[(PTColorAlertView *)alertView getRGBColor];
					
					
					break;
					
				case XF_CONTACT_SEPARATOR_COLOR:
					g_XfContactSeparatorColor=[(PTColorAlertView *)alertView getRGBColor];
					
					
					break;
					
				case XF_XFIRE_THEME:
					
					break;
					
				default:
					break;
			}
			
			
		
			
			break;
		default:
			break;
	}
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
	
	
	
	NSUInteger row = [indexPath row];
	
	NSUInteger section = [indexPath section];
	
	
    switch (section) {
			
		case XFMOBILE_NAVBAR_THEME:
			
			switch (row) {
					
				case XFMOBILE_NAVBAR_THEME_BACKGROUND_COLOR:
				{
					
					g_ThemeType=XF_NAVBAR_BACKGROUND_COLOR;
					PTColorAlertView *alert = [[PTColorAlertView alloc] initWithTitle:@"BackgroundColor" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Set", nil];
					[alert show];
					[alert release];
				}
					break;
					
				case 1:
					break;
					
				default:
					break;
			}

			
			
			break;
			
		case XFMOBILE_THEME:
		
			 switch (row) {
				
				 case XFMOBILE_THEME_BACKGROUND_COLOR:
				 {
					 
					 g_ThemeType=XF_BACKGROUND_COLOR;
					 
					 PTColorAlertView *alert = [[PTColorAlertView alloc] initWithTitle:@"BackgroundColor" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Set", nil];
					 
					 UIColor *color=OPAQUE_HEXCOLOR(g_XfBackgroundColor);
					 
					 [alert presetSlidersWithColor:color];
					 
					 [alert show];
					 
					 [alert release];
				 }
					 break;
					 
				 case XFMOBILE_XFIRE_THEME:
					 
				 {
									 
					     g_XfContactSeparatorColor=0xFFFFFFFF;
					     g_XfNavBarBackgroundColor=0xFF12283f;
					     g_XfContactSectionTextColor=0xFF8ABAFF;
					     g_XfContactSectionBackgroundTextColor=0x144083;//0xFF8ABAFF;
					     g_XfBackgroundColor=     0xFF12283f;   //184063
					     g_XfContactsStatusTextColor=0xFF8ABAF1;
					     g_XfContactsNameTextColor=0xFFFFFFFF;
					
					 
					 
					 iXfireAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
					 
					 UIActionSheet *actionSheet = [[UIActionSheet alloc] 
												   initWithTitle:@"Xfire Theme Applied"
												   delegate:nil 
												   cancelButtonTitle:@"OK"
												   destructiveButtonTitle:nil 
												   otherButtonTitles:nil];
					 [actionSheet showInView:delegate.m_pNavController.visibleViewController.view];
					 [actionSheet release];
					 
					 
					 
					 
				 }					 
					 
					 break;
					 
				 default:
					 break;
			 }
		
			
			break;
		case XFMOBILE_CONTACTS_THEME:
			
			
			switch (row) {
					
				case XFMOBILE_CONTACTS_THEME_TEXT_COLOR:
				{
					g_ThemeType=XF_CONTACT_NAME_TEXT_COLOR;
					PTColorAlertView *alert = [[PTColorAlertView alloc] initWithTitle:@"Contacts TxtColor" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Set", nil];
					[alert show];
					[alert release];
					
				}
					break;
					
				case XFMOBILE_CONTACTS_THEME_STATUS_TEXT_COLOR:
				{
					g_ThemeType=XF_CONTACT_STATUS_TEXT_COLOR;
					PTColorAlertView *alert = [[PTColorAlertView alloc] initWithTitle:@"Contacts Status TxtColor" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Set", nil];
					[alert show];
					[alert release];
				
				}
					break;
					
				case XFMOBILE_CONTACTS_THEME_SECTION_BACKGROUND_COLOR:
					
				{
					g_ThemeType=XF_CONTACT_SECTION_BACKGROUND_COLOR;
					PTColorAlertView *alert = [[PTColorAlertView alloc] initWithTitle:@"Contacts Title BGColor" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Set", nil];
					[alert show];
					[alert release];
					break;
				}
					
				case XFMOBILE_CONTACTS_THEME_SECTION_TEXT_COLOR:
					
				{
					g_ThemeType=XF_CONTACT_SECTION_TEXT_COLOR;
					PTColorAlertView *alert = [[PTColorAlertView alloc] initWithTitle:@"Contacts Title TxtColor" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Set", nil];
					[alert show];
					[alert release];
					
				}
					break;
				case XFMOBILE_CONTACTS_THEME_SEPARATOR_COLOR:
					
				{
					g_ThemeType=XF_CONTACT_SEPARATOR_COLOR;
					PTColorAlertView *alert = [[PTColorAlertView alloc] initWithTitle:@"Contacts Title TxtColor" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Set", nil];
					[alert show];
					[alert release];
					
				}
					break;
					
				default:
					break;
			}
			
			
			break;
			
		default:
			break;
	}
	
	
	
	
//   ColorPickerViewController    *colorPicker=[[ColorPickerViewController alloc] initWithNibName:@"ColorPickerViewController" bundle:nil ];

   //  [self presentModalViewController:viewController  animated:YES];
	//  [self.view  addSubview:colorPicker.view];
	
	
//	[self.view addSubview:viewController.view];
	
	//[self.view bringSubviewToFront:self.viewController.view];
	
	//[colorPicker release];
	
		
	
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"ThemeEditorCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
	}
	
	// Set up the cell...
	
	
	switch(indexPath.section)
	{
		case 0:
			
			cell.textLabel.text = [arryXfMobileScreen objectAtIndex:indexPath.row];
			
			break;
			
			
		case 1:
			
			cell.textLabel.text = [arryContactsScreen objectAtIndex:indexPath.row];
			
			break;
			
		case 2:
			
			cell.textLabel.text = [arryNavigationbar  objectAtIndex:indexPath.row];
			
			break;
			
			
			
		default:
			break;
	}

	
	
		
	return cell;
}




- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	
	[viewController release];
	
	[arryNavigationbar release];
	
	[arryContactsScreen release];
	
	[arryXfMobileScreen release];
	
    [super dealloc];
}


@end
