//
//  ActivityDetailsViewController.h
//  Angellist
//
//  Created by Ram Charan on 6/4/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityDetailsViewController : UIViewController
{
    IBOutlet UIImageView *actorImage;
    IBOutlet UILabel *actorName;
    IBOutlet UITextView *actorDesc;
    IBOutlet UIButton *followButton;
    IBOutlet UIButton *unfollowButton;
}

-(IBAction)actorDetails:(id)sender;
-(IBAction)followActor:(id)sender;
-(IBAction)unfollowActor:(id)sender;

@end
