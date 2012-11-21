//
//  SPSnapInfo.h
//  Spot
//
//  Created by Sinhyub Kim on 11/9/12.
//  Copyright (c) 2012 Sinhyub Kim. All rights reserved.
//


@interface SPSnapInfo : NSObject

@property (nonatomic)           NSInteger   snapID;
@property (nonatomic)           NSInteger   imageID;
@property (nonatomic)           NSInteger   spotID;
@property (nonatomic)           NSInteger   userID;
@property (strong, nonatomic)   NSString*   snaptime;
@property (strong, nonatomic)   NSString*   description;
@property (nonatomic)           float       lat;
@property (nonatomic)           float       lng;
@property (nonatomic)           NSInteger   popularity;
@property (strong, nonatomic)   NSString*   userName;
@property (strong, nonatomic)   NSString*   spotName;
@property (nonatomic)           BOOL        isLiked;


-(id) init;
-(id) initWithJSONDictionary:(NSDictionary*)jsonDictionary;
-(void) loadFromJSONDictionary:(NSDictionary*)jsonDictionary;


@end
