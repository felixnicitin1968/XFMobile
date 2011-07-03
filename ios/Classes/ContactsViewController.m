//
//  FriendsController.m
//  iXfire
//
//  Created by Moti Joseph on 4/9/09.
//  Copyright 2009 Gamepe. All rights resfile://localhost/Users/motijoseph/Desktop/CRC32.CPPerved.
//

/*
 
 You were logged off because you logged in on a 
 different computer
 
 */
#import "MyNicknameController.h"
#import  "MyStatusController.h"
#import  "ContactsViewController.h"
#import  "iXfireAppDelegate.h"
#import  "XfireCore.h"
#import  "ChatViewController.h"
#import  "LoginViewControlller.h"
#import  "PreferencesViewController.h"
#import  "ProfileViewController.h"
#import  "CustomContactCell.h"
#import   <AudioToolbox/AudioToolbox.h>
#import  "global.h"
#import "stdlib.h"
#import "MockPhotoSource.h"
#import  "UIImage+Resize.h"
#import  "XGroupChannel.h"
#import "TextAlertView.h"

#import "ThemeEditor.h"
#import  "json.h"

#import "AdImageView.h"



#define this  self

#define MAX_PENDING_MESSAGES 120
#define SET_MY_STATUS_LABEL_ID   0
#define ADD_BUDDY_LABEL_ID       1



// When SHOW_300x250_AD is set, we'll show the 300x250 ad format.  Otherwise, we
// will show the 320x50 format.
#define SHOW_300x250_AD 0

volatile  BOOL g_bDownloadAds;

int
_stricmp(const char *s1, const char *s2)
{
	while (toupper(*s1) == toupper(*s2))
	{
		if (*s1 == 0)
			return 0;
		s1++;
		s2++;
	}
	return toupper(*(unsigned const char *)s1) - toupper(*(unsigned const char *)(s2));
}



static int cmpr(XFireContact *a, XFireContact*b)
{ 
	

	return _stricmp(a->cNickname,b->cNickname);
}





static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 140;



@implementation ContactsViewController

@synthesize     m_pContactsTableView;
@synthesize     m_nTotalConvSessions; 
@synthesize     m_GroupController;
@synthesize     m_pChatWindow;
@synthesize     m_pMyStatus;


// In the synthesize section
@synthesize contentView = _contentView;
@synthesize adBannerView = _adBannerView;
@synthesize adBannerViewIsVisible = _adBannerViewIsVisible;




-(IBAction)    setMyStatusMessageDone:(id) sender
{
	

	
	
	
	
	
	[sender resignFirstResponder];

	

	
}








- (void)textFieldDidEndEditing:(UITextField *)textField
{
	
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += m_animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}




-(void)textFieldDidBeginEditing:(UITextField *)textField
{
	
	
    CGRect textFieldRect =
	[self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect =
	[self.view.window convertRect:self.view.bounds fromView:self.view];
	
	
	CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator =
	midline - viewRect.origin.y
	- MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator =
	(MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)
	* viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
	if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
	UIInterfaceOrientation orientation =
	[[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        m_animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else
    {
        m_animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
	CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= m_animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}











-(void)playSound:(NSString*) name
{
	NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"wav"];
	SystemSoundID soundID;
	AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:path], &soundID);
	AudioServicesPlaySystemSound (soundID);		
	//[self performSelector:@selector(showButton) withObject:nil afterDelay:1.5];
}




-(void)   OnTypingMessage: (uint32)userid
{
	
			
	[m_pChatWindow SetTypingMode:userid];
	
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex 

{
	TextAlertView *alertView = (TextAlertView*) actionSheet;
	if(buttonIndex > 0) {
		if(alertView.tag == 1) {
			NSString *textValue = alertView.textField.text;
			if(textValue==nil)
				
				return;
			
			
		
		if (strlen([textValue  UTF8String])<2) {
			
			
			
			UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Chat Room" message:@"name is too short." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
			
			
			[myAlertView show];
			
			[myAlertView release];
			
			
			return;
		}
		

		
			
			// do something meaningful with textValue
			
			NSLog(textValue);
			
			
			[m_GroupController setGroup:[g_pXfireNetCore getActiveGroup]];
			XfGroupChannel* group=[g_pXfireNetCore   getActiveGroup];
			
			strcpy(group->room,[textValue UTF8String]);
			
			
			
			
			[g_pXfireNetCore XfMobileGChat_CreateRoom:[textValue UTF8String] password:""];
			
			
		}
	}
}


-(void) OnRecvMessage: (uint32)userid  Msg:(char*)pMessage
{
	

	
	XFireContact* pContact=[g_pXfireNetCore getContactByUserid:userid];
	
	if (pContact==NULL)
	{
		
		 pContact=[g_pXfireNetCore  getClanContactByUserid:userid];
		
	}
	
	if (pContact->Messageslist ==nil){
	
			
	  pContact->Messageslist=[[NSMutableArray alloc] initWithObjects:nil]; 
	
	}
			
			
			
	if ([pContact->Messageslist count]==MAX_PENDING_MESSAGES) {
				
		[pContact->Messageslist removeAllObjects];
	}
			
	
	if (pContact->cNickname[0]!=0){
	
      	[pContact->Messageslist addObject:[NSString  stringWithFormat:@"%@: %@", [NSString stringWithUTF8String:pContact->cNickname],[NSString stringWithUTF8String:pMessage]]];
			
	}else{
	   	[pContact->Messageslist addObject:[NSString  stringWithFormat:@"%@: %@", [NSString stringWithUTF8String:pContact->cUsername],[NSString stringWithUTF8String:pMessage]]];
		
		
	}
				

	if (g_bIsPlayRecvIMSound) {
	
		
		[self playSound:@"imsound"];
	}
	
	
	if ( pContact->isConversation==FALSE){
		
		
		NUSERID *pID=[NUSERID alloc];
		
		[pID setUserid:pContact->userid];
		
		[m_pConverstaionMessageslist addObject:pID];
		
		[pID release];
		pContact->isConversation=TRUE;
		m_nTotalConvSessions++;
	}
	
	NSLog(@"msg=%s",pMessage);	
	[m_pChatWindow SetChattingMode:userid];
	[m_pChatWindow OnRecvMessage:userid Msg:pMessage];
	
				
	
	pContact->nTotalRecivedMessages++;
			
	[self.m_pContactsTableView reloadData];
	
	
}

-(void)     UpdateContactsGameName:(XFireContact*)pContact
{
	
	
	
	
	if (pContact->image!=nil){
		
		
		[pContact->image release];
		
		 pContact-> image=[self newImageFromResource:[NSString stringWithFormat:@"gameid_%d.gif",pContact->gameid]];
	}
	
	
		
	[self.m_pContactsTableView reloadData];
	
	
	
}

-(void)              UpdateContactsStatusMessage
{
	
	
	[self.m_pContactsTableView reloadData];
	
	
	
}

-(void)   UpdateContact:(int)userid  isOnline:(bool)bOnline

{
		
	
	
	if (bOnline==false) {
	
				
		
		XFireContact *clan_xcontact=[g_pXfireNetCore getClanContactByUserid:userid];
		
		if (clan_xcontact) {
			
			clan_xcontact->uStatus=MISTATUS_OFFLINE;
			
		
					
			
			if (clan_xcontact->image!=nil){
				
			
				[clan_xcontact->image release];
			}
			    clan_xcontact-> image=[self newImageFromResource:@"offline.png"];
			
			
			[g_pXfireNetCore sortClanContacts];
			
		}
		
		
		
		XFireContact *pFriend=[g_pXfireNetCore getContactByUserid:userid];
		
		if (pFriend){
			
			if (m_nTotalOnlineUsers){
			
				m_nTotalOnlineUsers--;
			
			}
			
			pFriend->uStatus=MISTATUS_OFFLINE;
			
			
			if (pFriend->image!=nil){
				
				
				[pFriend->image release];
			}
			
			    pFriend-> image=[self newImageFromResource:@"offline.png"];
				
			
			
			
			[g_pXfireNetCore sortContacts];
			
			
			
		}
		
						
		
	
	}else{
		
				
		XFireContact *clan_xcontact=[g_pXfireNetCore getClanContactByUserid:userid];
		
		if (clan_xcontact) {
			
			clan_xcontact->uStatus=MISTATUS_ONLINE;
			
	
			if (clan_xcontact!=nil){
				
				
				[clan_xcontact->image release];
			}
			    clan_xcontact-> image=[self newImageFromResource:@"available.png"];
				
			
			
		
			[g_pXfireNetCore sortClanContacts];

		}
		
		
		
	     XFireContact *pFriend=[g_pXfireNetCore getContactByUserid:userid];
		
		if (pFriend){
			
			m_nTotalOnlineUsers++;
		
			pFriend->uStatus=MISTATUS_ONLINE;
					
			
			if (pFriend!=nil){
				
				
				[pFriend->image release];
			
			}
			    pFriend-> image=[self newImageFromResource:@"available.png"];
				
			
			
			
			[g_pXfireNetCore sortContacts];
		
		
	
		}
	
		
	}

	
		[self.m_pContactsTableView reloadData];
	
			
		
		
}
#pragma mark ADBannerViewDelegate
/*
- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    if (!_adBannerViewIsVisible) {                
        _adBannerViewIsVisible = YES;
        [self fixupAdView:[UIDevice currentDevice].orientation];
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    if (_adBannerViewIsVisible)
    {        
        _adBannerViewIsVisible = NO;
        [self fixupAdView:[UIDevice currentDevice].orientation];
    }
}
#pragma mark Table view Controller Methods
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self fixupAdView:toInterfaceOrientation];
}
 */
- (void)viewWillAppear:(BOOL)animated

{
	
	//xf[self refresh];
    //[self fixupAdView:[UIDevice currentDevice].orientation];

	
	self.navigationController.navigationBar.tintColor =  OPAQUE_HEXCOLOR(g_XfNavBarBackgroundColor);
	self.view.backgroundColor =OPAQUE_HEXCOLOR(g_XfBackgroundColor);
	m_pContactsTableView.backgroundColor=OPAQUE_HEXCOLOR(g_XfBackgroundColor);
		
	
	
	
	self.title=@"☛XfMobile☚ ";


	if (self.navigationItem.rightBarButtonItem==nil){
	

	UIBarButtonItem *newMsgButton=[[UIBarButtonItem alloc]
								   initWithTitle:@"Options"
								   style:UIBarButtonItemStyleBordered
								   target:self
								   action:@selector(showMore)];
	
	
	self.navigationItem.rightBarButtonItem=newMsgButton;

	[newMsgButton release];
		
	}


			
	m_pContactsTableView.separatorColor=   OPAQUE_HEXCOLOR(g_XfContactSeparatorColor);
	
	[self.m_pContactsTableView reloadData];
	
	static int keywords=0;
	
	keywords++;
	
	if (keywords % 2==0) 
	{
	
		//[self get_keyords];
		
	}
  
}






- (void)viewWillDisappear:(BOOL)animated

{
	[m_pMyStatus resignFirstResponder];	
}



-(void) showPreferences
{
	
	
	
	PreferencesViewController    *pPreferencesView=[[PreferencesViewController alloc] initWithNibName:@"PreferencesViewController" bundle:nil ];
	
	iXfireAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	
	[delegate.m_pNavController  pushViewController:pPreferencesView animated:YES];
	
	[pPreferencesView release];
	
	
	
}



-(void) showThemeEditor  
{

	
	ThemeEditor    *pThemeEditorView=[[ThemeEditor alloc] initWithNibName:@"ThemeEditor" bundle:nil ];
	
	iXfireAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	
	[delegate.m_pNavController  pushViewController:pThemeEditorView animated:YES];
	
	[pThemeEditorView release];
	
}



-(void) showAddFriends
{

	 
	 SearchViewController    *pSearchViewController=[[SearchViewController alloc] initWithNibName:@"SearchViewController"
																					  bundle:nil ];


     iXfireAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
     [delegate.m_pNavController  pushViewController:pSearchViewController animated:YES];


     [pSearchViewController release];

}


-(void) showNews
{

	
	ProfileViewController      *pProfileView=[[ProfileViewController alloc] initWithNibName:@"ProfileViewController"
																					 bundle:nil ];
	
	
	char cURL[256];
	
	sprintf(cURL,"http://www.xf-mobile.com/forum");
	
	
	[pProfileView setProfileURL:cURL];
	
	pProfileView.title=@"XfMobile Forum";//[NSString stringWithUTF8String:pFriend->cNickname];
	
	
	iXfireAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	[delegate.m_pNavController  pushViewController:pProfileView animated:YES];
	
	[pProfileView release];

	
}

-(void)                        startLoadingAnimation
{
    

	_Loadinglabel.text = @"Loading";
	_Loadinglabel.hidden=FALSE;
	_Loadinglabel.font = [UIFont systemFontOfSize:25];
	_Loadinglabel.textAlignment = UITextAlignmentCenter;
	_Loadinglabel.contentMode = UIViewContentModeCenter;
	_Loadinglabel.backgroundColor =[UIColor clearColor];
	[_Loadinglabel sizeToFit];
//	_Loadinglabel.frame = CGRectMake(0, 0, self.view .width, _Loadinglabel.height );
	[self.view addSubview:_Loadinglabel];
	[_Loadinglabel startAnimating];
	
	
}
-(void)                        noScreenShotAnimation
{
    
	
	_Loadinglabel.text = @"No screenshots.";
	_Loadinglabel.hidden=FALSE;
	_Loadinglabel.font = [UIFont systemFontOfSize:25];
	_Loadinglabel.textAlignment = UITextAlignmentCenter;
	_Loadinglabel.contentMode = UIViewContentModeCenter;
	_Loadinglabel.backgroundColor =[UIColor clearColor];
	[_Loadinglabel sizeToFit];
	//_Loadinglabel.frame = CGRectMake(0, 0, self.view .width, _Loadinglabel.height );
	[self.view addSubview:_Loadinglabel];
	[_Loadinglabel startAnimating];
	
	
}

-(void)                        stopLoadingAnimation
{
	
	[_Loadinglabel stopAnimating];
	_Loadinglabel.hidden=TRUE;
	
	
}


-(void)  addNewGroupChat
{

	
	[self removeGroupConverstaion];
	
	m_nTotalConvSessions++;
	
	NUSERID *pID=[NUSERID alloc];
	
	[pID setUserid:0xFFFFFFFF];
	
	[m_pConverstaionMessageslist addObject:pID];
	
	[pID release];
	
	
	[self.m_pContactsTableView reloadData];
	
	
}
BOOL   g_bChangeNickName=FALSE;

- (void)postController:(TTPostController *)postController 
		   didPostText:(NSString *)text 
			withResult:(id)result { 
	

	
	if (g_bChangeNickName==TRUE){
		
			if (text.length>=1 ){
		
				
				
				[g_pXfireNetCore setNickname:[text UTF8String]];
			     [g_pXfireNetCore XfMobile_NewNickname:[text UTF8String]];
			}
		g_bChangeNickName=FALSE;
		return;
	}

	
	
	if (text.length<=1 ){
		
		
		[g_pXfireNetCore XfMobile_MessageOfTheDay:g_cMyStatusMessage] ;
		return;
	}
	
	
	strcpy(g_cMyStatusMessage,[text UTF8String]);
	[g_pXfireNetCore XfMobile_MessageOfTheDay:g_cMyStatusMessage];

	
	
} 


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	
	if (actionSheet.tag==0xDDDDDDDD)
	{
		
		switch(buttonIndex)
		{
				
	case 0:
		
		
		NSLog(@"Accept");
		
		  [g_pXfireNetCore	XfMobileHandle_Invitation_Accept:nil];
				
		
		
		break;
	case 1:
		
		NSLog(@"Reject");
				
			
			  [g_pXfireNetCore	 XfMobileHandle_Invitation_Reject:nil];
		
		break;
		
	default:
		
		//[g_pXfireNetCore XfMobileGChat_RejectInvite:g_ActiveGroupChat.gsid];
		break;
		}
		
		
		return;
		
	}
	
	if (actionSheet.tag==0xAAAAAAAA){
	
		switch(buttonIndex)
		{
				
				
			case 0:
				
			
				NSLog(@"Accept");
				
				
							
				[g_pXfireNetCore AcceptGroupInvite];
				
				
							
				break;
				
				
			default:
				
				//[g_pXfireNetCore XfMobileGChat_RejectInvite:g_ActiveGroupChat.gsid];
				break;
		}
		
		return;
		
	}
	
	if (actionSheet.tag==0xCCCCCCCC){
		
		switch(buttonIndex)
		{
				
		
			case 0:
			
				[self showPreferences];
				
				break;
			case 1:
				
				[self showAddFriends];
							
				break;
			case 2:
				
			{
				TextAlertView *alert = [[TextAlertView alloc] initWithTitle:@"Room Name" 
																	message:@"Start a New Chat Room" 
																   delegate:self cancelButtonTitle:@"Cancel"
														  otherButtonTitles:@"OK", nil];
				alert.textField.keyboardType = UIKeyboardTypeDefault;
				
				// tag the alert in case you have multiple alert sheet calls
				alert.tag = 1;
				[alert show];
				[alert release];
				
			}
				
				break;
			case 3:
				

				
					NSLog(@"Change Status.....");
				
				
			{				
				
				
				MyStatusController    *mystatus=[[MyStatusController alloc] initWithNibName:@"MyStatusController"
																									  bundle:nil ];
				mystatus.title=@"My Status";
				
				iXfireAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
				
				
				  
				[mystatus setParent:self];
				[delegate.m_pNavController  pushViewController:mystatus animated:YES];
				
				
				
				[mystatus release];
				
						
				break;
			}
				
			case 4:
				
				NSLog(@"Change Nickname.....");
				
				
			{		
				
				
				
				MyNicknameController    *mynick=[[MyNicknameController alloc] initWithNibName:@"MyNicknameController"
																					 bundle:nil ];
				mynick.title=@"My Nick";
				
				iXfireAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
				
				
				
				[mynick setParent:self];
				[delegate.m_pNavController  pushViewController:mynick animated:YES];
				
				
				
				[mynick release];

				
				
				
			/*	TTPostController *postController = [[TTPostController alloc] init]; 
				postController.delegate = self; // self must implement the TTPostControllerDelegate protocol 
				postController.title=@"My Nickname";
				g_bChangeNickName=TRUE;
			
			    self.popupViewController = postController; 
				postController.superController = self; // assuming self to be the current UIViewController 
				postController.textView.text=[NSString stringWithUTF8String:[g_pXfireNetCore mynickname]];
				[postController showInView:self.view animated:YES]; 
				[postController release]; 
				*/
				break;
				
				
			}
				
				
			case 5:
				
				NSLog(@"Theme Editor !");
				
				[self showThemeEditor];
				
				
				break;

							
			default:
				break;
		}
	
		
		
		return;
	}
	
	
	switch (buttonIndex) {
	
		case 0:
			[self viewUserProfile:actionSheet.tag];
			
			
			break;
			
		case 1:
			[self startLoadingAnimation];
			[g_pXfireNetCore XfMobile_GetData:actionSheet.tag];

			break;
		
		default:
			break;
	}
	

}

-(void) showMore
{
	
	
	
	
	
	
	iXfireAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	
    UIActionSheet *actionSheet = [[UIActionSheet alloc] 
								  initWithTitle:nil 
								  delegate:self 
								  cancelButtonTitle:@"Cancel"
								  destructiveButtonTitle:nil 
								  otherButtonTitles:@"Preferences",@"Add Friends",@"Start a New Chat Room",
								  @"Change Status",@"Change Nickname",@"Theme Editor",nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	
	actionSheet.tag=0xCCCCCCCC;
    [actionSheet showInView:delegate.m_pNavController.visibleViewController.view];
    [actionSheet release];
	

	
	
	//
	
	
	
}



-(void) showBuddyinvite:(char*)msg
{
	
	

		
	
	iXfireAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	
	
		
	
    UIActionSheet *actionSheet = [[UIActionSheet alloc] 
								  initWithTitle:[NSString  stringWithFormat:@"%s",msg]
								  delegate:self 
								  cancelButtonTitle:@"Reject"
								  destructiveButtonTitle:nil 
								  otherButtonTitles:@"Accept",nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	
	actionSheet.tag=0xDDDDDDDD;
    [actionSheet showInView:delegate.m_pNavController.visibleViewController.view];
    [actionSheet release];
	
	
	
	
	
	
	//
	
	
	
}

-(void) showGoupChatinvite:(XfGroupChannel*)pGroupChat
{
	
	
	char msg[0x100];
	
	sprintf(msg,"Invite from %s to room %s ",(char*)(pGroupChat->host),(char*)(pGroupChat->room));
	
	
	
	
	iXfireAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	
	
	if (delegate.m_pNavController.visibleViewController==m_GroupController) {
		
		return;
	}
	
	
    UIActionSheet *actionSheet = [[UIActionSheet alloc] 
								  initWithTitle:[NSString  stringWithFormat:@"%s",msg]
								  delegate:self 
								  cancelButtonTitle:@"Reject"
								  destructiveButtonTitle:nil 
								  otherButtonTitles:@"Accept",nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	
	actionSheet.tag=0xAAAAAAAA;
    [actionSheet showInView:delegate.m_pNavController.visibleViewController.view];
    [actionSheet release];
	
	
		
	
	
	
	//
	
	
	
}

/*

// Set the ad click action to display the advertiser's site in a full-screen
// UIWebView.
- (GADAdClickAction)adControllerActionModelForAdClick:
(GADAdViewController *)adController {
	return GAD_ACTION_DISPLAY_INTERNAL_WEBSITE_VIEW;
}

- (void)adController:(GADAdViewController *)adController
     failedWithError:(NSError *)error {
	// Handle error here.
}

- (UIViewController *)viewControllerForModalPresentation:
(GADAdViewController *)adController {
	
	
	
	iXfireAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	
	
	
	return delegate.m_pNavController.visibleViewController;
}
*/


/*
BOOL ParseAdOutput()

{
	
	json_object *new_obj;
	
	json_object *my_array;
	
	const char *cp;
	if (g_ad_result[0]==0) return 0;
	my_array = json_tokener_parse(g_ad_result);
	
	if (json_object_array_length(my_array)==0) return 0;
	new_obj=json_object_object_get(my_array,
								   
								   "img_url");
	if (new_obj){
		cp=json_object_get_string(new_obj);
		
		strcpy(g_szLinkToAdImage,cp);
		
	}
	
	new_obj=json_object_object_get(my_array,
								   
								   "redirect_url");
	if (new_obj){
		cp=json_object_get_string(new_obj);
		
				
		strcpy(g_szLinkToAd,cp);
		
	}
	
	new_obj=json_object_object_get(my_array,
								   
								   "metrics_url");
	if (new_obj){
		cp=json_object_get_string(new_obj);
		
	
		
	}
	
	if (new_obj){
		new_obj=json_object_object_get(my_array,
									   
									   "ad_text");
		cp=json_object_get_string(new_obj);
		
		strcpy(g_szTextAd,cp);
		
	}
	
	new_obj=json_object_object_get(my_array,
								   
								   "ad_type");
	if (new_obj){
		int ad_type=json_object_get_int(new_obj);
	}
	
	NSLog(@"%s\n",g_szLinkToAdImage);
	NSLog(@"%s\n",g_szLinkToAd);
	NSLog(@"%s\n",g_szTextAd);
	return 1;
}
*/


// Set the ad click action to display the advertiser's site in a full-screen
// UIWebView.
- (GADAdClickAction)adControllerActionModelForAdClick:
(GADAdViewController *)adController {
	return GAD_ACTION_DISPLAY_INTERNAL_WEBSITE_VIEW;
}

- (void)loadSucceeded:(GADAdViewController *)adController
          withResults:(NSDictionary *)results {
	// Successful load. You can examine the results for interesting things.
	NSLog(@"Load Succeeded: %@", results);
}

- (void)loadFailed:(GADAdViewController *)adController
         withError:(NSError *) error {
	// Handle error here.
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a method instance elsewhere
    NSLog(@"Succeeded! Received %d bytes of data",[receivedAdsData length]);
	
    // release the connection, and the data object
	
	if ([receivedAdsData length]>0) {
		
		
	char *keywords=malloc([receivedAdsData length]+1);
	memset(keywords,0,[receivedAdsData length]+1);
	memcpy(keywords,(char*)[receivedAdsData bytes],[receivedAdsData length]);
	
		NSLog(@"%s",keywords);
		
		strcpy(g_ad_result, keywords);
	
	
	
	[_keywords release];
	_keywords = [[NSString alloc] initWithUTF8String:keywords];
		
	NSLog(@"keywords===%@",_keywords);
	
	//	UIColor  *adBackgroundClr=OPAQUE_HEXCOLOR(0xff122840);
		
	UIColor  *adBackgroundClr=OPAQUE_HEXCOLOR(0xff2f5f9f);
		
    if (g_XfBackgroundColor!=-1) {
			
			adBackgroundClr =OPAQUE_HEXCOLOR(g_XfBackgroundColor);
			
	}
	
		NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
									@"XfMobile", kGADAdSenseCompanyName,
									_keywords, kGADAdSenseKeywords,
									@"ca-mb-app-pub-5531202394163433", kGADAdSenseClientID,
									@"XfMobile", kGADAdSenseAppName,
									@"315133549", kGADAdSenseApplicationAppleID,
									adBackgroundClr,kGADAdSenseAdBackgroundColor,
									adBackgroundClr,kGADAdSenseAdBorderColor,
									
									[NSArray arrayWithObjects:@"5523329122", nil], kGADAdSenseChannelIDs,
									[NSNumber numberWithInt:1], kGADAdSenseIsTestAdRequest,
									nil];
		
			
		[adViewController_ loadGoogleAd:attributes];
		
		// Position ad at bottom of screen.
		UIView *adView = adViewController_.view;
		CGFloat adViewHeight = [adView bounds].size.height;
		CGRect bounds = [self.view bounds];
		CGPoint center = CGPointMake(CGRectGetMidX(bounds),
									 CGRectGetMaxY(bounds) - adViewHeight / 2);
		
		
		[adView setCenter:center];
	
		[self.view addSubview:adView];
		
	
	      free(keywords);
		
	}
    [connection release];
    [receivedAdsData release];
	
	 g_bDownloadAds=FALSE;
}


- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    // release the connection, and the data object
	
	NSLog(@"error%@",error);
	
    [connection release];
	
	
	[receivedAdsData release];
		g_bDownloadAds=FALSE;
	/*
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
	
	UIColor  *adBackgroundClr=[UIColor clearColor];//  OPAQUE_HEXCOLOR(0xff122840);
	
	NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
								@"ca-mb-app-pub-5531202394163433", kGADAdSenseClientID,
								@"Moti Joseph", kGADAdSenseCompanyName,
								@"XfMobile", kGADAdSenseAppName,
								_keywords, kGADAdSenseKeywords,
								[NSArray arrayWithObjects:@"5523329122", nil], kGADAdSenseChannelIDs,
								adBackgroundClr,kGADAdSenseAdBackgroundColor,
								adBackgroundClr,kGADAdSenseAdBorderColor,
								
								
								[NSNumber numberWithInt:GOOGLE_AD_TEST], kGADAdSenseIsTestAdRequest,
								nil];
	
		[adViewController_ loadGoogleAd:attributes];
	
	// Position ad at bottom of screen.
	UIView *adView = adViewController_.view;
	CGFloat adViewHeight = [adView bounds].size.height;
	CGRect bounds = [self.view bounds];
	CGPoint center = CGPointMake(CGRectGetMidX(bounds),
								 CGRectGetMaxY(bounds) - adViewHeight / 2);
	
	
	[adView setCenter:center];
	[self.view addSubview:adView];
	
	g_bDownloadAds=FALSE;
	*/
	
	
	
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // append the new data to the receivedData
    // receivedData is declared as a method instance elsewhere
	
	  NSLog(@"did recv data");
     [receivedAdsData appendData:data];
}





-(void) get_keyords
{	
	
		
	if (g_bDownloadAds) return;
	
	
	g_bDownloadAds=TRUE;
	
	
	// create the request
	NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.xf-mobile.com/download/keywords.php"]
											  cachePolicy:NSURLRequestUseProtocolCachePolicy
										  timeoutInterval:60.0];
	// create the connection with the request
	// and start loading the data
	NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	if (theConnection) {
		// Create the NSMutableData that will hold
		// the received data
		// receivedData is declared as a method instance elsewhere
		
		receivedAdsData=[[NSMutableData data] retain];
	} else {
		// inform the user that the download could not be made
	}
	

}




- (UIViewController *)viewControllerForModalPresentation:
(GADAdViewController *)adController {
	return self;
}


- (void)viewDidLoad
{

	

		
	m_pMyStatus.textColor=[UIColor whiteColor];
	
	
	m_nTotalConvSessions=0;
	
	m_nTotalOnlineUsers=0;
	
    m_pChatWindow=[[ChatViewController alloc] initWithNibName:@"ChatViewController"
														   bundle:nil ];
		
    [m_pChatWindow init];
	
	_keywords = [[NSString alloc] initWithUTF8String:"games, game,iphone  apps,android app,HTC,apple,att go phone,cheap,music,pc,laptop"];
	
	m_GroupController=[[GroupChatController alloc] initWithNibName:@"GroupChatController"
														   bundle:nil ];
	
	
	

	m_pMyStatus.textColor=[UIColor whiteColor];
	 m_pConverstaionMessageslist=[[NSMutableArray alloc] initWithObjects:nil]; 
	
	 _Loadinglabel=[[TTSearchlightLabel alloc] init];
	
	
//	adViewController_ = [[GADAdViewController alloc] initWithDelegate:self];

	
	

	//adViewController_.adSize = kGADAdSize320x50;

	
	//[self get_keyords];
	
	
	
	
	
}

/*
- (void)createAdBannerView {
    Class classAdBannerView = NSClassFromString(@"ADBannerView");
    if (classAdBannerView != nil) {
        self.adBannerView = [[[classAdBannerView alloc] 
							  initWithFrame:CGRectZero] autorelease];
        [_adBannerView setRequiredContentSizeIdentifiers:[NSSet setWithObjects: 
														  ADBannerContentSizeIdentifier320x50, 
														  ADBannerContentSizeIdentifier480x32, nil]];
        if (UIInterfaceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
            [_adBannerView setCurrentContentSizeIdentifier:
			 ADBannerContentSizeIdentifier480x32];
        } else {
            [_adBannerView setCurrentContentSizeIdentifier:
			 ADBannerContentSizeIdentifier320x50];            
        }
 //
        [_adBannerView setFrame:CGRectOffset([_adBannerView frame], 0,50/*[self getBannerHeight]*/
//)
//];
      //  [_adBannerView setDelegate:self];
		
    //    [self.view addSubview:_adBannerView];        
  //  }
//}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}

/*

- (int)getBannerHeight:(UIDeviceOrientation)orientation {
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        return 32;
    } else {
        return 50;
    }
}

- (int)getBannerHeight {
    return [self getBannerHeight:[UIDevice currentDevice].orientation];
}

- (void)fixupAdView:(UIInterfaceOrientation)toInterfaceOrientation {
    if (_adBannerView != nil) {        
        if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
            [_adBannerView setCurrentContentSizeIdentifier:
			 ADBannerContentSizeIdentifier480x32];
        } else {
            [_adBannerView setCurrentContentSizeIdentifier:
			 ADBannerContentSizeIdentifier320x50];
        }          
        [UIView beginAnimations:@"fixupViews" context:nil];
        if (_adBannerViewIsVisible) {
            CGRect adBannerViewFrame = [_adBannerView frame];
            adBannerViewFrame.origin.x = 0;
            adBannerViewFrame.origin.y = 380;
            [_adBannerView setFrame:adBannerViewFrame];
            CGRect contentViewFrame = _contentView.frame;
            contentViewFrame.origin.y = [self getBannerHeight:toInterfaceOrientation];
            contentViewFrame.size.height = self.view.frame.size.height -[self getBannerHeight:toInterfaceOrientation];
            _contentView.frame = contentViewFrame;
			
			
			
			
			
			
			
			
        } else {
            CGRect adBannerViewFrame = [_adBannerView frame];
            adBannerViewFrame.origin.x = 0;
            adBannerViewFrame.origin.y = 
			-[self getBannerHeight:toInterfaceOrientation];
            [_adBannerView setFrame:adBannerViewFrame];
            CGRect contentViewFrame = _contentView.frame;
            contentViewFrame.origin.y = 0;
            contentViewFrame.size.height = self.view.frame.size.height;
            _contentView.frame = contentViewFrame;            
        }
        [UIView commitAnimations];
    }   
}
	*/
- (void)dealloc

{

	// In the dealloc section
	self.contentView = nil;
	self.adBannerView = nil;
	
	
	[_keywords release];
	
	[adViewController_ release];
	[m_GroupController release];
	[_Loadinglabel release];
    [m_pConverstaionMessageslist release];
	[m_pMyStatus  release];
	[m_pChatWindow release];
	[m_pContactsTableView release];
	[super dealloc];
}



#pragma mark -
#pragma mark Table View Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	
	
	switch (section)
	{
	
		case FRIEND_CELL_ID:
			
			if (g_bIsShowOfflineFriends )  return [g_pXfireNetCore getTotalContacts] ;
			
			
			return g_nTotalOnlineUsers ;
			
		case CHAT_CELL_ID:
			
			NSLog(@"conver #%d",m_nTotalConvSessions);
			
			return m_nTotalConvSessions;

		default:
			break;
			
			
	}
	
	XfireClan *clan=[g_pXfireNetCore clans];
	
	
	 if (g_bIsShowOfflineFriends==false)
		 return clan[section-2].online_userscount;
     return clan[section-2].userscount;
}



// called to get permission to rotate this view to some new orientation.
// always allow it

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orient
{
    if(orient == UIInterfaceOrientationPortrait)
		return YES;
	
	return NO;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

	

	if (g_bIsClansVisible==FALSE) return 2;
	
	return (2+[g_pXfireNetCore getTotalClans]);
}






- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	
	NSString *sectionName = nil;
	XfireClan *clan=nil;

   switch (section) {
		case 0:
			sectionName = [NSString stringWithFormat:@"Conversation"];
			break;
		case 1:
			sectionName = [NSString stringWithFormat:@"%s (%d) ","Friends",g_nTotalOnlineUsers];
			break;
		default:
		    clan=[g_pXfireNetCore clans];
		   if (clan) {
			   
			  
			  sectionName = [NSString stringWithUTF8String:clan[section-2].name];
		       
		   }
			break;
	}
	
	UILabel *sectionHeader = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)] autorelease];
    sectionHeader.backgroundColor = OPAQUE_HEXCOLOR(g_XfContactSectionBackgroundTextColor); //[UIColor clearColor];
	//sectionHeader.backgroundColor =[UIColor blackColor];
	sectionHeader.font = [UIFont boldSystemFontOfSize:15];
	sectionHeader.textColor = OPAQUE_HEXCOLOR(g_XfContactSectionTextColor);
	sectionHeader.text = sectionName;
	
	return sectionHeader;
}


 
 

 
 

#ifndef __IPHONE_3_0
- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView 
		 accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
	
	NSUInteger section = [indexPath section];
	
	switch(section)
	{
	
		case CHAT_CELL_ID:
			
			return UITableViewCellAccessoryDetailDisclosureButton;
			
		case FRIEND_CELL_ID:
			return UITableViewCellAccessoryDetailDisclosureButton;
		
		default:
			break;
			
	}
	return UITableViewCellEditingStyleNone;
}
#endif


-(void) viewUserProfile:(int)userid
{
	
	
	
	
	XFireContact *pFriend=NULL;
		
	pFriend=[g_pXfireNetCore getContactByUserid:userid];
		
	if (pFriend==NULL)
	{
			pFriend=[g_pXfireNetCore  getClanContactByUserid:userid];
	}
	
	if (pFriend==NULL) return;
	
		
		
	ProfileViewController      *pProfileView=[[ProfileViewController alloc] initWithNibName:@"ProfileViewController"
																					 bundle:nil ];
	
	
	char cURL[256];
	
	sprintf(cURL,"http://www.xfire.com/profile/%s/",pFriend->cUsername);
	
	
	[pProfileView setProfileURL:cURL];
	
	pProfileView.title=@"Xfire Profile";//[NSString stringWithUTF8String:pFriend->cNickname];
	
	
	iXfireAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	[delegate.m_pNavController  pushViewController:pProfileView animated:YES];
	
	[pProfileView release];
	
}



// -----------------------------------------------------------------------

#pragma mark TTPhoto protocol

- (NSString*)URLForVersion:(TTPhotoVersion)version
{
    return nil;//(version == TTPhotoVersionThumbnail && thumbnailURL) 
    //? thumbnailURL
    //: imageURL;
}

#pragma mark - 

#pragma mark TTPhotoSource

- (NSInteger)numberOfPhotos 
{
	
	NSLog(@"numberOfPhotos called");
    return 0;
}

- (NSInteger)maxPhotoIndex
{
    return 0;
}

- (id<TTPhoto>)photoAtIndex:(NSInteger)index 
{
  //  if (index < 0 || index > [self maxPhotoIndex])
        return nil;
    
   /* // Construct an object (PhotoItem) that is suitable for Three20's
    // photo browsing system from the domain object (SearchResult)
    // at the specified index in the TTModel.
    SearchResult *result = [[model results] objectAtIndex:index];
    id<TTPhoto> photo = [PhotoItem itemWithImageURL:result.bigImageURL thumbImageURL:result.thumbnailURL caption:result.title size:result.bigImageSize];
    photo.index = index;
    photo.photoSource = self;
    return photo;*/
}

// -----------------------------------------------------------------------
#pragma mark -




- (void)tableView:(UITableView *)tableView 
accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{

	
	
	
		
	NSUInteger row = [indexPath row];
	NSUInteger section = [indexPath section];
	
	XFireContact* pFriend=NULL;
	XfireClan    *pClans=NULL;
	
	[self   stopLoadingAnimation];
	
	if (section>=2){
		
		
	    pClans=[g_pXfireNetCore clans];
		
		
		pFriend=&pClans[section-2].users[row];	
		
	}
	
	
	if (section ==FRIEND_CELL_ID) {
		
		
		pFriend=[g_pXfireNetCore contacts];
		
		pFriend=&pFriend[row];
		
		
		
	}
	
	
	memcpy(invite_sid,pFriend->sid,16);
	
	iXfireAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	
    UIActionSheet *actionSheet = [[UIActionSheet alloc] 
								  initWithTitle:nil 
								  delegate:self 
								  cancelButtonTitle:@"Cancel"
								  destructiveButtonTitle:nil 
								  otherButtonTitles:@"View Profile",@"View Screenshots",nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	
	actionSheet.tag=pFriend->userid;
    [actionSheet showInView:delegate.m_pNavController.visibleViewController.view];
    [actionSheet release];
	
	NSLog(@"action sheer was done");
	
	return;

	/*
*/
		

	
		
}


-(void) initData
{
	
	m_nTotalConvSessions=0;
	m_nTotalOnlineUsers=0;
	
	[m_pConverstaionMessageslist removeAllObjects];
	
	
}
-(void) XfGroupChannelAccessoryClicked:(id)sender;
{
	

	NSLog(@"Enter XfGroupChannelAccessoryClicked");
	UISwitch *switchView =(UISwitch*)sender;
	
	NSUInteger row = switchView.tag;

	if (switchView.on==TRUE){
		
		
	
		
	}else{	
	
	
	
		[g_pXfireNetCore LeaveGroupChat];
		
		
		m_nTotalConvSessions--;
	    [m_pConverstaionMessageslist removeObjectAtIndex:row];
	    [self.m_pContactsTableView reloadData];
	
	}
	
}

- (void)chatCellAccessoryClicked:(id)sender;
{
	
	UISwitch *switchView =(UISwitch*)sender;

	NSUInteger row = switchView.tag;

	NUSERID *pID;
	
	XFireContact *pFriend;
	
	if (switchView.on==0){
		
	
		pID=[m_pConverstaionMessageslist objectAtIndex:row];
		
		pFriend=[g_pXfireNetCore getContactByUserid:[pID getUserid]];
		
		if (pFriend==NULL)
		{
			pFriend=[g_pXfireNetCore  getClanContactByUserid:[pID getUserid]];
		}
		
		
		
		if (pFriend!=nil){
			
				pFriend->nTotalRecivedMessages=0; 
			    pFriend->isConversation=FALSE;
		     	m_nTotalConvSessions--;
			    [m_pConverstaionMessageslist removeObjectAtIndex:row];
			  	[self.m_pContactsTableView reloadData];
				
		}else
		{
			 
			  m_nTotalConvSessions--;
			  [m_pConverstaionMessageslist removeObjectAtIndex:row];
			  [self.m_pContactsTableView reloadData];
		
		}
			
		 
		
			

		
	}
	
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	
	NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
	
	if (section==CHAT_CELL_ID ){
	
		return 46;
	
		
	}
	
	
	return 66;
}


- (UIImage *)newImageFromResource:(NSString *)filename  
{  
    NSString *imageFile = [[NSString alloc] initWithFormat:@"%@/%@",  
                           [[NSBundle mainBundle] resourcePath], filename];  
    UIImage *image = nil;  
    image = [[UIImage alloc] initWithContentsOfFile:imageFile];  
    [imageFile release];  
    return image;  
}  



- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	
	NSUInteger row = [indexPath row];
	NSUInteger section = [indexPath section];
		
	static NSString *SimpleTableIdentifier = @"ContactsCellIdentifier";
	
	static NSString *SimpleChatTableIdentifier = @"ChatContactsIdentifier";
	
	static NSString *GoogleCellIdentifier = @"GoogleAds_Cell";

	
	
	
	CustomCell *cell,*GoogleCell;
	
	if (section>=2){
		
		XfireClan *clan=[g_pXfireNetCore clans];
		cell= [tableView dequeueReusableCellWithIdentifier:[NSString stringWithUTF8String:clan[section-2].name]];
		if (cell == nil) {
			cell = [[[CustomCell alloc] initWithFrame:CGRectZero
										   reuseIdentifier:[NSString stringWithUTF8String:clan[section-2].name]] autorelease];
			
			
			
		}
		
	}
	
	
	if (section==FRIEND_CELL_ID){
		
	
		
		cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
		if (cell == nil) {
			cell = [[[CustomCell alloc] initWithFrame:CGRectZero reuseIdentifier:SimpleTableIdentifier] autorelease];
		}
		
		
	}
	
	if (section==CHAT_CELL_ID){
		
		
		cell= [tableView dequeueReusableCellWithIdentifier:SimpleChatTableIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero
										   reuseIdentifier:SimpleChatTableIdentifier] autorelease];
			
			
			
		}
		
	}

	
	unsigned int userid;
	XFireContact *pFriend=nil;
	XfireClan    * pClans=nil;
	NUSERID *pID;		
	
	NSString *string ;
	UIImage *image;
	switch(section)
	{
			
			
		case CHAT_CELL_ID:
		
			

			cell.accessoryType =  UITableViewCellAccessoryDetailDisclosureButton;

			
			cell.textLabel.font=[UIFont systemFontOfSize:15];
			cell.textLabel.textColor=OPAQUE_HEXCOLOR(g_XfContactsNameTextColor);
			
			
	
			pID=[m_pConverstaionMessageslist objectAtIndex:row];
			
			pFriend=[g_pXfireNetCore getContactByUserid:[pID getUserid]];
			
			if (pFriend==NULL)
			{
				pFriend=[g_pXfireNetCore  getClanContactByUserid:[pID getUserid]];
			}
			
			
			if (pFriend!=nil) {
				
			
				string = [[NSString alloc] initWithUTF8String:(pFriend->cNickname[0])?pFriend->cNickname:pFriend->cUsername];
				
				cell.textLabel.text =string;
				
				if (pFriend->nTotalRecivedMessages!=0){
					
					cell.textLabel.text =[cell.textLabel.text stringByAppendingString:[NSString stringWithFormat:@" (+%d)",pFriend->nTotalRecivedMessages]];;
					
					
				}
				
				[string release];
				
				
				
				
				image=[self newImageFromResource:@"person.png"];
				
				cell.imageView.image =image;
			
				[image release];
				UISwitch *switchView = [[UISwitch alloc] init];
				switchView.tag=row;
				switchView.on=TRUE;
				cell.accessoryView = switchView;
				[switchView addTarget:self action:@selector(chatCellAccessoryClicked:) forControlEvents: UIControlEventValueChanged ];
				[switchView release];
				
				
				
				
			}else {
						
				
				image=[self newImageFromResource:@"room.png"];
				
				cell.imageView.image =image;
			
				cell.textLabel.text=[NSString stringWithFormat:@"%s",[g_pXfireNetCore getGroupName]];
			
				[image release];
				UISwitch *switchView = [[UISwitch alloc] init];
				switchView.on=TRUE;
				switchView.tag=row;
				cell.accessoryView = switchView;
				[switchView addTarget:self action:@selector(XfGroupChannelAccessoryClicked:) forControlEvents: UIControlEventValueChanged ];
				[switchView release];
				
			//	cell.backgroundColor=[UIColor clearColor];

				
				return cell;

				
			}
			
			
			
		
			
			
		break;
			
		case FRIEND_CELL_ID:
					
			
#ifdef __IPHONE_3_0
			cell.accessoryType =  UITableViewCellAccessoryDetailDisclosureButton;
#endif
		 			pFriend=[g_pXfireNetCore contacts];
			
	
			
			
			
			pFriend=&pFriend[row];
			
			
			pFriend->nRowInTable=row;
			
			
					
			
			if (g_bIsUsernamesVisible||(pFriend->cNickname[0]==0)){
				
				   string = [[NSString alloc] initWithUTF8String:pFriend->cUsername];
			}else{
			
			
				
					string = [[NSString alloc] initWithUTF8String:pFriend->cNickname];			
			
			
			}
			cell.m_pContactName.text =string;// [NSString stringWithUTF8String:(pFriend->cNickname[0])?pFriend->cNickname:pFriend->cUsername];
			
			[string release];
			
			
			cell.imageView.image =	 pFriend-> image;;
			
					
			
			
		
					
			
			if (pFriend->gameid && pFriend->cGamename[0]){
				
				
				cell.m_pContactStatusMessage.text = [NSString stringWithUTF8String:pFriend->cGamename];
				
				
			}else{
			
				
				if (pFriend->cStatusMsg[0] ){
					
	
					cell.m_pContactStatusMessage.text = [NSString stringWithUTF8String:pFriend->cStatusMsg];
					
				}else{
					
					cell.m_pContactStatusMessage.text=@"";
				}
				
				
			}
			
					
						
						
			break;
			
			
			
		default://clan friend		
			
			
#ifdef __IPHONE_3_0
			cell.accessoryType =  UITableViewCellAccessoryDetailDisclosureButton;
#endif
			
		   
			pClans=[g_pXfireNetCore clans];
			
			//if (pClans[section-2].userscount<row) return;
			
			userid=pClans[section-2].users[row].userid;
			
			XFireContact *pFriend=&pClans[section-2].users[row];
			
		
			
#ifdef __IPHONE_3_0
			cell.imageView.image =	 pFriend-> image;;
			
			
#else
			cell.image =	 pFriend-> image;;
#endif					
			
			
				
			if (g_bIsUsernamesVisible){
				
				string = [[NSString alloc] initWithUTF8String:pFriend->cUsername];
			}else{
				
				string = [[NSString alloc] initWithUTF8String:(pFriend->cNickname[0]!=0)?pFriend->cNickname:pFriend->cUsername];			
				
			}		
				
			
			    cell.m_pContactName.text=string;
				
				[string release];
				
							
				if (pFriend->gameid!=0 && pFriend->cGamename[0]){
					
					
					cell.m_pContactStatusMessage.text = [NSString stringWithUTF8String:pFriend->cGamename];
					
					
								
				}else{
					
					
					if (pFriend->cStatusMsg[0] ){
						
						
						cell.m_pContactStatusMessage.text = [NSString stringWithUTF8String:pFriend->cStatusMsg];
						
					}else{
						
						cell.m_pContactStatusMessage.text=@"";
					}
					
					
				}
			
	
			
						
				
			
			break;
			
			
	}
	
	
	
	
	
	
	return cell;
}


#pragma mark -
#pragma mark Table Delegate Methods





- (NSIndexPath *)tableView:(UITableView *)tableView
  willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{


	

	return indexPath;
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	
	
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	
	[m_pContactsTableView reloadData];
	
  
	
}






- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar

{

	/*NSString *searchTerm=[m_pContactSearchBar text];
		
	XFireContact *pConact=[g_pXfireNetCore contacts];
	
	for (int i=0; i<[g_pXfireNetCore getTotalContacts] ; i++){
		
	
		if  (strstr(pConact[i].cNickname,[searchTerm UTF8String])){
			
		
					
			
			[m_pContactsTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:pConact[i].nRowInTable inSection:FRIEND_CELL_ID] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
			[m_pContactsTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:pConact
	 .nRowInTable inSection:FRIEND_CELL_ID]  animated:YES scrollPosition:UITableViewScrollPositionBottom ];
			
			
			[m_pContactSearchBar resignFirstResponder];
			break;
		}
		
	
	}*/
	
	
}

- (void)removeGroupConverstaion
{
	
	NUSERID *pID;	
	for (int i=0; i<[m_pConverstaionMessageslist count]; i++)
	{
		
		
		pID=[m_pConverstaionMessageslist objectAtIndex:i];
		
		
		if ([pID getUserid]==0xFFFFFFFF){
			
			
			m_nTotalConvSessions--;
			[m_pConverstaionMessageslist removeObjectAtIndex:i];

		
			return;
		}
	
		
	}
	
}
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	

	NSUInteger row = [indexPath row];
	
	NSUInteger section = [indexPath section];
	XFireContact *pFriend=NULL;
	XfireClan    *pClans=NULL;
	
	NUSERID *pID;				
	
	
	
	
	switch(section)
	{
			
			
		case CHAT_CELL_ID:
			
			pID=[m_pConverstaionMessageslist objectAtIndex:row];
			
			
			if ([pID getUserid]==0xFFFFFFFF){
				
			
				iXfireAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
				
				[m_GroupController setGroup:[g_pXfireNetCore getActiveGroup]];
	
			     self.title=@"☚ ";
				[delegate.m_pNavController  pushViewController:m_GroupController animated:YES];
	
				return;
			}
			
			pFriend=[g_pXfireNetCore getContactByUserid:[pID getUserid]];
			
			if (pFriend==NULL)
			{
				pFriend=[g_pXfireNetCore  getClanContactByUserid:[pID getUserid]];
			}
		
			if (pFriend) {
				
				pFriend->nTotalRecivedMessages=0;
				
			/*	if (pFriend->uStatus==MISTATUS_OFFLINE) {
				
				
					return;
				}*/
				
				/*if ( pFriend->isConversation==FALSE){
				
					  m_nTotalConvSessions++;
					  pFriend->isConversation=TRUE;
				}*/
				
			
			    [m_pChatWindow SetContact:pFriend->userid];
			}
			break;
				
		case FRIEND_CELL_ID:
		

			pFriend=[g_pXfireNetCore contacts];
		
			
			pFriend=&pFriend[row];
			
			if (pFriend==NULL) return;
			
			
			if (pFriend->uStatus==MISTATUS_OFFLINE){
				
				
				return;
				
			}
			
			
			if ( pFriend->isConversation==FALSE){
				  pFriend->isConversation=TRUE;
				NUSERID *pID=[NUSERID alloc];
				
				[pID setUserid:pFriend->userid];
				
				[m_pConverstaionMessageslist addObject:pID];
				[pID release];
				m_nTotalConvSessions++;
			}
			
		  
			[m_pChatWindow SetContact:pFriend->userid];
		
			
		
			break;
			
		default: 
			
			pClans=[g_pXfireNetCore clans];
			
			pFriend=&pClans[section-2].users[row];	
			
			if (pFriend==NULL) return;
			
			
			
		
			
			if (pClans[section-2].users[row].uStatus==MISTATUS_OFFLINE) return;
			
			if ( pFriend->isConversation==FALSE){
			     pFriend->isConversation=TRUE;
				m_nTotalConvSessions++;
				
				NUSERID *pID=[NUSERID alloc];
				
				[pID setUserid:pFriend->userid];
				
				[m_pConverstaionMessageslist addObject:pID];
				
				[pID release];
				
				

			}
			
		
			
			[m_pChatWindow SetContact:pFriend->userid];
			break;
	}
	

	
	iXfireAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	
	[delegate.m_pNavController  pushViewController:m_pChatWindow animated:YES];
	
	
         
	[self.m_pContactsTableView reloadData];
	

	[self.m_pContactsTableView deselectRowAtIndexPath:indexPath animated:NO];
		
}




@end




