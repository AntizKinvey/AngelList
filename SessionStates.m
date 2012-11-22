//
//  SessionStates.m
//  Angellist
//
//  Created by Ram Charan on 20/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SessionStates.h"
#import <KinveyKit/KinveyAnalytics.h>
 NSString* myStaticSessionId;
@implementation SessionStates
@synthesize _sessionId;


+ (id)sharedManager {
    static  SessionStates *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        KCSAnalytics *col = [KCSAnalytics new];
        //_globalSessionId = [col generateUUID];
        
      
        _sessionId = [[NSString alloc] initWithString: [col generateUUID]];
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}
-(void)setSessionId
{
    KCSAnalytics *col = [KCSAnalytics new];
   
    _sessionId = [[NSString alloc] initWithString:[col generateUUID]];
  

}

-(NSString*)getSessionId
{
    
    return myStaticSessionId;
    
}
@end
