//
//  SPUserInfo.m
//  Spot
//
//  Created by Sinhyub Kim on 11/9/12.
//  Copyright (c) 2012 Sinhyub Kim. All rights reserved.
//

@implementation SPUserInfo

@synthesize userID;
@synthesize birthday;
@synthesize description;
@synthesize email;
@synthesize facebook;
@synthesize gender;
@synthesize homepage;
@synthesize nickname;
@synthesize phoneNumber;
@synthesize workplace;

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
    
    value = [jsonDictionary valueForKey:@"birthday"];
    if ([value isMemberOfClass:[NSNull class]] == NO)
    {
        self.birthday = value;
    }
    else
    {
        self.birthday = emptyString;
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
    
    value = [jsonDictionary valueForKey:@"email"];
    if ([value isMemberOfClass:[NSNull class]] == NO)
    {
        self.email = value;
    }
    else
    {
        self.email = emptyString;
    }
    
    value = [jsonDictionary valueForKey:@"facebook"];
    if ([value isMemberOfClass:[NSNull class]] == NO)
    {
        self.facebook = value;
    }
    else
    {
        self.facebook = emptyString;
    }
    
    value = [jsonDictionary valueForKey:@"gender"];
    if ([value isMemberOfClass:[NSNull class]] == NO)
    {
        self.gender = value;
    }
    else
    {
        self.gender = emptyString;
    }
    
    value = [jsonDictionary valueForKey:@"homepage"];
    if ([value isMemberOfClass:[NSNull class]] == NO)
    {
        self.homepage = value;
    }
    else
    {
        self.homepage = emptyString;
    }
    
    value = [jsonDictionary valueForKey:@"nickname"];
    if ([value isMemberOfClass:[NSNull class]] == NO)
    {
        self.nickname = value;
    }
    else
    {
        self.nickname = emptyString;
    }
    
    value = [jsonDictionary valueForKey:@"phone_number"];
    if ([value isMemberOfClass:[NSNull class]] == NO)
    {
        self.phoneNumber = value;
    }
    else
    {
        self.phoneNumber = emptyString;
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
    
    value = [jsonDictionary valueForKey:@"workplace"];
    if ([value isMemberOfClass:[NSNull class]] == NO)
    {
        self.email = value;
    }
    else
    {
        self.email = emptyString;
    }
}

@end
