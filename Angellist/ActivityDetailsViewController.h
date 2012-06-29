//
//  ActivityDetailsViewController.h
//  Angellist
//
//  Created by Ram Charan on 6/4/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KinveyKit/KinveyKit.h>

@interface ActivityDetailsViewController : UIViewController <KCSPersistableDelegate>
{
    IBOutlet UITableView *table;
    UIButton *followButton;
    UIButton *unfollowButton;
    UIButton *moreButton;
}

@end
