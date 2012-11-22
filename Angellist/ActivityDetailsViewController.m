//
//  ActivityDetailsViewController.m
//  TableProj
//
//  Created by Ram Charan on 8/24/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import "ActivityDetailsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ActivityWebDetailsController.h"
#import "Reachability.h"
#import "KCSUserActivity.h"
#import "KCSLogin.h"
#import "AppDelegate.h"


@implementation ActivityDetailsViewController

NSMutableArray *displayDetailsOfFeedsArray;

int _rowNumberInDetails = 0;

extern NSMutableArray *feedItemTypeArray;

extern NSMutableArray *actorNameArray;
extern NSMutableArray *actorLinkArray;
extern NSMutableArray *actorTaglineArray;
extern NSMutableArray *feedActorImageDisplayArray;

extern NSMutableArray *targetNameArray;
extern NSMutableArray *targetLinkArray;
extern NSMutableArray *targetTaglineArray;
extern NSMutableArray *feedTargetImageDisplayArray;

extern int _rowNumberInActivity;

KCSCollection *_detailsCollection;
extern NSString *_globalSessionId;

int _number_of_times_AD = 10;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Details";
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
    
    if(indexPath.row == 0)
    {
        UIImageView *cellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 100, 100)];
        cellImageView.image = [displayDetailsOfFeedsArray objectAtIndex:0];
        cellImageView.layer.cornerRadius = 3.5f;
        cellImageView.layer.masksToBounds = YES;
        [cell.contentView addSubview:cellImageView];
        [cellImageView release];
        
        UILabel *actorNamelabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 125, 300, 30)];
        actorNamelabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
        actorNamelabel.lineBreakMode = UILineBreakModeWordWrap;
        actorNamelabel.backgroundColor = [UIColor clearColor];
        actorNamelabel.text = [displayDetailsOfFeedsArray objectAtIndex:1];
        actorNamelabel.textColor = [UIColor colorWithRed:63.0/255.0 green:103.0/255.0 blue:160.0/255.0 alpha:1.0f];
        [cell.contentView addSubview:actorNamelabel];
        [actorNamelabel release];
        
        // label to display description
        NSString *text = [displayDetailsOfFeedsArray objectAtIndex:2];
        CGSize constraint = CGSizeMake(270, 20000.0f);
        CGSize size = [text sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:14] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        
        UILabel *actorDesclabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 160, 270, size.height)];
        actorDesclabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
        actorDesclabel.numberOfLines = 10;
        actorDesclabel.backgroundColor = [UIColor clearColor];
        actorDesclabel.lineBreakMode = UILineBreakModeWordWrap;
        actorDesclabel.text = text;
        [cell.contentView addSubview:actorDesclabel];
        [actorDesclabel release];
    }
    
    if(indexPath.row == 1)
    {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *feedTypelabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 300, 30)];
        feedTypelabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
        feedTypelabel.lineBreakMode = UILineBreakModeWordWrap;
        feedTypelabel.backgroundColor = [UIColor clearColor];
        feedTypelabel.textAlignment = UITextAlignmentCenter;
        feedTypelabel.text = [displayDetailsOfFeedsArray objectAtIndex:3];
        feedTypelabel.textColor = [UIColor colorWithRed:63.0/255.0 green:103.0/255.0 blue:160.0/255.0 alpha:1.0f];
        [cell.contentView addSubview:feedTypelabel];
        [feedTypelabel release]; 
    }
    
    if(indexPath.row == 2)
    {
        UIImageView *cellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 100, 100)];
        cellImageView.image = [displayDetailsOfFeedsArray objectAtIndex:4];
        cellImageView.layer.cornerRadius = 3.5f;
        cellImageView.layer.masksToBounds = YES;
        [cell.contentView addSubview:cellImageView];
        [cellImageView release];
        
        // label to display name of the user/startup
        UILabel *targetNamelabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 125, 300, 30)];
        targetNamelabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
        targetNamelabel.lineBreakMode = UILineBreakModeWordWrap;
        targetNamelabel.backgroundColor = [UIColor clearColor];
        targetNamelabel.text = [NSString stringWithFormat:@"%@",[displayDetailsOfFeedsArray objectAtIndex:5]];
        targetNamelabel.textColor = [UIColor colorWithRed:63.0/255.0 green:103.0/255.0 blue:160.0/255.0 alpha:1.0f];
        [cell.contentView addSubview:targetNamelabel];
        [targetNamelabel release];
        
        // label to display description
        NSString *text = [displayDetailsOfFeedsArray objectAtIndex:6];
        CGSize constraint = CGSizeMake(270, 20000.0f);
        CGSize size = [[NSString stringWithFormat:@"%@",text] sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:14] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        
        
        UILabel *targetDesclabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 160, 270, size.height)];
        targetDesclabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
        targetDesclabel.numberOfLines = 10;
        targetDesclabel.backgroundColor = [UIColor clearColor];
        targetDesclabel.lineBreakMode = UILineBreakModeWordWrap;
        targetDesclabel.text = [NSString stringWithFormat:@"%@",text];
        [cell.contentView addSubview:targetDesclabel];
        [targetDesclabel release];
    }
    
    return cell; 
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{ 
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int heightOfRow = 0;
    if(indexPath.row == 0)
    {
        NSString *text = [displayDetailsOfFeedsArray objectAtIndex:2];
        CGSize constraint = CGSizeMake(270, 20000.0f);
        CGSize size = [text sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:14] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        heightOfRow = size.height + 200; 
    }
    if (indexPath.row == 1) 
    {
        heightOfRow = 50;
    }
    if (indexPath.row == 2) 
    {
        NSString *text = [displayDetailsOfFeedsArray objectAtIndex:6];
        CGSize constraint = CGSizeMake(270, 20000.0f);
        CGSize size = [text sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:14] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        heightOfRow = size.height + 200;
    }
    return heightOfRow; //160    
}

// --navigate to activity details--
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _rowNumberInDetails = indexPath.row;
    if((_rowNumberInDetails == 0) || (_rowNumberInDetails == 2))
    {
        //Check for the availability of Internet
        Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
        
        NetworkStatus internetStatus = [r currentReachabilityStatus];
        if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Internet appears to be offline" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
        else
        {
            switch (_rowNumberInDetails) {
                case 0:
                    if([[actorLinkArray objectAtIndex:_rowNumberInActivity] isEqual:@"No Information"])
                    {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"No Information available" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                        [alert show];
                        [alert release];
                    }
                    else
                    {
                        [self navigateToWebDetails];
                    }
                    break;
                    
                case 2:
                    if([[targetLinkArray objectAtIndex:_rowNumberInActivity] isEqual:@"No Information"])
                    {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"No Information available" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                        [alert show];
                        [alert release];
                    }
                    else
                    {
                        [self navigateToWebDetails];
                    }
                    break;
            }
        }
    }  
}

-(void) navigateToWebDetails
{
    ActivityWebDetailsController *detailsViewController;
    detailsViewController = [[[ActivityWebDetailsController alloc] initWithNibName:@"ActivityWebDetailsController_iPhone" bundle:nil] autorelease];
    
    [self.navigationController pushViewController:detailsViewController animated:YES];
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
    
    NSLog(@"KK _globalSessionId = %@",_globalSessionId);
    displayDetailsOfFeedsArray = [NSMutableArray new];
    
    [displayDetailsOfFeedsArray addObject:[feedActorImageDisplayArray objectAtIndex:_rowNumberInActivity]];
    [displayDetailsOfFeedsArray addObject:[actorNameArray objectAtIndex:_rowNumberInActivity]];
    [displayDetailsOfFeedsArray addObject:[actorTaglineArray objectAtIndex:_rowNumberInActivity]];
    
    [displayDetailsOfFeedsArray addObject:[feedItemTypeArray objectAtIndex:_rowNumberInActivity]];
    
    [displayDetailsOfFeedsArray addObject:[feedTargetImageDisplayArray objectAtIndex:_rowNumberInActivity]];
    [displayDetailsOfFeedsArray addObject:[targetNameArray objectAtIndex:_rowNumberInActivity]];
    [displayDetailsOfFeedsArray addObject:[targetTaglineArray objectAtIndex:_rowNumberInActivity]];
    
    [displayDetailsOfFeedsArray addObject:[actorLinkArray objectAtIndex:_rowNumberInActivity]];
    [displayDetailsOfFeedsArray addObject:[targetLinkArray objectAtIndex:_rowNumberInActivity]];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIImage *backgroundImage = [UIImage imageNamed:@"navigationbarNf.png"];
    [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    
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
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@",[actorNameArray objectAtIndex:_rowNumberInActivity]];
    
    ////////////////////////////////////// To be saved to Kinvey /////////////////////////////////
    //Check for the availability of Internet
//    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
//    
//    NetworkStatus internetStatus = [r currentReachabilityStatus];
//    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
//    {
//        NSLog(@"\n\n No Internet Connection");
//    }
//    else
//    {
        _detailsCollection = [[[KCSClient sharedClient]
                               collectionFromString:@"UserActivity"
                               withClass:[KCSUserActivity class]] retain];
        
        KCSUserActivity *userActivity = [[KCSUserActivity alloc] init];
        
        SessionStates *sharedManager = [SessionStates sharedManager];
        if(sharedManager._sessionId == nil)
        {
            [sharedManager setSessionId];
        }
        userActivity.sessionId = sharedManager._sessionId;//_globalSessionId;
        
       NSLog(@"in ActivityDetailsViewController session id is %@\n",sharedManager._sessionId);
        userActivity.urlLinkVisited = [NSString stringWithFormat:@"%@",[actorLinkArray objectAtIndex:_rowNumberInActivity]];
        [userActivity saveToCollection:_detailsCollection withDelegate:self];
        [userActivity release];
   // }
}

-(void) backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewWillAppear:(BOOL)animated
{
    NSIndexPath *selection = [table indexPathForSelectedRow];
    if (selection)
    {
        [table deselectRowAtIndexPath:selection animated:YES];
    }
    [super viewWillAppear:animated];
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

//  ****************************************************************************************************/
/*                                          Kinvey Delegate Methods                                         */
/************************************************************************************************************/

// Persistable Delegate Methods
// Right now just pop-up an alert about what we got back from Kinvey during
// the save. Normally you would want to implement more code here
// This is called when the save completes successfully
- (void)entity:(id)entity operationDidCompleteWithResult:(NSObject *)result
{
    NSLog(@"\n\n%@",[result description]);
    _number_of_times_AD = 10;
}

// Right now just pop-up an alert about the error we got back from Kinvey during
// the save attempt. Normally you would want to implement more code here
// This is called when a save fails
- (void)entity:(id)entity operationDidFailWithError:(NSError *)error
{
    //Check for the availability of Internet
//    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
//    
//    NetworkStatus internetStatus = [r currentReachabilityStatus];
//    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
//    {
//        NSLog(@"\n\n No Internet Connection");
//    }
//    else
//    {
    NSLog(@"inside operationDidFailWithError - ActivityDetailsViewController\n ");
        NSLog(@"\n%@",[error localizedDescription]);
        NSLog(@"\n%@",[error localizedFailureReason]);
        
        if(error.code != 401 && _number_of_times_AD >= 0){
           // _number_of_times_AD--;
            NSLog(@"fetchDidFailWithError , _number_of_times_AD:%d\n",_number_of_times_AD);
            
            
            [self performSelector:@selector(TrysaveToCollection:) withObject:entity afterDelay:10.0];
            
            
            
        }
        else if (error.code == 401)
        {
            [KCSUser clearSavedCredentials];
        }

        
    //}
    
    
}

-(void)TrysaveToCollection:(id) entity{
    NSLog(@"inside TrysaveToCollection- activitydetailsviewcontroller\n");
    _number_of_times_AD--;
    [entity saveToCollection:_detailsCollection withDelegate:self];
}

@end
