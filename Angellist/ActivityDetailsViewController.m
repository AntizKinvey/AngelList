//
//  ActivityDetailsViewController.m
//  Angellist
//
//  Created by Ram Charan on 6/4/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import "ActivityDetailsViewController.h"
#import "ActivityWebDetailsController.h"
#import "Reachability.h"
#import <QuartzCore/QuartzCore.h>
#import "KCSUserActivity.h"

@implementation ActivityDetailsViewController

// arrays from activity screen
extern NSMutableArray *actorTypeArray; 
extern NSMutableArray *actorIdArray;
extern NSMutableArray *actorNameArray;
extern NSMutableArray *actorUrlArray;
extern NSMutableArray *actorTaglineArray;
extern NSMutableArray *feedImageArray;

extern NSMutableArray *targetTypeArray; 
extern NSMutableArray *targetIdArray;
extern NSMutableArray *targetNameArray;
extern NSMutableArray *targetUrlArray;
extern NSMutableArray *targetTaglineArray;
extern NSMutableArray *targetImageArray;

extern NSMutableArray *feedImagesArrayFromDirectory;

extern NSMutableArray *userFollowingIds;

extern NSMutableArray *feedType;

extern int _rowNumberInActivity;
extern NSString *_currAccessToken;
extern NSString *_globalSessionId;
UIButton* backButton;

NSString *feedTypeString;

int _rowIndexPathNumber;

NSMutableArray *displayFeedsInCells;

NSMutableArray *displayTargetInCells;

KCSCollection *_detailsCollection;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
       // self.title = @"Feed";
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
            // image view to display image of user/startup
            UIImageView *cellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 100, 100)];
            
            //Check for the availability of Internet
            Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
            
            NetworkStatus internetStatus = [r currentReachabilityStatus];
            if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
            {
                cellImageView.image = [UIImage imageWithContentsOfFile:[displayFeedsInCells objectAtIndex:0]];
            }
            else 
            {
                cellImageView.image = [displayFeedsInCells objectAtIndex:0];
            }
            
            cellImageView.layer.cornerRadius = 3.5f;
            cellImageView.layer.masksToBounds = YES;
            [cell.contentView addSubview:cellImageView];
            [cellImageView release];
            
            // label to display name of the user/startup
            UILabel *actorNamelabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 125, 300, 30)];
            actorNamelabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
            actorNamelabel.lineBreakMode = UILineBreakModeWordWrap;
            actorNamelabel.backgroundColor = [UIColor clearColor];
            actorNamelabel.text = [displayFeedsInCells objectAtIndex:1];
            actorNamelabel.textColor = [UIColor colorWithRed:63.0/255.0 green:103.0/255.0 blue:160.0/255.0 alpha:1.0f];
            [cell.contentView addSubview:actorNamelabel];
            [actorNamelabel release];
            
            // label to display description
             NSString *text = [displayFeedsInCells objectAtIndex:2];
             CGSize constraint = CGSizeMake(270, 20000.0f);
            CGSize size = [text sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:14] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
            
            
            UILabel *actorDesclabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 160, 270, size.height)];
            actorDesclabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
            actorDesclabel.numberOfLines = 10;
            actorDesclabel.backgroundColor = [UIColor clearColor];
            actorDesclabel.lineBreakMode = UILineBreakModeWordWrap;
            actorDesclabel.text = text;
            [cell.contentView addSubview:actorDesclabel];
            [actorDesclabel release];
            
                
        }
        
        if (indexPath.row == 1) 
        {
            
            UILabel *actorNamelabel = [[UILabel alloc] initWithFrame:CGRectMake(00, 05, 320, 30)];
            actorNamelabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
            actorNamelabel.lineBreakMode = UILineBreakModeWordWrap;
            actorNamelabel.backgroundColor = [UIColor clearColor];
            actorNamelabel.textAlignment = UITextAlignmentCenter;
            actorNamelabel.text = feedTypeString;
            actorNamelabel.textColor = [UIColor colorWithRed:63.0/255.0 green:103.0/255.0 blue:160.0/255.0 alpha:1.0f];
            [cell.contentView addSubview:actorNamelabel];
            [actorNamelabel release];        
        }
    
    
        if (indexPath.row == 2 && ![[displayTargetInCells objectAtIndex:1] isEqual:(NSString*)[NSNull null]]) 
        {
        
            // image view to display image of user/startup
            NSLog(@"\n\n%@",[displayTargetInCells objectAtIndex:0]);
            UIImageView *cellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 100, 100)];
            cellImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[displayTargetInCells objectAtIndex:0]]]];
            cellImageView.layer.cornerRadius = 3.5f;
            cellImageView.layer.masksToBounds = YES;
            [cell.contentView addSubview:cellImageView];
            [cellImageView release];
            
            // label to display name of the user/startup
            UILabel *actorNamelabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 125, 300, 30)];
            actorNamelabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
            actorNamelabel.lineBreakMode = UILineBreakModeWordWrap;
            actorNamelabel.backgroundColor = [UIColor clearColor];
            actorNamelabel.text = [NSString stringWithFormat:@"%@",[displayTargetInCells objectAtIndex:1]];
            actorNamelabel.textColor = [UIColor colorWithRed:63.0/255.0 green:103.0/255.0 blue:160.0/255.0 alpha:1.0f];
            [cell.contentView addSubview:actorNamelabel];
            [actorNamelabel release];
            
            // label to display description
            NSString *text = [displayTargetInCells objectAtIndex:2];
            CGSize constraint = CGSizeMake(270, 20000.0f);
            CGSize size = [[NSString stringWithFormat:@"%@",text] sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:14] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
            
            
            UILabel *actorDesclabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 160, 270, size.height)];
            actorDesclabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
            actorDesclabel.numberOfLines = 10;
            actorDesclabel.backgroundColor = [UIColor clearColor];
            actorDesclabel.lineBreakMode = UILineBreakModeWordWrap;
            actorDesclabel.text = [NSString stringWithFormat:@"%@",text];
            [cell.contentView addSubview:actorDesclabel];
            [actorDesclabel release];
            
        }
    }
    else
    {
        //For IPad
    }
    
    return cell; 
}

- (void)viewWillAppear:(BOOL)animated
{
    
    NSIndexPath *selection = [table indexPathForSelectedRow];
    if (selection)
    {
        
        [table deselectRowAtIndexPath:selection animated:YES];
        
    }
    [displayFeedsInCells retain];
    //[displayTargetInCells retain];
    [super viewWillAppear:animated];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int heightOfRow;
    if (indexPath.row == 1) {
        heightOfRow = 50;
    }
    else {
        NSString *text = [displayFeedsInCells objectAtIndex:2];
        CGSize constraint = CGSizeMake(270, 20000.0f);
        CGSize size = [text sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:14] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        heightOfRow = size.height + 200;
    }
   

    return heightOfRow; //160    
}


//---set the number of rows in the table view---
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{ 
    if (![[displayTargetInCells objectAtIndex:1] isEqual:(NSString*)[NSNull null]]) {
        return 3;
    }
    else {
        return 1;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.row !=1) {
        
        _rowIndexPathNumber = indexPath.row;
        [self actorDetails];
    }
    
    
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
//    NSLog(@"\n\n%@",[targetTaglineArray objectAtIndex:_rowNumberInActivity]);
//    NSLog(@"\n\n%@",[targetNameArray objectAtIndex:_rowNumberInActivity]);
//    NSLog(@"\n\n%@",[targetImageArray objectAtIndex:_rowNumberInActivity]);
    NSLog(@"&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
    NSLog(@"\n\n%@",[feedImagesArrayFromDirectory objectAtIndex:_rowNumberInActivity]);
    // back button 
    UIImage* image = [UIImage imageNamed:@"back.png"];
    CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
    backButton = [[UIButton alloc] initWithFrame:frame];
    [backButton setBackgroundImage:image forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlStateHighlighted];
    
    UIImage *backgroundImage = [UIImage imageNamed:@"navigationbarNf.png"];
    [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    
    UIBarButtonItem* backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    [backButtonItem release];
    [backButton release];
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@",[actorNameArray objectAtIndex:_rowNumberInActivity]];
    //Check for the availability of Internet
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
    {
        
        NSLog(@"\n\n No Internet Connection");
        
    }
    else
    {
        _detailsCollection = [[[KCSClient sharedClient]
                               collectionFromString:@"UserActivity"
                               withClass:[KCSUserActivity class]] retain];
        
        KCSUserActivity *userActivity = [[KCSUserActivity alloc] init];
        userActivity.sessionId = _globalSessionId;
        userActivity.urlLinkVisited = [NSString stringWithFormat:@"%@",[actorUrlArray objectAtIndex:_rowNumberInActivity]];
        [userActivity saveToCollection:_detailsCollection withDelegate:self];
        [userActivity release];
    }
   
    
    // follow button
    followButton = [[UIButton alloc] init];
    [followButton setBackgroundImage:[UIImage imageNamed:@"follow.png"] forState:UIControlStateNormal];
    [followButton addTarget:self action:@selector(followActor) forControlEvents:UIControlStateHighlighted];
    followButton.hidden = YES;
    
    // unfollow button
    unfollowButton = [[UIButton alloc] init];
    [unfollowButton setBackgroundImage:[UIImage imageNamed:@"unfollow.png"] forState:UIControlStateNormal];
    [unfollowButton addTarget:self action:@selector(unfollowActor) forControlEvents:UIControlStateHighlighted];
    unfollowButton.hidden = YES;

    // more button
    moreButton = [[UIButton alloc] init];
    [moreButton setBackgroundImage:[UIImage imageNamed:@"more.png"] forState:UIControlStateNormal];
    [moreButton addTarget:self action:@selector(actorDetails) forControlEvents:UIControlStateHighlighted];
    
    displayFeedsInCells = [[NSMutableArray alloc] init];
    [displayFeedsInCells addObject:[feedImagesArrayFromDirectory objectAtIndex:_rowNumberInActivity]];
    
//    [displayFeedsInCells addObject:@"/Users/iAntiz/Library/Application Support/iPhone Simulator/5.1/Applications/64486B2D-3F01-4D1A-B48D-84987AD9096E/Documents/feeduser1.png"];
     
    [displayFeedsInCells addObject:[actorNameArray objectAtIndex:_rowNumberInActivity]];
    [displayFeedsInCells addObject:[actorTaglineArray objectAtIndex:_rowNumberInActivity]];
    NSLog(@"************************************** Step 1");
    displayTargetInCells = [[NSMutableArray alloc] init];
    
    [displayTargetInCells addObject:[targetImageArray objectAtIndex:_rowNumberInActivity]];
    NSLog(@"************************************** Step 2");
    [displayTargetInCells addObject:[targetNameArray objectAtIndex:_rowNumberInActivity]];
    NSLog(@"************************************** Step 3");
    [displayTargetInCells addObject:[targetTaglineArray objectAtIndex:_rowNumberInActivity]];
    NSLog(@"************************************** Step 4");
    
    NSLog(@"\n\n%@",[feedType objectAtIndex:_rowNumberInActivity]);
    feedTypeString = [feedType objectAtIndex:_rowNumberInActivity];
    NSLog(@"************************************** Step 5");

    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void) backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)actorDetails
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
        ActivityWebDetailsController *webDetailsController;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) 
        {
            webDetailsController = [[[ActivityWebDetailsController alloc] initWithNibName:@"ActivityWebDetailsController_iPhone" bundle:nil] autorelease]; 
        }
        else
        {
            webDetailsController = [[[ActivityWebDetailsController alloc] initWithNibName:@"ActivityWebDetailsController_iPad" bundle:nil] autorelease]; 
        }
        
        [self.navigationController pushViewController:webDetailsController animated:YES];
    }
    
}

// follow user / startup
-(void)followActor
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
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.angel.co/1/follows?id=%@&type=%@&access_token=%@",[actorIdArray objectAtIndex:_rowNumberInActivity],[actorTypeArray objectAtIndex:_rowNumberInActivity],_currAccessToken]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod: @"POST"];
        
        [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        [userFollowingIds addObject:[actorIdArray objectAtIndex:_rowNumberInActivity]];
        followButton.hidden = YES;
        unfollowButton.hidden = NO;
        [table reloadData];
    }
    
}


// unfollow user/startup
-(void)unfollowActor
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
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.angel.co/1/follows?id=%@&type=%@&access_token=%@",[actorIdArray objectAtIndex:_rowNumberInActivity],[actorTypeArray objectAtIndex:_rowNumberInActivity],_currAccessToken]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod: @"DELETE"];
        
        [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        [userFollowingIds removeObject:[actorIdArray objectAtIndex:_rowNumberInActivity]];
        followButton.hidden = NO;
        unfollowButton.hidden = YES;
        [table reloadData];
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

-(void) dealloc
{
    [displayFeedsInCells release];
    //[displayTargetInCells release];
    [followButton release];
    [unfollowButton release];
    [moreButton release];
    [super dealloc];
}

//  ****************************************************************************************************/
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
    NSLog(@"\n%@",[error localizedDescription]);
    NSLog(@"\n%@",[error localizedFailureReason]);
    [entity saveToCollection:_detailsCollection withDelegate:self];
}

@end
