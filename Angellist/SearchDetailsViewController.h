//
//  SearchDetailsViewController.h
//  Angellist
//
//  Created by Ram Charan on 25/07/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchDetailsViewController : UIViewController<UIWebViewDelegate>
{
    
    IBOutlet UIWebView *webView;
    IBOutlet UIView *loading;
    UILabel *labelSearchDetails;
    UILabel *labelSearch;
}

@end
