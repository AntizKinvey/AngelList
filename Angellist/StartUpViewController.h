//
//  StartUpViewController.h
//  TableProj
//
//  Created by Ram Charan on 8/24/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

@interface StartUpViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *table;
    IBOutlet UIView *filterViewInStartUps;
    IBOutlet UIView *filtersButtonsViewInStartUps;
    
    IBOutlet UIView *emptyAlertView;
    
    DBManager *_dbmanager;
    
    IBOutlet UIView *loadingView;
}
-(void) getStartUpsFollowedByUser;
-(void) loadFollowingStartUps:(NSString *)urlString;
-(void) loadPortfolioStartUps:(NSString *)urlString;

-(void) loadImages;

-(void) getTrendingStartUps;
-(void) getFollowingStartUps;
-(void) getPortfolioStartUps;

-(IBAction)getFilteredList:(id)sender;

-(void) saveTrendingStartUps;
-(void) saveFollowingStartUps;
-(void) savePortfolioStartUps;

-(void)refreshTrendingStartUps;
-(void) startLoadingAtTop;

@end
