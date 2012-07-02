//
//  KCSLogout.h
//  SampleDateApp
//
//  Created by Ram Charan on 6/22/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KinveyKit/KinveyKit.h>

@interface KCSLogout : NSObject <KCSPersistable>

//Id of object which is created default in Kinvey or can be manually specified
@property (retain, nonatomic) NSString *objectId;
//Time of logout that user logs out of app
@property (retain, nonatomic) NSString *logouttime;
//Session Id to determine at what time the user logs in
@property (retain, nonatomic) NSString *sessionId;

@end
