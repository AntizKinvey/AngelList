//
//  ViewController.m
//  TableProj
//
//  Created by Ram Charan on 8/21/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import "ViewController.h"
#import "LoginViewController.h"
#import "ContainerViewController.h"
#import "Reachability.h"
#import <QuartzCore/QuartzCore.h>

@implementation ViewController

BOOL loginFromAL = FALSE;
BOOL _loggedIn = FALSE;

LoginViewController *_loginViewController;
ContainerViewController *_containerViewController;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

//Button action to open login screen
-(IBAction) loginFromAngellist:(id) sender
{
    //Check for the availability of Internet
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
    {
        UIAlertView *myAlert = [[[UIAlertView alloc] initWithTitle:nil message:@"Internet appears offline!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease];
        [myAlert show];
    }
    else
    {
        loginFromAL = TRUE;
        //Open Login screen
        _loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController_iPhone" bundle:nil];
        [_loginViewController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        [self presentModalViewController:_loginViewController animated:YES];
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
    [super viewWillAppear:animated];
    
    if(_loggedIn == TRUE)
    {
        _containerViewController = [[[ContainerViewController alloc] initWithNibName:@"ContainerViewController_iPhone" bundle:nil] autorelease];
        
        _loggedIn = FALSE;
        
        [self.view removeFromSuperview];
        [self.view addSubview:_containerViewController.view];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
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
