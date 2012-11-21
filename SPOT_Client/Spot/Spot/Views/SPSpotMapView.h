//
//  SPSpotMapView.h
//  Spot
//
//  Created by Sinhyub Kim on 11/12/12.
//  Copyright (c) 2012 Sinhyub Kim. All rights reserved.
//


@interface SPSpotMapView : SPSnapMapView

@property (nonatomic) NSInteger curCellX;
@property (nonatomic) NSInteger curCellY;
@property (nonatomic) BOOL  isPhysicalSpotMapView;

-(void)onViewMoveToNextCell:(SnapImageDirection)direction WithMove:(BOOL)willMove;
-(void)onViewMoveToNextCellFinished:(SnapImageDirection)direction;
@end
