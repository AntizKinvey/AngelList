//
//  InboxDetailsViewController.h
//  Angellist
//
//  Created by Ram Charan on 15/06/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InboxDetailsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate, UITextViewDelegate>
{
    
    IBOutlet UITableView *tableMsgDetails;
    IBOutlet UITextView *textViewReply;
    
    
}

@property(nonatomic, retain)IBOutlet UITableView *tableMsgDetails;
@property(nonatomic, retain)IBOutlet UITextView *textViewReply;

-(IBAction)returnkeyboard:(id)sender;
-(void)setViewMoveUp:(BOOL)moveUp;
-(void)startLoadingImagesConcurrently;
-(void)getTime;
-(void)getrequestDetails;

@end
