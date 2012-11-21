//
//  SPSpotInfo.h
//  Spot
//
//  Created by Sinhyub Kim on 11/9/12.
//  Copyright (c) 2012 Sinhyub Kim. All rights reserved.
//

@interface SPSpotInfo : NSObject

@property                       NSInteger   spotID;
@property                       NSInteger   kingID;
@property                       NSInteger   queenID;
@property                       SPUserInfo*   kingUserInfo;
@property                       SPUserInfo*   queenUserInfo;
@property (strong, nonatomic)   NSString*   spotName;
@property (strong, nonatomic)   NSString*   description;
@property (strong, nonatomic)   NSString*   createdTime;
@property                       float       lat;
@property                       float       lng;
@property                       NSInteger   popularity;
@property                       BOOL        isPrivate;
@property                       BOOL        isPhysical;
@property                       float       price;

-(id) init;
-(id) initWithJSONDictionary:(NSDictionary*)jsonDictionary;
-(void) loadFromJSONDictionary:(NSDictionary*)jsonDictionary;

@end
