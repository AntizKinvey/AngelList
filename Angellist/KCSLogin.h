//
//  KCSLogin.h
//  SampleDateApp
//
//  Created by Ram Charan on 6/22/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KinveyKit/KinveyKit.h>

@interface KCSLogin : NSObject <KCSPersistable>

//Id of object which is created default in Kinvey or can be manually specified
@property (retain, nonatomic) NSString *objectId;
//Id of user of current device
@property (retain, nonatomic) NSString *userId;
//Time of login that user logged into app
@property (retain, nonatomic) NSString *logintime;
//Session Id to determine at what time the user logs in
@property (retain, nonatomic) NSString *sessionId;

@end
