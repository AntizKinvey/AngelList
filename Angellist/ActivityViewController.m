//
//  ActivityViewController.m
//  TableProj
//
//  Created by Ram Charan on 8/24/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import "ActivityViewController.h"
#import "Reachability.h"

#import "ActivityDetailsViewController.h"
#import "SearchViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation ActivityViewController

NSMutableArray *feedDescDisplayArray;
NSMutableArray *completeFeedDescDisplayArray;
NSMutableArray *feedIdArray;
NSMutableArray *completeFeedIdArray;
NSMutableArray *feedItemTypeArray;
NSMutableArray *completeFeedItemTypeArray;

NSMutableArray *actorNameArray;
NSMutableArray *completeActorNameArray;
NSMutableArray *actorImageUrlArray;
NSMutableArray *completeActorImageUrlArray;
NSMutableArray *actorLinkArray;
NSMutableArray *completeActorLinkArray;
NSMutableArray *actorTaglineArray;
NSMutableArray *completeActorTaglineArray;

NSMutableArray *feedActorImageDisplayArray;
NSMutableArray *completeFeedActorImageDisplayArray;
NSMutableArray *feedTargetImageDisplayArray;
NSMutableArray *completeFeedTargetImageDisplayArray;

NSMutableArray *targetNameArray;
NSMutableArray *completeTargetNameArray;
NSMutableArray *targetImageUrlArray;
NSMutableArray *completeTargetImageUrlArray;
NSMutableArray *targetLinkArray;
NSMutableArray *completeTargetLinkArray;
NSMutableArray *targetTaglineArray;
NSMutableArray *completeTargetTaglineArray;


//////////////////////////
NSMutableArray *filterFeedDescDisplayArray;
NSMutableArray *filterFeedIdArray;
NSMutableArray *filterFeedItemTypeArray;

NSMutableArray *filterActorNameArray;
NSMutableArray *filterActorImageUrlArray;
NSMutableArray *filterActorLinkArray;
NSMutableArray *filterActorTaglineArray;

NSMutableArray *filterFeedActorImageDisplayArray;
NSMutableArray *filterFeedTargetImageDisplayArray;

NSMutableArray *filterTargetNameArray;
NSMutableArray *filterTargetImageUrlArray;
NSMutableArray *filterTargetLinkArray;
NSMutableArray *filterTargetTaglineArray;



///////////////
NSMutableArray *latestfeedDescDisplayArray;
NSMutableArray *latestFeedIdArray;
NSMutableArray *latestFeedItemTypeArray;

NSMutableArray *latestActorNameArray;
NSMutableArray *latestActorImageUrlArray;
NSMutableArray *latestActorLinkArray;
NSMutableArray *latestActorTaglineArray;

NSMutableArray *latestFeedActorImageDisplayArray;
NSMutableArray *latestFeedTargetImageDisplayArray;

NSMutableArray *latestTargetNameArray;
NSMutableArray *latestTargetImageUrlArray;
NSMutableArray *latestTargetLinkArray;
NSMutableArray *latestTargetTaglineArray;


NSMutableArray *userDetailsArray;
//////////////
UIView *refreshViewTop;
UIImageView *imageViewTop;
UIImageView *imageViewLogoTop;
BOOL isLoadingTop = FALSE;
UIActivityIndicatorView *refreshSpinnerTop;

UIView *refreshViewBottom;
UIImageView *imageViewBottom;
UIImageView *imageViewLogoBottom;
BOOL isLoadingBottom = FALSE;
UIActivityIndicatorView *refreshSpinnerBottom;
//////////////

int feedPageNumber = 1;
int feedImagesToBeDownloadedForAandT = 0;

BOOL latestFeedsFlag = FALSE;
int numberOfFeedsDisplayed = 0;

int _rowNumberInActivity = 0;

BOOL _showFilterMenu = FALSE;

BOOL _filterFollowed = FALSE;
BOOL _filterInvested = FALSE;
BOOL _filterIntroduced = FALSE;

UILabel *navigationBarLabel;
UITapGestureRecognizer *activityFilterTap;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //self.title = @"Activity";
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
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
    
    
    UIImageView *cellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(7, 9, 50, 50)];
    cellImageView.image = [feedActorImageDisplayArray objectAtIndex:indexPath.row];
    cellImageView.layer.cornerRadius = 3.5f;
    cellImageView.layer.masksToBounds = YES;
    [cell.contentView addSubview:cellImageView];
    [cellImageView release];
    
    
    
    // label to display description
    NSString *text = [feedDescDisplayArray objectAtIndex:indexPath.row];
    CGSize constraint = CGSizeMake(210, 20000.0f);
    CGSize size = [text sizeWithFont:[UIFont fontWithName:@"Helvetica-Light" size:14] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    UILabel *cellTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 9, 230, size.height)];
    cellTextLabel.lineBreakMode = UILineBreakModeWordWrap;
    cellTextLabel.numberOfLines = 50;
    cellTextLabel.backgroundColor = [UIColor clearColor];
    cellTextLabel.text = text;
    cellTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    [cell.contentView addSubview:cellTextLabel];
    [cellTextLabel release];
    
    refreshViewBottom.frame = CGRectMake(0, [table contentSize].height, 320, 52);
    
    return cell; 
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{ 
//    if(([feedDescDisplayArray count] == 0) && ((_filterFollowed == TRUE) || (_filterInvested == TRUE) || (_filterIntroduced == TRUE)))
//    {
//        emptyAlertView.hidden = NO;
//    }
    if([feedDescDisplayArray count] == 0)
    {
        emptyAlertView.hidden = NO;
    }
    if([feedDescDisplayArray count] != 0)
    { 
        emptyAlertView.hidden = YES;
    }
    
    return [feedDescDisplayArray count];
}

// --dynamic cell height according to the text--
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *text = [feedDescDisplayArray objectAtIndex:[indexPath row]];
    CGSize constraint = CGSizeMake(210, 20000.0f); 
    CGSize size = [text sizeWithFont:[UIFont fontWithName:@"Helvetica-Light" size:14] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap]; 
    // constratins the size of the table row according to the text
    
    CGFloat height = MAX(size.height,60);
    
    return height + (15);
    // return the height of the particular row in the table view
}

// --navigate to activity details--
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _rowNumberInActivity = indexPath.row;
    
    ActivityDetailsViewController *detailsViewController;
    detailsViewController = [[[ActivityDetailsViewController alloc] initWithNibName:@"ActivityDetailsViewController_iPhone" bundle:nil] autorelease];
    
    [self.navigationController pushViewController:detailsViewController animated:YES];
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    _dbmanager = [DBManager new];
    [_dbmanager openDB];
    
    feedDescDisplayArray = [NSMutableArray new];
    completeFeedDescDisplayArray = [NSMutableArray new];
    feedIdArray = [NSMutableArray new];
    completeFeedIdArray = [NSMutableArray new];
    feedItemTypeArray = [NSMutableArray new];
    completeFeedItemTypeArray = [NSMutableArray new];
    
    actorNameArray = [NSMutableArray new];
    completeActorNameArray = [NSMutableArray new];
    actorImageUrlArray = [NSMutableArray new];
    completeActorImageUrlArray = [NSMutableArray new];
    actorLinkArray = [NSMutableArray new];
    completeActorLinkArray = [NSMutableArray new];
    actorTaglineArray = [NSMutableArray new];
    completeActorTaglineArray = [NSMutableArray new];
    
    feedActorImageDisplayArray = [NSMutableArray new];
    completeFeedActorImageDisplayArray = [NSMutableArray new];
    feedTargetImageDisplayArray = [NSMutableArray new];
    completeFeedTargetImageDisplayArray = [NSMutableArray new];
    
    targetNameArray = [NSMutableArray new];
    completeTargetNameArray = [NSMutableArray new];
    targetImageUrlArray = [NSMutableArray new];
    completeTargetImageUrlArray = [NSMutableArray new];
    targetLinkArray = [NSMutableArray new];
    completeTargetLinkArray = [NSMutableArray new];
    targetTaglineArray = [NSMutableArray new];
    completeTargetTaglineArray = [NSMutableArray new];
    
    ///////////////////////////////////////////////////////////////////
    
    filterFeedDescDisplayArray = [NSMutableArray new];
    filterFeedIdArray = [NSMutableArray new];
    filterFeedItemTypeArray = [NSMutableArray new];
    
    filterActorNameArray = [NSMutableArray new];
    filterActorImageUrlArray = [NSMutableArray new];
    filterActorLinkArray = [NSMutableArray new];
    filterActorTaglineArray = [NSMutableArray new];
    
    filterFeedActorImageDisplayArray = [NSMutableArray new];
    filterFeedTargetImageDisplayArray = [NSMutableArray new];
    
    filterTargetNameArray = [NSMutableArray new];
    filterTargetImageUrlArray = [NSMutableArray new];
    filterTargetLinkArray = [NSMutableArray new];
    filterTargetTaglineArray = [NSMutableArray new];
    
    ///////////////////////////////////////////////////////////////////
    latestfeedDescDisplayArray = [NSMutableArray new];
    latestFeedIdArray = [NSMutableArray new];
    latestFeedItemTypeArray = [NSMutableArray new];
    
    latestActorNameArray = [NSMutableArray new];
    latestActorImageUrlArray = [NSMutableArray new];
    latestActorLinkArray = [NSMutableArray new];
    latestActorTaglineArray = [NSMutableArray new];
    
    latestFeedActorImageDisplayArray = [NSMutableArray new];
    latestFeedTargetImageDisplayArray = [NSMutableArray new];
    
    latestTargetNameArray = [NSMutableArray new];
    latestTargetImageUrlArray = [NSMutableArray new];
    latestTargetLinkArray = [NSMutableArray new];
    latestTargetTaglineArray = [NSMutableArray new];
    
    
    userDetailsArray = [NSMutableArray new];
    ///////////////////////////////////////////////////////////////////    
    
//    _dbmanager.feedDescDisplayArrayFromDB = [NSMutableArray new];
//    _dbmanager.feedIdArrayFromDB = [NSMutableArray new];
//    _dbmanager.feedItemTypeArrayFromDB = [NSMutableArray new];
//    _dbmanager.actorNameArrayFromDB = [NSMutableArray new];
//    _dbmanager.feedActorImageDisplayArrayFromDB = [NSMutableArray new];
//    _dbmanager.actorLinkArrayFromDB = [NSMutableArray new];
//    _dbmanager.actorTaglineArrayFromDB = [NSMutableArray new];
//    _dbmanager.targetNameArrayFromDB = [NSMutableArray new];
//    _dbmanager.feedTargetImageDisplayArrayFromDB = [NSMutableArray new];
//    _dbmanager.targetLinkArrayFromDB = [NSMutableArray new];
//    _dbmanager.targetTaglineArrayFromDB = [NSMutableArray new];
//    _dbmanager.actorImageUrlArrayFromDB = [NSMutableArray new];
//    _dbmanager.targetImageUrlArrayFromDB = [NSMutableArray new];
//    
//    
//    _dbmanager.userDetailsArrayFromDB = [NSMutableArray new];
    
    _dbmanager.feedDescDisplayArrayFromDB = [[NSMutableArray new] autorelease];
    _dbmanager.feedIdArrayFromDB = [[NSMutableArray new] autorelease];
    _dbmanager.feedItemTypeArrayFromDB = [[NSMutableArray new] autorelease];
    _dbmanager.actorNameArrayFromDB = [[NSMutableArray new] autorelease];
    _dbmanager.feedActorImageDisplayArrayFromDB = [[NSMutableArray new] autorelease];
    _dbmanager.actorLinkArrayFromDB = [[NSMutableArray new] autorelease];
    _dbmanager.actorTaglineArrayFromDB = [[NSMutableArray new] autorelease];
    _dbmanager.targetNameArrayFromDB = [[NSMutableArray new] autorelease];
    _dbmanager.feedTargetImageDisplayArrayFromDB = [[NSMutableArray new] autorelease];
    _dbmanager.targetLinkArrayFromDB = [[NSMutableArray new] autorelease];
    _dbmanager.targetTaglineArrayFromDB = [[NSMutableArray new] autorelease];
    _dbmanager.actorImageUrlArrayFromDB = [[NSMutableArray new] autorelease];
    _dbmanager.targetImageUrlArrayFromDB = [[NSMutableArray new] autorelease];
    
    _dbmanager.userDetailsArrayFromDB = [[NSMutableArray new] autorelease];
    //Re - Initialise variables that works for 2nd login 
    feedPageNumber = 1;
    feedImagesToBeDownloadedForAandT = 0;
    latestFeedsFlag = FALSE;
    numberOfFeedsDisplayed = 0;
    _rowNumberInActivity = 0;
    _showFilterMenu = FALSE;
    _filterFollowed = FALSE;
    _filterInvested = FALSE;
    _filterIntroduced = FALSE;
    
    [super viewDidLoad];
    
    self.navigationController.navigationBar.frame = CGRectMake(0, 0, 320, 45);
    
    //Navigation Bar Label
    navigationBarLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 260, 20)];
    navigationBarLabel.textAlignment = UITextAlignmentCenter;
    navigationBarLabel.textColor = [UIColor whiteColor];
    navigationBarLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
    navigationBarLabel.backgroundColor = [UIColor clearColor];
    navigationBarLabel.text = @"Activity";
    [self.navigationController.navigationBar addSubview:navigationBarLabel];
    [navigationBarLabel release];
    
    
    //Search Button
    UIButton *buttonSearch = [[UIButton alloc] init];
    buttonSearch.frame = CGRectMake(0, 0, 52, 45);
    [buttonSearch setImage:[UIImage imageNamed:@"search.png"] forState:UIControlStateNormal];
    [buttonSearch addTarget:self action:@selector(goToSearch) forControlEvents:UIControlStateHighlighted];
    buttonSearch.enabled = YES;
    
    UIBarButtonItem *barButtonSearch = [[UIBarButtonItem alloc] initWithCustomView:buttonSearch];
    self.navigationItem.rightBarButtonItem = barButtonSearch;
    [barButtonSearch release];
    [buttonSearch release];
    
    ////////////////////////////// PULL TO REFRESH //////////////////////////////
    
    refreshViewTop = [[UIView alloc] initWithFrame:CGRectMake(0, -52, 320, 52)];
    
    imageViewTop = [[UIImageView alloc] initWithFrame:CGRectMake(50, 5, 20, 45)];
    imageViewTop.image = [UIImage imageNamed:@"refresh_arrow.png"];
    imageViewTop.transform = CGAffineTransformMakeRotation(3.142);
    [refreshViewTop addSubview:imageViewTop];
    [imageViewTop release];
    
    imageViewLogoTop = [[UIImageView alloc] initWithFrame:CGRectMake(200, 5, 86, 36)];
    imageViewLogoTop.image = [UIImage imageNamed:@"angel_logo.png"];
    [refreshViewTop addSubview:imageViewLogoTop];
    [imageViewLogoTop release];
    
    refreshSpinnerTop = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(50, 5, 20, 20)];
    refreshSpinnerTop.hidden = YES;
    [refreshViewTop addSubview:refreshSpinnerTop];
    [refreshSpinnerTop release];
    
    [table addSubview:refreshViewTop];
    [refreshViewTop release];
    
    ////////////////////////////// PULL TO REFRESH //////////////////////////////
    
    ////////////////////////////// PUSH TO REFRESH //////////////////////////////
    refreshViewBottom = [[UIView alloc] initWithFrame:CGRectMake(0, [table contentSize].height, 320, 52)];
    
    imageViewBottom = [[UIImageView alloc] initWithFrame:CGRectMake(50, 5, 20, 45)];
    imageViewBottom.image = [UIImage imageNamed:@"refresh_arrow.png"];
    [refreshViewBottom addSubview:imageViewBottom];
    [imageViewBottom release];
    
    imageViewLogoBottom = [[UIImageView alloc] initWithFrame:CGRectMake(180, 5, 124, 45)];
    imageViewLogoBottom.image = [UIImage imageNamed:@"kinvey_logo.png"];
    [refreshViewBottom addSubview:imageViewLogoBottom];
    [imageViewLogoBottom release];
    
    refreshSpinnerBottom = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(50, 5, 20, 20)];
    refreshSpinnerBottom.hidden = YES;
    [refreshViewBottom addSubview:refreshSpinnerBottom];
    [refreshSpinnerBottom release];
    
    [table addSubview:refreshViewBottom];
    [refreshViewBottom release];
    ////////////////////////////// PUSH TO REFRESH //////////////////////////////
    
    //retrieve userDetails
    [_dbmanager retrieveUserDetails];
    [userDetailsArray removeAllObjects];
    [userDetailsArray addObjectsFromArray:_dbmanager.userDetailsArrayFromDB];
    
    
    loadingView.hidden = NO;
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(invokeLoadFeeds) userInfo:nil repeats:NO];
    
}

-(void) invokeLoadFeeds
{
    //load feeds
    [self loadFeeds:feedPageNumber];
    [table reloadData];
}

-(void) loadFeeds:(int)pageNo
{
    //Check for the availability of Internet
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
    {
        [_dbmanager retrieveActivityDetails];
        
        [feedDescDisplayArray addObjectsFromArray:_dbmanager.feedDescDisplayArrayFromDB];
        [completeFeedDescDisplayArray addObjectsFromArray:_dbmanager.feedDescDisplayArrayFromDB];
        
        [feedIdArray addObjectsFromArray:_dbmanager.feedIdArrayFromDB];
        [completeFeedIdArray addObjectsFromArray:_dbmanager.feedIdArrayFromDB];
        
        [feedItemTypeArray addObjectsFromArray:_dbmanager.feedItemTypeArrayFromDB];
        [completeFeedItemTypeArray addObjectsFromArray:_dbmanager.feedItemTypeArrayFromDB];
        
        [actorNameArray addObjectsFromArray:_dbmanager.actorNameArrayFromDB];
        [completeActorNameArray addObjectsFromArray:_dbmanager.actorNameArrayFromDB];
        
        for(int k=0; k < [_dbmanager.feedActorImageDisplayArrayFromDB count]; k++)
        {
            [feedActorImageDisplayArray addObject:[UIImage imageWithData:[NSData dataWithContentsOfFile:[_dbmanager.feedActorImageDisplayArrayFromDB objectAtIndex:k]]]];
            [completeFeedActorImageDisplayArray addObject:[UIImage imageWithData:[NSData dataWithContentsOfFile:[_dbmanager.feedActorImageDisplayArrayFromDB objectAtIndex:k]]]];
            
            [feedTargetImageDisplayArray addObject:[UIImage imageWithData:[NSData dataWithContentsOfFile:[_dbmanager.feedTargetImageDisplayArrayFromDB objectAtIndex:k]]]]; 
            [completeFeedTargetImageDisplayArray addObject:[UIImage imageWithData:[NSData dataWithContentsOfFile:[_dbmanager.feedTargetImageDisplayArrayFromDB objectAtIndex:k]]]];
            
            numberOfFeedsDisplayed++;
        }
        
        [actorLinkArray addObjectsFromArray:_dbmanager.actorLinkArrayFromDB];
        [completeActorLinkArray addObjectsFromArray:_dbmanager.actorLinkArrayFromDB];
        
        [actorTaglineArray addObjectsFromArray:_dbmanager.actorTaglineArrayFromDB];
        [completeActorTaglineArray addObjectsFromArray:_dbmanager.actorTaglineArrayFromDB];
        
        [targetNameArray addObjectsFromArray:_dbmanager.targetNameArrayFromDB];
        [completeTargetNameArray addObjectsFromArray:_dbmanager.targetNameArrayFromDB];
        
        [targetLinkArray addObjectsFromArray:_dbmanager.targetLinkArrayFromDB];
        [completeTargetLinkArray addObjectsFromArray:_dbmanager.targetLinkArrayFromDB];
        
        [targetTaglineArray addObjectsFromArray:_dbmanager.targetTaglineArrayFromDB];
        [completeTargetTaglineArray addObjectsFromArray:_dbmanager.targetTaglineArrayFromDB];   
        
        [actorImageUrlArray addObjectsFromArray:_dbmanager.actorImageUrlArrayFromDB];
        [completeActorImageUrlArray addObjectsFromArray:_dbmanager.actorImageUrlArrayFromDB];
        
        [targetImageUrlArray addObjectsFromArray:_dbmanager.targetImageUrlArrayFromDB];
        [completeTargetImageUrlArray addObjectsFromArray:_dbmanager.targetImageUrlArrayFromDB];
    }
    else
    {
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
        
        for(int z=0; z < [feeds count]; z++)
        {
            NSDictionary *feedDict = [feeds objectAtIndex:z];
            
            NSString *feedDescription = [feedDict objectForKey:@"description"];
            
            
            if([feedDescription rangeOfString:@"updated"].location == NSNotFound)
            {   
                NSArray *str = [feedDescription componentsSeparatedByString:@">"];
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
                
                if(latestFeedsFlag == FALSE)
                {
                    [feedDescDisplayArray addObject:theMutableString];
                    [completeFeedDescDisplayArray addObject:theMutableString];
                }
                else
                {
                    [latestfeedDescDisplayArray addObject:theMutableString];
                }
                
                [theMutableString release];
                
                
                NSString *feedId = [feedDict objectForKey:@"id"];
                if(latestFeedsFlag == FALSE)
                {
                    [feedIdArray addObject:feedId];
                    [completeFeedIdArray addObject:feedId];
                }
                else
                {
                    [latestFeedIdArray addObject:feedId];
                }
                
                
                NSString *feedItemType = [[feedDict objectForKey:@"item"] valueForKey:@"type"];
                if(latestFeedsFlag == FALSE)
                {
                    [feedItemTypeArray addObject:feedItemType];
                    [completeFeedItemTypeArray addObject:feedItemType];
                }
                else
                {
                    [latestFeedItemTypeArray addObject:feedItemType];
                }
                
                
                //for actor
                NSString *actorName = [[feedDict objectForKey:@"actor"] valueForKey:@"name"];
                
                if(latestFeedsFlag == FALSE)
                {
                    if(actorName == (NSString *)[NSNull null])
                    {
                        [actorNameArray addObject:@"No Information"];
                        [completeActorNameArray addObject:@"No Information"];
                    }
                    else
                    {
                        [actorNameArray addObject:actorName];
                        [completeActorNameArray addObject:actorName];
                    }
                }
                else
                {
                    if(actorName == (NSString *)[NSNull null])
                    {
                        [latestActorNameArray addObject:@"No Information"];
                    }
                    else
                    {
                        [latestActorNameArray addObject:actorName];
                    }
                }
                
                
                
                NSString *actorImageUrl = [[feedDict objectForKey:@"actor"] valueForKey:@"image"];
                
                if(latestFeedsFlag == FALSE)
                {
                    if(actorImageUrl == (NSString *)[NSNull null])
                    {
                        [actorImageUrlArray addObject:@"https://angel.co/images/nopic.png"];
                        [completeActorImageUrlArray addObject:@"https://angel.co/images/nopic.png"];
                    }
                    else
                    {
                        [actorImageUrlArray addObject:actorImageUrl];
                        [completeActorImageUrlArray addObject:actorImageUrl];
                    }
                }
                else
                {
                    if(actorImageUrl == (NSString *)[NSNull null])
                    {
                        [latestActorImageUrlArray addObject:@"https://angel.co/images/nopic.png"];
                    }
                    else
                    {
                        [latestActorImageUrlArray addObject:actorImageUrl];
                    }
                }
                
                
                
                NSString *actorlink = [[feedDict objectForKey:@"actor"] valueForKey:@"angellist_url"];
                
                if(latestFeedsFlag == FALSE)
                {
                    if(actorlink == (NSString *)[NSNull null])
                    {
                        [actorLinkArray addObject:@"No Information"];
                        [completeActorLinkArray addObject:@"No Information"];
                    }
                    else
                    {
                        [actorLinkArray addObject:actorlink];
                        [completeActorLinkArray addObject:actorlink];
                    }
                }
                else
                {
                    if(actorlink == (NSString *)[NSNull null])
                    {
                        [latestActorLinkArray addObject:@"No Information"];
                    }
                    else
                    {
                        [latestActorLinkArray addObject:actorlink];
                    }
                }
                
                
                
                NSString *actorTagline = [[feedDict objectForKey:@"actor"] valueForKey:@"tagline"];
                
                if(latestFeedsFlag == FALSE)
                {
                    if(actorTagline == (NSString *)[NSNull null])
                    {
                        [actorTaglineArray addObject:@"No Information"];
                        [completeActorTaglineArray addObject:@"No Information"];
                    }
                    else
                    {
                        [actorTaglineArray addObject:actorTagline];
                        [completeActorTaglineArray addObject:actorTagline];
                    }
                }
                else
                {
                    if(actorTagline == (NSString *)[NSNull null])
                    {
                        [latestActorTaglineArray addObject:@"No Information"];
                    }
                    else
                    {
                        [latestActorTaglineArray addObject:actorTagline];
                    }
                }
                
                
                
                //for target
                NSString *targetName = [[feedDict objectForKey:@"target"] valueForKey:@"name"];
                if(latestFeedsFlag == FALSE)
                {
                    if(targetName == (NSString *)[NSNull null])
                    {
                        [targetNameArray addObject:@"No Information"];
                        [completeTargetNameArray addObject:@"No Information"];
                    }
                    else
                    {
                        [targetNameArray addObject:targetName];
                        [completeTargetNameArray addObject:targetName];
                    }
                }
                else
                {
                    if(targetName == (NSString *)[NSNull null])
                    {
                        [latestTargetNameArray addObject:@"No Information"];
                    }
                    else
                    {
                        [latestTargetNameArray addObject:targetName];
                    }
                }
                
                
                
                NSString *targetImageUrl = [[feedDict objectForKey:@"target"] valueForKey:@"image"];
                if(latestFeedsFlag == FALSE)
                {
                    if(targetImageUrl == (NSString *)[NSNull null])
                    {
                        [targetImageUrlArray addObject:@"https://angel.co/images/nopic.png"];
                        [completeTargetImageUrlArray addObject:@"https://angel.co/images/nopic.png"];
                    }
                    else
                    {
                        [targetImageUrlArray addObject:targetImageUrl];
                        [completeTargetImageUrlArray addObject:targetImageUrl];
                    }
                }
                else
                {
                    if(targetImageUrl == (NSString *)[NSNull null])
                    {
                        [latestTargetImageUrlArray addObject:@"https://angel.co/images/nopic.png"];
                    }
                    else
                    {
                        [latestTargetImageUrlArray addObject:targetImageUrl];
                    }
                }
                
                
                
                NSString *targetlink = [[feedDict objectForKey:@"target"] valueForKey:@"angellist_url"];
                if(latestFeedsFlag == FALSE)
                {
                    if(targetlink == (NSString *)[NSNull null])
                    {
                        [targetLinkArray addObject:@"No Information"];
                        [completeTargetLinkArray addObject:@"No Information"];
                    }
                    else
                    {
                        [targetLinkArray addObject:targetlink];
                        [completeTargetLinkArray addObject:targetlink];
                    }
                }
                else
                {
                    if(targetlink == (NSString *)[NSNull null])
                    {
                        [latestTargetLinkArray addObject:@"No Information"];
                    }
                    else
                    {
                        [latestTargetLinkArray addObject:targetlink];
                    }
                }
                
                
                
                NSString *targetTagline = [[feedDict objectForKey:@"target"] valueForKey:@"tagline"];
                if(latestFeedsFlag == FALSE)
                {
                    if(targetTagline == (NSString *)[NSNull null])
                    {
                        [targetTaglineArray addObject:@"No Information"];
                        [completeTargetTaglineArray addObject:@"No Information"];
                    }
                    else
                    {
                        [targetTaglineArray addObject:targetTagline];
                        [completeTargetTaglineArray addObject:targetTagline];   
                    }
                }
                else
                {
                    if(targetTagline == (NSString *)[NSNull null])
                    {
                        [latestTargetTaglineArray addObject:@"No Information"];
                    }
                    else
                    {
                        [latestTargetTaglineArray addObject:targetTagline];
                    }
                }
                
                if(latestFeedsFlag == FALSE)
                {
                    [feedActorImageDisplayArray addObject:[UIImage imageNamed:@"placeholder.png"]];
                    [completeFeedActorImageDisplayArray addObject:[UIImage imageNamed:@"placeholder.png"]];
                    [feedTargetImageDisplayArray addObject:[UIImage imageNamed:@"placeholder.png"]];
                    [completeFeedTargetImageDisplayArray addObject:[UIImage imageNamed:@"placeholder.png"]];
                }
                else
                {
                    [latestFeedActorImageDisplayArray addObject:[UIImage imageNamed:@"placeholder.png"]];
                    [latestFeedTargetImageDisplayArray addObject:[UIImage imageNamed:@"placeholder.png"]];
                }
                
                
                if(pageNo == 1)
                {
                    numberOfFeedsDisplayed++;
                }
                
            }//End Updated If Block  
            
        }//End for loop
        
        
        if(latestFeedsFlag == TRUE)
        {
            
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [latestfeedDescDisplayArray count])];
            
            [feedDescDisplayArray insertObjects:latestfeedDescDisplayArray atIndexes:indexSet];
            [completeFeedDescDisplayArray insertObjects:latestfeedDescDisplayArray atIndexes:indexSet];
            
            [feedIdArray insertObjects:latestFeedIdArray atIndexes:indexSet];
            [completeFeedIdArray insertObjects:latestFeedIdArray atIndexes:indexSet];
            
            [feedItemTypeArray insertObjects:latestFeedItemTypeArray atIndexes:indexSet];
            [completeFeedItemTypeArray insertObjects:latestFeedItemTypeArray atIndexes:indexSet];
            
            [actorNameArray insertObjects:latestActorNameArray atIndexes:indexSet];
            [completeActorNameArray insertObjects:latestActorNameArray atIndexes:indexSet];
            
            [actorImageUrlArray insertObjects:latestActorImageUrlArray atIndexes:indexSet];
            [completeActorImageUrlArray insertObjects:latestActorImageUrlArray atIndexes:indexSet];
            
            [actorLinkArray insertObjects:latestActorLinkArray atIndexes:indexSet];
            [completeActorLinkArray insertObjects:latestActorLinkArray atIndexes:indexSet];
            
            [actorTaglineArray insertObjects:latestActorTaglineArray atIndexes:indexSet];
            [completeActorTaglineArray insertObjects:latestActorTaglineArray atIndexes:indexSet];
            
            [feedActorImageDisplayArray insertObjects:latestFeedActorImageDisplayArray atIndexes:indexSet];
            [completeFeedActorImageDisplayArray insertObjects:latestFeedActorImageDisplayArray atIndexes:indexSet];
            
            [feedTargetImageDisplayArray insertObjects:latestFeedTargetImageDisplayArray atIndexes:indexSet];
            [completeFeedTargetImageDisplayArray insertObjects:latestFeedTargetImageDisplayArray atIndexes:indexSet];
            
            [targetNameArray insertObjects:latestTargetNameArray atIndexes:indexSet];
            [completeTargetNameArray insertObjects:latestTargetNameArray atIndexes:indexSet];
            
            [targetImageUrlArray insertObjects:latestTargetImageUrlArray atIndexes:indexSet];
            [completeTargetImageUrlArray insertObjects:latestTargetImageUrlArray atIndexes:indexSet];
            
            [targetLinkArray insertObjects:latestTargetLinkArray atIndexes:indexSet];
            [completeTargetLinkArray insertObjects:latestTargetLinkArray atIndexes:indexSet];
            
            [targetTaglineArray insertObjects:latestTargetTaglineArray atIndexes:indexSet];
            [completeTargetTaglineArray insertObjects:latestTargetTaglineArray atIndexes:indexSet];
        }
        
        //Target Name
        for(int k=0; k<[completeTargetNameArray count]; k++)
        {
            NSMutableString * theMutableString = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@",[completeTargetNameArray objectAtIndex:k]]];
            [theMutableString replaceOccurrencesOfString:@"'" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
            
            [targetNameArray replaceObjectAtIndex:k withObject:theMutableString];
            [completeTargetNameArray replaceObjectAtIndex:k withObject:theMutableString];
            
            [theMutableString release];
        }
        //Actor Name
        for(int k=0; k<[completeActorNameArray count]; k++)
        {
            NSMutableString * theMutableString = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@",[completeActorNameArray objectAtIndex:k]]];
            [theMutableString replaceOccurrencesOfString:@"'" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
            
            [actorNameArray replaceObjectAtIndex:k withObject:theMutableString];
            [completeActorNameArray replaceObjectAtIndex:k withObject:theMutableString];
            
            [theMutableString release];
        }
        
        //Actor Tagline
        for(int k=0; k<[completeActorTaglineArray count]; k++)
        {
            NSMutableString * theMutableString = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@",[completeActorTaglineArray objectAtIndex:k]]];
            [theMutableString replaceOccurrencesOfString:@"'" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
            
            [actorTaglineArray replaceObjectAtIndex:k withObject:theMutableString];
            [completeActorTaglineArray replaceObjectAtIndex:k withObject:theMutableString];
            
            [theMutableString release];
        }
        
        //Target Tagline
        for(int k=0; k<[completeTargetTaglineArray count]; k++)
        {
            NSMutableString * theMutableString = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@",[completeTargetTaglineArray objectAtIndex:k]]];
            [theMutableString replaceOccurrencesOfString:@"'" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
            
            [targetTaglineArray replaceObjectAtIndex:k withObject:theMutableString];
            [completeTargetTaglineArray replaceObjectAtIndex:k withObject:theMutableString];
            
            [theMutableString release];
        }
        
        
        if(pageNo == 1)
        {
            [self saveImagesToDocumentsDirectory];
        }
        [self loadImages];
    }//End else block
    
    loadingView.hidden = YES;
}

-(void) loadImages
{
    /* Operation Queue init (autorelease) */
    NSOperationQueue *queue = [NSOperationQueue new];
    
    /* Create our NSInvocationOperation to call loadDataWithOperation, passing in nil */
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self
                                                                            selector:@selector(loadDataWithOperation)
                                                                              object:nil];
    
    /* Add the operation to the queue */
    [queue addOperation:operation];
    [operation release];
    [queue release];
}

-(void) loadDataWithOperation
{
    for(int z=0; z < [actorImageUrlArray count]; z++)
    {
        if([[feedActorImageDisplayArray objectAtIndex:z] isEqual:[UIImage imageNamed:@"placeholder.png"]])
        {
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[actorImageUrlArray objectAtIndex:z]]]];
            [feedActorImageDisplayArray replaceObjectAtIndex:z withObject:image];
            [completeFeedActorImageDisplayArray replaceObjectAtIndex:z withObject:image];
            //[table reloadData];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:z inSection: 0];
            UITableViewCell *cell = [table cellForRowAtIndexPath:indexPath];
            UIImageView *cellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(7, 12, 50, 50)];
            cellImageView.image = [feedActorImageDisplayArray objectAtIndex:indexPath.row];
            [cell.contentView addSubview:cellImageView];
            [cellImageView release];
        }
    }
    
    for(int z=0; z < [targetImageUrlArray count]; z++)
    {
        if([[feedTargetImageDisplayArray objectAtIndex:z] isEqual:[UIImage imageNamed:@"placeholder.png"]])
        {
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[targetImageUrlArray objectAtIndex:z]]]];
            [feedTargetImageDisplayArray replaceObjectAtIndex:z withObject:image];
            [completeFeedTargetImageDisplayArray replaceObjectAtIndex:z withObject:image];
        }
    }
}

-(void) saveImagesToDocumentsDirectory
{
    for (int z=0; z < numberOfFeedsDisplayed; z++) 
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSString *activityId = [NSString stringWithFormat:@"%d",(z+1)];
        NSString *feedId = [NSString stringWithFormat:@"%@",[feedIdArray objectAtIndex:z]];
        NSString *feedType = [NSString stringWithFormat:@"%@",[feedItemTypeArray objectAtIndex:z]];
        NSString *feedDescription = [NSString stringWithFormat:@"%@",[feedDescDisplayArray objectAtIndex:z]];
        
        //for actor
        NSString *actorName = [NSString stringWithFormat:@"%@",[actorNameArray objectAtIndex:z]];
        
        NSString *savedImagePathforFeedActor = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"actor%d.jpg",(z+1)]];
        UIImage *imageFeedActor = [UIImage imageNamed:@"placeholder.png"];
        NSData *imageDataFeedActor = UIImagePNGRepresentation(imageFeedActor);
        [imageDataFeedActor writeToFile:savedImagePathforFeedActor atomically:NO];
        
        NSString *actorImagePath = [NSString stringWithFormat:@"%@",savedImagePathforFeedActor];
        NSString *actorLink = [NSString stringWithFormat:@"%@",[actorLinkArray objectAtIndex:z]];
        NSString *actorTagline = [NSString stringWithFormat:@"%@",[actorTaglineArray objectAtIndex:z]];
        NSString *actorImageUrl = [NSString stringWithFormat:@"%@",[actorImageUrlArray objectAtIndex:z]];
        
        
        //for target
        NSString *targetName = [NSString stringWithFormat:@"%@",[targetNameArray objectAtIndex:z]];
        
        NSString *savedImagePathforFeedTarget = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"target%d.jpg",(z+1)]];
        UIImage *imageFeedTarget = [UIImage imageNamed:@"placeholder.png"];
        NSData *imageDataFeedTarget = UIImagePNGRepresentation(imageFeedTarget);
        [imageDataFeedTarget writeToFile:savedImagePathforFeedTarget atomically:NO];
        
        NSString *targetImagePath = [NSString stringWithFormat:@"%@",savedImagePathforFeedTarget];
        NSString *targetLink = [NSString stringWithFormat:@"%@",[targetLinkArray objectAtIndex:z]];
        NSString *targetTagline = [NSString stringWithFormat:@"%@",[targetTaglineArray objectAtIndex:z]];
        NSString *targetImageUrl = [NSString stringWithFormat:@"%@",[targetImageUrlArray objectAtIndex:z]];
        
        
        //Save activity feeds to DB
        [_dbmanager insertRecordIntoActivityTable:@"Activity" withField1:@"Id" field1Value:activityId andField2:@"feedId" field2Value:feedId andField3:@"feedItemType" field3Value:feedType andField4:@"feedDescription" field4Value:feedDescription andField5:@"actorName" field5Value:actorName andField6:@"actorImagePath" field6Value:actorImagePath andField7:@"actorLink" field7Value:actorLink andField8:@"actorTagline" field8Value:actorTagline andField9:@"targetName" field9Value:targetName andField10:@"targetImagePath" field10Value:targetImagePath andField11:@"targetLink" field11Value:targetLink andField12:@"targetTagline" field12Value:targetTagline andField13:@"actorImageUrl" field13Value:actorImageUrl andField14:@"targetImageUrl" field14Value:targetImageUrl]; 
    }
    
    feedImagesToBeDownloadedForAandT = numberOfFeedsDisplayed;
    [self performSelectorInBackground:@selector(downloadImages) withObject:nil];
}

-(void) downloadImages
{
    NSMutableArray *actorImageUrlArrayToDownload = [NSMutableArray new];
    NSMutableArray *targetImageUrlArrayToDownload = [NSMutableArray new];
    
    [actorImageUrlArrayToDownload addObjectsFromArray:actorImageUrlArray]; 
    [targetImageUrlArrayToDownload addObjectsFromArray:targetImageUrlArray];
    
    for (int z=0; z < feedImagesToBeDownloadedForAandT; z++) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        
        NSString *savedImagePathForActor = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"actor%d.jpg",(z+1)]];
        UIImage *imageForActor = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[actorImageUrlArrayToDownload objectAtIndex:z]]]];
        NSData *imageDataForActor = UIImagePNGRepresentation(imageForActor);
        [imageDataForActor writeToFile:savedImagePathForActor atomically:NO];
        
        
        NSString *savedImagePathForTarget = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"target%d.jpg",(z+1)]];
        UIImage *imageForTarget = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[targetImageUrlArrayToDownload objectAtIndex:z]]]];
        NSData *imageDataForTarget = UIImagePNGRepresentation(imageForTarget);
        [imageDataForTarget writeToFile:savedImagePathForTarget atomically:NO];
    }
    
    [actorImageUrlArrayToDownload release]; 
    [targetImageUrlArrayToDownload release];
}

-(void)latestfeeds
{
    //Check for the availability of Internet
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Internet appears to be offline" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else
    {
        
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,numberOfFeedsDisplayed)];
        
        [feedDescDisplayArray removeObjectsAtIndexes:indexSet];
        [completeFeedDescDisplayArray removeObjectsAtIndexes:indexSet];
        
        [feedIdArray removeObjectsAtIndexes:indexSet];
        [completeFeedIdArray removeObjectsAtIndexes:indexSet];
        
        [feedItemTypeArray removeObjectsAtIndexes:indexSet];
        [completeFeedItemTypeArray removeObjectsAtIndexes:indexSet];
        
        [actorNameArray removeObjectsAtIndexes:indexSet];
        [completeActorNameArray removeObjectsAtIndexes:indexSet];
        
        [actorImageUrlArray removeObjectsAtIndexes:indexSet];
        [completeActorImageUrlArray removeObjectsAtIndexes:indexSet];
            
        [targetImageUrlArray removeObjectsAtIndexes:indexSet];
        [completeTargetImageUrlArray removeObjectsAtIndexes:indexSet];
        
        [actorLinkArray removeObjectsAtIndexes:indexSet];
        [completeActorLinkArray removeObjectsAtIndexes:indexSet];
        
        [actorTaglineArray removeObjectsAtIndexes:indexSet];
        [completeActorTaglineArray removeObjectsAtIndexes:indexSet];
        
        [feedActorImageDisplayArray removeObjectsAtIndexes:indexSet];
        [completeFeedActorImageDisplayArray removeObjectsAtIndexes:indexSet];
        
        [feedTargetImageDisplayArray removeObjectsAtIndexes:indexSet];
        [completeFeedTargetImageDisplayArray removeObjectsAtIndexes:indexSet];
        
        [targetNameArray removeObjectsAtIndexes:indexSet];
        [completeTargetNameArray removeObjectsAtIndexes:indexSet];
        
        
        [targetLinkArray removeObjectsAtIndexes:indexSet];
        [completeTargetLinkArray removeObjectsAtIndexes:indexSet];
        
        [targetTaglineArray removeObjectsAtIndexes:indexSet];
        [completeTargetTaglineArray removeObjectsAtIndexes:indexSet];
        
        
        [latestfeedDescDisplayArray removeAllObjects];
        [latestFeedIdArray removeAllObjects];
        [latestFeedItemTypeArray removeAllObjects];
        
        [latestActorNameArray removeAllObjects];
        [latestActorImageUrlArray removeAllObjects];
        [latestActorLinkArray removeAllObjects];
        [latestActorTaglineArray removeAllObjects];
        
        [latestFeedActorImageDisplayArray removeAllObjects];
        [latestFeedTargetImageDisplayArray removeAllObjects];
        
        [latestTargetNameArray removeAllObjects];
        [latestTargetImageUrlArray removeAllObjects];
        [latestTargetLinkArray removeAllObjects];
        [latestTargetTaglineArray removeAllObjects];
        
        [_dbmanager deleteRowsFromActivity];
        latestFeedsFlag = TRUE;
        numberOfFeedsDisplayed = 0;
        
        [self loadFeeds:1];
    }
}

-(void)morefeeds
{
    //Check for the availability of Internet
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Internet appears to be offline" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else
    {
        feedPageNumber++;
        latestFeedsFlag = FALSE;
        [self loadFeeds:feedPageNumber];
        [table reloadData];
    }
}

-(void) filterButtonSelected:(id)sender
{
    if(_showFilterMenu == FALSE)
    {
        [UIView beginAnimations:nil context:NULL];
        filterView.frame = CGRectMake(0, 0, 320, 480);
        filtersButtonsView.frame = CGRectMake(50, 0, 220, 204);
        [UIView setAnimationDuration:0.3];
        [UIView commitAnimations];
        
        _showFilterMenu = TRUE;
    }
    else
    {
        [UIView beginAnimations:nil context:NULL];
        filterView.frame = CGRectMake(0, -481, 320, 480);
        filtersButtonsView.frame = CGRectMake(50, -481, 220, 204);
        [UIView setAnimationDuration:0.3];
        [UIView commitAnimations];
        
        _showFilterMenu = FALSE;
    }
}

-(void)goToSearch
{
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Internet appears offline!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];        
    }
    else
    {
        SearchViewController *_searchViewController = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
        [_searchViewController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        [self.navigationController pushViewController:_searchViewController animated:YES];
        [_searchViewController release]; 
    }
}

-(IBAction)getFilteredList:(id)sender
{
    [feedDescDisplayArray removeAllObjects];
    [feedDescDisplayArray addObjectsFromArray:completeFeedDescDisplayArray];
    [feedIdArray removeAllObjects];
    [feedIdArray addObjectsFromArray:completeFeedIdArray];
    [feedItemTypeArray removeAllObjects];
    [feedItemTypeArray addObjectsFromArray:completeFeedItemTypeArray];
    
    [actorNameArray removeAllObjects];
    [actorNameArray addObjectsFromArray:completeActorNameArray];
    [actorImageUrlArray removeAllObjects];
    [actorImageUrlArray addObjectsFromArray:completeActorImageUrlArray];
    [actorLinkArray removeAllObjects];
    [actorLinkArray addObjectsFromArray:completeActorLinkArray];
    [actorTaglineArray removeAllObjects];
    [actorTaglineArray addObjectsFromArray:completeActorTaglineArray];
    
    [feedActorImageDisplayArray removeAllObjects];
    [feedActorImageDisplayArray addObjectsFromArray:completeFeedActorImageDisplayArray];
    [feedTargetImageDisplayArray removeAllObjects];
    [feedTargetImageDisplayArray addObjectsFromArray:completeFeedTargetImageDisplayArray];
    
    [targetNameArray removeAllObjects];
    [targetNameArray addObjectsFromArray:completeTargetNameArray];
    [targetImageUrlArray removeAllObjects];
    [targetImageUrlArray addObjectsFromArray:completeTargetImageUrlArray];
    [targetLinkArray removeAllObjects];
    [targetLinkArray addObjectsFromArray:completeTargetLinkArray];
    [targetTaglineArray removeAllObjects];
    [targetTaglineArray addObjectsFromArray:completeTargetTaglineArray];
 
//////////////////////////////////////////////////////////////////////////////////////////////
    
    [filterFeedDescDisplayArray removeAllObjects];
    [filterFeedIdArray removeAllObjects];
    [filterFeedItemTypeArray removeAllObjects];
    
    [filterActorNameArray removeAllObjects];
    [filterActorImageUrlArray removeAllObjects];
    [filterActorLinkArray removeAllObjects];
    [filterActorTaglineArray removeAllObjects];
    
    [filterFeedActorImageDisplayArray removeAllObjects];
    [filterFeedTargetImageDisplayArray removeAllObjects];
    
    [filterTargetNameArray removeAllObjects];
    [filterTargetImageUrlArray removeAllObjects];
    [filterTargetLinkArray removeAllObjects];
    [filterTargetTaglineArray removeAllObjects];
    
    int _tagID = [sender tag];
    
    switch(_tagID)
    {
        case 1: NSLog(@"\nFollowed");
                _filterFollowed = TRUE;
                _filterInvested = FALSE;
                _filterIntroduced = FALSE;
            
                for(int k=0; k<[feedDescDisplayArray count];k++)
                {
                    NSString *checkStr = [feedDescDisplayArray objectAtIndex:k];
                    if([checkStr rangeOfString:@"followed"].location != NSNotFound)
                    {
                        [filterFeedDescDisplayArray addObject:[feedDescDisplayArray objectAtIndex:k]];
                        [filterFeedIdArray addObject:[feedIdArray objectAtIndex:k]];
                        [filterFeedItemTypeArray addObject:[feedItemTypeArray objectAtIndex:k]];
                        
                        [filterActorNameArray addObject:[actorNameArray objectAtIndex:k]];
                        [filterActorImageUrlArray addObject:[actorImageUrlArray objectAtIndex:k]];
                        [filterActorLinkArray addObject:[actorLinkArray objectAtIndex:k]];
                        [filterActorTaglineArray addObject:[actorTaglineArray objectAtIndex:k]];
                        
                        [filterFeedActorImageDisplayArray addObject:[feedActorImageDisplayArray objectAtIndex:k]];
                        [filterFeedTargetImageDisplayArray addObject:[feedTargetImageDisplayArray objectAtIndex:k]];
                        
                        [filterTargetNameArray addObject:[targetNameArray objectAtIndex:k]];
                        [filterTargetImageUrlArray addObject:[targetImageUrlArray objectAtIndex:k]];
                        [filterTargetLinkArray addObject:[targetLinkArray objectAtIndex:k]];
                        [filterTargetTaglineArray addObject:[targetTaglineArray objectAtIndex:k]];
                    }
                }
            
                [feedDescDisplayArray removeAllObjects];
                [feedDescDisplayArray addObjectsFromArray:filterFeedDescDisplayArray];
                [feedIdArray removeAllObjects];
                [feedIdArray addObjectsFromArray:filterFeedIdArray];
                [feedItemTypeArray removeAllObjects];
                [feedItemTypeArray addObjectsFromArray:filterFeedItemTypeArray];
            
                [actorNameArray removeAllObjects];
                [actorNameArray addObjectsFromArray:filterActorNameArray];
                [actorImageUrlArray removeAllObjects];
                [actorImageUrlArray addObjectsFromArray:filterActorImageUrlArray];
                [actorLinkArray removeAllObjects];
                [actorLinkArray addObjectsFromArray:filterActorLinkArray];
                [actorTaglineArray removeAllObjects];
                [actorTaglineArray addObjectsFromArray:filterActorTaglineArray];
            
                [feedActorImageDisplayArray removeAllObjects];
                [feedActorImageDisplayArray addObjectsFromArray:filterFeedActorImageDisplayArray];
                [feedTargetImageDisplayArray removeAllObjects];
                [feedTargetImageDisplayArray addObjectsFromArray:filterFeedTargetImageDisplayArray];
            
                [targetNameArray removeAllObjects];
                [targetNameArray addObjectsFromArray:filterTargetNameArray];
                [targetImageUrlArray removeAllObjects];
                [targetImageUrlArray addObjectsFromArray:filterTargetImageUrlArray];
                [targetLinkArray removeAllObjects];
                [targetLinkArray addObjectsFromArray:filterTargetLinkArray];
                [targetTaglineArray removeAllObjects];
                [targetTaglineArray addObjectsFromArray:filterTargetTaglineArray];
            
                refreshViewTop.hidden = YES;
                refreshViewBottom.hidden = YES;
                navigationBarLabel.text = @"Activity - Followed";
                [self filterButtonSelected:sender];
                [table reloadData];
                break;
        case 2: NSLog(@"\nInvested");
                _filterInvested = TRUE;
                _filterFollowed = FALSE;
                _filterIntroduced = FALSE;
            
            
            for(int k=0; k<[feedDescDisplayArray count];k++)
            {
                NSString *checkStr = [feedDescDisplayArray objectAtIndex:k];
                if([checkStr rangeOfString:@"invested"].location != NSNotFound)
                {
                    [filterFeedDescDisplayArray addObject:[feedDescDisplayArray objectAtIndex:k]];
                    [filterFeedIdArray addObject:[feedIdArray objectAtIndex:k]];
                    [filterFeedItemTypeArray addObject:[feedItemTypeArray objectAtIndex:k]];
                    
                    [filterActorNameArray addObject:[actorNameArray objectAtIndex:k]];
                    [filterActorImageUrlArray addObject:[actorImageUrlArray objectAtIndex:k]];
                    [filterActorLinkArray addObject:[actorLinkArray objectAtIndex:k]];
                    [filterActorTaglineArray addObject:[actorTaglineArray objectAtIndex:k]];
                    
                    [filterFeedActorImageDisplayArray addObject:[feedActorImageDisplayArray objectAtIndex:k]];
                    [filterFeedTargetImageDisplayArray addObject:[feedTargetImageDisplayArray objectAtIndex:k]];
                    
                    [filterTargetNameArray addObject:[targetNameArray objectAtIndex:k]];
                    [filterTargetImageUrlArray addObject:[targetImageUrlArray objectAtIndex:k]];
                    [filterTargetLinkArray addObject:[targetLinkArray objectAtIndex:k]];
                    [filterTargetTaglineArray addObject:[targetTaglineArray objectAtIndex:k]];
                }
            }
            
            [feedDescDisplayArray removeAllObjects];
            [feedDescDisplayArray addObjectsFromArray:filterFeedDescDisplayArray];
            [feedIdArray removeAllObjects];
            [feedIdArray addObjectsFromArray:filterFeedIdArray];
            [feedItemTypeArray removeAllObjects];
            [feedItemTypeArray addObjectsFromArray:filterFeedItemTypeArray];
            
            [actorNameArray removeAllObjects];
            [actorNameArray addObjectsFromArray:filterActorNameArray];
            [actorImageUrlArray removeAllObjects];
            [actorImageUrlArray addObjectsFromArray:filterActorImageUrlArray];
            [actorLinkArray removeAllObjects];
            [actorLinkArray addObjectsFromArray:filterActorLinkArray];
            [actorTaglineArray removeAllObjects];
            [actorTaglineArray addObjectsFromArray:filterActorTaglineArray];
            
            [feedActorImageDisplayArray removeAllObjects];
            [feedActorImageDisplayArray addObjectsFromArray:filterFeedActorImageDisplayArray];
            [feedTargetImageDisplayArray removeAllObjects];
            [feedTargetImageDisplayArray addObjectsFromArray:filterFeedTargetImageDisplayArray];
            
            [targetNameArray removeAllObjects];
            [targetNameArray addObjectsFromArray:filterTargetNameArray];
            [targetImageUrlArray removeAllObjects];
            [targetImageUrlArray addObjectsFromArray:filterTargetImageUrlArray];
            [targetLinkArray removeAllObjects];
            [targetLinkArray addObjectsFromArray:filterTargetLinkArray];
            [targetTaglineArray removeAllObjects];
            [targetTaglineArray addObjectsFromArray:filterTargetTaglineArray];
            
            refreshViewTop.hidden = YES;
            refreshViewBottom.hidden = YES;
            navigationBarLabel.text = @"Activity - Invested";
            [self filterButtonSelected:sender];
            [table reloadData];
            
                break;
        case 3: NSLog(@"\nIntroduced");
                _filterIntroduced = TRUE;
                _filterFollowed = FALSE;
                _filterInvested = FALSE;
            
            for(int k=0; k<[feedDescDisplayArray count];k++)
            {
                NSString *checkStr = [feedDescDisplayArray objectAtIndex:k];
                if([checkStr rangeOfString:@"introduced"].location != NSNotFound)
                {
                    [filterFeedDescDisplayArray addObject:[feedDescDisplayArray objectAtIndex:k]];
                    [filterFeedIdArray addObject:[feedIdArray objectAtIndex:k]];
                    [filterFeedItemTypeArray addObject:[feedItemTypeArray objectAtIndex:k]];
                    
                    [filterActorNameArray addObject:[actorNameArray objectAtIndex:k]];
                    [filterActorImageUrlArray addObject:[actorImageUrlArray objectAtIndex:k]];
                    [filterActorLinkArray addObject:[actorLinkArray objectAtIndex:k]];
                    [filterActorTaglineArray addObject:[actorTaglineArray objectAtIndex:k]];
                    
                    [filterFeedActorImageDisplayArray addObject:[feedActorImageDisplayArray objectAtIndex:k]];
                    [filterFeedTargetImageDisplayArray addObject:[feedTargetImageDisplayArray objectAtIndex:k]];
                    
                    [filterTargetNameArray addObject:[targetNameArray objectAtIndex:k]];
                    [filterTargetImageUrlArray addObject:[targetImageUrlArray objectAtIndex:k]];
                    [filterTargetLinkArray addObject:[targetLinkArray objectAtIndex:k]];
                    [filterTargetTaglineArray addObject:[targetTaglineArray objectAtIndex:k]];
                }
            }
            
            [feedDescDisplayArray removeAllObjects];
            [feedDescDisplayArray addObjectsFromArray:filterFeedDescDisplayArray];
            [feedIdArray removeAllObjects];
            [feedIdArray addObjectsFromArray:filterFeedIdArray];
            [feedItemTypeArray removeAllObjects];
            [feedItemTypeArray addObjectsFromArray:filterFeedItemTypeArray];
            
            [actorNameArray removeAllObjects];
            [actorNameArray addObjectsFromArray:filterActorNameArray];
            [actorImageUrlArray removeAllObjects];
            [actorImageUrlArray addObjectsFromArray:filterActorImageUrlArray];
            [actorLinkArray removeAllObjects];
            [actorLinkArray addObjectsFromArray:filterActorLinkArray];
            [actorTaglineArray removeAllObjects];
            [actorTaglineArray addObjectsFromArray:filterActorTaglineArray];
            
            [feedActorImageDisplayArray removeAllObjects];
            [feedActorImageDisplayArray addObjectsFromArray:filterFeedActorImageDisplayArray];
            [feedTargetImageDisplayArray removeAllObjects];
            [feedTargetImageDisplayArray addObjectsFromArray:filterFeedTargetImageDisplayArray];
            
            [targetNameArray removeAllObjects];
            [targetNameArray addObjectsFromArray:filterTargetNameArray];
            [targetImageUrlArray removeAllObjects];
            [targetImageUrlArray addObjectsFromArray:filterTargetImageUrlArray];
            [targetLinkArray removeAllObjects];
            [targetLinkArray addObjectsFromArray:filterTargetLinkArray];
            [targetTaglineArray removeAllObjects];
            [targetTaglineArray addObjectsFromArray:filterTargetTaglineArray];
            
            refreshViewTop.hidden = YES;
            refreshViewBottom.hidden = YES;
            navigationBarLabel.text = @"Activity - Introduced";
            [self filterButtonSelected:sender];
            [table reloadData];
            
                break;
        case 4: NSLog(@"\nAll");
                _filterFollowed = FALSE;
                _filterInvested = FALSE;
                _filterIntroduced = FALSE;
            
                refreshViewTop.hidden = NO;
                refreshViewBottom.hidden = NO;
                navigationBarLabel.text = @"Activity";
                [self filterButtonSelected:sender];
                [table reloadData];
                break;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSIndexPath *selection = [table indexPathForSelectedRow];
    if (selection)
    {
        [table deselectRowAtIndexPath:selection animated:YES];
    }
    
    [super viewWillAppear:animated];

    activityFilterTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(filterButtonSelected:)];
    [self.navigationController.navigationBar addGestureRecognizer:activityFilterTap];
    [activityFilterTap release];
    
   
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    UIImage *backgroundImage = [UIImage imageNamed:@"navigationbarfil.png"];
    [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    navigationBarLabel.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    navigationBarLabel.hidden = YES;
    [self.navigationController.navigationBar removeGestureRecognizer:activityFilterTap];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

//Required
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.y <= -52) 
    {
        if((_filterFollowed == FALSE) && (_filterIntroduced == FALSE) && (_filterInvested == FALSE))
        {
            isLoadingTop = TRUE;
            [self startLoadingAtTop];
        }
    }  
    
    if ([scrollView contentOffset].y + 460  - 52 - 100 >= [scrollView contentSize].height) 
    {
        if((_filterFollowed == FALSE) && (_filterIntroduced == FALSE) && (_filterInvested == FALSE))
        {
            isLoadingBottom = TRUE;
            [self startLoadingAtBottom];
        }
    }
}


//Required
-(void) startLoadingAtTop
{
    table.contentInset = UIEdgeInsetsMake(52, 0, 0, 0);
    if(isLoadingTop)
    {
        imageViewTop.hidden = YES;
        refreshSpinnerTop.hidden = NO;
        [refreshSpinnerTop startAnimating];
    }
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(stopLoadingAtTop) userInfo:nil repeats:NO];
}
//Required
-(void) stopLoadingAtTop
{
    isLoadingTop = FALSE;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    imageViewTop.transform = CGAffineTransformMakeRotation(3.142*2);
    [UIView commitAnimations];
    table.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    imageViewTop.hidden = NO;
    refreshSpinnerTop.hidden = YES;
    [refreshSpinnerTop stopAnimating];
    
    [self latestfeeds];
    
    refreshViewBottom.frame = CGRectMake(0, [table contentSize].height, 320, 52);
}

//Required
-(void) startLoadingAtBottom
{
    table.contentInset = UIEdgeInsetsMake(0, 0, 70, 0);
    
    if(isLoadingBottom)
    {
        imageViewBottom.hidden = YES;
        refreshSpinnerBottom.hidden = NO;
        [refreshSpinnerBottom startAnimating];
    }
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(stopLoadingAtBottom) userInfo:nil repeats:NO];
}
//Required
-(void) stopLoadingAtBottom
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    imageViewBottom.transform = CGAffineTransformMakeRotation(3.142*2);
    [UIView commitAnimations];
    table.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    imageViewBottom.hidden = NO;
    refreshSpinnerBottom.hidden = YES;
    [refreshSpinnerBottom stopAnimating];
    
    [self morefeeds];
    
    isLoadingBottom = FALSE;
    refreshViewBottom.frame = CGRectMake(0, [table contentSize].height, 320, 52);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{  
    if(scrollView.contentOffset.y < -52)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        imageViewTop.transform = CGAffineTransformMakeRotation(3.142*2);
        [UIView commitAnimations];
    }
    else
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        imageViewTop.transform = CGAffineTransformMakeRotation(3.142);
        [UIView commitAnimations];
    } 
    
    if([scrollView contentOffset].y + 460 - 52 - 100 > [scrollView contentSize].height)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        imageViewBottom.transform = CGAffineTransformMakeRotation(3.142);
        [UIView commitAnimations];
    }
    else
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        imageViewBottom.transform = CGAffineTransformMakeRotation(3.142*2);
        [UIView commitAnimations];
    } 
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

