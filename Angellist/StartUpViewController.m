//
//  SecondViewController.m
//  SampleTabbar
//
//  Created by Ram Charan on 5/16/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "StartUpViewController.h"
#import "StartUpDetailsViewController.h"
#import "AsyncImageView.h"
#import "Reachability.h"

@implementation StartUpViewController

NSMutableArray *startUpIdsArray;
NSMutableArray *startUpNameArray;
NSMutableArray *startUpAngelUrlArray;
NSMutableArray *startUpLogoUrlArray;
NSMutableArray *startUpProductDescArray;
NSMutableArray *startUpHighConceptArray;
NSMutableArray *startUpFollowerCountArray;
NSMutableArray *startUpLocationArray;
NSMutableArray *startUpMarketArray;
NSMutableArray *startUpLogoImageInDirectory;

NSMutableArray *displayStartUpIdsArray;
NSMutableArray *displayStartUpNameArray;
NSMutableArray *displayStartUpAngelUrlArray;
NSMutableArray *displayStartUpLogoUrlArray;
NSMutableArray *displayStartUpProductDescArray;
NSMutableArray *displayStartUpHighConceptArray;
NSMutableArray *displayStartUpFollowerCountArray;
NSMutableArray *displayStartUpLocationArray;
NSMutableArray *displayStartUpMarketArray;
NSMutableArray *displayStartUpLogoImageInDirectory;

NSMutableArray *displayStartUpLogoImageDataArray;

extern NSMutableArray *userFollowingIds;

extern BOOL _transitFromStartUps;
extern BOOL _transitFromActivity;

extern NSString *_angelUserId;
extern NSString *_currUserId;

BOOL _filterFollow = FALSE;
BOOL _filterPortfolio = FALSE;
BOOL _showFilterMenuInStartUps = FALSE;

int _rowNumberInStartUps = 0;
NSArray *_filterStartUpNames;

UIButton *filterButton;

int countDown = 0;
float alphaValueInStartUp = 1.0;
UIView *notReachableView;
NSTimer *timer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"StartUps";
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
    filterButton.enabled = YES;
    
    
    //---create new cell if no reusable cell is available---
    if (cell == nil) 
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    else 
    {
        AsyncImageView* oldImage = (AsyncImageView*)
        [cell.contentView viewWithTag:999];
        [oldImage removeFromSuperview];
    }
    
    //---set the text to display for the cell---
    NSString *cellNameValue = [displayStartUpNameArray objectAtIndex:indexPath.row]; 
    NSString *cellHighConceptValue = [displayStartUpHighConceptArray objectAtIndex:indexPath.row]; 
    NSString *cellLocationValue = [displayStartUpLocationArray objectAtIndex:indexPath.row]; 

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) 
    {
        UILabel *cellNameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(85, 8, 210, 20)] autorelease];
        cellNameLabel.lineBreakMode = UILineBreakModeWordWrap;
        cellNameLabel.text = cellNameValue;
        cellNameLabel.backgroundColor = [UIColor clearColor];
        cellNameLabel.textColor = [UIColor colorWithRed:63.0/255.0 green:103.0/255.0 blue:160.0/255.0 alpha:1.0f];
        cellNameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:13];
        [cell.contentView addSubview:cellNameLabel];
        
        UILabel *cellHighConceptLabel = [[[UILabel alloc] initWithFrame:CGRectMake(85, 26, 210, 30)] autorelease];
        cellHighConceptLabel.lineBreakMode = UILineBreakModeWordWrap;
        cellHighConceptLabel.numberOfLines = 5;
        cellHighConceptLabel.text = cellHighConceptValue;
        cellHighConceptLabel.backgroundColor = [UIColor clearColor];
        cellHighConceptLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
        [cell.contentView addSubview:cellHighConceptLabel];
        
        UILabel *cellLocationLabel = [[[UILabel alloc] initWithFrame:CGRectMake(82, 61, 210, 30)] autorelease];
        cellLocationLabel.lineBreakMode = UILineBreakModeWordWrap;
        cellLocationLabel.text = cellLocationValue;
        cellLocationLabel.backgroundColor = [UIColor clearColor];
        cellLocationLabel.textColor = [UIColor colorWithRed:77.0/255.0 green:77.0/255.0 blue:76.0/255.0 alpha:1.0f];
        cellLocationLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10];
        [cell.contentView addSubview:cellLocationLabel];
        

            UIImage *image = [UIImage imageWithContentsOfFile:[displayStartUpLogoImageInDirectory objectAtIndex:indexPath.row]];
            UIImageView *cellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(7, 8, 50, 50)];
            cellImageView.image = image;
            [cell.contentView addSubview:cellImageView];
            [cellImageView release];

    }
    else
    {
        UILabel *cellNameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(((768*85)/320), ((1024*7)/480), ((768*240)/320), ((1024*30)/480))] autorelease];
        cellNameLabel.lineBreakMode = UILineBreakModeWordWrap;
        cellNameLabel.text = cellNameValue;
        cellNameLabel.backgroundColor = [UIColor clearColor];
        cellNameLabel.textColor = [UIColor colorWithRed:63.0/255.0 green:103.0/255.0 blue:160.0/255.0 alpha:1.0f];
        cellNameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:26];
        [cell.contentView addSubview:cellNameLabel];
        
        UILabel *cellHighConceptLabel = [[[UILabel alloc] initWithFrame:CGRectMake(((768*85)/320), ((1024*39)/480), ((768*240)/320), ((1024*30)/480))] autorelease];
        cellHighConceptLabel.lineBreakMode = UILineBreakModeWordWrap;
        cellHighConceptLabel.numberOfLines = 5;
        cellHighConceptLabel.text = cellHighConceptValue;
        cellHighConceptLabel.backgroundColor = [UIColor clearColor];
        cellHighConceptLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:26];
        [cell.contentView addSubview:cellHighConceptLabel];
        
        UILabel *cellLocationLabel = [[[UILabel alloc] initWithFrame:CGRectMake(((768*85)/320), ((1024*71)/480), ((768*240)/320), ((1024*30)/480))] autorelease];
        cellLocationLabel.lineBreakMode = UILineBreakModeWordWrap;
        cellLocationLabel.text = cellLocationValue;
        cellLocationLabel.backgroundColor = [UIColor clearColor];
        cellLocationLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
        [cell.contentView addSubview:cellLocationLabel];
        
        
        UIImage *image = [UIImage imageWithContentsOfFile:[displayStartUpLogoImageInDirectory objectAtIndex:indexPath.row]];
        UIImageView *cellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(((768*7)/320), ((1024*8)/480), ((768*70)/320), ((1024*70)/480))];
        cellImageView.image = image;
        [cell.contentView addSubview:cellImageView];
        [cellImageView release];
    }
    return cell; 
}

//---set the number of rows in the table view---
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{ 
    if(([displayStartUpNameArray count] == 0) && (_filterFollow == TRUE))
    {
        loadingView.hidden = YES;
//        filterButton.enabled = YES;
    }
    return [displayStartUpNameArray count];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _rowNumberInStartUps = indexPath.row;
   
    StartUpDetailsViewController *detailsViewController;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) 
    {
        detailsViewController = [[[StartUpDetailsViewController alloc] initWithNibName:@"StartUpDetailsViewController_iPhone" bundle:nil] autorelease];
    }
    else
    {
        detailsViewController = [[[StartUpDetailsViewController alloc] initWithNibName:@"StartUpDetailsViewController_iPad" bundle:nil] autorelease];
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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    notReachableView = [[UIView alloc] initWithFrame:CGRectMake(100, 140, 118, 118)];
    notReachableView.alpha = 0;
    [notReachableView.layer setCornerRadius:10.0f];
    notReachableView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:notReachableView];
    
    UILabel *msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, 53, 106, 46)];
    msgLabel.text = @"No Internet Connection";
    msgLabel.textAlignment = UITextAlignmentCenter;
    msgLabel.numberOfLines = 2;
    msgLabel.backgroundColor = [UIColor clearColor];
    msgLabel.textColor = [UIColor whiteColor];
    msgLabel.font = [UIFont fontWithName:@"System" size:10.0];
    [notReachableView addSubview:msgLabel];
    
    UIImage *notReachableImage = [UIImage imageNamed:@"closebutton.png"];
    UIImageView *notReachView = [[UIImageView alloc] initWithFrame:CGRectMake(41, 20, 37, 37)];
    notReachView.image = notReachableImage;
    [notReachableView addSubview:notReachView];
    
    [msgLabel release];
    [notReachView release];
    [notReachableView release];
    
    _dbmanager = [[DBManager alloc] init];
    [_dbmanager openDB];
    
    startUpIdsArray = [[NSMutableArray alloc] init];
    startUpNameArray = [[NSMutableArray alloc] init];
    startUpAngelUrlArray = [[NSMutableArray alloc] init];
    startUpLogoUrlArray = [[NSMutableArray alloc] init];
    startUpProductDescArray = [[NSMutableArray alloc] init];
    startUpHighConceptArray = [[NSMutableArray alloc] init];
    startUpFollowerCountArray = [[NSMutableArray alloc] init];
    startUpLocationArray = [[NSMutableArray alloc] init];
    startUpMarketArray = [[NSMutableArray alloc] init];
    
    displayStartUpIdsArray = [[NSMutableArray alloc] init];
    displayStartUpNameArray = [[NSMutableArray alloc] init];
    displayStartUpAngelUrlArray = [[NSMutableArray alloc] init];
    displayStartUpLogoUrlArray = [[NSMutableArray alloc] init];
    displayStartUpProductDescArray = [[NSMutableArray alloc] init];
    displayStartUpHighConceptArray = [[NSMutableArray alloc] init];
    displayStartUpFollowerCountArray = [[NSMutableArray alloc] init];
    displayStartUpLocationArray = [[NSMutableArray alloc] init];
    displayStartUpMarketArray = [[NSMutableArray alloc] init];
    
    startUpLogoImageInDirectory = [[NSMutableArray alloc] init];
    displayStartUpLogoImageInDirectory = [[NSMutableArray alloc] init];
    displayStartUpLogoImageDataArray = [[NSMutableArray alloc] init];
    
    _dbmanager.startUpIdsArrayFromDB = [[[NSMutableArray alloc] init] autorelease];
    _dbmanager.startUpNameArrayFromDB = [[[NSMutableArray alloc] init] autorelease];
    _dbmanager.startUpAngelUrlArrayFromDB = [[[NSMutableArray alloc] init] autorelease];
    _dbmanager.startUpLogoUrlArrayFromDB = [[[NSMutableArray alloc] init] autorelease];
    _dbmanager.startUpProductDescArrayFromDB = [[[NSMutableArray alloc] init] autorelease];
    _dbmanager.startUpHighConceptArrayFromDB = [[[NSMutableArray alloc] init] autorelease];
    _dbmanager.startUpFollowerCountArrayFromDB = [[[NSMutableArray alloc] init] autorelease];
    _dbmanager.startUpLocationArrayFromDB = [[[NSMutableArray alloc] init] autorelease];
    _dbmanager.startUpMarketArrayFromDB = [[[NSMutableArray alloc] init] autorelease];
    _dbmanager.startUpLogoImageInDirectoryFromDB = [[[NSMutableArray alloc] init] autorelease];
    
    _filterStartUpNames = [[NSArray arrayWithObjects:@"Following", @"Portfolio", @"Trending", @"All", nil] retain];
    
    //Add background image to navigation title bar
    UIImage *backgroundImage = [UIImage imageNamed:@"navigationbar.png"];
    [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    
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
    
    //Check for the availability of Internet
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
    {
        [_dbmanager retrieveStartUpsDetails];
        
        [startUpIdsArray addObjectsFromArray:_dbmanager.startUpIdsArrayFromDB];
        [displayStartUpIdsArray addObjectsFromArray:_dbmanager.startUpIdsArrayFromDB];
        
        [startUpNameArray addObjectsFromArray:_dbmanager.startUpNameArrayFromDB];
        [displayStartUpNameArray addObjectsFromArray:_dbmanager.startUpNameArrayFromDB];
        
        [startUpAngelUrlArray addObjectsFromArray:_dbmanager.startUpAngelUrlArrayFromDB];
        [displayStartUpAngelUrlArray addObjectsFromArray:_dbmanager.startUpAngelUrlArrayFromDB];
        
        [startUpLogoUrlArray addObjectsFromArray:_dbmanager.startUpLogoUrlArrayFromDB];
        [displayStartUpLogoUrlArray addObjectsFromArray:_dbmanager.startUpLogoUrlArrayFromDB];
        
        [startUpProductDescArray addObjectsFromArray:_dbmanager.startUpProductDescArrayFromDB];
        [displayStartUpProductDescArray addObjectsFromArray:_dbmanager.startUpProductDescArrayFromDB];
        
        [startUpHighConceptArray addObjectsFromArray:_dbmanager.startUpHighConceptArrayFromDB];
        [displayStartUpHighConceptArray addObjectsFromArray:_dbmanager.startUpHighConceptArrayFromDB];
        
        [startUpFollowerCountArray addObjectsFromArray:_dbmanager.startUpFollowerCountArrayFromDB];
        [displayStartUpFollowerCountArray addObjectsFromArray:_dbmanager.startUpFollowerCountArrayFromDB];
        
        [startUpLocationArray addObjectsFromArray:_dbmanager.startUpLocationArrayFromDB];
        [displayStartUpLocationArray addObjectsFromArray:_dbmanager.startUpLocationArrayFromDB];
        
        [startUpMarketArray addObjectsFromArray:_dbmanager.startUpMarketArrayFromDB];
        [displayStartUpMarketArray addObjectsFromArray:_dbmanager.startUpMarketArrayFromDB];
        
        [startUpLogoImageInDirectory addObjectsFromArray:_dbmanager.startUpLogoImageInDirectoryFromDB];
        [displayStartUpLogoImageInDirectory addObjectsFromArray:_dbmanager.startUpLogoImageInDirectoryFromDB];
    }
    else
    {
        filterButton.enabled = NO;
        
        NSURL *url = [NSURL URLWithString:@"https://api.angel.co/1/startups/batch?ids=6702,445,87,97,117,127,147,166,167,179,193,203,223,227,289,292,303,304,312,319,321,323"];
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
                 
                 NSArray *startUpIds = [json valueForKey:@"id"];
                 NSArray* startUpNames = [json valueForKey:@"name"]; //2
                 NSArray* startUpAngelUrl = [json valueForKey:@"angellist_url"]; //2
                 NSArray* startUpLogoUrl = [json valueForKey:@"thumb_url"]; //2
                 NSArray* startUpProductDesc = [json valueForKey:@"product_desc"]; //2
                 NSArray* startUpHighConcept = [json valueForKey:@"high_concept"]; //2
                 NSArray* startUpFollowerCount = [json valueForKey:@"follower_count"]; //2
                 
                 NSArray* startUpLocation = [[json valueForKey:@"locations"] valueForKey:@"display_name"]; //2
                 
                 NSArray* startUpMarket = [[json valueForKey:@"markets"] valueForKey:@"display_name"]; //2
                 
                 for(int i=0; i<[startUpNames count]; i++)
                 {
                     [startUpNameArray addObject:[startUpNames objectAtIndex:i]];
                     [displayStartUpNameArray addObject:[startUpNames objectAtIndex:i]];
                     
                     [startUpIdsArray addObject:[startUpIds objectAtIndex:i]];
                     [displayStartUpIdsArray addObject:[startUpIds objectAtIndex:i]];
                     
                     [startUpAngelUrlArray addObject:[startUpAngelUrl objectAtIndex:i]];
                     [displayStartUpAngelUrlArray addObject:[startUpAngelUrl objectAtIndex:i]];
                     
                     [startUpLogoUrlArray addObject:[startUpLogoUrl objectAtIndex:i]];
                     [displayStartUpLogoUrlArray addObject:[startUpLogoUrl objectAtIndex:i]];
                     
                     [startUpProductDescArray addObject:[startUpProductDesc objectAtIndex:i]];
                     [displayStartUpProductDescArray addObject:[startUpProductDesc objectAtIndex:i]];
                     
                     [startUpHighConceptArray addObject:[startUpHighConcept objectAtIndex:i]];
                     [displayStartUpHighConceptArray addObject:[startUpHighConcept objectAtIndex:i]];
                     
                     [startUpFollowerCountArray addObject:[startUpFollowerCount objectAtIndex:i]];
                     [displayStartUpFollowerCountArray addObject:[startUpFollowerCount objectAtIndex:i]];
                     
                     if([startUpLocation objectAtIndex:i] == (NSString*)[NSNull null])
                     {
                         [startUpLocationArray addObject:@"NA"];
                         [displayStartUpLocationArray addObject:@"NA"];
                     }
                     else
                     {
                         NSMutableString * theMutableString = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@",[startUpLocation objectAtIndex:i]]];
                         for(int j=0; j<[[startUpLocation objectAtIndex:i] count]; j++)
                         {
                             [theMutableString replaceOccurrencesOfString:@"\"" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
                             [theMutableString replaceOccurrencesOfString:@"(" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
                             [theMutableString replaceOccurrencesOfString:@")" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
                             [theMutableString replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
                         }
                         [startUpLocationArray addObject:theMutableString];
                         [displayStartUpLocationArray addObject:theMutableString];
                         [theMutableString release];
                     } 
                     
                     NSMutableString * theMutableString = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@",[startUpMarket objectAtIndex:i]]];
                     for(int j=0; j<[[startUpMarket objectAtIndex:i] count]; j++)
                     {
                         [theMutableString replaceOccurrencesOfString:@"\"" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
                         [theMutableString replaceOccurrencesOfString:@"(" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
                         [theMutableString replaceOccurrencesOfString:@")" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
                         [theMutableString replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
                         
                     }
                     [startUpMarketArray addObject:theMutableString];
                     [displayStartUpMarketArray addObject:theMutableString];
                     [theMutableString release];
                     
                 }
                 
                 for(int k=0; k<[startUpMarketArray count]; k++)
                 {
                     NSString *checkStr = [[NSString alloc] initWithFormat:@"%@",[startUpMarketArray objectAtIndex:k]];
                     if([checkStr rangeOfString:@"("].location != NSNotFound)
                     {
                         [startUpMarketArray replaceObjectAtIndex:k withObject:@"No data"];
                         [displayStartUpMarketArray replaceObjectAtIndex:k withObject:@"No data"];
                     }
                     [checkStr release];
                 }
                 for(int k=0; k<[startUpProductDescArray count]; k++)
                 {
                     NSMutableString * theMutableString = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@",[startUpProductDescArray objectAtIndex:k]]];
                     
                     [theMutableString replaceOccurrencesOfString:@"'" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
                     
                     [startUpProductDescArray replaceObjectAtIndex:k withObject:theMutableString];
                     [displayStartUpProductDescArray replaceObjectAtIndex:k withObject:theMutableString];
                     [theMutableString release];
                 }
                 [self saveImagesOfStartUps];
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



-(void) saveImagesOfStartUps
{
    for(int imageNumber=1; imageNumber<=[displayStartUpLogoUrlArray count]; imageNumber++)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"startup%d.png",imageNumber]];
        
        UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[displayStartUpLogoUrlArray objectAtIndex:(imageNumber-1)]]]]];
        NSData *imageData = UIImagePNGRepresentation(image);
        [imageData writeToFile:savedImagePath atomically:NO];
        
        [image release];
        
        [startUpLogoImageInDirectory addObject:savedImagePath];
        [displayStartUpLogoImageInDirectory addObject:savedImagePath];
    }
    [self saveStartUpsDetailsToDB];
}

-(void) saveStartUpsDetailsToDB
{
    for(int k=0; k<[startUpIdsArray count]; k++)
    {
        NSString *strtid = [NSString stringWithFormat:@"%d",(k+1)];
        NSString *startUpId= [NSString stringWithFormat:@"%@",[startUpIdsArray objectAtIndex:k]];
        NSString *startUpName= [NSString stringWithFormat:@"%@",[startUpNameArray objectAtIndex:k]];
        NSString *startUpAngelUrl= [NSString stringWithFormat:@"%@",[startUpAngelUrlArray objectAtIndex:k]];
        NSString *startUpLogoUrl= [NSString stringWithFormat:@"%@",[startUpLogoUrlArray objectAtIndex:k]];
        NSString *startUpProductDesc= [NSString stringWithFormat:@"%@",[startUpProductDescArray objectAtIndex:k]];
        NSString *startUpHighConcept= [NSString stringWithFormat:@"%@",[startUpHighConceptArray objectAtIndex:k]];
        NSString *startUpFollowerCount= [NSString stringWithFormat:@"%@",[startUpFollowerCountArray objectAtIndex:k]];
        NSString *startUpLocations= [NSString stringWithFormat:@"%@",[startUpLocationArray objectAtIndex:k]];
        NSString *startUpMarkets= [NSString stringWithFormat:@"%@",[startUpMarketArray objectAtIndex:k]];
        NSString *startUpLogoImage= [NSString stringWithFormat:@"%@",[startUpLogoImageInDirectory objectAtIndex:k]];
        
        [_dbmanager insertRecordIntoStartUpsTable:@"StartUps" field1Value:strtid field2Value:startUpId field3Value:startUpName field4Value:startUpAngelUrl field5Value:startUpLogoUrl field6Value:startUpProductDesc field7Value:startUpHighConcept field8Value:startUpFollowerCount field9Value:startUpLocations field10Value:startUpMarkets field11Value:startUpLogoImage];
    } 
}



- (void)filterButtonSelected:(id)sender 
{

    
    UIView *filtersList;
    
    if(_showFilterMenuInStartUps == FALSE)
    {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) 
        {
            UIView *filterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
            [filterView  setBackgroundColor: [UIColor blackColor]];
            [filterView setAlpha:0.6f];
            filterView.tag = 1000;
            [self.view addSubview:filterView];
            
            filtersList = [[UIView alloc] initWithFrame:CGRectMake(165, 0, 150, 120)];
            [filtersList  setBackgroundColor: [UIColor blackColor]];
            [filtersList.layer setCornerRadius:18.0f];
            [filtersList setAlpha:1.0f];
            filtersList.tag = 1001;
            [self.view addSubview:filtersList];
            
            UIImage* image = [UIImage imageNamed:@"navigationbar.png"];
            
            int _yPos = 5;
            
            for (int i=1; i<=4; i++) 
            {
                UIButton *filterButtons = [UIButton buttonWithType:UIButtonTypeCustom];
                [filterButtons setBackgroundImage:image forState:UIControlStateNormal];
                [filterButtons setTitle:[NSString stringWithFormat:@"%@",[_filterStartUpNames objectAtIndex:(i-1)]] forState:UIControlStateNormal];
                [filterButtons setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [filterButtons addTarget:self action:@selector(getFilteredList:) forControlEvents:UIControlStateHighlighted];
                filterButtons.frame = CGRectMake(14, _yPos, 120, 25);
                filterButtons.tag = i;
                [filtersList addSubview:filterButtons];
                
                if(i==3)
                {
                    filterButtons.enabled = NO;
                }
                
                _yPos = _yPos + 27;
            }
            
            [filtersList release];
            [filterView release];
            
            _showFilterMenuInStartUps = TRUE;
        }
        else
        {
            UIView *filterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
            [filterView  setBackgroundColor: [UIColor blackColor]];
            [filterView setAlpha:0.6f];
            filterView.tag = 1000;
            [self.view addSubview:filterView];
            
            filtersList = [[UIView alloc] initWithFrame:CGRectMake(((768*165)/320), 0, ((768*150)/320), ((1024*120)/480))];
            [filtersList  setBackgroundColor: [UIColor blackColor]];
            [filtersList.layer setCornerRadius:18.0f];
            [filtersList setAlpha:1.0f];
            filtersList.tag = 1001;
            [self.view addSubview:filtersList];
            
            UIImage* image = [UIImage imageNamed:@"navigationbar.png"];
            
            int _yPos = ((1024*5)/480);
            
            for (int i=1; i<=4; i++) 
            {
                UIButton *filterButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [filterButton setBackgroundImage:image forState:UIControlStateNormal];
                [filterButton setTitle:[NSString stringWithFormat:@"%@",[_filterStartUpNames objectAtIndex:(i-1)]] forState:UIControlStateNormal];
                [filterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [filterButton addTarget:self action:@selector(getFilteredList:) forControlEvents:UIControlStateHighlighted];
                filterButton.frame = CGRectMake(((768*14)/320), _yPos, ((768*120)/320), ((1024*25)/480));
                filterButton.tag = i;
                [filtersList addSubview:filterButton];
                
                if(i==2 || i==3)
                {
                    filterButton.enabled = NO;
                }
                
                _yPos = _yPos + ((1024*27)/480);
            }
            
            [filtersList release];
            [filterView release];
            
            _showFilterMenuInStartUps = TRUE;
        }    
    }
    else
    {
        [[self.view viewWithTag:1000] removeFromSuperview];
        [[self.view viewWithTag:1001] removeFromSuperview];
        _showFilterMenuInStartUps = FALSE;
    }
}

-(void)getFilteredList:(id)sender
{
    [displayStartUpIdsArray removeAllObjects];
    [displayStartUpNameArray removeAllObjects];
    [displayStartUpAngelUrlArray removeAllObjects];
    [displayStartUpLogoUrlArray removeAllObjects];
    [displayStartUpProductDescArray removeAllObjects];
    [displayStartUpHighConceptArray removeAllObjects];
    [displayStartUpFollowerCountArray removeAllObjects];
    [displayStartUpLocationArray removeAllObjects];
    [displayStartUpMarketArray removeAllObjects];
    [displayStartUpLogoImageDataArray removeAllObjects];
    [displayStartUpLogoImageInDirectory removeAllObjects];
    
    int _tagID = [sender tag];
    
    switch(_tagID)
    {
            //Implement Following
        case 1 : _filterFollow = TRUE;
                 _showFilterMenuInStartUps = FALSE;
                 [[self.view viewWithTag:1000] removeFromSuperview];
                 [[self.view viewWithTag:1001] removeFromSuperview];
                  
                 self.title = @"StartUps - Following";
                 self.navigationController.title = @"StartUps";
            
                 [self getDetailsOfFollowing];
//                 filterButton.enabled = NO;     
                 break;
            
            //Implement Portfolio    
        case 2 : 
            _filterPortfolio = TRUE;
            _showFilterMenuInStartUps = FALSE;
            [[self.view viewWithTag:1000] removeFromSuperview];
            [[self.view viewWithTag:1001] removeFromSuperview];
            
            self.title = @"StartUps - Portfolio";
            self.navigationController.title = @"StartUps";
            [self getDetailsOfPortfolio];
//            filterButton.enabled = NO;   
            
            break;
            
            //Implement Trending 
        case 3 :  
            
            _showFilterMenuInStartUps = FALSE;
            [[self.view viewWithTag:1000] removeFromSuperview];
            [[self.view viewWithTag:1001] removeFromSuperview]; 
            break;
            
            //Implement All    
        case 4 : _filterFollow = FALSE; 
                 _filterPortfolio = FALSE;
                 [self getDetailsOfAll];
                 [table reloadData];
            
                 self.title = @"StartUps";
                 self.navigationController.title = @"StartUps";
            
                 _showFilterMenuInStartUps = FALSE;
                 [[self.view viewWithTag:1000] removeFromSuperview];
                 [[self.view viewWithTag:1001] removeFromSuperview];
                 break;    
    }
}


-(void) getDetailsOfFollowing
{
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
    {
        [_dbmanager.startUpIdsArrayFromDB removeAllObjects];
        [_dbmanager.startUpNameArrayFromDB removeAllObjects];
        [_dbmanager.startUpAngelUrlArrayFromDB removeAllObjects];
        [_dbmanager.startUpLogoUrlArrayFromDB removeAllObjects];
        [_dbmanager.startUpProductDescArrayFromDB removeAllObjects];
        [_dbmanager.startUpHighConceptArrayFromDB removeAllObjects];
        [_dbmanager.startUpFollowerCountArrayFromDB removeAllObjects];
        [_dbmanager.startUpLocationArrayFromDB removeAllObjects];
        [_dbmanager.startUpMarketArrayFromDB removeAllObjects];
        [_dbmanager.startUpLogoImageInDirectoryFromDB removeAllObjects];
        
        [_dbmanager retrieveStartUpsFollowingDetails];
        

        [displayStartUpIdsArray addObjectsFromArray:_dbmanager.startUpIdsArrayFromDB];
        
        [displayStartUpNameArray addObjectsFromArray:_dbmanager.startUpNameArrayFromDB];
        

        [displayStartUpAngelUrlArray addObjectsFromArray:_dbmanager.startUpAngelUrlArrayFromDB];
        

        [displayStartUpLogoUrlArray addObjectsFromArray:_dbmanager.startUpLogoUrlArrayFromDB];
        

        [displayStartUpProductDescArray addObjectsFromArray:_dbmanager.startUpProductDescArrayFromDB];
        

        [displayStartUpHighConceptArray addObjectsFromArray:_dbmanager.startUpHighConceptArrayFromDB];
        

        [displayStartUpFollowerCountArray addObjectsFromArray:_dbmanager.startUpFollowerCountArrayFromDB];
        

        [displayStartUpLocationArray addObjectsFromArray:_dbmanager.startUpLocationArrayFromDB];
        

        [displayStartUpMarketArray addObjectsFromArray:_dbmanager.startUpMarketArrayFromDB];
        

        [displayStartUpLogoImageInDirectory addObjectsFromArray:_dbmanager.startUpLogoImageInDirectoryFromDB];
        
        [table reloadData];
    }
    else
    {
        loadingView.hidden = NO;
        filterButton.enabled = NO;
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.angel.co/1/users/%@/following?type=startup",_currUserId]];
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
                 
                 NSArray* startUpFollowing = [json objectForKey:@"startups"]; //2
                 
                 
                 
                 for(int k=0; k<[startUpFollowing count]; k++)
                 {
                     NSDictionary *following = [startUpFollowing objectAtIndex:k];
                     
                     NSString* startUpFollowIds = [following valueForKey:@"id"];
                     [displayStartUpIdsArray addObject:startUpFollowIds];
                     if(![userFollowingIds containsObject:startUpFollowIds])
                     {
                         [userFollowingIds addObject:startUpFollowIds];
                     }
                     
                     NSString* startUpFollowNames = [following valueForKey:@"name"];
                     [displayStartUpNameArray addObject:startUpFollowNames];
                     
                     NSString* startUpFollowAngelUrl = [following valueForKey:@"angellist_url"]; //2
                     [displayStartUpAngelUrlArray addObject:startUpFollowAngelUrl];
                     
                     NSString* startUpFollowLogoUrl = [following valueForKey:@"thumb_url"]; //2

                     [displayStartUpLogoUrlArray addObject:startUpFollowLogoUrl];
                      
                     NSString* startUpFollowProductDesc = [following valueForKey:@"product_desc"]; //2
                     [displayStartUpProductDescArray addObject:startUpFollowProductDesc];
                     
                     NSString* startUpFollowHighConcept = [following valueForKey:@"high_concept"]; //2
                     [displayStartUpHighConceptArray addObject:startUpFollowHighConcept];
                     
                     NSString* startUpFollowFollowerCount = [following valueForKey:@"follower_count"]; //2
                     [displayStartUpFollowerCountArray addObject:startUpFollowFollowerCount];
                     
                 }
                 
                 
                 for(int i=0; i<[displayStartUpIdsArray count]; i++)
                 {
                     NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.angel.co/1/startups/%@",[displayStartUpIdsArray objectAtIndex:i]]];
                     
                     NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
                     [request setHTTPMethod: @"GET"];
                     
                     
                     NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
                     
                     NSError* error;
                     NSDictionary* json = [NSJSONSerialization 
                                           JSONObjectWithData:response //1
                                           options:kNilOptions 
                                           error:&error];
                     
                     NSArray* startUpFollowingLocations = [[json valueForKey:@"locations"] valueForKey:@"display_name"]; //2
                     NSString* startUpFollowingMarkets = [[json valueForKey:@"markets"] valueForKey:@"display_name"]; //2
                     
                     for(int j=0; j<[startUpFollowingLocations count]; j++)
                     {
                         if([startUpFollowingLocations objectAtIndex:j] == (NSString*)[NSNull null])
                         {
                             [displayStartUpLocationArray addObject:@"NA"];
                         }
                         else
                         {
                             NSMutableString * theMutableString = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@",[startUpFollowingLocations objectAtIndex:j]]];
                             
                             [theMutableString replaceOccurrencesOfString:@"\"" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
                             [theMutableString replaceOccurrencesOfString:@"(" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
                             [theMutableString replaceOccurrencesOfString:@")" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
                             [theMutableString replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
                             
                             [displayStartUpLocationArray addObject:theMutableString];
                             [theMutableString release];
                         } 
                     }
                     
                     NSMutableString * theMutableString = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@",startUpFollowingMarkets]];
                     [theMutableString replaceOccurrencesOfString:@"\"" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
                     [theMutableString replaceOccurrencesOfString:@"(" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
                     [theMutableString replaceOccurrencesOfString:@")" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
                     [theMutableString replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
                     [displayStartUpMarketArray addObject:theMutableString];
                     [theMutableString release];
                 }
                 
                 for(int k=0; k<[displayStartUpMarketArray count]; k++)
                 {
                     NSString *checkStr = [[NSString alloc] initWithFormat:@"%@",[displayStartUpMarketArray objectAtIndex:k]];
                     if([checkStr rangeOfString:@"("].location != NSNotFound)
                     {
                         [displayStartUpMarketArray replaceObjectAtIndex:k withObject:@"No data"];
                     }
                     [checkStr release];
                 }
//                 [self startLoadingImagesConcurrently];
                 [self saveImagesOfStartUpsFollowing];
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
}

-(void) saveImagesOfStartUpsFollowing
{
    for(int imageNumber=1; imageNumber<=[displayStartUpLogoUrlArray count]; imageNumber++)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"startupfollowing%d.png",imageNumber]];
        
        UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[displayStartUpLogoUrlArray objectAtIndex:(imageNumber-1)]]]]];
        NSData *imageData = UIImagePNGRepresentation(image);
        [imageData writeToFile:savedImagePath atomically:NO];
        
        [image release];
        

        [displayStartUpLogoImageInDirectory addObject:savedImagePath];
    }
    [self saveStartUpsFollowingDetailsToDB];
}

-(void) saveStartUpsFollowingDetailsToDB
{
    for(int k=0; k<[displayStartUpIdsArray count]; k++)
    {
        NSString *strtid = [NSString stringWithFormat:@"%d",(k+1)];
        NSString *startUpId= [NSString stringWithFormat:@"%@",[displayStartUpIdsArray objectAtIndex:k]];
        NSString *startUpName= [NSString stringWithFormat:@"%@",[displayStartUpNameArray objectAtIndex:k]];
        NSString *startUpAngelUrl= [NSString stringWithFormat:@"%@",[displayStartUpAngelUrlArray objectAtIndex:k]];
        NSString *startUpLogoUrl= [NSString stringWithFormat:@"%@",[displayStartUpLogoUrlArray objectAtIndex:k]];
        NSString *startUpProductDesc= [NSString stringWithFormat:@"%@",[displayStartUpProductDescArray objectAtIndex:k]];
        NSString *startUpHighConcept= [NSString stringWithFormat:@"%@",[displayStartUpHighConceptArray objectAtIndex:k]];
        NSString *startUpFollowerCount= [NSString stringWithFormat:@"%@",[displayStartUpFollowerCountArray objectAtIndex:k]];
        NSString *startUpLocations= [NSString stringWithFormat:@"%@",[displayStartUpLocationArray objectAtIndex:k]];
        NSString *startUpMarkets= [NSString stringWithFormat:@"%@",[displayStartUpMarketArray objectAtIndex:k]];
        NSString *startUpLogoImage= [NSString stringWithFormat:@"%@",[displayStartUpLogoImageInDirectory objectAtIndex:k]];
        
        [_dbmanager insertRecordIntoStartUpsFollowingTable:@"Following" field1Value:strtid field2Value:startUpId field3Value:startUpName field4Value:startUpAngelUrl field5Value:startUpLogoUrl field6Value:startUpProductDesc field7Value:startUpHighConcept field8Value:startUpFollowerCount field9Value:startUpLocations field10Value:startUpMarkets field11Value:startUpLogoImage];
    }
}



-(void) getDetailsOfPortfolio
{
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
    {
        [_dbmanager.startUpIdsArrayFromDB removeAllObjects];
        [_dbmanager.startUpNameArrayFromDB removeAllObjects];
        [_dbmanager.startUpAngelUrlArrayFromDB removeAllObjects];
        [_dbmanager.startUpLogoUrlArrayFromDB removeAllObjects];
        [_dbmanager.startUpProductDescArrayFromDB removeAllObjects];
        [_dbmanager.startUpHighConceptArrayFromDB removeAllObjects];
        [_dbmanager.startUpFollowerCountArrayFromDB removeAllObjects];
        [_dbmanager.startUpLocationArrayFromDB removeAllObjects];
        [_dbmanager.startUpMarketArrayFromDB removeAllObjects];
        [_dbmanager.startUpLogoImageInDirectoryFromDB removeAllObjects];
        
        [_dbmanager retrieveStartUpsPortfolioDetails];
        

        [displayStartUpIdsArray addObjectsFromArray:_dbmanager.startUpIdsArrayFromDB];
        

        [displayStartUpNameArray addObjectsFromArray:_dbmanager.startUpNameArrayFromDB];
        

        [displayStartUpAngelUrlArray addObjectsFromArray:_dbmanager.startUpAngelUrlArrayFromDB];
        

        [displayStartUpLogoUrlArray addObjectsFromArray:_dbmanager.startUpLogoUrlArrayFromDB];

        [displayStartUpProductDescArray addObjectsFromArray:_dbmanager.startUpProductDescArrayFromDB];
        

        [displayStartUpHighConceptArray addObjectsFromArray:_dbmanager.startUpHighConceptArrayFromDB];
        

        [displayStartUpFollowerCountArray addObjectsFromArray:_dbmanager.startUpFollowerCountArrayFromDB];
        

        [displayStartUpLocationArray addObjectsFromArray:_dbmanager.startUpLocationArrayFromDB];
        

        [displayStartUpMarketArray addObjectsFromArray:_dbmanager.startUpMarketArrayFromDB];
        

        [displayStartUpLogoImageInDirectory addObjectsFromArray:_dbmanager.startUpLogoImageInDirectoryFromDB];
        
        [table reloadData];
    }
    else
    {
        loadingView.hidden = NO;
        filterButton.enabled = NO;
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.angel.co/1/startup_roles?user_id=%@",_currUserId]];//
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
                 
                 NSArray* startUpPortfolio = [[json objectForKey:@"startup_roles"] valueForKey:@"startup"]; //2
                 
                 for(int k=0; k<[startUpPortfolio count]; k++)
                 {
                     NSDictionary *portfolio = [startUpPortfolio objectAtIndex:k];
                     
                     NSString *startUpPortfolioId = [portfolio valueForKey:@"id"];
                     [displayStartUpIdsArray addObject:startUpPortfolioId];
                     
                     NSString *startUpPortfolioName = [portfolio valueForKey:@"name"];
                     [displayStartUpNameArray addObject:startUpPortfolioName];
                     
                     NSString *startUpPortfolioAngelUrl = [portfolio valueForKey:@"angellist_url"];
                     [displayStartUpAngelUrlArray addObject:startUpPortfolioAngelUrl];
                     
                     NSString *startUpPortfolioLogoUrl = [portfolio valueForKey:@"thumb_url"];
//                     [displayStartUpLogoImageDataArray addObject:startUpPortfolioLogoUrl];
//                     [displayStartUpLogoUrlArray addObject:[UIImage imageNamed:@"placeholder.png"]];
                     [displayStartUpLogoUrlArray addObject:startUpPortfolioLogoUrl];
                     
                     NSString *startUpProdDesc = [portfolio valueForKey:@"product_desc"];
                     [displayStartUpProductDescArray addObject:startUpProdDesc];
                     
                     NSString *startUpPortfolioHighConcept = [portfolio valueForKey:@"high_concept"];
                     [displayStartUpHighConceptArray addObject:startUpPortfolioHighConcept];
                     
                     NSString *startUpPortfolioFollowerCount = [portfolio valueForKey:@"follower_count"];
                     [displayStartUpFollowerCountArray addObject:startUpPortfolioFollowerCount];
                     
                     [displayStartUpLocationArray addObject:@""];
                     [displayStartUpMarketArray addObject:@""];
                     
                 }
//                 [self startLoadingImagesConcurrently];
                 [self saveImagesOfStartUpsPortfolio];
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
}

-(void) saveImagesOfStartUpsPortfolio
{
    for(int imageNumber=1; imageNumber<=[displayStartUpLogoUrlArray count]; imageNumber++)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"startupportfolio%d.png",imageNumber]];
        
        UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[displayStartUpLogoUrlArray objectAtIndex:(imageNumber-1)]]]]];
        NSData *imageData = UIImagePNGRepresentation(image);
        [imageData writeToFile:savedImagePath atomically:NO];
        
        [image release];
        
        [startUpLogoImageInDirectory addObject:savedImagePath];
        [displayStartUpLogoImageInDirectory addObject:savedImagePath];
    }
    [self saveStartUpsPortfolioDetailsToDB];
}

-(void) saveStartUpsPortfolioDetailsToDB
{
    for(int k=0; k<[displayStartUpIdsArray count]; k++)
    {
        NSString *strtid = [NSString stringWithFormat:@"%d",(k+1)];
        NSString *startUpId= [NSString stringWithFormat:@"%@",[displayStartUpIdsArray objectAtIndex:k]];
        NSString *startUpName= [NSString stringWithFormat:@"%@",[displayStartUpNameArray objectAtIndex:k]];
        NSString *startUpAngelUrl= [NSString stringWithFormat:@"%@",[displayStartUpAngelUrlArray objectAtIndex:k]];
        NSString *startUpLogoUrl= [NSString stringWithFormat:@"%@",[displayStartUpLogoUrlArray objectAtIndex:k]];
        NSString *startUpProductDesc= [NSString stringWithFormat:@"%@",[displayStartUpProductDescArray objectAtIndex:k]];
        NSString *startUpHighConcept= [NSString stringWithFormat:@"%@",[displayStartUpHighConceptArray objectAtIndex:k]];
        NSString *startUpFollowerCount= [NSString stringWithFormat:@"%@",[displayStartUpFollowerCountArray objectAtIndex:k]];
        NSString *startUpLocations= [NSString stringWithFormat:@"%@",[displayStartUpLocationArray objectAtIndex:k]];
        NSString *startUpMarkets= [NSString stringWithFormat:@"%@",[displayStartUpMarketArray objectAtIndex:k]];
        NSString *startUpLogoImage= [NSString stringWithFormat:@"%@",[displayStartUpLogoImageInDirectory objectAtIndex:k]];
        
        [_dbmanager insertRecordIntoStartUpsPortfolioTable:@"Portfolio" field1Value:strtid field2Value:startUpId field3Value:startUpName field4Value:startUpAngelUrl field5Value:startUpLogoUrl field6Value:startUpProductDesc field7Value:startUpHighConcept field8Value:startUpFollowerCount field9Value:startUpLocations field10Value:startUpMarkets field11Value:startUpLogoImage];
    }
}

-(void) getDetailsOfAll
{
    [displayStartUpIdsArray addObjectsFromArray:startUpIdsArray];
    [displayStartUpNameArray addObjectsFromArray:startUpNameArray];
    [displayStartUpAngelUrlArray addObjectsFromArray:startUpAngelUrlArray];
    [displayStartUpLogoUrlArray addObjectsFromArray:startUpLogoUrlArray];
    [displayStartUpProductDescArray addObjectsFromArray:startUpProductDescArray];
    [displayStartUpHighConceptArray addObjectsFromArray:startUpHighConceptArray];
    [displayStartUpFollowerCountArray addObjectsFromArray:startUpFollowerCountArray];
    [displayStartUpLocationArray addObjectsFromArray:startUpLocationArray];
    [displayStartUpMarketArray addObjectsFromArray:startUpMarketArray];
    [displayStartUpLogoImageInDirectory addObjectsFromArray:startUpLogoImageInDirectory];
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void) dealloc
{
    [startUpIdsArray release];
    [startUpNameArray release];
    [startUpAngelUrlArray release];
    [startUpLogoUrlArray release];
    [startUpProductDescArray release];
    [startUpHighConceptArray release];
    [startUpFollowerCountArray release];
    [startUpLocationArray release];
    [startUpMarketArray release];
    
    [displayStartUpIdsArray release];
    [displayStartUpNameArray release];
    [displayStartUpAngelUrlArray release];
    [displayStartUpLogoUrlArray release];
    [displayStartUpProductDescArray release];
    [displayStartUpHighConceptArray release];
    [displayStartUpFollowerCountArray release];
    [displayStartUpLocationArray release];
    [displayStartUpMarketArray release];
    
    [startUpLogoImageInDirectory release];
    [displayStartUpLogoImageInDirectory release];
    [displayStartUpLogoImageDataArray release];
    
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
