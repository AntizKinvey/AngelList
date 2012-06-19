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

@implementation ActivityDetailsViewController

extern NSMutableArray *actorTypeArray;
extern NSMutableArray *actorIdArray;
extern NSMutableArray *actorNameArray;
extern NSMutableArray *actorUrlArray;
extern NSMutableArray *actorTaglineArray;
extern NSMutableArray *feedImageArray;

extern NSMutableArray *feedImagesArrayFromDirectory;

extern NSMutableArray *userFollowingIds;

extern int _rowNumberInActivity;
extern NSString *_currAccessToken;

UIButton* backButton;

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
    backButton = [[UIButton alloc] initWithFrame:frame];
    [backButton setBackgroundImage:image forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlStateHighlighted];
    
    UIBarButtonItem* backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    [backButtonItem release];
    [backButton release];
    
    
    UIImage *feedImage = [UIImage imageWithContentsOfFile:[feedImagesArrayFromDirectory objectAtIndex:_rowNumberInActivity]];
    UIImageView *feedImageView = [[UIImageView alloc] initWithFrame:actorImage.frame];
    feedImageView.image = feedImage;
    [self.view addSubview:feedImageView];
    [feedImageView release];
    
    actorName.text = [actorNameArray objectAtIndex:_rowNumberInActivity];
    actorName.lineBreakMode = UILineBreakModeWordWrap;
    actorName.numberOfLines = 3;
    
    actorDesc.text = [actorTaglineArray objectAtIndex:_rowNumberInActivity];
    actorDesc.editable = FALSE;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void) backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)actorDetails:(id)sender
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

-(IBAction)followActor:(id)sender
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
    }
    
}

-(IBAction)unfollowActor:(id)sender
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
    }
    
}

-(void) viewWillAppear:(BOOL)animated
{
    if([userFollowingIds containsObject:[actorIdArray objectAtIndex:_rowNumberInActivity]])
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
