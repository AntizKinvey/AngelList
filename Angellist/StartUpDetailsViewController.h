//
//  StartUpDetailsViewController.h
//  Angellist
//
//  Created by Ram Charan on 6/4/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StartUpDetailsViewController : UIViewController
{
    IBOutlet UIImageView *startUpImage;
    IBOutlet UITextView *startUpDesc;
    
    IBOutlet UILabel *startUpName;
    IBOutlet UILabel *startUpMarket;
    IBOutlet UILabel *startUpLocation;
    IBOutlet UILabel *startUpFollowers;
    
    IBOutlet UIButton *followButton;
    IBOutlet UIButton *unfollowButton;
}

-(IBAction)startUpDetails:(id)sender;
-(IBAction)followStartUp:(id)sender;
-(IBAction)unfollowStartUp:(id)sender;

@end
