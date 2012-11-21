//
//  SPUserMapView.h
//  Spot
//
//  Created by Sinhyub Kim on 11/13/12.
//  Copyright (c) 2012 Sinhyub Kim. All rights reserved.
//

@interface SPUserMapView : SPSnapMapView
@property (nonatomic) NSInteger curCellX;
@property (nonatomic) NSInteger curCellY;
@property (nonatomic, strong) SPSpotInfo* spotInfo;


-(void)onViewMoveToNextCell:(SnapImageDirection)direction WithMove:(BOOL)willMove;
-(void)onViewMoveToNextCellFinished:(SnapImageDirection)direction;


@end
