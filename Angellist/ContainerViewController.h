//
//  ContainerViewController.h
//  Angellist
//
//  Created by Ram Charan on 5/25/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

@interface ContainerViewController : UIViewController <UITabBarControllerDelegate>
{
    DBManager *_dbmanager;
}

@property (strong, nonatomic) UITabBarController *tabBarController;

@end
