//
//  SPCommentInfo.m
//  Spot
//
//  Created by Sinhyub Kim on 11/17/12.
//  Copyright (c) 2012 Sinhyub Kim. All rights reserved.
//


@implementation SPCommentInfo

@synthesize comment, createdTime, commentID, snapID, spotID, userID, userInfo;


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
    
    value = [jsonDictionary valueForKey:@"comment"];
    if ([value isMemberOfClass:[NSNull class]] == NO)
    {
        self.comment = value;
    }
    else
    {
        self.comment = emptyString;
    }
    
    
    value = [jsonDictionary valueForKey:@"created"];
    if ([value isMemberOfClass:[NSNull class]] == NO)
    {
        self.createdTime = value;
    }
    else
    {
        self.createdTime = emptyString;
    }
    
    value = [jsonDictionary valueForKey:@"id"];
    if ([value isMemberOfClass:[NSNull class]] == NO)
    {
        self.commentID = [value integerValue];
    }
    else
    {
        self.commentID = -1;
    }
    
    value = [jsonDictionary valueForKey:@"snap_id"];
    if ([value isMemberOfClass:[NSNull class]] == NO)
    {
        self.snapID = [value integerValue];
    }
    else
    {
        self.snapID = NO;
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

    value = [jsonDictionary valueForKey:@"userinfo"];
    if ([value isMemberOfClass:[NSNull class]] == NO)
    {
        self.userInfo = [[SPUserInfo alloc] initWithJSONDictionary:value];
    }
    else
    {
        self.userInfo = nil;
    }
}


@end
