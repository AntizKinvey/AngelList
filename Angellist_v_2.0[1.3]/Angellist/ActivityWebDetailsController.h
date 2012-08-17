//
//  ActivityWebDetailsVontroller.h
//  Angellist
//
//  Created by Ram Charan on 6/4/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityWebDetailsController : UIViewController <UIWebViewDelegate>
{
    // webview
    IBOutlet UIWebView *webView;
    IBOutlet UIView *loading;
}
@end
