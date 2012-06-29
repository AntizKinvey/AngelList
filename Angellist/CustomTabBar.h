//
//  CustomTabBar.h
//  CustomTabBarProj
//
//  Created by Ram Charan on 6/6/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomTabBar : UITabBarController
{
//    UIButton *btn1;
    UIButton *btn2;
    UIButton *btn3;
    UIButton *btn4;
}

-(void) hideExistingTabBar;

-(void) addCustomElements;

-(void) selectTab:(int)tabID;

@end
