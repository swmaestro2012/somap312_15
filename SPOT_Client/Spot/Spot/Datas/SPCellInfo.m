//
//  SPCellInfo.m
//  Spot
//
//  Created by Sinhyub Kim on 11/10/12.
//  Copyright (c) 2012 Sinhyub Kim. All rights reserved.
//
@implementation SPCellInfo

@synthesize mapX;
@synthesize mapY;
@synthesize startLng;
@synthesize endLng;
@synthesize startLat;
@synthesize endLat;
@synthesize postList;


-(id) init
{
    if( self = [super init])
    {
    }
    return self;
}

-(id) initWithJSONDictionary:(NSDictionary *)jsonDictionary
{
    self = [super init];
    if( self )
    {
        [self loadFromJSONDictionary:jsonDictionary];
    }
    return self;
}

-(void) loadFromJSONDictionary:(NSDictionary*)jsonDictionary
{
    id value = nil;
    
    value = [jsonDictionary valueForKey:@"map_x"];
    if ([value isMemberOfClass:[NSNull class]] == NO)
    {
        self.mapX = [value integerValue];
    }
    else
    {
        self.mapX = -1;
    }
    
    value = [jsonDictionary valueForKey:@"map_y"];
    if ([value isMemberOfClass:[NSNull class]] == NO)
    {
        self.mapY = [value integerValue];
    }
    else
    {
        self.mapY = -1;
    }
    
    value = [jsonDictionary valueForKey:@"start_lat"];
    if ([value isMemberOfClass:[NSNull class]] == NO)
    {
        self.startLat = [value floatValue];
    }
    else
    {
        self.startLat = -1.f;
    }
    
    value = [jsonDictionary valueForKey:@"end_lat"];
    if ([value isMemberOfClass:[NSNull class]] == NO)
    {
        self.endLat = [value floatValue];
    }
    else
    {
        self.endLat = -1.f;
    }
    
    value = [jsonDictionary valueForKey:@"start_lng"];
    if ([value isMemberOfClass:[NSNull class]] == NO)
    {
        self.startLng = [value floatValue];
    }
    else
    {
        self.startLng = -1.f;
    }
    
    value = [jsonDictionary valueForKey:@"end_lat"];
    if ([value isMemberOfClass:[NSNull class]] == NO)
    {
        self.endLat = [value floatValue];
    }
    else
    {
        self.endLat = -1.f;
    }
    
    value = [jsonDictionary valueForKey:@"snap_list"];
    if ([value isMemberOfClass:[NSNull class]] == NO)
    {
        if( self.postList == nil )
            self.postList = [[NSMutableArray alloc] init];
        
        NSArray* postListJSON = value;
        for( NSDictionary* postJSON in postListJSON )
        {
            SPSnapInfo* snapInfo = [[SPSnapInfo alloc] initWithJSONDictionary:postJSON];
            [self.postList addObject:snapInfo];
        }
    }
    else
    {
        self.postList = nil;
    }
}


@end
