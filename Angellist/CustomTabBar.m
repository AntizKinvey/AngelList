//
//  CustomTabBar.m
//  CustomTabBarProj
//
//  Created by Ram Charan on 6/6/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import "CustomTabBar.h"

@implementation CustomTabBar

- (void)viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
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
//    [UIImage imageNamed:@"tabbarbackground.png"];
    UIImage *btnImage = [UIImage imageNamed:@"home.png"];
    UIImage *btnImageSelected = [UIImage imageNamed:@"homep.png"];
    
    btn1 = [UIButton buttonWithType:UIButtonTypeCustom]; //Setup the button
    btn1.frame = CGRectMake(0, 415, 80, 44); // Set the frame (size and position) of the button)
    [btn1 setBackgroundImage:btnImage forState:UIControlStateNormal]; // Set the image for the normal state of the button
    [btn1 setBackgroundImage:btnImageSelected forState:UIControlStateSelected]; // Set the image for the selected state of the button
    [btn1 setTag:0]; // Assign the button a "tag" so when our "click" event is called we know which button was pressed.
    [btn1 setSelected:true]; // Set this button as selected (we will select the others to false as we only want Tab 1 to be selected initially
    
    // Now we repeat the process for the other buttons
    btnImage = [UIImage imageNamed:@"activity.png"];
    btnImageSelected = [UIImage imageNamed:@"activityp.png"];
    btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(80, 415, 80, 44);
    [btn2 setBackgroundImage:btnImage forState:UIControlStateNormal];
    [btn2 setBackgroundImage:btnImageSelected forState:UIControlStateSelected];
    [btn2 setTag:1];
    
    btnImage = [UIImage imageNamed:@"startup.png"];
    btnImageSelected = [UIImage imageNamed:@"startupp.png"];
    btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.frame = CGRectMake(160, 415, 80, 44);
    [btn3 setBackgroundImage:btnImage forState:UIControlStateNormal];
    [btn3 setBackgroundImage:btnImageSelected forState:UIControlStateSelected];
    [btn3 setTag:2];
    
    btnImage = [UIImage imageNamed:@"inbox.png"];
    btnImageSelected = [UIImage imageNamed:@"inboxp.png"];
    btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn4.frame = CGRectMake(240, 415, 80, 44);
    [btn4 setBackgroundImage:btnImage forState:UIControlStateNormal];
    [btn4 setBackgroundImage:btnImageSelected forState:UIControlStateSelected];
    [btn4 setTag:3];
    
    // Add my new buttons to the view
    [self.view addSubview:btn1];
    [self.view addSubview:btn2];
    [self.view addSubview:btn3];
    [self.view addSubview:btn4];
    
    // Setup event handlers so that the buttonClicked method will respond to the touch up inside event.
    [btn1 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn2 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn3 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn4 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)selectTab:(int)tabID
{
    switch(tabID)
    {
        case 0:
            [btn1 setSelected:true];
            [btn2 setSelected:false];
            [btn3 setSelected:false];
            [btn4 setSelected:false];
            break;
        case 1:
            [btn1 setSelected:false];
            [btn2 setSelected:true];
            [btn3 setSelected:false];
            [btn4 setSelected:false];
            break;
        case 2:
            [btn1 setSelected:false];
            [btn2 setSelected:false];
            [btn3 setSelected:true];
            [btn4 setSelected:false];
            break;
        case 3:
            [btn1 setSelected:false];
            [btn2 setSelected:false];
            [btn3 setSelected:false];
            [btn4 setSelected:true];
            break;
    }  
    
    if (self.selectedIndex == tabID) {
        UINavigationController *navController = (UINavigationController *)[self selectedViewController];
        [navController popToRootViewControllerAnimated:YES];
    } else {
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
