//
//  InboxViewController.h
//  TableProj
//
//  Created by Ram Charan on 8/28/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

@interface InboxViewController : UIViewController <UITableViewDataSource>
{
    IBOutlet UITableView *table;
    
    DBManager *_dbmanager;
    
    IBOutlet UIView *loadingView;
}

-(void) loadInboxMessages;

-(void) loadImages;

-(void)readUnread:(int)msgCount;

-(void)getTime;

@end
