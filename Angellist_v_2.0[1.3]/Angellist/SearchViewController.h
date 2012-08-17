//
//  SearchViewController.h
//  Angellist
//
//  Created by Ram Charan on 24/07/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchDetailsViewController.h"

@interface SearchViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
{
    UIButton *backButton;
    UILabel *labelSearch;
    IBOutlet UISearchBar *searchBar;
    IBOutlet UITableView *tableSearch;
    SearchDetailsViewController *searchDetails;
    UIView *_view1;
    UIView *filterView;
}

@property(nonatomic , retain)IBOutlet UISearchBar *searchBar;




@end
