//
//  ScreenshotsCategoryController.m
//  iXfire
//
//  Created by Moti Joseph on 7/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ScreenshotsCategoryController.h"
#import "global.h"
#import "iXfireAppDelegate.h"
#import "MockPhotoSource.h"
@implementation ScreenshotsCategoryController
@synthesize    m_pScreenshotsCategoryTable;
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

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return  YES;// (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || UIInterfaceOrientationLandscapeRight==interfaceOrientation);
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	
	NSUInteger section = [indexPath section];
	
    return 66;
}

#define degreesToRadian(x) (M_PI * x / 180.0)
- (void)viewWillAppear:(BOOL)animated

{
	
	
	
	
	self.view.backgroundColor =OPAQUE_HEXCOLOR(g_XfBackgroundColor);
	
	m_pScreenshotsCategoryTable.backgroundColor=OPAQUE_HEXCOLOR(g_XfBackgroundColor);
	
	
	m_pScreenshotsCategoryTable.separatorColor= OPAQUE_HEXCOLOR(0xFF8ABAF1);

	self.title=@"Screenshots";
	
	static int loaded=0;
	
	if (loaded==0){
		loaded=1;
	
	iXfireAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	
	UIActionSheet *actionSheet = [[UIActionSheet alloc] 
								  initWithTitle:@"Use landscape mode for better view ." 
								  delegate:nil 
								  cancelButtonTitle:@"OK"
								  destructiveButtonTitle:nil 
								  otherButtonTitles:nil];
	
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	[actionSheet showInView:delegate.m_pNavController.visibleViewController.view];
	[actionSheet release];
	
	}
	
	
}

-(void)ScreenshotsCategoryController:(TTThumbsViewController*)controller didSelectPhoto:(id<TTPhoto>)photo

{
	
}


- (BOOL)ScreenshotsCategoryController:(TTThumbsViewController*)controller
	   shouldNavigateToPhoto:(id<TTPhoto>)photo

{

	return TRUE;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	
	NSUInteger row = [indexPath row];
	
	NSUInteger section = [indexPath section];
	
	NSMutableArray *pImages=[[NSMutableArray alloc] initWithObjects:nil];
	MockPhoto *photo;
	
	int gameid=g_idGamesCategory[row];
	
	for (int i=0; i<g_xScreenShotCount; i++){
	
		
		if (gameid==g_xScreenShot[i].gameid){
			
	
			//NSLog(@"adding photo %s",g_xScreenShot[i].cURL);
		
			photo=[[[MockPhoto alloc] initWithURL:[NSString stringWithFormat:@"http://screenshot.xfire.com/screenshot/large/%s.jpg",g_xScreenShot[i].cURL]
										 smallURL:[NSString stringWithFormat:@"http://screenshot.xfire.com/screenshot/small/%s.jpg",g_xScreenShot[i].cURL] size:CGSizeMake(960, 1280) 
					
										  caption:[NSString stringWithFormat:@"%s",g_xScreenShot[i].cComment]]  autorelease];
			
			[ pImages addObject:photo];
		}
		
		
	}
	
	
	

	
	
	
	
	TTThumbsViewController *thumbs = [[TTThumbsViewController alloc] init] ;
	
	thumbs.photoSource = [[MockPhotoSource alloc]
						  initWithType:MockPhotoSourceNormal
						  //initWithType:MockPhotoSourceDelayed
						  // initWithType:MockPhotoSourceLoadError
						  // initWithType:MockPhotoSourceDelayed|MockPhotoSourceLoadError
						  title:@"Photos"
						  photos:pImages
						  
						  
						  photos2:nil
						  //  photos2:[[NSArray alloc] initWithObjects:
						  //    [[[MockPhoto alloc]
						  //      initWithURL:@"http://farm4.static.flickr.com/3280/2949707060_e639b539c5_o.jpg"
						  //      smallURL:@"http://farm4.static.flickr.com/3280/2949707060_8139284ba5_t.jpg"
						  //      size:CGSizeMake(800, 533)] autorelease],
						  //    nil]
						  ];
	
	
	iXfireAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	
	//thumbs.delegate = self;

	
	
	//thumbs.popupViewController=self;
	
	//[self presentModalViewController:thumbs animated:YES];

	
	[delegate.m_pNavController  pushViewController:thumbs animated:YES];
	
	
	[thumbs release];
	
	

	

	
	
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



- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

	
	UITableViewCell *cell;
	
	NSUInteger row = [indexPath row];
	static NSString *SimpleChatTableIdentifier = @"CategoryScreenShotCell"; 
		
		cell= [tv dequeueReusableCellWithIdentifier:SimpleChatTableIdentifier];
    	if (cell == nil)
			
		{
			
			
			cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero
										   reuseIdentifier:SimpleChatTableIdentifier] autorelease];
			
			
			
	    }

	
	

	

	cell.textLabel.font=[UIFont italicSystemFontOfSize:15];
	cell.textLabel.text =	[NSString stringWithFormat:@"%s", GetGameName(g_idGamesCategory[row])];
	cell.textLabel.textColor=OPAQUE_HEXCOLOR(g_XfContactsNameTextColor);
	
	
	UIImage *image=[self newImageFromResource:[NSString stringWithFormat:@"gameid_%d.gif",g_idGamesCategory[row]]];
	
	cell.imageView.image=image;
	
	[image release];
	
	return cell;
	}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	
	
	return g_idGamesCategoryCunt;
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
 
	
	[m_pScreenshotsCategoryTable release];
	[super dealloc];
}


@end
