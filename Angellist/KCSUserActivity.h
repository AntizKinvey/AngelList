//
//  KCSUserActivity.h
//  Angellist
//
//  Created by Ram Charan on 6/27/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KinveyKit/KinveyKit.h>

@interface KCSUserActivity : NSObject <KCSPersistable>

//Id of object which is created default in Kinvey or can be manually specified
@property (retain, nonatomic) NSString *objectId;
//Session Id to determine at what time the user logs in
@property (retain, nonatomic) NSString *sessionId;
//Activity of user at a particular session
@property (retain, nonatomic) NSString *urlLinkVisited;

@end
