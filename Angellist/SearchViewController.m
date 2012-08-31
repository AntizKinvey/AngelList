//
//  SearchViewController.m
//  Angellist
//
//  Created by Ram Charan on 24/07/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import "SearchViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CustomTabBar.h"
#import "Reachability.h"

@implementation SearchViewController

extern bool _tabBarSelected;

@synthesize searchBar;


NSMutableArray *searchNamesStartup;// array of names of startups
NSMutableArray *searchIdStartup;// array of Ids of startups
NSMutableArray *searchImageStartup;// array of images of startups
NSMutableArray *searchtypeStartup;// array of types of startups
NSMutableArray *searchUrlStartup;// array of urls of startups

NSMutableArray *searchNamesUser;// array of names of user
NSMutableArray *searchIdUser;// array of Ids of user
NSMutableArray *searchImageUser;// array of images of user
NSMutableArray *searchtypeUser;// array of types of user
NSMutableArray *searchUrlUser;// array of urls of user

NSMutableArray *searchNamesDisplay;// array of names of displayed in tableview
NSMutableArray *searchIdDisplay;// array of Ids of displayed in tableview
NSMutableArray *searchImageDisplay;// array of images of displayed in tableview
NSMutableArray *searchtypeDisplay;// array of types of displayed in tableview
NSMutableArray *searchUrlDisplay;// array of urls of displayed in tableview

NSMutableArray *searchDisplayInTableImage;// array of images of displayed in tableview

NSArray *_filterOptions;//filter options array
NSString *searchString;
int _rowSelected = 0;

int ifilter=0;
int _yPosS = 0;
int _xPosS = 0;

UINavigationBar *barSearch;
UITapGestureRecognizer *tap;

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
    
    // image 
    UIImage *image = [searchDisplayInTableImage objectAtIndex:indexPath.row];
    UIImageView *cellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(7, 12, 50, 50)];
    cellImageView.image = image;
    cellImageView.layer.cornerRadius = 3.5f;
    cellImageView.layer.masksToBounds = YES;
    [cell.contentView addSubview:cellImageView];
    [cellImageView release];
    
    // label to display the the name
    UILabel *cellTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 210, 25)];
    cellTextLabel.lineBreakMode = UILineBreakModeWordWrap;
    cellTextLabel.textColor = [UIColor colorWithRed:63.0/255.0 green:103.0/255.0 blue:160.0/255.0 alpha:1.0f];
    cellTextLabel.numberOfLines = 50;
    cellTextLabel.backgroundColor = [UIColor clearColor];
    cellTextLabel.text = [searchNamesDisplay objectAtIndex:indexPath.row];
    cellTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
    [cell.contentView addSubview:cellTextLabel];
    [cellTextLabel release];
    
    
    // label to display the type
    UILabel *cellTextLabelType = [[[UILabel alloc] initWithFrame:CGRectMake(70, 28, 210, 15)] autorelease];
    cellTextLabelType.lineBreakMode = UILineBreakModeWordWrap;
    cellTextLabelType.numberOfLines = 50;
    cellTextLabelType.backgroundColor = [UIColor clearColor];
    cellTextLabelType.text = [searchtypeDisplay objectAtIndex:indexPath.row];
    cellTextLabelType.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    [cell.contentView addSubview:cellTextLabelType];
    
    
    
    return cell; 
}

// --dynamic cell height according to the text--
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   
    return 70;
}


//---set the number of rows in the table view---
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{ 
    return [searchIdDisplay count];
}


// --navigate to activity details--
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    labelSearch.hidden = YES;
    _rowSelected = indexPath.row;
    // navigate to the webview 
    searchDetails = [[SearchDetailsViewController alloc] initWithNibName:@"SearchDetailsViewController" bundle:nil];
    [self.navigationController pushViewController:searchDetails animated:YES];
   
}

-(void)viewDidAppear:(BOOL)animated
{
    
     labelSearch.hidden = NO;
    UIImage *backgroundImage = [UIImage imageNamed:@"navigationbarfil.png"];
    [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    
}
 
- (void)viewDidDisappear:(BOOL)animated {    
    if(_tabBarSelected == true )
    {
        [super viewDidDisappear:YES];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
    labelSearch.hidden = YES;
}

- (void)viewDidLoad
{
    
    _tabBarSelected = false; 
    
    //Filter view
    filterView = [[UIView alloc] initWithFrame:CGRectMake(0, -480, 320, 480)];
    [filterView  setBackgroundColor: [UIColor blackColor]];
    [filterView setAlpha:0.4f];
    filterView.tag = 1000;
    [self.view addSubview:filterView];
    searchBar.delegate =self;
    
    //back button 
    UIImage* image = [UIImage imageNamed:@"back.png"];
    CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
    backButton = [[UIButton alloc] initWithFrame:frame];
    [backButton setBackgroundImage:image forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlStateHighlighted];
    UIBarButtonItem* backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    [backButtonItem release];
    [backButton release];
    
    //Navigations bar Image
    UIImage *backgroundImage = [UIImage imageNamed:@"navigationbarfil.png"];
    [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    
    // add the label to the navigation bar
    barSearch = [self.navigationController navigationBar];
    labelSearch = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 320, 20)];
    labelSearch.textAlignment = UITextAlignmentCenter;
    labelSearch.textColor = [UIColor whiteColor];
    labelSearch.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
    labelSearch.backgroundColor = [UIColor clearColor];
    labelSearch.text = @"Search";
    [barSearch addSubview:labelSearch];
    
    // add tap for the label
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(filterButtonSelected:)];
    [barSearch addGestureRecognizer:tap];
    
    [tap release];
    
    searchNamesStartup = [[NSMutableArray alloc] init];
    searchIdStartup = [[NSMutableArray alloc] init];
    searchImageStartup = [[NSMutableArray alloc] init];
    searchtypeStartup = [[NSMutableArray alloc] init];
    searchUrlStartup = [[NSMutableArray alloc] init];
    
    searchNamesUser = [[NSMutableArray alloc] init];
    searchIdUser = [[NSMutableArray alloc] init];
    searchImageUser = [[NSMutableArray alloc] init];
    searchtypeUser = [[NSMutableArray alloc] init];
    searchUrlUser = [[NSMutableArray alloc] init];
    
    searchNamesDisplay = [[NSMutableArray alloc] init];
    searchIdDisplay = [[NSMutableArray alloc] init];
    searchImageDisplay = [[NSMutableArray alloc] init];
    searchtypeDisplay = [[NSMutableArray alloc] init];
    searchUrlDisplay = [[NSMutableArray alloc] init];
    
    searchDisplayInTableImage = [[NSMutableArray alloc] init];
    
    _filterOptions = [[NSArray alloc] initWithObjects:@"Users", @"Startups", @"All",nil];
    
    _view1 = [[UIView alloc] initWithFrame:CGRectMake(0, -250, 271, 51*3)];
    [self.view addSubview:_view1];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

}

// whatever needs to happen when button is tapped 
- (void)filterButtonSelected:(id)sender 
{   
    // Check for the availability of Internet
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
        [self performSelector:@selector(animateFilter) withObject:nil afterDelay:0.05]; 
    }
}


//Method is called when search button is clicked
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar1
{
    
    [searchBar resignFirstResponder];
    
    searchString = [[NSString alloc] init];
    
    [searchNamesStartup removeAllObjects];
    [searchIdStartup removeAllObjects];
    [searchImageStartup removeAllObjects];
    [searchtypeStartup removeAllObjects];
    [searchUrlStartup removeAllObjects];
    
    [searchNamesUser removeAllObjects];
    [searchIdUser removeAllObjects];
    [searchImageUser removeAllObjects];
    [searchtypeUser removeAllObjects];
    [searchUrlUser removeAllObjects];
    
    [searchNamesDisplay removeAllObjects];
    [searchIdDisplay removeAllObjects];
    [searchImageDisplay removeAllObjects];
    [searchtypeDisplay removeAllObjects];
    [searchUrlDisplay removeAllObjects];    
    [searchDisplayInTableImage removeAllObjects];
    
    searchString = searchBar.text;
    
     
    
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
        [self searchOption:searchString];
    }
    
}

// search the string typed
-(void)searchOption:(NSString*)query
{ 
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.angel.co/1/search?query=%@",query]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod: @"GET"];
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data=  [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSDictionary* json = [NSJSONSerialization 
                          JSONObjectWithData:data //1
                          options:kNilOptions 
                          error:&error];
    
    NSArray *nameSearch = [json valueForKey:@"name"];
    NSArray *allIdSearch = [json valueForKey:@"id"];
    NSArray *typeSearch = [json valueForKey:@"type"];
    NSArray *imageSearch = [json valueForKey:@"pic"];
    NSArray *urlSearch = [json valueForKey:@"url"];
    
    for (int countOfSearch = 0; countOfSearch < [nameSearch count]; countOfSearch++) {
        
        NSString *typeString = [NSString stringWithFormat:@"%@",[typeSearch objectAtIndex:countOfSearch]];
        
        
        if ([typeString isEqualToString:@"Startup"]) // results of startup
        {
            [searchNamesStartup addObject:[nameSearch objectAtIndex:countOfSearch]];
            [searchIdStartup addObject:[allIdSearch objectAtIndex:countOfSearch]];
            [searchImageStartup addObject:[imageSearch objectAtIndex:countOfSearch]];
            [searchtypeStartup addObject:[typeSearch objectAtIndex:countOfSearch]];
            [searchUrlStartup addObject:[urlSearch objectAtIndex:countOfSearch]];
            
            [searchNamesDisplay addObject:[nameSearch objectAtIndex:countOfSearch]];
            [searchIdDisplay addObject:[allIdSearch objectAtIndex:countOfSearch]];
            [searchImageDisplay addObject:[imageSearch objectAtIndex:countOfSearch]];
            [searchtypeDisplay addObject:[typeSearch objectAtIndex:countOfSearch]];
            [searchUrlDisplay addObject:[urlSearch objectAtIndex:countOfSearch]];
        
        }
        else if ([typeString isEqualToString:@"User"]) // results of user
        {
            
            [searchNamesUser addObject:[nameSearch objectAtIndex:countOfSearch]];
            [searchIdUser addObject:[allIdSearch objectAtIndex:countOfSearch]];
            [searchImageUser addObject:[imageSearch objectAtIndex:countOfSearch]];
            [searchtypeUser addObject:[typeSearch objectAtIndex:countOfSearch]];
            [searchUrlUser addObject:[urlSearch objectAtIndex:countOfSearch]];
            
            [searchNamesDisplay addObject:[nameSearch objectAtIndex:countOfSearch]];
            [searchIdDisplay addObject:[allIdSearch objectAtIndex:countOfSearch]];
            [searchImageDisplay addObject:[imageSearch objectAtIndex:countOfSearch]];
            [searchtypeDisplay addObject:[typeSearch objectAtIndex:countOfSearch]];
            [searchUrlDisplay addObject:[urlSearch objectAtIndex:countOfSearch]];
        }
        
        UIImage *image = [UIImage imageNamed:@"placeholder.png"]; // placeholder image
        [searchDisplayInTableImage addObject:image];
                    
    }

    [table reloadData];
    [self loadImages];
    
}

// load images concurrently after the data is loaded in the table
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
    for(int z=0; z < [searchImageDisplay count]; z++)
    {
        if([[searchDisplayInTableImage objectAtIndex:z] isEqual:[UIImage imageNamed:@"placeholder.png"]])
        {
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[searchImageDisplay objectAtIndex:z]]]];
            [searchDisplayInTableImage replaceObjectAtIndex:z withObject:image];
            //[table reloadData];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:z inSection: 0];
            UITableViewCell *cell = [table cellForRowAtIndexPath:indexPath];
            UIImageView *cellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(7, 12, 50, 50)];
            cellImageView.image = [searchDisplayInTableImage objectAtIndex:indexPath.row];
            [cell.contentView addSubview:cellImageView];
            [cellImageView release];
        }
    }
}

//Method called when back button is tapped
-(void) backAction:(id)sender
{
    [barSearch removeGestureRecognizer:tap];
    labelSearch.hidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
}

-(void) viewWillDisappear:(BOOL)animated
{
    ifilter = 0;
    [super viewWillDisappear:YES];
}

//function to animate filter
-(void)animateFilter
{
    _yPosS = 0;
    _xPosS = 0;
    
    if (ifilter%2 == 0) {
        ifilter++;
        
        for (int index = 0; index<[_filterOptions count]; index++) 
        {
            UIImage* image = [UIImage imageNamed:@"filters.png"];
            UIButton *filterButtons = [UIButton buttonWithType:UIButtonTypeCustom];
            [filterButtons setBackgroundImage:image forState:UIControlStateNormal];
            
            NSString *imageName = [NSString stringWithFormat:@"%@",[_filterOptions objectAtIndex:index]];
            [filterButtons setBackgroundImage:[UIImage imageNamed:@"filtertab.png"] forState:UIControlStateNormal];
            [filterButtons setTitle:imageName forState:UIControlStateNormal];
            filterButtons.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
            [[filterButtons titleLabel] setTextAlignment:UITextAlignmentCenter];
            [filterButtons setBackgroundColor:[UIColor darkGrayColor]];
            [filterButtons setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            filterButtons.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15];
            [filterButtons addTarget:self action:@selector(getFilteredListSearch:) forControlEvents:UIControlStateHighlighted];
            filterButtons.frame = CGRectMake(_xPosS, _yPosS, 271, 51);
            filterButtons.tag = index+1;
            _yPosS = _yPosS + 53;
            [_view1 addSubview:filterButtons];
            
        }
        
        [_view1 setFrame:CGRectMake(25, -250, 271, 51*3)];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2];
        
        [_view1 setFrame:CGRectMake(25, 0, 271, 51*3)];
        [filterView setFrame:CGRectMake(0, 0, 320, 400)];
        [_view1 setBackgroundColor:[UIColor blackColor]];
        [UIView commitAnimations];
        
    }
    
    else {
        for (int index = 1; index<[_filterOptions count]+1; index++) 
        {
            
            [[self.view viewWithTag:index] removeFromSuperview];
            
        }
        ifilter++;
        [filterView setFrame:CGRectMake(0, 0, 320, 400)];
        [_view1 setFrame:CGRectMake(25, 0, 271, 51*3)];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2];
        
        [_view1 setFrame:CGRectMake(25, -250, 271, 51*3)];
        [filterView setFrame:CGRectMake(0, -480, 320, 400)];
        [_view1 setBackgroundColor:[UIColor blackColor]];
        
        [UIView commitAnimations];
        
    }
    
}

//Method called when filters are choosen by user
-(void)getFilteredListSearch:(id)sender
{
    [searchNamesDisplay removeAllObjects];
    [searchIdDisplay removeAllObjects];
    [searchImageDisplay removeAllObjects];
    [searchtypeDisplay removeAllObjects];
    [searchUrlDisplay removeAllObjects];
    [searchDisplayInTableImage removeAllObjects];
    
    int _tagID = [sender tag];
    
    switch(_tagID)
    {
            //Implement User
        case 1 : 
            
            [searchNamesDisplay addObjectsFromArray:searchNamesUser];
            [searchIdDisplay addObjectsFromArray:searchIdUser];
            [searchImageDisplay addObjectsFromArray:searchImageUser];
            [searchtypeDisplay addObjectsFromArray:searchtypeUser];
            [searchUrlDisplay addObjectsFromArray:searchUrlUser];
            
            for (int i = 0; i < [searchIdDisplay count]; i++) {
                UIImage *image = [UIImage imageNamed:@"placeholder.png"];
                [searchDisplayInTableImage addObject:image];
               
            }
            [table reloadData];
            [self loadImages];
            
            [self performSelector:@selector(animateFilter) withObject:nil afterDelay:0.05];
            break;
            
            //Implement StartUYUp    
        case 2 : 
            [searchNamesDisplay addObjectsFromArray:searchNamesStartup];
            [searchIdDisplay addObjectsFromArray:searchIdStartup];
            [searchImageDisplay addObjectsFromArray:searchImageStartup];
            [searchtypeDisplay addObjectsFromArray:searchtypeStartup];
            [searchUrlDisplay addObjectsFromArray:searchUrlStartup];
            
            for (int i = 0; i < [searchIdDisplay count]; i++) {
                UIImage *image = [UIImage imageNamed:@"placeholder.png"];
                [searchDisplayInTableImage addObject:image];
            }
            [table reloadData];
            [self loadImages];
            
            [self performSelector:@selector(animateFilter) withObject:nil afterDelay:0.05];
            break;
            
            //Implement All 
        case 3 : 
            
            [searchNamesStartup removeAllObjects];
            [searchIdStartup removeAllObjects];
            [searchImageStartup removeAllObjects];
            [searchtypeStartup removeAllObjects];
            [searchUrlStartup removeAllObjects];
            
            [searchNamesUser removeAllObjects];
            [searchIdUser removeAllObjects];
            [searchImageUser removeAllObjects];
            [searchtypeUser removeAllObjects];
            [searchUrlUser removeAllObjects];
            
            [self searchOption:searchString];
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
