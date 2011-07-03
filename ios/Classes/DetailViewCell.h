//
//  DetailViewCell.h
//  iXfire
//
//  Created by Moti Joseph on 7/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailViewCell : UITableViewCell {
	UILabel *label;
}


// gets the data from another class
-(void)setData:(NSString *)text;

@property (nonatomic, retain) UILabel *label;

@end



