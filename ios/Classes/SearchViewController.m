//
//  SearchViewController.m
//  iXfire
//
//  Created by Moti Joseph on 7/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SearchViewController.h"

#import "global.h"
#import "XfireCore.h"
#import  "iXfireAppDelegate.h"


@implementation SearchViewController
#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 8.0f

@synthesize     m_pSearchActivityIndicator;

@synthesize     m_pSearchedFriendTableView;
@synthesize     m_pContactSearchBar;
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

    
	
	self.title=@"Search Friends";  
	m_pContactSearchBar.autocapitalizationType=UITextAutocapitalizationTypeNone;
	
	m_pContactSearchBar.autocorrectionType=UITextAutocorrectionTypeNo;
	
    g_nXfireSearchedFriendCount=0;
	
	[super viewDidLoad];
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

- (void)chatCellAccessoryClicked:(id)sender;
{
	
	UIButton *buttonView =(UIButton*)sender;
	
	NSUInteger row = buttonView.tag;
	[g_pXfireNetCore XfMobile_AddFriend:g_xfireSearchedFriends[row].cUsername msg:@"Hello from my iPhone!"];
	
	iXfireAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	
    UIActionSheet *actionSheet = [[UIActionSheet alloc] 
								  initWithTitle:[NSString stringWithFormat:@"XfMobile sent invite to %s .",g_xfireSearchedFriends[row].cUsername]
								  delegate:nil 
								  cancelButtonTitle:@"OK"
								  destructiveButtonTitle:nil 
								  otherButtonTitles:nil];
    [actionSheet showInView:delegate.m_pNavController.visibleViewController.view];
    [actionSheet release];
	

	
	
	
}
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell;
	UILabel *label = nil;
	
	
	NSUInteger row = [indexPath row];
	
	cell = [tv dequeueReusableCellWithIdentifier:@"CellX"];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"CellX"] autorelease];
		
		
		
		cell.accessoryType =  UITableViewCellAccessoryDetailDisclosureButton;

		
		UIButton *buttonView = [UIButton buttonWithType:UIButtonTypeInfoLight ];
		
		cell.accessoryView = buttonView;
		buttonView.tag=row;
		[buttonView addTarget:self action:@selector(chatCellAccessoryClicked:) forControlEvents: UIControlEventTouchDown  ];
		//[buttonView release];		
		
		label = [[UILabel alloc] initWithFrame:CGRectZero];
		[label setLineBreakMode:UILineBreakModeWordWrap];
		[label setMinimumFontSize:FONT_SIZE];
		[label setNumberOfLines:0];
		[label setFont:[UIFont systemFontOfSize:FONT_SIZE]];
		[label setTag:1];
		
		[[cell contentView] addSubview:label];
	}
	
	NSString *text =  [NSString stringWithFormat:@"%s (%s %s)",g_xfireSearchedFriends[row].cUsername,g_xfireSearchedFriends[row].fname,g_xfireSearchedFriends[row].lname];  	
	CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
	
	CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
	
	if (!label) {
		label = (UILabel*)[cell viewWithTag:1];
	}
	
	label.backgroundColor=[UIColor  clearColor];
	
	
	label.textColor=OPAQUE_HEXCOLOR(g_XfContactsNameTextColor);

	
    [label setText:text];
	[label setFrame:CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), MAX(size.height, 44.0f))];
	
	return cell;
	
	
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	
	
	return g_nXfireSearchedFriendCount;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orient
{
    return NO;
}


-(void) refresh
{
	m_pSearchActivityIndicator.hidden=TRUE;
	[m_pSearchActivityIndicator stopAnimating];
   [m_pSearchedFriendTableView reloadData];

}

- (void)viewWillAppear:(BOOL)animated

{


	
	self.view.backgroundColor =OPAQUE_HEXCOLOR(g_XfBackgroundColor);
	
	m_pSearchedFriendTableView.backgroundColor=OPAQUE_HEXCOLOR(g_XfBackgroundColor);
	
	
	
	m_pSearchedFriendTableView.separatorColor= OPAQUE_HEXCOLOR(0xFF8ABAF1);
	[m_pSearchActivityIndicator stopAnimating];
	[m_pSearchedFriendTableView reloadData];
	
	m_pSearchActivityIndicator.hidden=TRUE;
	
	
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar

{
	
	m_pSearchActivityIndicator.hidden=FALSE;
	[m_pSearchActivityIndicator startAnimating];
	g_nXfireSearchedFriendCount=0;
	[m_pSearchedFriendTableView reloadData];
	
	NSString *searchTerm=[m_pContactSearchBar text];
	
	NSLog(searchTerm);
	
	[m_pContactSearchBar resignFirstResponder];
	
	[g_pXfireNetCore XfMobile_SearchFreinds:[searchTerm  UTF8String] view:self];
	
	
	
	
	
	
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
	
	
	[m_pSearchedFriendTableView release];
	[m_pSearchActivityIndicator release];
	[m_pContactSearchBar release];
    [super dealloc];
}


@end
