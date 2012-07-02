//
//  InboxViewController.h
//  Angellist
//
//  Created by Ram Charan on 5/25/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

@interface InboxViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *tableview;
    UILabel *label;
    IBOutlet UIView *loading;
    
    DBManager *_dbmanager;
    
    
}

@property(nonatomic, retain)IBOutlet UITableView *tableview;
@property(nonatomic, retain)IBOutlet UIView *loading;

// To display time on screen 
-(void)getTime;

// To load images concurrently 
-(void)startLoadingImagesConcurrently;

// send request to fetch the data 
-(void)sendRequestToFetch;

// To display viewed status
-(void)readUnread:(int)msgCount;

@end
