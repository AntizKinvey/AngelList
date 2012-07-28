//
//  ActivityDetailsViewController.h
//  Angellist
//
//  Created by Ram Charan on 6/4/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KinveyKit/KinveyKit.h>

@interface ActivityDetailsViewController : UIViewController <KCSPersistableDelegate,UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *table;
    // follow button
    UIButton *followButton;
    
    // unfollow button
    UIButton *unfollowButton;
    
    // more button
    UIButton *moreButton;
}

@end
