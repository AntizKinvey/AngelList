//
//  UserProfileViewController.h
//  Angellist
//
//  Created by Ram Charan on 23/07/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
#import "ViewController.h"

@interface UserProfileViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, UIAlertViewDelegate>
{
    IBOutlet UITableView *tableViewUser;
    DBManager *_dbmanager;
    UIButton *_logoutButton;
    UIButton *buttonSearch;
   
}



@end
