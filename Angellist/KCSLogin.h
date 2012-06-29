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

@property (retain, nonatomic) NSString *objectId;
@property (retain, nonatomic) NSString *userId;
@property (retain, nonatomic) NSString *logintime;
@property (retain, nonatomic) NSString *sessionId;

@end
