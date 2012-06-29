//
//  AppDelegate.h
//  Angellist
//
//  Created by Ram Charan on 5/25/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
#import <KinveyKit/KinveyKit.h>

@class ViewController,ContainerViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, KCSPersistableDelegate, KCSCollectionDelegate, KCSEntityDelegate>
{
    DBManager *_dbmanager;
    KCSCollection *loginCollection;
    KCSCollection *logoutCollection;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@property (strong, nonatomic) ContainerViewController *containerViewController;

@property (nonatomic, retain) KCSCollection *loginCollection;

@property (nonatomic, retain) KCSCollection *logoutCollection;

@end
