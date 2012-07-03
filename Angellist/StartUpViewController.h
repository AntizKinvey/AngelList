//
//  StartUpViewController.h
//  Angellist
//
//  Created by Ram Charan on 5/25/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"


@interface StartUpViewController : UIViewController <UITableViewDataSource>
{
    IBOutlet UITableView *table;
    IBOutlet UIView *loadingView;
    IBOutlet UIButton *moreButton;
    DBManager *_dbmanager;
    UIView *filterView;
}

@property(nonatomic,retain) UIView *filterView;

//Method to get details of user following
-(void) getDetailsOfFollowing;
//Method to get details of user portfolio
-(void) getDetailsOfPortfolio;
-(void) getDetailsOfAll;

//Save images and startUp details to database
-(void) saveImagesOfStartUps;
-(void) saveStartUpsDetailsToDB;

-(void) saveImagesOfStartUpsFollowing;
-(void) saveStartUpsFollowingDetailsToDB;

-(void) saveImagesOfStartUpsPortfolio;
-(void) saveStartUpsPortfolioDetailsToDB;

// to load the request
-(void)sendRequestForLoad;

//Load more startUps
-(IBAction)moreButtonAction:(id)sender;

@end
