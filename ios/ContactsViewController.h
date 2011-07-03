//
//  FriendsController.h
//  iXfire
//CGPoint p = [tv contentOffset];
//tv.text = [NSString stringWithFormat:@"%@\n%@", tv.text, @"New line"];
//[tv setContentOffset:p animated:NO];
//[tv scrollRangeToVisible:NSMakeRange([tv.text length], 0)];//  Created by Moti Joseph on 4/9/09.
//  Copyright 2009 Gamepe. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Three20/Three20.h"
#import "XfireCore.h"
#import "global.h"
#import "GroupChatController.h"
#import "XGroupChannel.h"
#import "GADAdViewController.h"
#import "GADAdSenseParameters.h"
#import "iAd/ADBannerView.h"

@class  ChatViewController;
@class  PreferencesViewController;
@class  ProfileViewController;

@class  GroupChatController;


@interface ContactsViewController : UIViewController <TTPostControllerDelegate,UITableViewDelegate, GADAdViewControllerDelegate,UITableViewDataSource,UITextFieldDelegate,UIAlertViewDelegate,UISearchBarDelegate,UIActionSheetDelegate>
{
	

		IBOutlet                   UITextField *m_pMyStatus;
		IBOutlet UITableView      *m_pContactsTableView;
	    ChatViewController        *m_pChatWindow;
     	GroupChatController       *m_GroupController;
		CGFloat                    m_animatedDistance;
	  
      	int                        m_nTotalOnlineUsers;
     	
	    int                        m_nTotalConvSessions;
	    NSMutableArray             *m_pConverstaionMessageslist;
	
        TTSearchlightLabel*        _Loadinglabel;
    	uint8                       invite_sid[16];     
	    GADAdViewController *adViewController_;
	
     	NSMutableData* receivedAdsData;
	    NSString *_keywords;
	    UIView *_contentView;
	    id _adBannerView;
	    BOOL _adBannerViewIsVisible;


	}


// After the interface
@property (nonatomic, retain) IBOutlet UIView *contentView;
@property (nonatomic, retain) id adBannerView;
@property (nonatomic) BOOL adBannerViewIsVisible;

@property                     int                       m_nTotalConvSessions;
@property(nonatomic,retain)   GroupChatController         *m_GroupController;
@property(nonatomic,retain)   ChatViewController         *m_pChatWindow;
@property(nonatomic,retain)   UITableView                *m_pContactsTableView;
@property(nonatomic,retain)   UITextField                *m_pMyStatus;



-(void)                        showThemeEditor  ;
-(void)                        get_keyords;
-(void)                        noScreenShotAnimation;
-(void)                        showBuddyinvite:(char*)msg;
-(void)                        addNewGroupChat;
- (void)                       removeGroupConverstaion;
-(void)                        showGoupChatinvite:(XfGroupChannel*)pGroupChat;
-(void)                        startLoadingAnimation;
-(void)                        stopLoadingAnimation;
-(void)                        showMore;
-(void)                        showNews;
-(void)                        showAddFriends;
-(void)                        showPreferences;
-(void)                        UpdateContactsStatusMessage;
-(void)                        UpdateContactsGameName:(XFireContact*)pContact;
-(UIImage *)                   newImageFromResource:(NSString *)filename;

-(void)                        initData;
-(void)                        playSound:(NSString*) name;
-(void)                        OnRecvMessage: (uint32)userid Msg:(char*)pMessage;
-(void)                        UpdateContact:(int)userid  isOnline:(bool)bOnline;

-(void)                        chatCellAccessoryClicked:(id)sender;
-(IBAction)                    addContact:(id) sender;	
-(IBAction)                    setMyStatusMessageDone:(id) sender;
-(void)                        OnTypingMessage: (uint32)userid;
-(void)                        viewUserProfile:(int)userid;



@end


