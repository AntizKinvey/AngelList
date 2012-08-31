//
//  StartUpDetailsViewController.h
//  TableProj
//
//  Created by Ram Charan on 8/27/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KinveyKit/KinveyKit.h>

@interface StartUpDetailsViewController : UIViewController <UITableViewDataSource, KCSPersistableDelegate>
{
    UIButton *followButton;
    UIButton *unfollowButton;
    UIButton *moreButton;
    
    IBOutlet UITableView *table;
}
@end
