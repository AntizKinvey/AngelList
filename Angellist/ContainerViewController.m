//
//  WallViewController.m
//  SampleRest
//
//  Created by Ram Charan on 5/10/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import "ContainerViewController.h"
#import "ActivityViewController.h"
#import "StartUpViewController.h"
#import "InboxViewController.h"
#import "CustomTabBar.h"

@implementation ContainerViewController

@synthesize tabBarController = _tabBarController;

extern NSString *_angelUserId;//Angel user Id
extern NSString *_angelUserName;// Angel User name
extern NSString *access_token;// Access token of user

extern NSString *_angelUserIdFromDB;
extern NSString *_angelUserNameFromDB;
extern NSString *access_tokenFromDB;

extern int _totalNoOfRowsInUserTable;

NSString *_currUserId;
NSString *_currAccessToken;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    _dbmanager = [[[DBManager alloc] init] autorelease];
    [_dbmanager openDB];
    if(_totalNoOfRowsInUserTable == 0)
    {
        _totalNoOfRowsInUserTable++;
        //Insert Angel userId,username and access token of user into User table
        [_dbmanager insertRecordIntoUserTable:@"User" withField1:@"UID" field1Value:[NSString stringWithFormat:@"%d",_totalNoOfRowsInUserTable] andField2:@"username" field2Value:[NSString stringWithFormat:@"%@",_angelUserName] andField3:@"angelUserId" field3Value:[NSString stringWithFormat:@"%@",_angelUserId] andField4:@"access_token" field4Value:[NSString stringWithFormat:@"%@",access_token]];
    }
    
    [_dbmanager retrieveUserDetails];
    self.tabBarController.delegate=self;
    //Assign angel User Id to global variable
    _currUserId = [[NSString alloc] initWithFormat:@"%@",_angelUserIdFromDB];
    //Assign angel User access token to global variable
    _currAccessToken = [[NSString alloc] initWithFormat:@"%@",access_tokenFromDB];

    //Create tab bar elements and navigation controllers
    UIViewController *viewController2, *viewController3, *viewController4;
    UINavigationController *navigationcontroller2,*navigationcontroller3,*navigationcontroller4;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) 
    {
        viewController2 = [[[ActivityViewController alloc] initWithNibName:@"ActivityViewController_iPhone" bundle:nil] autorelease];
        navigationcontroller2 = [[[UINavigationController alloc] initWithRootViewController:viewController2] autorelease];
        
        viewController3 = [[[StartUpViewController alloc] initWithNibName:@"StartUpViewController_iPhone" bundle:nil] autorelease];
        navigationcontroller3 = [[[UINavigationController alloc] initWithRootViewController:viewController3] autorelease];
        
        viewController4 = [[[InboxViewController alloc] initWithNibName:@"InboxViewController_iPhone" bundle:nil] autorelease];
        navigationcontroller4 = [[[UINavigationController alloc] initWithRootViewController:viewController4] autorelease];
    }
    else
    {
        viewController2 = [[[ActivityViewController alloc] initWithNibName:@"ActivityViewController_iPad" bundle:nil] autorelease];
        navigationcontroller2 = [[[UINavigationController alloc] initWithRootViewController:viewController2] autorelease];
        
        viewController3 = [[[StartUpViewController alloc] initWithNibName:@"StartUpViewController_iPad" bundle:nil] autorelease];
        navigationcontroller3 = [[[UINavigationController alloc] initWithRootViewController:viewController3] autorelease];
        
        viewController4 = [[[InboxViewController alloc] initWithNibName:@"InboxViewController_iPad" bundle:nil] autorelease];
        navigationcontroller4 = [[[UINavigationController alloc] initWithRootViewController:viewController4] autorelease];
    }
    
    //Use custom tab bar
    self.tabBarController = [[[CustomTabBar alloc] init] autorelease];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:navigationcontroller2, navigationcontroller3, navigationcontroller4, nil];
    [self.view addSubview:self.tabBarController.view];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void) dealloc
{
//    [_currUserId release];
    
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if((interfaceOrientation == UIInterfaceOrientationPortrait) || (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

@end
