//
//  SPCellInfo.h
//  Spot
//
//  Created by Sinhyub Kim on 11/10/12.
//  Copyright (c) 2012 Sinhyub Kim. All rights reserved.
//

@interface SPCellInfo : NSObject

@property (nonatomic)           NSInteger   mapX;
@property (nonatomic)           NSInteger   mapY;
@property (nonatomic)           float       startLng;
@property (nonatomic)           float       endLng;
@property (nonatomic)           float       startLat;
@property (nonatomic)           float       endLat;
@property (strong, nonatomic)   NSMutableArray*    postList;

-(id) init;
-(id) initWithJSONDictionary:(NSDictionary*)jsonDictionary;
-(void) loadFromJSONDictionary:(NSDictionary*)jsonDictionary;


@end
