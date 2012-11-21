//
//  SPSpotInfo.m
//  Spot
//
//  Created by Sinhyub Kim on 11/9/12.
//  Copyright (c) 2012 Sinhyub Kim. All rights reserved.
//

@implementation SPSpotInfo

@synthesize spotID;
@synthesize kingID;
@synthesize queenID;
@synthesize kingUserInfo;
@synthesize queenUserInfo;
@synthesize spotName;
@synthesize description;
@synthesize createdTime;
@synthesize lat;
@synthesize lng;
@synthesize popularity;
@synthesize isPrivate;
@synthesize isPhysical;
@synthesize price;

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
    NSString* emptyString = @"";
    
    value = [jsonDictionary valueForKey:@"created"];
    if ([value isMemberOfClass:[NSNull class]] == NO)
    {
        self.createdTime = value;
    }
    else
    {
        self.createdTime = emptyString;
    }
    
    
    value = [jsonDictionary valueForKey:@"description"];
    if ([value isMemberOfClass:[NSNull class]] == NO)
    {
        self.description = value;
    }
    else
    {
        self.description = emptyString;
    }
    
    value = [jsonDictionary valueForKey:@"name"];
    if ([value isMemberOfClass:[NSNull class]] == NO)
    {
        self.spotName = value;
    }
    else
    {
        self.spotName = emptyString;
    }
    
    value = [jsonDictionary valueForKey:@"is_private"];
    if ([value isMemberOfClass:[NSNull class]] == NO)
    {
        self.isPrivate = [value boolValue];
    }
    else
    {
        self.isPrivate = NO;
    }
    
    value = [jsonDictionary valueForKey:@"is_physical"];
    if ([value isMemberOfClass:[NSNull class]] == NO)
    {
        self.isPhysical = [value boolValue];
    }
    else
    {
        self.isPhysical = NO;
    }

    
    value = [jsonDictionary valueForKey:@"spot_id"];
    if ([value isMemberOfClass:[NSNull class]] == NO)
    {
        self.spotID = [value integerValue];
    }
    else
    {
        self.spotID = 0;
    }
    
    value = [jsonDictionary valueForKey:@"king"];
    if ([value isMemberOfClass:[NSNull class]] == NO)
    {
        self.kingUserInfo = [[SPUserInfo alloc] initWithJSONDictionary:value];
    }
    else
    {
        self.kingUserInfo = nil;
    }
    
    value = [jsonDictionary valueForKey:@"king_id"];
    if ([value isMemberOfClass:[NSNull class]] == NO)
    {
        self.kingID = [value integerValue];
    }
    else
    {
        self.kingID = 1;
    }
    
    value = [jsonDictionary valueForKey:@"queen"];
    if ([value isMemberOfClass:[NSNull class]] == NO)
    {
        self.queenUserInfo = [[SPUserInfo alloc] initWithJSONDictionary:value];
    }
    else
    {
        self.queenUserInfo = nil;
    }
    
    value = [jsonDictionary valueForKey:@"queen_id"];
    if ([value isMemberOfClass:[NSNull class]] == NO)
    {
        self.queenID = [value integerValue];
    }
    else
    {
        self.queenID = 1;
    }
    
    value = [jsonDictionary valueForKey:@"lat"];
    if ([value isMemberOfClass:[NSNull class]] == NO)
    {
        self.lat = [value floatValue];
    }
    else
    {
        self.lat = 0.f;
    }
    
    value = [jsonDictionary valueForKey:@"lng"];
    if ([value isMemberOfClass:[NSNull class]] == NO)
    {
        self.lng = [value floatValue];
    }
    else
    {
        self.lng = 0.f;
    }
    
    value = [jsonDictionary valueForKey:@"popularity"];
    if ([value isMemberOfClass:[NSNull class]] == NO)
    {
        self.popularity = [value integerValue];
    }
    else
    {
        self.popularity = 0;
    }
    
    value = [jsonDictionary valueForKey:@"price"];
    if ([value isMemberOfClass:[NSNull class]] == NO)
    {
        self.price = [value floatValue];
    }
    else
    {
        self.price = 0;
    }
}

@end
