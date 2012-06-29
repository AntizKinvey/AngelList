//
//  StartUpDetailsViewController.m
//  Angellist
//
//  Created by Ram Charan on 6/4/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import "StartUpDetailsViewController.h"
#import "AsyncImageView.h"
#import "StartUpWebDetailsController.h"
#import "Reachability.h"
#import <QuartzCore/QuartzCore.h>
#import "KCSUserActivity.h"

@implementation StartUpDetailsViewController

extern NSMutableArray *displayStartUpIdsArray;
extern NSMutableArray *displayStartUpNameArray;
extern NSMutableArray *displayStartUpAngelUrlArray;
extern NSMutableArray *displayStartUpLogoUrlArray;
extern NSMutableArray *displayStartUpProductDescArray;
extern NSMutableArray *displayStartUpHighConceptArray;
extern NSMutableArray *displayStartUpFollowerCountArray;
extern NSMutableArray *displayStartUpLocationArray;
extern NSMutableArray *displayStartUpMarketArray;
extern NSMutableArray *displayStartUpLogoImageInDirectory;

extern int _rowNumberInStartUps;
extern BOOL _filterFollow;
extern BOOL _filterPortfolio;
extern NSString *_currAccessToken;
extern NSString *_globalSessionId;

extern NSMutableArray *userFollowingIds;

NSMutableArray *displayInCells;

KCSCollection *_detailsCollection;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"StartUp";
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
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) 
    {
        if(indexPath.row == 0)
        {
            UIImageView *cellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 100, 100)];
            cellImageView.image = [displayInCells objectAtIndex:0];
            cellImageView.layer.cornerRadius = 3.5f;
            cellImageView.layer.masksToBounds = YES;
            [cell.contentView addSubview:cellImageView];
            [cellImageView release];
            
            UILabel *startUpNamelabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 125, 300, 30)];
            startUpNamelabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
            startUpNamelabel.lineBreakMode = UILineBreakModeWordWrap;
            startUpNamelabel.backgroundColor = [UIColor clearColor];
            startUpNamelabel.text = [displayInCells objectAtIndex:1];
            startUpNamelabel.textColor = [UIColor colorWithRed:63.0/255.0 green:103.0/255.0 blue:160.0/255.0 alpha:1.0f];
            [cell.contentView addSubview:startUpNamelabel];
            [startUpNamelabel release];
            
            NSString *text1 = [displayInCells objectAtIndex:2];
            CGSize constraint1 = CGSizeMake(270, 20000.0f);
            CGSize size1 = [text1 sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:14] constrainedToSize:constraint1 lineBreakMode:UILineBreakModeWordWrap];
            
            UILabel *startUpDesclabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 160, 270, size1.height)];
            startUpDesclabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
            int numLines = (int)(startUpDesclabel.frame.size.height/startUpDesclabel.font.leading);
            startUpDesclabel.numberOfLines = numLines;
            startUpDesclabel.backgroundColor = [UIColor clearColor];
            startUpDesclabel.lineBreakMode = UILineBreakModeWordWrap;
            startUpDesclabel.text = text1;
            [cell.contentView addSubview:startUpDesclabel];
            [startUpDesclabel release];
            
            
            UILabel *startUpLocationlabel = [[UILabel alloc] initWithFrame:CGRectMake(20, startUpDesclabel.frame.size.height+180, 270, 30)];
            startUpLocationlabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
            startUpLocationlabel.textColor = [UIColor colorWithRed:77.0/255.0 green:77.0/255.0 blue:76.0/255.0 alpha:1.0f];
            
            startUpLocationlabel.numberOfLines = 0;
            startUpLocationlabel.backgroundColor = [UIColor clearColor];
            startUpLocationlabel.lineBreakMode = UILineBreakModeWordWrap;
            NSString *strLoc = [displayInCells objectAtIndex:3];
            NSString *displayLoc = [NSString stringWithFormat:@"Locations - %@",strLoc];
            displayLoc = [[displayLoc componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\n"]] componentsJoinedByString:@" "];
            startUpLocationlabel.text = displayLoc;
            [cell.contentView addSubview:startUpLocationlabel];
            [startUpLocationlabel release];
            
            // startups market label  
            UILabel *startUpMarketlabel = [[UILabel alloc] initWithFrame:CGRectMake(20, startUpDesclabel.frame.size.height+210, 270, 30)];
            startUpMarketlabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
            startUpMarketlabel.textColor = [UIColor colorWithRed:77.0/255.0 green:77.0/255.0 blue:76.0/255.0 alpha:1.0f];
            startUpMarketlabel.numberOfLines = 0;
            startUpMarketlabel.backgroundColor = [UIColor clearColor];
            startUpMarketlabel.lineBreakMode = UILineBreakModeWordWrap;
            NSString *str = [displayInCells objectAtIndex:4];
            NSString *displayMarkets = [NSString stringWithFormat:@"Markets - %@",str];
            displayMarkets = [[displayMarkets componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\n"]] componentsJoinedByString:@" "];
            startUpMarketlabel.text = displayMarkets;
            [cell.contentView addSubview:startUpMarketlabel];
            [startUpMarketlabel release];
            
            UILabel *startUpFollowerslabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 20, 270, 30)];
            startUpFollowerslabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
            startUpFollowerslabel.textColor = [UIColor colorWithRed:77.0/255.0 green:77.0/255.0 blue:76.0/255.0 alpha:1.0f];
            startUpFollowerslabel.backgroundColor = [UIColor clearColor];
            startUpFollowerslabel.lineBreakMode = UILineBreakModeWordWrap;
            startUpFollowerslabel.text = [NSString stringWithFormat:@"%@ follows",[displayInCells objectAtIndex:5]];
            [cell.contentView addSubview:startUpFollowerslabel];
            [startUpFollowerslabel release];
            
            if([userFollowingIds containsObject:[displayStartUpIdsArray objectAtIndex:_rowNumberInStartUps]])
            {
                unfollowButton.hidden = NO;
                followButton.hidden = YES;
                
                unfollowButton.frame = CGRectMake(170, 260+size1.height, 52, 36);
                [cell.contentView addSubview:unfollowButton];
            }
            else
            {
                followButton.hidden = NO;
                unfollowButton.hidden = YES;
                
                followButton.frame = CGRectMake(170, 260+size1.height, 52, 36);
                [cell.contentView addSubview:followButton];
            }
            
            moreButton.frame = CGRectMake(230, 260+size1.height, 52, 36);
            [[cell contentView] addSubview:moreButton];
        }
    }
    else
    {
        //For IPad
    }
    
    return cell; 
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *text = [displayInCells objectAtIndex:2];
    
    CGSize constraint = CGSizeMake(270, 20000.0f);
    
    CGSize size = [text sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:14] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    return size.height + 315;
    
}


//---set the number of rows in the table view---
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{ 
    return 1;
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
    UIImage* image = [UIImage imageNamed:@"back.png"];
    CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
    UIButton* backButton = [[UIButton alloc] initWithFrame:frame];
    [backButton setBackgroundImage:image forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlStateHighlighted];
    
    UIBarButtonItem* backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    [backButtonItem release];
    [backButton release];
    
    //Check for the availability of Internet
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
    {
        NSLog(@"\n\nNo Internet Connection");
    }
    else
    {
        _detailsCollection = [[[KCSClient sharedClient]
                               collectionFromString:@"UserActivity"
                               withClass:[KCSUserActivity class]] retain];
        
        
        KCSUserActivity *userActivity = [[KCSUserActivity alloc] init];
        userActivity.sessionId = _globalSessionId;
        userActivity.urlLinkVisited = [NSString stringWithFormat:@"%@",[displayStartUpAngelUrlArray objectAtIndex:_rowNumberInStartUps]];
        [userActivity saveToCollection:_detailsCollection withDelegate:self];
        [userActivity release];
    }
    
    
    followButton = [[UIButton alloc] init];
    [followButton setBackgroundImage:[UIImage imageNamed:@"follow.png"] forState:UIControlStateNormal];
    [followButton addTarget:self action:@selector(followStartUp) forControlEvents:UIControlStateHighlighted];
    followButton.hidden = YES;
    
    unfollowButton = [[UIButton alloc] init];
    [unfollowButton setBackgroundImage:[UIImage imageNamed:@"unfollow.png"] forState:UIControlStateNormal];
    [unfollowButton addTarget:self action:@selector(unfollowStartUp) forControlEvents:UIControlStateHighlighted];
    unfollowButton.hidden = YES;
    
    moreButton = [[UIButton alloc] init];
    [moreButton setBackgroundImage:[UIImage imageNamed:@"more.png"] forState:UIControlStateNormal];
    [moreButton addTarget:self action:@selector(startUpDetails) forControlEvents:UIControlStateHighlighted];
    
    
    
    displayInCells = [[NSMutableArray alloc] init];
    
    [displayInCells addObject:[UIImage imageWithContentsOfFile:[displayStartUpLogoImageInDirectory objectAtIndex:_rowNumberInStartUps]]];
    [displayInCells addObject:[displayStartUpNameArray objectAtIndex:_rowNumberInStartUps]];
    [displayInCells addObject:[displayStartUpProductDescArray objectAtIndex:_rowNumberInStartUps]];
    
    [displayInCells addObject:[displayStartUpLocationArray objectAtIndex:_rowNumberInStartUps]];
    
    [displayInCells addObject:[displayStartUpMarketArray objectAtIndex:_rowNumberInStartUps]];
    [displayInCells addObject:[displayStartUpFollowerCountArray objectAtIndex:_rowNumberInStartUps]];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void) backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)startUpDetails
{
    //Check for the availability of Internet
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
    {
        UIAlertView *myAlert = [[[UIAlertView alloc] initWithTitle:@"No Internet Connection" message:@"Please turn on wi-fi." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease];
        [myAlert show];
    }
    else
    {
        StartUpWebDetailsController *webDetailsController;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) 
        {
            webDetailsController = [[[StartUpWebDetailsController alloc] initWithNibName:@"StartUpWebDetailsController_iPhone" bundle:nil] autorelease]; 
        }
        else
        {
            webDetailsController = [[[StartUpWebDetailsController alloc] initWithNibName:@"StartUpWebDetailsController_iPad" bundle:nil] autorelease]; 
        }
        
        [self.navigationController pushViewController:webDetailsController animated:YES];
    }
}

-(void)followStartUp
{
    //Check for the availability of Internet
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
    {
        UIAlertView *myAlert = [[[UIAlertView alloc] initWithTitle:@"No Internet Connection" message:@"Please turn on wi-fi." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease];
        [myAlert show];
    }
    else
    {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.angel.co/1/follows?id=%@&type=startup&access_token=%@",[displayStartUpIdsArray objectAtIndex:_rowNumberInStartUps],_currAccessToken]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod: @"POST"];
        
        [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        [userFollowingIds addObject:[displayStartUpIdsArray objectAtIndex:_rowNumberInStartUps]];
        followButton.hidden = YES;
        unfollowButton.hidden = NO;
        [table reloadData];
    }
}

-(void)unfollowStartUp
{
    //Check for the availability of Internet
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
    {
        UIAlertView *myAlert = [[[UIAlertView alloc] initWithTitle:@"No Internet Connection" message:@"Please turn on wi-fi." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease];
        [myAlert show];
    }
    else
    {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.angel.co/1/follows?id=%@&type=startup&access_token=%@",[displayStartUpIdsArray objectAtIndex:_rowNumberInStartUps],_currAccessToken]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod: @"DELETE"];
        
        [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        [userFollowingIds removeObject:[displayStartUpIdsArray objectAtIndex:_rowNumberInStartUps]];
        followButton.hidden = NO;
        unfollowButton.hidden = YES;
        [table reloadData];
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    [displayInCells retain];
    [super viewWillAppear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) dealloc
{
    [displayInCells release];
    [followButton release];
    [unfollowButton release];
    [moreButton release];
    [super dealloc];
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
    NSLog(@"\n\n%@",[result description]);
}

// Right now just pop-up an alert about the error we got back from Kinvey during
// the save attempt. Normally you would want to implement more code here
// This is called when a save fails
- (void)entity:(id)entity operationDidFailWithError:(NSError *)error
{
    NSLog(@"\n%@",[error localizedDescription]);
    NSLog(@"\n%@",[error localizedFailureReason]);
    [entity saveToCollection:_detailsCollection withDelegate:self];
}

@end
