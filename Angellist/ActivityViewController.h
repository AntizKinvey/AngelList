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
}

-(void) saveImagesOfFeeds;
-(void) saveFeedsDataToDB;

@end
