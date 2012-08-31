//
//  LoginViewController.m
//  TableProj
//
//  Created by Ram Charan on 8/26/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import "LoginViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation LoginViewController

NSString *baseString;//Base URL
NSString *queryString;//Query string in URL
NSString *access_token;//Access token of Angellist user
BOOL access_token_received = FALSE;//Flag to be set when access token is received

extern BOOL loginFromAL;
extern BOOL _loggedIn;


NSString *_angelUserId;//Angellist User Id
NSString *_angelUserName;//Angellist User name
NSString *_angelUserImage;//Angellist User Image
NSString *_angelUserEmailId;//Angellist User email id
NSString *_angelUserFollows;//Angellist User followers



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
    
    _angelUserId = [NSString new];
    _angelUserName = [NSString new];
    _angelUserFollows = [NSString new];
    _angelUserEmailId = [NSString new];
    _angelUserImage = [NSString new];
    
    _dbmanager = [[DBManager alloc] init];
    [_dbmanager openDB];
    
    webView.delegate = self;
    webView.scrollView.bounces = NO;
    
    [loading.layer setCornerRadius:18.0f];
    
    
    if(loginFromAL)
    {
        //Send request to get authenticated user
        NSURL *url = [NSURL URLWithString:@"https://angel.co/api/oauth/authorize?client_id=f91c04a55243218eb588f329ae8bbbb9&scope=message%20email&response_type=code"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [webView loadRequest:request];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType 
{
    
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
    if(loginFromAL)
    {
        NSURLRequest *currentrequest = [webViewC request];
        NSURL *currentURL = [currentrequest URL];
        NSString *strFromURL = currentURL.absoluteString;
        
        //Get base string from Url
        baseString = [[strFromURL componentsSeparatedByString:@"="] objectAtIndex:0];
        
        if([strFromURL isEqualToString:@"http://antiztech.com/angellist/?error=access_denied&error_description=The+resource+owner+denied+your+request."])
        {
            [self closeAction];
        }
        
        if([baseString isEqualToString:@"http://antiztech.com/angellist/?code"])
        {
            //Get the query string which provides response code and link with the URL request and POST the URL
            queryString = [[strFromURL componentsSeparatedByString:@"="] objectAtIndex:1];
            NSString *urlString = [NSString stringWithFormat:@"https://angel.co/api/oauth/token?client_id=f91c04a55243218eb588f329ae8bbbb9&client_secret=80b56220b6fb722bcb8c85aa6f4996f3&code=%@&grant_type=authorization_code",queryString];
            NSURL *url = [NSURL URLWithString:urlString];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
            [request setHTTPMethod:@"POST"];
            [webView loadRequest:request];
            
            //Process json respons and get access token
            NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            NSError* error;
            NSDictionary* json = [NSJSONSerialization 
                                  JSONObjectWithData:response
                                  options:kNilOptions 
                                  error:&error];
            
            access_token = [json objectForKey:@"access_token"];
            
            access_token_received = TRUE;
        }
        
        if(access_token_received)
        {
            //Get details of User after getting access token
            NSString *urlString = [NSString stringWithFormat:@"https://api.angel.co/1/me?access_token=%@",access_token];
            NSURL *url = [NSURL URLWithString:urlString];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            [webView loadRequest:request]; 
            
            
            NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            //Process json respons and get user details
            NSError* error;
            NSDictionary* json = [NSJSONSerialization 
                                  JSONObjectWithData:response
                                  options:kNilOptions 
                                  error:&error];
            
            
            _angelUserId = [json objectForKey:@"id"];
            _angelUserName = [json objectForKey:@"name"];
            _angelUserFollows = [json objectForKey:@"follower_count"];
            _angelUserEmailId = [json objectForKey:@"email"];
            _angelUserImage = [json objectForKey:@"image"];
            
            NSString *fbUrl = [json objectForKey:@"facebook_url"];
            NSString *twUrl = [json objectForKey:@"twitter_url"];
            
            NSLog(@"\n \n id = %@ \n \n", _angelUserId);
            NSLog(@"\n \n id = %@ \n \n", _angelUserName);
            NSLog(@"\n \n id = %@ \n \n", _angelUserFollows);
            NSLog(@"\n \n id = %@ \n \n", _angelUserEmailId);
            NSLog(@"\n \n id = %@ \n \n", _angelUserImage);
            
            if((fbUrl == (NSString *)[NSNull null]) || [fbUrl isEqualToString:@""] )
            {
                fbUrl = @"NA";
            }
            if((twUrl == (NSString *)[NSNull null]) || [twUrl isEqualToString:@""] )
            {
                twUrl = @"NA";
            }
            NSLog(@"\nfacebook url = %@\ntwitter url = %@",fbUrl,twUrl);
            //Set the User collection attributes in Kinvey with user's access token, facebook url(if any), twitter url(if any)
//            [[[KCSClient sharedClient] currentUser] setValue:[NSString stringWithFormat:@"%@",fbUrl] forAttribute:@"facebookUrl"];
//            [[[KCSClient sharedClient] currentUser] setValue:[NSString stringWithFormat:@"%@",twUrl] forAttribute:@"twitterUrl"];
//            [[[KCSClient sharedClient] currentUser] setValue:[NSString stringWithFormat:@"%@",access_token] forAttribute:@"access_token"];
//            [[[KCSClient sharedClient] currentUser] saveWithDelegate:self];
            
            access_token_received = FALSE;
            _loggedIn = TRUE;
            [self saveImageOfUserAndDetailsToDb];
        }
    }
}

-(void) saveImageOfUserAndDetailsToDb
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];

    NSString *savedImagePathForUser = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"me.jpg"]];
    UIImage *imageForUser = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_angelUserImage]]]];
    NSData *imageDataForUser = UIImagePNGRepresentation(imageForUser);
    [imageDataForUser writeToFile:savedImagePathForUser atomically:NO];
    
    int _userId = 1;
    [_dbmanager insertRecordIntoUserTable:@"User" withField1:@"UID" field1Value:[NSString stringWithFormat:@"%d",_userId] andField2:@"username" field2Value:[NSString stringWithFormat:@"%@",_angelUserName] andField3:@"angelUserId" field3Value:[NSString stringWithFormat:@"%@",_angelUserId] andField4:@"access_token" field4Value:[NSString stringWithFormat:@"%@",access_token] andField5:@"email" field5Value:[NSString stringWithFormat:@"%@",_angelUserEmailId] andField6:@"image" field6Value:savedImagePathForUser andField7:@"follows" field7Value:[NSString stringWithFormat:@"%@",_angelUserFollows]];
    
    [self closeAction];
}



-(IBAction)dismissView:(id)sender
{
    [self closeAction];
}
//Close login Page
-(void) closeAction
{
    loginFromAL = FALSE;
    [webView stopLoading];
    [self dismissModalViewControllerAnimated:YES];
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
