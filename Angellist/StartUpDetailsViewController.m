//
//  StartUpDetailsViewController.m
//  Angellist
//
//  Created by Ram Charan on 6/4/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import "StartUpDetailsViewController.h"
#import "AsyncImageView.h"
#import "StartUpWebDetailsController.h"
#import "Reachability.h"

@implementation StartUpDetailsViewController

extern NSMutableArray *displayStartUpIdsArray;
extern NSMutableArray *displayStartUpNameArray;
extern NSMutableArray *displayStartUpAngelUrlArray;
extern NSMutableArray *displayStartUpLogoUrlArray;
extern NSMutableArray *displayStartUpProductDescArray;
extern NSMutableArray *displayStartUpHighConceptArray;
extern NSMutableArray *displayStartUpFollowerCountArray;
extern NSMutableArray *displayStartUpLocationArray;
extern NSMutableArray *displayStartUpMarketArray;
extern NSMutableArray *displayStartUpLogoImageInDirectory;

extern int _rowNumberInStartUps;
extern BOOL _filterFollow;
extern BOOL _filterPortfolio;
extern NSString *_currAccessToken;

extern NSMutableArray *userFollowingIds;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    UIImage* image = [UIImage imageNamed:@"back.png"];
    CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
    UIButton* backButton = [[UIButton alloc] initWithFrame:frame];
    [backButton setBackgroundImage:image forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlStateHighlighted];
    
    UIBarButtonItem* backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    [backButtonItem release];
    [backButton release];
    

    if((_filterFollow == TRUE) || (_filterPortfolio == TRUE))
    {
        UIImage *strtUpImage = [displayStartUpLogoUrlArray objectAtIndex:_rowNumberInStartUps];
        UIImageView *startUpImageView = [[UIImageView alloc] initWithFrame:startUpImage.frame];
        startUpImageView.image = strtUpImage;
        [self.view addSubview:startUpImageView];
        [startUpImageView release];
    }
    else
    {
        UIImage *strtUpImage = [UIImage imageWithContentsOfFile:[displayStartUpLogoImageInDirectory objectAtIndex:_rowNumberInStartUps]];
        UIImageView *startUpImageView = [[UIImageView alloc] initWithFrame:startUpImage.frame];
        startUpImageView.image = strtUpImage;
        [self.view addSubview:startUpImageView];
        [startUpImageView release];
    }
    
    
    startUpName.text = [displayStartUpNameArray objectAtIndex:_rowNumberInStartUps];
    startUpName.lineBreakMode = UILineBreakModeWordWrap;
    
    if([[displayStartUpMarketArray objectAtIndex:_rowNumberInStartUps] isEqualToString:@""])
    {
        startUpMarket.text = @"";
    }
    else
    {
        startUpMarket.text = [NSString stringWithFormat:@"Markets - %@",[displayStartUpMarketArray objectAtIndex:_rowNumberInStartUps]];
        startUpMarket.lineBreakMode = UILineBreakModeWordWrap;
    }
    
    if([[displayStartUpLocationArray objectAtIndex:_rowNumberInStartUps] isEqualToString:@""])
    {
        startUpLocation.text = @"";
    }
    else
    {
        startUpLocation.text = [NSString stringWithFormat:@"Locations - %@",[displayStartUpLocationArray objectAtIndex:_rowNumberInStartUps]];
        startUpLocation.lineBreakMode = UILineBreakModeWordWrap;
    }
    
    
    startUpFollowers.text = [NSString stringWithFormat:@"Followers %@",[displayStartUpFollowerCountArray objectAtIndex:_rowNumberInStartUps]];
    startUpFollowers.lineBreakMode = UILineBreakModeWordWrap;
    
    startUpDesc.text = [displayStartUpProductDescArray objectAtIndex:_rowNumberInStartUps];
    startUpDesc.editable = FALSE;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void) backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)startUpDetails:(id)sender
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
        StartUpWebDetailsController *webDetailsController;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) 
        {
            webDetailsController = [[[StartUpWebDetailsController alloc] initWithNibName:@"StartUpWebDetailsController_iPhone" bundle:nil] autorelease]; 
        }
        else
        {
            webDetailsController = [[[StartUpWebDetailsController alloc] initWithNibName:@"StartUpWebDetailsController_iPad" bundle:nil] autorelease]; 
        }
        
        [self.navigationController pushViewController:webDetailsController animated:YES];
    }
}

-(IBAction)followStartUp:(id)sender
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
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.angel.co/1/follows?id=%@&type=startup&access_token=%@",[displayStartUpIdsArray objectAtIndex:_rowNumberInStartUps],_currAccessToken]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod: @"POST"];
        
        [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        [userFollowingIds addObject:[displayStartUpIdsArray objectAtIndex:_rowNumberInStartUps]];
        followButton.hidden = YES;
        unfollowButton.hidden = NO;
    }
}

-(IBAction)unfollowStartUp:(id)sender
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
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.angel.co/1/follows?id=%@&type=startup&access_token=%@",[displayStartUpIdsArray objectAtIndex:_rowNumberInStartUps],_currAccessToken]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod: @"DELETE"];
        
        [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        [userFollowingIds removeObject:[displayStartUpIdsArray objectAtIndex:_rowNumberInStartUps]];
        followButton.hidden = NO;
        unfollowButton.hidden = YES;
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    if([userFollowingIds containsObject:[displayStartUpIdsArray objectAtIndex:_rowNumberInStartUps]])
    {
        unfollowButton.hidden = NO;
        followButton.hidden = YES;
    }
    else
    {
        followButton.hidden = NO;
        unfollowButton.hidden = YES;
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
