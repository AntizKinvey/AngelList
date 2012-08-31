//
//  StartUpWebDetailsController.h
//  TableProj
//
//  Created by Ram Charan on 8/27/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StartUpWebDetailsController : UIViewController <UIWebViewDelegate>
{
    IBOutlet UIWebView *webView;
    IBOutlet UIView *loading;
}

@end
