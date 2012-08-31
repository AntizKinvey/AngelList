//
//  ActivityViewController.h
//  TableProj
//
//  Created by Ram Charan on 8/24/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

@interface ActivityViewController : UIViewController <UITableViewDataSource>
{
    IBOutlet UITableView *table;
    
    DBManager *_dbmanager;
    
    IBOutlet UIView *filterView;
    IBOutlet UIView *filtersButtonsView;
    IBOutlet UIView *emptyAlertView;
    IBOutlet UIView *loadingView;
}

-(void) loadImages;
-(void) loadFeeds:(int)pageNo;
-(void) saveImagesToDocumentsDirectory;

-(void)latestfeeds;
-(void)morefeeds;

-(void) startLoadingAtTop;
-(void) startLoadingAtBottom;

-(IBAction)getFilteredList:(id)sender;

@end
