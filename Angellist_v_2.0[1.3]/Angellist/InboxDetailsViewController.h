//
//  InboxDetailsViewController.h
//  Angellist
//
//  Created by Ram Charan on 15/06/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

@interface InboxDetailsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate, UITextViewDelegate>
{
    IBOutlet UITableView *tableMsgDetails;
    IBOutlet UITextView *textViewReply;
    DBManager *_dbmanager; 
}

// table view
@property(nonatomic, retain)IBOutlet UITableView *tableMsgDetails;

// text view to send a reply
@property(nonatomic, retain)IBOutlet UITextView *textViewReply;



// return keyboard
-(IBAction)returnkeyboard:(id)sender;

// move the view up while replying through the text view
-(void)setViewMoveUp:(BOOL)moveUp;

// load images Concurrently
-(void)startLoadingImagesConcurrently;

// display time
-(void)getTime;

//get details of the conversation
-(void)getrequestDetails;

@end
