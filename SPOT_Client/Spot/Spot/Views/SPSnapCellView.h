//
//  SPSnapCellView.h
//  Spot
//
//  Created by Sinhyub Kim on 11/10/12.
//  Copyright (c) 2012 Sinhyub Kim. All rights reserved.
//

#define CELL_ROWS 3
#define CELL_COLUMNS 3

typedef enum CELL_POSITION{
    CELL_POSITION_TOPLEFT = 0,
    CELL_POSITION_TOPCENTER = 1,
    CELL_POSITION_TOPRIGHT = 2,
    CELL_POSITION_LEFT = 3,
    CELL_POSITION_CENTER = 4,
    CELL_POSITION_RIGHT = 5,
    CELL_POSITION_BOTTOMLEFT = 6,
    CELL_POSITION_BOTTOMCENTER = 7,
    CELL_POSITION_BOTTOMRIGHT = 8,
    CELL_POSITION_MAX = 9,
} CELL_POSITION;


@interface SPSubCell : UIView
@property (strong, nonatomic)       NSMutableArray*     snapImageViewList;
@property (weak, nonatomic)         SPSnapImageView*    selectedSnapImageView;
@property (atomic)                  NSInteger           capacity;
@property (atomic)                  NSInteger           nextSnapImageIndex;
//@property (atomic)                  NSInteger           numAllocatedSnapImageViews;
@property (nonatomic)               NSInteger           popularity;
- (void)addSnapImage:(SPSnapInfo*)snapInfo;
- (void)removeAllSnapImageViews;
- (SPSnapImageView*)getSelectedSnapImageView:(CGPoint)selectingPoint;
- (SPSnapImageView*)getNextSnapImageView:(SnapImageDirection)direction UpdateSelected:(BOOL)willUpdate;
- (void)onDeselected;
@end



//#define MAX_SNAPIMAGE_NUM 16
#define MAX_CELL_CAPACITY 16
#define SNAP_CAPACITY_POPULARITY0 1
#define SNAP_CAPACITY_POPULARITY1 4

#define SNAPCELLVIEW_SUBCELL_ROWS 2
#define SNAPCELLVIEW_SUBCELL_COLUMNS 2
@interface SPSnapCellView : UIView
@property   (weak, nonatomic)       SPCellInfo*         cellInfo;
@property   (weak, atomic)          SPSubCell*          selectedSubCell;
@property   (atomic)                NSInteger           cellIndex;  //0~8
@property   (atomic)                NSInteger           cellCapacity;  //0~8
@property   (strong, nonatomic)     NSMutableArray*     subCellList;
@property   (atomic)                NSInteger           nextSubCellIndexToAddImage;
@property   (atomic)                BOOL                isValidCell;
@property   (nonatomic)             CELL_POSITION       cellPosition;

- (void)addSnapImage:(SPSnapInfo*)snapInfo;
- (void)removeAllSnapImageViews;
- (void)loadWithCellInfo:(SPCellInfo*)cellInfo_;
- (SPSnapImageView*)getSelectedSnapImageView:(CGPoint)selectingPoint;
- (SPSnapImageView*)getNextSnapImageView:(SnapImageDirection)direction UpdateSelected:(BOOL)willUpdate;
- (SPSnapImageView*)getSnapImageViewWithPosition:(SnapSubCellPosition)position UpdateSelected:(BOOL)willUpdate;
- (void)onDeselected;

@end
