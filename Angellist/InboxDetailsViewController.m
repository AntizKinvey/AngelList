//
//  InboxDetailsViewController.m
//  TableProj
//
//  Created by Ram Charan on 8/28/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import "InboxDetailsViewController.h"

#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"

#define kOFFSET_FOR_KEYBOARD 160.0
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f

@implementation InboxDetailsViewController

extern NSMutableArray *userDetailsArray;
extern int threadValue;

NSMutableArray *_messageBody;
NSMutableArray *_senderId;
NSMutableArray *_recipientId;
NSMutableArray *_time;
NSMutableArray *_firstUser;
NSMutableArray *_secondUser;
NSMutableArray *displayImage;
NSMutableArray *_displayTimeDetails;

BOOL stayUp = NO;

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
    
    // image view to display images
    UIImageView *cellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(7, 12, 50, 50)];
    cellImageView.image = [displayImage objectAtIndex:indexPath.row];
    [cell.contentView addSubview:cellImageView];
    [cellImageView release];
    
    // label to display names
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 0, 210, 40)];
    nameLabel.text = [_firstUser objectAtIndex:indexPath.row]; 
    nameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
    nameLabel.lineBreakMode = UILineBreakModeWordWrap;
    nameLabel.numberOfLines = 0;
    [cell.contentView addSubview:nameLabel];
    nameLabel.backgroundColor = [UIColor clearColor];
    [nameLabel release];
    
    // label to display messages
    NSString *text = [_messageBody objectAtIndex:[indexPath row]];
    CGSize constrainedSize = CGSizeMake(310, 20000.0f);
    CGSize size = [text sizeWithFont:[UIFont fontWithName:@"Helvetica-Light" size:14] constrainedToSize:constrainedSize lineBreakMode:UILineBreakModeWordWrap];
    
    UILabel *msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 40, 210, size.height)];
    msgLabel.text = text; 
    msgLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    msgLabel.lineBreakMode = UILineBreakModeWordWrap;
    msgLabel.numberOfLines = 0;
    [cell.contentView addSubview:msgLabel];
    msgLabel.backgroundColor = [UIColor clearColor];
    [msgLabel release];
    
    // label to display time
    UILabel *msgTime = [[UILabel alloc] initWithFrame:CGRectMake(220, msgLabel.frame.size.height+30, 210, 35)];
    msgTime.text = [_displayTimeDetails objectAtIndex:indexPath.row]; 
    msgTime.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:9];
    msgTime.lineBreakMode = UILineBreakModeWordWrap;
    msgTime.numberOfLines = 0;
    [cell.contentView addSubview:msgTime];
    msgTime.backgroundColor = [UIColor clearColor];
    [msgTime release];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{ 
    return [_firstUser count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *text = [_messageBody objectAtIndex:[indexPath row]];
    CGSize constraint = CGSizeMake(310, 20000.0f);
    CGSize size = [text sizeWithFont:[UIFont fontWithName:@"Helvetica-Light" size:14] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    CGFloat height = size.height;
    
    return height + (40 * 2);
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    _messageBody = [[NSMutableArray alloc] init];
    _senderId = [[NSMutableArray alloc] init];
    _recipientId = [[NSMutableArray alloc] init];
    _time = [[NSMutableArray alloc] init];
    _firstUser = [[NSMutableArray alloc] init];
    _secondUser = [[NSMutableArray alloc] init];
    displayImage = [[NSMutableArray alloc] init];
    _displayTimeDetails = [[NSMutableArray alloc] init];
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    UIImage *backgroundImage = [UIImage imageNamed:@"navigationbarNf.png"];
    [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    
    UIImage* image = [UIImage imageNamed:@"back.png"];
    CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
    UIButton* backButton = [[UIButton alloc] initWithFrame:frame];
    [backButton setBackgroundImage:image forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlStateHighlighted];
    
    UIBarButtonItem* backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    [backButtonItem release];
    [backButton release];
    
    self.navigationItem.title = [NSString stringWithFormat:@"Conversation"];
    
    textViewReply.layer.cornerRadius = 10.0f;
    textViewReply.layer.borderColor = [UIColor grayColor].CGColor;
    textViewReply.layer.borderWidth = 1.0f;
    
    loadingView.hidden = NO;
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(invokeGetConversations) userInfo:nil repeats:NO];
}

-(void) invokeGetConversations
{
    [self getConversations];
    [table reloadData];
}

-(void) getConversations
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
        [_messageBody removeAllObjects];
        [_senderId removeAllObjects];
        [_recipientId removeAllObjects];
        [_time removeAllObjects];
        [_firstUser removeAllObjects];
        [_secondUser removeAllObjects];
        [displayImage removeAllObjects];
        [_displayTimeDetails removeAllObjects];
        
        // URL request
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.angel.co/1/messages/%d?access_token=%@",threadValue,[userDetailsArray objectAtIndex:2]]];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"GET"];
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSError* error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:&error];
        NSArray *arrayMessages = [json valueForKey:@"messages"];
        NSArray *arrayUser = [json valueForKey:@"users"];
        int user = 0;
        
        for (int msg = [arrayMessages count] ; msg >= 1 ; msg--) 
        {
            NSDictionary *diction = [arrayMessages objectAtIndex:msg-1];
            NSDictionary *user1Diction = [arrayUser objectAtIndex:0];
            NSDictionary *user2Diction = [arrayUser objectAtIndex:1];
            
            [_messageBody addObject:[diction valueForKey:@"body"]];
            [_senderId addObject:[diction valueForKey:@"sender_id"]];
            [_recipientId addObject:[diction valueForKey:@"recipient_id"]];
            [_time addObject:[diction valueForKey:@"created_at"]];
            
            NSString *string1 = [NSString stringWithFormat:@"%@",[_senderId objectAtIndex:user]];
            
            NSString *string2 = [NSString stringWithFormat:@"%@",[user1Diction valueForKey:@"id"]];
            
            if ([string1 isEqualToString:string2]) {
                [_firstUser addObject:[user1Diction valueForKey:@"name"]];
                [_secondUser addObject:[user1Diction valueForKey:@"image"]];
                
            }
            else {
                
                [_firstUser addObject:[user2Diction valueForKey:@"name"]];
                [_secondUser addObject:[user2Diction valueForKey:@"image"]];
            }
            
            [displayImage addObject:[UIImage imageNamed:@"placeholder.png"]];
            
            user++;
            
        }
        [self loadImages];
        [self getTime];
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
    for(int z=0; z < [_secondUser count]; z++)
    {
        if([[displayImage objectAtIndex:z] isEqual:[UIImage imageNamed:@"placeholder.png"]])
        {
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[_secondUser objectAtIndex:z]]]];
            [displayImage replaceObjectAtIndex:z withObject:image];
            
//            NSArray *array = [[NSArray alloc] initWithObjects:indexPath, nil];
//            [table reloadRowsAtIndexPaths: array withRowAnimation: UITableViewRowAnimationNone];
//            [array release];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:z inSection: 0];
            UITableViewCell *cell = [table cellForRowAtIndexPath:indexPath];
            UIImageView *cellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(7, 12, 50, 50)];
            cellImageView.image = [displayImage objectAtIndex:indexPath.row];
            [cell.contentView addSubview:cellImageView];
            [cellImageView release];
        }
    }
}

// display time
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
        [_displayTimeDetails addObject:displayTime];
        [cal release];
        [dateForm release];
    }
}


// post a reply from the user
-(IBAction)postReply:(id)sender
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
        NSString *postMsg = [NSString stringWithFormat:@"%@",textViewReply.text];
        NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"https://api.angel.co/1/messages?thread_id=%d&body=%@&access_token=%@",threadValue,postMsg,[userDetailsArray objectAtIndex:2]]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        [self getConversations];
        
        // reload table
        [table reloadData];
        textViewReply.text =@"";
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


////////////////////
//  methods move the view up while replying through the text view // 
- (void)keyboardWillShow:(NSNotification *)notif{
    [self setViewMoveUp:YES];
}
// return keyboard on 'Done' button
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextField *)sender {
    stayUp = YES;
    
    if ([sender isEqual:textViewReply])
    {
        [self setViewMoveUp:YES];
    }
}

- (void)textViewDidEndEditing:(UITextField *)sender {
    stayUp = NO;
    if ([sender isEqual:textViewReply])
    {
        [self setViewMoveUp:NO];
    }
}


-(void)setViewMoveUp:(BOOL)moveUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    CGRect rect = self.view.frame;
    if (moveUp)
    {
        if (rect.origin.y == 0 ) {
            rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        }
    }
    else
    {
        if (stayUp == NO) {
            rect.origin.y += kOFFSET_FOR_KEYBOARD;
        }
    }
    self.view.frame = rect; 
    [UIView commitAnimations];
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
