//
//  KCSUserActivity.m
//  Angellist
//
//  Created by Ram Charan on 6/27/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import "KCSUserActivity.h"

@implementation KCSUserActivity

@synthesize objectId = _objectId;
@synthesize sessionId = _sessionId;
@synthesize urlLinkVisited = _urlLinkVisited;

-(id) init
{
    if(self = [super init])
    {
        _objectId = nil;
        _sessionId = nil;
        _urlLinkVisited = nil;
    }
    return self;
}

-(void) dealloc
{
    [_objectId release];
    [_sessionId release];
    [_urlLinkVisited release];
    
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
                    @"sessionId", @"sessionId",//Session Id to determine at what time the user logs in
                    @"urlLinkVisited", @"urlLinkVisited",//Activity of user at a particular session
                    nil] retain];
    }
    
    return mapping;
}

@end
