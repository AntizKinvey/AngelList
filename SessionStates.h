//
//  SessionStates.h
//  Angellist
//
//  Created by Ram Charan on 20/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SessionStates : NSObject
{
   NSString *_sessionId;
}
@property (nonatomic, retain) NSString *_sessionId;
+ (id)sharedManager;
-(void)setSessionId;
-(NSString*)getSessionId;
@end
