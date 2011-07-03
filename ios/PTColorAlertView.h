//
//  PTColorAlertView.h
//  PocketTouch
//
//  Created by Skylar Cantu on 7/18/09.
//  Copyright 2009 Skylar Cantu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PTColorAlertView : UIAlertView 
{
	
	
	UISlider *redSlider;
	UISlider *greenSlider;
	UISlider *blueSlider;
	
	UILabel *redLabel;
	UILabel *blueLabel;
	UILabel *greenLabel;
	
	UIView *previewView;
}


- (void)presetSlidersWithColor:(UIColor *)color;

- (UIColor *)getColor;

- (NSUInteger )getRGBColor;

@end
