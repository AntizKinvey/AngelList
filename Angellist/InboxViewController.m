//
//  InboxViewController.m
//  Angellist
//
//  Created by Ram Charan on 5/25/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import "InboxViewController.h"
#import "InboxDetailsViewController.h"
#import "Reachability.h"
#import <QuartzCore/QuartzCore.h>

@implementation InboxViewController

@synthesize tableview, loading;

extern NSString *_currAccessToken;

NSMutableArray *_senderName;
NSMutableArray *_recepientName;
NSMutableArray *_imageOfRecepient;
NSMutableArray *_imageOfSender;
NSMutableArray *_userids;
NSMutableArray *_sender;
NSMutableArray *_recepient;
NSMutableArray *_read;
NSMutableArray *_threadId;
NSMutableArray *_msgbody;
NSMutableArray *_placeHolder;
NSMutableArray *_time;
NSMutableArray *_displayTime;

extern BOOL fromInboxDetails;

NSString *threadIdString;

int threadValue = 0;

int countDownInbox = 0;
float alphaValueInInbox = 1.0;
NSTimer *timerInbox;
UIView *noInternetView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Inbox";
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
    
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
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
    label = [[UILabel alloc] initWithFrame:CGRectMake(90, 0, 210, 50)];
    label.text = [_senderName objectAtIndex:indexPath.row];
    label.backgroundColor = [UIColor clearColor];
    

    label.textColor = [UIColor colorWithRed:63.0/255.0 green:103.0/255.0 blue:160.0/255.0 alpha:1.0f];
        

    label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
    [cell.contentView addSubview:label];
    [label release];
    
    UILabel *msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(220, 70, 70, 30)];
    msgLabel.text = [_displayTime objectAtIndex:indexPath.row]; 
    msgLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:8];
    [cell.contentView addSubview:msgLabel];
    msgLabel.backgroundColor = [UIColor clearColor];
    [msgLabel release];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 40, 210, 30)];
    timeLabel.text = [_msgbody objectAtIndex:indexPath.row]; 
    timeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
    timeLabel.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:timeLabel];
    [timeLabel release];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(7, 12, 70, 70)];
    imageView.image = [_placeHolder objectAtIndex:indexPath.row];
    [cell.contentView addSubview:imageView];
    [imageView release];
    
    loading.hidden = YES;
    return cell;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{ 

    
    NSInteger integer = 2;
    return integer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 100.0;
}

- (void)viewWillAppear:(BOOL)animated
{
    
    NSIndexPath *selection = [tableview indexPathForSelectedRow];
    if (selection){
        [tableview deselectRowAtIndexPath:selection animated:YES];
    }
    
    if (fromInboxDetails == TRUE) {
        fromInboxDetails = FALSE;
        [self sendRequestToFetch];
        [tableview reloadData];
        [self startLoadingImagesConcurrently];
    }
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
   
//    [tableview reloadData];
    [super viewDidAppear:animated];
}

-(void) fadeView
{
    if(countDownInbox < 35)
    {
        countDownInbox++;
        noInternetView.alpha = alphaValueInInbox;
        alphaValueInInbox = alphaValueInInbox - 0.03;
    }
    else
    {
        [timerInbox invalidate];
    }
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    noInternetView = [[UIView alloc] initWithFrame:CGRectMake(100, 140, 118, 118)];
    noInternetView.alpha = 0;
    [noInternetView.layer setCornerRadius:10.0f];
    noInternetView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:noInternetView];
    
    UILabel *msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, 53, 106, 46)];
    msgLabel.text = @"No Internet Connection";
    msgLabel.textAlignment = UITextAlignmentCenter;
    msgLabel.numberOfLines = 2;
    msgLabel.backgroundColor = [UIColor clearColor];
    msgLabel.textColor = [UIColor whiteColor];
    msgLabel.font = [UIFont fontWithName:@"System" size:10.0];
    [noInternetView addSubview:msgLabel];
    
    UIImage *notReachableImage = [UIImage imageNamed:@"closebutton.png"];
    UIImageView *notReachView = [[UIImageView alloc] initWithFrame:CGRectMake(41, 20, 37, 37)];
    notReachView.image = notReachableImage;
    [noInternetView addSubview:notReachView];
    
    [msgLabel release];
    [notReachView release];
    [noInternetView release];
    
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) 
    {
        self.navigationController.navigationBar.frame = CGRectMake(0, 0, 320, 45);
    }
    else
    {
        self.navigationController.navigationBar.frame = CGRectMake(0, 0, 768, 45);
    }
    UIImage *backgroundImage = [UIImage imageNamed:@"navigationbar.png"];
    [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    
    self.tabBarItem.title = @"Inbox";

    loading.hidden = YES;
    UIImage* image = [UIImage imageNamed:@"back.png"];
    CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
    UIButton* backButton = [[[UIButton alloc] initWithFrame:frame] autorelease];
    [backButton setBackgroundImage:image forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlStateHighlighted];
    
    //Check for the availability of Internet
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
    {
        timerInbox = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(fadeView) userInfo:nil repeats:YES];
        alphaValueInInbox = 1.0;
        countDownInbox = 0;

        [super viewDidLoad];
    }
    else
    {
        [self sendRequestToFetch];
         [super viewDidLoad];
        // Do any additional setup after loading the view from its nib.
        // [self performSelector:@selector(loadImagesToTable) withObject:nil afterDelay:0.5];
        [self startLoadingImagesConcurrently];
    }
    
    
    
}

-(void)sendRequestToFetch
{
   
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.angel.co/1/messages?access_token=%@",_currAccessToken]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod: @"GET"];
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSError* error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:&error];
    
    NSArray *_messageThreads = [json valueForKey:@"messages"];
    _senderName = [[NSMutableArray alloc] init];
    _imageOfSender = [[NSMutableArray alloc] init];
    _imageOfRecepient = [[NSMutableArray alloc] init];
    _userids = [[NSMutableArray alloc] init];
    _sender = [[NSMutableArray alloc] init];
    _recepient = [[NSMutableArray alloc] init];
    _recepientName = [[NSMutableArray alloc] init];
    _read = [[NSMutableArray alloc] init];
    _threadId = [[NSMutableArray alloc] init];
    _msgbody = [[NSMutableArray alloc] init];
    _placeHolder = [[NSMutableArray alloc] init];
    _time = [[NSMutableArray alloc] init];
    _displayTime = [[NSMutableArray alloc] init];
    
    for (int _userCount=0; _userCount<[_messageThreads count] ; _userCount++) 
    {
        
        NSDictionary *diction = [_messageThreads objectAtIndex:_userCount];
        
        [_userids addObject:[[diction valueForKey:@"users"] valueForKey:@"id"]];
        [_sender addObject:[[diction valueForKey:@"last_message"] valueForKey:@"sender_id"]];
        [_recepient addObject:[[diction valueForKey:@"last_message"] valueForKey:@"recipient_id"]];
        [_read addObject:[diction valueForKey:@"viewed"]];
        [_threadId addObject:[diction valueForKey:@"thread_id"]];
        [_msgbody addObject:[[diction valueForKey:@"last_message"] valueForKey:@"body"]];
        [_time addObject:[[diction valueForKey:@"last_message"] valueForKey:@"created_at"]];
        
        NSDictionary *dictionary = [diction valueForKey:@"users"];
        NSString *string1 = [NSString stringWithFormat:@"%@",[_sender objectAtIndex:_userCount]];
        
        NSEnumerator *enumerator = [dictionary objectEnumerator];
        NSDictionary *key;
        
        while (key = [enumerator nextObject]) {
            
            NSString *string2 = [NSString stringWithFormat:@"%@",[key valueForKey:@"id"]];
            
            if ([string1 isEqual:string2]) 
            {
                
                [_senderName addObject:[key valueForKey:@"name"]];
                [_imageOfSender addObject:[key valueForKey:@"image"]];
               
                
            }
            else 
            {
                [_recepientName addObject:[key valueForKey:@"name"]];
                [_imageOfRecepient addObject:[key valueForKey:@"image"]];
            }
            
        }
        
        [_placeHolder addObject:[UIImage imageNamed:@"placeholder.png"]];
        
    }
    [self getTime];  
    
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
    for (int asyncCount = 0; asyncCount < [_imageOfSender count] ; asyncCount++) {
        
        NSString *picLoad = [NSString stringWithFormat:@"%@",[_imageOfSender objectAtIndex:asyncCount]];
        NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:picLoad]];
       
        
        UIImage* image = [UIImage imageWithData:imageData];
        
        if (image != nil) {
            
            [_placeHolder replaceObjectAtIndex:asyncCount withObject:image];
            [self performSelectorOnMainThread:@selector(displayImage:) withObject:[NSNumber numberWithInt:asyncCount] waitUntilDone:NO]; 
        }
        [imageData release];
    }
}

-(void)displayImage:(NSNumber*)presentCount
{
    if([[tableview indexPathsForVisibleRows]count] > 0)
    {
        NSIndexPath *firstRowShown = [[tableview indexPathsForVisibleRows]objectAtIndex:0];
        NSIndexPath *lastRowShown = [[tableview indexPathsForVisibleRows]objectAtIndex:[[tableview indexPathsForVisibleRows]count]-1];
        NSInteger count = [presentCount integerValue];
        if((count > firstRowShown.row)&&(count < lastRowShown.row))
            [tableview reloadData];
    }
    else
        [tableview reloadData]; 
    
}

-(void)getTime
{
    
    for (int time=0; time < [_time count]; time++) { 
        
        NSString *timeStamp = [NSString stringWithFormat:@"%@",[_time objectAtIndex:time]];
        
    NSDateFormatter *dateForm = [[NSDateFormatter alloc] init];
    [dateForm setDateFormat:@"YYYY-MM-dd'T'HH:mm:ss'Z'"];
    [dateForm setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    [dateForm setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [cal setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    [cal setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDate *date1 = [dateForm dateFromString:timeStamp];
    NSDate *date2 = [NSDate date];
    unsigned int unitFlags = NSDayCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit; 
    NSDateComponents *diffComps = [cal components:unitFlags fromDate:date2 toDate:date1 options:0];
        
        int year = ABS([diffComps year]);
        int month = ABS([diffComps month]);
        int day = ABS([diffComps day]);
        int hour = ABS([diffComps hour]);
        int minute = ABS([diffComps minute]);
        int seconds = ABS([diffComps second]);
        NSString *displayTime;
        
        if (year == 0) {
            
            if (month == 0) {
                
                if (day == 0) {
                    
                    if (hour == 0){

                        if (minute == 0) {
                            displayTime = [NSString stringWithFormat:@"about %d secs ago",seconds];     
                        }
                        else {
                            displayTime = [NSString stringWithFormat:@"about %d mins ago",minute];  
                        }
                    }
                    else {
                        displayTime = [NSString stringWithFormat:@"about %d hours ago",hour];  
                    }
                }
                else {
                        displayTime = [NSString stringWithFormat:@"about %d days ago",day]; 
                    }
            }
            else {
                    displayTime = [NSString stringWithFormat:@"about %d months ago",month];
            }
        }
        else {
             displayTime = [NSString stringWithFormat:@"about %d months ago",year];
        }

    [_displayTime addObject:displayTime];
    [cal release];

    }
    

  
}

-(void) backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    threadIdString = [[NSString alloc] init];
    
    InboxDetailsViewController *detailsViewController;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) 
    {
        detailsViewController = [[[InboxDetailsViewController alloc] initWithNibName:@"InboxDetailsViewController_IPhone" bundle:nil] autorelease];
    }
    else
    {
        detailsViewController = [[[InboxDetailsViewController alloc] initWithNibName:@"InboxDetailsViewController_IPad" bundle:nil] autorelease];
    }
    threadIdString = [NSString stringWithFormat:@"%@",[_threadId objectAtIndex:indexPath.row]];
    
    threadValue = [threadIdString intValue];
   
    
    [self.navigationController pushViewController:detailsViewController animated:YES];
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
