//
//  KCSLogin.m
//  SampleDateApp
//
//  Created by Ram Charan on 6/22/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import "KCSLogin.h"

@implementation KCSLogin

@synthesize objectId = _objectId;
@synthesize userId = _userId;
@synthesize logintime = _logintime;
@synthesize sessionId = _sessionId;


// Default initializer
-(id) init
{
    if(self = [super init])
    {
        _objectId = nil;
        _userId = nil;
        _logintime = nil;
        _sessionId = nil;
    }
    return self;
}

// Destroy our objects when we're done
-(void)dealloc
{
    [_objectId release];
    [_userId release];
    [_logintime release];
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
                   @"_id", @"objectId",//Id of object which is created default in Kinvey or can be manually specified
                   @"KinveyUserId", @"userId",//Id of user of current device
                   @"logintime", @"logintime",//Time of login that user logged into app
                   @"sessionId", @"sessionId",//Session Id to determine at what time the user logs in
                   nil] retain];
    }
    
    return mapping;
}

@end
