//
//  SPUserProfileInfo.m
//  Spot
//
//  Created by Sinhyub Kim on 11/9/12.
//  Copyright (c) 2012 Sinhyub Kim. All rights reserved.
//

@implementation SPUserProfileInfo

@synthesize userInfo;
@synthesize snapList;
@synthesize logicalSpotList;
@synthesize physicalSpotList;

-(id) init
{
    if( self = [super init])
    {
        if( self.snapList == nil )
            self.snapList = [[NSMutableArray alloc] init];
        if( self.physicalSpotList == nil )
            self.physicalSpotList = [[NSMutableArray alloc] init];
        if( self.logicalSpotList == nil )
            self.logicalSpotList = [[NSMutableArray alloc] init];

    }
    return self;
}

-(id) initWithJSONDictionary:(NSDictionary *)jsonDictionary
{
    self = [super init];
    if( self )
    {
        if( self.snapList == nil )
            self.snapList = [[NSMutableArray alloc] init];
        if( self.physicalSpotList == nil )
            self.physicalSpotList = [[NSMutableArray alloc] init];
        if( self.logicalSpotList == nil )
            self.logicalSpotList = [[NSMutableArray alloc] init];

        [self loadFromJSONDictionary:jsonDictionary];
    }
    return self;
}

-(void) loadFromJSONDictionary:(NSDictionary*)jsonDictionary
{
    NSAssert(self.snapList!=nil, @"snapList is not Allocated");
    NSAssert(self.logicalSpotList!=nil, @"spotList is not Allocated");
    NSAssert(self.physicalSpotList!=nil, @"spotList is not Allocated");
    
    id value = nil;

    value = [jsonDictionary valueForKey:@"user_info"];
    if ([value isMemberOfClass:[NSNull class]] == NO)
    {
        self.userInfo = [[SPUserInfo alloc] initWithJSONDictionary:value];
    }
    else
    {
        self.userInfo = nil;
    }
    
    value = [jsonDictionary valueForKey:@"snap_list"];
    if ([value isMemberOfClass:[NSNull class]] == NO)
    {
        NSArray* snapListJSON = value;
        for(id snapJSON in snapListJSON )
        {
            SPSnapInfo* snapInfo = [[SPSnapInfo alloc] initWithJSONDictionary:snapJSON];
            [self.snapList addObject:snapInfo];
        }
    }
    else
    {
        self.snapList = nil;
    }
    
    value = [jsonDictionary valueForKey:@"physical_spot_list"];
    if ([value isMemberOfClass:[NSNull class]] == NO)
    {
        NSArray* spotListJSON = value;
        for(id spotJSON in spotListJSON )
        {
            SPSpotInfo* spotInfo = [[SPSpotInfo alloc] initWithJSONDictionary:spotJSON];
            [self.physicalSpotList addObject:spotInfo];
        }
    }
    else
    {
        self.physicalSpotList = nil;
    }

    value = [jsonDictionary valueForKey:@"logical_spot_list"];
    if ([value isMemberOfClass:[NSNull class]] == NO)
    {
        NSArray* spotListJSON = value;
        for(id spotJSON in spotListJSON )
        {
            SPSpotInfo* spotInfo = [[SPSpotInfo alloc] initWithJSONDictionary:spotJSON];
            [self.logicalSpotList addObject:spotInfo];
        }
    }
    else
    {
        self.logicalSpotList = nil;
    }

}


@end
