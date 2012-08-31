//
//  ActivityWebDetailsController.m
//  TableProj
//
//  Created by Ram Charan on 8/25/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import "ActivityWebDetailsController.h"
#import <QuartzCore/QuartzCore.h>

@implementation ActivityWebDetailsController

extern int _rowNumberInDetails;
extern int _rowNumberInActivity;
extern NSMutableArray *actorNameArray;
extern NSMutableArray *actorLinkArray;
extern NSMutableArray *targetNameArray;
extern NSMutableArray *targetLinkArray;

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
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    webView.delegate = self;
    webView.scrollView.bounces = NO;
    [loading.layer setCornerRadius:18.0f];
    
    // back button
    UIImage* image = [UIImage imageNamed:@"back.png"];
    CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
    UIButton *backButton = [[UIButton alloc] initWithFrame:frame];
    [backButton setBackgroundImage:image forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlStateHighlighted];
    
    UIBarButtonItem* backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    [backButtonItem release];
    [backButton release];
    
    NSURL *url;
    if(_rowNumberInDetails == 0)
    {
        self.navigationItem.title = [NSString stringWithFormat:@"%@",[actorNameArray objectAtIndex:_rowNumberInActivity]];
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[actorLinkArray objectAtIndex:_rowNumberInActivity]]];
    }
    else
    {
        self.navigationItem.title = [NSString stringWithFormat:@"%@",[targetNameArray objectAtIndex:_rowNumberInActivity]];
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[targetLinkArray objectAtIndex:_rowNumberInActivity]]];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}

-(void) backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [webView setDelegate:nil];
    [super viewWillDisappear:YES];
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
