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
    
    //Call to hide existing elements of tab bar
    [self hideExistingTabBar];
    //Call to add custom elements to tab bar
    [self addCustomElements];
}

//Hide existing elements of default tab bar
- (void)hideExistingTabBar
{
    //Hide all subviews in tab bar view
    for(UIView *view in self.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            view.hidden = YES;
            break;
        }
    }
}

//Add custom elements required to tab bar
-(void)addCustomElements
{
    // Initialise our two images
    UIImage *btnImage;
    UIImage *btnImageSelected;

    btnImage = [UIImage imageNamed:@"peoplei.png"];
    btnImageSelected = [UIImage imageNamed:@"peoplea.png"];
    btn2 = [UIButton buttonWithType:UIButtonTypeCustom];//Setup the button
//    btn2.frame = CGRectMake(0, 410, 107, 50);// Set the frame (size and position) of the button)
    btn2.frame = CGRectMake(0, 400, 80, 60);
    [btn2 setBackgroundImage:btnImage forState:UIControlStateNormal];// Set the image for the normal state of the button
    [btn2 setBackgroundImage:btnImageSelected forState:UIControlStateSelected];// Set the image for the selected state of the button
    [btn2 setSelected:TRUE];// Set this button as selected (we will select the others to false as we only want Tab 1 to be selected initially
    [btn2 setTag:0];// Assign the button a "tag" so when our "click" event is called we know which button was pressed.
    
    // Now we repeat the process for the other buttons
    btnImage = [UIImage imageNamed:@"startupi.png"];
    btnImageSelected = [UIImage imageNamed:@"startupa.png"];
    btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.frame = CGRectMake(80, 400, 80, 60);
    [btn3 setBackgroundImage:btnImage forState:UIControlStateNormal];
    [btn3 setBackgroundImage:btnImageSelected forState:UIControlStateSelected];
    [btn3 setTag:1];
    
    btnImage = [UIImage imageNamed:@"inboxi.png"];
    btnImageSelected = [UIImage imageNamed:@"inboxa.png"];
    btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn4.frame = CGRectMake(160, 400, 80, 60);
    [btn4 setBackgroundImage:btnImage forState:UIControlStateNormal];
    [btn4 setBackgroundImage:btnImageSelected forState:UIControlStateSelected];
    [btn4 setTag:2];
    
    btnImage = [UIImage imageNamed:@"mei.png"];
    btnImageSelected = [UIImage imageNamed:@"mea.png"];
    btn5 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn5.frame = CGRectMake(240, 400, 80, 60);
    [btn5 setBackgroundImage:btnImage forState:UIControlStateNormal];
    [btn5 setBackgroundImage:btnImageSelected forState:UIControlStateSelected];
    [btn5 setTag:3];
    
    // Add my new buttons to the view
    [self.view addSubview:btn2];
    [self.view addSubview:btn3];
    [self.view addSubview:btn4];
    [self.view addSubview:btn5];
    
    // Setup event handlers so that the buttonClicked method will respond to the touch up inside event.
    [btn2 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn3 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn4 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn5 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

//Check the selected tab in tab bar
- (void)selectTab:(int)tabID
{
    switch(tabID)
    {
        case 0:
            [btn2 setSelected:true];
            [btn3 setSelected:false];
            [btn4 setSelected:false];
            [btn5 setSelected:false];
            break;
        case 1:
            [btn2 setSelected:false];
            [btn3 setSelected:true];
            [btn4 setSelected:false];
            [btn5 setSelected:false];
            break;
        case 2:
            [btn2 setSelected:false];
            [btn3 setSelected:false];
            [btn4 setSelected:true];
            [btn5 setSelected:false];
            break;
        case 3:
            [btn2 setSelected:false];
            [btn3 setSelected:false];
            [btn5 setSelected:true];
            [btn4 setSelected:false];
            break;
    } 
    
    //Check if selected tab is selected again
    if (self.selectedIndex == tabID) 
    {
        //Navigate to root view controller
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
