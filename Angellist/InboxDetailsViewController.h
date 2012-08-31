//
//  InboxDetailsViewController.h
//  TableProj
//
//  Created by Ram Charan on 8/28/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InboxDetailsViewController : UIViewController <UITableViewDataSource, UITextViewDelegate>
{
    IBOutlet UITableView *table;
    IBOutlet UITextView *textViewReply;
    IBOutlet UIView *loadingView;
}

-(void) getConversations;

-(void) loadImages;

-(void)getTime;

-(void)setViewMoveUp:(BOOL)moveUp;


@end
