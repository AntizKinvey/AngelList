//
//  StartUpDetailsViewController.m
//  TableProj
//
//  Created by Ram Charan on 8/27/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import "StartUpDetailsViewController.h"
#import "Reachability.h"

#import <QuartzCore/QuartzCore.h>
#import "StartUpWebDetailsController.h"
#import "KCSUserActivity.h"

@implementation StartUpDetailsViewController

extern NSMutableArray *startUpImageDisplayArray;
extern NSMutableArray *startUpNameArray;
extern NSMutableArray *startUpLinkArray;
extern NSMutableArray *startUpProdDescArray;
extern NSMutableArray *startUpFollowCountArray;
extern NSMutableArray *startUpLocationsArray;
extern NSMutableArray *startUpMarketsArray;

extern int _rowNumberInStartUps;

//for follow and unfollow
extern NSMutableArray *startUpIdArray;
extern NSMutableArray *userFollowingIds;
extern NSMutableArray *userDetailsArray;
/////////////////////////
NSMutableArray *displayDetailsOfStartUpsArray;


extern NSString *_globalSessionId;
KCSCollection *_detailsCollection;


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
    
    UIImageView *cellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 100, 100)];
    cellImageView.image = [displayDetailsOfStartUpsArray objectAtIndex:0];
    cellImageView.layer.cornerRadius = 3.5f;
    cellImageView.layer.masksToBounds = YES;
    [cell.contentView addSubview:cellImageView];
    [cellImageView release];
    
    //startup name to be displayed
    UILabel *startUpNamelabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 125, 300, 30)];
    startUpNamelabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
    startUpNamelabel.lineBreakMode = UILineBreakModeWordWrap;
    startUpNamelabel.backgroundColor = [UIColor clearColor];
    startUpNamelabel.text = [displayDetailsOfStartUpsArray objectAtIndex:1];
    startUpNamelabel.textColor = [UIColor colorWithRed:63.0/255.0 green:103.0/255.0 blue:160.0/255.0 alpha:1.0f];
    [cell.contentView addSubview:startUpNamelabel];
    [startUpNamelabel release];
    
    //startUp follower count to be displayed
    UILabel *startUpFollowerslabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 20, 270, 30)];
    startUpFollowerslabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
    startUpFollowerslabel.textColor = [UIColor colorWithRed:77.0/255.0 green:77.0/255.0 blue:76.0/255.0 alpha:1.0f];
    startUpFollowerslabel.backgroundColor = [UIColor clearColor];
    startUpFollowerslabel.lineBreakMode = UILineBreakModeWordWrap;
    startUpFollowerslabel.text = [NSString stringWithFormat:@"%@ follows",[displayDetailsOfStartUpsArray objectAtIndex:2]];
    [cell.contentView addSubview:startUpFollowerslabel];
    [startUpFollowerslabel release];
    
    
    //startup locations to be displayed
    UILabel *startUpLocationlabel = [[UILabel alloc] initWithFrame:CGRectMake(20, startUpNamelabel.frame.size.height+120, 270, 30)];
    startUpLocationlabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
    startUpLocationlabel.textColor = [UIColor colorWithRed:77.0/255.0 green:77.0/255.0 blue:76.0/255.0 alpha:1.0f];
    
    startUpLocationlabel.numberOfLines = 0;
    startUpLocationlabel.backgroundColor = [UIColor clearColor];
    startUpLocationlabel.lineBreakMode = UILineBreakModeWordWrap;
    startUpLocationlabel.text = [NSString stringWithFormat:@"Locations - %@",[displayDetailsOfStartUpsArray objectAtIndex:3]];
    [cell.contentView addSubview:startUpLocationlabel];
    [startUpLocationlabel release];
    
    // startup market label  
    UILabel *startUpMarketlabel = [[UILabel alloc] initWithFrame:CGRectMake(20, startUpNamelabel.frame.size.height+160, 270, 30)];
    startUpMarketlabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
    startUpMarketlabel.textColor = [UIColor colorWithRed:77.0/255.0 green:77.0/255.0 blue:76.0/255.0 alpha:1.0f];
    startUpMarketlabel.numberOfLines = 0;
    startUpMarketlabel.backgroundColor = [UIColor clearColor];
    startUpMarketlabel.lineBreakMode = UILineBreakModeWordWrap;
    
    startUpMarketlabel.text = [NSString stringWithFormat:@"Markets - %@",[displayDetailsOfStartUpsArray objectAtIndex:4]];
    [cell.contentView addSubview:startUpMarketlabel];
    [startUpMarketlabel release];
    
    NSString *text = [displayDetailsOfStartUpsArray objectAtIndex:5];
    CGSize constraint = CGSizeMake(270, 20000.0f);
    CGSize size = [text sizeWithFont:[UIFont fontWithName:@"Helvetica-Light" size:14] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    
    //startup description to be displayed
    UILabel *startUpDesclabel = [[UILabel alloc] initWithFrame:CGRectMake(20, startUpMarketlabel.frame.size.height+200, 270, size.height)];
    startUpDesclabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    int numLines = (int)(startUpDesclabel.frame.size.height/startUpDesclabel.font.leading);
    startUpDesclabel.numberOfLines = numLines;
    startUpDesclabel.backgroundColor = [UIColor clearColor];
    startUpDesclabel.lineBreakMode = UILineBreakModeWordWrap;
    startUpDesclabel.text = text;
    [cell.contentView addSubview:startUpDesclabel];
    [startUpDesclabel release];
    
    
    if([userFollowingIds containsObject:[startUpIdArray objectAtIndex:_rowNumberInStartUps]])
    {
        unfollowButton.hidden = NO;
        followButton.hidden = YES;
        
        unfollowButton.frame = CGRectMake(170, size.height + 259, 52, 36);
        [cell.contentView addSubview:unfollowButton];
    }
    else
    {
        followButton.hidden = NO;
        unfollowButton.hidden = YES;
        
        followButton.frame = CGRectMake(170, size.height + 259, 52, 36);
        [cell.contentView addSubview:followButton];
    }
    
    moreButton.frame = CGRectMake(230, size.height + 259, 52, 36);
    [[cell contentView] addSubview:moreButton];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell; 
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{ 
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *text = [displayDetailsOfStartUpsArray objectAtIndex:5];
    
    CGSize constraint = CGSizeMake(270, 20000.0f);
    
    CGSize size = [text sizeWithFont:[UIFont fontWithName:@"Helvetica-Light" size:14] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    return size.height + 315;
    
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
    UIImage *backgroundImage = [UIImage imageNamed:@"navigationbarNf.png"];
    [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    
    UIImage* image = [UIImage imageNamed:@"back.png"];
    CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
    UIButton* backButton = [[UIButton alloc] initWithFrame:frame];
    [backButton setBackgroundImage:image forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlStateHighlighted];
    
    UIBarButtonItem* backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    [backButtonItem release];
    [backButton release];
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@",[startUpNameArray objectAtIndex:_rowNumberInStartUps]];
    
    //Follow button
    followButton = [[UIButton alloc] init];
    [followButton setBackgroundImage:[UIImage imageNamed:@"follow.png"] forState:UIControlStateNormal];
    [followButton addTarget:self action:@selector(followStartUp) forControlEvents:UIControlStateHighlighted];
    followButton.hidden = YES;
//    [followButton release];
    
    //Unfollow button
    unfollowButton = [[UIButton alloc] init];
    [unfollowButton setBackgroundImage:[UIImage imageNamed:@"unfollow.png"] forState:UIControlStateNormal];
    [unfollowButton addTarget:self action:@selector(unfollowStartUp) forControlEvents:UIControlStateHighlighted];
    unfollowButton.hidden = YES;
//    [unfollowButton release];
    
    //More button
    moreButton = [[UIButton alloc] init];
    [moreButton setBackgroundImage:[UIImage imageNamed:@"more.png"] forState:UIControlStateNormal];
    [moreButton addTarget:self action:@selector(startUpWebDetails) forControlEvents:UIControlStateHighlighted];
//    [moreButton release];
    
    displayDetailsOfStartUpsArray = [NSMutableArray new];
    [displayDetailsOfStartUpsArray addObject:[startUpImageDisplayArray objectAtIndex:_rowNumberInStartUps]];
    [displayDetailsOfStartUpsArray addObject:[startUpNameArray objectAtIndex:_rowNumberInStartUps]];
    [displayDetailsOfStartUpsArray addObject:[startUpFollowCountArray objectAtIndex:_rowNumberInStartUps]];
    [displayDetailsOfStartUpsArray addObject:[startUpLocationsArray objectAtIndex:_rowNumberInStartUps]];
    [displayDetailsOfStartUpsArray addObject:[startUpMarketsArray objectAtIndex:_rowNumberInStartUps]];
    [displayDetailsOfStartUpsArray addObject:[startUpProdDescArray objectAtIndex:_rowNumberInStartUps]];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //Check for the availability of Internet
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
    {
        NSLog(@"\n\n No Internet Connection");
    }
    else
    {
        //Kinvey UserActivity collection
        _detailsCollection = [[[KCSClient sharedClient]
                               collectionFromString:@"UserActivity"
                               withClass:[KCSUserActivity class]] retain];
        
        //Set details of user activity
        KCSUserActivity *userActivity = [[KCSUserActivity alloc] init];
        userActivity.sessionId = _globalSessionId;
        userActivity.urlLinkVisited = [NSString stringWithFormat:@"%@",[startUpLinkArray objectAtIndex:_rowNumberInStartUps]];
        [userActivity saveToCollection:_detailsCollection withDelegate:self];
        [userActivity release];
    }
}

-(void) backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//Method to follow startUp
-(void)followStartUp
{
    //Check for the availability of Internet
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
    {
        UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Internet appears offline" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [myAlert show];
        [myAlert release];
    }
    else
    {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.angel.co/1/follows?id=%@&type=startup&access_token=%@",[startUpIdArray objectAtIndex:_rowNumberInStartUps],[userDetailsArray objectAtIndex:2]]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod: @"POST"];
        
        [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        [userFollowingIds addObject:[startUpIdArray objectAtIndex:_rowNumberInStartUps]];
        followButton.hidden = YES;
        unfollowButton.hidden = NO;
        [table reloadData];
    }
}

//Method to unfollow startUp
-(void)unfollowStartUp
{
    //Check for the availability of Internet
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
    {
        UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Internet appears offline" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [myAlert show];
        [myAlert release];
    }
    else
    {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.angel.co/1/follows?id=%@&type=startup&access_token=%@",[startUpIdArray objectAtIndex:_rowNumberInStartUps],[userDetailsArray objectAtIndex:2]]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod: @"DELETE"];
        
        [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        [userFollowingIds removeObject:[startUpIdArray objectAtIndex:_rowNumberInStartUps]];
        followButton.hidden = NO;
        unfollowButton.hidden = YES;
        [table reloadData];
    }
}

//Method invoked when selecting more button
-(void)startUpWebDetails
{
    //Check for the availability of Internet
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
    {
        UIAlertView *myAlert = [[[UIAlertView alloc] initWithTitle:nil message:@"Internet appears offline" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease];
        [myAlert show];
    }
    else
    {
        StartUpWebDetailsController *webDetailsController = [[[StartUpWebDetailsController alloc] initWithNibName:@"StartUpWebDetailsController_iPhone" bundle:nil] autorelease]; 
        
        [self.navigationController pushViewController:webDetailsController animated:YES];
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

/************************************************************************************************************/
/*                                          Kinvey Delegate Methods                                         */
/************************************************************************************************************/

// Persistable Delegate Methods
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
    //Check for the availability of Internet
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
    {
        NSLog(@"\n\n No Internet Connection");
    }
    else
    {
        NSLog(@"\n%@",[error localizedDescription]);
        NSLog(@"\n%@",[error localizedFailureReason]);
        [entity saveToCollection:_detailsCollection withDelegate:self];
    }
}

@end
