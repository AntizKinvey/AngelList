//
//  KCSLogout.m
//  SampleDateApp
//
//  Created by Ram Charan on 6/22/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import "KCSLogout.h"

@implementation KCSLogout

@synthesize objectId = _objectId;
@synthesize logouttime = _logouttime;
@synthesize sessionId = _sessionId;

-(id) init
{
    if(self = [super init])
    {
        _objectId = nil;
        _logouttime = nil;
        _sessionId = nil;
    }
    return self;
}

-(void) dealloc
{
    [_objectId release];
    [_logouttime release];
    [_sessionId release];
    [super dealloc];
}

// Required to be overridden for Kinvey
- (NSDictionary *)hostToKinveyPropertyMapping
{
    // Only define the dictionary once
    static NSDictionary *mapping = nil;
    
    // If it's not initialized, initialize here
    if (mapping == nil){
        // Assign the mapping
        mapping = [[NSDictionary dictionaryWithObjectsAndKeys:
                   @"_id", @"objectId",
                   @"sessionId", @"sessionId",
                   @"logouttime", @"logouttime",
                   nil] retain];
    }
    
    return mapping;
}

@end
