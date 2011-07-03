//
//  GroupChatController.m
//  iXfire
//
//  Created by Moti Joseph on 2/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GroupChatController.h"
#import <Three20/Three20.h>
#import  "iXfireAppDelegate.h"
#import "GroupInviteController.h"

#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 8.0f


@implementation GroupChatController

@synthesize                 m_pPanelChat;       
@synthesize                 m_pPanelInput;         
@synthesize                 m_pChatMessages;
@synthesize                 m_pInputField;
@synthesize                 m_ActiveGroupChannel;




- (void)viewWillDisappear:(BOOL)animated
{
	
    	
	
	
}




/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/


-(void)                        groupAction:(id) sender

{
	
	
	GroupInviteController    *invite=[[GroupInviteController alloc] initWithNibName:@"GroupInviteController" bundle:nil ];
	
	
	
	
	iXfireAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	[delegate.m_pNavController  pushViewController:invite animated:YES];
	
	
	[invite release];

	
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {

    [super viewDidLoad];

	[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications]; 
	[[NSNotificationCenter defaultCenter] addObserver:self										
											 selector:@selector(didRotate:) name:UIDeviceOrientationDidChangeNotification object:nil];
	
	
	
	_tabBar1 = [[TTTabStrip alloc] initWithFrame:CGRectMake(0, 0, 320, 41)];
	
	
	UIBarButtonItem *groupButton=[[UIBarButtonItem alloc]
								  initWithTitle:@"Add"
								  style:UIBarButtonItemStylePlain
								  target:self
								  action:@selector(groupAction:)];
	
	
	self.navigationItem.rightBarButtonItem=groupButton;
	[groupButton release];
 
 
	
	
		
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	
	
	NSLog(@"numberOfRowsInSection %d", [m_ActiveGroupChannel->messages count]);
	return [m_ActiveGroupChannel->messages count];
}


-(void) refreshContacts
{
	
	
	NSMutableArray *users=[[NSMutableArray alloc] initWithObjects:nil];
	for (int i=0; i<[m_ActiveGroupChannel->users count]; i++)
	{
	
		
    	XGroupUser *pGroupUser=[m_ActiveGroupChannel->users objectAtIndex:i];
		
		[users addObject:[   [[TTTabItem alloc] initWithTitle:[NSString stringWithFormat:@"%s",pGroupUser->name]]
						  autorelease]];
	}
	
		
	UIColor *borderTintColor = RGBCOLOR(18, 40, 63); 
	UIColor *bgTintColor = RGBCOLOR(18, 40, 63); 

	
	/*
	_tabBar1.style = [TTSolidFillStyle styleWithColor:bgTintColor 
								next: [TTFourBorderStyle styleWithTop:bgTintColor right:bgTintColor 
															   bottom:bgTintColor left:bgTintColor width:1 
																 next:nil]]; 

	
	 */
	_tabBar1.tabItems =users; 	

	self.navigationItem.titleView =_tabBar1;
	
	[users release];
	
}


-(void) refresh
{
	
	
	[m_pChatMessages reloadData];
	
	[m_pChatMessages scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[m_ActiveGroupChannel->messages count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];

}

- (NSString *)getTextForIndexPath:(NSIndexPath *)indexPath
{
	
	NSUInteger row = [indexPath row];
	
	return [m_ActiveGroupChannel->messages objectAtIndex:row];
	
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
	NSString *text=[self getTextForIndexPath:indexPath];
	
	CGSize size=[text sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(240.0f,480.0f) lineBreakMode:UILineBreakModeWordWrap];
	
	return size.height+15;
	
}
#define  kBallonView 1
#define  kLabel  2
#define  kMessage 3


- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	
	static NSString *CellIdentifier=@"GroupChatIdentifier";
	
	UIImageView *balloonView;
	
	UILabel     *label;
	
    UITableViewCell*	cell = [tv dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell==nil){
		
		
		cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
		tv.separatorStyle=UITableViewCellSeparatorStyleNone;
		
		balloonView=[[UIImageView alloc] init];
		balloonView.tag=kBallonView;
		
		label=[[UILabel alloc] init];
		label.tag=kLabel;
		label.backgroundColor=[UIColor clearColor];
		label.numberOfLines=0;
		label.lineBreakMode=UILineBreakModeWordWrap;
		label.font=[UIFont systemFontOfSize:14.0];
		
		
		UIView *message=[[UIView alloc] initWithFrame:CGRectMake(0,0,cell.frame.size.width,cell.frame.size.height)];
		message.tag=kMessage;
		[message addSubview:balloonView];
		[message addSubview:label];
		
		message.autoresizingMask=UIViewAutoresizingFlexibleWidth;
		[cell.contentView addSubview:message];
		
		[balloonView release];
		[label release];
		[message release];
	}
	else{
		
		balloonView=(UIImageView*)[[cell.contentView viewWithTag:kMessage] viewWithTag:kBallonView];
		label=(UILabel*)[[cell.contentView viewWithTag:kMessage] viewWithTag:kLabel];
		
		
	}
	
	NSString *text=[self getTextForIndexPath:indexPath];
	CGSize size=[text sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(240.0f,480.0f) lineBreakMode:UILineBreakModeWordWrap];
	UIImage *balloon;
	
	if (indexPath.row %2==0){
		
		
		balloonView.frame=CGRectMake(320.0f-(size.width+28.0f),2.0f,size.width+28.0f,size.height+15.0f);
		balloonView.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin;
		balloon=[[UIImage imageNamed:@"aqua.png"] stretchableImageWithLeftCapWidth:24.0 topCapHeight:15.0f];
		
		label.frame=CGRectMake(307.0f-(size.width+5.0f),8.0f,size.width+5.0f,size.height);
		
		label.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin;
		
	}
	else{
		
		
		balloonView.frame=CGRectMake(0.0f,2.0f,size.width+28.0f,size.height+15.0f);
		balloonView.autoresizingMask=UIViewAutoresizingFlexibleRightMargin;
		balloon=[[UIImage imageNamed:@"grey_2.png"] stretchableImageWithLeftCapWidth:24.0 topCapHeight:15.0f];
		
		label.frame=CGRectMake(16.0f,8.0f,size.width+5.0f,size.height);
		
		label.autoresizingMask=UIViewAutoresizingFlexibleRightMargin;
		
	}
	
	balloonView.image=balloon;
	label.textColor=[UIColor blackColor];
	label.text=text;
	
	return cell;
	
	
	
	
}

/*
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{


	UITableViewCell *cell;

	TTStyledTextLabel* label=nil;
	

	NSString *text =0;
	
	
	text = [self getTextForIndexPath:indexPath];
	
	
		
	
	cell = [tv dequeueReusableCellWithIdentifier:@"GroupChatIdentifier"];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"GroupChatIdentifier"] autorelease];
		
		
		label = [[[TTStyledTextLabel alloc] initWithFrame:CGRectZero ] autorelease];
		label.font = [UIFont systemFontOfSize:13];

		label.backgroundColor=[UIColor  clearColor];
		label.textColor=[UIColor whiteColor];
		[label setTag:1];
		[[cell contentView] addSubview:label];
		
	}
	
	
	if (!label) {
		label = (TTStyledTextLabel*)[cell viewWithTag:1];
	}
	
	CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
	
	CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
	[label setFrame:CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), MAX(size.height, 44.0f))];
	
	
	
	label.text =  [TTStyledText textWithURLs:text lineBreaks:YES ];
	
	
	
	return cell;
}
*/

-(void) setGroup:(XfGroupChannel*)group
{
	
	m_ActiveGroupChannel=group;
	
	self.title =[NSString  stringWithFormat:@"room %s",m_ActiveGroupChannel->room];
	
}


- (void)viewWillAppear:(BOOL)animated

{

	
	self.view.backgroundColor =OPAQUE_HEXCOLOR(g_XfBackgroundColor);
	
	m_pChatMessages.backgroundColor=OPAQUE_HEXCOLOR(g_XfBackgroundColor);
	
	
	m_pPanelChat.frame=CGRectMake(0, 0, 320, 165);
	m_pPanelInput.frame = CGRectMake(0, 190, 320, 31);
	
	
	if (UIDeviceOrientationIsPortrait(m_orientation))
		
	{
		
		m_pPanelChat.frame=CGRectMake(0, 0, 320, 165);
		m_pPanelInput.frame = CGRectMake(0, 190, 320, 31);
		
		
	}
	if (UIDeviceOrientationIsLandscape(m_orientation))
	{
		
		
		
		m_pPanelInput.frame=CGRectMake(0, 95, 480, 31);
		m_pPanelChat.frame=CGRectMake(0, 0, 480, 80);
	}
	
	[m_pInputField becomeFirstResponder];

	[super viewWillAppear:YES];
	
}

// called to get permission to rotate this view to some new orientation.
// always allow it
- (void) didRotate:(NSNotification *)notification
{	
	UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
	m_orientation=	orientation;
    if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation))
		
	{
		m_pPanelChat.frame=CGRectMake(0, 0, 320, 165);
		m_pPanelInput.frame = CGRectMake(0, 190, 320, 31);
		
		
	}
	if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
	{
		
		m_pPanelInput.frame=CGRectMake(0, 95, 480, 31);
		m_pPanelChat.frame=CGRectMake(0, 0, 480, 80);
	}
	
	
}
/*

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
	
	NSString *text = [self getTextForIndexPath:indexPath];
	
	
	
	
	CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
	
	CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
	
	CGFloat height = MAX(size.height, 44.0f);
	
	return height + (CELL_CONTENT_MARGIN * 2)-20;
}*/


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	
	
	
	if (strlen([m_pInputField.text UTF8String])==0) {
		
		
		return NO;
		
	}
	
	[g_pXfireNetCore XfMobileGChat_SendIM:m_ActiveGroupChannel->gsid   msg:[m_pInputField.text  UTF8String] ];
	
	textField.text=@"";
	
	
	return NO;
}



-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orient
{
	
	if (orient==UIDeviceOrientationPortraitUpsideDown) return FALSE;
	
    return TRUE;
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
	
	[m_pPanelChat release];
	[m_pPanelInput release];
	[m_pChatMessages release];
	[m_pInputField release];
	
	
	TT_RELEASE_SAFELY(_tabBar1);
    [super dealloc];
}


@end
