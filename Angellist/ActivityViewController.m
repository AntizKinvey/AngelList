//
//  FirstViewController.m
//  SampleTabbar
//
//  Created by Ram Charan on 5/16/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.


#import <QuartzCore/QuartzCore.h>
#import "ActivityViewController.h"
#import "ActivityDetailsViewController.h"
#import "Reachability.h"
#import "StartUpViewController.h"
#import "StartUpViewController.h"

@implementation ActivityViewController

@synthesize filterView;

// arrays to fetch the request
NSMutableArray *feedDescArray;
NSMutableArray *feedDescDisplayArray;
NSMutableArray *feedImageArray;
NSMutableArray *feedIdArray;

NSMutableArray *feedImagesArrayFromDirectory;
NSMutableArray *completeFeedImagesArrayFromDirectory;

NSMutableArray *actorTypeArray;
NSMutableArray *actorIdArray;
NSMutableArray *actorNameArray;
NSMutableArray *actorUrlArray;
NSMutableArray *actorTaglineArray;

NSMutableArray *targetTypeArray;
NSMutableArray *targetIdArray;
NSMutableArray *targetNameArray;
NSMutableArray *targetUrlArray;
NSMutableArray *targetTaglineArray;
NSMutableArray *targetImageArray;

// arrays to display the feeds
NSMutableArray *completeActorTypeArray;
NSMutableArray *completeActorIdArray;
NSMutableArray *completeActorNameArray;
NSMutableArray *completeActorUrlArray;
NSMutableArray *completeActorTaglineArray;


// arrays to display the feeds
NSMutableArray *completeTargetTypeArray;
NSMutableArray *completeTargetIdArray;
NSMutableArray *completeTargetNameArray;
NSMutableArray *completeTargetUrlArray;
NSMutableArray *completeTargetTaglineArray;
NSMutableArray *completeTargetImageArray;

NSMutableArray *completeFeedDescDisplayArray;
NSMutableArray *completeFeedImageArray;

NSMutableArray *completeFeedType;
NSMutableArray *feedType;
NSMutableArray *filterFeedType;

// arrays for filter details
NSMutableArray *filterDescArray;
NSMutableArray *filterImageArray;

NSMutableArray *filterFeedImagesArrayFromDirectory;

NSMutableArray *filterTypeArray;
NSMutableArray *filterIdArray;
NSMutableArray *filterNameArray;
NSMutableArray *filterUrlArray;
NSMutableArray *filterTaglineArray;

NSMutableArray *filterTypeArrayTarget;
NSMutableArray *filterIdArrayTarget;
NSMutableArray *filterNameArrayTarget;
NSMutableArray *filterUrlArrayTarget;
NSMutableArray *filterTaglineArrayTarget;
NSMutableArray *filterImageArrayTarget;


NSMutableArray *directoryImagesArray;
// array of filter names
NSArray *_filterNames;
int _rowNumberInActivity = 0;
BOOL _showFilterMenu = FALSE;
BOOL _imagesSaved = FALSE;

BOOL imageTransform = FALSE;
BOOL finishedLoading = FALSE;
int _tagID = 0;

// array of ids of the people/startup user is following
NSMutableArray *userFollowingIds;

extern BOOL _transitFromActivity;
extern BOOL _transitFromStartUps;

extern NSString *_currUserId;
int i=0;
int countDownForView = 0;
float alphaValue = 1.0;
NSTimer *timer;
UIView *notReachable;
UIButton *filtersContainer;

int _yPos = 5;
int _xPos = 245;
int _btnRot = 5;
int _pageNo = 1;
int _arrayCountForOlderFeeds = 0;
// for filters selected
BOOL _filterFollowed = FALSE;
BOOL _filterInvested = FALSE;
BOOL _filterUpdated = FALSE;
BOOL _filterIntroduced = FALSE;
BOOL _startupLoad = FALSE;

BOOL _allImagesDowloaded=FALSE;
BOOL _olderFeeds = FALSE , _newFeeds = FALSE, _viewPresentPtoR = FALSE;

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
    
    loadingView.hidden = YES;
    filtersContainer.enabled = YES;

    
    
    //---create new cell if no reusable cell is available---
    if (cell == nil) 
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

    
    //---set the text to display for the cell---
    NSString *cellValue = [feedDescDisplayArray objectAtIndex:indexPath.row]; 
    
    // detect for an iphone view 
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) 
    {
               
        Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
        
        NetworkStatus internetStatus = [r currentReachabilityStatus];
        if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
        {
            // label to display the feed
            UILabel *cellTextLabel = [[[UILabel alloc] initWithFrame:CGRectMake(70, 0, 210, 75)] autorelease];
            cellTextLabel.lineBreakMode = UILineBreakModeWordWrap;
            cellTextLabel.numberOfLines = 50;
            cellTextLabel.backgroundColor = [UIColor clearColor];
            cellTextLabel.text = cellValue;
            cellTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
            [cell.contentView addSubview:cellTextLabel];
            
             UIImage *image = [UIImage imageWithContentsOfFile:[feedImagesArrayFromDirectory objectAtIndex:indexPath.row]];
            NSLog(@"\n \n IMAGE PATH = %@ \n \n ", [feedImagesArrayFromDirectory objectAtIndex:indexPath.row]);
            
            UIImageView *cellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(7, 12, 50, 50)];
            cellImageView.image = image;
            cellImageView.layer.cornerRadius = 3.5f;
            cellImageView.layer.masksToBounds = YES;
            [cell.contentView addSubview:cellImageView];
            [cellImageView release];
            
            // label to confor to the cell height
            NSString *strContent1 = [feedDescDisplayArray objectAtIndex:[indexPath row]];
            CGSize constrainedSize = CGSizeMake(210, 20000);
            CGSize exactSize = [strContent1 sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:15] constrainedToSize:constrainedSize lineBreakMode:UILineBreakModeWordWrap];
            
            if (!cellTextLabel)
                cellTextLabel = (UILabel*)[cell viewWithTag:1];
            [cellTextLabel setText:strContent1];
            [cellTextLabel setFrame:CGRectMake(70, 9, 210, MAX(exactSize.height, 20.0f))];
            
        }
        
        else {
            
            // label to display the feed
            UILabel *cellTextLabel = [[[UILabel alloc] initWithFrame:CGRectMake(70, 0, 210, 75)] autorelease];
            cellTextLabel.lineBreakMode = UILineBreakModeWordWrap;
            cellTextLabel.numberOfLines = 50;
            cellTextLabel.backgroundColor = [UIColor clearColor];
            cellTextLabel.text = cellValue;
            cellTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
            [cell.contentView addSubview:cellTextLabel];

            
            
            UIImage *image;
            if(_allImagesDowloaded == FALSE)
            {
                image = [feedImagesArrayFromDirectory objectAtIndex:indexPath.row];
            }
            else 
            {
                image = [UIImage imageWithContentsOfFile:[directoryImagesArray objectAtIndex:indexPath.row]];
            }
            
            UIImageView *cellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(7, 12, 50, 50)];
            cellImageView.image = image;
            cellImageView.layer.cornerRadius = 3.5f;
            cellImageView.layer.masksToBounds = YES;
            [cell.contentView addSubview:cellImageView];
            [cellImageView release];
            
            // label to confor to the cell height
            NSString *strContent1 = [feedDescDisplayArray objectAtIndex:[indexPath row]];
            CGSize constrainedSize = CGSizeMake(210, 20000);
            CGSize exactSize = [strContent1 sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:15] constrainedToSize:constrainedSize lineBreakMode:UILineBreakModeWordWrap];
            
            if (!cellTextLabel)
                cellTextLabel = (UILabel*)[cell viewWithTag:1];
            [cellTextLabel setText:strContent1];
             [cellTextLabel setFrame:CGRectMake(70, 9, 210, MAX(exactSize.height, 20.0f))];

        }
        

    }
    else
    {
        UILabel *cellTextLabel = [[[UILabel alloc] initWithFrame:CGRectMake(((768*80)/320), ((1024*7)/480), ((768*240)/320), ((1024*75)/480))] autorelease];
        cellTextLabel.lineBreakMode = UILineBreakModeWordWrap;
        cellTextLabel.numberOfLines = 50;
        cellTextLabel.text = cellValue;
        cellTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:24];
        [cell.contentView addSubview:cellTextLabel];
        
        UIImage *image = [UIImage imageWithContentsOfFile:[feedImagesArrayFromDirectory objectAtIndex:indexPath.row]];
        UIImageView *cellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(((768*7)/320), ((1024*7)/480), ((768*70)/320), ((1024*70)/480))];
        cellImageView.image = image;
        [cell.contentView addSubview:cellImageView];
        [cellImageView release];
    }
    
    return cell; 
}

// --dynamic cell height according to the text--
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *text = [feedDescDisplayArray objectAtIndex:[indexPath row]];
    
    CGSize constraint = CGSizeMake(210, 20000.0f);
    
    CGSize size = [text sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:15] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    CGFloat height = MAX(size.height, 44.0f);
    
    return height + (15 * 2);
    
}


//---set the number of rows in the table view---
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{ 
    if(([feedDescDisplayArray count] == 0) && ((_filterFollowed == TRUE) || (_filterInvested == TRUE) || (_filterUpdated == TRUE) || (_filterIntroduced == TRUE)))
    {
        UILabel *alertPopup = [[UILabel alloc] initWithFrame:CGRectMake(20, 155, 280, 30)];
        alertPopup.text = @"No Activity to display!";
        alertPopup.backgroundColor = [UIColor clearColor];
        alertPopup.textColor = [UIColor grayColor];
        alertPopup.textAlignment = UITextAlignmentCenter;
        alertPopup.tag = 404;
        [[self.view viewWithTag:404] removeFromSuperview];
        [self.view addSubview:alertPopup];
        [alertPopup release];
    }
    if([feedDescDisplayArray count] != 0)
    { 
        [[self.view viewWithTag:404] removeFromSuperview];
    }
    
    
    
    return [feedDescDisplayArray count];
}


// --navigate to activity details--
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _rowNumberInActivity = indexPath.row;
    label.hidden = YES;

    ActivityDetailsViewController *detailsViewController;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) 
    {
        detailsViewController = [[[ActivityDetailsViewController alloc] initWithNibName:@"ActivityDetailsViewController_iPhone" bundle:nil] autorelease];
    }
    else
    {
        detailsViewController = [[[ActivityDetailsViewController alloc] initWithNibName:@"ActivityDetailsViewController_iPad" bundle:nil] autorelease];
    }
    [self.navigationController pushViewController:detailsViewController animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    
    NSIndexPath *selection = [table indexPathForSelectedRow];
    if (selection)
    {
        
        [table deselectRowAtIndexPath:selection animated:YES];
        
    }
    
    [super viewWillAppear:animated];
    [self performSelector:@selector(hideLabel) withObject:nil afterDelay:0.2];
}

-(void)hideLabel
{
    UIImage *backgroundImage = [UIImage imageNamed:@"navigationbarfil.png"];
    [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    label.hidden = NO;
}



- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

// get people followed by the user
-(void) getUserFollowingDetails
{
    // Check for the availability of Internet
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
    {

        
        
    }
    else
    {
        NSURL *userFollowingUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.angel.co/1/users/%@/following/ids?type=user",_currUserId]];
        NSMutableURLRequest *requestUserFollowing = [NSMutableURLRequest requestWithURL:userFollowingUrl];
        [requestUserFollowing setHTTPMethod: @"GET"];
        
        NSData *responseUserFollowing = [NSURLConnection sendSynchronousRequest:requestUserFollowing returningResponse:nil error:nil];
        
        NSError* error;
        NSDictionary* json = [NSJSONSerialization 
                              JSONObjectWithData:responseUserFollowing //1
                              options:kNilOptions 
                              error:&error];
        NSArray* followingIds = [json objectForKey:@"ids"]; //2
        [userFollowingIds addObjectsFromArray:followingIds];
    }
}

// get startups followed by the user

-(void) getStartUpFollowingDetails
{
    //Check for the availability of Internet
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
    {
        
        
        
        
    }
    else
    {
        NSURL *startUpFollowingUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.angel.co/1/users/%@/following/ids?type=startup",_currUserId]];
        NSMutableURLRequest *requestStartUpFollowing = [NSMutableURLRequest requestWithURL:startUpFollowingUrl];
        [requestStartUpFollowing setHTTPMethod: @"GET"];
        
        NSData *responseStartUpFollowing = [NSURLConnection sendSynchronousRequest:requestStartUpFollowing returningResponse:nil error:nil];
        
        NSError* error;
        NSDictionary* json = [NSJSONSerialization 
                              JSONObjectWithData:responseStartUpFollowing //1
                              options:kNilOptions 
                              error:&error];
        NSArray* followingIds = [json objectForKey:@"ids"]; //2
        [userFollowingIds addObjectsFromArray:followingIds];
    }
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    
    filterView = [[UIView alloc] initWithFrame:CGRectMake(0, -480, 320, 480)];
    [filterView  setBackgroundColor: [UIColor blackColor]];
    [filterView setAlpha:0.4f];
    filterView.tag = 1000;
    [self.view addSubview:filterView];
        
//    StartUpViewController *start;
//    [start viewDidLoad];
    notReachable = [[UIView alloc] initWithFrame:CGRectMake(100, 140, 118, 118)];
    notReachable.alpha = 0;
    [notReachable.layer setCornerRadius:10.0f];
    notReachable.backgroundColor = [UIColor blackColor];
    [self.view addSubview:notReachable];
    
    // label to display message when offline
    UILabel *msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, 53, 106, 46)];
    msgLabel.text = @"No Internet Connection";
    msgLabel.textAlignment = UITextAlignmentCenter;
    msgLabel.numberOfLines = 2;
    msgLabel.backgroundColor = [UIColor clearColor];
    msgLabel.textColor = [UIColor whiteColor];
    msgLabel.font = [UIFont fontWithName:@"System" size:10.0];
    [notReachable addSubview:msgLabel];
    
    UIImage *notReachableImage = [UIImage imageNamed:@"closebutton.png"];
    UIImageView *notReachView = [[UIImageView alloc] initWithFrame:CGRectMake(41, 20, 37, 37)];
    notReachView.image = notReachableImage;
    [notReachable addSubview:notReachView];
    
    [msgLabel release];
    [notReachView release];
    [notReachable release];
    
    _dbmanager = [[DBManager alloc] init];
    [_dbmanager openDB];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) 
    {
        self.navigationController.navigationBar.frame = CGRectMake(0, 0, 320, 45);
    }
    else
    {
        self.navigationController.navigationBar.frame = CGRectMake(0, 0, 768, 45);
    }
    
    _filterNames = [[NSArray arrayWithObjects:@"Followed", @"Invested", @"Introduced", @"All", nil] retain];
    
    _view1 = [[UIView alloc] initWithFrame:CGRectMake(0, -250, 271, 51*4)];
    [self.view addSubview:_view1];
    
    //Add background image to navigation title bar
    UIImage *backgroundImage = [UIImage imageNamed:@"navigationbarfil.png"];
    [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    
    //self.tabBarItem.title = @"Activity";
    UINavigationBar *bar = [self.navigationController navigationBar];
    label = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 260, 20)];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"Activity";
    [bar addSubview:label];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(filterButtonSelected:)];
    [bar addGestureRecognizer:tap];
    
    buttonSearch = [[UIButton alloc] init];
    buttonSearch.frame = CGRectMake(0, 0, 40, 40);
    [buttonSearch setImage:[UIImage imageNamed:@"search.png"] forState:UIControlStateNormal];
    [buttonSearch setImage:[UIImage imageNamed:@"searcha.png"] forState:UIControlStateSelected];
    [buttonSearch addTarget:self action:@selector(goToSearch) forControlEvents:UIControlStateHighlighted];
    buttonSearch.enabled = YES;
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:buttonSearch]autorelease];

    
    feedDescArray = [[NSMutableArray alloc] init];
    feedDescDisplayArray = [[NSMutableArray alloc] init];
    feedImageArray = [[NSMutableArray alloc] init];
    feedIdArray = [[NSMutableArray alloc] init];
    
    feedImagesArrayFromDirectory = [[NSMutableArray alloc] init];
    completeFeedImagesArrayFromDirectory = [[NSMutableArray alloc] init];
    
    completeFeedDescDisplayArray = [[NSMutableArray alloc] init];
    completeFeedImageArray = [[NSMutableArray alloc] init];
    
    completeActorTypeArray = [[NSMutableArray alloc] init];
    completeActorIdArray = [[NSMutableArray alloc] init];
    completeActorNameArray = [[NSMutableArray alloc] init];
    completeActorUrlArray = [[NSMutableArray alloc] init];
    completeActorTaglineArray = [[NSMutableArray alloc] init];
    
    completeTargetTypeArray = [[NSMutableArray alloc] init];
    completeTargetIdArray = [[NSMutableArray alloc] init];
    completeTargetNameArray = [[NSMutableArray alloc] init];
    completeTargetUrlArray = [[NSMutableArray alloc] init];
    completeTargetTaglineArray = [[NSMutableArray alloc] init];
    completeTargetImageArray = [[NSMutableArray alloc] init];
    
    actorTypeArray = [[NSMutableArray alloc] init];
    actorIdArray = [[NSMutableArray alloc] init];
    actorNameArray = [[NSMutableArray alloc] init];
    actorUrlArray = [[NSMutableArray alloc] init];
    actorTaglineArray = [[NSMutableArray alloc] init];
    
    targetTypeArray = [[NSMutableArray alloc] init];
    targetIdArray = [[NSMutableArray alloc] init];
    targetNameArray = [[NSMutableArray alloc] init];
    targetUrlArray = [[NSMutableArray alloc] init];
    targetTaglineArray = [[NSMutableArray alloc] init];
    targetImageArray = [[NSMutableArray alloc] init];
    
    filterDescArray = [[NSMutableArray alloc] init];
    filterImageArray = [[NSMutableArray alloc] init];
    
    filterTypeArray = [[NSMutableArray alloc] init];
    filterIdArray = [[NSMutableArray alloc] init];
    filterNameArray = [[NSMutableArray alloc] init];
    filterUrlArray = [[NSMutableArray alloc] init];
    filterTaglineArray = [[NSMutableArray alloc] init];
    
    filterImageArrayTarget = [[NSMutableArray alloc] init];
    filterTypeArrayTarget = [[NSMutableArray alloc] init];
    filterIdArrayTarget = [[NSMutableArray alloc] init];
    filterNameArrayTarget = [[NSMutableArray alloc] init];
    filterUrlArrayTarget = [[NSMutableArray alloc] init];
    filterTaglineArrayTarget = [[NSMutableArray alloc] init];
    
    completeFeedType = [[NSMutableArray alloc] init];
    feedType = [[NSMutableArray alloc] init];
    filterFeedType = [[NSMutableArray alloc] init];
    
    filterFeedImagesArrayFromDirectory = [[NSMutableArray alloc] init];
    directoryImagesArray = [[NSMutableArray alloc] init];
    
    userFollowingIds = [[NSMutableArray alloc] init];    
    _dbmanager.feedImagesArrayFromDirectoryFromDB = [[[NSMutableArray alloc] init] autorelease];
    _dbmanager.actorTypeArrayFromDB = [[[NSMutableArray alloc] init] autorelease];
    _dbmanager.actorIdArrayFromDB = [[[NSMutableArray alloc] init] autorelease];
    _dbmanager.actorNameArrayFromDB = [[[NSMutableArray alloc] init] autorelease];
    _dbmanager.actorUrlArrayFromDB = [[[NSMutableArray alloc] init] autorelease];
    _dbmanager.actorTaglineArrayFromDB = [[[NSMutableArray alloc] init] autorelease];
    _dbmanager.feedDescDisplayArrayFromDB = [[[NSMutableArray alloc] init] autorelease];
    _dbmanager.feedImageArrayFromDB = [[[NSMutableArray alloc] init] autorelease];    
    
    [self performSelectorInBackground:@selector(getUserFollowingDetails) withObject:nil];
    [self performSelectorInBackground:@selector(getStartUpFollowingDetails) withObject:nil];
    
    [self getFeeds:1];
    [super viewDidLoad];
    
}

-(void)goToSearch
{
    label.hidden = YES;
    _searchViewController = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
    [_searchViewController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    //[self presentModalViewController:_searchViewController animated:YES];
    [self.navigationController pushViewController:_searchViewController animated:YES];
    
}


-(void)loadOldFeeds:(int)pageNo
{
    _arrayCountForOlderFeeds = [feedDescDisplayArray count];
    
    finishedLoading = FALSE;
    [table reloadData];

    // Check for the availability of Internet
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
    {
        
        NSLog(@"\n \n No Internet connection \n \n");
        
    }
    else
    {
        filtersContainer.enabled = NO;
        //Get feeds
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.angel.co/1/feed?page=%d",pageNo]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod: @"GET"];
        
        NSLog(@"\n \n \n page number = %d \n \n ", pageNo);
        
        NSError *error;                                    
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
        
             
                // NSError* error;
                 NSDictionary* json = [NSJSONSerialization 
                                       JSONObjectWithData:data //1
                                       options:kNilOptions 
                                       error:&error];
                 
                 NSArray* feeds = [json objectForKey:@"feed"]; //2
                 
                 
                 for(int i=0; i<[feeds count]; i++)
                 {
                     NSDictionary *feedDict = [feeds objectAtIndex:i];
                     NSString *description = [feedDict objectForKey:@"description"];
                     [feedDescArray addObject:description];
                     
                    
                     NSString *feedId = [feedDict objectForKey:@"id"];
                     [feedIdArray insertObject:feedId atIndex:i];
                     
                     NSString *feedTypeString = [[feedDict valueForKey:@"item"] valueForKey:@"type"];
                     [feedType addObject:feedTypeString];
                     [completeFeedType addObject:feedTypeString];
                     
                     NSLog(@"\n \n FEED TYPE = %@ count %d \n \n ", feedTypeString, i);
                     
                     NSString *actorType = [[feedDict objectForKey:@"actor"] valueForKey:@"type"];
                     if(actorType == (NSString *)[NSNull null])
                     {
                         NSString *targetActorType = [[feedDict objectForKey:@"target"] valueForKey:@"type"];
                         [actorTypeArray addObject:targetActorType];
                         [completeActorTypeArray addObject:targetActorType];
                     }
                     else
                     {
                         [actorTypeArray addObject:actorType];
                         [completeActorTypeArray addObject:actorType];
                     }
                     
                     NSString *actorId = [[feedDict objectForKey:@"actor"] valueForKey:@"id"];
                     if(actorId == (NSString *)[NSNull null])
                     {
                         NSString *targetActorId = [[feedDict objectForKey:@"target"] valueForKey:@"id"];
                         [actorIdArray addObject:targetActorId];
                         [completeActorIdArray addObject:targetActorId];
                     }
                     else
                     {
                         [actorIdArray addObject:actorId];
                         [completeActorIdArray addObject:actorId];
                     }
                     
                     NSString *feedImages = [[feedDict objectForKey:@"actor"] valueForKey:@"image"];
                     if(feedImages == (NSString *)[NSNull null])
                     {
                         NSString *targetFeedImages = [[feedDict objectForKey:@"target"] valueForKey:@"image"];
                         if (targetFeedImages == (NSString *)[NSNull null]) 
                         {
                             [feedImageArray addObject:@"nopic.png"];
                             [completeFeedImageArray addObject:@"nopic.png"];
                         } 
                         else 
                         {
                             [feedImageArray addObject:targetFeedImages];
                             [completeFeedImageArray addObject:targetFeedImages];
                         }
                     }
                     else
                     {
                         [feedImageArray addObject:feedImages];
                         [completeFeedImageArray addObject:feedImages];
                     }
                     
                     NSString *actorNames = [[feedDict objectForKey:@"actor"] valueForKey:@"name"];
                     if(actorNames == (NSString *)[NSNull null])
                     {
                         NSString *targetNames = [[feedDict objectForKey:@"target"] valueForKey:@"name"];
                         if (targetNames == (NSString *)[NSNull null]) 
                         {
                             [actorNameArray addObject:@"Name not found!"];
                             [completeActorNameArray addObject:@"Name not found!"];
                         } 
                         else 
                         {
                             [actorNameArray addObject:targetNames];
                             [completeActorNameArray addObject:targetNames];
                         }
                         
                     }
                     else
                     {
                         [actorNameArray addObject:actorNames];
                         [completeActorNameArray addObject:actorNames];
                     }
                     
                     NSString *actorUrl = [[feedDict objectForKey:@"actor"] valueForKey:@"angellist_url"];
                     [actorUrlArray addObject:actorUrl];
                     [completeActorUrlArray addObject:actorUrl];
                     
                     NSString *actorTagline = [[feedDict objectForKey:@"actor"] valueForKey:@"tagline"];
                     if(actorTagline == (NSString *)[NSNull null])
                     {
                         NSString *targetTagline = [[feedDict objectForKey:@"target"] valueForKey:@"tagline"];
                         if (targetTagline == (NSString *)[NSNull null]) 
                         {
                             [actorTaglineArray addObject:@"Information not available!"];
                             [completeActorTaglineArray addObject:@"Information not available!"];
                         } 
                         else 
                         {
                             [actorTaglineArray addObject:targetTagline];
                             [completeActorTaglineArray addObject:targetTagline];
                         }
                         
                     }
                     else
                     {
                         [actorTaglineArray addObject:actorTagline];
                         [completeActorTaglineArray addObject:actorTagline];
                     }
                 }
        for(int i=0; i<[feeds count]; i++)
        {
            NSLog(@"\n \n \n feeds count = %d \n \n \n *********", i);
            
            NSDictionary *feedDict = [feeds objectAtIndex:i];
            
            NSString *actorType = [[feedDict objectForKey:@"target"] valueForKey:@"type"];
            //                if(actorType != (NSString *)[NSNull null])
            //                {
            [targetTypeArray addObject:actorType];
            [completeTargetTypeArray addObject:actorType];
            
            // }
            
            NSString *actorId = [[feedDict objectForKey:@"target"] valueForKey:@"id"];
            //                if(actorId != (NSString *)[NSNull null])
            //                {
            [targetIdArray addObject:actorId];
            [completeTargetIdArray addObject:actorId];
            // }
            
            NSString *feedImages = [[feedDict objectForKey:@"target"] valueForKey:@"image"];
            //                if(feedImages != (NSString *)[NSNull null])
            //                {
            [targetImageArray addObject:feedImages];
            [completeTargetImageArray addObject:feedImages];
            //   }
            
            
            
            NSString *targetNames = [[feedDict objectForKey:@"target"] valueForKey:@"name"];
            //                if (targetNames == (NSString *)[NSNull null]) 
            //                {
            //                    [targetNameArray addObject:@"Name not found!"];
            //                    [completeTargetNameArray addObject:@"Name not found!"];
            //                } 
            //                else 
            //                {
            [targetNameArray addObject:targetNames];
            [completeTargetNameArray addObject:targetNames];
            // }
            
            
            NSString *actorUrl = [[feedDict objectForKey:@"target"] valueForKey:@"angellist_url"];
            //if(actorUrl != (NSString *)[NSNull null])
            //{
            [targetUrlArray addObject:actorUrl];
            [completeTargetUrlArray addObject:actorUrl];
            // }
            
            
            NSString *targetTagline = [[feedDict objectForKey:@"target"] valueForKey:@"tagline"];
            //                if (targetTagline == (NSString *)[NSNull null]) 
            //                {
            //                    [targetTaglineArray addObject:@"Information not available!"];
            //                    [completeTargetTaglineArray addObject:@"Information not available!"];
            //                } 
            //                else 
            //                {
            [targetTaglineArray addObject:targetTagline];
            [completeTargetTaglineArray addObject:targetTagline];
            // }
            
            
        }
                 
                 for(int k=_arrayCountForOlderFeeds-1; k<[completeActorTaglineArray count]; k++)
                 {
                     NSMutableString * theMutableString = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@",[completeActorTaglineArray objectAtIndex:k]]];
                     
                     [theMutableString replaceOccurrencesOfString:@"'" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
                     
                     [actorTaglineArray replaceObjectAtIndex:k withObject:theMutableString];
                     [completeActorTaglineArray replaceObjectAtIndex:k withObject:theMutableString];
                     
                     [theMutableString release];
                 }
                 
                 for(int z=_arrayCountForOlderFeeds; z<[feedDescArray count]; z++)
                 {
                      NSLog(@"\n \n \n desc. = %d \n \n ",[feedDescArray count]);
                    
                     NSString *desc = [feedDescArray objectAtIndex:z]; 
                     NSArray *str = [desc componentsSeparatedByString:@">"];
                     
                     int k=0;
                     NSString *concatStr = @"";
                     for(int j=0; j<[str count]; j++)
                     {
                         if(k%2 == 1)
                         {
                             NSString *strName1 = [str objectAtIndex:j];
                             NSArray *str1 = [strName1 componentsSeparatedByString:@"</a"];
                             concatStr = [concatStr stringByAppendingFormat:@"%@",[str1 objectAtIndex:0]];
                             k++;
                         }
                         else
                         {
                             NSString *strName2 = [str objectAtIndex:j];
                             NSArray *str2 = [strName2 componentsSeparatedByString:@"<"];
                             concatStr = [concatStr stringByAppendingFormat:@"%@",[str2 objectAtIndex:0]];
                             k++;
                         }
                     }
                     
                     NSMutableString * theMutableString = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@",concatStr]];
                     
                     [theMutableString replaceOccurrencesOfString:@"'" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
                     
                     [feedDescDisplayArray addObject:theMutableString];
                     [completeFeedDescDisplayArray addObject:theMutableString];
                     
                     [theMutableString release];
                 }
                
                 for(int imageNumber=_arrayCountForOlderFeeds; imageNumber<=[feedDescArray count]; imageNumber++)
                 {
                     UIImage *image = [UIImage imageNamed:@"placeholder.png"];
                     [feedImagesArrayFromDirectory addObject:image];
                     [completeFeedImagesArrayFromDirectory addObject:image];
                     
                     
                     
                 }

                 [table reloadData];
        [self startLoadingImagesConcurrently];
                 
    }
 
}


-(void)getFeeds:(int)pageNo
{
    
    //Check for the availability of Internet
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
    {
        loadingView.hidden = YES;
        [_dbmanager retrieveActivityDetails];
        
        [feedDescDisplayArray addObjectsFromArray:_dbmanager.feedDescDisplayArrayFromDB];
        [completeFeedDescDisplayArray addObjectsFromArray:_dbmanager.feedDescDisplayArrayFromDB];
        
        [feedImageArray addObjectsFromArray:_dbmanager.feedImageArrayFromDB];
        [completeFeedImageArray addObjectsFromArray:_dbmanager.feedImageArrayFromDB];
        
        [feedImagesArrayFromDirectory addObjectsFromArray:_dbmanager.feedImagesArrayFromDirectoryFromDB];
        [completeFeedImagesArrayFromDirectory addObjectsFromArray:_dbmanager.feedImagesArrayFromDirectoryFromDB];
        
        [actorIdArray addObjectsFromArray:_dbmanager.actorIdArrayFromDB];
        [completeActorIdArray addObjectsFromArray:_dbmanager.actorIdArrayFromDB];
        
        [actorTypeArray addObjectsFromArray:_dbmanager.actorTypeArrayFromDB];
        [completeActorTypeArray addObjectsFromArray:_dbmanager.actorTypeArrayFromDB];
        
        [actorNameArray addObjectsFromArray:_dbmanager.actorNameArrayFromDB];
        [completeActorNameArray addObjectsFromArray:_dbmanager.actorNameArrayFromDB];
        
        [actorUrlArray addObjectsFromArray:_dbmanager.actorUrlArrayFromDB];
        [completeActorUrlArray addObjectsFromArray:_dbmanager.actorUrlArrayFromDB];
        
        [actorTaglineArray addObjectsFromArray:_dbmanager.actorTaglineArrayFromDB];
        [completeActorTaglineArray addObjectsFromArray:_dbmanager.actorTaglineArrayFromDB];
        
        [table reloadData];
    }
    else
    {
        filtersContainer.enabled = NO;
        _arrayCountForOlderFeeds = 1;
    
        //Get feeds
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.angel.co/1/feed?page=%d",pageNo]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod: @"GET"];
        
        
        NSError *error;                                  
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
        
    
            NSDictionary* json = [NSJSONSerialization 
                                  JSONObjectWithData:data //1
                                  options:kNilOptions 
                                  error:&error];
            
            NSArray* feeds = [json objectForKey:@"feed"]; //2
            
            for(int i=0; i<[feeds count]; i++)
            {
                NSDictionary *feedDict = [feeds objectAtIndex:i];
                NSString *description = [feedDict objectForKey:@"description"];
                [feedDescArray addObject:description];
                NSString *feedId = [feedDict objectForKey:@"id"];
                [feedIdArray insertObject:feedId atIndex:i];
                
                NSString *feedTypeString = [[feedDict valueForKey:@"item"] valueForKey:@"type"];
                [feedType addObject:feedTypeString];
                [completeFeedType addObject:feedTypeString];
                
                NSLog(@"\n \n FEED TYPE = %@ \n \n ", feedTypeString);
                
                NSString *actorType = [[feedDict objectForKey:@"actor"] valueForKey:@"type"];
                if(actorType == (NSString *)[NSNull null])
                {
                    NSString *targetActorType = [[feedDict objectForKey:@"target"] valueForKey:@"type"];
                    [actorTypeArray addObject:targetActorType];
                    [completeActorTypeArray addObject:targetActorType];
                }
                else
                {
                    [actorTypeArray addObject:actorType];
                    [completeActorTypeArray addObject:actorType];
                }
                
                NSString *actorId = [[feedDict objectForKey:@"actor"] valueForKey:@"id"];
                if(actorId == (NSString *)[NSNull null])
                {
                    NSString *targetActorId = [[feedDict objectForKey:@"target"] valueForKey:@"id"];
                    [actorIdArray addObject:targetActorId];
                    [completeActorIdArray addObject:targetActorId];
                }
                else
                {
                    [actorIdArray addObject:actorId];
                    [completeActorIdArray addObject:actorId];
                }
                
                NSString *feedImages = [[feedDict objectForKey:@"actor"] valueForKey:@"image"];
                if(feedImages == (NSString *)[NSNull null])
                {
                    NSString *targetFeedImages = [[feedDict objectForKey:@"target"] valueForKey:@"image"];
                    if (targetFeedImages == (NSString *)[NSNull null]) 
                    {
                        [feedImageArray addObject:@"nopic.png"];
                        [completeFeedImageArray addObject:@"nopic.png"];
                    } 
                    else 
                    {
                        [feedImageArray addObject:targetFeedImages];
                        [completeFeedImageArray addObject:targetFeedImages];
                    }
                }
                else
                {
                    [feedImageArray addObject:feedImages];
                    [completeFeedImageArray addObject:feedImages];
                }
                
                NSString *actorNames = [[feedDict objectForKey:@"actor"] valueForKey:@"name"];
                if(actorNames == (NSString *)[NSNull null])
                {
                    NSString *targetNames = [[feedDict objectForKey:@"target"] valueForKey:@"name"];
                    if (targetNames == (NSString *)[NSNull null]) 
                    {
                        [actorNameArray addObject:@"Name not found!"];
                        [completeActorNameArray addObject:@"Name not found!"];
                    } 
                    else 
                    {
                        [actorNameArray addObject:targetNames];
                        [completeActorNameArray addObject:targetNames];
                    }
                    
                }
                else
                {
                    [actorNameArray addObject:actorNames];
                    [completeActorNameArray addObject:actorNames];
                }
                
                NSString *actorUrl = [[feedDict objectForKey:@"actor"] valueForKey:@"angellist_url"];
                [actorUrlArray addObject:actorUrl];
                [completeActorUrlArray addObject:actorUrl];
                
                NSString *actorTagline = [[feedDict objectForKey:@"actor"] valueForKey:@"tagline"];
                if(actorTagline == (NSString *)[NSNull null])
                {
                    NSString *targetTagline = [[feedDict objectForKey:@"target"] valueForKey:@"tagline"];
                    if (targetTagline == (NSString *)[NSNull null]) 
                    {
                        [actorTaglineArray addObject:@"Information not available!"];
                        [completeActorTaglineArray addObject:@"Information not available!"];
                    } 
                    else 
                    {
                        [actorTaglineArray addObject:targetTagline];
                        [completeActorTaglineArray addObject:targetTagline];
                    }
                    
                }
                else
                {
                    [actorTaglineArray addObject:actorTagline];
                    [completeActorTaglineArray addObject:actorTagline];
                }
            }
            
            for(int k=0; k<[completeActorTaglineArray count]; k++)
            {
                NSMutableString * theMutableString = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@",[completeActorTaglineArray objectAtIndex:k]]];
                
                [theMutableString replaceOccurrencesOfString:@"'" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
                
                [actorTaglineArray replaceObjectAtIndex:k withObject:theMutableString];
                [completeActorTaglineArray replaceObjectAtIndex:k withObject:theMutableString];
                
                [theMutableString release];
            }
        
            for(int i=0; i<[feeds count]; i++)
            {
                NSLog(@"\n \n \n feeds count = %d \n \n \n *********", i);

                NSDictionary *feedDict = [feeds objectAtIndex:i];
            
                NSString *actorType = [[feedDict objectForKey:@"target"] valueForKey:@"type"];
//                if(actorType != (NSString *)[NSNull null])
//                {
                    [targetTypeArray addObject:actorType];
                    [completeTargetTypeArray addObject:actorType];
                
               // }
                        
                NSString *actorId = [[feedDict objectForKey:@"target"] valueForKey:@"id"];
//                if(actorId != (NSString *)[NSNull null])
//                {
                    [targetIdArray addObject:actorId];
                    [completeTargetIdArray addObject:actorId];
               // }
            
                NSString *feedImages = [[feedDict objectForKey:@"target"] valueForKey:@"image"];
//                if(feedImages != (NSString *)[NSNull null])
//                {
                    [targetImageArray addObject:feedImages];
                    [completeTargetImageArray addObject:feedImages];
             //   }
            
            
            
                NSString *targetNames = [[feedDict objectForKey:@"target"] valueForKey:@"name"];
//                if (targetNames == (NSString *)[NSNull null]) 
//                {
//                    [targetNameArray addObject:@"Name not found!"];
//                    [completeTargetNameArray addObject:@"Name not found!"];
//                } 
//                else 
//                {
                    [targetNameArray addObject:targetNames];
                    [completeTargetNameArray addObject:targetNames];
               // }
                
                       
                NSString *actorUrl = [[feedDict objectForKey:@"target"] valueForKey:@"angellist_url"];
                //if(actorUrl != (NSString *)[NSNull null])
                //{
                    [targetUrlArray addObject:actorUrl];
                    [completeTargetUrlArray addObject:actorUrl];
               // }
            
           
                NSString *targetTagline = [[feedDict objectForKey:@"target"] valueForKey:@"tagline"];
//                if (targetTagline == (NSString *)[NSNull null]) 
//                {
//                    [targetTaglineArray addObject:@"Information not available!"];
//                    [completeTargetTaglineArray addObject:@"Information not available!"];
//                } 
//                else 
//                {
                    [targetTaglineArray addObject:targetTagline];
                    [completeTargetTaglineArray addObject:targetTagline];
               // }
                
            
        }

            
            for(int z=0; z<[feedDescArray count]; z++)
            {
                NSLog(@"\n \n count of feeds = %d",[feedDescArray count]);
                NSString *desc = [feedDescArray objectAtIndex:z]; 
                NSArray *str = [desc componentsSeparatedByString:@">"];
                
                int k=0;
                NSString *concatStr = @"";
                for(int j=0; j<[str count]; j++)
                {
                    if(k%2 == 1)
                    {
                        NSString *strName1 = [str objectAtIndex:j];
                        NSArray *str1 = [strName1 componentsSeparatedByString:@"</a"];
                        concatStr = [concatStr stringByAppendingFormat:@"%@",[str1 objectAtIndex:0]];
                        k++;
                    }
                    else
                    {
                        NSString *strName2 = [str objectAtIndex:j];
                        NSArray *str2 = [strName2 componentsSeparatedByString:@"<"];
                        concatStr = [concatStr stringByAppendingFormat:@"%@",[str2 objectAtIndex:0]];
                        k++;
                    }
                }
                
                NSMutableString * theMutableString = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@",concatStr]];
                
                [theMutableString replaceOccurrencesOfString:@"'" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
                
                [feedDescDisplayArray addObject:theMutableString];
                [completeFeedDescDisplayArray addObject:theMutableString];
                
                [theMutableString release];
            }
            
            for(int imageNumber=1; imageNumber<=[feedDescArray count]; imageNumber++)
            {
                UIImage *image = [UIImage imageNamed:@"placeholder.png"];
                [feedImagesArrayFromDirectory addObject:image];
                [completeFeedImagesArrayFromDirectory addObject:image];
                
                NSLog(@"\n \n \n Nothing was downloaded.");
            }
            
            [table reloadData];
            [self startLoadingImagesConcurrently];
        
    }

}

// Functions to display images concurrently 

-(void)startLoadingImagesConcurrently
{
    
    NSOperationQueue *tShopQueue = [NSOperationQueue new];
    NSInvocationOperation *tPerformOperation = [[NSInvocationOperation alloc] 
                                                initWithTarget:self
                                                selector:@selector(loadImage) 
                                                object:nil];
    [tShopQueue addOperation:tPerformOperation]; 
    [tPerformOperation release];
    [tShopQueue release];
    
}

- (void)loadImage 
{
    for (int asyncCount = _arrayCountForOlderFeeds; asyncCount < [feedImageArray count] ; asyncCount++) {
        
        NSString *picLoad = [NSString stringWithFormat:@"%@",[feedImageArray objectAtIndex:asyncCount]];
        NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:picLoad]];
        UIImage* image = [UIImage imageWithData:imageData];
        if (image != nil) {
            
            [feedImagesArrayFromDirectory replaceObjectAtIndex:asyncCount withObject:image];
            [self performSelectorOnMainThread:@selector(displayImage:) withObject:[NSNumber numberWithInt:asyncCount] waitUntilDone:NO]; 
        }
        [imageData release];
       
    }
    if (_pageNo == 1) {
         [self saveImagesOfFeeds]; 
    }
   
}

-(void)displayImage:(NSNumber*)presentCount
{
    if([[table indexPathsForVisibleRows]count] > 0)
    {
        NSIndexPath *firstRowShown = [[table indexPathsForVisibleRows]objectAtIndex:0];
        NSIndexPath *lastRowShown = [[table indexPathsForVisibleRows]objectAtIndex:[[table indexPathsForVisibleRows]count]-1];
        NSInteger count = [presentCount integerValue];
        if((count > firstRowShown.row)&&(count < lastRowShown.row))
        [table reloadData];
    }
    else
    {
        [table reloadData]; 
    }
    
}


-(void)refreshFeeds
{
//    [filterDescArray removeAllObjects];
//    [filterImageArray removeAllObjects];
//    
//    [filterFeedImagesArrayFromDirectory removeAllObjects];
//    
//    [filterTypeArray removeAllObjects];
//    [filterIdArray removeAllObjects];
//    
//    [filterNameArray removeAllObjects];
//    [filterUrlArray removeAllObjects];
//    [filterTaglineArray removeAllObjects];
//    
//    [filterTypeArrayTarget removeAllObjects];
//    [filterIdArrayTarget removeAllObjects];
//    [filterImageArrayTarget removeAllObjects];
//    [filterNameArrayTarget removeAllObjects];
//    [filterUrlArrayTarget removeAllObjects];
//    [filterTaglineArrayTarget removeAllObjects];
//    [filterFeedType removeAllObjects];
//    [feedDescDisplayArray removeAllObjects];
//    [feedImageArray removeAllObjects];
//    [feedImagesArrayFromDirectory removeAllObjects];
//    [actorTypeArray removeAllObjects];
//    [actorIdArray removeAllObjects];
//    [actorNameArray removeAllObjects];
//    [actorUrlArray removeAllObjects];
//    [actorTaglineArray removeAllObjects];
//    [targetTypeArray removeAllObjects];
//    [targetIdArray removeAllObjects];
//    [targetImageArray removeAllObjects];
//    [targetNameArray removeAllObjects];
//    [targetUrlArray removeAllObjects];
//    [targetTaglineArray removeAllObjects];
//    [feedType removeAllObjects];
//    [feedImagesArrayFromDirectory removeAllObjects];
//    
//    [completeActorTaglineArray removeAllObjects];
//    [completeFeedType removeAllObjects];
//    [completeFeedImagesArrayFromDirectory removeAllObjects];
//    [completeActorIdArray removeAllObjects];
//    [completeActorNameArray removeAllObjects];
//    [completeActorTypeArray removeAllObjects];
//    [completeActorUrlArray removeAllObjects];
//    [completeFeedDescDisplayArray removeAllObjects];
//    [completeFeedImageArray removeAllObjects];
//    
//    [completeFeedImagesArrayFromDirectory removeAllObjects];
//    [completeTargetIdArray removeAllObjects];
//    [completeTargetImageArray removeAllObjects];
//    [completeTargetNameArray removeAllObjects];
//    [completeTargetTaglineArray removeAllObjects];
//    [completeTargetTypeArray removeAllObjects];
//    [completeTargetUrlArray removeAllObjects];
    
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
    {
        loadingView.hidden = YES;
        [_dbmanager retrieveActivityDetails];
        
        [feedDescDisplayArray addObjectsFromArray:_dbmanager.feedDescDisplayArrayFromDB];
        [completeFeedDescDisplayArray addObjectsFromArray:_dbmanager.feedDescDisplayArrayFromDB];
        
        [feedImageArray addObjectsFromArray:_dbmanager.feedImageArrayFromDB];
        [completeFeedImageArray addObjectsFromArray:_dbmanager.feedImageArrayFromDB];
        
        [feedImagesArrayFromDirectory addObjectsFromArray:_dbmanager.feedImagesArrayFromDirectoryFromDB];
        [completeFeedImagesArrayFromDirectory addObjectsFromArray:_dbmanager.feedImagesArrayFromDirectoryFromDB];
        
        [actorIdArray addObjectsFromArray:_dbmanager.actorIdArrayFromDB];
        [completeActorIdArray addObjectsFromArray:_dbmanager.actorIdArrayFromDB];
        
        [actorTypeArray addObjectsFromArray:_dbmanager.actorTypeArrayFromDB];
        [completeActorTypeArray addObjectsFromArray:_dbmanager.actorTypeArrayFromDB];
        
        [actorNameArray addObjectsFromArray:_dbmanager.actorNameArrayFromDB];
        [completeActorNameArray addObjectsFromArray:_dbmanager.actorNameArrayFromDB];
        
        [actorUrlArray addObjectsFromArray:_dbmanager.actorUrlArrayFromDB];
        [completeActorUrlArray addObjectsFromArray:_dbmanager.actorUrlArrayFromDB];
        
        [actorTaglineArray addObjectsFromArray:_dbmanager.actorTaglineArrayFromDB];
        [completeActorTaglineArray addObjectsFromArray:_dbmanager.actorTaglineArrayFromDB];
        
        [table reloadData];
    }
    else
    {
        filtersContainer.enabled = NO;
        //Get feeds
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.angel.co/1/feed"]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod: @"GET"];
        
        
        NSError *error;                                  
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
        
        
        NSDictionary* json = [NSJSONSerialization 
                              JSONObjectWithData:data //1
                              options:kNilOptions 
                              error:&error];
        
        NSArray* feeds = [json objectForKey:@"feed"]; //2
        
        for (int i = 0; i < [feeds count]; i++) 
        {
            NSDictionary *feed = [feeds objectAtIndex:i];
            NSString *feedId = [feed objectForKey:@"id"];
            
            if (![feedIdArray containsObject:feedId]) 
            {
                [feedIdArray insertObject:feedId atIndex:i];
                
                NSString *description = [feed objectForKey:@"description"];
                [feedDescArray insertObject:description atIndex:i];
                
                NSString *feedTypeString = [[feed valueForKey:@"item"] valueForKey:@"type"];
                [feedType addObject:feedTypeString];
                [completeFeedType insertObject:feedTypeString atIndex:i];
                
                NSLog(@"\n \n FEED TYPE = %@ \n \n ", feedTypeString);
                
                NSString *actorType = [[feed objectForKey:@"actor"] valueForKey:@"type"];
                if(actorType == (NSString *)[NSNull null])
                {
                    NSString *targetActorType = [[feed objectForKey:@"target"] valueForKey:@"type"];
                    [actorTypeArray insertObject:targetActorType atIndex:i];
                    [completeActorTypeArray insertObject:targetActorType atIndex:i];
                }
                else
                {
                    [actorTypeArray insertObject:actorType atIndex:i];
                    [completeActorTypeArray insertObject:actorType atIndex:i];
                }
                
                NSString *actorId = [[feed objectForKey:@"actor"] valueForKey:@"id"];
                if(actorId == (NSString *)[NSNull null])
                {
                    NSString *targetActorId = [[feed objectForKey:@"target"] valueForKey:@"id"];
                    [actorIdArray insertObject:targetActorId atIndex:i];
                    [completeActorIdArray insertObject:targetActorId atIndex:i];
                }
                else
                {
                    [actorIdArray insertObject:actorId atIndex:i];
                    [completeActorIdArray insertObject:actorId atIndex:i];
                }
                
                NSString *feedImages = [[feed objectForKey:@"actor"] valueForKey:@"image"];
                if(feedImages == (NSString *)[NSNull null])
                {
                    NSString *targetFeedImages = [[feed objectForKey:@"target"] valueForKey:@"image"];
                    if (targetFeedImages == (NSString *)[NSNull null]) 
                    {
                        [feedImageArray insertObject:@"nopic.png" atIndex:i];
                        [completeFeedImageArray insertObject:@"nopic.png" atIndex:i];
                    } 
                    else 
                    {
                        [feedImageArray insertObject:targetFeedImages atIndex:i];
                        [completeFeedImageArray insertObject:targetFeedImages atIndex:i];
                    }
                }
                else
                {
                    [feedImageArray insertObject:feedImages atIndex:i];
                    [completeFeedImageArray insertObject:feedImages atIndex:i];
                }
                
                NSString *actorNames = [[feed objectForKey:@"actor"] valueForKey:@"name"];
                if(actorNames == (NSString *)[NSNull null])
                {
                    NSString *targetNames = [[feed objectForKey:@"target"] valueForKey:@"name"];
                    if (targetNames == (NSString *)[NSNull null]) 
                    {
                        [actorNameArray insertObject:@"Name not found!" atIndex:i];
                        [completeActorNameArray insertObject:@"Name not found!" atIndex:i];
                    } 
                    else 
                    {
                        [actorNameArray insertObject:targetNames atIndex:i];
                        [completeActorNameArray insertObject:targetNames atIndex:i];
                    }
                    
                }
                else
                {
                    [actorNameArray insertObject:actorNames atIndex:i];
                    [completeActorNameArray insertObject:actorNames atIndex:i];
                }
                
                NSString *actorUrl = [[feed objectForKey:@"actor"] valueForKey:@"angellist_url"];
                [actorUrlArray insertObject:actorUrl atIndex:i];
                [completeActorUrlArray insertObject:actorUrl atIndex:i];
                
                NSString *actorTagline = [[feed objectForKey:@"actor"] valueForKey:@"tagline"];
                if(actorTagline == (NSString *)[NSNull null])
                {
                    NSString *targetTagline = [[feed objectForKey:@"target"] valueForKey:@"tagline"];
                    if (targetTagline == (NSString *)[NSNull null]) 
                    {
                        [actorTaglineArray insertObject:@"Information not available!" atIndex:i];
                        [completeActorTaglineArray insertObject:@"Information not available!" atIndex:i];
                    } 
                    else 
                    {
                        [actorTaglineArray insertObject:targetTagline atIndex:i];
                        [completeActorTaglineArray insertObject:targetTagline atIndex:i];
                    }
                    
                }
                else
                {
                    [actorTaglineArray insertObject:actorTagline atIndex:i];
                    [completeActorTaglineArray insertObject:actorTagline atIndex:i];
                }

                
                    NSMutableString * theMutableString = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@",[completeActorTaglineArray objectAtIndex:i]]];
                    
                    [theMutableString replaceOccurrencesOfString:@"'" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
                    
                    [actorTaglineArray replaceObjectAtIndex:i withObject:theMutableString];
                    [completeActorTaglineArray replaceObjectAtIndex:i withObject:theMutableString];
                    
                    [theMutableString release];
                               
                
                    
                    NSDictionary *feedDict = [feeds objectAtIndex:i];
                    
                    NSString *targetType = [[feedDict objectForKey:@"target"] valueForKey:@"type"];
                    //                if(actorType != (NSString *)[NSNull null])
                    //                {
                    [targetTypeArray insertObject:targetType atIndex:i];
                    [completeTargetTypeArray insertObject:targetType atIndex:i];
                    
                    // }
                    
                    NSString *targetId = [[feedDict objectForKey:@"target"] valueForKey:@"id"];
                    //                if(actorId != (NSString *)[NSNull null])
                    //                {
                    [targetIdArray insertObject:targetId atIndex:i];
                    [completeTargetIdArray insertObject:targetId atIndex:i];
                    // }
                    
                    NSString *feedtargetImages = [[feedDict objectForKey:@"target"] valueForKey:@"image"];
                    //                if(feedImages != (NSString *)[NSNull null])
                    //                {
                    [targetImageArray insertObject:feedtargetImages atIndex:i];
                    [completeTargetImageArray insertObject:feedtargetImages atIndex:i];
                    //   }
                    
                    
                    
                    NSString *targetNames = [[feedDict objectForKey:@"target"] valueForKey:@"name"];
                    //                if (targetNames == (NSString *)[NSNull null]) 
                    //                {
                    //                    [targetNameArray addObject:@"Name not found!"];
                    //                    [completeTargetNameArray addObject:@"Name not found!"];
                    //                } 
                    //                else 
                    //                {
                    [targetNameArray insertObject:targetNames atIndex:i];
                    [completeTargetNameArray insertObject:targetNames atIndex:i];
                    // }
                    
                    
                    NSString *targetUrl = [[feedDict objectForKey:@"target"] valueForKey:@"angellist_url"];
                    //if(actorUrl != (NSString *)[NSNull null])
                    //{
                    [targetUrlArray insertObject:targetUrl atIndex:i];
                    [completeTargetUrlArray insertObject:targetUrl atIndex:i];
                    // }
                    
                    
                    NSString *targetTagline = [[feedDict objectForKey:@"target"] valueForKey:@"tagline"];
                    //                if (targetTagline == (NSString *)[NSNull null]) 
                    //                {
                    //                    [targetTaglineArray addObject:@"Information not available!"];
                    //                    [completeTargetTaglineArray addObject:@"Information not available!"];
                    //                } 
                    //                else 
                    //                {
                    [targetTaglineArray insertObject:targetTagline atIndex:i];
                    [completeTargetTaglineArray insertObject:targetTagline atIndex:i];
                    // }
                    
                    NSLog(@"\n \n count of feeds = %d",[feedDescArray count]);
                    NSString *desc = [feedDescArray objectAtIndex:i]; 
                    NSArray *str = [desc componentsSeparatedByString:@">"];
                    
                    int k=0;
                    NSString *concatStr = @"";
                    for(int j=0; j<[str count]; j++)
                    {
                        if(k%2 == 1)
                        {
                            NSString *strName1 = [str objectAtIndex:j];
                            NSArray *str1 = [strName1 componentsSeparatedByString:@"</a"];
                            concatStr = [concatStr stringByAppendingFormat:@"%@",[str1 objectAtIndex:0]];
                            k++;
                        }
                        else
                        {
                            NSString *strName2 = [str objectAtIndex:j];
                            NSArray *str2 = [strName2 componentsSeparatedByString:@"<"];
                            concatStr = [concatStr stringByAppendingFormat:@"%@",[str2 objectAtIndex:0]];
                            k++;
                        }
                    }
                    
                    NSMutableString * theMutableString1 = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@",concatStr]];
                    
                    [theMutableString1 replaceOccurrencesOfString:@"'" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
                    
                    [feedDescDisplayArray insertObject:theMutableString atIndex:i];
                    [completeFeedDescDisplayArray insertObject:theMutableString atIndex:i];
                    
                    [theMutableString1 release];
                
                
                
                    UIImage *image = [UIImage imageNamed:@"placeholder.png"];
                    [feedImagesArrayFromDirectory insertObject:image atIndex:i];
                    [completeFeedImagesArrayFromDirectory insertObject:image atIndex:i];
                       
                
            }
        }
        
    }
    [table reloadData];
    //[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(checkPage:) userInfo:nil repeats:NO];
     [self performSelector:@selector(checkPage:) withObject:nil afterDelay:1.0];
    
     NSLog(@"\n \n  PULL DOWN  \n \n ");
  
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{  
    
    
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    
    if(table.contentOffset.y >= (table.contentSize.height - table.frame.size.height) + 80) {
        //user has scrolled to the bottom
        
         
        NSLog(@"\n pos: %f of %f", y, h);
        
               [table reloadData];
        _pageNo++;
        table.sectionFooterHeight = 52;
        [self loadOldFeeds:_pageNo];
        
        table.sectionFooterHeight = 17;
        // [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(checkPage:) userInfo:nil repeats:NO];
        [self performSelector:@selector(checkPage:) withObject:nil afterDelay:1.0];
        
    }
  
    //  float reload_distance = 10;
    if(scrollView.contentOffset.y < 0.0f && scrollView.contentOffset.y > -80.0f) 
    {
        
        NSLog(@"\n \n \n DISPLAY NEW FEEDS AT THIS POINT \n \n \n ");   
//  CGRect frame = CGRectMake(table.frame.origin.x,table.frame.origin.y+10, table.frame.size.width, table.frame.size.height);
//        table.frame = frame;
        [table reloadData];
        table.sectionHeaderHeight = 52;
        [self refreshFeeds];
       
//    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(checkPage:) userInfo:nil repeats:NO];
       
    }    
    
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
    viewPullToRefresh = [[UIView alloc] initWithFrame:CGRectMake(0, 05, 320, 50)];
   // [table.tableHeaderView addSubview:viewPullToRefresh];
    
    imageAngelLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"angel_logo.png"]];
    imageAngelLogo.frame = CGRectMake(220, 0, 100, 40);
    
    imageRefresh = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"refresh_arrow.png"]];
    imageRefresh.frame = CGRectMake(20, 0, 30, 40);
    
    labelrefresh = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, 180, 30)];
    labelrefresh.text = @"Loading New Feeds..";
    labelrefresh.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:13];
    labelrefresh.textColor = [UIColor lightGrayColor];
    labelrefresh.backgroundColor = [UIColor clearColor];
    if (table.sectionHeaderHeight >= 52) 
    {
        [viewPullToRefresh addSubview:labelrefresh];
        [viewPullToRefresh addSubview:imageAngelLogo];
        [viewPullToRefresh addSubview:imageRefresh];
        
    }
    

       // [labelrefresh release];
        _newFeeds = TRUE;
        _olderFeeds = FALSE;
        //NSLog(@"\n \n \n DISPLAY NEW FEEDS AT THIS POINT \n \n \n ");
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.8];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationBeginsFromCurrentState:YES];
        
        // The transform matrix
        CGAffineTransform transform = 
        CGAffineTransformMakeRotation(0.1745*90);
        imageRefresh.transform = transform;
        
        // Commit the changes
        [UIView commitAnimations];
        
         //[self refreshFeeds];
   // }
    
    
//    imageTransform = TRUE;
//    imageRefresh.transform = CGAffineTransformMakeRotation(0.1745*90);
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:0.4];
    return [viewPullToRefresh autorelease];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section 
{
    
    
   // if(table.contentOffset.y >= (table.contentSize.height - table.frame.size.height) + 80)  {
        
        
        viewPullUpOlder= [[UIView alloc] initWithFrame:CGRectMake(0, ((table.contentSize.height - table.frame.size.height) + 70), 320, 70)];
        
        imageKinveyLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"kinvey_logo.png"]];
        imageKinveyLogo.frame = CGRectMake(200, ((table.contentSize.height - table.frame.size.height) + 70), 100, 30);
        
        imagePullUp = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"refresh_arrow.png"]];
        imagePullUp.frame = CGRectMake(20,((table.contentSize.height - table.frame.size.height) + 50), 30, 40);
        
             
        labelPullUp = [[UILabel alloc] initWithFrame:CGRectMake(70, ((table.contentSize.height - table.frame.size.height) + 10), 180, 30)];
        labelPullUp.text = @"Pull up for older feeds...";
        labelPullUp.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:13];
        labelPullUp.textColor = [UIColor whiteColor];
        labelPullUp.backgroundColor = [UIColor clearColor];
        
        //if (table.sectionFooterHeight >= 52) {
            [viewPullUpOlder addSubview:labelPullUp];
            [viewPullUpOlder addSubview:imageAngelLogo];
            [viewPullUpOlder addSubview:imageRefresh];
        //}
        
        
 
        _newFeeds = FALSE;
        _olderFeeds = TRUE;
        
        //[self refreshFeeds];
  //  }


    
    return viewPullUpOlder;
    
    
}

- (CGFloat)tableViewHeight
{
    [table layoutIfNeeded];
    return [table contentSize].height;
}


- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView 
{
    
    
    
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSLog(@"lol");
     
    if (_newFeeds == TRUE) {
//        CGAffineTransform transform = 
//        CGAffineTransformMakeRotation(0.1745*90);
//        imageRefresh.transform = transform;
        
        labelrefresh.text = @"Loading New Feeds..";
    }
    else if (_olderFeeds == TRUE)  {
        
        
       // labelPullUp.text = @"Loading New Feeds..";
    }
   
       
}


-(void)checkPage:(UIScrollView*)scrollView
{
    //_pageNo = 1;
    table.sectionHeaderHeight = 22;
    table.sectionFooterHeight = 17;
    for(UIView *view in table.subviews)
    {
       
        if ([view isKindOfClass:[UILabel class]]) {
            
            [view removeFromSuperview];
        }
        if ([view isKindOfClass:[UIImageView class]]) 
        {
            [view removeFromSuperview];
        }
        
    }
    
    if (_newFeeds == TRUE) {
    [viewPullToRefresh removeFromSuperview];
    table.sectionHeaderHeight = 22;
    }
    
    table.sectionFooterHeight = 17;
    NSLog(@"\n \n \n STOP DISPLAY NEW FEEDS AT THIS POINT \n \n \n ");
    
}


// save images to the documents directory

-(void) saveImagesOfFeeds
{
    for(int imageNumber=_arrayCountForOlderFeeds; imageNumber<=[completeFeedImageArray count]; imageNumber++)
    {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"feeduser%d.png",imageNumber]];
        
        UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[completeFeedImageArray objectAtIndex:(imageNumber-1)]]]]];
        NSData *imageData = UIImagePNGRepresentation(image);
        [imageData writeToFile:savedImagePath atomically:NO];
        
        [image release];
        

        [directoryImagesArray addObject:savedImagePath];
    }
    
    if (_pageNo==1) {
    [self saveFeedsDataToDB];
    }
 
}

// save data of all feeds to the database

-(void) saveFeedsDataToDB
{
    for(int k=0; k<[completeFeedDescDisplayArray count]; k++)
    {
        NSString *activityId = [NSString stringWithFormat:@"%d",(k+1)];
        NSString *feedDescription = [NSString stringWithFormat:@"%@",[completeFeedDescDisplayArray objectAtIndex:k]];
        NSString *feedImageUrl = [NSString stringWithFormat:@"%@",[completeFeedImageArray objectAtIndex:k]];
        NSString *actorType = [NSString stringWithFormat:@"%@",[completeActorTypeArray objectAtIndex:k]];
        NSString *actorId = [NSString stringWithFormat:@"%@",[completeActorIdArray objectAtIndex:k]];
        NSString *actorName = [NSString stringWithFormat:@"%@",[completeActorNameArray objectAtIndex:k]];
        NSString *actorUrl = [NSString stringWithFormat:@"%@",[completeActorUrlArray objectAtIndex:k]];
        NSString *actorTagline = [NSString stringWithFormat:@"%@",[completeActorTaglineArray objectAtIndex:k]];
        
        NSString *feedImagePath = [NSString stringWithFormat:@"%@",[directoryImagesArray objectAtIndex:k]];
        
        [_dbmanager insertRecordIntoActivityTable:@"Activity" withField1:@"activityId" field1Value:activityId andField2:@"feedDescription" field2Value:feedDescription andField3:@"feedImageUrl" field3Value:feedImageUrl andField4:@"actorType" field4Value:actorType andField5:@"actorId" field5Value:actorId andField6:@"actorName" field6Value:actorName andField7:@"actorUrl" field7Value:actorUrl andField8:@"actorTagline" field8Value:actorTagline andField9:@"feedImagePath" field9Value:feedImagePath];
   }
    
    
    if([directoryImagesArray count] == [feedImagesArrayFromDirectory count])
    {
        _allImagesDowloaded = TRUE;
        [table reloadData];
    }
}

// methods to animate filter options
-(void)animateFilter
{
    _yPos = 0;
    _xPos = 0;
    
    if (i%2 == 0) {
        i++;
         _showFilterMenu = TRUE;
        for (int index = 0; index<[_filterNames count]; index++) 
        {
            UIImage* image = [UIImage imageNamed:@"filters.png"];
            UIButton *filterButtons = [UIButton buttonWithType:UIButtonTypeCustom];
            [filterButtons setBackgroundImage:image forState:UIControlStateNormal];
            
            NSString *imageName = [NSString stringWithFormat:@"%@",[_filterNames objectAtIndex:index]];
          [filterButtons setBackgroundImage:[UIImage imageNamed:@"filtertab.png"] forState:UIControlStateNormal];
            [filterButtons setTitle:imageName forState:UIControlStateNormal];
            filterButtons.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
            [[filterButtons titleLabel] setTextAlignment:UITextAlignmentCenter];
            [filterButtons setBackgroundColor:[UIColor darkGrayColor]];
            [filterButtons setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            filterButtons.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15];
            [filterButtons addTarget:self action:@selector(getFilteredList:) forControlEvents:UIControlStateHighlighted];
            filterButtons.frame = CGRectMake(_xPos, _yPos, 271, 51);
            filterButtons.tag = index+1;
            _yPos = _yPos + 53;
            [_view1 addSubview:filterButtons];
            
        }
        
        [filtersContainer setUserInteractionEnabled:YES];
        [_view1 setFrame:CGRectMake(25, -250, 271, 51*4)];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2];
       
        [_view1 setFrame:CGRectMake(25, 0, 271, 51*4)];
        [filterView setFrame:CGRectMake(0, 0, 320, 400)];
        [_view1 setBackgroundColor:[UIColor blackColor]];
        [UIView commitAnimations];

    }
    
    else 
    {
        
       
        [filtersContainer setUserInteractionEnabled:YES];
        
        for (int index = 1; index<[_filterNames count]+1; index++) {
        
            [[self.view viewWithTag:index] removeFromSuperview];
        }
        i++;
        [filterView setFrame:CGRectMake(0, 0, 320, 400)];
        [_view1 setFrame:CGRectMake(25, 0, 271, 51*4)];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2];
        
        [_view1 setFrame:CGRectMake(25, -250, 271, 51*4)];
        [filterView setFrame:CGRectMake(0, -480, 320, 400)];
        [_view1 setBackgroundColor:[UIColor blackColor]];
        
        [UIView commitAnimations];
        
    }
    
}


- (void)filterButtonSelected:(id)sender 
{
    // whatever needs to happen when button is tapped    
    // Check for the availability of Internet

    UIView *filtersList;
    
    if(_showFilterMenu == FALSE)
    {
        [filtersContainer setSelected:TRUE];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) 
        {


            [self performSelector:@selector(animateFilter) withObject:nil afterDelay:0.05];  
        }
        else
        {
            filterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
            [filterView  setBackgroundColor: [UIColor blackColor]];
            [filterView setAlpha:0.6f];
            filterView.tag = 1000;
            [self.view addSubview:filterView];
            
            filtersList = [[UIView alloc] initWithFrame:CGRectMake(((768*165)/320), 0, ((768*150)/320), ((1024*145)/480))];
            [filtersList  setBackgroundColor: [UIColor blackColor]];
            [filtersList.layer setCornerRadius:18.0f];
            [filtersList setAlpha:1.0f];
            filtersList.tag = 1001;
            [self.view addSubview:filtersList];
            
            UIImage* image = [UIImage imageNamed:@"navigationbarNf.png"];
            
            int _yPos = ((1024*5)/480);
            
            for (int i=1; i<=5; i++) 
            {
                UIButton *following = [UIButton buttonWithType:UIButtonTypeCustom];
                [following setBackgroundImage:image forState:UIControlStateNormal];
                [following setTitle:[NSString stringWithFormat:@"%@",[_filterNames objectAtIndex:(i-1)]] forState:UIControlStateNormal];
                [following setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [following addTarget:self action:@selector(getFilteredList:) forControlEvents:UIControlStateHighlighted];
                following.frame = CGRectMake(((768*14)/320), _yPos, ((768*120)/320), ((1024*25)/480));
                following.tag = i;
                [filtersList addSubview:following];
                
                _yPos = _yPos + ((1024*27)/480);
            }
            
            [filtersList release];
            [filterView release];
            
            _showFilterMenu = TRUE;
        }
           
    }
    else
    {
        [filtersContainer setSelected:FALSE];
        [self performSelector:@selector(animateFilter) withObject:nil afterDelay:0.07];
        _showFilterMenu = FALSE;
    }
  
}


// get the selected filter option details
-(void)getFilteredList:(id)sender
{
    [filterDescArray removeAllObjects];
    [filterImageArray removeAllObjects];
    
    [filterFeedImagesArrayFromDirectory removeAllObjects];
    
    [filterTypeArray removeAllObjects];
    [filterIdArray removeAllObjects];
    
    [filterNameArray removeAllObjects];
    [filterUrlArray removeAllObjects];
    [filterTaglineArray removeAllObjects];
    
    [filterTypeArrayTarget removeAllObjects];
    [filterIdArrayTarget removeAllObjects];
    [filterImageArrayTarget removeAllObjects];
    [filterNameArrayTarget removeAllObjects];
    [filterUrlArrayTarget removeAllObjects];
    [filterTaglineArrayTarget removeAllObjects];
    [filterFeedType removeAllObjects];
    
    [feedDescDisplayArray removeAllObjects];
    [feedDescDisplayArray addObjectsFromArray:completeFeedDescDisplayArray];
    [feedImageArray removeAllObjects];
    [feedImageArray addObjectsFromArray:completeFeedImageArray];
    
    [feedImagesArrayFromDirectory removeAllObjects];
    [feedImagesArrayFromDirectory addObjectsFromArray:completeFeedImagesArrayFromDirectory];
    
    [actorTypeArray removeAllObjects];
    [actorTypeArray addObjectsFromArray:completeActorTypeArray];
    
    [actorIdArray removeAllObjects];
    [actorIdArray addObjectsFromArray:completeActorIdArray];
    
    [actorNameArray removeAllObjects];
    [actorNameArray addObjectsFromArray:completeActorNameArray];
    [actorUrlArray removeAllObjects];
    [actorUrlArray addObjectsFromArray:completeActorUrlArray];
    [actorTaglineArray removeAllObjects];
    [actorTaglineArray addObjectsFromArray:completeActorTaglineArray];
    
    
    
    [targetTypeArray removeAllObjects];
    [targetTypeArray addObjectsFromArray:completeTargetTypeArray];
    
    [targetIdArray removeAllObjects];
    [targetIdArray addObjectsFromArray:completeTargetIdArray];
    [targetImageArray removeAllObjects];
    [targetImageArray addObjectsFromArray:completeTargetImageArray];
    [targetNameArray removeAllObjects];
    [targetNameArray addObjectsFromArray:completeTargetNameArray];
    [targetUrlArray removeAllObjects];
    [targetUrlArray addObjectsFromArray:completeTargetUrlArray];
    [targetTaglineArray removeAllObjects];
    [targetTaglineArray addObjectsFromArray:completeTargetTaglineArray];
    
    [feedType removeAllObjects];
    [feedType addObjectsFromArray:completeFeedType];
    
    _tagID = [sender tag];
    
    switch(_tagID)
    {
            //Implement Following
        case 1 : _filterFollowed = TRUE;
                 for(int k=0; k<[feedDescDisplayArray count];k++)
                 {
                     NSString *checkStr = [feedDescDisplayArray objectAtIndex:k];
                     if([checkStr rangeOfString:@"followed"].location != NSNotFound)
                     {
                         [filterDescArray addObject:[feedDescDisplayArray objectAtIndex:k]];
                         [filterImageArray addObject:[feedImageArray objectAtIndex:k]];
                         [filterFeedImagesArrayFromDirectory addObject:[feedImagesArrayFromDirectory objectAtIndex:k]];
                         [filterTypeArray addObject:[actorTypeArray objectAtIndex:k]];
                         [filterIdArray addObject:[actorIdArray objectAtIndex:k]];
                         [filterNameArray addObject:[actorNameArray objectAtIndex:k]];
                         [filterUrlArray addObject:[actorUrlArray objectAtIndex:k]];
                         [filterTaglineArray addObject:[actorTaglineArray objectAtIndex:k]];
                         
                         
                         [filterTypeArrayTarget addObject:[targetTypeArray objectAtIndex:k]];
                         [filterIdArrayTarget addObject:[targetIdArray objectAtIndex:k]];
                         [filterImageArrayTarget addObject:[targetImageArray objectAtIndex:k]];
                         [filterNameArrayTarget addObject:[targetNameArray objectAtIndex:k]];
                         [filterUrlArrayTarget addObject:[targetUrlArray objectAtIndex:k]];
                         [filterTaglineArrayTarget addObject:[targetTaglineArray objectAtIndex:k]];
                       
                         [filterFeedType addObject:[feedType objectAtIndex:k]];
                     }
                 }
                
                 label.text = @"Activity - Followed";
                 self.tabBarItem.title = @"Activity";

                 [feedDescDisplayArray removeAllObjects];
                 [feedDescDisplayArray addObjectsFromArray:filterDescArray];
                 [feedImageArray removeAllObjects];
                 [feedImageArray addObjectsFromArray:filterImageArray];
                 [feedImagesArrayFromDirectory removeAllObjects];
                 [feedImagesArrayFromDirectory addObjectsFromArray:filterFeedImagesArrayFromDirectory];
                 [actorTypeArray removeAllObjects];
                 [actorTypeArray addObjectsFromArray:filterTypeArray];
                 [actorIdArray removeAllObjects];
                 [actorIdArray addObjectsFromArray:filterIdArray];
                 [actorNameArray removeAllObjects];
                 [actorNameArray addObjectsFromArray:filterNameArray];
                 [actorUrlArray removeAllObjects];
                 [actorUrlArray addObjectsFromArray:filterUrlArray];
                 [actorTaglineArray removeAllObjects];
                 [actorTaglineArray addObjectsFromArray:filterTaglineArray];
            
            [targetTypeArray removeAllObjects];
            [targetTypeArray addObjectsFromArray:filterTypeArrayTarget];            
            [targetIdArray removeAllObjects];
            [targetIdArray addObjectsFromArray:filterIdArrayTarget];
            [targetImageArray removeAllObjects];
            [targetImageArray addObjectsFromArray:filterImageArrayTarget];
            [targetNameArray removeAllObjects];
            [targetNameArray addObjectsFromArray:filterNameArrayTarget];
            [targetUrlArray removeAllObjects];
            [targetUrlArray addObjectsFromArray:filterUrlArrayTarget];
            [targetTaglineArray removeAllObjects];
            [targetTaglineArray addObjectsFromArray:filterTaglineArrayTarget];
            
            [feedType removeAllObjects];
            [feedType addObjectsFromArray:filterFeedType];


            
                 _showFilterMenu = FALSE;
            [filtersContainer setSelected:FALSE];
                
            [[self.view viewWithTag:i] removeFromSuperview];
            [self performSelector:@selector(animateFilter) withObject:nil afterDelay:0.05];
            [table reloadData];
            [self startLoadingImagesConcurrently];
                break;
            
            //Implement Invested    
        case 2 : _filterInvested = TRUE;
                 for(int k=0; k<[feedDescDisplayArray count];k++)
                 {
                     NSString *checkStr = [feedDescDisplayArray objectAtIndex:k];
                     if([checkStr rangeOfString:@"invested"].location != NSNotFound)
                     {
                         [filterDescArray addObject:[feedDescDisplayArray objectAtIndex:k]];
                         [filterImageArray addObject:[feedImageArray objectAtIndex:k]];
                         
                         [filterFeedImagesArrayFromDirectory addObject:[feedImagesArrayFromDirectory objectAtIndex:k]];
                         
                         [filterTypeArray addObject:[actorTypeArray objectAtIndex:k]];
                         [filterIdArray addObject:[actorIdArray objectAtIndex:k]];
                         
                         [filterNameArray addObject:[actorNameArray objectAtIndex:k]];
                         [filterUrlArray addObject:[actorUrlArray objectAtIndex:k]];
                         [filterTaglineArray addObject:[actorTaglineArray objectAtIndex:k]];
                         
                         
                         [filterTypeArrayTarget addObject:[targetTypeArray objectAtIndex:k]];
                         [filterIdArrayTarget addObject:[targetIdArray objectAtIndex:k]];
                         [filterImageArrayTarget addObject:[targetImageArray objectAtIndex:k]];
                         [filterNameArrayTarget addObject:[targetNameArray objectAtIndex:k]];
                         [filterUrlArrayTarget addObject:[targetUrlArray objectAtIndex:k]];
                         [filterTaglineArrayTarget addObject:[targetTaglineArray objectAtIndex:k]];
                         
                         [filterFeedType addObject:[feedType objectAtIndex:k]];
                     }
                 } 

                 label.text = @"Activity - Invested";
                 self.tabBarItem.title = @"Activity";
            
                 [feedDescDisplayArray removeAllObjects];
                 [feedDescDisplayArray addObjectsFromArray:filterDescArray];
                 [feedImageArray removeAllObjects];
                 [feedImageArray addObjectsFromArray:filterImageArray];
            
                 [feedImagesArrayFromDirectory removeAllObjects];
                 [feedImagesArrayFromDirectory addObjectsFromArray:filterFeedImagesArrayFromDirectory];
            
                 [actorTypeArray removeAllObjects];
                 [actorTypeArray addObjectsFromArray:filterTypeArray];
                 [actorIdArray removeAllObjects];
                 [actorIdArray addObjectsFromArray:filterIdArray];
            
                 [actorNameArray removeAllObjects];
                 [actorNameArray addObjectsFromArray:filterNameArray];
                 [actorUrlArray removeAllObjects];
                 [actorUrlArray addObjectsFromArray:filterUrlArray];
                 [actorTaglineArray removeAllObjects];
                 [actorTaglineArray addObjectsFromArray:filterTaglineArray];
            
            [targetTypeArray removeAllObjects];
            [targetTypeArray addObjectsFromArray:filterTypeArrayTarget];            
            [targetIdArray removeAllObjects];
            [targetIdArray addObjectsFromArray:filterIdArrayTarget];
            [targetImageArray removeAllObjects];
            [targetImageArray addObjectsFromArray:filterImageArrayTarget];
            [targetNameArray removeAllObjects];
            [targetNameArray addObjectsFromArray:filterNameArrayTarget];
            [targetUrlArray removeAllObjects];
            [targetUrlArray addObjectsFromArray:filterUrlArrayTarget];
            [targetTaglineArray removeAllObjects];
            [targetTaglineArray addObjectsFromArray:filterTaglineArrayTarget];
            
            [feedType removeAllObjects];
            [feedType addObjectsFromArray:filterFeedType];

            
                 [table reloadData];
                [self startLoadingImagesConcurrently];
                 _showFilterMenu = FALSE;
                [filtersContainer setSelected:FALSE];
          
            [self performSelector:@selector(animateFilter) withObject:nil afterDelay:0.05];
                 break;
            
              //Implement Introduced    
        case 3 : _filterIntroduced = TRUE;
                 for(int k=0; k<[feedDescDisplayArray count];k++)
                 {
                     NSString *checkStr = [feedDescDisplayArray objectAtIndex:k];
                     if([checkStr rangeOfString:@"took intro"].location != NSNotFound)
                     {
                         [filterDescArray addObject:[feedDescDisplayArray objectAtIndex:k]];
                         [filterImageArray addObject:[feedImageArray objectAtIndex:k]];
                         
                         [filterFeedImagesArrayFromDirectory addObject:[feedImagesArrayFromDirectory objectAtIndex:k]];
                         
                         [filterTypeArray addObject:[actorTypeArray objectAtIndex:k]];
                         [filterIdArray addObject:[actorIdArray objectAtIndex:k]];
                         
                         [filterNameArray addObject:[actorNameArray objectAtIndex:k]];
                         [filterUrlArray addObject:[actorUrlArray objectAtIndex:k]];
                         [filterTaglineArray addObject:[actorTaglineArray objectAtIndex:k]];
                         
                         [filterTypeArrayTarget addObject:[targetTypeArray objectAtIndex:k]];
                         [filterIdArrayTarget addObject:[targetIdArray objectAtIndex:k]];
                         [filterImageArrayTarget addObject:[targetImageArray objectAtIndex:k]];
                         [filterNameArrayTarget addObject:[targetNameArray objectAtIndex:k]];
                         [filterUrlArrayTarget addObject:[targetUrlArray objectAtIndex:k]];
                         [filterTaglineArrayTarget addObject:[targetTaglineArray objectAtIndex:k]];                         
                         [filterFeedType addObject:[feedType objectAtIndex:k]];

                     }
                 } 

                 label.text = @"Activity - Introduced";
                 self.tabBarItem.title = @"Activity";
            
                 [feedDescDisplayArray removeAllObjects];
                 [feedDescDisplayArray addObjectsFromArray:filterDescArray];
                 [feedImageArray removeAllObjects];
                 [feedImageArray addObjectsFromArray:filterImageArray]; 
            
                 [feedImagesArrayFromDirectory removeAllObjects];
                 [feedImagesArrayFromDirectory addObjectsFromArray:filterFeedImagesArrayFromDirectory];
            
                 [actorTypeArray removeAllObjects];
                 [actorTypeArray addObjectsFromArray:filterTypeArray];
                 [actorIdArray removeAllObjects];
                 [actorIdArray addObjectsFromArray:filterIdArray];
            
                 [actorNameArray removeAllObjects];
                 [actorNameArray addObjectsFromArray:filterNameArray];
                 [actorUrlArray removeAllObjects];
                 [actorUrlArray addObjectsFromArray:filterUrlArray];
                 [actorTaglineArray removeAllObjects];
                 [actorTaglineArray addObjectsFromArray:filterTaglineArray];
            
            [targetTypeArray removeAllObjects];
            [targetTypeArray addObjectsFromArray:filterTypeArrayTarget];            
            [targetIdArray removeAllObjects];
            [targetIdArray addObjectsFromArray:filterIdArrayTarget];
            [targetImageArray removeAllObjects];
            [targetImageArray addObjectsFromArray:filterImageArrayTarget];
            [targetNameArray removeAllObjects];
            [targetNameArray addObjectsFromArray:filterNameArrayTarget];
            [targetUrlArray removeAllObjects];
            [targetUrlArray addObjectsFromArray:filterUrlArrayTarget];
            [targetTaglineArray removeAllObjects];
            [targetTaglineArray addObjectsFromArray:filterTaglineArrayTarget];
            
            [feedType removeAllObjects];
            [feedType addObjectsFromArray:filterFeedType];
            
                 [table reloadData];
                 [self startLoadingImagesConcurrently];
                 _showFilterMenu = FALSE;
                 [filtersContainer setSelected:FALSE];
            
                 [self performSelector:@selector(animateFilter) withObject:nil afterDelay:0.05];
                 break; 
            
            //Implement All    
        case 4 : _filterFollowed = FALSE;
                 _filterInvested = FALSE;
                 _filterUpdated = FALSE;
                 _filterIntroduced = FALSE;
                 [table reloadData];
                 [self startLoadingImagesConcurrently];
                 label.text = @"Activity";
                 self.tabBarItem.title = @"Activity";
            
                 _showFilterMenu = FALSE;
                 [filtersContainer setSelected:FALSE];
         
                 [self performSelector:@selector(animateFilter) withObject:nil afterDelay:0.05];
                 break;    
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void) dealloc
{
    [feedDescArray release];
    [feedDescDisplayArray release];
    [feedImageArray release];
    
    [feedImagesArrayFromDirectory release];
    
    [completeActorTypeArray release];
    [completeActorIdArray release];
    [completeActorNameArray release];
    [completeActorUrlArray release];
    [completeActorTaglineArray release];
    
    [actorTypeArray release];
    [actorIdArray release];
    [actorNameArray release];
    [actorUrlArray release];
    [actorTaglineArray release];
    
    [targetTypeArray release];
    [targetIdArray release];
    [targetNameArray release];
    [targetUrlArray release];
    [targetTaglineArray release];
    
    [completeFeedDescDisplayArray release];
    [completeFeedImageArray release];
    [completeFeedImagesArrayFromDirectory release];
    
    [filterDescArray release];
    [filterImageArray release];
    [filterFeedImagesArrayFromDirectory release];
    
    [filterNameArray release];
    [filterUrlArray release];
    [filterTaglineArray release];
    
    [userFollowingIds release];
    [super dealloc];
}

// To support orientations
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
