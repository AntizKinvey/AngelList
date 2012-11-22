//
//  LoginViewController.h
//  TableProj
//
//  Created by Ram Charan on 8/26/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

@interface LoginViewController : UIViewController <UIWebViewDelegate>
{
    IBOutlet UIView *loading;
    IBOutlet UIWebView *webView;
    IBOutlet UIActivityIndicatorView *ac;
    
    
    DBManager *_dbmanager;
}

-(void) saveImageOfUserAndDetailsToDb;
-(IBAction)dismissView:(id)sender;
-(void) closeAction;

@end
