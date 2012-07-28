//
//  SearchDetailsViewController.m
//  Angellist
//
//  Created by Ram Charan on 25/07/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import "SearchDetailsViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation SearchDetailsViewController
extern NSMutableArray *searchUrlDisplay;
extern NSMutableArray *searchNamesDisplay;
extern int _rowSelected;


UIButton *backButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    webView.delegate = self;
    webView.scrollView.bounces = NO;
    
    [loading.layer setCornerRadius:18.0f];
   
    UIImage *backgroundImage = [UIImage imageNamed:@"navigationbarNf.png"];
    [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    
    // back button
    UIImage* image = [UIImage imageNamed:@"back.png"];
    CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
    backButton = [[UIButton alloc] initWithFrame:frame];
    [backButton setBackgroundImage:image forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlStateHighlighted];
    
    UIBarButtonItem* backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    [backButtonItem release];
    [backButton release];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    // load angellist URL
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[searchUrlDisplay objectAtIndex:_rowSelected]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    
    self.navigationItem.title = [searchNamesDisplay objectAtIndex:_rowSelected];

}

-(void) backAction:(id)sender
{
    labelSearchDetails.hidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [webView setDelegate:nil];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)webView:(UIWebView*)webView1 shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    
    webView.scalesPageToFit=YES;
    return YES;   
}


- (void)webViewDidStartLoad:(UIWebView *)webViewC
{
    loading.hidden = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webViewC
{
    [webView stopLoading];
    loading.hidden = YES;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
