//
//  SPUserProfileInfo.h
//  Spot
//
//  Created by Sinhyub Kim on 11/9/12.
//  Copyright (c) 2012 Sinhyub Kim. All rights reserved.
//


@interface SPUserProfileInfo : NSObject

@property (strong, nonatomic)   SPUserInfo*         userInfo;
@property (strong, nonatomic)   NSMutableArray*     snapList;
@property (strong, nonatomic)   NSMutableArray*     logicalSpotList;
@property (strong, nonatomic)   NSMutableArray*     physicalSpotList;

-(id) init;
-(id) initWithJSONDictionary:(NSDictionary*)jsonDictionary;
-(void) loadFromJSONDictionary:(NSDictionary*)jsonDictionary;



@end
