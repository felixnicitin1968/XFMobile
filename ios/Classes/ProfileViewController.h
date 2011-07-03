//
//  ProfileViewController.h
//  iXfire
//
//  Created by Moti Joseph on 4/27/09.
//  Copyright 2009 Gamepe. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ProfileViewController : UIViewController <UIWebViewDelegate> {

	IBOutlet UIWebView *m_webProfilebView;
	char                m_cProfileURL[256];
	IBOutlet UIActivityIndicatorView         *m_pLoadingProfilectivityIndicator;

}




-(void) setProfileURL:(char*) pURL;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView       *m_pLoadingProfilectivityIndicator;
@property(nonatomic,retain)    UIWebView *m_webProfilebView;
@end
