//
//  ActivityViewController.h
//  Angellist
//
//  Created by Ram Charan on 5/25/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

@interface ActivityViewController : UIViewController <UITableViewDataSource>
{
    IBOutlet UITableView *table;
    IBOutlet UIView *loadingView;
    
    DBManager *_dbmanager;
    UIView *filterView;
}

@property(nonatomic, retain)UIView *filterView;

// to save images to the documents directory
-(void) saveImagesOfFeeds;

// to save the details of all feeds to the database
-(void) saveFeedsDataToDB;

@end
