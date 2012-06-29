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

-(void)getTime;
-(void)startLoadingImagesConcurrently;
-(void)sendRequestToFetch;
-(void)readUnread:(int)msgCount;

@end
