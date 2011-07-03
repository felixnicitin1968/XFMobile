//
//  CustomContactCell.h
//  iXfire
//
//  Created by Moti Joseph on 5/1/09.
//  Copyright 2009 Gamepe. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomCell : UITableViewCell {
	
	UILabel *m_pContactName;
	UILabel *m_pContactStatusMessage;
	UIImageView *myImageView;
@public
	int  userid;
}
@property(nonatomic,retain)UILabel *m_pContactName;
@property(nonatomic,retain)UILabel *m_pContactStatusMessage;
@property(nonatomic,retain)UIImageView *myImageView;
@end


