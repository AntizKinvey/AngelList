//
//  CustomTabBar.h
//  CustomTabBarProj
//
//  Created by Deepak on 6/6/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomTabBar : UITabBarController
{
    UIButton *btn2;
    UIButton *btn3;
    UIButton *btn4;
    UIButton *btn5;
}

//Hide existing elements of default tab bar
-(void) hideExistingTabBar;

//Add custom elements required to tab bar
-(void) addCustomElements;

//Check the selected tab in tab bar
-(void) selectTab:(int)tabID;

@end
