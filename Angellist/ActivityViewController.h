//
//  ActivityViewController.h
//  Angellist
//
//  Created by Ram Charan on 5/25/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
#import "StartUpViewController.h"


@interface ActivityViewController : UIViewController <UITableViewDataSource>
{
    IBOutlet UITableView *table;
    IBOutlet UIView *loadingView;
    UIView *loadOlderFeeds;
    UIView *_view1;
    UILabel *label;
    
    UIImageView *kinvey;
    UIImageView *angelLogo;
    DBManager *_dbmanager;
    UIView *filterView;
    UIActivityIndicatorView *labelLoading;
    StartUpViewController *startUpView;
}

@property(nonatomic, retain)UIView *filterView;

// to save images to the documents directory
-(void) saveImagesOfFeeds;

// to save the details of all feeds to the database
-(void) saveFeedsDataToDB;
-(void)getFeeds;
@end
