//
//  AppDelegate.m
//  Angellist
//
//  Created by Ram Charan on 5/25/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"
#import "ContainerViewController.h"


@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize containerViewController = _containerViewController;

int _totalNoOfRowsInUserTable = 0;

- (void)dealloc
{
    [_dbmanager closeDB];
    [_dbmanager release];
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];

    _dbmanager = [[DBManager alloc] init];
    
    [_dbmanager openDB];
    [_dbmanager createTableActivity:@"Activity" withField1:@"activityId" withField2:@"feedDescription" withField3:@"feedImageUrl" withField4:@"actorType" withField5:@"actorId" withField6:@"actorName" withField7:@"actorUrl" withField8:@"actorTagline" withField9:@"feedImagePath"];
    
    [_dbmanager createTableStartUps:@"StartUps" withField1:@"Id" withField2:@"startUpId" withField3:@"startUpName" withField4:@"startUpAngelUrl" withField5:@"startUpLogoUrl" withField6:@"startUpProdDesc" withField7:@"startUpHighConcept" withField8:@"startUpFollowerCount" withField9:@"startUpLocations" withField10:@"startUpMarkets" withField11:@"startUpImagePath"];
    
    _totalNoOfRowsInUserTable = [_dbmanager retrieveUserFromDB];
    
    if(_totalNoOfRowsInUserTable == 0)
    {
        [_dbmanager createTableUser:@"User" withField1:@"UID" withField2:@"username" withField3:@"angelUserId" withField4:@"access_token"];
        
        // Override point for customization after application launch.
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            self.viewController = [[[ViewController alloc] initWithNibName:@"ViewController_iPhone" bundle:nil] autorelease];
        } else {
            self.viewController = [[[ViewController alloc] initWithNibName:@"ViewController_iPad" bundle:nil] autorelease];
        }
        self.window.rootViewController = self.viewController;
    }
    else
    {
        // Override point for customization after application launch.
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            self.containerViewController = [[[ContainerViewController alloc] initWithNibName:@"ContainerViewController_iPhone" bundle:nil] autorelease];
        } else {
            self.containerViewController = [[[ContainerViewController alloc] initWithNibName:@"ContainerViewController_iPad" bundle:nil] autorelease];
        }
        self.window.rootViewController = self.containerViewController;
    }
    
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"\n\nAPPLICATION ENTERED FOREGROUND");
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"\n\nAPPLICATION BECAME ACTIVE");
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
