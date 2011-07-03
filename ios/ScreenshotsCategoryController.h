//
//  ScreenshotsCategoryController.h
//  iXfire
//
//  Created by Moti Joseph on 7/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <TTThumbsViewControllerDelegate.h>

@interface ScreenshotsCategoryController : UIViewController  <TTThumbsViewControllerDelegate,UITableViewDelegate, UITableViewDataSource>{

	
	IBOutlet        UITableView              *m_pScreenshotsCategoryTable;
	
	
}


@property(nonatomic,retain)   UITableView     *m_pScreenshotsCategoryTable;


- (UIImage *)newImageFromResource:(NSString *)filename  ;


@end
