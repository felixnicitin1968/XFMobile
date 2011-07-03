//
//  ThemeEditor.h
//  iXfire
//
//  Created by Moti Joseph on 4/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ColorPickerViewController;



#define XFMOBILE_THEME                               0
#define XFMOBILE_THEME_BACKGROUND_COLOR              0
#define XFMOBILE_XFIRE_THEME                         1

#define XFMOBILE_CONTACTS_THEME                      1

#define XFMOBILE_CONTACTS_THEME_TEXT_COLOR           0
#define XFMOBILE_CONTACTS_THEME_STATUS_TEXT_COLOR    1
#define XFMOBILE_CONTACTS_THEME_SECTION_BACKGROUND_COLOR 2
#define XFMOBILE_CONTACTS_THEME_SECTION_TEXT_COLOR 3

#define XFMOBILE_CONTACTS_THEME_SEPARATOR_COLOR 4

#define XFMOBILE_NAVBAR_THEME                         2
#define XFMOBILE_NAVBAR_THEME_BACKGROUND_COLOR        0




@interface ThemeEditor : UIViewController<UIAlertViewDelegate> {

	
	
	 IBOutlet UITableView *tblSimpleTable;
	 NSArray *arryContactsScreen;
	 NSArray *arryXfMobileScreen;
	NSArray *arryNavigationbar;
	
	
	 ColorPickerViewController *viewController;
	
}

@property (nonatomic, retain) IBOutlet ColorPickerViewController *viewController;
@end


