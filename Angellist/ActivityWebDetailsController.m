//
//  ActivityWebDetailsVontroller.m
//  Angellist
//
//  Created by Ram Charan on 6/4/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import "ActivityWebDetailsController.h"
#import <QuartzCore/QuartzCore.h>

@implementation ActivityWebDetailsController

// array from feed details
extern NSMutableArray *actorNameArray;
extern NSMutableArray *actorUrlArray;

extern NSMutableArray *targetNameArray;
extern NSMutableArray *targetUrlArray;
extern int _rowNumberInActivity;

extern int _rowIndexPathNumber;

UIButton* backButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
       
        if (_rowIndexPathNumber == 0) {
            self.title = [actorNameArray objectAtIndex:_rowNumberInActivity];
            
        }
        else if(_rowIndexPathNumber == 2){
             self.title = [targetNameArray objectAtIndex:_rowNumberInActivity];
            
        }
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
    
    webView.delegate = self;
    webView.scrollView.bounces = NO;
    
    [loading.layer setCornerRadius:18.0f];
    
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
    NSURL *url;
    if (_rowIndexPathNumber == 0) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[actorUrlArray objectAtIndex:_rowNumberInActivity]]];
       
    }
    else if(_rowIndexPathNumber == 2){
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[targetUrlArray objectAtIndex:_rowNumberInActivity]]];
        
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    
   
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void) backAction:(id)sender
{
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


// To support orientations 
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
