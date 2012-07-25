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

//Container that holds all views
@property (strong, nonatomic) ContainerViewController *containerViewController;
//Collection on Kinvey that contains Login details of user
@property (nonatomic, retain) KCSCollection *loginCollection;
//Collection on Kinvey that contains Logout details of user
@property (nonatomic, retain) KCSCollection *logoutCollection;



-(void)loginToAngelList;

@end
