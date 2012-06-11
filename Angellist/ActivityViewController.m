//
//  FirstViewController.m
//  SampleTabbar
//
//  Created by Ram Charan on 5/16/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ActivityViewController.h"
#import "ActivityDetailsViewController.h"
#import "AsyncImageView.h"
#import "Reachability.h"

@implementation ActivityViewController

NSMutableArray *feedDescArray;
NSMutableArray *feedDescDisplayArray;
NSMutableArray *feedImageArray;

NSMutableArray *feedImagesArrayFromDirectory;
NSMutableArray *completeFeedImagesArrayFromDirectory;

NSMutableArray *actorTypeArray;
NSMutableArray *actorIdArray;
NSMutableArray *actorNameArray;
NSMutableArray *actorUrlArray;
NSMutableArray *actorTaglineArray;

NSMutableArray *completeActorTypeArray;
NSMutableArray *completeActorIdArray;
NSMutableArray *completeActorNameArray;
NSMutableArray *completeActorUrlArray;
NSMutableArray *completeActorTaglineArray;

NSMutableArray *completeFeedDescDisplayArray;
NSMutableArray *completeFeedImageArray;

NSMutableArray *filterDescArray;
NSMutableArray *filterImageArray;

NSMutableArray *filterFeedImagesArrayFromDirectory;

NSMutableArray *filterTypeArray;
NSMutableArray *filterIdArray;
NSMutableArray *filterNameArray;
NSMutableArray *filterUrlArray;
NSMutableArray *filterTaglineArray;

NSArray *_filterNames;
int _rowNumberInActivity = 0;
BOOL _showFilterMenu = FALSE;

NSMutableArray *userFollowingIds;

extern BOOL _transitFromActivity;
extern BOOL _transitFromStartUps;

extern NSString *_currUserId;

int countDownForView = 0;
float alphaValue = 1.0;
NSTimer *timer;
UIView *notReachable;
UIButton *filterButton;

BOOL _dataLoaded = FALSE;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Recent Activity";
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
    
    
    //---create new cell if no reusable cell is available---
    if (cell == nil) 
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
//    else 
//    {
//        AsyncImageView* oldImage = (AsyncImageView*)
//        [cell.contentView viewWithTag:999];
//        [oldImage removeFromSuperview];
//    }
    
    //---set the text to display for the cell---
    NSString *cellValue = [feedDescDisplayArray objectAtIndex:indexPath.row]; 
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) 
    {
        UILabel *cellTextLabel = [[[UILabel alloc] initWithFrame:CGRectMake(80, 7, 240, 75)] autorelease];
        cellTextLabel.lineBreakMode = UILineBreakModeWordWrap;
        cellTextLabel.numberOfLines = 50;
        cellTextLabel.text = cellValue;
        cellTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
        [cell.contentView addSubview:cellTextLabel];
        
        UIImage *image = [UIImage imageWithContentsOfFile:[feedImagesArrayFromDirectory objectAtIndex:indexPath.row]];
        UIImageView *cellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(7, 7, 70, 70)];
        cellImageView.image = image;
        [cell.contentView addSubview:cellImageView];
        [cellImageView release];
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

//---set the number of rows in the table view---
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{ 
    return [feedDescDisplayArray count];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _rowNumberInActivity = indexPath.row;

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
    if (selection){
        [table deselectRowAtIndexPath:selection animated:YES];
    }
    
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void) getUserFollowingDetails
{
    //Check for the availability of Internet
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
    {
//        UIAlertView *myAlert = [[[UIAlertView alloc] initWithTitle:@"No Internet Connection" message:@"Please turn on wi-fi." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease];
//        [myAlert show];
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

-(void) getStartUpFollowingDetails
{
    //Check for the availability of Internet
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
    {
//        UIAlertView *myAlert = [[[UIAlertView alloc] initWithTitle:@"No Internet Connection" message:@"Please turn on wi-fi." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease];
//        [myAlert show];
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
    
    notReachable = [[UIView alloc] initWithFrame:CGRectMake(100, 140, 118, 118)];
    notReachable.alpha = 0;
    [notReachable.layer setCornerRadius:10.0f];
    notReachable.backgroundColor = [UIColor blackColor];
    [self.view addSubview:notReachable];
    
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
    
    _filterNames = [[NSArray arrayWithObjects:@"Followed", @"Invested", @"New Status", @"Took Intro", @"All", nil] retain];
    
    //Add background image to navigation title bar
    UIImage *backgroundImage = [UIImage imageNamed:@"navigationbar.png"];
    [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    
    self.tabBarItem.title = @"Activity";
    
    //Add image to navigation bar button
    UIImage* image = [UIImage imageNamed:@"filter.png"];
    CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
    filterButton = [[UIButton alloc] initWithFrame:frame];
    [filterButton setBackgroundImage:image forState:UIControlStateNormal];
    [filterButton addTarget:self action:@selector(filterButtonSelected:) forControlEvents:UIControlStateHighlighted];
    
    UIBarButtonItem* filterButtonItem = [[UIBarButtonItem alloc] initWithCustomView:filterButton];
    self.navigationItem.rightBarButtonItem = filterButtonItem;
    [filterButtonItem release];
    [filterButton release];
    
    
    
    feedDescArray = [[NSMutableArray alloc] init];
    feedDescDisplayArray = [[NSMutableArray alloc] init];
    feedImageArray = [[NSMutableArray alloc] init];
    
    feedImagesArrayFromDirectory = [[NSMutableArray alloc] init];
    completeFeedImagesArrayFromDirectory = [[NSMutableArray alloc] init];
    
    completeFeedDescDisplayArray = [[NSMutableArray alloc] init];
    completeFeedImageArray = [[NSMutableArray alloc] init];
    
    completeActorTypeArray = [[NSMutableArray alloc] init];
    completeActorIdArray = [[NSMutableArray alloc] init];
    completeActorNameArray = [[NSMutableArray alloc] init];
    completeActorUrlArray = [[NSMutableArray alloc] init];
    completeActorTaglineArray = [[NSMutableArray alloc] init];
    
    actorTypeArray = [[NSMutableArray alloc] init];
    actorIdArray = [[NSMutableArray alloc] init];
    actorNameArray = [[NSMutableArray alloc] init];
    actorUrlArray = [[NSMutableArray alloc] init];
    actorTaglineArray = [[NSMutableArray alloc] init];
    
    
    
    filterDescArray = [[NSMutableArray alloc] init];
    filterImageArray = [[NSMutableArray alloc] init];
    
    filterTypeArray = [[NSMutableArray alloc] init];
    filterIdArray = [[NSMutableArray alloc] init];
    filterNameArray = [[NSMutableArray alloc] init];
    filterUrlArray = [[NSMutableArray alloc] init];
    filterTaglineArray = [[NSMutableArray alloc] init];
    
    filterFeedImagesArrayFromDirectory = [[NSMutableArray alloc] init];
    
    userFollowingIds = [[NSMutableArray alloc] init];
//////////////////////////////////////////////////////////////////////////////////////    
    _dbmanager.feedImagesArrayFromDirectoryFromDB = [[[NSMutableArray alloc] init] autorelease];
    _dbmanager.actorTypeArrayFromDB = [[[NSMutableArray alloc] init] autorelease];
    _dbmanager.actorIdArrayFromDB = [[[NSMutableArray alloc] init] autorelease];
    _dbmanager.actorNameArrayFromDB = [[[NSMutableArray alloc] init] autorelease];
    _dbmanager.actorUrlArrayFromDB = [[[NSMutableArray alloc] init] autorelease];
    _dbmanager.actorTaglineArrayFromDB = [[[NSMutableArray alloc] init] autorelease];
    _dbmanager.feedDescDisplayArrayFromDB = [[[NSMutableArray alloc] init] autorelease];
    _dbmanager.feedImageArrayFromDB = [[[NSMutableArray alloc] init] autorelease];
//////////////////////////////////////////////////////////////////////////////////////    
    [self performSelectorInBackground:@selector(getUserFollowingDetails) withObject:nil];
    [self performSelectorInBackground:@selector(getStartUpFollowingDetails) withObject:nil];
    
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
        //Get feeds
        NSURL *url = [NSURL URLWithString:@"https://api.angel.co/1/feed"];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod: @"GET"];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[[[NSOperationQueue alloc] init] autorelease]
                               completionHandler:^(NSURLResponse *response,
                                                   NSData *data,
                                                   NSError *error) 
         {
             if ([data length] >0 && error == nil)
             {
                 NSError* error;
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
                 
                 for(int z=0; z<[feedDescArray count]; z++)
                 {
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
                 [self saveImagesOfFeeds];
                 [table reloadData];
             }
             else if ([data length] == 0 && error == nil)
             {
                 NSLog(@"Nothing was downloaded.");
             }
             else if (error != nil)
             {
                 NSLog(@"Error = %@", error);
             }         
         }];
    }
    [super viewDidLoad];

}


-(void) saveImagesOfFeeds
{
    for(int imageNumber=1; imageNumber<=[completeFeedImageArray count]; imageNumber++)
    {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"feeduser%d.png",imageNumber]];
        
        UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[completeFeedImageArray objectAtIndex:(imageNumber-1)]]]]];
        NSData *imageData = UIImagePNGRepresentation(image);
        [imageData writeToFile:savedImagePath atomically:NO];
        
        [image release];
        
        [feedImagesArrayFromDirectory addObject:savedImagePath];
        [completeFeedImagesArrayFromDirectory addObject:savedImagePath];
    }
    [self saveFeedsDataToDB];
}

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
        
        NSString *feedImagePath = [NSString stringWithFormat:@"%@",[completeFeedImagesArrayFromDirectory objectAtIndex:k]];
        
        [_dbmanager insertRecordIntoActivityTable:@"Activity" withField1:@"activityId" field1Value:activityId andField2:@"feedDescription" field2Value:feedDescription andField3:@"feedImageUrl" field3Value:feedImageUrl andField4:@"actorType" field4Value:actorType andField5:@"actorId" field5Value:actorId andField6:@"actorName" field6Value:actorName andField7:@"actorUrl" field7Value:actorUrl andField8:@"actorTagline" field8Value:actorTagline andField9:@"feedImagePath" field9Value:feedImagePath];
    }
}

-(void) fadeView
{
    if(countDownForView < 35)
    {
        countDownForView++;
        notReachable.alpha = alphaValue;
        alphaValue = alphaValue - 0.03;
    }
    else
    {
        [timer invalidate];
        [filterButton setUserInteractionEnabled:YES];
    }
}

- (void)filterButtonSelected:(id)sender {
    // whatever needs to happen when button is tapped
    
    //Check for the availability of Internet
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
    {
        [filterButton setUserInteractionEnabled:NO];
        timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(fadeView) userInfo:nil repeats:YES];
        alphaValue = 1.0;
        countDownForView = 0;
    }
    else
    {
        UIView *filtersList;
        
        if(_showFilterMenu == FALSE)
        {
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) 
            {
                UIView *filterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
                [filterView  setBackgroundColor: [UIColor blackColor]];
                [filterView setAlpha:0.6f];
                filterView.tag = 1000;
                [self.view addSubview:filterView];
                
                filtersList = [[UIView alloc] initWithFrame:CGRectMake(165, 0, 150, 145)];
                [filtersList  setBackgroundColor: [UIColor blackColor]];
                [filtersList.layer setCornerRadius:18.0f];
                [filtersList setAlpha:1.0f];
                filtersList.tag = 1001;
                [self.view addSubview:filtersList];
                
                UIImage* image = [UIImage imageNamed:@"navigationbar.png"];
                
                int _yPos = 5;
                
                for (int i=1; i<=5; i++) 
                {
                    UIButton *filterButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    [filterButton setBackgroundImage:image forState:UIControlStateNormal];
                    [filterButton setTitle:[NSString stringWithFormat:@"%@",[_filterNames objectAtIndex:(i-1)]] forState:UIControlStateNormal];
                    [filterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [filterButton addTarget:self action:@selector(getFilteredList:) forControlEvents:UIControlStateHighlighted];
                    filterButton.frame = CGRectMake(14, _yPos, 120, 25);
                    filterButton.tag = i;
                    [filtersList addSubview:filterButton];
                    
                    _yPos = _yPos + 27;
                }
                
                
                [filtersList release];
                [filterView release];
                
                _showFilterMenu = TRUE;
            }
            else
            {
                UIView *filterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
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
                
                UIImage* image = [UIImage imageNamed:@"navigationbar.png"];
                
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
            [[self.view viewWithTag:1000] removeFromSuperview];
            [[self.view viewWithTag:1001] removeFromSuperview];
            _showFilterMenu = FALSE;
        }
    } 
}

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
    
    int _tagID = [sender tag];
    
    switch(_tagID)
    {
            //Implement Following
        case 1 : for(int k=0; k<[feedDescDisplayArray count];k++)
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
                         
                     }
                 }
                
                 self.title = @"Recent Activity - Followed";
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
            
                 _showFilterMenu = FALSE;
                 [[self.view viewWithTag:1000] removeFromSuperview];
                 [[self.view viewWithTag:1001] removeFromSuperview];
                 [table reloadData];
                break;
            
            //Implement Invested    
        case 2 : for(int k=0; k<[feedDescDisplayArray count];k++)
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
                     }
                 } 

                 self.title = @"Recent Activity - Invested";
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
            
                 [table reloadData];
                 _showFilterMenu = FALSE;
                 [[self.view viewWithTag:1000] removeFromSuperview];
                 [[self.view viewWithTag:1001] removeFromSuperview];
                 break;
            
            //Implement Updated    
        case 3 : for(int k=0; k<[feedDescDisplayArray count];k++)
                 {
                     NSString *checkStr = [feedDescDisplayArray objectAtIndex:k];
                     if([checkStr rangeOfString:@"updated"].location != NSNotFound)
                     {
                         [filterDescArray addObject:[feedDescDisplayArray objectAtIndex:k]];
                         [filterImageArray addObject:[feedImageArray objectAtIndex:k]];
                         
                         [filterFeedImagesArrayFromDirectory addObject:[feedImagesArrayFromDirectory objectAtIndex:k]];
                         
                         [filterTypeArray addObject:[actorTypeArray objectAtIndex:k]];
                         [filterIdArray addObject:[actorIdArray objectAtIndex:k]];
                         
                         [filterNameArray addObject:[actorNameArray objectAtIndex:k]];
                         [filterUrlArray addObject:[actorUrlArray objectAtIndex:k]];
                         [filterTaglineArray addObject:[actorTaglineArray objectAtIndex:k]];
                     }
                 } 

                 self.title = @"Recent Activity - Updated";
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
            
                 [table reloadData]; 
                 _showFilterMenu = FALSE;
                 [[self.view viewWithTag:1000] removeFromSuperview];
                 [[self.view viewWithTag:1001] removeFromSuperview]; 
                 break;
            
            //Implement Took Intro    
        case 4 : for(int k=0; k<[feedDescDisplayArray count];k++)
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
                     }
                 } 

                 self.title = @"Recent Activity - Took intro";
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
            
                 [table reloadData];
                 _showFilterMenu = FALSE;
                 [[self.view viewWithTag:1000] removeFromSuperview];
                 [[self.view viewWithTag:1001] removeFromSuperview];
                 break; 
            
            //Implement All    
        case 5 : [table reloadData];
                 self.title = @"Recent Activity";
                 self.tabBarItem.title = @"Activity";
            
                 _showFilterMenu = FALSE;
                 [[self.view viewWithTag:1000] removeFromSuperview];
                 [[self.view viewWithTag:1001] removeFromSuperview];
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
