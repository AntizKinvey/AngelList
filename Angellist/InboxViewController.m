//
//  InboxViewController.m
//  TableProj
//
//  Created by Ram Charan on 8/28/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import "InboxViewController.h"

#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"
#import "SearchViewController.h"
#import "InboxDetailsViewController.h"

@implementation InboxViewController

extern NSMutableArray *userDetailsArray;

//////////////////////////////////
NSMutableArray *_senderName; // sender name
NSMutableArray *_recepientName; // recepient name
NSMutableArray *_imageOfRecepient; // image of recepient 
NSMutableArray *_imageOfSender; // image of sender
NSMutableArray *_userids; // user ids
NSMutableArray *_sender; // sender ids
NSMutableArray *_recepient; // recepient ids
NSMutableArray *_read; // viewed status
NSMutableArray *_threadId; // thread id
NSMutableArray *_msgbody; // message body
NSMutableArray *_placeHolder; // place holder images
NSMutableArray *_time; // time got from response
NSMutableArray *_displayTime; // display time
NSMutableArray *_totalMsgCount; // total message count
//////////////////////////////////

UILabel *navigationBarLabelInInbox;
int threadValue = 0;

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
    
    // image view to display image of the sender
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(7, 12, 50, 50)];
    imageView.image = [_placeHolder objectAtIndex:indexPath.row];
    imageView.layer.cornerRadius = 3.5f;
    imageView.layer.masksToBounds = YES;
    [cell.contentView addSubview:imageView];
    [imageView release];
    
    // label to display sender name
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 210, 40)];
    nameLabel.text = [_senderName objectAtIndex:indexPath.row];
    nameLabel.backgroundColor = [UIColor clearColor];
    NSString *strStatus = [NSString stringWithFormat:@"%@",[_dbmanager.inboxViewedArrayFromDB objectAtIndex:indexPath.row]];
    
    if ([strStatus isEqual:@"0"]) 
    {
        nameLabel.textColor = [UIColor colorWithRed:63.0/255.0 green:103.0/255.0 blue:160.0/255.0 alpha:1.0f];
    }
    else 
    {
        nameLabel.textColor = [UIColor grayColor];
    }
    nameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
    [cell.contentView addSubview:nameLabel];
    [nameLabel release];
    
    UIImageView *imageViewDot = [[UIImageView alloc] initWithFrame:CGRectMake(260, 5, 20, 20)];
    imageViewDot.image = [UIImage imageNamed:@"dot.png"];
    [cell.contentView addSubview:imageViewDot];
    [imageViewDot release];
    
    UILabel *msgCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(260, 5, 20, 20)];
    msgCountLabel.text = [NSString stringWithFormat:@"%@",[_totalMsgCount objectAtIndex:indexPath.row]]; 
    msgCountLabel.textAlignment = UITextAlignmentCenter;
    msgCountLabel.textColor = [UIColor whiteColor];
    msgCountLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:10];
    [cell.contentView addSubview:msgCountLabel];
    msgCountLabel.backgroundColor = [UIColor clearColor];
    [msgCountLabel release];
    
    // label to display message  
    NSString *msgText = [_msgbody objectAtIndex:[indexPath row]];
    CGSize constrainedSize = CGSizeMake(310, 200);
    CGSize size = [msgText sizeWithFont:[UIFont fontWithName:@"Helvetica-Light" size:14] constrainedToSize:constrainedSize lineBreakMode:UILineBreakModeWordWrap];
    
    UILabel *msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 40, 210, size.height)];
    msgLabel.text = msgText; 
    msgLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    msgLabel.lineBreakMode = UILineBreakModeWordWrap;
    msgLabel.numberOfLines = 0;
    msgLabel.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:msgLabel];
    [msgLabel release];
    
    // label to display time
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(210, MAX(msgLabel.frame.size.height+35, 80), 90, 30)];
    timeLabel.text = [_displayTime objectAtIndex:indexPath.row];
    timeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:9];
    [cell.contentView addSubview:timeLabel];
    timeLabel.backgroundColor = [UIColor clearColor];
    [timeLabel release];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{ 
    return [_dbmanager.inboxThreadIdArrayFromDB count];
}

// for dynamic cell height according to the text
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *text = [_msgbody objectAtIndex:indexPath.row];
    CGSize constraint = CGSizeMake(310, 200.0f);
    CGSize size = [text sizeWithFont:[UIFont fontWithName:@"Helvetica-Light" size:14] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    CGFloat height = MAX(size.height, 44.0f);
    return height + (30 * 2);
}

// TableView delegate method to navigate to the details of a message and display the conversation in that particular thread
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Internet appears offline!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else
    {
        //NSString *threadIdString = [[NSString alloc] init];
        NSString *threadIdString = [NSString stringWithFormat:@"%@",[_threadId objectAtIndex:indexPath.row]];
        
        NSString *readState = [NSString stringWithFormat:@"%@", [_dbmanager.inboxViewedArrayFromDB objectAtIndex:indexPath.row]];
        
        
        if ([readState isEqual:@"0"]) {
            [_dbmanager updateStatusIntoInboxTable:@"Inbox" withField1:@"viewed" field1Value:@"1" andField2:@"threadId" field2Value:threadIdString];
        }
        
        threadValue = [threadIdString intValue];
        
        InboxDetailsViewController *detailsViewController = [[[InboxDetailsViewController alloc] initWithNibName:@"InboxDetailsViewController_iPhone" bundle:nil] autorelease];
        
        [self.navigationController pushViewController:detailsViewController animated:YES];
    }
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
    _dbmanager = [[DBManager alloc] init];
    [_dbmanager openDB];
    
//    _dbmanager.inboxThreadIdArrayFromDB = [NSMutableArray new];
//    _dbmanager.inboxTotalArrayFromDB = [NSMutableArray new];
//    _dbmanager.inboxViewedArrayFromDB = [NSMutableArray new];
    
    _dbmanager.inboxThreadIdArrayFromDB = [[NSMutableArray new] autorelease];
    _dbmanager.inboxTotalArrayFromDB = [[NSMutableArray new] autorelease];
    _dbmanager.inboxViewedArrayFromDB = [[NSMutableArray new] autorelease];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //Navigation Bar Label
    navigationBarLabelInInbox = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 260, 20)];
    navigationBarLabelInInbox.textAlignment = UITextAlignmentCenter;
    navigationBarLabelInInbox.textColor = [UIColor whiteColor];
    navigationBarLabelInInbox.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
    navigationBarLabelInInbox.backgroundColor = [UIColor clearColor];
    navigationBarLabelInInbox.text = @"Inbox";
    [self.navigationController.navigationBar addSubview:navigationBarLabelInInbox];
    [navigationBarLabelInInbox release];
    
    //Search Button
    UIButton *buttonSearch = [[UIButton alloc] init];
    buttonSearch.frame = CGRectMake(0, 0, 52, 45);
    [buttonSearch setImage:[UIImage imageNamed:@"search.png"] forState:UIControlStateNormal];
    [buttonSearch addTarget:self action:@selector(goToSearch) forControlEvents:UIControlStateHighlighted];
    buttonSearch.enabled = YES;
    
    UIBarButtonItem *barButtonSearch = [[UIBarButtonItem alloc] initWithCustomView:buttonSearch];
    self.navigationItem.rightBarButtonItem = barButtonSearch;
    [barButtonSearch release];
    [buttonSearch release];
    
//    [self loadInboxMessages];
}

-(void) loadInboxMessages
{
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Internet appears offline!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else
    {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.angel.co/1/messages?access_token=%@",[userDetailsArray objectAtIndex:2]]]; //0923767ad7d007d4c519aa45a1129f73 //4e9e60844d74902da90466a9b08a4d1c
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod: @"GET"];
        
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        
        NSError* error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:&error];
        NSArray *_messageThreads = [json valueForKey:@"messages"];
        
        if ([_messageThreads count] == 0) {
            UILabel *labelError = [[UILabel alloc] initWithFrame:CGRectMake(60, 150, 200, 30)];
            labelError.text = @"No messages to display!";
            labelError.textColor = [UIColor grayColor];
            labelError.textAlignment = UITextAlignmentCenter;
            [labelError setBackgroundColor:[UIColor clearColor]];
            [self.view addSubview:labelError];
            [labelError release];
        }
        else 
        {
            
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
            _totalMsgCount = [[NSMutableArray alloc] init];
            
            for (int _userCount=0; _userCount<[_messageThreads count] ; _userCount++) 
            {
                NSDictionary *diction = [_messageThreads objectAtIndex:_userCount];
                
                [_userids addObject:[[diction valueForKey:@"users"] valueForKey:@"id"]];
                [_sender addObject:[[diction valueForKey:@"last_message"] valueForKey:@"sender_id"]];
                [_recepient addObject:[[diction valueForKey:@"last_message"] valueForKey:@"recipient_id"]];
                [_read addObject:[NSNumber numberWithBool:[[diction valueForKey:@"viewed"]boolValue]]];
                [_totalMsgCount addObject:[diction valueForKey:@"total"]];
                for (int _userCount1=0; _userCount1<[_messageThreads count] ; _userCount1++) 
                {
                    NSDictionary *diction = [_messageThreads objectAtIndex:_userCount1];
                    [_threadId addObject:[diction valueForKey:@"thread_id"]];
                }
                [_msgbody addObject:[[diction valueForKey:@"last_message"] valueForKey:@"body"]];
                [_time addObject:[[diction valueForKey:@"last_message"] valueForKey:@"created_at"]];
                
                [self readUnread:_userCount];
                if(_userCount == [_messageThreads count]-1)
                {
                    [self readUnread:_userCount];
                }
                
                
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
            [self loadImages];
            [self getTime]; 
        }
    }
    loadingView.hidden = YES;
}

//Image caching
-(void) loadImages
{
    /* Operation Queue init (autorelease) */
    NSOperationQueue *queue = [NSOperationQueue new];
    
    /* Create our NSInvocationOperation to call loadDataWithOperation, passing in nil */
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self
                                                                            selector:@selector(loadDataWithOperation)
                                                                              object:nil];
    
    /* Add the operation to the queue */
    [queue addOperation:operation];
    [operation release];
    [queue release];
}

-(void) loadDataWithOperation
{
    for(int z=0; z < [_imageOfSender count]; z++)
    {
        if([[_placeHolder objectAtIndex:z] isEqual:[UIImage imageNamed:@"placeholder.png"]])
        {
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[_imageOfSender objectAtIndex:z]]]];
            [_placeHolder replaceObjectAtIndex:z withObject:image];
            //[table reloadData];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:z inSection: 0];
            UITableViewCell *cell = [table cellForRowAtIndexPath:indexPath];
            UIImageView *cellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(7, 12, 50, 50)];
            cellImageView.image = [_placeHolder objectAtIndex:indexPath.row];
            [cell.contentView addSubview:cellImageView];
            [cellImageView release];
        }
    }
}

// Function to display the status of the message.
-(void)readUnread:(int)msgCount
{
    [_dbmanager retrieveInboxDetails];
    
    if ([_dbmanager.inboxThreadIdArrayFromDB count] != 0) {
        
        if ([_dbmanager.inboxThreadIdArrayFromDB count] !=[_threadId count]) {  // checks whether the thread ids are same in both db and the retrieved data
            
            
            NSString *str1 = [NSString stringWithFormat:@"%@", [_threadId objectAtIndex:msgCount]];
            NSString *str2 = [NSString stringWithFormat:@"%@", [_totalMsgCount objectAtIndex:msgCount]];
            NSString *str3 = [NSString stringWithFormat:@"%@", [_read objectAtIndex:msgCount]];
            
            [_dbmanager insertRecordIntoInbox:[NSString stringWithFormat:@"Inbox"] withField1:[NSString stringWithFormat:@"threadId"] field1Value:str1 andField2:[NSString stringWithFormat:@"total"] field2Value:str2 andField3:[NSString stringWithFormat:@"viewed"] field3Value:str3];
            
            
        }
        else if (![[NSString stringWithFormat:@"%@",[_totalMsgCount objectAtIndex:msgCount]] isEqual:[NSString stringWithFormat:@"%@",[_dbmanager.inboxTotalArrayFromDB objectAtIndex:msgCount]]]) {
            
            NSString *str2 = [NSString stringWithFormat:@"%@", [_totalMsgCount objectAtIndex:msgCount]];
            NSString *str3 = [NSString stringWithFormat:@"%@", [_threadId objectAtIndex:msgCount]];
            NSString *str4 = [NSString stringWithFormat:@"%@", [_read objectAtIndex:msgCount]];
            [_dbmanager updateRecordIntoInboxTable:[NSString stringWithFormat:@"Inbox"] withField1:[NSString stringWithFormat:@"threadId"] field1Value:str3 andField2:[NSString stringWithFormat:@"total"] field2Value:str2 andField3:[NSString stringWithFormat:@"viewed"] field3Value:str4];
        }
        
    }
    else {
        
        NSString *str1 = [NSString stringWithFormat:@"%@", [_threadId objectAtIndex:msgCount]];
        NSString *str2 = [NSString stringWithFormat:@"%@", [_totalMsgCount objectAtIndex:msgCount]];
        NSString *str3 = [NSString stringWithFormat:@"%@", [_read objectAtIndex:msgCount]];
        
        [_dbmanager insertRecordIntoInbox:[NSString stringWithFormat:@"Inbox"] withField1:[NSString stringWithFormat:@"threadId"] field1Value:str1 andField2:[NSString stringWithFormat:@"total"] field2Value:str2 andField3:[NSString stringWithFormat:@"viewed"] field3Value:str3];
    }
}

// To display time on screen
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
        
        // gets the difference between the current date and also the date and time in the timestamp of the data
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
        [dateForm release];
    }
}

-(void)goToSearch
{
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Internet appears offline!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];        
    }
    else
    {
        SearchViewController *_searchViewController = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
        [_searchViewController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        [self.navigationController pushViewController:_searchViewController animated:YES];
        [_searchViewController release];
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    UIImage *backgroundImage = [UIImage imageNamed:@"navigationbarNf.png"];
    [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    
    NSIndexPath *selection = [table indexPathForSelectedRow];
    if (selection)
    {
        [table deselectRowAtIndexPath:selection animated:YES];
    }
    [super viewWillAppear:YES];
    
    loadingView.hidden = NO;
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(invokeLoadInboxMessages) userInfo:nil repeats:NO];
}

-(void) invokeLoadInboxMessages
{
    [self loadInboxMessages];
    [table reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    navigationBarLabelInInbox.hidden = YES;
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    navigationBarLabelInInbox.hidden = NO;
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
