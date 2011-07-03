//
//  DetailViewCell.m
//  iXfire
//
//  Created by Moti Joseph on 7/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DetailViewCell.h"


#import "DetailViewCell.h"


@implementation DetailViewCell

@synthesize label;


- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
		// Initialization code
		// we need a view to place our labels on.
		UIView *myContentView = self.contentView;
		
		//init font.
		UIFont *font = [UIFont systemFontOfSize:12];
		
		// init the label
		self.label = [[UILabel alloc] initWithFrame:CGRectZero];
		self.label.backgroundColor = [UIColor blackColor];
		self.label.font = font;
		self.label.numberOfLines = 0;
		
		[myContentView addSubview:self.label];
		[self.label release];
		
	}
	return self;
}



-(void)setData:(NSString *)text {

	
	self.label.text = text;	
	
	
	
	if (strstr([text UTF8String],"Me:")){
		
		
#ifdef __IPHONE_3_0
		self.label.textColor=[UIColor blueColor];
		//	cell.imageView.image =[UIImage imageNamed:@"white_star.png"];
#else
		//	cell.image =[UIImage imageNamed:@"white_star.png"];
		//self.label=[UIColor blackColor];
		self.textColor=[UIColor blueColor];
#endif		
		
		
	}else{
		
		
#ifdef __IPHONE_3_0
		self.label.textColor=[UIColor blackColor];
		//	cell.imageView.image =[UIImage imageNamed:@"white_star.png"];
#else
		//	cell.image =[UIImage imageNamed:@"white_star.png"];
		//self.label=[UIColor blackColor];
		self.textColor=[UIColor blackColor];
#endif		
	
		
	}
		
	

	
	
}





-(void)layoutSubviews {
	[super layoutSubviews];
	
	//get the cell size.
	CGRect contentRect = self.contentView.bounds;
	
	if(!self.editing){
		CGFloat boundsX = contentRect.origin.x;
		CGRect frame;
		
		NSString *text = self.label.text;
		UIFont *font = self.label.font;
		CGSize constraint = CGSizeMake(280,500);
		CGSize size = [text sizeWithFont:font constrainedToSize:constraint];
		
		//frame = CGRectMake(boundsX + 5, 0, 280, size.height);
		frame = CGRectMake(boundsX, 0, 280, size.height);
		self.label.frame = frame;
		
		
		
	}
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	
	[super setSelected:selected animated:animated];
	
	// Configure the view for the selected state
}


- (void)dealloc {
	NSLog(@"olalalal");
//	[label dealloc];
	[super dealloc];
}


@end


