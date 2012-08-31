//
//  AppDelegate.m
//  TableProj
//
//  Created by Ram Charan on 8/21/12.
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

int _totalNoOfRowsInUserTable = 0;//No. of rows in User table 

BOOL _kinveyPingSuccess = FALSE;//Ping to Kinvey flag
NSString *_globalSessionId;//Contains unique session Id
NSString *_kinveyUserId;//Id of user of current device assigned by Kinvey 


- (void)dealloc
{
    [_window release];
    [_viewController release];
    [_containerViewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    _dbmanager = [DBManager new];
    [_dbmanager openDB];
    
    [_dbmanager createTableUser:@"User" withField1:@"UID" withField2:@"username" withField3:@"angelUserId" withField4:@"access_token" withField5:@"email" withField6:@"image" withField7:@"follows"];
    
    [_dbmanager createTableActivity:@"Activity" withField1:@"Id" withField2:@"feedId" withField3:@"feedItemType" withField4:@"feedDescription" withField5:@"actorName" withField6:@"actorImagePath" withField7:@"actorLink" withField8:@"actorTagline" withField9:@"targetName" withField10:@"targetImagePath" withField11:@"targetLink" withField12:@"targetTagline" withField13:@"actorImageUrl" withField14:@"targetImageUrl"];
    
    
    [_dbmanager createTableTrendingStartUps:@"Trending" withField1:@"Id" withField2:@"trendingId" withField3:@"trendingName" withField4:@"trendingLink" withField5:@"trendingImageUrl" withField6:@"trendingProdDesc" withField7:@"trendingHighConcept" withField8:@"trendingFollowCount" withField9:@"trendingLocations" withField10:@"trendingMarkets" withField11:@"trendingImagePath"];
    
    [_dbmanager createTableFollowingStartUps:@"Following" withField1:@"Id" withField2:@"followingId" withField3:@"followingName" withField4:@"followingLink" withField5:@"followingImageUrl" withField6:@"followingProdDesc" withField7:@"followingHighConcept" withField8:@"followingFollowCount" withField9:@"followingLocations" withField10:@"followingMarkets" withField11:@"followingImagePath"];
    
    
    [_dbmanager createTablePortfolioStartUps:@"Portfolio" withField1:@"Id" withField2:@"portfolioId" withField3:@"portfolioName" withField4:@"portfolioLink" withField5:@"portfolioImageUrl" withField6:@"portfolioProdDesc" withField7:@"portfolioHighConcept" withField8:@"portfolioFollowCount" withField9:@"portfolioLocations" withField10:@"portfolioMarkets" withField11:@"portfolioImagePath"];
    
    //Create table Inbox
    [_dbmanager createTableInboxDetails:@"Inbox" withField1:@"threadId" withField2:@"total" withField3:@"viewed"];
    
    [self showLoginScreen];
    //    [self.window makeKeyAndVisible];
    
    return YES;
}

-(void) showLoginScreen
{
    _totalNoOfRowsInUserTable = [_dbmanager retrieveNoOfRowsOfUser];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    if(_totalNoOfRowsInUserTable == 0)
    {
        self.viewController = [[[ViewController alloc] initWithNibName:@"ViewController_iPhone" bundle:nil] autorelease];
        self.window.rootViewController = self.viewController;
        [self.window makeKeyAndVisible];
    }
    else
    {
        self.containerViewController = [[[ContainerViewController alloc] initWithNibName:@"ContainerViewController_iPhone" bundle:nil] autorelease];
        self.window.rootViewController = self.containerViewController;
        [self.window makeKeyAndVisible];
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
        NSLog(@"\n\nNo Internet Connection in Resign active");
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
        NSLog(@"\n\nNo Internet Connection in become Active");
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
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
    {
        NSLog(@"\n\nNo Internet Connection in operationDidFailWithError");
    }
    else
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
}

//Collection Delegate Methods
- (void)collection:(KCSCollection *)collection didCompleteWithResult:(NSArray *)result{
    
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
    {
        NSLog(@"\n\nNo Internet Connection in didCompleteWithResult");
    }
    else
    {
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
}

- (void)collection:(KCSCollection *)collection didFailWithError:(NSError *)error{
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
    {
        NSLog(@"\n\nNo Internet Connection in didFailWithError");
    }
    else
    {
        NSLog(@"\n%@",[error localizedDescription]);
        NSLog(@"\n%@",[error localizedFailureReason]);
    }
    
}

//Entity Delegate Methods
// This is called when the load completes successfully
- (void)entity:(id<KCSPersistable>)entity fetchDidCompleteWithResult:(NSUserDefaults *)result
{
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
    {
        NSLog(@"\n\nNo Internet Connection in fetchDidCompleteWithResult");
    }
    else
    {
        _kinveyUserId = [NSString stringWithString:[result objectForKey:@"username"]];
        if(_kinveyPingSuccess)
        {
            [_loginCollection fetchAllWithDelegate:self];
        }
    }
}

// Right now just pop-up an alert about the error we got back from Kinvey during
// the load attempt. Normally you would want to implement more code here
// This is called when a load fails
- (void)entity:(id<KCSPersistable>)entity fetchDidFailWithError:(NSError *)error
{
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
    {
        NSLog(@"\n\nNo Internet Connection in fetchDidFailWithError");
    }
    else
    {
        NSLog(@"\n%@",[error localizedDescription]);
        NSLog(@"\n%@",[error localizedFailureReason]);
        [[[KCSClient sharedClient] currentUser] loadWithDelegate:self];
    }
}

@end
