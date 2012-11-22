//
//  StartUpViewController.m
//  TableProj
//
//  Created by Ram Charan on 8/24/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import "StartUpViewController.h"
#import "Reachability.h"
#import "SearchViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "StartUpDetailsViewController.h"

@implementation StartUpViewController


NSMutableArray *startUpIdArray;
NSMutableArray *startUpNameArray;
NSMutableArray *startUpLinkArray;
NSMutableArray *startUpImageUrlArray;
NSMutableArray *startUpProdDescArray;
NSMutableArray *startUpHighConceptArray;
NSMutableArray *startUpFollowCountArray;
NSMutableArray *startUpLocationsArray;
NSMutableArray *startUpMarketsArray;
NSMutableArray *startUpImageDisplayArray;

NSMutableArray *userFollowingIds;
extern NSMutableArray *userDetailsArray;

NSMutableArray *userPortfolioIdsArray;

UILabel *navigationBarLabelInStartUp;
UITapGestureRecognizer *startUpFilterTap;
BOOL _showFilterMenuInStartUps = FALSE;

BOOL _filterTrending = TRUE;
BOOL _filterFollowing = FALSE;
BOOL _filterPortfolio = FALSE;

int _rowNumberInStartUps = 0;

//////////////////////////
UIView *refreshViewTopTrending;
UIImageView *imageViewTopTrending;
UIImageView *imageViewLogoTopTrending;
BOOL isLoadingTopTrending = FALSE;
UIActivityIndicatorView *refreshSpinnerTopTrending;
//////////////////////////

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //self.title = @"Startup";
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
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
    
    UIImageView *cellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(7, 12, 50, 50)];
    cellImageView.image = [startUpImageDisplayArray objectAtIndex:indexPath.row];
    cellImageView.layer.cornerRadius = 3.5f;
    cellImageView.layer.masksToBounds = YES;
    [cell.contentView addSubview:cellImageView];
    [cellImageView release];
    
    UILabel *cellNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 8, 210, 20)];
    cellNameLabel.lineBreakMode = UILineBreakModeWordWrap;
    cellNameLabel.text = [startUpNameArray objectAtIndex:indexPath.row];
    cellNameLabel.backgroundColor = [UIColor clearColor];
    cellNameLabel.textColor = [UIColor colorWithRed:63.0/255.0 green:103.0/255.0 blue:160.0/255.0 alpha:1.0f];
    cellNameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
    [cell.contentView addSubview:cellNameLabel];
    [cellNameLabel release];
    
    NSString *cellFollowsValue = [NSString stringWithFormat:@"%@ follows",[startUpFollowCountArray objectAtIndex:indexPath.row]]; 
    UILabel *cellFollowsLabel = [[UILabel alloc] initWithFrame:CGRectMake(235, 15, 50, 10)];
    cellFollowsLabel.text = cellFollowsValue;
    cellFollowsLabel.backgroundColor = [UIColor clearColor];
    cellFollowsLabel.textColor = [UIColor colorWithRed:77.0/255.0 green:77.0/255.0 blue:76.0/255.0 alpha:1.0f];
    cellFollowsLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10];
    [cell.contentView addSubview:cellFollowsLabel];
    [cellFollowsLabel release];
    
    
    // label to display high concept
    NSString *text = [startUpHighConceptArray objectAtIndex:indexPath.row];
    CGSize constraint = CGSizeMake(270, 20000.0f);
    CGSize size = [text sizeWithFont:[UIFont fontWithName:@"Helvetica-Light" size:14] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    UILabel *cellHighConceptLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 35, 210, size.height)];
    cellHighConceptLabel.lineBreakMode = UILineBreakModeWordWrap;
    cellHighConceptLabel.numberOfLines = 50;
    cellHighConceptLabel.backgroundColor = [UIColor clearColor];
    cellHighConceptLabel.text = text;
    cellHighConceptLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    [cell.contentView addSubview:cellHighConceptLabel];
    [cellHighConceptLabel release];
    
    //label to display locations
    UILabel *cellLocationLabel = [[[UILabel alloc] initWithFrame:CGRectMake(68, cellHighConceptLabel.frame.size.height + 35, 210, 30)] autorelease];//61
    cellLocationLabel.lineBreakMode = UILineBreakModeWordWrap;
    cellLocationLabel.text = [startUpLocationsArray objectAtIndex:indexPath.row];
    cellLocationLabel.backgroundColor = [UIColor clearColor];
    cellLocationLabel.textColor = [UIColor colorWithRed:77.0/255.0 green:77.0/255.0 blue:76.0/255.0 alpha:1.0f];
    cellLocationLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10];
    [cell.contentView addSubview:cellLocationLabel];
    
    //label to display markets
    UILabel *cellMarketLabel = [[[UILabel alloc] initWithFrame:CGRectMake(67, cellHighConceptLabel.frame.size.height + 50, 210, 30)] autorelease];//61
    cellMarketLabel.text = [startUpMarketsArray objectAtIndex:indexPath.row];
    cellMarketLabel.backgroundColor = [UIColor clearColor];
    cellMarketLabel.textColor = [UIColor colorWithRed:77.0/255.0 green:77.0/255.0 blue:76.0/255.0 alpha:1.0f];
    cellMarketLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10];
    [cell.contentView addSubview:cellMarketLabel];
    
    return cell; 
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    if([startUpIdArray count] == 0)
    {
        emptyAlertView.hidden = NO;
    }
    if([startUpIdArray count] != 0)
    { 
        emptyAlertView.hidden = YES;
    }
    
    return [startUpIdArray count];
}

// --dynamic cell height according to the text--
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *text = [startUpHighConceptArray objectAtIndex:indexPath.row];
    CGSize constraint = CGSizeMake(270, 20000.0f);
    CGSize size = [text sizeWithFont:[UIFont fontWithName:@"Helvetica-Light" size:14] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    return size.height + 85;
    // return the height of the particular row in the table view
}

// --navigate to activity details--
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _rowNumberInStartUps = indexPath.row;
    
    StartUpDetailsViewController *detailsViewController;
    detailsViewController = [[[StartUpDetailsViewController alloc] initWithNibName:@"StartUpDetailsViewController_iPhone" bundle:nil] autorelease];
    
    [self.navigationController pushViewController:detailsViewController animated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    _dbmanager = [[DBManager alloc] init];
    [_dbmanager openDB];
    
    startUpIdArray = [NSMutableArray new];
    startUpNameArray = [NSMutableArray new];
    startUpLinkArray = [NSMutableArray new];
    startUpImageUrlArray = [NSMutableArray new];
    startUpProdDescArray = [NSMutableArray new];
    startUpHighConceptArray = [NSMutableArray new];
    startUpFollowCountArray = [NSMutableArray new];
    startUpLocationsArray = [NSMutableArray new];
    startUpMarketsArray = [NSMutableArray new];
    startUpImageDisplayArray = [NSMutableArray new];
    
    
    userFollowingIds = [NSMutableArray new];
    userPortfolioIdsArray = [NSMutableArray new];
    
//    _dbmanager.startUpIdArrayFromDB = [NSMutableArray new];
//    _dbmanager.startUpNameArrayFromDB = [NSMutableArray new];
//    _dbmanager.startUpLinkArrayFromDB = [NSMutableArray new];
//    _dbmanager.startUpImageUrlArrayFromDB = [NSMutableArray new];
//    _dbmanager.startUpProdDescArrayFromDB = [NSMutableArray new];
//    _dbmanager.startUpHighConceptArrayFromDB = [NSMutableArray new];
//    _dbmanager.startUpFollowCountArrayFromDB = [NSMutableArray new];
//    _dbmanager.startUpLocationsArrayFromDB = [NSMutableArray new];
//    _dbmanager.startUpMarketsArrayFromDB = [NSMutableArray new];
//    _dbmanager.startUpImageDisplayArrayFromDB = [NSMutableArray new];
    
    _dbmanager.startUpIdArrayFromDB = [[NSMutableArray new] autorelease];
    _dbmanager.startUpNameArrayFromDB = [[NSMutableArray new] autorelease];
    _dbmanager.startUpLinkArrayFromDB = [[NSMutableArray new] autorelease];
    _dbmanager.startUpImageUrlArrayFromDB = [[NSMutableArray new] autorelease];
    _dbmanager.startUpProdDescArrayFromDB = [[NSMutableArray new] autorelease];
    _dbmanager.startUpHighConceptArrayFromDB = [[NSMutableArray new] autorelease];
    _dbmanager.startUpFollowCountArrayFromDB = [[NSMutableArray new] autorelease];
    _dbmanager.startUpLocationsArrayFromDB = [[NSMutableArray new] autorelease];
    _dbmanager.startUpMarketsArrayFromDB = [[NSMutableArray new] autorelease];
    _dbmanager.startUpImageDisplayArrayFromDB = [[NSMutableArray new] autorelease];

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    

    //Navigation Bar Label
    navigationBarLabelInStartUp = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 260, 20)];
    navigationBarLabelInStartUp.textAlignment = UITextAlignmentCenter;
    navigationBarLabelInStartUp.textColor = [UIColor whiteColor];
    navigationBarLabelInStartUp.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
    navigationBarLabelInStartUp.backgroundColor = [UIColor clearColor];
    navigationBarLabelInStartUp.text = @"Startups - Trending";
    [self.navigationController.navigationBar addSubview:navigationBarLabelInStartUp];
    [navigationBarLabelInStartUp release];
    
    
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
    
    refreshViewTopTrending = [[UIView alloc] initWithFrame:CGRectMake(0, -52, 320, 52)];
    
    imageViewTopTrending = [[UIImageView alloc] initWithFrame:CGRectMake(50, 5, 20, 45)];
    imageViewTopTrending.image = [UIImage imageNamed:@"refresh_arrow.png"];
    imageViewTopTrending.transform = CGAffineTransformMakeRotation(3.142);
    [refreshViewTopTrending addSubview:imageViewTopTrending];
    [imageViewTopTrending release];
    
    imageViewLogoTopTrending = [[UIImageView alloc] initWithFrame:CGRectMake(200, 5, 86, 36)];
    imageViewLogoTopTrending.image = [UIImage imageNamed:@"angel_logo.png"];
    [refreshViewTopTrending addSubview:imageViewLogoTopTrending];
    [imageViewLogoTopTrending release];
    
    refreshSpinnerTopTrending = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(50, 5, 20, 20)];
    refreshSpinnerTopTrending.hidden = YES;
    [refreshViewTopTrending addSubview:refreshSpinnerTopTrending];
    [refreshSpinnerTopTrending release];
    
    [table addSubview:refreshViewTopTrending];
    [refreshViewTopTrending release];
    
    ////////////////////////////// PULL TO REFRESH //////////////////////////////
    
    loadingView.hidden = NO;
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(invokeTrendingStartUps) userInfo:nil repeats:NO];
}

-(void) invokeTrendingStartUps
{
    [self getStartUpsFollowedByUser];
    [self getTrendingStartUps];
    [table reloadData];
}

-(void) getStartUpsFollowedByUser
{
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if (!(internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
    {
        NSURL *startUpFollowingUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.angel.co/1/users/%@/following/ids?type=startup",[userDetailsArray objectAtIndex:1]]];
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
        
        for(int k=0; k<[userFollowingIds count]; k++)
        {
            NSMutableString * theMutableString = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@",[userFollowingIds objectAtIndex:k]]];
            
            [theMutableString replaceOccurrencesOfString:@"(" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
            [theMutableString replaceOccurrencesOfString:@")" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
            [theMutableString replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
            [theMutableString replaceOccurrencesOfString:@"\n" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
            
            [theMutableString release];
        }
    }
}

-(void) filterButtonSelected:(id)sender
{
    if(_showFilterMenuInStartUps == FALSE)
    {
        [UIView beginAnimations:nil context:NULL];
        filterViewInStartUps.frame = CGRectMake(0, 0, 320, 480);
        filtersButtonsViewInStartUps.frame = CGRectMake(50, 0, 220, 155);
        [UIView setAnimationDuration:0.3];
        [UIView commitAnimations];
        
        _showFilterMenuInStartUps = TRUE;
    }
    else
    {
        [UIView beginAnimations:nil context:NULL];
        filterViewInStartUps.frame = CGRectMake(0, -481, 320, 480);
        filtersButtonsViewInStartUps.frame = CGRectMake(50, -481, 220, 155);
        [UIView setAnimationDuration:0.3];
        [UIView commitAnimations];
        
        _showFilterMenuInStartUps = FALSE;
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
    [startUpIdArray removeAllObjects];
    [startUpNameArray removeAllObjects];
    [startUpLinkArray removeAllObjects];
    [startUpImageUrlArray removeAllObjects];
    [startUpProdDescArray removeAllObjects];
    [startUpHighConceptArray removeAllObjects];
    [startUpFollowCountArray removeAllObjects];
    [startUpLocationsArray removeAllObjects];
    [startUpMarketsArray removeAllObjects];
    [startUpImageDisplayArray removeAllObjects];
    
    [_dbmanager.startUpIdArrayFromDB removeAllObjects];
    [_dbmanager.startUpNameArrayFromDB removeAllObjects];
    [_dbmanager.startUpLinkArrayFromDB removeAllObjects];
    [_dbmanager.startUpImageUrlArrayFromDB removeAllObjects];
    [_dbmanager.startUpProdDescArrayFromDB removeAllObjects];
    [_dbmanager.startUpHighConceptArrayFromDB removeAllObjects];
    [_dbmanager.startUpFollowCountArrayFromDB removeAllObjects];
    [_dbmanager.startUpLocationsArrayFromDB removeAllObjects];
    [_dbmanager.startUpMarketsArrayFromDB removeAllObjects];
    [_dbmanager.startUpImageDisplayArrayFromDB removeAllObjects];
    
    int _tagId = [sender tag];
    
    switch (_tagId) {
        case 1:NSLog(@"\nTrending");
            _filterTrending = TRUE;
            _filterFollowing = FALSE;
            _filterPortfolio = FALSE;
            
            loadingView.hidden = NO;
            [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(invokeStartUpsFromFilter) userInfo:nil repeats:NO];
            
            
            refreshViewTopTrending.hidden = NO;
            navigationBarLabelInStartUp.text = @"Startups - Trending";
            [self filterButtonSelected:sender];
//            [table reloadData];
            break;
            
        case 2:NSLog(@"\nFollowing");
            _filterTrending = FALSE;
            _filterFollowing = TRUE;
            _filterPortfolio = FALSE;
            
            loadingView.hidden = NO;
            [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(invokeStartUpsFromFilter) userInfo:nil repeats:NO];
            
            
            refreshViewTopTrending.hidden = YES;
            navigationBarLabelInStartUp.text = @"Startups - Following";
            [self filterButtonSelected:sender];
//            [table reloadData];
            break;
            
        case 3:NSLog(@"\nPortfolio");
            _filterTrending = FALSE;
            _filterFollowing = FALSE;
            _filterPortfolio = TRUE;
            
            loadingView.hidden = NO;
            [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(invokeStartUpsFromFilter) userInfo:nil repeats:NO];
            
            
            refreshViewTopTrending.hidden = YES;
            navigationBarLabelInStartUp.text = @"Startups - Portfolio";
            [self filterButtonSelected:sender];
//            [table reloadData];
            break;
    }
} 


-(void) invokeStartUpsFromFilter
{
    if(_filterTrending == TRUE)
    {
        [self getTrendingStartUps];
    }
    else if(_filterFollowing == TRUE)
    {
        [self getFollowingStartUps];
    }
    else if(_filterPortfolio == TRUE)
    {
        [self getPortfolioStartUps];
    }
    [table reloadData];
}

-(void) getTrendingStartUps
{
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
    {
        [_dbmanager retrieveTrendingDetails];
        
        [startUpIdArray addObjectsFromArray:_dbmanager.startUpIdArrayFromDB];
        [startUpNameArray addObjectsFromArray:_dbmanager.startUpNameArrayFromDB];
        [startUpLinkArray addObjectsFromArray:_dbmanager.startUpLinkArrayFromDB];
        [startUpImageUrlArray addObjectsFromArray:_dbmanager.startUpImageUrlArrayFromDB];
        [startUpProdDescArray addObjectsFromArray:_dbmanager.startUpProdDescArrayFromDB];
        [startUpHighConceptArray addObjectsFromArray:_dbmanager.startUpHighConceptArrayFromDB];
        [startUpFollowCountArray addObjectsFromArray:_dbmanager.startUpFollowCountArrayFromDB];
        [startUpLocationsArray addObjectsFromArray:_dbmanager.startUpLocationsArrayFromDB];
        [startUpMarketsArray addObjectsFromArray:_dbmanager.startUpMarketsArrayFromDB];
        
        for(int j=0; j < [_dbmanager.startUpImageDisplayArrayFromDB count]; j++)
        {
            [startUpImageDisplayArray addObject:[UIImage imageWithData:[NSData dataWithContentsOfFile:[_dbmanager.startUpImageDisplayArrayFromDB objectAtIndex:j]]]];
        }
    }
    else
    {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.angel.co/1/startups?filter=trending"]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod: @"GET"];
        
        NSError *error;                                   
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
        //Process json data
        
        NSDictionary* json = [NSJSONSerialization 
                              JSONObjectWithData:data 
                              options:kNilOptions 
                              error:&error];
        
        NSArray *startUpTrendingHidden = [json valueForKey:@"hidden"]; //2
        NSArray *startUpTrendingId = [json valueForKey:@"id"];
        NSArray *startUpTrendingName = [json valueForKey:@"name"];
        NSArray *startUpTrendingLink = [json valueForKey:@"angellist_url"];
        NSArray *startUpTrendingImageUrl = [json valueForKey:@"thumb_url"];
        NSArray *startUpTrendingProdDesc = [json valueForKey:@"product_desc"];
        NSArray *startUpTrendingHighConcept = [json valueForKey:@"high_concept"];
        NSArray *startUpTrendingFollowCount = [json valueForKey:@"follower_count"];
        NSArray *startUpTrendingLocations = [[json valueForKey:@"locations"] valueForKey:@"display_name"];
        NSArray *startUpTrendingMarkets = [[json valueForKey:@"markets"] valueForKey:@"display_name"];
        
        
        
        for (int z=0; z < [startUpTrendingHidden count]; z++) 
        {
            if([[startUpTrendingHidden objectAtIndex:z] intValue] == 0)
            {
                NSString *startUpId = [startUpTrendingId objectAtIndex:z];
                [startUpIdArray addObject:startUpId];
                
                NSString *startUpName = [startUpTrendingName objectAtIndex:z];
                [startUpNameArray addObject:startUpName];
                
                NSString *startUpLink = [startUpTrendingLink objectAtIndex:z];
                [startUpLinkArray addObject:startUpLink];
                
                NSString *startUpImageUrl = [startUpTrendingImageUrl objectAtIndex:z];
                [startUpImageUrlArray addObject:startUpImageUrl];
                [startUpImageDisplayArray addObject:[UIImage imageNamed:@"placeholder.png"]];
                
                NSString *startUpProdDesc = [startUpTrendingProdDesc objectAtIndex:z];
                if(startUpProdDesc == (NSString *)[NSNull null])
                {
                    [startUpProdDescArray addObject:@"No Information"];
                }
                else
                {
                    [startUpProdDescArray addObject:startUpProdDesc];
                }
                
                
                NSString *startUpHighConcept = [startUpTrendingHighConcept objectAtIndex:z];
                if(startUpHighConcept == (NSString *)[NSNull null])
                {
                    [startUpHighConceptArray addObject:@"No Information"];
                }
                else
                {
                    [startUpHighConceptArray addObject:startUpHighConcept];
                }
                
                
                
                
                NSString *startUpLocations = [startUpTrendingLocations objectAtIndex:z];
                if(startUpLocations == (NSString *)[NSNull null])
                {
                    [startUpLocationsArray addObject:@"No Information"];
                }
                else
                {
                    [startUpLocationsArray addObject:startUpLocations];
                }
                
                
                NSString *startUpMarkets = [startUpTrendingMarkets objectAtIndex:z];
                if(startUpMarkets == (NSString *)[NSNull null])
                {
                    [startUpMarketsArray addObject:@"No Information"];
                }
                else
                {
                    [startUpMarketsArray addObject:startUpMarkets];
                }
                
                
                NSString *startUpFollowCount = [startUpTrendingFollowCount objectAtIndex:z];
                [startUpFollowCountArray addObject:startUpFollowCount];
                
            }//End IF
        }//End For
        
        
        
        for (int k=0; k < [startUpNameArray count]; k++) 
        {
            NSMutableString * theMutableString = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@",[startUpNameArray objectAtIndex:k]]];
            [theMutableString replaceOccurrencesOfString:@"'" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
            [startUpNameArray replaceObjectAtIndex:k withObject:theMutableString];
            [theMutableString release];
        }
        
        for (int k=0; k < [startUpProdDescArray count]; k++) 
        {
            NSMutableString * theMutableString = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@",[startUpProdDescArray objectAtIndex:k]]];
            [theMutableString replaceOccurrencesOfString:@"'" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
            [startUpProdDescArray replaceObjectAtIndex:k withObject:theMutableString];
            [theMutableString release];
        }
        
        for (int k=0; k < [startUpHighConceptArray count]; k++) 
        {
            NSMutableString * theMutableString = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@",[startUpHighConceptArray objectAtIndex:k]]];
            [theMutableString replaceOccurrencesOfString:@"'" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
            [startUpHighConceptArray replaceObjectAtIndex:k withObject:theMutableString];
            [theMutableString release];
        }
        
        for (int k=0; k < [startUpLocationsArray count]; k++) 
        {
            NSMutableString * theMutableString = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@",[startUpLocationsArray objectAtIndex:k]]];
            
            [theMutableString replaceOccurrencesOfString:@"\"" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
            [theMutableString replaceOccurrencesOfString:@"(" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
            [theMutableString replaceOccurrencesOfString:@")" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
            [theMutableString replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
            [theMutableString replaceOccurrencesOfString:@"\n" withString:@" " options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
            
            [startUpLocationsArray replaceObjectAtIndex:k withObject:theMutableString];
            [theMutableString release];
        }
        
        for (int k=0; k < [startUpMarketsArray count]; k++) 
        {
            NSMutableString * theMutableString = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@",[startUpMarketsArray objectAtIndex:k]]];
            
            [theMutableString replaceOccurrencesOfString:@"\"" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
            [theMutableString replaceOccurrencesOfString:@"(" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
            [theMutableString replaceOccurrencesOfString:@")" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
            [theMutableString replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
            [theMutableString replaceOccurrencesOfString:@"\n" withString:@" " options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
            
            [startUpMarketsArray replaceObjectAtIndex:k withObject:theMutableString];
            [theMutableString release];
        }
        
        [self saveTrendingStartUps];
        [self loadImages];
    }
    loadingView.hidden = YES;
}

-(void) getFollowingStartUps
{
    NSString *urlToConcat = @"";
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if (!(internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
    {
        urlToConcat = [NSString stringWithFormat:@"https://api.angel.co/1/startups/batch?ids=%@",[userFollowingIds componentsJoinedByString:@","]];
    }
    [self loadFollowingStartUps:urlToConcat];
}

-(void) loadFollowingStartUps:(NSString *)urlString
{
    
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
    {
        [_dbmanager retrieveFollowingDetails];
            
        [startUpIdArray addObjectsFromArray:_dbmanager.startUpIdArrayFromDB];
        [startUpNameArray addObjectsFromArray:_dbmanager.startUpNameArrayFromDB];
        [startUpLinkArray addObjectsFromArray:_dbmanager.startUpLinkArrayFromDB];
        [startUpImageUrlArray addObjectsFromArray:_dbmanager.startUpImageUrlArrayFromDB];
        [startUpProdDescArray addObjectsFromArray:_dbmanager.startUpProdDescArrayFromDB];
        [startUpHighConceptArray addObjectsFromArray:_dbmanager.startUpHighConceptArrayFromDB];
        [startUpFollowCountArray addObjectsFromArray:_dbmanager.startUpFollowCountArrayFromDB];
        [startUpLocationsArray addObjectsFromArray:_dbmanager.startUpLocationsArrayFromDB];
        [startUpMarketsArray addObjectsFromArray:_dbmanager.startUpMarketsArrayFromDB];
        
        for(int j=0; j < [_dbmanager.startUpImageDisplayArrayFromDB count]; j++)
        {
            [startUpImageDisplayArray addObject:[UIImage imageWithData:[NSData dataWithContentsOfFile:[_dbmanager.startUpImageDisplayArrayFromDB objectAtIndex:j]]]];
        }
    }
    else
    {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod: @"GET"];
        
        NSError *error;                                   
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
        //Process json data
        
        NSDictionary* json = [NSJSONSerialization 
                              JSONObjectWithData:data 
                              options:kNilOptions 
                              error:&error];
        
        NSArray *startUpFollowingHidden = [json valueForKey:@"hidden"]; //2
        NSArray *startUpFollowingId = [json valueForKey:@"id"];
        NSArray *startUpFollowingName = [json valueForKey:@"name"];
        NSArray *startUpFollowingLink = [json valueForKey:@"angellist_url"];
        NSArray *startUpFollowingImageUrl = [json valueForKey:@"thumb_url"];
        NSArray *startUpFollowingProdDesc = [json valueForKey:@"product_desc"];
        NSArray *startUpFollowingHighConcept = [json valueForKey:@"high_concept"];
        NSArray *startUpFollowingFollowCount = [json valueForKey:@"follower_count"];
        NSArray *startUpFollowingLocations = [[json valueForKey:@"locations"] valueForKey:@"display_name"];
        NSArray *startUpFollowingMarkets = [[json valueForKey:@"markets"] valueForKey:@"display_name"];
        
        for (int z=0; z < [startUpFollowingHidden count]; z++) 
        {
            if([[startUpFollowingHidden objectAtIndex:z] intValue] == 0)
            {
                NSString *startUpId = [startUpFollowingId objectAtIndex:z];
                [startUpIdArray addObject:startUpId];
                
                NSString *startUpName = [startUpFollowingName objectAtIndex:z];
                [startUpNameArray addObject:startUpName];
                
                NSString *startUpLink = [startUpFollowingLink objectAtIndex:z];
                [startUpLinkArray addObject:startUpLink];
                
                NSString *startUpImageUrl = [startUpFollowingImageUrl objectAtIndex:z];
                [startUpImageUrlArray addObject:startUpImageUrl];
                [startUpImageDisplayArray addObject:[UIImage imageNamed:@"placeholder.png"]];
                
                NSString *startUpProdDesc = [startUpFollowingProdDesc objectAtIndex:z];
                if(startUpProdDesc == (NSString *)[NSNull null])
                {
                    [startUpProdDescArray addObject:@"No Information"];
                }
                else
                {
                    [startUpProdDescArray addObject:startUpProdDesc];
                }
                
                
                NSString *startUpHighConcept = [startUpFollowingHighConcept objectAtIndex:z];
                if(startUpHighConcept == (NSString *)[NSNull null])
                {
                    [startUpHighConceptArray addObject:@"No Information"];
                }
                else
                {
                    [startUpHighConceptArray addObject:startUpHighConcept];
                }
                
                
                
                
                NSString *startUpLocations = [startUpFollowingLocations objectAtIndex:z];
                if(startUpLocations == (NSString *)[NSNull null])
                {
                    [startUpLocationsArray addObject:@"No Information"];
                }
                else
                {
                    [startUpLocationsArray addObject:startUpLocations];
                }
                
                
                NSString *startUpMarkets = [startUpFollowingMarkets objectAtIndex:z];
                if(startUpMarkets == (NSString *)[NSNull null])
                {
                    [startUpMarketsArray addObject:@"No Information"];
                }
                else
                {
                    [startUpMarketsArray addObject:startUpMarkets];
                }
                
                
                NSString *startUpFollowCount = [startUpFollowingFollowCount objectAtIndex:z];
                [startUpFollowCountArray addObject:startUpFollowCount];
                
            }//End IF
        }//End For
        
        for (int k=0; k < [startUpNameArray count]; k++) 
        {
            NSMutableString * theMutableString = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@",[startUpNameArray objectAtIndex:k]]];
            [theMutableString replaceOccurrencesOfString:@"'" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
            [startUpNameArray replaceObjectAtIndex:k withObject:theMutableString];
            [theMutableString release];
        }
        
        for (int k=0; k < [startUpProdDescArray count]; k++) 
        {
            NSMutableString * theMutableString = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@",[startUpProdDescArray objectAtIndex:k]]];
            [theMutableString replaceOccurrencesOfString:@"'" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
            [startUpProdDescArray replaceObjectAtIndex:k withObject:theMutableString];
            [theMutableString release];
        }
        
        for (int k=0; k < [startUpHighConceptArray count]; k++) 
        {
            NSMutableString * theMutableString = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@",[startUpHighConceptArray objectAtIndex:k]]];
            [theMutableString replaceOccurrencesOfString:@"'" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
            [startUpHighConceptArray replaceObjectAtIndex:k withObject:theMutableString];
            [theMutableString release];
        }
        
        for (int k=0; k < [startUpLocationsArray count]; k++) 
        {
            NSMutableString * theMutableString = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@",[startUpLocationsArray objectAtIndex:k]]];
            
            [theMutableString replaceOccurrencesOfString:@"\"" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
            [theMutableString replaceOccurrencesOfString:@"(" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
            [theMutableString replaceOccurrencesOfString:@")" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
            [theMutableString replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
            [theMutableString replaceOccurrencesOfString:@"\n" withString:@" " options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
            
            [startUpLocationsArray replaceObjectAtIndex:k withObject:theMutableString];
            [theMutableString release];
        }
        
        for (int k=0; k < [startUpMarketsArray count]; k++) 
        {
            NSMutableString * theMutableString = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@",[startUpMarketsArray objectAtIndex:k]]];
            
            [theMutableString replaceOccurrencesOfString:@"\"" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
            [theMutableString replaceOccurrencesOfString:@"(" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
            [theMutableString replaceOccurrencesOfString:@")" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
            [theMutableString replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
            [theMutableString replaceOccurrencesOfString:@"\n" withString:@" " options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
            
            [startUpMarketsArray replaceObjectAtIndex:k withObject:theMutableString];
            [theMutableString release];
        }

        [self saveFollowingStartUps];
        [self loadImages];
    }
   loadingView.hidden = YES;
}

-(void) getPortfolioStartUps
{
    //start loading data
    NSString *urlToConcat = @"";
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if (!(internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
    {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.angel.co/1/startup_roles?user_id=%@",[userDetailsArray objectAtIndex:1]]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod: @"GET"];
        
        NSError *error;                                   //  NSError *error) 
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
        //Process json data
        
        NSDictionary* json = [NSJSONSerialization 
                              JSONObjectWithData:data //1
                              options:kNilOptions 
                              error:&error];
        
        NSArray* startUpPortfolio = [[json objectForKey:@"startup_roles"] valueForKey:@"startup"]; //2
        
        [userPortfolioIdsArray removeAllObjects];
        
        for(int k=0; k<[startUpPortfolio count]; k++)
        {
            NSDictionary *portfolio = [startUpPortfolio objectAtIndex:k];
            
            NSString *startUpPortfolioHidden = [portfolio valueForKey:@"hidden"];
            
            if ([startUpPortfolioHidden intValue] == 0) 
            {
                NSString *startUpPortfolioId = [portfolio valueForKey:@"id"];
                [userPortfolioIdsArray addObject:startUpPortfolioId];
            }   
        }
        
        urlToConcat = [NSString stringWithFormat:@"https://api.angel.co/1/startups/batch?ids=%@",[userPortfolioIdsArray componentsJoinedByString:@","]];
    }
    
    [self loadPortfolioStartUps:urlToConcat];
    
}

-(void) loadPortfolioStartUps:(NSString *)urlString
{
    
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
    {
        [_dbmanager retrievePortfolioDetails];
        
        [startUpIdArray addObjectsFromArray:_dbmanager.startUpIdArrayFromDB];
        [startUpNameArray addObjectsFromArray:_dbmanager.startUpNameArrayFromDB];
        [startUpLinkArray addObjectsFromArray:_dbmanager.startUpLinkArrayFromDB];
        [startUpImageUrlArray addObjectsFromArray:_dbmanager.startUpImageUrlArrayFromDB];
        [startUpProdDescArray addObjectsFromArray:_dbmanager.startUpProdDescArrayFromDB];
        [startUpHighConceptArray addObjectsFromArray:_dbmanager.startUpHighConceptArrayFromDB];
        [startUpFollowCountArray addObjectsFromArray:_dbmanager.startUpFollowCountArrayFromDB];
        [startUpLocationsArray addObjectsFromArray:_dbmanager.startUpLocationsArrayFromDB];
        [startUpMarketsArray addObjectsFromArray:_dbmanager.startUpMarketsArrayFromDB];
        
        for(int j=0; j < [_dbmanager.startUpImageDisplayArrayFromDB count]; j++)
        {
            [startUpImageDisplayArray addObject:[UIImage imageWithData:[NSData dataWithContentsOfFile:[_dbmanager.startUpImageDisplayArrayFromDB objectAtIndex:j]]]];
        }
    }
    else
    {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod: @"GET"];
        
        NSError *error;                                   
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
        //Process json data
        
        NSDictionary* json = [NSJSONSerialization 
                              JSONObjectWithData:data 
                              options:kNilOptions 
                              error:&error];
        
        NSArray *startUpFollowingHidden = [json valueForKey:@"hidden"]; //2
        NSArray *startUpFollowingId = [json valueForKey:@"id"];
        NSArray *startUpFollowingName = [json valueForKey:@"name"];
        NSArray *startUpFollowingLink = [json valueForKey:@"angellist_url"];
        NSArray *startUpFollowingImageUrl = [json valueForKey:@"thumb_url"];
        NSArray *startUpFollowingProdDesc = [json valueForKey:@"product_desc"];
        NSArray *startUpFollowingHighConcept = [json valueForKey:@"high_concept"];
        NSArray *startUpFollowingFollowCount = [json valueForKey:@"follower_count"];
        NSArray *startUpFollowingLocations = [[json valueForKey:@"locations"] valueForKey:@"display_name"];
        NSArray *startUpFollowingMarkets = [[json valueForKey:@"markets"] valueForKey:@"display_name"];
        
        for (int z=0; z < [startUpFollowingHidden count]; z++) 
        {
            if([[startUpFollowingHidden objectAtIndex:z] intValue] == 0)
            {
                NSString *startUpId = [startUpFollowingId objectAtIndex:z];
                [startUpIdArray addObject:startUpId];
                
                NSString *startUpName = [startUpFollowingName objectAtIndex:z];
                [startUpNameArray addObject:startUpName];
                
                NSString *startUpLink = [startUpFollowingLink objectAtIndex:z];
                [startUpLinkArray addObject:startUpLink];
                
                NSString *startUpImageUrl = [startUpFollowingImageUrl objectAtIndex:z];
                [startUpImageUrlArray addObject:startUpImageUrl];
                [startUpImageDisplayArray addObject:[UIImage imageNamed:@"placeholder.png"]];
                
                NSString *startUpProdDesc = [startUpFollowingProdDesc objectAtIndex:z];
                if(startUpProdDesc == (NSString *)[NSNull null])
                {
                    [startUpProdDescArray addObject:@"No Information"];
                }
                else
                {
                    [startUpProdDescArray addObject:startUpProdDesc];
                }
                
                
                NSString *startUpHighConcept = [startUpFollowingHighConcept objectAtIndex:z];
                if(startUpHighConcept == (NSString *)[NSNull null])
                {
                    [startUpHighConceptArray addObject:@"No Information"];
                }
                else
                {
                    [startUpHighConceptArray addObject:startUpHighConcept];
                }
                
                
                
                
                NSString *startUpLocations = [startUpFollowingLocations objectAtIndex:z];
                if(startUpLocations == (NSString *)[NSNull null])
                {
                    [startUpLocationsArray addObject:@"No Information"];
                }
                else
                {
                    [startUpLocationsArray addObject:startUpLocations];
                }
                
                
                NSString *startUpMarkets = [startUpFollowingMarkets objectAtIndex:z];
                if(startUpMarkets == (NSString *)[NSNull null])
                {
                    [startUpMarketsArray addObject:@"No Information"];
                }
                else
                {
                    [startUpMarketsArray addObject:startUpMarkets];
                }
                
                
                NSString *startUpFollowCount = [startUpFollowingFollowCount objectAtIndex:z];
                [startUpFollowCountArray addObject:startUpFollowCount];
                
            }//End IF
        }//End For
        
        for (int k=0; k < [startUpNameArray count]; k++) 
        {
            NSMutableString * theMutableString = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@",[startUpNameArray objectAtIndex:k]]];
            [theMutableString replaceOccurrencesOfString:@"'" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
            [startUpNameArray replaceObjectAtIndex:k withObject:theMutableString];
            [theMutableString release];
        }
        
        for (int k=0; k < [startUpProdDescArray count]; k++) 
        {
            NSMutableString * theMutableString = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@",[startUpProdDescArray objectAtIndex:k]]];
            [theMutableString replaceOccurrencesOfString:@"'" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
            [startUpProdDescArray replaceObjectAtIndex:k withObject:theMutableString];
            [theMutableString release];
        }
        
        for (int k=0; k < [startUpHighConceptArray count]; k++) 
        {
            NSMutableString * theMutableString = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@",[startUpHighConceptArray objectAtIndex:k]]];
            [theMutableString replaceOccurrencesOfString:@"'" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
            [startUpHighConceptArray replaceObjectAtIndex:k withObject:theMutableString];
            [theMutableString release];
        }
        
        for (int k=0; k < [startUpLocationsArray count]; k++) 
        {
            NSMutableString * theMutableString = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@",[startUpLocationsArray objectAtIndex:k]]];
            
            [theMutableString replaceOccurrencesOfString:@"\"" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
            [theMutableString replaceOccurrencesOfString:@"(" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
            [theMutableString replaceOccurrencesOfString:@")" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
            [theMutableString replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
            [theMutableString replaceOccurrencesOfString:@"\n" withString:@" " options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
            
            [startUpLocationsArray replaceObjectAtIndex:k withObject:theMutableString];
            [theMutableString release];
        }
        
        for (int k=0; k < [startUpMarketsArray count]; k++) 
        {
            NSMutableString * theMutableString = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@",[startUpMarketsArray objectAtIndex:k]]];
            
            [theMutableString replaceOccurrencesOfString:@"\"" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
            [theMutableString replaceOccurrencesOfString:@"(" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
            [theMutableString replaceOccurrencesOfString:@")" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
            [theMutableString replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
            [theMutableString replaceOccurrencesOfString:@"\n" withString:@" " options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
            
            [startUpMarketsArray replaceObjectAtIndex:k withObject:theMutableString];
            [theMutableString release];
        }
        
        [self savePortfolioStartUps];
        [self loadImages];
    }
    loadingView.hidden = YES;
}

//Image caching
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
        //if((startUpImageDisplayArray != nil) && ([startUpImageDisplayArray count] == [startUpImageUrlArray count]) )
    //{       
        for(int z=0; z < [startUpImageDisplayArray count]; z++)
        {
            if([[startUpImageDisplayArray objectAtIndex:z] isEqual:[UIImage imageNamed:@"placeholder.png"]])
            {
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[startUpImageUrlArray objectAtIndex:z]]]];
                [startUpImageDisplayArray replaceObjectAtIndex:z withObject:image];
                //[table reloadData];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:z inSection: 0];
                UITableViewCell *cell = [table cellForRowAtIndexPath:indexPath];
                UIImageView *cellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(7, 12, 50, 50)];
                cellImageView.image = [startUpImageDisplayArray objectAtIndex:indexPath.row];
                [cell.contentView addSubview:cellImageView];
                [cellImageView release];
            }
        }
   // }
}


//DB Operations
-(void) saveTrendingStartUps
{
    [_dbmanager deleteRowsFromTrending];
    for(int z = 0; z < [startUpIdArray count]; z++)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSString *serialId = [NSString stringWithFormat:@"%d",(z+1)];
        NSString *trendingId = [NSString stringWithFormat:@"%@",[startUpIdArray objectAtIndex:z]];
        NSString *trendingName = [NSString stringWithFormat:@"%@",[startUpNameArray objectAtIndex:z]];
        NSString *trendingLink = [NSString stringWithFormat:@"%@",[startUpLinkArray objectAtIndex:z]];
        NSString *trendingImageUrl = [NSString stringWithFormat:@"%@",[startUpImageUrlArray objectAtIndex:z]];

        NSString *trendingProdDesc = [NSString stringWithFormat:@"%@",[startUpProdDescArray objectAtIndex:z]];
        NSString *trendingHighConcept = [NSString stringWithFormat:@"%@",[startUpHighConceptArray objectAtIndex:z]];
        NSString *trendingFollowCount = [NSString stringWithFormat:@"%@",[startUpFollowCountArray objectAtIndex:z]];
        NSString *trendingLocations = [NSString stringWithFormat:@"%@",[startUpLocationsArray objectAtIndex:z]];
        NSString *trendingMarkets = [NSString stringWithFormat:@"%@",[startUpMarketsArray objectAtIndex:z]];
        
        
        NSString *savedImagePathforTrendingStartUp = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"trending%d.jpg",(z+1)]];
        UIImage *imageForTrending = [UIImage imageNamed:@"placeholder.png"];
        NSData *imageDataforTrendingStartUp = UIImagePNGRepresentation(imageForTrending);
        [imageDataforTrendingStartUp writeToFile:savedImagePathforTrendingStartUp atomically:NO];
        
        
        
        [_dbmanager insertRecordIntoTrendingTable:@"Trending" withField1:@"Id" field1Value:serialId andField2:@"trendingId" field2Value:trendingId andField3:@"trendingName" field3Value:trendingName andField4:@"trendingLink" field4Value:trendingLink andField5:@"trendingImageUrl" field5Value:trendingImageUrl andField6:@"trendingProdDesc" field6Value:trendingProdDesc andField7:@"trendingHighConcept" field7Value:trendingHighConcept andField8:@"trendingFollowCount" field8Value:trendingFollowCount andField9:@"trendingLocations" field9Value:trendingLocations andField10:@"trendingMarkets" field10Value:trendingMarkets andField11:@"trendingImagePath" field11Value:savedImagePathforTrendingStartUp];
    }
    
    [self performSelectorInBackground:@selector(downloadImagesOfTrendingStartUps) withObject:nil];
}

-(void) saveFollowingStartUps
{
    [_dbmanager deleteRowsFromFollowing];
    for(int z = 0; z < [startUpIdArray count]; z++)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSString *serialId = [NSString stringWithFormat:@"%d",(z+1)];
        NSString *followingId = [NSString stringWithFormat:@"%@",[startUpIdArray objectAtIndex:z]];
        NSString *followingName = [NSString stringWithFormat:@"%@",[startUpNameArray objectAtIndex:z]];
        NSString *followingLink = [NSString stringWithFormat:@"%@",[startUpLinkArray objectAtIndex:z]];
        NSString *followingImageUrl = [NSString stringWithFormat:@"%@",[startUpImageUrlArray objectAtIndex:z]];
        
        NSString *followingProdDesc = [NSString stringWithFormat:@"%@",[startUpProdDescArray objectAtIndex:z]];
        NSString *followingHighConcept = [NSString stringWithFormat:@"%@",[startUpHighConceptArray objectAtIndex:z]];
        NSString *followingFollowCount = [NSString stringWithFormat:@"%@",[startUpFollowCountArray objectAtIndex:z]];
        NSString *followingLocations = [NSString stringWithFormat:@"%@",[startUpLocationsArray objectAtIndex:z]];
        NSString *followingMarkets = [NSString stringWithFormat:@"%@",[startUpMarketsArray objectAtIndex:z]];
        
        
        NSString *savedImagePathforFollowingStartUp = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"following%d.jpg",(z+1)]];
        UIImage *imageForFollowing = [UIImage imageNamed:@"placeholder.png"];
        NSData *imageDataforFollowingStartUp = UIImagePNGRepresentation(imageForFollowing);
        [imageDataforFollowingStartUp writeToFile:savedImagePathforFollowingStartUp atomically:NO];
        
        [_dbmanager insertRecordIntoFollowingTable:@"Following" withField1:@"Id" field1Value:serialId andField2:@"followingId" field2Value:followingId andField3:@"followingName" field3Value:followingName andField4:@"followingLink" field4Value:followingLink andField5:@"followingImageUrl" field5Value:followingImageUrl andField6:@"followingProdDesc" field6Value:followingProdDesc andField7:@"followingHighConcept" field7Value:followingHighConcept andField8:@"followingFollowCount" field8Value:followingFollowCount andField9:@"followingLocations" field9Value:followingLocations andField10:@"followingMarkets" field10Value:followingMarkets andField11:@"followingImagePath" field11Value:savedImagePathforFollowingStartUp];
    }
    
    [self performSelectorInBackground:@selector(downloadImagesOfFollowingStartUps) withObject:nil];
}

-(void) savePortfolioStartUps
{
    [_dbmanager deleteRowsFromPortfolio];
    for(int z = 0; z < [startUpIdArray count]; z++)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSString *serialId = [NSString stringWithFormat:@"%d",(z+1)];
        NSString *portfolioId = [NSString stringWithFormat:@"%@",[startUpIdArray objectAtIndex:z]];
        NSString *portfolioName = [NSString stringWithFormat:@"%@",[startUpNameArray objectAtIndex:z]];
        NSString *portfolioLink = [NSString stringWithFormat:@"%@",[startUpLinkArray objectAtIndex:z]];
        NSString *portfolioImageUrl = [NSString stringWithFormat:@"%@",[startUpImageUrlArray objectAtIndex:z]];
        
        NSString *portfolioProdDesc = [NSString stringWithFormat:@"%@",[startUpProdDescArray objectAtIndex:z]];
        NSString *portfolioHighConcept = [NSString stringWithFormat:@"%@",[startUpHighConceptArray objectAtIndex:z]];
        NSString *portfolioFollowCount = [NSString stringWithFormat:@"%@",[startUpFollowCountArray objectAtIndex:z]];
        NSString *portfolioLocations = [NSString stringWithFormat:@"%@",[startUpLocationsArray objectAtIndex:z]];
        NSString *portfolioMarkets = [NSString stringWithFormat:@"%@",[startUpMarketsArray objectAtIndex:z]];
        
        
        NSString *savedImagePathforPortfolioStartUp = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"portfolio%d.jpg",(z+1)]];
        UIImage *imageForPortfolio = [UIImage imageNamed:@"placeholder.png"];
        NSData *imageDataforPortfolioStartUp = UIImagePNGRepresentation(imageForPortfolio);
        [imageDataforPortfolioStartUp writeToFile:savedImagePathforPortfolioStartUp atomically:NO];
        
        [_dbmanager insertRecordIntoPortfolioTable:@"Portfolio" withField1:@"Id" field1Value:serialId andField2:@"portfolioId" field2Value:portfolioId andField3:@"portfolioName" field3Value:portfolioName andField4:@"portfolioLink" field4Value:portfolioLink andField5:@"portfolioImageUrl" field5Value:portfolioImageUrl andField6:@"portfolioProdDesc" field6Value:portfolioProdDesc andField7:@"portfolioHighConcept" field7Value:portfolioHighConcept andField8:@"portfolioFollowCount" field8Value:portfolioFollowCount andField9:@"portfolioLocations" field9Value:portfolioLocations andField10:@"portfolioMarkets" field10Value:portfolioMarkets andField11:@"portfolioImagePath" field11Value:savedImagePathforPortfolioStartUp];
    }
    
    [self performSelectorInBackground:@selector(downloadImagesOfPortfolioStartUps) withObject:nil];
}

-(void) downloadImagesOfTrendingStartUps
{
    NSMutableArray *startUpImageUrlArrayToDownload = [NSMutableArray new];
    [startUpImageUrlArrayToDownload addObjectsFromArray:startUpImageUrlArray];
    
    for (int z=0; z < [startUpImageUrlArrayToDownload count]; z++) 
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        
        NSString *savedImagePathForActor = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"trending%d.jpg",(z+1)]];
        UIImage *imageForActor = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[startUpImageUrlArrayToDownload objectAtIndex:z]]]];
        NSData *imageDataForActor = UIImagePNGRepresentation(imageForActor);
        [imageDataForActor writeToFile:savedImagePathForActor atomically:NO];
    }
    
    [startUpImageUrlArrayToDownload release];
}

-(void) downloadImagesOfFollowingStartUps
{
    NSMutableArray *startUpImageUrlArrayToDownload = [NSMutableArray new];
    [startUpImageUrlArrayToDownload addObjectsFromArray:startUpImageUrlArray];
    
    for (int z=0; z < [startUpImageUrlArrayToDownload count]; z++) 
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        
        NSString *savedImagePathForActor = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"following%d.jpg",(z+1)]];
        UIImage *imageForActor = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[startUpImageUrlArrayToDownload objectAtIndex:z]]]];
        NSData *imageDataForActor = UIImagePNGRepresentation(imageForActor);
        [imageDataForActor writeToFile:savedImagePathForActor atomically:NO];
    }
    
    [startUpImageUrlArrayToDownload release];
}

-(void) downloadImagesOfPortfolioStartUps
{
    NSMutableArray *startUpImageUrlArrayToDownload = [NSMutableArray new];
    [startUpImageUrlArrayToDownload addObjectsFromArray:startUpImageUrlArray];
    
    for (int z=0; z < [startUpImageUrlArrayToDownload count]; z++) 
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        
        NSString *savedImagePathForActor = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"portfolio%d.jpg",(z+1)]];
        UIImage *imageForActor = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[startUpImageUrlArrayToDownload objectAtIndex:z]]]];
        NSData *imageDataForActor = UIImagePNGRepresentation(imageForActor);
        [imageDataForActor writeToFile:savedImagePathForActor atomically:NO];
    }
    
    [startUpImageUrlArrayToDownload release];
}



-(void)refreshTrendingStartUps
{
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
        [startUpIdArray removeAllObjects];
        [startUpNameArray removeAllObjects];
        [startUpLinkArray removeAllObjects];
        [startUpImageUrlArray removeAllObjects];
        [startUpProdDescArray removeAllObjects];
        [startUpHighConceptArray removeAllObjects];
        [startUpFollowCountArray removeAllObjects];
        [startUpLocationsArray removeAllObjects];
        [startUpMarketsArray removeAllObjects];
        [startUpImageDisplayArray removeAllObjects];
        
        [_dbmanager deleteRowsFromTrending];
        [self getTrendingStartUps];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    NSIndexPath *selection = [table indexPathForSelectedRow];
    if (selection)
    {
        [table deselectRowAtIndexPath:selection animated:YES];
    }
    
    [super viewWillAppear:animated];
    
    startUpFilterTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(filterButtonSelected:)];
    [self.navigationController.navigationBar addGestureRecognizer:startUpFilterTap];
    [startUpFilterTap release];
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    UIImage *backgroundImage = [UIImage imageNamed:@"navigationbarfil.png"];
    [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    navigationBarLabelInStartUp.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    navigationBarLabelInStartUp.hidden = YES;
    [self.navigationController.navigationBar removeGestureRecognizer:startUpFilterTap];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


//Required
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.y <= -52) 
    {
        if(_filterTrending == TRUE)
        {
            isLoadingTopTrending = TRUE;
            [self startLoadingAtTop];
        }
    } 
}

//Required
-(void) startLoadingAtTop
{
    table.contentInset = UIEdgeInsetsMake(52, 0, 0, 0);
    if(isLoadingTopTrending)
    {
        imageViewTopTrending.hidden = YES;
        refreshSpinnerTopTrending.hidden = NO;
        [refreshSpinnerTopTrending startAnimating];
    }
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(stopLoadingAtTop) userInfo:nil repeats:NO];
}
//Required
-(void) stopLoadingAtTop
{
    isLoadingTopTrending = FALSE;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    imageViewTopTrending.transform = CGAffineTransformMakeRotation(3.142*2);
    [UIView commitAnimations];
    table.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    
    [self refreshTrendingStartUps];
    
    imageViewTopTrending.hidden = NO;
    refreshSpinnerTopTrending.hidden = YES;
    [refreshSpinnerTopTrending stopAnimating];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{  
    if(scrollView.contentOffset.y < -52)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        imageViewTopTrending.transform = CGAffineTransformMakeRotation(3.142*2);
        [UIView commitAnimations];
    }
    else
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        imageViewTopTrending.transform = CGAffineTransformMakeRotation(3.142);
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
