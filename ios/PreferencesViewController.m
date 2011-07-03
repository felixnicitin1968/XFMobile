//
//  PreferencesViewController.m
//  iXfire
//
//  Created by Moti Joseph on 4/25/09.
//  Copyright 2009 Gamepe. All rights reserved.
//

#import "PreferencesViewController.h"
#import "iXfireAppDelegate.h"
#import "SearchViewController.h"
#import "global.h"
#import "ProfileViewController.h"



@implementation PreferencesViewController

@synthesize m_pOptionsTableView;



- (void)viewWillAppear:(BOOL)animated

{
		

	self.view.backgroundColor =OPAQUE_HEXCOLOR(g_XfBackgroundColor);
		
	m_pOptionsTableView.backgroundColor=OPAQUE_HEXCOLOR(g_XfBackgroundColor);
	
	
	
	
		
}

- (void)viewDidLoad
{
	
	self.title=@"Preferences";   
	
	/*m_pClanGroups.on=g_bIsClansVisible;
	m_pShowOfflineFriends.on=g_bIsShowOfflineFriends;
	m_pPlayRecvIMSound.on=g_bIsPlayRecvIMSound;
	m_pShowUsernamesFriends.on=g_bIsUsernamesVisible;
	m_pDisableSignature.on=g_bIsDisableSignature;
	*/
	
	m_pMutableOptionslist=[[NSMutableArray alloc] initWithObjects:nil]; 

	[m_pMutableOptionslist addObject:@"Clans/Community"];
	[m_pMutableOptionslist addObject:@"Show usernames"];
	[m_pMutableOptionslist addObject:@"Offlines Friends"];
	[m_pMutableOptionslist addObject:@"Sound when IM are received"];
	[m_pMutableOptionslist addObject:@"Signature"];
	[m_pMutableOptionslist addObject:@"Push Notification"];
	
	//[m_pMutableOptionslist addObject:[NSString stringWithFormat:@"%s",push_token_id]];
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


-(IBAction)  OnSwitchChanged:(id) sender
{

/*	g_bIsClansVisible=m_pClanGroups.on;
	g_bIsShowOfflineFriends=m_pShowOfflineFriends.on;
	g_bIsPlayRecvIMSound=m_pPlayRecvIMSound.on;
	g_bIsUsernamesVisible=m_pShowUsernamesFriends.on;
	g_bIsDisableSignature=m_pDisableSignature.on;
	NSLog(@"OnSwitchChanged");
*/	
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return  NO;// (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || UIInterfaceOrientationLandscapeRight==interfaceOrientation);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	
	NSUInteger section = [indexPath section];
	
    return 66;
}







- (void)chatCellAccessoryClicked:(id)sender;
{
	
	UISwitch *switchView =(UISwitch*)sender;
	
	NSUInteger row = switchView.tag;
	
	switch(row)
	{
	
		case 0:
			
			g_bIsClansVisible=switchView.on;			
			break;
			
		case 1:
			g_bIsUsernamesVisible=switchView.on;	
			
			break;
		case 2:
			g_bIsShowOfflineFriends=switchView.on;	
			break;
			
		case 3:
			
			g_bIsPlayRecvIMSound=switchView.on;
			
			break;
			
		case 4:
			g_bIsDisableSignature=switchView.on;
			break;
			
		case 5:
			[self showPushHelp];
			break;
		case 6:
			break;
		
		default:
			break;
	}

	
	
}



- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	
	UITableViewCell *cell;
	
	NSUInteger row = [indexPath row];
	static NSString *SimpleChatTableIdentifier = @"OptionCell"; 
	
	cell= [tv dequeueReusableCellWithIdentifier:SimpleChatTableIdentifier];
	if (cell == nil)
		
	{
		
		
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero
									   reuseIdentifier:SimpleChatTableIdentifier] autorelease];
		
		
		
	}
	
	
	
	cell.textLabel.font=[UIFont systemFontOfSize:15];
	cell.textLabel.text =	[m_pMutableOptionslist objectAtIndex:row];
	cell.textLabel.textColor=OPAQUE_HEXCOLOR(g_XfContactsNameTextColor);
	
	UISwitch *switchView = [[UISwitch alloc] init];
	switchView.tag=row;
	
	
	switch(row)
	{
			
		case 0:
			
			switchView.on=g_bIsClansVisible;		
			cell.accessoryView = switchView;

			break;
			
		case 1:
			
			switchView.on=g_bIsUsernamesVisible;		
			cell.accessoryView = switchView;
			
			break;
			
		case 2:
			switchView.on=g_bIsShowOfflineFriends;
			cell.accessoryView = switchView;

			break;
			
		case 3:
			
			switchView.on=g_bIsPlayRecvIMSound;
			cell.accessoryView = switchView;

			break;
			
		case 4:
			switchView.on=g_bIsDisableSignature;
			cell.accessoryView = switchView;

			break;
			
		case 5:
			switchView.on=TRUE;
			cell.accessoryView = switchView;
			break;
		case 6:
			
			cell.textLabel.font=[UIFont systemFontOfSize:8];
			break;
			
		default:
			break;
	}

	
	
	   [switchView addTarget:self action:@selector(chatCellAccessoryClicked:) forControlEvents: UIControlEventValueChanged ];
	    
	   [switchView release];
	
	

	
	
	
	
	return cell;
}


-(void) showPushHelp
{
	
	
	
	UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Push Notification" message:@"To use the push feature you will have to run our gateway tool."
														 delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
	
	
	[myAlertView show];
	
	[myAlertView release];
	
		
	ProfileViewController      *pProfileView=[[ProfileViewController alloc] initWithNibName:@"ProfileViewController"
																					 bundle:nil ];
	
	
	char cURL[256];
	
	sprintf(cURL,"http://www.xf-mobile.com/forum/viewtopic.php?f=37&t=349");
	
	
	[pProfileView setProfileURL:cURL];
	
	pProfileView.title=@"Push Notification";//[NSString stringWithUTF8String:pFriend->cNickname];
	
	
	iXfireAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	[delegate.m_pNavController  pushViewController:pProfileView animated:YES];
	
	[pProfileView release];
	
	
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	
	
	return 6;
}

- (void)dealloc {
	

		[m_pMutableOptionslist release];
	
	[m_pOptionsTableView release];
	/*[m_pShowUsernamesFriends release];
	[m_pPlayRecvIMSound release];
	[m_pShowOfflineFriends release];
	[m_pClanGroups release];*/
    [super dealloc];
}


@end
