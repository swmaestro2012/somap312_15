//
//  SPCommentInfo.h
//  Spot
//
//  Created by Sinhyub Kim on 11/17/12.
//  Copyright (c) 2012 Sinhyub Kim. All rights reserved.
//

@interface SPCommentInfo : NSObject

@property (strong, nonatomic) NSString* comment;
@property (strong, nonatomic) NSString* createdTime;
@property (nonatomic)   NSInteger commentID;
@property (nonatomic)   NSInteger snapID;
@property (nonatomic)   NSInteger spotID;
@property (nonatomic)   NSInteger userID;
@property (strong, nonatomic)   SPUserInfo* userInfo;


-(id) init;
-(id) initWithJSONDictionary:(NSDictionary*)jsonDictionary;
-(void) loadFromJSONDictionary:(NSDictionary*)jsonDictionary;


@end
