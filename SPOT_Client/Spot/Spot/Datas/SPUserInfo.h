//
//  SPUserInfo.h
//  Spot
//
//  Created by Sinhyub Kim on 11/9/12.
//  Copyright (c) 2012 Sinhyub Kim. All rights reserved.
//


@interface SPUserInfo : NSObject

@property (nonatomic)           NSInteger userID;
@property (strong, nonatomic)   NSString* birthday;
@property (strong, nonatomic)   NSString* description;
@property (strong, nonatomic)   NSString* email;
@property (strong, nonatomic)   NSString* facebook;
@property (strong, nonatomic)   NSString* gender;
@property (strong, nonatomic)   NSString* homepage;
@property (strong, nonatomic)   NSString* nickname;
@property (strong, nonatomic)   NSString* phoneNumber;
@property (strong, nonatomic)   NSString* workplace;


-(id) init;
-(id) initWithJSONDictionary:(NSDictionary*)jsonDictionary;
-(void) loadFromJSONDictionary:(NSDictionary*)jsonDictionary;

@end
