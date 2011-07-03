//
//  GroupInviteController.m
//  iXfire
//
//  Created by Moti Joseph on 2/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GroupInviteController.h"
#import  "CustomContactCell.h"
#import  "XfireCore.h"
#import  "global.h"


@implementation GroupInviteController


@synthesize     _users;

- (void)viewWillAppear:(BOOL)animated

{

	[g_pXfireNetCore clearContactInvite];
	
}

- (void) hideActivityInviteLabel: (id) timer

{
	
	
	self.navigationItem.titleView=nil;
	self.title=@"Invite friends";
	
		
}	
- (void)addActivityLabelWithStyle:(TTActivityLabelStyle)style 
{
	
	TTActivityLabel* label = [[[TTActivityLabel alloc] initWithStyle:style] autorelease];
	UIView* lastView = [self.view.subviews lastObject];
	label.text = @"Sending invite...";

	[label sizeToFit];
	//label.frame = CGRectMake(0, lastView.bottom+10, self.view.width, label.height);
	self.navigationItem.titleView=label;
	
	[NSTimer scheduledTimerWithTimeInterval: 1
	 
									 target: self
	 
								   selector: @selector(hideActivityInviteLabel:)
	 
								   userInfo: nil
	 
									repeats: NO];

	
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	
		
	return (1+[g_pXfireNetCore getTotalClans]);
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	
	
	
	NSUInteger row = [indexPath row];
	
	NSUInteger section = [indexPath section];
	XFireContact *pFriend=NULL;
	XfireClan    *pClans=NULL;

	
	
	switch(section)
	{
	case 0:
			
			pFriend=[g_pXfireNetCore contacts];
			
			pFriend=&pFriend[row];
			
			if (pFriend->userid==g_myuserid)  return;

			pFriend->invited=!	pFriend->invited;
			
			break;
	    
		case 1:
			
			pClans=[g_pXfireNetCore clans];
			
			pFriend=&pClans[section-1].users[row];	
			
			if (pFriend->userid==g_myuserid)  return;

			pFriend->invited=!	pFriend->invited;
		
			break;

		default:
			break;
	}
	
	
	if (pFriend->invited) {
	
	 [self addActivityLabelWithStyle:TTActivityLabelStyleWhite ];
		[g_pXfireNetCore XfMobileGChat_SendInvite:pFriend->sid];

	}
     [tableView deselectRowAtIndexPath:indexPath animated:NO];
	[tableView reloadData];
	
	
}


- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	
	
	NSUInteger row = [indexPath row];
	NSUInteger section = [indexPath section];
	
	static NSString *SimpleTableIdentifier = @"InviteCellIdentifier";
	
	
	CustomCell *cell;
	
	if (section>=1){
		
		XfireClan *clan=[g_pXfireNetCore clans];
		cell= (CustomCell*)[tableView dequeueReusableCellWithIdentifier:[NSString stringWithUTF8String:clan[section-1].name]];
		if (cell == nil) {
			
			cell = [[[CustomCell alloc] initWithFrame:CGRectZero
									  reuseIdentifier:[NSString stringWithUTF8String:clan[section-1].name]] autorelease];
			
			
			
		}
		
	}
	
	
	if (section==0){
		
		
		
		cell = (CustomCell*)[tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
		if (cell == nil) {
			cell = [[[CustomCell alloc] initWithFrame:CGRectZero reuseIdentifier:SimpleTableIdentifier] autorelease];
		}
		
		
	}
	
	
	
	unsigned int userid;
	XFireContact *pFriend=nil;
	XfireClan    * pClans=nil;

	
	
	
	
	NSString *string ;
	switch(section)
	{
			
			
				
		case 0:
	
			
			pFriend=[g_pXfireNetCore contacts];
			
			pFriend=&pFriend[row];
			
					
			
			pFriend->nRowInTable=row;
				
			
			if (pFriend->cNickname[0]==0){
				
				string = [[NSString alloc] initWithUTF8String:pFriend->cUsername];
				
			}
			else{
				
				string = [[NSString alloc] initWithUTF8String:pFriend->cNickname];
				
			}	
			cell.m_pContactName.text =string;
			
			if (pFriend->invited)
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			else
				cell.accessoryType = UITableViewCellAccessoryNone;
			
			
			
				cell.imageView.image =	 pFriend-> image;;
			[string release];
			

		
			
	
			
			break;
			
			
			
		default://clan friend		
			
				
			pClans=[g_pXfireNetCore clans];
			
			
			userid=pClans[section-2].users[row].userid;
			
			XFireContact *pFriend=&pClans[section-1].users[row];
			
			
			if (pFriend->invited)
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			else
				cell.accessoryType = UITableViewCellAccessoryNone;
			
			
			

			if (pFriend->cNickname[0]==0){
			
				string = [[NSString alloc] initWithUTF8String:pFriend->cUsername];
				
			}
			else{
							
			string = [[NSString alloc] initWithUTF8String:pFriend->cNickname];
		
			}
				cell.imageView.image =	 pFriend-> image;;
			
			cell.m_pContactName.text=string;
			
			[string release];
			
			
					

			
			
			
			break;
			
			
	}
	
	
	
	
	
	
	return cell;
}



#pragma mark -
#pragma mark Table View Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	
	

	
	switch (section)
	{
			
	
			
		case 0:
			
			
		
			return g_nTotalOnlineUsers;
				
		default:
			break;
			
			
	}
	
	
	XfireClan *clan=[g_pXfireNetCore clans];
	
	if (clan==0) return 0;
		return clan[section-1].online_userscount;
	
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	
	
	
	
	NSString *sectionName = nil;
	XfireClan *clan=nil;
	
	switch (section) {
	
	
		case 0:
			sectionName = [NSString stringWithFormat:@"%s (%d) ","Friends",g_nTotalOnlineUsers];
			break;
		default:
		    clan=[g_pXfireNetCore clans];
			if (clan) {
				
				
				sectionName = [NSString stringWithUTF8String:clan[section-1].name];
				
			}
			break;
	}
	
	UILabel *sectionHeader = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)] autorelease];
	sectionHeader.backgroundColor = OPAQUE_HEXCOLOR(0x144083); //[UIColor clearColor];
	sectionHeader.font = [UIFont boldSystemFontOfSize:15];
	sectionHeader.textColor = OPAQUE_HEXCOLOR(0xFF8ABAFF);
	sectionHeader.text = sectionName;
	
	return sectionHeader;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	
    return 66;
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




// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	self.title=@"Invite friends";
}



/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
	
	[_users release];
    [super dealloc];
}


@end
