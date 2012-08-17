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
#import "Reachability.h"

@implementation StartUpViewController
@synthesize filterView;

NSMutableArray *startUpIdsArray;//Complete Ids of StartUps
NSMutableArray *startUpNameArray;//Complete names of StartUps
NSMutableArray *startUpAngelUrlArray;//Complete angellist url's of StartUps
NSMutableArray *startUpLogoUrlArray;//Complete logo url's of StartUps
NSMutableArray *startUpProductDescArray;//Complete product description of StartUps
NSMutableArray *startUpHighConceptArray;//Complete high concept of StartUps
NSMutableArray *startUpFollowerCountArray;//Complete follower count of StartUps
NSMutableArray *startUpLocationArray;//Complete locations of StartUps
NSMutableArray *startUpMarketArray;//Complete market of StartUps
NSMutableArray *startUpLogoImageInDirectory;//Complete logo image paths of StartUps

NSMutableArray *displayStartUpIdsArray;//Ids of StartUps to be displayed
NSMutableArray *displayStartUpNameArray;//Names of StartUps to be displayed
NSMutableArray *displayStartUpAngelUrlArray;//Angellist url's of StartUps to be displayed
NSMutableArray *displayStartUpLogoUrlArray;//Logo url's of StartUps to be displayed
NSMutableArray *displayStartUpProductDescArray;//Complete product description of StartUps to be displayed
NSMutableArray *displayStartUpHighConceptArray;//High concept of StartUps to be displayed
NSMutableArray *displayStartUpFollowerCountArray;//Follower count of StartUps to be displayed
NSMutableArray *displayStartUpLocationArray;//Locations of StartUps to be displayed
NSMutableArray *displayStartUpMarketArray;//Market of StartUps to be displayed
NSMutableArray *displayStartUpLogoImageInDirectory;//Logo image paths of StartUps to be displayed

NSMutableArray *saveImageInDirectory;
extern BOOL _startupLoad;
extern NSMutableArray *userFollowingIds;//Array of user following Ids

extern NSString *_currUserId;//Angellist user Id used to send requests

BOOL _filterFollow = FALSE;//Flag to be set when request to following is sent
BOOL _filterPortfolio = FALSE;//Flag to be set when request to portfolio is sent
BOOL _filterTrending = FALSE;//Flag to be set when request to trending is sent
BOOL _showFilterMenuInStartUps = FALSE;//Flag to be set when filter displays on screen
BOOL _requestLoadComplete = FALSE;
int _rowNumberInStartUps = 0;
NSArray *_filterStartUpNames;

BOOL labelNoStartUpsActive = FALSE;

UIButton *filterContainer;

int countDown = 0;
float alphaValueInStartUp = 1.0;
UIView *notReachableView;
NSTimer *timer;

int _addFilter=0;
int _yPosSp = 5;
int _xPosSp = 245;
int _btnRotSp = 5;

int startUpsLoadCount = 10; 

BOOL _allImagesDownloadDone = FALSE;

UINavigationBar *bars;

//////////////////////////
UIView *refreshViewTopTrending;
UIImageView *imageViewTopTrending;
UIImageView *imageViewLogoTopTrending;
UILabel *refreshLabelTopTrending;
BOOL isLoadingTopTrending = FALSE;
UIActivityIndicatorView *refreshSpinnerTopTrending;
//////////////////////////

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //self.title = @"Startups";
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
    filterContainer.enabled = YES;
    
    //---create new cell if no reusable cell is available---
    if (cell == nil) 
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

    //---set the text to display for the cell---
    // Set the name of startUp
    NSString *cellNameValue = [displayStartUpNameArray objectAtIndex:indexPath.row]; 
    // Set the name of startUp
    NSString *cellFollowsValue = [NSString stringWithFormat:@"%@ follows",[displayStartUpFollowerCountArray objectAtIndex:indexPath.row]]; 
    NSLog(@"\n \n \n followers count = %@ \n \n ", cellFollowsValue);
    // Set the high concept of startUp
    NSString *cellHighConceptValue = [displayStartUpHighConceptArray objectAtIndex:indexPath.row]; 
    // Set the locations of startUp
    NSString *cellLocationValue = [displayStartUpLocationArray objectAtIndex:indexPath.row]; 
    // Set the market of startUp
    NSString *cellMarketValue = [displayStartUpMarketArray objectAtIndex:indexPath.row]; 

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) 
    {
        
        Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
        
        NetworkStatus internetStatus = [r currentReachabilityStatus];
        if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
        {
            
            UILabel *cellNameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(70, 8, 210, 20)] autorelease];
            cellNameLabel.lineBreakMode = UILineBreakModeWordWrap;
            cellNameLabel.text = cellNameValue;
            cellNameLabel.backgroundColor = [UIColor clearColor];
            cellNameLabel.textColor = [UIColor colorWithRed:63.0/255.0 green:103.0/255.0 blue:160.0/255.0 alpha:1.0f];
            cellNameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
            [cell.contentView addSubview:cellNameLabel];
            
            UILabel *cellFollowsLabel = [[[UILabel alloc] initWithFrame:CGRectMake(235, 25, 50, 10)] autorelease];
            cellFollowsLabel.text = cellFollowsValue;
            cellFollowsLabel.backgroundColor = [UIColor clearColor];
            cellFollowsLabel.textColor = [UIColor colorWithRed:77.0/255.0 green:77.0/255.0 blue:76.0/255.0 alpha:1.0f];
            cellFollowsLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10];
            [cell.contentView addSubview:cellFollowsLabel];
            
            
            NSString *text1 = cellHighConceptValue;
            CGSize constraint1 = CGSizeMake(270, 20000.0f);
            CGSize size1 = [text1 sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:14] constrainedToSize:constraint1 lineBreakMode:UILineBreakModeWordWrap];
            
            UILabel *cellHighConceptLabel = [[[UILabel alloc] initWithFrame:CGRectMake(70, 35, 210, size1.height)] autorelease];//26
            cellHighConceptLabel.lineBreakMode = UILineBreakModeWordWrap;
            cellHighConceptLabel.numberOfLines = 5;
            cellHighConceptLabel.text = cellHighConceptValue;
            cellHighConceptLabel.backgroundColor = [UIColor clearColor];
            cellHighConceptLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
            [cell.contentView addSubview:cellHighConceptLabel];
            
            UILabel *cellLocationLabel = [[[UILabel alloc] initWithFrame:CGRectMake(68, cellHighConceptLabel.frame.size.height + 35, 210, 30)] autorelease];//61
            cellLocationLabel.lineBreakMode = UILineBreakModeWordWrap;
            cellLocationLabel.text = cellLocationValue;
            cellLocationLabel.backgroundColor = [UIColor clearColor];
            cellLocationLabel.textColor = [UIColor colorWithRed:77.0/255.0 green:77.0/255.0 blue:76.0/255.0 alpha:1.0f];
            cellLocationLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10];
            [cell.contentView addSubview:cellLocationLabel];
            
            UILabel *cellMarketLabel = [[[UILabel alloc] initWithFrame:CGRectMake(66, cellHighConceptLabel.frame.size.height + 50, 210, 30)] autorelease];//61
            
            cellMarketLabel.text = cellMarketValue;
            cellMarketLabel.backgroundColor = [UIColor clearColor];
            cellMarketLabel.textColor = [UIColor colorWithRed:77.0/255.0 green:77.0/255.0 blue:76.0/255.0 alpha:1.0f];
            cellMarketLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10];
            [cell.contentView addSubview:cellMarketLabel];
            
        
                UIImage *image = [UIImage imageWithContentsOfFile:[displayStartUpLogoImageInDirectory objectAtIndex:indexPath.row]];
    
            UIImageView *cellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(7, 12, 50, 50)];
            cellImageView.image = image;
            cellImageView.layer.cornerRadius = 3.5f;
            cellImageView.layer.masksToBounds = YES;
            [cell.contentView addSubview:cellImageView];
            [cellImageView release];

            
            
        }
        else {
        UILabel *cellNameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(70, 8, 210, 20)] autorelease];
        cellNameLabel.lineBreakMode = UILineBreakModeWordWrap;
        cellNameLabel.text = cellNameValue;
        cellNameLabel.backgroundColor = [UIColor clearColor];
        cellNameLabel.textColor = [UIColor colorWithRed:63.0/255.0 green:103.0/255.0 blue:160.0/255.0 alpha:1.0f];
        cellNameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
        [cell.contentView addSubview:cellNameLabel];
        
        UILabel *cellFollowsLabel = [[[UILabel alloc] initWithFrame:CGRectMake(235, 25, 50, 10)] autorelease];
        cellFollowsLabel.text = cellFollowsValue;
        cellFollowsLabel.backgroundColor = [UIColor clearColor];
        cellFollowsLabel.textColor = [UIColor colorWithRed:77.0/255.0 green:77.0/255.0 blue:76.0/255.0 alpha:1.0f];
        cellFollowsLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10];
        [cell.contentView addSubview:cellFollowsLabel];
        
        
        NSString *text1 = cellHighConceptValue;
        CGSize constraint1 = CGSizeMake(270, 20000.0f);
        CGSize size1 = [text1 sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:14] constrainedToSize:constraint1 lineBreakMode:UILineBreakModeWordWrap];
        
        UILabel *cellHighConceptLabel = [[[UILabel alloc] initWithFrame:CGRectMake(70, 35, 210, size1.height)] autorelease];//26
        cellHighConceptLabel.lineBreakMode = UILineBreakModeWordWrap;
        cellHighConceptLabel.numberOfLines = 5;
        cellHighConceptLabel.text = cellHighConceptValue;
        cellHighConceptLabel.backgroundColor = [UIColor clearColor];
        cellHighConceptLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
        [cell.contentView addSubview:cellHighConceptLabel];
        
        UILabel *cellLocationLabel = [[[UILabel alloc] initWithFrame:CGRectMake(68, cellHighConceptLabel.frame.size.height + 35, 210, 30)] autorelease];//61
        cellLocationLabel.lineBreakMode = UILineBreakModeWordWrap;
        cellLocationLabel.text = cellLocationValue;
        cellLocationLabel.backgroundColor = [UIColor clearColor];
        cellLocationLabel.textColor = [UIColor colorWithRed:77.0/255.0 green:77.0/255.0 blue:76.0/255.0 alpha:1.0f];
        cellLocationLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10];
        [cell.contentView addSubview:cellLocationLabel];
        
        UILabel *cellMarketLabel = [[[UILabel alloc] initWithFrame:CGRectMake(66, cellHighConceptLabel.frame.size.height + 50, 210, 30)] autorelease];//61
       
        cellMarketLabel.text = cellMarketValue;
        cellMarketLabel.backgroundColor = [UIColor clearColor];
        cellMarketLabel.textColor = [UIColor colorWithRed:77.0/255.0 green:77.0/255.0 blue:76.0/255.0 alpha:1.0f];
        cellMarketLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10];
        [cell.contentView addSubview:cellMarketLabel];
        
       
        UIImage *image;
        if (_allImagesDownloadDone == FALSE) {
            image = [displayStartUpLogoImageInDirectory objectAtIndex:indexPath.row];
        }
        else {
            image = [UIImage imageWithContentsOfFile:[saveImageInDirectory objectAtIndex:indexPath.row]];
        }
        
        UIImageView *cellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(7, 12, 50, 50)];
        cellImageView.image = image;
        cellImageView.layer.cornerRadius = 3.5f;
        cellImageView.layer.masksToBounds = YES;
        [cell.contentView addSubview:cellImageView];
        [cellImageView release];
        }

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

//Returns dynamic cell height to be displayed
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *text = [displayStartUpHighConceptArray objectAtIndex:indexPath.row];
    CGSize constraint = CGSizeMake(270, 20000.0f);
    CGSize size = [text sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:14] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    return size.height + 85;
}

//---set the number of rows in the table view---
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{ 
    if(([displayStartUpNameArray count] == 0)  && _requestLoadComplete == TRUE && ((_filterFollow == TRUE) || (_filterPortfolio == TRUE) || (_filterTrending == TRUE) ))
    {
        labelNoStartUpsActive = TRUE;
        
        UILabel *alertPopup = [[UILabel alloc] initWithFrame:CGRectMake(20, 155, 280, 30)];
        alertPopup.text = @"No StartUps to display!";
        alertPopup.backgroundColor = [UIColor clearColor];
        alertPopup.textColor = [UIColor grayColor];
        alertPopup.textAlignment = UITextAlignmentCenter;
        alertPopup.tag = 404;
        [[self.view viewWithTag:404] removeFromSuperview];
        [self.view addSubview:alertPopup];
        [alertPopup release];
        loadingView.hidden = YES;
        filterContainer.enabled = YES;
    }
    if([displayStartUpNameArray count] != 0 && ((_filterFollow == TRUE) || (_filterPortfolio == TRUE) || (_filterTrending == TRUE) ))
    {
        labelNoStartUpsActive = FALSE;
        loadingView.hidden = YES;
        [[self.view viewWithTag:404] removeFromSuperview];
    }
    
    //Returns more number of startUps when more button is clicked
    if((_filterFollow == FALSE) && (_filterPortfolio == FALSE) && (_filterTrending == FALSE))
    {
        
        moreButton.hidden = FALSE;
        loadingView.hidden = NO;
        if(startUpsLoadCount == 10)
        {
            if([displayStartUpNameArray count] == 0)
            {
                return [displayStartUpNameArray count];
            }
            else
            {
                int _toLoad = 0;
                _toLoad = [displayStartUpNameArray count] - 20;
                return [displayStartUpNameArray count] - _toLoad;
            }
        }
        else
        {
            return startUpsLoadCount + 10;
        }
    }
    else
    {
        if (labelNoStartUpsActive == FALSE) {
            loadingView.hidden = NO;
           
        }
        
        moreButton.hidden = TRUE;
       //loadingView.hidden = NO;
         NSLog(@"\n \n loading view hidden in else \n \n ");
        return [displayStartUpNameArray count];
    }
}






//This method is called when a row in table is selected
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _rowNumberInStartUps = indexPath.row;
    labels.hidden = YES;
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
    
    UITapGestureRecognizer *taps = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(filterButtonSelectedStartUp:)];
    [bars addGestureRecognizer:taps];
    [taps release];
    
    [self performSelector:@selector(hideLabels) withObject:nil afterDelay:0.2];
}

-(void)hideLabels
{
    UIImage *backgroundImage = [UIImage imageNamed:@"navigationbarfil.png"];
    [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    labels.hidden = NO;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

//Method to load more startUps
-(IBAction)moreButtonAction:(id)sender
{
    if(startUpsLoadCount >= ([displayStartUpNameArray count] - 10))
    {
        [moreButton setTitle:@"No more StartUps" forState:UIControlStateNormal];
    }
    else
    {
        startUpsLoadCount = startUpsLoadCount + 10;
        [moreButton setTitle:@"Loading..." forState:UIControlStateNormal];
        [moreButton setUserInteractionEnabled:NO];
        [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(timeComplete) userInfo:nil repeats:NO];
    }
    
}

-(void) timeComplete
{
    [moreButton setTitle:@"More" forState:UIControlStateNormal];
    [moreButton setUserInteractionEnabled:YES];
    [table reloadData];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    filterView = [[UIView alloc] initWithFrame:CGRectMake(0, -480, 320, 480)];
    [filterView  setBackgroundColor: [UIColor blackColor]];
    [filterView setAlpha:0.4f];
    filterView.tag = 1000;
    [self.view addSubview:filterView];
    
    
    _filterStartUpNames = [[NSArray arrayWithObjects:@"Trending", @"Following", @"Portfolio", nil] retain];
    
    _view2 = [[UIView alloc] initWithFrame:CGRectMake(0, -250, 271, 51*3)];
    [self.view addSubview:_view2];
    
    //Add background image to navigation title bar
    UIImage *backgroundImage = [UIImage imageNamed:@"navigationbarfil.png"];
    [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    bars = [self.navigationController navigationBar];
    labels = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 260, 20)];
    labels.textAlignment = UITextAlignmentCenter;
    labels.textColor = [UIColor whiteColor];
    labels.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
    labels.backgroundColor = [UIColor clearColor];
    labels.text = @"Startups - Trending";
    [bars addSubview:labels];
    
//    UITapGestureRecognizer *taps = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(filterButtonSelectedStartUp:)];
//    [bars addGestureRecognizer:taps];
//    [taps release];
     
    buttonSearch = [[[UIButton alloc] init] autorelease];
    buttonSearch.frame = CGRectMake(0, 0, 49, 42);
    [buttonSearch setImage:[UIImage imageNamed:@"search.png"] forState:UIControlStateNormal];
    [buttonSearch setImage:[UIImage imageNamed:@"searcha.png"] forState:UIControlStateSelected];
    [buttonSearch addTarget:self action:@selector(goToSearch) forControlEvents:UIControlStateHighlighted];
    buttonSearch.enabled = YES;
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:buttonSearch]autorelease];
    

    _dbmanager = [[DBManager alloc] init];
    [_dbmanager openDB];
    
    //Create objects of all arrays
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
    saveImageInDirectory = [[NSMutableArray alloc] init];
    startUpLogoImageInDirectory = [[NSMutableArray alloc] init];
    displayStartUpLogoImageInDirectory = [[NSMutableArray alloc] init];
    
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
    
    _dbmanager.userDetailsArray = [[[NSMutableArray alloc] init] autorelease];

    [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(getDetailsOfTrending) userInfo:nil repeats:NO];
    _filterTrending = TRUE;
    
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
    
    refreshSpinnerTopTrending = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(50, 15, 20, 20)];
    refreshSpinnerTopTrending.hidden = YES;
    [refreshViewTopTrending addSubview:refreshSpinnerTopTrending];
    [refreshSpinnerTopTrending release];
    
    [table addSubview:refreshViewTopTrending];
    [refreshViewTopTrending release];
    
    [super viewDidLoad];
    

}


-(void)goToSearch
{
    labels.hidden = YES;
    _searchViewController = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
    [_searchViewController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self.navigationController pushViewController:_searchViewController animated:YES];
    
}


// Functions to display images concurrently 
-(void)startLoadingImagesConcurrently
{
    loadingView.hidden = YES;
    tShopQueueStartups = [NSOperationQueue new];
    NSInvocationOperation *tPerformOperation = [[NSInvocationOperation alloc] 
                                                initWithTarget:self
                                                selector:@selector(loadImage) 
                                                object:nil];
    [tShopQueueStartups addOperation:tPerformOperation]; 
    [tPerformOperation release];
    //[tShopQueueStartups release];
    
}

- (void)loadImage 
{
    for (int asyncCount = 0; asyncCount < [displayStartUpLogoUrlArray count] ; asyncCount++) {
        
        NSString *picLoad = [NSString stringWithFormat:@"%@",[displayStartUpLogoUrlArray objectAtIndex:asyncCount]];
        NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:picLoad]];
        UIImage* image = [UIImage imageWithData:imageData];
        if (image != nil) {
            
            [displayStartUpLogoImageInDirectory replaceObjectAtIndex:asyncCount withObject:image];
            [self performSelectorOnMainThread:@selector(displayImage:) withObject:[NSNumber numberWithInt:asyncCount] waitUntilDone:NO]; 
        }
        [imageData release];
        
    }
    if (_filterFollow == TRUE) 
    {
        [self saveImagesOfStartUpsFollowing];
    }
    else if(_filterPortfolio == TRUE)
    {
        [self saveImagesOfStartUpsPortfolio];
    }
    else if(_filterTrending == TRUE)
    {
        [self saveImagesOfStartUpsTrending];
    }
    else {
        [self saveImagesOfStartUps];
    }
     
}

-(void)displayImage:(NSNumber*)presentCount
{
    if([[table indexPathsForVisibleRows]count] > 0)
    {
        NSIndexPath *firstRowShown = [[table indexPathsForVisibleRows] objectAtIndex:0];
        NSIndexPath *lastRowShown = [[table indexPathsForVisibleRows] objectAtIndex:[[table indexPathsForVisibleRows]count]-1];
        NSInteger count = [presentCount integerValue];
        if((count > firstRowShown.row) && (count < lastRowShown.row))
            [table reloadData];
    }
    else
    {
        [table reloadData]; 
    }
    
}


// to load the request
-(void)sendRequestForLoad
{
    _requestLoadComplete = FALSE;
          
    //Check for the availability of Internet
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
    {
        //If offline retrieve startUp details from local database
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
        //loadingView.hidden = NO;
        filterContainer.enabled = NO;
        
        //Send URL request to get list of startUps
        NSURL *url = [NSURL URLWithString:@"https://api.angel.co/1/startups/batch?ids=445,87,97,117,127,147,166,167,179,193,203,223,227,289,292,303,304,312,319,321,323,96447,95646,95473,94779,93606,93179,93089,92151,90626,90609,90306,89402,87788,87484,84913,84880,84711,83262,82265,80743,80742,77600,76074,75777,75769,72754,70465,67887,67482"];
        
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod: @"GET"];
        
        NSError *error;                                 
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
                 
                 //Process json data obtained from response
                 NSDictionary* json = [NSJSONSerialization 
                                       JSONObjectWithData:data //1
                                       options:kNilOptions 
                                       error:&error];
                 
                 NSArray* startUpIds = [json valueForKey:@"id"];
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
                     UIImage *image = [UIImage imageNamed:@"placeholder.png"];
                     
                     [startUpLogoImageInDirectory addObject:image];
                     [displayStartUpLogoImageInDirectory addObject:image];

                     [startUpNameArray addObject:[startUpNames objectAtIndex:i]];
                     [displayStartUpNameArray addObject:[startUpNames objectAtIndex:i]];
                     
                     [startUpIdsArray addObject:[startUpIds objectAtIndex:i]];
                     [displayStartUpIdsArray addObject:[startUpIds objectAtIndex:i]];
                     
                     [startUpAngelUrlArray addObject:[startUpAngelUrl objectAtIndex:i]];
                     [displayStartUpAngelUrlArray addObject:[startUpAngelUrl objectAtIndex:i]];
                     
                     [startUpLogoUrlArray addObject:[startUpLogoUrl objectAtIndex:i]];
                     [displayStartUpLogoUrlArray addObject:[startUpLogoUrl objectAtIndex:i]];
                     
                     if([startUpProductDesc objectAtIndex:i] == (NSString *)[NSNull null] || ([[startUpProductDesc objectAtIndex:i] isEqualToString:@""]))
                     {
                         [startUpProductDescArray addObject:@"No Information"];
                         [displayStartUpProductDescArray addObject:@"No Information"];
                     }
                     else
                     {
                         [startUpProductDescArray addObject:[startUpProductDesc objectAtIndex:i]];
                         [displayStartUpProductDescArray addObject:[startUpProductDesc objectAtIndex:i]];
                     }
                     
                     if([startUpHighConcept objectAtIndex:i] == (NSString *)[NSNull null] || ([[startUpHighConcept objectAtIndex:i] isEqualToString:@""]))
                     {
                         [startUpHighConceptArray addObject:@"No Information"];
                         [displayStartUpHighConceptArray addObject:@"No Information"];
                     }
                     else
                     {
                         [startUpHighConceptArray addObject:[startUpHighConcept objectAtIndex:i]];
                         [displayStartUpHighConceptArray addObject:[startUpHighConcept objectAtIndex:i]];
                     }
                     
                     
                     [startUpFollowerCountArray addObject:[startUpFollowerCount objectAtIndex:i]];
                     [displayStartUpFollowerCountArray addObject:[startUpFollowerCount objectAtIndex:i]];
                     
                     if([startUpLocation objectAtIndex:i] == (NSString*)[NSNull null])
                     {
                         [startUpLocationArray addObject:@"No Information"];
                         [displayStartUpLocationArray addObject:@"No Information"];
                     }
                     else
                     {
                         //Replace special characters from json data obtained from response
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
                         [startUpMarketArray replaceObjectAtIndex:k withObject:@" No Market Information"];
                         [displayStartUpMarketArray replaceObjectAtIndex:k withObject:@" No Market Information"];
                     }
                     [checkStr release];
                 }
                 
                 for(int k=0; k<[startUpLocationArray count]; k++)
                 {
                     NSString *checkStr = [[NSString alloc] initWithFormat:@"%@",[startUpLocationArray objectAtIndex:k]];
                     if([checkStr rangeOfString:@"("].location != NSNotFound)
                     {
                         [startUpLocationArray replaceObjectAtIndex:k withObject:@"No Information"];
                         [displayStartUpLocationArray replaceObjectAtIndex:k withObject:@"No Information"];
                     }
                     [checkStr release];
                 }
                 
                 for(int k=0; k<[startUpHighConceptArray count]; k++)
                 {
                     NSMutableString * theMutableString = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@",[startUpHighConceptArray objectAtIndex:k]]];
                     
                     [theMutableString replaceOccurrencesOfString:@"'" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
                     
                     [startUpHighConceptArray replaceObjectAtIndex:k withObject:theMutableString];
                     [displayStartUpHighConceptArray replaceObjectAtIndex:k withObject:theMutableString];
                     [theMutableString release];
                 }
                 
                 for(int k=0; k<[startUpProductDescArray count]; k++)
                 {
                     NSMutableString * theMutableString = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@",[startUpProductDescArray objectAtIndex:k]]];
                     
                     [theMutableString replaceOccurrencesOfString:@"'" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
                     
                     [startUpProductDescArray replaceObjectAtIndex:k withObject:theMutableString];
                     [displayStartUpProductDescArray replaceObjectAtIndex:k withObject:theMutableString];
                     [theMutableString release];
                 }
                 
                 for(int k=0; k<[startUpNameArray count]; k++)
                 {
                     NSMutableString * theMutableString = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@",[startUpNameArray objectAtIndex:k]]];
                     
                     [theMutableString replaceOccurrencesOfString:@"'" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
                     
                     [startUpNameArray replaceObjectAtIndex:k withObject:theMutableString];
                     [displayStartUpNameArray replaceObjectAtIndex:k withObject:theMutableString];
                     [theMutableString release];
                 }
            for(int imageNumber=1; imageNumber<=[startUpLogoUrlArray count]; imageNumber++)
            {
                UIImage *image = [UIImage imageNamed:@"placeholder.png"];
                
                [startUpLogoImageInDirectory addObject:image];
                [displayStartUpLogoImageInDirectory addObject:image];
            
            }
                _requestLoadComplete = TRUE;
                [table reloadData];
        
                [self startLoadingImagesConcurrently];

    }
}

//Save images of StartUps
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
        
        [saveImageInDirectory addObject:savedImagePath];
    }
    [self saveStartUpsDetailsToDB];
}

//Save StartUps details
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
        
        //Insert records to startUps table in database
        [_dbmanager insertRecordIntoStartUpsTable:@"StartUps" field1Value:strtid field2Value:startUpId field3Value:startUpName field4Value:startUpAngelUrl field5Value:startUpLogoUrl field6Value:startUpProductDesc field7Value:startUpHighConcept field8Value:startUpFollowerCount field9Value:startUpLocations field10Value:startUpMarkets field11Value:startUpLogoImage];
    } 
    
    if ([saveImageInDirectory count] == [displayStartUpLogoImageInDirectory count]) 
    {
        _allImagesDownloadDone = TRUE;
        [table reloadData];
    }
    
}

//Method invoked when filter button is selected
- (void)filterButtonSelectedStartUp:(id)sender 
{
    UIView *filtersList;
    
    if(_showFilterMenuInStartUps == FALSE)
    {
        filterContainer.selected = TRUE;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) 
        {

            
            [self performSelector:@selector(animateFilter) withObject:nil afterDelay:0.05];
            
            _showFilterMenuInStartUps = TRUE;
        }
        else
        {
            filterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
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
            
            UIImage* image = [UIImage imageNamed:@"filters.png"];
            
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
        filterContainer.selected = FALSE;
       
      
        [self performSelector:@selector(animateFilter) withObject:nil afterDelay:0.05];
        _showFilterMenuInStartUps = FALSE;
    }
}


//Methods to animate filter options
-(void)animateFilter
{
    _yPosSp = 0;
    _xPosSp = 0;
    NSLog(@"\n \n i value = %d \n \n ",_addFilter);
    if (_addFilter%2 == 0) { // every alternate time the label is tapped the filter view is added
        _addFilter++;
        
        _showFilterMenuInStartUps = TRUE;
        for (int index = 0; index<[_filterStartUpNames count]; index++) 
        {
            UIImage* image = [UIImage imageNamed:@"filters.png"];
            UIButton *filterButtons = [UIButton buttonWithType:UIButtonTypeCustom];
            [filterButtons setBackgroundImage:image forState:UIControlStateNormal];
            
            NSString *imageName = [NSString stringWithFormat:@"%@",[_filterStartUpNames objectAtIndex:index]];
            [filterButtons setBackgroundImage:[UIImage imageNamed:@"filtertab.png"] forState:UIControlStateNormal];
            [filterButtons setTitle:imageName forState:UIControlStateNormal];
            filterButtons.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
            [[filterButtons titleLabel] setTextAlignment:UITextAlignmentCenter];
            [filterButtons setBackgroundColor:[UIColor darkGrayColor]];
            [filterButtons setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            filterButtons.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15];
            [filterButtons addTarget:self action:@selector(getFilteredList:) forControlEvents:UIControlStateHighlighted]; // action for each button 
            filterButtons.frame = CGRectMake(_xPosSp, _yPosSp, 271, 51);
            filterButtons.tag = index+1; // tag for the button
            _yPosSp = _yPosSp + 53;
            [_view2 addSubview:filterButtons];
            
        }
        
        [filterContainer setUserInteractionEnabled:YES];
        [_view2 setFrame:CGRectMake(25, -250, 271, 51*3)];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2];
        
        [_view2 setFrame:CGRectMake(25, 0, 271, 51*3)];
        [filterView setFrame:CGRectMake(0, 0, 320, 400)];
        [_view2 setBackgroundColor:[UIColor blackColor]];
        [UIView commitAnimations];
        
    }
    
    else { // every alternate time the label is tapped the filter view is removed
        
        [filterContainer setUserInteractionEnabled:YES];
        
        for (int index = 1; index<[_filterStartUpNames count]+1; index++) {
            
            [[self.view viewWithTag:index] removeFromSuperview];
            
        }
        _addFilter++;
        [filterView setFrame:CGRectMake(0, 0, 320, 400)];
        [_view2 setFrame:CGRectMake(25, 0, 271, 51*3)];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2];
        [_view2 setFrame:CGRectMake(25, -250, 271, 51*3)];
        [filterView setFrame:CGRectMake(0, -480, 320, 400)];
        [_view2 setBackgroundColor:[UIColor blackColor]];
       
        [UIView commitAnimations];
        
    }
    
}


//Get list of filters
-(void)getFilteredList:(id)sender
{
    loadingView.hidden = NO;
    _requestLoadComplete = FALSE;
    [displayStartUpIdsArray removeAllObjects];
    [displayStartUpNameArray removeAllObjects];
    [displayStartUpAngelUrlArray removeAllObjects];
    [displayStartUpLogoUrlArray removeAllObjects];
    [displayStartUpProductDescArray removeAllObjects];
    [displayStartUpHighConceptArray removeAllObjects];
    [displayStartUpFollowerCountArray removeAllObjects];
    [displayStartUpLocationArray removeAllObjects];
    [displayStartUpMarketArray removeAllObjects];
    [displayStartUpLogoImageInDirectory removeAllObjects];
    [saveImageInDirectory removeAllObjects];
    _allImagesDownloadDone = FALSE;
    [displayStartUpLogoUrlArray removeAllObjects];
    [tShopQueueStartups cancelAllOperations];
    
    int _tagID = [sender tag];
    
    switch(_tagID)
    {
            //Implement Following
        case 2 : [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(getDetailsOfFollowing) userInfo:nil repeats:NO];
            
                _filterFollow = TRUE;
                _filterPortfolio = FALSE;
                _filterTrending = FALSE;
            
                [refreshViewTopTrending setHidden:YES];
                 _showFilterMenuInStartUps = FALSE;
                
               
                 [self performSelector:@selector(animateFilter) withObject:nil afterDelay:0.05];
                  filterContainer.selected = FALSE;
                 labels.text = @"Startups - Following";
                 self.navigationController.title = @"Startups";
                 break;
            
            //Implement Portfolio    
        case 3 : 
            [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(getDetailsOfPortfolio) userInfo:nil repeats:NO];
            
            _filterPortfolio = TRUE;
            _filterTrending = FALSE;
            _filterFollow = FALSE;
            
            [refreshViewTopTrending setHidden:YES];
            _showFilterMenuInStartUps = FALSE;
            filterContainer.selected = FALSE;
            
            
            [self performSelector:@selector(animateFilter) withObject:nil afterDelay:0.05];
            
            labels.text = @"Startups - Portfolio";
            self.navigationController.title = @"Startups";
            
            break;
            
            //Implement Trending 
        case 1 :    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(getDetailsOfTrending) userInfo:nil repeats:NO];
                filterContainer.selected = FALSE;
           
                _filterTrending = TRUE; 
                [table reloadData];
            
                [refreshViewTopTrending setHidden:NO];
                labels.text = @"Startups - Trending";
            
                self.navigationController.title = @"Startups";
            
                _showFilterMenuInStartUps = FALSE;
               
              
                [self performSelector:@selector(animateFilter) withObject:nil afterDelay:0.05];
            
                break;
            
            //Implement All    
        case 4 : [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(sendRequestForLoad) userInfo:nil repeats:NO];
                _filterFollow = FALSE; 
                _filterPortfolio = FALSE;
                _filterTrending = FALSE;
                _showFilterMenuInStartUps = FALSE;
                 filterContainer.selected = FALSE;
            
                [self performSelector:@selector(animateFilter) withObject:nil afterDelay:0.05];
                [table reloadData];
                labels.text = @"Startups";
                self.navigationController.title = @"Startups";
            
                _showFilterMenuInStartUps = FALSE;
               
              
                
                 break;    
    }
}

//Get details of following startUps by user
-(void) getDetailsOfFollowing
{
    _requestLoadComplete = FALSE;
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
       
        filterContainer.enabled = NO;
        [_dbmanager openDB];
        [_dbmanager retrieveUserDetails];
        
        //Send request to get startUps followed by user
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.angel.co/1/users/%@/following?type=startup",_dbmanager._angelUserIdFromDB]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod: @"GET"];
        NSError *error;                                  
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
                 //Process json data
                
                 NSDictionary* json = [NSJSONSerialization 
                                       JSONObjectWithData:data //1
                                       options:kNilOptions 
                                       error:&error];
                 
                 NSArray* startUpFollowing = [json objectForKey:@"startups"]; //2
                 
                 
                 
                 for(int k=0; k<[startUpFollowing count]; k++)
                 {
                     NSDictionary *following = [startUpFollowing objectAtIndex:k];
                     
                     NSString *startUpFollowHidden = [following valueForKey:@"hidden"];
                     NSLog(@"VALUE = %d",[startUpFollowHidden intValue]);
                     
                     if([startUpFollowHidden intValue] == 0)
                     {
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
                         if(startUpFollowProductDesc == (NSString *)[NSNull null])
                         {
                             [displayStartUpProductDescArray addObject:@"No Information"];
                         }
                         else
                         {
                             [displayStartUpProductDescArray addObject:startUpFollowProductDesc];
                         }
                         
                         NSString* startUpFollowHighConcept = [following valueForKey:@"high_concept"]; //2
                         if(startUpFollowHighConcept == (NSString *)[NSNull null])
                         {
                             [displayStartUpHighConceptArray addObject:@"No Information"];
                         }
                         else
                         {
                             [displayStartUpHighConceptArray addObject:startUpFollowHighConcept];
                         }
                         
                         
                         NSString* startUpFollowFollowerCount = [following valueForKey:@"follower_count"]; //2
                         [displayStartUpFollowerCountArray addObject:startUpFollowFollowerCount];
                         
                         
                         for(int k=0; k<[displayStartUpNameArray count]; k++)
                         {
                             NSMutableString * theMutableString = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@",[displayStartUpNameArray objectAtIndex:k]]];
                             
                             [theMutableString replaceOccurrencesOfString:@"'" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
                             
                             [displayStartUpNameArray replaceObjectAtIndex:k withObject:theMutableString];
                             [theMutableString release];
                             
                             UIImage *image = [UIImage imageNamed:@"placeholder.png"];
                             
                             [startUpLogoImageInDirectory addObject:image];
                             [displayStartUpLogoImageInDirectory addObject:image];

                         }
                         for(int k=0; k<[displayStartUpHighConceptArray count]; k++)
                         {
                             NSMutableString * theMutableString = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@",[displayStartUpHighConceptArray objectAtIndex:k]]];
                             
                             [theMutableString replaceOccurrencesOfString:@"'" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
                             
                             [displayStartUpHighConceptArray replaceObjectAtIndex:k withObject:theMutableString];
                             [theMutableString release];
                         }
                         
                         for(int k=0; k<[displayStartUpProductDescArray count]; k++)
                         {
                             NSMutableString * theMutableString = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@",[displayStartUpProductDescArray objectAtIndex:k]]];
                             
                             [theMutableString replaceOccurrencesOfString:@"'" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
                             
                             [displayStartUpProductDescArray replaceObjectAtIndex:k withObject:theMutableString];
                             [theMutableString release];
                         }
                     }//End If
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
                     
                     if([startUpFollowingLocations count] == 0)
                     {
                         [displayStartUpLocationArray addObject:@"No Information"];
                     }
                     for(int j=0; j<[startUpFollowingLocations count]; j++)
                     {
                         if([startUpFollowingLocations objectAtIndex:j] == (NSString*)[NSNull null])
                         {
                             [displayStartUpLocationArray addObject:@"No Information"];
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
                         [displayStartUpMarketArray replaceObjectAtIndex:k withObject:@" No Market Information"];
                     }
                     [checkStr release];
                 }
                 for(int k=0; k<[displayStartUpLocationArray count]; k++)
                 {
                     NSString *checkStr = [[NSString alloc] initWithFormat:@"%@",[displayStartUpLocationArray objectAtIndex:k]];
                     if([checkStr rangeOfString:@"("].location != NSNotFound)
                     {
                         [displayStartUpLocationArray replaceObjectAtIndex:k withObject:@"No Information"];
                     }
                     [checkStr release];
                 }
    
                for(int imageNumber=1; imageNumber<=[startUpLogoUrlArray count]; imageNumber++)
                {
                    UIImage *image = [UIImage imageNamed:@"placeholder.png"];
                    [startUpLogoImageInDirectory addObject:image];
                    [displayStartUpLogoImageInDirectory addObject:image];
        
                }
                 _requestLoadComplete = TRUE;
                 [table reloadData];
                [self startLoadingImagesConcurrently];

    }
}

//Save images of following startUps by user
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
        
        [saveImageInDirectory addObject:savedImagePath];
    }
    [self saveStartUpsFollowingDetailsToDB];
}

//Save details of following startUps by user to database
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
        NSString *startUpLogoImage= [NSString stringWithFormat:@"%@",[saveImageInDirectory objectAtIndex:k]];
        
        //Insert records of startUps to Folowing table
        [_dbmanager insertRecordIntoStartUpsFollowingTable:@"Following" field1Value:strtid field2Value:startUpId field3Value:startUpName field4Value:startUpAngelUrl field5Value:startUpLogoUrl field6Value:startUpProductDesc field7Value:startUpHighConcept field8Value:startUpFollowerCount field9Value:startUpLocations field10Value:startUpMarkets field11Value:startUpLogoImage];
    }
    
    if ([saveImageInDirectory count] == [displayStartUpLogoImageInDirectory count]) {
        _allImagesDownloadDone = TRUE;
        [table reloadData];
    }
}


//Get details of portfolio startUps by user
-(void) getDetailsOfPortfolio
{
    _requestLoadComplete = FALSE;
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
        filterContainer.enabled = NO;
        [_dbmanager retrieveUserDetails];
        //Send request to get details of portfolio
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.angel.co/1/startup_roles?user_id=%@",[_dbmanager.userDetailsArray objectAtIndex:5]]];
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
                 
                 for(int k=0; k<[startUpPortfolio count]; k++)
                 {
                     NSDictionary *portfolio = [startUpPortfolio objectAtIndex:k];
                     
                     NSString *startUpPortfolioHidden = [portfolio valueForKey:@"hidden"];
                     
                     if ([startUpPortfolioHidden intValue] == 0) 
                     {
                         NSString *startUpPortfolioId = [portfolio valueForKey:@"id"];
                         [displayStartUpIdsArray addObject:startUpPortfolioId];
                         
                         NSString *startUpPortfolioName = [portfolio valueForKey:@"name"];
                         [displayStartUpNameArray addObject:startUpPortfolioName];
                         
                         NSString *startUpPortfolioAngelUrl = [portfolio valueForKey:@"angellist_url"];
                         [displayStartUpAngelUrlArray addObject:startUpPortfolioAngelUrl];
                         
                         NSString *startUpPortfolioLogoUrl = [portfolio valueForKey:@"thumb_url"];
                         [displayStartUpLogoUrlArray addObject:startUpPortfolioLogoUrl];
                         
                         NSString *startUpProdDesc = [portfolio valueForKey:@"product_desc"];
                         [displayStartUpProductDescArray addObject:startUpProdDesc];
                         
                         NSString *startUpPortfolioHighConcept = [portfolio valueForKey:@"high_concept"];
                         [displayStartUpHighConceptArray addObject:startUpPortfolioHighConcept];
                         
                         NSString *startUpPortfolioFollowerCount = [portfolio valueForKey:@"follower_count"];
                         [displayStartUpFollowerCountArray addObject:startUpPortfolioFollowerCount];
                         
                         [displayStartUpLocationArray addObject:@""];
                         [displayStartUpMarketArray addObject:@""];
                         
                         UIImage *image = [UIImage imageNamed:@"placeholder.png"];
                         // placeholder image 
                         [startUpLogoImageInDirectory addObject:image];
                         [displayStartUpLogoImageInDirectory addObject:image];

                     } 
                 }
                 
                 for(int k=0; k<[displayStartUpNameArray count]; k++)
                 {
                     NSMutableString * theMutableString = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@",[displayStartUpNameArray objectAtIndex:k]]];
                     
                     [theMutableString replaceOccurrencesOfString:@"'" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
                     
                     [displayStartUpNameArray replaceObjectAtIndex:k withObject:theMutableString];
                     [theMutableString release];
                 }
                 for(int k=0; k<[displayStartUpHighConceptArray count]; k++)
                 {
                     NSMutableString * theMutableString = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@",[displayStartUpHighConceptArray objectAtIndex:k]]];
                     
                     
                     [theMutableString replaceOccurrencesOfString:@"'" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
                     
                     [displayStartUpHighConceptArray replaceObjectAtIndex:k withObject:theMutableString];
                     [theMutableString release];
                 }
                 for(int k=0; k<[displayStartUpProductDescArray count]; k++)
                 {
                     NSMutableString * theMutableString = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@",[displayStartUpProductDescArray objectAtIndex:k]]];
                     
                     [theMutableString replaceOccurrencesOfString:@"'" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
                     
                     [displayStartUpProductDescArray replaceObjectAtIndex:k withObject:theMutableString];
                     [theMutableString release];
                 }
   
                    for(int imageNumber=1; imageNumber<=[startUpLogoUrlArray count]; imageNumber++)
                    {
                            UIImage *image = [UIImage imageNamed:@"placeholder.png"];
                            [startUpLogoImageInDirectory addObject:image];
                            [displayStartUpLogoImageInDirectory addObject:image];
                        
                    }
                
                 _requestLoadComplete = TRUE;
                 [table reloadData];
                 [self startLoadingImagesConcurrently];

    }
}

//Save images of portfolio startUps
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
        
        [saveImageInDirectory addObject:savedImagePath];
        
       
    }
    [self saveStartUpsPortfolioDetailsToDB];
}

//Save details of portfolio startUps to database
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
        NSString *startUpLogoImage= [NSString stringWithFormat:@"%@",[saveImageInDirectory objectAtIndex:k]];
        
        //Insert records
        [_dbmanager insertRecordIntoStartUpsPortfolioTable:@"Portfolio" field1Value:strtid field2Value:startUpId field3Value:startUpName field4Value:startUpAngelUrl field5Value:startUpLogoUrl field6Value:startUpProductDesc field7Value:startUpHighConcept field8Value:startUpFollowerCount field9Value:startUpLocations field10Value:startUpMarkets field11Value:startUpLogoImage];
    }
    
    if ([saveImageInDirectory count] == [displayStartUpLogoImageInDirectory count]) {
        _allImagesDownloadDone = TRUE;
        [table reloadData];
    }
}


//Get details of trending startUps by user
-(void) getDetailsOfTrending
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
    [displayStartUpLogoImageInDirectory removeAllObjects];
    
    _requestLoadComplete = FALSE;
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
        
        [_dbmanager retrieveStartUpstrendingDetails];
        
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
        _requestLoadComplete = FALSE;
      //  loadingView.hidden = NO;
        filterContainer.enabled = NO;
        //Send request to get details of portfolio
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.angel.co/1/startups?filter=trending"]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod: @"GET"];
        [[self.view viewWithTag:404] removeFromSuperview];
        
        
        NSError *error;                                   //  NSError *error) 
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
                 //Process json data

                 NSDictionary* json = [NSJSONSerialization 
                                       JSONObjectWithData:data //1
                                       options:kNilOptions 
                                       error:&error];
                
                 NSArray* startUpPortfolio = [json valueForKey:@"hidden"]; //2
                 NSArray *startupId = [json valueForKey:@"id"];
                  NSArray *startupName = [json valueForKey:@"name"];
                  NSArray *startupURL = [json valueForKey:@"angellist_url"];
                  NSArray *startupTurl = [json valueForKey:@"thumb_url"];
                  NSArray *startupProdDes = [json valueForKey:@"product_desc"];
                  NSArray *startupHighConcept = [json valueForKey:@"high_concept"];
                  NSArray *startupFllwCnt = [json valueForKey:@"follower_count"];
                 
                 for(int k=0; k<[startUpPortfolio count]; k++)
                 {
                   
                     NSString *startUpPortfolioHidden = [startUpPortfolio objectAtIndex:k];
                     
                     if ([startUpPortfolioHidden intValue] == 0) 
                     {
                         NSString *startUpTrendingId = [startupId objectAtIndex:k];
                         [displayStartUpIdsArray addObject:startUpTrendingId];
                         
                         NSString *startUpTrendingName = [startupName objectAtIndex:k];
                         [displayStartUpNameArray addObject:startUpTrendingName];
                         
                         NSString *startUpTrendingAngelUrl = [startupURL objectAtIndex:k];
                         [displayStartUpAngelUrlArray addObject:startUpTrendingAngelUrl];
                         
                         NSString *startUpTrendingLogoUrl = [startupTurl objectAtIndex:k];
                         [displayStartUpLogoUrlArray addObject:startUpTrendingLogoUrl];
                         
                         NSString *startUpProdDesc = [startupProdDes objectAtIndex:k];
                         [displayStartUpProductDescArray addObject:startUpProdDesc];
                         
                         NSString *startUpTrendingHighConcept = [startupHighConcept objectAtIndex:k];
                         [displayStartUpHighConceptArray addObject:startUpTrendingHighConcept];
                         
                         NSString *startUpTrendingFollowerCount = [startupFllwCnt objectAtIndex:k];
                         [displayStartUpFollowerCountArray addObject:startUpTrendingFollowerCount];
                         
                         UIImage *image = [UIImage imageNamed:@"placeholder.png"];
                         
                         [startUpLogoImageInDirectory addObject:image];
                         [displayStartUpLogoImageInDirectory addObject:image];
                         

                     } 
                 }
               
                 for(int k=0; k<[displayStartUpNameArray count]; k++)
                 {
                     NSMutableString * theMutableString = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@",[displayStartUpNameArray objectAtIndex:k]]];
                     
                     [theMutableString replaceOccurrencesOfString:@"'" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
                     
                     [displayStartUpNameArray replaceObjectAtIndex:k withObject:theMutableString];
                     [theMutableString release];
                 }
                 for(int k=0; k<[displayStartUpHighConceptArray count]; k++)
                 {
                     NSMutableString * theMutableString = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@",[displayStartUpHighConceptArray objectAtIndex:k]]];
                     
                     [theMutableString replaceOccurrencesOfString:@"'" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
                     
                     [displayStartUpHighConceptArray replaceObjectAtIndex:k withObject:theMutableString];
                     [theMutableString release];
                 }
                 for(int k=0; k<[displayStartUpProductDescArray count]; k++)
                 {
                     NSMutableString * theMutableString = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@",[displayStartUpProductDescArray objectAtIndex:k]]];
                     
                     [theMutableString replaceOccurrencesOfString:@"'" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
                     
                     [displayStartUpProductDescArray replaceObjectAtIndex:k withObject:theMutableString];
                     [theMutableString release];
                 }
                 for(int i=0; i<[displayStartUpIdsArray count]; i++)
                 {
                                          
                     NSArray* startUpFollowingLocations = [[json valueForKey:@"locations"] valueForKey:@"display_name"]; //2
                     
                     NSString* startUpFollowingMarkets = [[json valueForKey:@"markets"] valueForKey:@"display_name"]; //2
                     
                     if([startUpFollowingLocations count] == 0)
                     {
                         [displayStartUpLocationArray addObject:@"No Information"];
                     }
                     for(int j=0; j<[startUpFollowingLocations count]; j++)
                     {
                         if([startUpFollowingLocations objectAtIndex:j] == (NSString*)[NSNull null])
                         {
                             [displayStartUpLocationArray addObject:@"No Information"];
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
                         [displayStartUpMarketArray replaceObjectAtIndex:k withObject:@"No Information"];
                     }
                     [checkStr release];
                 }
                 for(int k=0; k<[displayStartUpLocationArray count]; k++)
                 {
                     NSString *checkStr = [[NSString alloc] initWithFormat:@"%@",[displayStartUpLocationArray objectAtIndex:k]];
                     if([checkStr rangeOfString:@"("].location != NSNotFound)
                     {
                         [displayStartUpLocationArray replaceObjectAtIndex:k withObject:@"No Information"];
                     }
                     [checkStr release];
                 }
    
                 _requestLoadComplete = TRUE;
                 [table reloadData];
                 [self startLoadingImagesConcurrently];
    }
}

//Save images of portfolio startUps
-(void) saveImagesOfStartUpsTrending
{
    for(int imageNumber=1; imageNumber<=[displayStartUpLogoUrlArray count]; imageNumber++)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"startuptrending%d.png",imageNumber]];
        
        UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[displayStartUpLogoUrlArray objectAtIndex:(imageNumber-1)]]]]];
        NSData *imageData = UIImagePNGRepresentation(image);
        [imageData writeToFile:savedImagePath atomically:NO];
        
        [image release];
        
        [saveImageInDirectory addObject:savedImagePath];
        
    }
    [self saveStartUpsTrendingDetailsToDB];
}


//Save details of following startUps by user to database
-(void) saveStartUpsTrendingDetailsToDB
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
        NSString *startUpLogoImage= [NSString stringWithFormat:@"%@",[saveImageInDirectory objectAtIndex:k]];
        
        //Insert records of startUps to Folowing table
        [_dbmanager insertRecordIntoStartUpsFollowingTable:@"Trending" field1Value:strtid field2Value:startUpId field3Value:startUpName field4Value:startUpAngelUrl field5Value:startUpLogoUrl field6Value:startUpProductDesc field7Value:startUpHighConcept field8Value:startUpFollowerCount field9Value:startUpLocations field10Value:startUpMarkets field11Value:startUpLogoImage];
    }
    
    if ([saveImageInDirectory count] == [displayStartUpLogoImageInDirectory count]) {
        _allImagesDownloadDone = TRUE;
        [table reloadData];
    }
}



//Get details of All StartUps
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

//Invoked when scroll view ends dragging
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.y <= -52) 
    {
        //Check for the availability of Internet
        Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
        
        NetworkStatus internetStatus = [r currentReachabilityStatus];
        if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"No Internet Connection" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
        else
        {
            if(_filterTrending == TRUE)
            {
                isLoadingTopTrending = TRUE;
                [self startLoadingAtTop];
            }
        }
    } 
}


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

-(void) stopLoadingAtTop
{
    isLoadingTopTrending = FALSE;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    imageViewTopTrending.transform = CGAffineTransformMakeRotation(3.142*2);
    [UIView commitAnimations];
    table.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    
    [self getDetailsOfTrending];
    
    imageViewTopTrending.hidden = NO;
    refreshSpinnerTopTrending.hidden = YES;
    [refreshSpinnerTopTrending stopAnimating];
}

//Delegate method called when scroll view is scrolling
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

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void) dealloc
{
    //Release all arrays allocated
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
