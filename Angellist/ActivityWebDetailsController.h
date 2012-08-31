//
//  ActivityWebDetailsController.h
//  TableProj
//
//  Created by Ram Charan on 8/25/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityWebDetailsController : UIViewController <UIWebViewDelegate>
{
    IBOutlet UIWebView *webView;
    IBOutlet UIView *loading;
}

@end
