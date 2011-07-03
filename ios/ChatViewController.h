//
//  IMController.h
//  iXfire
//
//  Created by Moti Joseph on 4/9/09.
//  Copyright 2009 Gamepe. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XfireCore.h"

@interface ChatViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{

	

	int                                m_userid;
	IBOutlet        UITableView        *m_pMessagesTableView;
	IBOutlet        UITextField        *m_pMessage;
	CGFloat                            animatedDistance;
	UIInterfaceOrientation              m_toInterfaceOrientation;
	NSMutableArray                     *m_pMutableMessageslist;
	
	IBOutlet        UIView              *m_pInputText;
	IBOutlet        UIView              *m_pChatView;


}
@property (nonatomic, retain)   IBOutlet UIView                   *m_pChatView;       
@property (nonatomic, retain)   IBOutlet UIView                   *m_pInputText;         
@property (nonatomic, retain)   IBOutlet UITableView              *m_pMessagesTableView;
//@property (nonatomic, assign)   XFireContact                    *m_pContact;


@property (nonatomic, retain)   IBOutlet UITextField              *m_pMessage;
-(void)                   SetChattingMode:(uint32) userid;
-(void)                   SetTypingMode:(uint32)userid;
-(void)                   clearChatView;
-(IBAction)               OnOpenGamepe:(id) sender;
-(void)                   OnRecvMessage: (uint32)userid Msg:(char*)pMessage;
-(void)                   SetContact:(int) userd;
-(IBAction)               ImDoneTyping:(id) sender;
-(XFireContact*)          GetContact;

- (CGSize)GetSizeOfText:(NSString *)text withFont:(UIFont *)font;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
//- (NSString *)getTextForIndexPath:(NSIndexPath *)indexPath;
@end





 



/*
 
 #import 
 
 
 
 @interface FeedItemController : UIViewController 
 {
 IBOutlet UITableView *tblView;
 NSDictionary *currentStory;
 UILabel		*textView;
 
 }
 
 -(NSString *) testFunction;
 - (CGSize)GetSizeOfText:(NSString *)text withFont:(UIFont *)font;
 - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
 - (NSString *)getTextForIndexPath:(NSIndexPath *)indexPath;
 
 @property (nonatomic, retain) UITableView *tblView;
 @property (nonatomic, retain) NSDictionary *currentStory;
 @property (nonatomic, retain) UILabel *textView;
 
 
 @end
 
 
 
 #import "FeedItemController.h"
 #import "DetailViewCell.h"
 #import "UIKit/UITableView.h"
 #import 
 
 @implementation FeedItemController
 
 @synthesize tblView, currentStory, textView;

 
 

 
 -(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
 static NSString *identifier = @"MyCell";
 
 DetailViewCell *cell = (DetailViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
 if (cell == nil) {
 cell = [[[DetailViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:identifier] autorelease];
 }
 
 
 NSString *cellText = [self getTextForIndexPath:indexPath];
 
 //NSLog(@"Setting text to %@", cellText);
 [cell setData:cellText];
 
 return cell;
 }
  


 

 
 - (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
 {
 //boy i need to learn how to use arrays :P
 switch (section) {
 case 0:
 return @"Name and Date";
 break;
 case 1:
 return @"Details";
 default:
 return @"";
 break;
 }
 }
 
 - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
 {
 return 3;
 }
 
 -(NSInteger)tableView:(UITableView *)tblView numberOfRowsInSection:(NSInteger)section {
 
 //Every cell is going to have two rows.
 switch (section) {
 case 0:
 return 2;
 break;
 case 1:
 return 1;
 default:
 return 1;
 break;
 }
 }
 
 
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 // Navigation logic
 if(indexPath.row == 0 && indexPath.section == 2){
 NSString * storyLink = [currentStory objectForKey: @"link"];
 
 // clean up the link - get rid of spaces, returns, and tabs...
 storyLink = [storyLink stringByReplacingOccurrencesOfString:@" " withString:@""];
 storyLink = [storyLink stringByReplacingOccurrencesOfString:@"\n" withString:@""];
 storyLink = [storyLink stringByReplacingOccurrencesOfString:@"	" withString:@""];
 
 // NSLog(@"link: %@", storyLink);
 // open in Safari
 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:storyLink]];
 }
 }
 
 
 #pragma mark UIViewController delegates
 

 
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 
 
 - (void)didReceiveMemoryWarning {
 [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
 // Release anything that's not essential, such as cached data
 }
 
 
 
 - (void)dealloc {
 [currentStory release];
 [tblView release];
 [super dealloc];
 }
 
 
 
 
 @end*/




