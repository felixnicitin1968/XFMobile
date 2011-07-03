//
//  SearchViewController.h
//  iXfire
//
//  Created by Moti Joseph on 7/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SearchViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

{
  IBOutlet                                 UISearchBar *m_pContactSearchBar;
  IBOutlet        UITableView              *m_pSearchedFriendTableView;
  IBOutlet UIActivityIndicatorView         *m_pSearchActivityIndicator;


}
@property(nonatomic,retain)   UIActivityIndicatorView               *m_pSearchActivityIndicator;
@property(nonatomic,retain)   UISearchBar               *m_pContactSearchBar;
@property(nonatomic,retain)   UITableView               *m_pSearchedFriendTableView;
- (UIImage *)                  newImageFromResource:(NSString *)filename;
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;
-(void) refresh;

@end
