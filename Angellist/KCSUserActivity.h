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

@property (retain, nonatomic) NSString *objectId;
@property (retain, nonatomic) NSString *sessionId;
@property (retain, nonatomic) NSString *urlLinkVisited;

@end
