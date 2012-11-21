//
//  SPSnapInfo.m
//  Spot
//
//  Created by Sinhyub Kim on 11/9/12.
//  Copyright (c) 2012 Sinhyub Kim. All rights reserved.
//

@implementation SPSnapInfo
@synthesize snapID;
@synthesize imageID;
@synthesize spotID;
@synthesize userID;
@synthesize snaptime;
@synthesize description;
@synthesize lat;
@synthesize lng;
@synthesize popularity;
@synthesize userName;
@synthesize spotName;
@synthesize isLiked;


-(id) init
{
    if( self = [super init])
    {
        popularity = 1;
    }
    return self;
}

-(id) initWithJSONDictionary:(NSDictionary *)jsonDictionary
{
    self = [super init];
    if( self )
    {
        popularity = 1;
        [self loadFromJSONDictionary:jsonDictionary];
    }
    return self;
}

-(void) loadFromJSONDictionary:(NSDictionary*)jsonDictionary
{
    id value = nil;
    NSString* emptyString = @"";
    
    value = [jsonDictionary valueForKey:@"description"];
    if ([value isMemberOfClass:[NSNull class]] == NO)
    {
        self.description = value;
    }
    else
    {
        self.description = emptyString;
    }
    
    
    value = [jsonDictionary valueForKey:@"image_id"];
    if ([value isMemberOfClass:[NSNull class]] == NO)
    {
        self.imageID = [value integerValue];
    }
    else
    {
        self.imageID = 0;
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
    
    value = [jsonDictionary valueForKey:@"snap_id"];
    if ([value isMemberOfClass:[NSNull class]] == NO)
    {
        self.snapID = [value integerValue];
    }
    else
    {
        self.snapID = 0;
    }
    
    value = [jsonDictionary valueForKey:@"snaptime"];
    if ([value isMemberOfClass:[NSNull class]] == NO)
    {
        self.snaptime = value;
    }
    else
    {
        self.snaptime = 0;
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
    
    value = [jsonDictionary valueForKey:@"user_id"];
    if ([value isMemberOfClass:[NSNull class]] == NO)
    {
        self.userID = [value integerValue];
    }
    else
    {
        self.userID = 0;
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
    
    value = [jsonDictionary valueForKey:@"user_name"];
    if ([value isMemberOfClass:[NSNull class]] == NO)
    {
        self.userName = value;
    }
    else
    {
        self.userName = emptyString;
    }

    value = [jsonDictionary valueForKey:@"spot_name"];
    if ([value isMemberOfClass:[NSNull class]] == NO)
    {
        self.spotName = value;
    }
    else
    {
        self.spotName = emptyString;
    }
    
    value = [jsonDictionary valueForKey:@"liked"];
    if ([value isMemberOfClass:[NSNull class]] == NO)
    {
        self.isLiked = [value boolValue];
    }
    else
    {
        self.isLiked = NO;
    }
}



@end
