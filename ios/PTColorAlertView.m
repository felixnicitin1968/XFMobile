//
//  PTColorAlertView.m
//  PocketTouch
//
//  Created by Skylar Cantu on 7/18/09.
//  Copyright 2009 Skylar Cantu. All rights reserved.
//

#import "PTColorAlertView.h"
#import  "global.h"

@implementation PTColorAlertView

- (id)initWithFrame:(CGRect)frame {
	
	
	if (self = [super initWithFrame:frame]) {
		
		
		previewView = [[UIView alloc] initWithFrame:CGRectZero];
		previewView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
		previewView.opaque = YES;
		
		redLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		redLabel.backgroundColor = [UIColor clearColor];
		redLabel.text = @"R";
		redLabel.textColor = [UIColor redColor];
		redLabel.font = [UIFont systemFontOfSize:20];
		redLabel.shadowColor = [UIColor blackColor];
		redLabel.shadowOffset = CGSizeMake(0, -1);
		
		greenLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		greenLabel.backgroundColor = [UIColor clearColor];
		greenLabel.text = @"G";
		greenLabel.textColor = [UIColor greenColor];
		greenLabel.font = [UIFont systemFontOfSize:20];
		greenLabel.shadowColor = [UIColor blackColor];
		greenLabel.shadowOffset = CGSizeMake(0, -1);
		
		blueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		blueLabel.backgroundColor = [UIColor clearColor];
		blueLabel.text = @"B";
		blueLabel.textColor = [UIColor blueColor];
		blueLabel.font = [UIFont systemFontOfSize:20];
		blueLabel.shadowColor = [UIColor blackColor];
		blueLabel.shadowOffset = CGSizeMake(0, -1);
		
		redSlider = [[UISlider alloc] initWithFrame:CGRectZero];
		[redSlider addTarget:self action:@selector(redSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
		
		greenSlider = [[UISlider alloc] initWithFrame:CGRectZero];
		[greenSlider addTarget:self action:@selector(greenSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
		
		blueSlider = [[UISlider alloc] initWithFrame:CGRectZero];
	   [blueSlider addTarget:self action:@selector(blueSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
		
		
		[self addSubview:redLabel];
		[self addSubview:greenLabel];
		[self addSubview:blueLabel];
		[self addSubview:redSlider];
		[self addSubview:greenSlider];
		[self addSubview:blueSlider];
		[self addSubview:previewView]; 
		
		
		
	}
	return self;
}


- (void)drawRect:(CGRect)rect
{
	
	
	[super drawRect:rect];
	
	UIGraphicsBeginImageContext(previewView.frame.size);
	CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 2.0);
	CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.9, 0.9, 1.0, 1.0);
	CGContextSetShadow(UIGraphicsGetCurrentContext(), CGSizeMake(0, -3), 3.0);
	CGContextStrokeRect(UIGraphicsGetCurrentContext(),      CGContextGetClipBoundingBox(UIGraphicsGetCurrentContext()));
	[previewView addSubview:[[[UIImageView alloc] initWithImage:UIGraphicsGetImageFromCurrentImageContext()] autorelease]];
	UIGraphicsEndImageContext();
	
	
}


- (void)presetSlidersWithColor:(UIColor *)color
{
	
	
	
	if (CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) == kCGColorSpaceModelMonochrome) {
		
		
		const CGFloat *clr = CGColorGetComponents(color.CGColor);
		[redSlider setValue:clr[0] animated:YES];
		[greenSlider setValue:clr[0] animated:YES];
		[blueSlider setValue:clr[0] animated:YES];
		
		
	} else {
		
		
	
		const CGFloat *clr = CGColorGetComponents(color.CGColor);
		[redSlider setValue:clr[2] animated:YES];
		[greenSlider setValue:clr[1] animated:YES];
		[blueSlider setValue:clr[0] animated:YES];
		
	
	}
	
	
	
	[self performSelector:@selector(redSliderValueChanged:) withObject:redSlider afterDelay:0.0];
	[self performSelector:@selector(blueSliderValueChanged:) withObject:blueSlider afterDelay:0.0];
	[self performSelector:@selector(greenSliderValueChanged:) withObject:greenSlider afterDelay:0.0];

}





- (UIColor *)getColor {
	return [UIColor colorWithRed:redSlider.value green:greenSlider.value blue:blueSlider.value alpha:1.0]; 
}



- (NSUInteger )getRGBColor
{
	
	return RGB(blueSlider.value*255.0,greenSlider.value*255.0,redSlider.value*255.0); 
	
}


- (void)dealloc
{
	
	NSLog(@"dialloc of colorrrr");
	
	[super dealloc];
	
    [redLabel release];
	[greenLabel release];
    [blueLabel  release];
	[redSlider release];
	[greenSlider release];
	[blueSlider release];
	[previewView release]; 
	
}


- (void)layoutSubviews
{
	CGFloat buttonTop;
	for (UIView *view in self.subviews) {
		if ([[[view class] description] isEqualToString:@"UIThreePartButton"]) {
			
			view.frame = CGRectMake(view.frame.origin.x, self.bounds.size.height - view.frame.size.height - 15, view.frame.size.width, view.frame.size.height);
			
			buttonTop = view.frame.origin.y;
		}
	}
	buttonTop -= 7; buttonTop -= 100;
	previewView.frame = CGRectMake(12, buttonTop, self.frame.size.width - 53, 100);
	
	buttonTop -= 7; buttonTop -= 30;
	blueLabel.frame = CGRectMake(12, buttonTop, self.frame.size.width - 52, 30);
	blueSlider.frame = CGRectMake(blueLabel.frame.origin.x + 25, blueLabel.frame.origin.y, blueLabel.frame.size.width - 25, blueLabel.frame.size.height);
	
	buttonTop -= 30;
	greenLabel.frame = CGRectMake(12, buttonTop, self.frame.size.width - 52, 30);
	greenSlider.frame = CGRectMake(greenLabel.frame.origin.x + 25, greenLabel.frame.origin.y, greenLabel.frame.size.width - 25, greenLabel.frame.size.height);
	
	buttonTop -= 30;
	redLabel.frame = CGRectMake(12, buttonTop, self.frame.size.width - 52, 30);
	redSlider.frame = CGRectMake(redLabel.frame.origin.x + 25, redLabel.frame.origin.y, redLabel.frame.size.width - 25, redLabel.frame.size.height);
}




- (void)setFrame:(CGRect)rect 
{
	
	[super setFrame:CGRectMake(0, 0, rect.size.width, 300)];
	self.center = CGPointMake(320/2, 480/2);
}



#pragma mark 
#pragma mark UISlider Methods

- (void)redSliderValueChanged:(UISlider *)slider 
{
	
	[UIView beginAnimations:nil context:NULL];
	previewView.backgroundColor = [UIColor colorWithRed:slider.value green:greenSlider.value blue:blueSlider.value alpha:1.0];
	[UIView commitAnimations];
}


- (void)greenSliderValueChanged:(UISlider *)slider
{
	[UIView beginAnimations:nil context:NULL];
	previewView.backgroundColor = [UIColor colorWithRed:redSlider.value green:slider.value blue:blueSlider.value alpha:1.0];
	[UIView commitAnimations];
}


- (void)blueSliderValueChanged:(UISlider *)slider
{
	
	[UIView beginAnimations:nil context:NULL];
	previewView.backgroundColor = [UIColor colorWithRed:redSlider.value green:greenSlider.value blue:slider.value alpha:1.0];
	[UIView commitAnimations];
}

@end
