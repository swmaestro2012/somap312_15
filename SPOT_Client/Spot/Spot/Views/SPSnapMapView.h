//
//  SPSnapMapView.h
//  Spot
//
//  Created by Sinhyub Kim on 11/10/12.
//  Copyright (c) 2012 Sinhyub Kim. All rights reserved.
//

@interface SPSnapMapView : UIView

@property (weak, atomic)        SPSnapCellView* selectedSnapCellView;
@property (strong, nonatomic)   NSMutableArray* snapCellViewList;
@property (nonatomic)           NSInteger numRows;
@property (nonatomic)           NSInteger numColumns;


-(SPSnapCellView*)getSelectedSnapCellView:(CGPoint)selectingPoint;
-(SPSnapImageView*)getNextSnapImageView:(SnapImageDirection)direction UpdateSelected:(BOOL)willUpdate;

-(void)moveCellsWithOffset:(CGPoint)transition;
-(SPSnapImageView*)getSelectedSnapImageView:(CGPoint)selectingPoint;

-(void)addSnapCellViewWithCellInfo:(SPCellInfo*)cellInfo CellPosition:(CELL_POSITION)cellPosition;
-(void)loadWithCellInfoList:(NSMutableArray*)cellInfoList;

-(void)reloadWithCellInfoList:(NSMutableArray*)cellInfoList At:(SnapImageDirection)direction;

-(void)onViewMoveToNextCell:(SnapImageDirection)direction WithMove:(BOOL)willMove;
-(void)onViewMoveToNextCellFinished:(SnapImageDirection)direction;
-(void)removeAllSnapCells;

-(BOOL)canMoveToDirection:(SnapImageDirection)direction;

@end
