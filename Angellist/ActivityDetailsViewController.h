//
//  ActivityDetailsViewController.h
//  TableProj
//
//  Created by Ram Charan on 8/24/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KinveyKit/KinveyKit.h>

@interface ActivityDetailsViewController : UIViewController <UITableViewDataSource, KCSPersistableDelegate>
{
    IBOutlet UITableView *table;
}

-(void) navigateToWebDetails;

@end
