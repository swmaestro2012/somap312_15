//
//  SPSpotMapView.m
//  Spot
//
//  Created by Sinhyub Kim on 11/12/12.
//  Copyright (c) 2012 Sinhyub Kim. All rights reserved.
//

@implementation SPSpotMapView

@synthesize curCellX;
@synthesize curCellY;
@synthesize isPhysicalSpotMapView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.curCellX = 0;
        self.curCellY = 0;
//        [self setBackgroundColor:[UIColor colorWithPatternImage:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_BACKGROUNDTEXTURE]]];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)onViewMoveToNextCell:(SnapImageDirection)direction WithMove:(BOOL)willMove
{
//    [super onViewMoveToNextCell:direction WithMove:willMove];
    [super onViewMoveToNextCell:direction WithMove:willMove];
    
}

-(void)onViewMoveToNextCellFinished:(SnapImageDirection)direction
{
    // super method move expired cells to the new direction
    [super onViewMoveToNextCellFinished:direction];
    
    // and load data of cells with new direction
    NSNumber* cellX = [NSNumber numberWithInteger:self.curCellX];
    NSNumber* cellY = [NSNumber numberWithInteger:self.curCellY];
    NSString* directionString = nil;
    switch (direction) {
        case DIR_RIGHT:
        {
            directionString = @"right";
            break;
        }
        case DIR_LEFT:
        {
            directionString = @"left";
            break;
        }
        case DIR_UP:
        {
            directionString = @"up";
            break;
        }
        case DIR_DOWN:
        {
            directionString = @"down";
            break;
        }
        default:
        {
            directionString = nil;
            break;
        }
    }
        
    NSMutableDictionary* appendDic = [[NSMutableDictionary alloc] init];
    [appendDic setObject:@"append" forKey:@"mode"];
    [appendDic setObject:cellX forKey:@"cell_x"];
    [appendDic setObject:cellY forKey:@"cell_y"];
    [appendDic setObject:directionString forKey:@"direction"];
    
    [[RHProtocolSender getInstance] getJSONFromURL:[NSURL URLWithString:self.isPhysicalSpotMapView?URL_PHYSICALSPOTMAP:URL_LOGICALSPOTMAP] WithJSON:appendDic Success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSLog(@"XY: %d, %d",self.curCellX, self.curCellY);
        NSLog(@"%@", directionString);
        int result = [[JSON valueForKey:@"success"] intValue];
        if( result == 0 )
        {
            // Error Handling
//            NSNumber* isFailed = [self.moveFailedDir objectAtIndex:direction];
            
//            [RHUtilities popUpErrorMessage:[JSON valueForKey:@"message"] WithParentViewController:nil];
            
            NSMutableArray* cellInfoList = [[NSMutableArray alloc] init];
            for( int i=0; i< CELL_POSITION_MAX; i++)
            {
                [cellInfoList addObject:[[NSNull alloc] init]];
            }
            [self reloadWithCellInfoList:cellInfoList At:direction];
            return;
        }
        
        // TO DO : add a selector as a parameter, to reload image views after finishing animation.
        //[super onViewMoveToNextCell:direction WithMove:willMove];
        
        switch (direction) {
            case DIR_RIGHT:
            {
                self.curCellX = self.curCellX+1;
                break;
            }
            case DIR_LEFT:
            {
                self.curCellX = self.curCellX-1;
                break;
            }
            case DIR_UP:
            {
                self.curCellY = self.curCellY-1;
                break;
            }
            case DIR_DOWN:
            {
                self.curCellY = self.curCellY+1;
                break;
            }
            default:
            {
                break;
            }
        }
        
        
        NSMutableDictionary* spotMapJSON = [JSON valueForKey:@"data"];
        
        NSLog(@"%@", spotMapJSON.description);
        
        NSMutableArray* cellInfoList = [[NSMutableArray alloc] init];
        
        NSMutableDictionary* cellInfoJSON = [spotMapJSON valueForKey:@"cell_0"];
        SPCellInfo* cellInfo = [[SPCellInfo alloc] initWithJSONDictionary:cellInfoJSON];
        [cellInfoList addObject:cellInfo];
        cellInfoJSON = [spotMapJSON valueForKey:@"cell_1"];
        if( [cellInfoJSON isMemberOfClass:[NSNull class]] == YES )
        {
            [cellInfoList addObject:[[NSNull alloc] init]];
        }
        else
        {
            cellInfo = [[SPCellInfo alloc] initWithJSONDictionary:cellInfoJSON];
            [cellInfoList addObject:cellInfo];
        }
        
        cellInfoJSON = [spotMapJSON valueForKey:@"cell_2"];
        if( [cellInfoJSON isMemberOfClass:[NSNull class]] == YES )
        {
            [cellInfoList addObject:[[NSNull alloc] init]];
        }
        else
        {
            cellInfo = [[SPCellInfo alloc] initWithJSONDictionary:cellInfoJSON];
            [cellInfoList addObject:cellInfo];
        }
        
        cellInfoJSON = [spotMapJSON valueForKey:@"cell_3"];
        if( [cellInfoJSON isMemberOfClass:[NSNull class]] == YES )
        {
            [cellInfoList addObject:[[NSNull alloc] init]];
        }
        else
        {
            cellInfo = [[SPCellInfo alloc] initWithJSONDictionary:cellInfoJSON];
            [cellInfoList addObject:cellInfo];
        }
        
        cellInfoJSON = [spotMapJSON valueForKey:@"cell_4"];
        if( [cellInfoJSON isMemberOfClass:[NSNull class]] == YES )
        {
            [cellInfoList addObject:[[NSNull alloc] init]];
        }
        else
        {
            cellInfo = [[SPCellInfo alloc] initWithJSONDictionary:cellInfoJSON];
            [cellInfoList addObject:cellInfo];
        }
        
        cellInfoJSON = [spotMapJSON valueForKey:@"cell_5"];
        if( [cellInfoJSON isMemberOfClass:[NSNull class]] == YES )
        {
            [cellInfoList addObject:[[NSNull alloc] init]];
        }
        else
        {
            cellInfo = [[SPCellInfo alloc] initWithJSONDictionary:cellInfoJSON];
            [cellInfoList addObject:cellInfo];
        }
        
        cellInfoJSON = [spotMapJSON valueForKey:@"cell_6"];
        if( [cellInfoJSON isMemberOfClass:[NSNull class]] == YES )
        {
            [cellInfoList addObject:[[NSNull alloc] init]];
        }
        else
        {
            cellInfo = [[SPCellInfo alloc] initWithJSONDictionary:cellInfoJSON];
            [cellInfoList addObject:cellInfo];
        }
        
        cellInfoJSON = [spotMapJSON valueForKey:@"cell_7"];
        if( [cellInfoJSON isMemberOfClass:[NSNull class]] == YES )
        {
            [cellInfoList addObject:[[NSNull alloc] init]];
        }
        else
        {
            cellInfo = [[SPCellInfo alloc] initWithJSONDictionary:cellInfoJSON];
            [cellInfoList addObject:cellInfo];
        }
        
        cellInfoJSON = [spotMapJSON valueForKey:@"cell_8"];
        if( [cellInfoJSON isMemberOfClass:[NSNull class]] == YES )
        {
            [cellInfoList addObject:[[NSNull alloc] init]];
        }
        else
        {
            cellInfo = [[SPCellInfo alloc] initWithJSONDictionary:cellInfoJSON];
            [cellInfoList addObject:cellInfo];
        }
        
        [self reloadWithCellInfoList:cellInfoList At:direction];
        
    } Failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [RHUtilities handleError:error WithParentViewController:nil];
    } TimeOut:10.0f];

}


@end
