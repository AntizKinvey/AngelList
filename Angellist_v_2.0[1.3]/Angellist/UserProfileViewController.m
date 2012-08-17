//
//  UserProfileViewController.m
//  Angellist
//
//  Created by Ram Charan on 23/07/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import "UserProfileViewController.h"
#import "LoginViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <Foundation/NSHTTPCookie.h>
#import "AppDelegate.h"
#import "Reachability.h"

@implementation UserProfileViewController

extern BOOL _loggedIn;
extern NSString *_angelUserNameFromDB;

////////////////////////////////////////////
extern NSMutableArray *_msgbody;
extern NSMutableArray *_senderName; // sender name
extern NSMutableArray *_recepientName; // recepient name
extern NSMutableArray *_imageOfRecepient; // image of recepient 
extern NSMutableArray *_imageOfSender; // image of sender
extern NSMutableArray *_userids; // user ids
extern NSMutableArray *_sender; // sender ids
extern NSMutableArray *_recepient; // recepient ids
extern NSMutableArray *_read; // viewed status
extern NSMutableArray *_threadId; // thread id
extern NSMutableArray *_msgbody; // message body
extern NSMutableArray *_placeHolder; // place holder images
extern NSMutableArray *_time; // time got from response
extern NSMutableArray *_displayTime; // display time
extern NSMutableArray *_totalMsgCount; // total message count


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//---insert individual row into the table view---
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *CellIdentifier = @"Cell";
    
    //---try to get a reusable cell--- 
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    for(UIView *view in cell.contentView.subviews){
        if ([view isKindOfClass:[UIView class]]) {
            [view removeFromSuperview];
        }
    }
    
    //---create new cell if no reusable cell is available---
    if (cell == nil) 
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // load the image of the user from db
    UIImage *image = [UIImage imageWithContentsOfFile:_dbmanager._angelUserImageFromDB];
    UIImageView *cellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(80, 20, 150, 150)];
    cellImageView.image = image;
    cellImageView.layer.cornerRadius = 3.5f;
    cellImageView.layer.masksToBounds = YES;
    [cell.contentView addSubview:cellImageView];
    [cellImageView release];
    
    
    // load the name of the user
    UILabel *cellNameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5, 180, 290, 20)] autorelease];//CGRectMake(90, 180, 290, 20)] autorelease];
    
    cellNameLabel.lineBreakMode = UILineBreakModeWordWrap;
    cellNameLabel.text = _dbmanager._angelUserNameFromDB;
    cellNameLabel.backgroundColor = [UIColor clearColor];
    cellNameLabel.textColor = [UIColor colorWithRed:63.0/255.0 green:103.0/255.0 blue:160.0/255.0 alpha:1.0f];
    cellNameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
    cellNameLabel.textAlignment = UITextAlignmentCenter;
    [cell.contentView addSubview:cellNameLabel];
    
    // load the email id of the user
    UILabel *cellHighConceptLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5, 200, 290, 20)] autorelease];//26
    cellHighConceptLabel.lineBreakMode = UILineBreakModeWordWrap;
    cellHighConceptLabel.numberOfLines = 2;
    cellHighConceptLabel.text = _dbmanager._angelUserEmailFromDB;
    cellHighConceptLabel.backgroundColor = [UIColor clearColor];
    cellHighConceptLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    cellHighConceptLabel.textAlignment = UITextAlignmentCenter;
    [cell.contentView addSubview:cellHighConceptLabel];
    
    [cell.contentView addSubview:_logoutButton];
    
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
    {
        _logoutButton.enabled = NO;
    }
    else {
        _logoutButton.enabled = YES;
    }
    
    return cell; 
}

    
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 360;    
}


//---set the number of rows in the table view---
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{ 
    
    return 1;
}

-(void)viewWillAppear:(BOOL)animated
{
    UIImage *backgroundImage = [UIImage imageNamed:@"navigationbarNf.png"];
    [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _dbmanager = [[DBManager alloc] init];
    [_dbmanager openDB];
    
    _logoutButton = [[UIButton alloc] init];
    _logoutButton.frame = CGRectMake(110, 260, 80, 50);
  
    [_logoutButton setImage:[UIImage imageNamed:@"logout.png"] forState:UIControlStateNormal];
    [_logoutButton addTarget:self action:@selector(logoutFromApp) forControlEvents:UIControlStateHighlighted];
   
    // for search options
    
     buttonSearch = [[UIButton alloc] init];
     buttonSearch.frame = CGRectMake(0, 0, 49, 42);
    [buttonSearch setImage:[UIImage imageNamed:@"search.png"] forState:UIControlStateNormal];
    [buttonSearch setImage:[UIImage imageNamed:@"searcha.png"] forState:UIControlStateSelected];
    [buttonSearch addTarget:self action:@selector(goToSearch) forControlEvents:UIControlStateHighlighted];
    buttonSearch.enabled = YES;
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:buttonSearch]autorelease];
    
    
    
    UIImage *backgroundImage = [UIImage imageNamed:@"navigationbarNf.png"];
    [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    
     [_dbmanager retrieveUserDetails];
    self.navigationItem.title = _dbmanager._angelUserNameFromDB;
    
}


-(void)logoutFromApp
{    // alert before the logout
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Are you sure to logout?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Yes",@"No", nil];
    [alert show];
    [alert release];
    
    
    
}

-(void)goToSearch
{
    _searchViewController = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
    [_searchViewController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    //[self presentModalViewController:_searchViewController animated:YES];
    [self.navigationController pushViewController:_searchViewController animated:YES];
    
}



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        // to delete all the cookies of the webview
        NSHTTPCookie *aCookie;
        for (aCookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:aCookie];
        }
        
        _loggedIn = FALSE;
        
        [_dbmanager deleteUserFromDB]; // delete user details from the the db
        [_dbmanager deleteFromInbox];
        

        
        // navigate to the login screen
        AppDelegate *mainDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [mainDelegate loginToAngelList];
    }
    
   
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
