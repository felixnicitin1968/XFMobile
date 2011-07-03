//
//  CustomContactCell.m
//  iXfire
//
//  Created by Moti Joseph on 5/1/09.
//  Copyright 2009 Gamepe. All rights reserved.
//Entitlements.plist

#import "CustomContactCell.h"
#import "global.h"

@implementation CustomCell


@synthesize m_pContactName,m_pContactStatusMessage,myImageView;



- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code
		m_pContactName = [[UILabel alloc]init];
		m_pContactName.textAlignment = UITextAlignmentLeft;
		m_pContactName.font = [UIFont systemFontOfSize:14];
		m_pContactStatusMessage = [[UILabel alloc]init];
		m_pContactStatusMessage.textAlignment = UITextAlignmentLeft;
		m_pContactStatusMessage.font = [UIFont systemFontOfSize:10];
		myImageView = [[UIImageView alloc]init];
		[self.contentView addSubview:m_pContactName];
		[self.contentView addSubview:m_pContactStatusMessage];
		[self.contentView addSubview:myImageView];
		
    }
    return self;
}

- (void)layoutSubviews {
	
	[super layoutSubviews];
	CGRect contentRect = self.contentView.bounds;
	CGFloat boundsX = contentRect.origin.x;
	CGRect frame;
	
	frame= CGRectMake(boundsX+10 ,0, 50, 50);
	myImageView.frame = frame;
	
	frame= CGRectMake(boundsX+70 ,20, 200, 25);
	m_pContactName.frame = frame;
	
	frame= CGRectMake(boundsX+70 ,30+15, 200, 15);
	m_pContactStatusMessage.frame = frame;
	
	m_pContactName.font = [UIFont systemFontOfSize:15];
	
	m_pContactStatusMessage.font = [UIFont italicSystemFontOfSize:13.0f];
	
	m_pContactName.textColor=OPAQUE_HEXCOLOR(g_XfContactsNameTextColor); ;;//[UIColor whiteColor];
	m_pContactStatusMessage.textColor=OPAQUE_HEXCOLOR(g_XfContactsStatusTextColor);
	
	m_pContactName.backgroundColor = [UIColor clearColor];
	m_pContactStatusMessage.backgroundColor = [UIColor clearColor];

	
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	
    [super setSelected:selected animated:animated];
	
    // Configure the view for the selected state
}


@end

