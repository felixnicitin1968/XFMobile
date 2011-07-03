//
//  TextAlertView.h
//  iXfire
//
//  Created by Moti Joseph on 2/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>

#define kUITextFieldHeight 30.0
#define kUITextFieldXPadding 12.0
#define kUITextFieldYPadding 10.0
#define kUIAlertOffset 100.0

@interface TextAlertView : UIAlertView {
	UITextField *textField;
	BOOL layoutDone;
}

@property (nonatomic, retain) UITextField *textField;

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate 
  cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;

@end