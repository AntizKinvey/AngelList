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
     DBManager *_dbmanager;
}

-(void) getDetailsOfFollowing;
-(void) getDetailsOfPortfolio;
-(void) getDetailsOfAll;

-(void)startLoadingImagesConcurrently;
-(void) saveImagesOfStartUps;
-(void) saveStartUpsDetailsToDB;

@end
