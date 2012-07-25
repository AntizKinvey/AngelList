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
#import "KCSLogin.h"
#import "KCSLogout.h"
#import "Reachability.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize containerViewController = _containerViewController;

@synthesize loginCollection=_loginCollection;
@synthesize logoutCollection=_logoutCollection;

extern BOOL _loggedOut;
BOOL _kinveyPingSuccess = FALSE;//Ping to Kinvey flag
NSString *_globalSessionId;//Contains unique session Id
NSString *_kinveyUserId;//Id of user of current device assigned by Kinvey 

int _totalNoOfRowsInUserTable = 0;//No. of rows in User table 

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

    [self loginToAngelList];
    [self.window makeKeyAndVisible];
    
    return YES;
}

-(void)loginToAngelList
{
    //Create an object to access methods of database
    _dbmanager = [[DBManager alloc] init];
    //Create database if not created
    [_dbmanager openDB];
    
    //Create tables to do database operations
    //Create table Activity to store details of feeds
    [_dbmanager createTableActivity:@"Activity" withField1:@"activityId" withField2:@"feedDescription" withField3:@"feedImageUrl" withField4:@"actorType" withField5:@"actorId" withField6:@"actorName" withField7:@"actorUrl" withField8:@"actorTagline" withField9:@"feedImagePath"];
    
    //Create table StartUps that contains all startUps 
    [_dbmanager createTableStartUps:@"StartUps" withField1:@"Id" withField2:@"startUpId" withField3:@"startUpName" withField4:@"startUpAngelUrl" withField5:@"startUpLogoUrl" withField6:@"startUpProdDesc" withField7:@"startUpHighConcept" withField8:@"startUpFollowerCount" withField9:@"startUpLocations" withField10:@"startUpMarkets" withField11:@"startUpImagePath"];
    
    //Create table Following to store details of startups of user's following
    [_dbmanager createTableStartUpsFollowing:@"Following" withField1:@"Id" withField2:@"startUpId" withField3:@"startUpName" withField4:@"startUpAngelUrl" withField5:@"startUpLogoUrl" withField6:@"startUpProdDesc" withField7:@"startUpHighConcept" withField8:@"startUpFollowerCount" withField9:@"startUpLocations" withField10:@"startUpMarkets" withField11:@"startUpImagePath"];
    
    //Create table Portfolio to store details of startups of user's portfolio
    [_dbmanager createTableStartUpsPortfolio:@"Portfolio" withField1:@"Id" withField2:@"startUpId" withField3:@"startUpName" withField4:@"startUpAngelUrl" withField5:@"startUpLogoUrl" withField6:@"startUpProdDesc" withField7:@"startUpHighConcept" withField8:@"startUpFollowerCount" withField9:@"startUpLocations" withField10:@"startUpMarkets" withField11:@"startUpImagePath"];
    
    //Create table Portfolio to store details of trending startups 
    [_dbmanager createTableStartUpsPortfolio:@"Trending" withField1:@"Id" withField2:@"startUpId" withField3:@"startUpName" withField4:@"startUpAngelUrl" withField5:@"startUpLogoUrl" withField6:@"startUpProdDesc" withField7:@"startUpHighConcept" withField8:@"startUpFollowerCount" withField9:@"startUpLocations" withField10:@"startUpMarkets" withField11:@"startUpImagePath"];
    
    //Create table Inbox
    [_dbmanager createTableInboxDetails:@"Inbox" withField1:@"threadId" withField2:@"total" withField3:@"viewed"];
    
    //Get the number of rows in User table
    _totalNoOfRowsInUserTable = [_dbmanager retrieveUserFromDB];
    
    if(_totalNoOfRowsInUserTable == 0)
    {
        //Create table User
        [_dbmanager createTableUser:@"User" withField1:@"UID" withField2:@"username" withField3:@"angelUserId" withField4:@"access_token" withField5:@"email" withField6:@"image" withField7:@"follows"];
        
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
    
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    
    //Check for the availability of Internet
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
    {
        NSLog(@"\n\nNo Internet Connection");
    }
    else
    {
        if(_kinveyPingSuccess)
        {
            NSDateFormatter *date_formater=[[NSDateFormatter alloc] init];
            [date_formater setDateFormat:@"dd/MM/YYYY HH:MM"];
            NSDate *currDate = [NSDate date];
            NSString *todayDate = [date_formater stringFromDate:currDate];
            [date_formater release];
            //Set logout details of user
            KCSLogout *logout = [[KCSLogout alloc] init];
            logout.logouttime = todayDate;
            logout.sessionId = _globalSessionId;
            [_globalSessionId release];
            
            [logout saveToCollection:_logoutCollection withDelegate:self];
            
            [logout release];
        }
    }
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
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    //Check for the availability of Internet
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
    {
        NSLog(@"\n\nNo Internet Connection");
    }
    else
    {
        //Ping to Kinvey using app key and app secret 
        [[KCSClient sharedClient] initializeKinveyServiceForAppKey:@"kid1945"
                                                     withAppSecret:@"8f0b10ceba3c4bfa8f4ea03e42093231"
                                                      usingOptions:nil];
        
        
        [KCSPing pingKinveyWithBlock:^(KCSPingResult *result) {
            // This block gets executed when the ping completes
            
            //If result is successful set Kinvey ping flag to true
            if (result.pingWasSuccessful){
                _kinveyPingSuccess = TRUE;
                
                
                _loginCollection = [[[KCSClient sharedClient]
                                     collectionFromString:@"Login"
                                     withClass:[KCSLogin class]] retain];
                
                _logoutCollection = [[[KCSClient sharedClient]
                                      collectionFromString:@"Logout"
                                      withClass:[KCSLogout class]] retain];
                
                [[[KCSClient sharedClient] currentUser] loadWithDelegate:self]; 
                NSLog(@"\n\n%@",[result description]);
            } 
            else 
            {
                NSLog(@"\n\n%@",[result description]);
                _kinveyPingSuccess = FALSE;
            }
        }];
        
    }
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}


/************************************************************************************************************/
/*                                          Kinvey Delegate Methods                                         */
/************************************************************************************************************/

//Persistable Delegate Methods
// Right now just pop-up an alert about what we got back from Kinvey during
// the save. Normally you would want to implement more code here
// This is called when the save completes successfully
- (void)entity:(id)entity operationDidCompleteWithResult:(NSObject *)result
{
    NSLog(@"%@",[result description]);
}

// Right now just pop-up an alert about the error we got back from Kinvey during
// the save attempt. Normally you would want to implement more code here
// This is called when a save fails
- (void)entity:(id)entity operationDidFailWithError:(NSError *)error
{
    NSLog(@"\n%@",[error localizedDescription]);
    NSLog(@"\n%@",[error localizedFailureReason]);
    
    NSString *classname = NSStringFromClass([entity class]);
    if([classname isEqualToString:@"KCSLogin"])
    {
        [entity saveToCollection:_loginCollection withDelegate:self];
    }
    if([classname isEqualToString:@"KCSLogout"])
    {
        [entity saveToCollection:_logoutCollection withDelegate:self];
    }
}

//Collection Delegate Methods
- (void)collection:(KCSCollection *)collection didCompleteWithResult:(NSArray *)result{
    
    NSDateFormatter *date_formater=[[NSDateFormatter alloc] init];
    [date_formater setDateFormat:@"dd/MM/YYYY HH:MM"];
    NSDate *currDate = [NSDate date];
    NSString *todayDate = [date_formater stringFromDate:currDate];
    [date_formater release];
    
    _globalSessionId = [[NSString alloc] initWithFormat:@"%d",[result count]+1];
    //Set login details of user
    KCSLogin *loginDetails = [[KCSLogin alloc] init];
    
    loginDetails.userId = _kinveyUserId;
    
    loginDetails.logintime = todayDate;
    
    loginDetails.sessionId = [NSString stringWithFormat:@"%d",[result count]+1];
    
    [loginDetails saveToCollection:_loginCollection withDelegate:self];
    
    [loginDetails release];
    
    result = nil;
    [result release];
}

- (void)collection:(KCSCollection *)collection didFailWithError:(NSError *)error{
    NSLog(@"\n%@",[error localizedDescription]);
    NSLog(@"\n%@",[error localizedFailureReason]);
}

//Entity Delegate Methods
// This is called when the load completes successfully
- (void)entity:(id<KCSPersistable>)entity fetchDidCompleteWithResult:(NSUserDefaults *)result
{
    _kinveyUserId = [NSString stringWithString:[result objectForKey:@"username"]];
    if(_kinveyPingSuccess)
    {
        [_loginCollection fetchAllWithDelegate:self];
    }
}

// Right now just pop-up an alert about the error we got back from Kinvey during
// the load attempt. Normally you would want to implement more code here
// This is called when a load fails
- (void)entity:(id<KCSPersistable>)entity fetchDidFailWithError:(NSError *)error
{
    NSLog(@"\n%@",[error localizedDescription]);
    NSLog(@"\n%@",[error localizedFailureReason]);
    [[[KCSClient sharedClient] currentUser] loadWithDelegate:self];
}

@end
