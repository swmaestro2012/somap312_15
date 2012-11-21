//
//  RHSpotManager.h
//  RoughHandsFramework_Chat
//
//  Created by Sinhyub Kim on 10/25/12.
//  Copyright (c) 2012 Sinhyub Kim. All rights reserved.
//

@interface SPSpotManager : NSObject
@property (strong, nonatomic)   NSMutableArray* spotInfoList;

-(id)init;
-(void)insertSpot:(SPSpotInfo*)spotInfo;
-(SPSpotInfo*)getSpotWithSpotID:(NSInteger)spotID;
-(void)removeSpotWithSpotInfo:(SPSpotInfo*)spotInfo;
-(void)removeSpotWithSpotID:(NSInteger)spotID;


@end
