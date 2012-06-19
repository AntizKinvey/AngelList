//
//  InboxDetailsViewController.m
//  Angellist
//
//  Created by Ram Charan on 15/06/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import "InboxDetailsViewController.h"
#import "InboxViewController.h"
#define kOFFSET_FOR_KEYBOARD 160.0


@implementation InboxDetailsViewController

extern int threadValue;
extern NSString *_currAccessToken;
BOOL stayup1, fromInboxDetails;
NSMutableArray *_msgUser;
NSMutableArray *_otherUser;

NSMutableArray *_messBody;
NSMutableArray *_sen_id;
NSMutableArray *_rec_id;
NSMutableArray *_time;
NSMutableArray *_displayTime;

NSMutableArray *displayImage;

@synthesize tableMsgDetails, textViewReply;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"Conversation";
    }
    return self;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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

    
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(90, 0, 210, 50)];
    name.text = [_msgUser objectAtIndex:indexPath.row]; 
    name.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
    [cell.contentView addSubview:name];
    name.backgroundColor = [UIColor clearColor];
    [name release];
    
    UILabel *msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 40, 210, 50)];
    msgLabel.text = [_messBody objectAtIndex:indexPath.row]; 
    msgLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
    [cell.contentView addSubview:msgLabel];
    msgLabel.backgroundColor = [UIColor clearColor];
    [msgLabel release];
    
    UILabel *msgLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(220, 70, 70, 30)];
    msgLabel1.text = [_displayTime objectAtIndex:indexPath.row]; 
    msgLabel1.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:8];
    [cell.contentView addSubview:msgLabel1];
    msgLabel1.backgroundColor = [UIColor clearColor];
    [msgLabel1 release];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(7, 12, 70, 70)];
    imageView.image = [displayImage objectAtIndex:indexPath.row];
    [cell.contentView addSubview:imageView];
    [imageView release];
    
    return cell;   
    
}

- (void)viewDidLoad
{
    [self getrequest];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


-(void)getrequest
{
    
    _messBody = [[NSMutableArray alloc] init];
    _sen_id = [[NSMutableArray alloc] init];
    _rec_id = [[NSMutableArray alloc] init];
    _time = [[NSMutableArray alloc] init];
    
    _msgUser = [[NSMutableArray alloc] init];
    _otherUser = [[NSMutableArray alloc] init];
    displayImage = [[NSMutableArray alloc] init];
    
    _displayTime = [[NSMutableArray alloc] init];
    
    UIImage* image = [UIImage imageNamed:@"back.png"];
    CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
    UIButton* backButton = [[UIButton alloc] initWithFrame:frame];
    [backButton setBackgroundImage:image forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlStateHighlighted];
    
    UIBarButtonItem* backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    [backButtonItem release];
    [backButton release];
    
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.angel.co/1/messages/%d?access_token=%@",threadValue,_currAccessToken]];
    
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
        
        [_messBody addObject:[diction valueForKey:@"body"]];
        [_sen_id addObject:[diction valueForKey:@"sender_id"]];
        [_rec_id addObject:[diction valueForKey:@"recipient_id"]];
        [_time addObject:[diction valueForKey:@"created_at"]];
        
        NSString *string1 = [NSString stringWithFormat:@"%@",[_sen_id objectAtIndex:user]];
        
        NSString *string2 = [NSString stringWithFormat:@"%@",[user1Diction valueForKey:@"id"]];
        
        if ([string1 isEqualToString:string2]) {
            [_msgUser addObject:[user1Diction valueForKey:@"name"]];
            [_otherUser addObject:[user1Diction valueForKey:@"image"]];
            
        }
        else {
           
            [_msgUser addObject:[user2Diction valueForKey:@"name"]];
            [_otherUser addObject:[user2Diction valueForKey:@"image"]];
        }
        
        [displayImage addObject:[UIImage imageNamed:@"placeholder.png"]];
       
        user++;
        
    }
    
    [self startLoadingImagesConcurrently];
    [self getTime];

    
}
-(void) backAction:(id)sender
{
    fromInboxDetails = TRUE;
    [self.navigationController popViewControllerAnimated:YES];
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
    for (int asyncCount = 0; asyncCount < [_otherUser count] ; asyncCount++) {
        
        NSString *picLoad = [NSString stringWithFormat:@"%@",[_otherUser objectAtIndex:asyncCount]];
        NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:picLoad]];
      
        
        UIImage* image = [UIImage imageWithData:imageData];
        
        if (image != nil) {
            
            [displayImage replaceObjectAtIndex:asyncCount withObject:image];
            [self performSelectorOnMainThread:@selector(displayImage:) withObject:[NSNumber numberWithInt:asyncCount] waitUntilDone:NO]; 
        }
        [imageData release];
    }
}

-(void)displayImage:(NSNumber*)presentCount
{
    if([[tableMsgDetails indexPathsForVisibleRows]count] > 0)
    {
        NSIndexPath *firstRowShown = [[tableMsgDetails indexPathsForVisibleRows]objectAtIndex:0];
        NSIndexPath *lastRowShown = [[tableMsgDetails indexPathsForVisibleRows]objectAtIndex:[[tableMsgDetails indexPathsForVisibleRows]count]-1];
        NSInteger count = [presentCount integerValue];
        if((count > firstRowShown.row)&&(count < lastRowShown.row))
            [tableMsgDetails reloadData];
    }
    else
        [tableMsgDetails reloadData]; 
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{ 

   // NSInteger integer = 2;
    return [_msgUser count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 100.0;
}


-(IBAction)returnkeyboard:(id)sender
{ 

    [textViewReply resignFirstResponder];
}


-(IBAction)postReply:(id)sender
{
    
    NSString *postMsg = [NSString stringWithFormat:@"%@",textViewReply.text];
    
   
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.angel.co/1/messages?thread_id=%d&body=%@&access_token=0923767ad7d007d4c519aa45a1129f73",threadValue,postMsg]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];

    [self getrequest];
    [textViewReply setPlaceholder:@"Type your message..."];
    [tableMsgDetails reloadData];
    

}

- (void)keyboardWillShow:(NSNotification *)notif{
    [self setViewMoveUp:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)sender {
    stayup1 = YES;
    
    if ([sender isEqual:textViewReply])
    {
        [self setViewMoveUp:YES];
        
    }

}

- (void)textFieldDidEndEditing:(UITextField *)sender {
    stayup1 = NO;
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
        if (stayup1 == NO) {
            rect.origin.y += kOFFSET_FOR_KEYBOARD;
           
        }
    }
    self.view.frame = rect; 
    [UIView commitAnimations];
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


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
