//
//  IMController.m
//  iXfire
//
//  Created by Moti Joseph on 4/9/09.
//  Copyright 2009 Gamepe. All rights reserved.
//

#import    "ChatViewController.h"
#include   "iXfireAppDelegate.h"
#include   "LoginViewControlller.h"
#include   "XfireCore.h"
#import    "global.h"

#include   "ContactsViewController.h"
#import    <AudioToolbox/AudioToolbox.h>
#import    "UIImage+Resize.h"
#import    "ProfileViewController.h"
#import "AsyncImageView.h"
#import <Three20/Three20.h>
static const NSInteger  kTotalTextFields   =    20;
static const CGFloat    kTextFieldFontSize =  17.0;
static const CGFloat    kTextFieldHeight   =  30.0;
static const CGFloat    kTextFieldWidth    = 150.0;

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 140;
   

#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 8.0f



@implementation ChatViewController

@synthesize m_pMessage;
@synthesize m_pMessagesTableView;
@synthesize m_pInputText;

//@synthesize m_pContact;
@synthesize m_pChatView;

-(IBAction)              OnOpenGamepe:(id) sender
{
	
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.xf-mobile.com"]];
	
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // this will appear as the title in the navigation bar
        CGRect frame = CGRectMake(0, 0, 400, 44);
        UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:17.0];
      //  label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        label.textAlignment = UITextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        self.navigationItem.titleView = label;
       // 
    }
	
    return self;
}
- (void)viewWillDisappear:(BOOL)animated
{
	
    

	
	[m_pMutableMessageslist removeAllObjects];
	
	
	[m_pMessagesTableView reloadData];
	
	[m_pMessage resignFirstResponder];
	
	
	
}


 - (void)viewWillAppear:(BOOL)animated

{
	
	self.view.backgroundColor =OPAQUE_HEXCOLOR(g_XfBackgroundColor);
	
	m_pChatView.backgroundColor=OPAQUE_HEXCOLOR(g_XfBackgroundColor);
	

	
	
		m_pChatView.frame=CGRectMake(0, 0, 320, 150);
    	m_pInputText.frame = CGRectMake(0, 190, 320, 31);
	
	
	if (UIDeviceOrientationIsPortrait(g_orientation))
		
	{
		
		m_pChatView.frame=CGRectMake(0, 0, 320, 150);
		m_pInputText.frame = CGRectMake(0, 190, 320, 31);
		
		
	}
		if (UIDeviceOrientationIsLandscape(g_orientation))
	{
		
		
	
		m_pInputText.frame=CGRectMake(0, 95, 480, 31);
		m_pChatView.frame=CGRectMake(0, 0, 480, 60);
	}
		
		[m_pMessage becomeFirstResponder];
	
	XFireContact *pContact=[self GetContact];
	if (pContact==NULL) return;
	
	for (int i=0; i<[pContact->Messageslist count]; i++){
		
		
	
			[m_pMutableMessageslist addObject:[NSString stringWithFormat:@"\n%@",[pContact->Messageslist objectAtIndex:i]]];
			
		
	    }
	[m_pMessagesTableView reloadData];
	
	if ([m_pMutableMessageslist count]>=1){
	
	
	    [m_pMessagesTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[m_pMutableMessageslist count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];

	}
   [super viewWillAppear:YES];
	
}

// called to get permission to rotate this view to some new orientation.
// always allow it
- (void) didRotate:(NSNotification *)notification
{	
	UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
	g_orientation=	orientation;
    if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation))
		
	{
		m_pChatView.frame=CGRectMake(0, 0, 320, 150);
		m_pInputText.frame = CGRectMake(0, 190, 320, 31);
		
		
	}
	if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
	{
		
		m_pInputText.frame=CGRectMake(0, 95, 480, 31);
		m_pChatView.frame=CGRectMake(0, 0, 480, 60);
	}
	
	
}
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orient
{
	
	if (orient==UIDeviceOrientationPortraitUpsideDown) return FALSE;
	
    return TRUE;
}
- (void)viewDidLoad
{
	
		
	[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications]; 
	[[NSNotificationCenter defaultCenter] addObserver:self										
											 selector:@selector(didRotate:) name:UIDeviceOrientationDidChangeNotification object:nil];

/*	
	UIBarButtonItem *clearButton=[[UIBarButtonItem alloc]
								   initWithTitle:@"Clear"
								   style:UIBarButtonItemStylePlain
								   target:self
								   action:@selector(clearChatView)];
	
	
	self.navigationItem.rightBarButtonItem=clearButton;
	[clearButton release];
 */
	
	
	UIBarButtonItem *myBarButton = [[UIBarButtonItem alloc]
									initWithImage:[UIImage imageNamed:@"pics.png"] 
									style:UIBarButtonItemStyleDone target:self action:@selector(clearChatView)];
	
	self.navigationItem.rightBarButtonItem=myBarButton ;
	
	[myBarButton release];
	
	
	
	
/*	UIButton *button                  = [UIButton buttonWithType: UIButtonTypeRoundedRect];
	button.titleLabel.font            = [UIFont systemFontOfSize: 12];
	button.titleLabel.lineBreakMode   = UILineBreakModeTailTruncation;
	button.titleLabel.shadowOffset    = CGSizeMake (1.0, 0.0);
	//button.titleLabel="xxx";
	
	
	self.navigationItem.titleView=button;*/
	
	
	 m_pMutableMessageslist=[[NSMutableArray alloc] initWithObjects:nil]; 

	

	[super viewDidLoad];

}


-(void)   clearChatView
{
		
	
	//[m_pMutableMessageslist removeAllObjects];
	//[m_pMessagesTableView reloadData];
	
	[g_pXfireNetCore XfMobile_GetData:m_userid];
	
	
	
	
}

-(void)     SetChattingMode:(uint32) userid
{
	
	if (m_userid==-1) return;
	
	if (userid!=m_userid) return;
	
	
	
	UILabel *label =self.navigationItem.titleView;
	

	XFireContact *pContact=[self GetContact];
	label.text = NSLocalizedString([NSString stringWithUTF8String:pContact->cNickname], @"");
	label.textColor = [UIColor whiteColor];
	
	
	
	
}

-(void)     SetTypingMode:(uint32) userid
{
	
	
	if (m_userid==-1) return;
	
	if (userid!=m_userid) return;
	
	
	
	UILabel *label =self.navigationItem.titleView;
	label.text = NSLocalizedString(@"typing...", @"");
	
	label.textColor = [UIColor whiteColor];

	
}

-(XFireContact*)      GetContact
{
	
	
 
 XFireContact* pFriend=[g_pXfireNetCore getContactByUserid:m_userid];

 if (pFriend==NULL)
 {
	
	 pFriend=[g_pXfireNetCore  getClanContactByUserid:m_userid];
 }

  return pFriend;
}




-(void)      SetContact:(int) userid
{
	
	
	m_userid=userid;
	
	
	
	if (m_userid==-1){
	
		NSLog(@"userid=",m_userid);
	
	}
	UILabel *label =self.navigationItem.titleView;
	
	
	XFireContact *pContact=[self GetContact];
	
	if (pContact->cNickname[0]==0){
		
		label.text = NSLocalizedString([NSString stringWithUTF8String:pContact->cUsername], @"");
		
	}else{
	label.text = NSLocalizedString([NSString stringWithUTF8String:pContact->cNickname], @"");
	
	}
		
	label.textColor = [UIColor whiteColor];
	
	[m_pMessagesTableView reloadData];
	

		
	
//	[m_pMessage resignFirstResponder];
	
}



             
- (void)willAnimateSecondHalfOfRotationFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation duration:(NSTimeInterval)duration {
	
	
	

	UIInterfaceOrientation toInterfaceOrientation = self.interfaceOrientation;
	m_toInterfaceOrientation=toInterfaceOrientation;
	[UIView beginAnimations:@"move inputedit" context:nil];
	
	if (toInterfaceOrientation == UIInterfaceOrientationPortrait)
	{
		
		
	    	m_pChatView.frame=CGRectMake(0, 0, 320, 150);
			m_pInputText.frame = CGRectMake(0, 190, 320, 31);
	
	
		
	}
	else if (toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation==UIInterfaceOrientationLandscapeRight)
		
		
	{
		
		m_pInputText.frame=CGRectMake(0, 95, 480, 31);
		m_pChatView.frame=CGRectMake(0, 0, 480, 60);
	}
	
	[UIView commitAnimations];
	
	if ([m_pMutableMessageslist count]>=1){
	
	//	[m_pMessagesTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[m_pMutableMessageslist count] inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];

	}
}





-(void) OnRecvMessage: (uint32)userid Msg:(char*)pMessage
{

	
	if (m_userid==-1) return;	
	
	if (userid!=m_userid) return;
	
	XFireContact *pActiveFriend=[self GetContact];
		
	
				
	NSLog([NSString stringWithUTF8String:pActiveFriend->cNickname]);
	
	
	[m_pMutableMessageslist addObject:[NSString stringWithFormat:@"\n%@: %@",[NSString stringWithUTF8String:pActiveFriend->cNickname],[NSString stringWithUTF8String:pMessage]]];
		
	//[m_pMutableMessageslist addObject:[NSString stringWithFormat:@"\n%@: %s",[NSString stringWithUTF8String:pActiveFriend->cNickname],pMessage]];
	
		
	
	 
	 [self SetChattingMode:userid];
	
	 [m_pMessagesTableView reloadData];
	
	 if ([m_pMutableMessageslist count]>=1){
	
	   [m_pMessagesTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[m_pMutableMessageslist count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
	
	}
	
}




- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	

	
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	
	
	
	if (m_userid==-1) {
	
		
		NSLog(@"userid==-1 error");
		return NO;
		
	}
	
	
	if (strlen([m_pMessage.text UTF8String])==0) {
	
		
		return NO;
		
	}

	
	
   
	
	XFireContact *pContact=[self GetContact];
	
	if (pContact->uStatus==MISTATUS_OFFLINE){
	
		
		
		
		[m_pMutableMessageslist addObject:[NSString stringWithFormat:@"\n%s: %@",[g_pXfireNetCore mynickname] ,@"<user is offline>"]];
		
		[m_pMessagesTableView reloadData];
		[m_pMessagesTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[m_pMutableMessageslist count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
		
		
		return NO;
	}
	
	
	
	[m_pMutableMessageslist addObject:[NSString stringWithFormat:@"\n%@: %@",[NSString stringWithUTF8String:[g_pXfireNetCore mynickname]] ,[NSString stringWithUTF8String:[textField.text UTF8String]]]];
	[m_pMessagesTableView reloadData];
	[m_pMessagesTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[m_pMutableMessageslist count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
	
	
	
	
	if (pContact->Messageslist ==nil){
		

              pContact->Messageslist=[[NSMutableArray alloc] initWithObjects:nil]; 
	
	}
	
	
	
	[pContact->Messageslist addObject:[NSString stringWithFormat:@"%@: %@",[NSString stringWithUTF8String:[g_pXfireNetCore mynickname]],[NSString stringWithUTF8String:[m_pMessage.text  UTF8String]]]];

	if (pContact->sid[0]==0) {
		
		
		NSLog(@"EROROR EROROR EROROR EORORORORORORORORO");
		
	}
	

	[g_pXfireNetCore XfMobile_SendIM:pContact->sid  Imindex:0  msg:[m_pMessage.text  UTF8String] ];

	textField.text=@"";
	

	return NO;
}



- (CGSize)GetSizeOfText:(NSString *)text withFont:(UIFont *)font
{
	return [text sizeWithFont: font constrainedToSize:CGSizeMake(280, 500)];
}

-(IBAction) ImDoneTyping:(id) sender
{
	
	
	[self textFieldShouldReturn:m_pMessage];
	       
	
}







- (void)didReceiveMemoryWarning

{
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc

{
	
	
	[m_pMutableMessageslist release];
	[m_pMessagesTableView release];
    [m_pMessage       release];	
    [super dealloc];
}

#pragma mark -
#pragma mark Table View Data Source Methods




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	
	
		return [m_pMutableMessageslist count];
}




-(UITextField*)createTextField
{
    CGRect  rect = CGRectMake(0.0, 0.0, kTextFieldWidth, kTextFieldHeight);
    UITextField*  text = nil;
    
    text = [[[UITextField alloc] initWithFrame:rect] autorelease];
    
    text.backgroundColor = [UIColor whiteColor];
    text.borderStyle     = UITextBorderStyleRoundedRect;
    text.clearButtonMode = UITextFieldViewModeWhileEditing;
   // text.delegate        = self;
    text.font            = [UIFont systemFontOfSize:kTextFieldFontSize];
    text.keyboardType    = UIKeyboardTypeDefault;
    text.returnKeyType   = UIReturnKeyDone;
    text.text            = @"item text";
    text.textColor       = [UIColor blackColor];
    
    return text;
}



- (NSString *)getTextForIndexPath:(NSIndexPath *)indexPath
{
	NSUInteger row = [indexPath row];
	
	
	return [m_pMutableMessageslist objectAtIndex:row];
	
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
	

	static NSString *CellIdentifier=@"ChatCell";
	
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
	
	char *nickname=[g_pXfireNetCore mynickname];
	
	if ( strlen(nickname) < strlen([text UTF8String])){
	
		
		if (strstr([text UTF8String],[g_pXfireNetCore mynickname])){
			
			
			balloonView.frame=CGRectMake(0.0f,2.0f,size.width+28.0f,size.height+15.0f);
			balloonView.autoresizingMask=UIViewAutoresizingFlexibleRightMargin;
			balloon=[[UIImage imageNamed:@"grey_2.png"] stretchableImageWithLeftCapWidth:24.0 topCapHeight:15.0f];
			
			label.frame=CGRectMake(16.0f,8.0f,size.width+5.0f,size.height);
			
			label.autoresizingMask=UIViewAutoresizingFlexibleRightMargin;
			
			
			
		}else{
		
			
			balloonView.frame=CGRectMake(320.0f-(size.width+28.0f),2.0f,size.width+28.0f,size.height+15.0f);
			balloonView.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin;
			balloon=[[UIImage imageNamed:@"aqua.png"] stretchableImageWithLeftCapWidth:24.0 topCapHeight:15.0f];
			
			label.frame=CGRectMake(307.0f-(size.width+5.0f),8.0f,size.width+5.0f,size.height);
			
			label.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin;
			
		}
		
		
		
		
	}
	else{
		
		
		balloonView.frame=CGRectMake(320.0f-(size.width+28.0f),2.0f,size.width+28.0f,size.height+15.0f);
		balloonView.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin;
		balloon=[[UIImage imageNamed:@"aqua.png"] stretchableImageWithLeftCapWidth:24.0 topCapHeight:15.0f];
		
		label.frame=CGRectMake(307.0f-(size.width+5.0f),8.0f,size.width+5.0f,size.height);
		
		label.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin;
		
	}
	
	/*
	
	if (indexPath.row %2==0){
	
		
		balloonView.frame=CGRectMake(0.0f,2.0f,size.width+28.0f,size.height+15.0f);
		balloonView.autoresizingMask=UIViewAutoresizingFlexibleRightMargin;
		balloon=[[UIImage imageNamed:@"grey_2.png"] stretchableImageWithLeftCapWidth:24.0 topCapHeight:15.0f];
		
		label.frame=CGRectMake(16.0f,8.0f,size.width+5.0f,size.height);
		
		label.autoresizingMask=UIViewAutoresizingFlexibleRightMargin;
		
	
	 }
		else{
		
			
			balloonView.frame=CGRectMake(320.0f-(size.width+28.0f),2.0f,size.width+28.0f,size.height+15.0f);
			balloonView.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin;
			balloon=[[UIImage imageNamed:@"aqua.png"] stretchableImageWithLeftCapWidth:24.0 topCapHeight:15.0f];
			
			label.frame=CGRectMake(307.0f-(size.width+5.0f),8.0f,size.width+5.0f,size.height);
			
			label.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin;
					
		}*/
			
			balloonView.image=balloon;
	        label.textColor=[UIColor blackColor];// OPAQUE_HEXCOLOR(g_XfContactsNameTextColor);
			label.text=text;
			
			return cell;
	
	
	
	
}- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	
	NSUInteger row = [indexPath row];
	
	XFireContact *pFriend=[self GetContact];

	if (pFriend->Messageslist!=nil){
	
		
		if (row <1 || row>100 ) return;
		
		char *url=get_url([[pFriend->Messageslist objectAtIndex:row] UTF8String]);
		if  (memcmp(url,"http",4)==0){
		
			
		
			ProfileViewController      *pProfileView=[[ProfileViewController alloc] initWithNibName:@"ProfileViewController"
																							 bundle:nil ];
			
			pProfileView.title=@"website";//[NSString stringWithUTF8String:pFriend->cNickname];
			
			
			[pProfileView setProfileURL:url];
			
			iXfireAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
			[delegate.m_pNavController  pushViewController:pProfileView animated:YES];
			[pProfileView release];
			
			
		}else{
		
			NSLog([NSString stringWithUTF8String:url]);
		}

	}
	
	
	
	
	
	
}





@end
