//
//  SearchViewController.m
//  Angellist
//
//  Created by Ram Charan on 24/07/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import "SearchViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation SearchViewController

@synthesize searchBar;


NSMutableArray *searchNamesStartup;
NSMutableArray *searchIdStartup;
NSMutableArray *searchImageStartup;
NSMutableArray *searchtypeStartup;
NSMutableArray *searchUrlStartup;

NSMutableArray *searchNamesUser;
NSMutableArray *searchIdUser;
NSMutableArray *searchImageUser;
NSMutableArray *searchtypeUser;
NSMutableArray *searchUrlUser;

NSMutableArray *searchNamesDisplay;
NSMutableArray *searchIdDisplay;
NSMutableArray *searchImageDisplay;
NSMutableArray *searchtypeDisplay;
NSMutableArray *searchUrlDisplay;

NSMutableArray *searchDisplayInTableImage;

NSArray *_filterOptions;
NSString *searchString;
int _rowSelected = 0;

int ifilter=0;
int _yPosS = 0;
int _xPosS = 0;

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
    
    UIImage *image = [searchDisplayInTableImage objectAtIndex:indexPath.row];
    UIImageView *cellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(7, 12, 50, 50)];
    cellImageView.image = image;
    cellImageView.layer.cornerRadius = 3.5f;
    cellImageView.layer.masksToBounds = YES;
    [cell.contentView addSubview:cellImageView];
    
    // label to display the feed
    UILabel *cellTextLabel = [[[UILabel alloc] initWithFrame:CGRectMake(70, 0, 210, 25)] autorelease];
    cellTextLabel.lineBreakMode = UILineBreakModeWordWrap;
    cellTextLabel.textColor = [UIColor colorWithRed:63.0/255.0 green:103.0/255.0 blue:160.0/255.0 alpha:1.0f];
    cellTextLabel.numberOfLines = 50;
    cellTextLabel.backgroundColor = [UIColor clearColor];
    cellTextLabel.text = [searchNamesDisplay objectAtIndex:indexPath.row];
    cellTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
    [cell.contentView addSubview:cellTextLabel];
    
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
    searchDetails = [[SearchDetailsViewController alloc] initWithNibName:@"SearchDetailsViewController" bundle:nil];
    [self.navigationController pushViewController:searchDetails animated:YES];
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    
     labelSearch.hidden = NO;
    UIImage *backgroundImage = [UIImage imageNamed:@"navigationbarfil.png"];
    [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
}


- (void)viewDidLoad
{
    filterView = [[UIView alloc] initWithFrame:CGRectMake(0, -480, 320, 480)];
    [filterView  setBackgroundColor: [UIColor blackColor]];
    [filterView setAlpha:0.4f];
    filterView.tag = 1000;
    [self.view addSubview:filterView];
    searchBar.delegate =self;
    
    UIImage* image = [UIImage imageNamed:@"back.png"];
    CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
    backButton = [[UIButton alloc] initWithFrame:frame];
    [backButton setBackgroundImage:image forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlStateHighlighted];
    UIBarButtonItem* backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    [backButtonItem release];
    [backButton release];
    
    UIImage *backgroundImage = [UIImage imageNamed:@"navigationbarfil.png"];
    [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    
    UINavigationBar *bar = [self.navigationController navigationBar];
    labelSearch = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 320, 20)];
    labelSearch.textAlignment = UITextAlignmentCenter;
    labelSearch.textColor = [UIColor whiteColor];
    labelSearch.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
    labelSearch.backgroundColor = [UIColor clearColor];
    labelSearch.text = @"Search";
    [bar addSubview:labelSearch];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(filterButtonSelected:)];
    [bar addGestureRecognizer:tap];
    
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

- (void)filterButtonSelected:(id)sender 
{
    // whatever needs to happen when button is tapped    
    // Check for the availability of Internet
    [self performSelector:@selector(animateFilter) withObject:nil afterDelay:0.05]; 
    
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar1
{
    [searchBar resignFirstResponder];
    
    searchString = [[NSString alloc] init];
    
    searchString = searchBar.text;
    [self searchOption:searchString];
}

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
        
        
        if ([typeString isEqualToString:@"Startup"]) 
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
        else if ([typeString isEqualToString:@"User"]) 
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
        
        UIImage *image = [UIImage imageNamed:@"placeholder.png"];
        [searchDisplayInTableImage addObject:image];
                    
    }
    
    [tableSearch reloadData];
    [self startLoadingImagesConcurrently];
    
}

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
    for (int asyncCount = 0; asyncCount < [searchImageDisplay count] ; asyncCount++) {
        
        NSString *picLoad = [NSString stringWithFormat:@"%@",[searchImageDisplay objectAtIndex:asyncCount]];
        NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:picLoad]];
        UIImage* image = [UIImage imageWithData:imageData];
        if (image != nil) {
            
            [searchDisplayInTableImage replaceObjectAtIndex:asyncCount withObject:image];
            [self performSelectorOnMainThread:@selector(displayImage:) withObject:[NSNumber numberWithInt:asyncCount] waitUntilDone:NO]; 
        }
        [imageData release];
        
    }
    
}

-(void)displayImage:(NSNumber*)presentCount
{
    if([[tableSearch indexPathsForVisibleRows]count] > 0)
    {
        NSIndexPath *firstRowShown = [[tableSearch indexPathsForVisibleRows]objectAtIndex:0];
        NSIndexPath *lastRowShown = [[tableSearch indexPathsForVisibleRows]objectAtIndex:[[tableSearch indexPathsForVisibleRows]count]-1];
        NSInteger count = [presentCount integerValue];
        if((count > firstRowShown.row)&&(count < lastRowShown.row))
            [tableSearch reloadData];
    }
    else
    {
        [tableSearch reloadData]; 
    }
    
}


-(void) backAction:(id)sender
{
    labelSearch.hidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

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
        
        //[filtersContainer setUserInteractionEnabled:YES];
        [_view1 setFrame:CGRectMake(25, -250, 271, 51*3)];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2];
        
        [_view1 setFrame:CGRectMake(25, 0, 271, 51*3)];
        [filterView setFrame:CGRectMake(0, 0, 320, 400)];
        [_view1 setBackgroundColor:[UIColor blackColor]];
        [UIView commitAnimations];
        
    }
    
    else {
        
        
        //[filtersContainer setUserInteractionEnabled:YES];
        
        for (int index = 1; index<[_filterOptions count]+1; index++) {
            
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


-(void)getFilteredListSearch:(id)sender
{
    [searchNamesDisplay removeAllObjects];
    [searchIdDisplay removeAllObjects];
    [searchImageDisplay removeAllObjects];
    [searchtypeDisplay removeAllObjects];
    [searchUrlDisplay removeAllObjects];
 
    int _tagID = [sender tag];
    
    switch(_tagID)
    {
            //Implement Following
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
            [tableSearch reloadData];
            [self startLoadingImagesConcurrently];
            
            [self performSelector:@selector(animateFilter) withObject:nil afterDelay:0.05];
            break;
            
            //Implement Portfolio    
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
            [tableSearch reloadData];
            [self startLoadingImagesConcurrently];
            
            [self performSelector:@selector(animateFilter) withObject:nil afterDelay:0.05];
            break;
            
            //Implement Trending 
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
