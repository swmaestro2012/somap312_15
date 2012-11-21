//
//  RHSpotManager.m
//  RoughHandsFramework_Chat
//
//  Created by Sinhyub Kim on 10/25/12.
//  Copyright (c) 2012 Sinhyub Kim. All rights reserved.
//

@implementation SPSpotManager

@synthesize spotInfoList;

-(id) init
{
    if (self = [super init])
    {
        // Initialization code here
        if( spotInfoList == nil )
        {
            spotInfoList = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

-(void)insertSpot:(SPSpotInfo*)spotInfo
{
    NSAssert((spotInfo!=nil), @"nil spotInfo is pushed in");
    [self.spotInfoList addObject:spotInfo];
}

-(SPSpotInfo*)getSpotWithSpotID:(NSInteger)spotID
{
    NSAssert(spotID>=0, @"wrong spot id is requested" );
    
    SPSpotInfo* result = nil;
    for( SPSpotInfo* spotInfo in self.spotInfoList )
    {
        if( spotInfo.spotID == spotID )
        {
            result = spotInfo;
            break;
        }
    }
    return result;
}

-(void)removeSpotWithSpotInfo:(SPSpotInfo*)spotInfo
{
    NSAssert((spotInfo!=nil), @"nil spotInfo is requested to delete");
    [self.spotInfoList removeObject:spotInfo];
}

-(void)removeSpotWithSpotID:(NSInteger)spotID
{
    NSAssert(spotID>=0, @"wrong spot id is requested" );
    
    for( SPSpotInfo* spotInfo in self.spotInfoList )
    {
        if( spotInfo.spotID == spotID )
        {
            [self.spotInfoList removeObject:spotInfo];
            break;
        }
    }
}

@end
