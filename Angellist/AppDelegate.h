//
//  AppDelegate.h
//  Angellist
//
//  Created by Ram Charan on 5/25/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

@class ViewController,ContainerViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    DBManager *_dbmanager;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@property (strong, nonatomic) ContainerViewController *containerViewController;


@end
