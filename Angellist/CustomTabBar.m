//
//  CustomTabBar.m
//  CustomTabBarProj
//
//  Created by Ram Charan on 6/6/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import "CustomTabBar.h"
#import <QuartzCore/QuartzCore.h>

@implementation CustomTabBar

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self hideExistingTabBar];
    [self addCustomElements];
}

- (void)hideExistingTabBar
{
    for(UIView *view in self.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            view.hidden = YES;
            break;
        }
    }
}

-(void)addCustomElements
{
    // Initialise our two images

    UIImage *btnImage;
    UIImage *btnImageSelected;
    
    
    // Now we repeat the process for the other buttons
    btnImage = [UIImage imageNamed:@"peoplei.png"];
    btnImageSelected = [UIImage imageNamed:@"peoplea.png"];
    btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(0, 410, 107, 50);
    [btn2 setBackgroundImage:btnImage forState:UIControlStateNormal];
    [btn2 setBackgroundImage:btnImageSelected forState:UIControlStateSelected];
    [btn2 setSelected:TRUE];
    [btn2 setTag:0];
    
    btnImage = [UIImage imageNamed:@"startupi.png"];
    btnImageSelected = [UIImage imageNamed:@"startupa.png"];
    btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.frame = CGRectMake(107, 410, 107, 50);
    [btn3 setBackgroundImage:btnImage forState:UIControlStateNormal];
    [btn3 setBackgroundImage:btnImageSelected forState:UIControlStateSelected];
    [btn3 setTag:1];
    
    btnImage = [UIImage imageNamed:@"inboxi.png"];
    btnImageSelected = [UIImage imageNamed:@"inboxa.png"];
    btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn4.frame = CGRectMake(214, 410, 107, 50);
    [btn4 setBackgroundImage:btnImage forState:UIControlStateNormal];
    [btn4 setBackgroundImage:btnImageSelected forState:UIControlStateSelected];
    [btn4 setTag:2];

    [self.view addSubview:btn2];
    [self.view addSubview:btn3];
    [self.view addSubview:btn4];
    
    [btn2 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn3 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn4 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)selectTab:(int)tabID
{
    switch(tabID)
    {
        case 0:
            [btn2 setSelected:true];
            [btn3 setSelected:false];
            [btn4 setSelected:false];
            break;
        case 1:
            [btn2 setSelected:false];
            [btn3 setSelected:true];
            [btn4 setSelected:false];
            break;
        case 2:
            [btn2 setSelected:false];
            [btn3 setSelected:false];
            [btn4 setSelected:true];
            break;
    } 
    
    if (self.selectedIndex == tabID) 
    {
        UINavigationController *navController = (UINavigationController *)[self selectedViewController];
        [navController popToRootViewControllerAnimated:YES];
    } 
    else 
    {
        self.selectedIndex = tabID;
    }
}

- (void)buttonClicked:(id)sender
{
    int tagNum = [sender tag];
    [self selectTab:tagNum];
}

- (void)dealloc {
    [super dealloc];
}

@end
