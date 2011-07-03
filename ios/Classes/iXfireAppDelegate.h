//
//  iXfireAppDelegate.h
//  iXfire
//
//  Created by Moti Joseph on 4/1/09.
//  Copyright Gamepe 2009. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MainController;

#import "FlurryAPI.h"

@interface iXfireAppDelegate : NSObject <UIApplicationDelegate> 
{
	
    IBOutlet UIWindow               *window;  //outlet added
	IBOutlet UINavigationController *m_pNavController;
	bool    registered;

}
-(BOOL)isForeground ;
-(BOOL)isMultitaskingOS;
@property (nonatomic, assign)   bool                              registered;

@property (nonatomic, retain)   IBOutlet UIWindow                  *window;
@property (nonatomic, retain)   IBOutlet UINavigationController    *m_pNavController;


@end



