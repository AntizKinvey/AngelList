//
//  ContainerViewController.m
//  TableProj
//
//  Created by Ram Charan on 8/26/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import "ContainerViewController.h"
#import "Reachability.h"
#import "ActivityViewController.h"
#import "StartUpViewController.h"
#import "InboxViewController.h"
#import "UserProfileViewController.h"

#import "CustomTabBar.h"

@implementation ContainerViewController

@synthesize tabBarController = _tabBarController;

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
    UIViewController *viewController1, *viewController2, *viewController3, *viewController4;
    UINavigationController *navigationcontroller1,*navigationcontroller2,*navigationcontroller3,*navigationcontroller4;
    
    viewController1 = [[[ActivityViewController alloc] initWithNibName:@"ActivityViewController_iPhone" bundle:nil] autorelease];
    navigationcontroller1 = [[[UINavigationController alloc] initWithRootViewController:viewController1] autorelease];
    
    viewController2 = [[[StartUpViewController alloc] initWithNibName:@"StartUpViewController_iPhone" bundle:nil] autorelease];
    navigationcontroller2 = [[[UINavigationController alloc] initWithRootViewController:viewController2] autorelease];
    
    viewController3 = [[[InboxViewController alloc] initWithNibName:@"InboxViewController_iPhone" bundle:nil] autorelease];
    navigationcontroller3 = [[[UINavigationController alloc] initWithRootViewController:viewController3] autorelease];
    
    viewController4 = [[[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController_iPhone" bundle:nil] autorelease];
    navigationcontroller4 = [[[UINavigationController alloc] initWithRootViewController:viewController4] autorelease];
    
    self.tabBarController = [[[CustomTabBar alloc] init] autorelease];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:navigationcontroller1, navigationcontroller2, navigationcontroller3, navigationcontroller4, nil];
    [self.view addSubview:self.tabBarController.view];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
