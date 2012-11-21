//
//  SPSnapMapView.m
//  Spot
//
//  Created by Sinhyub Kim on 11/10/12.
//  Copyright (c) 2012 Sinhyub Kim. All rights reserved.
//


@implementation SPSnapMapView
@synthesize selectedSnapCellView;
@synthesize snapCellViewList;
@synthesize numRows;
@synthesize numColumns;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
//        [self setBackgroundColor:[UIColor blackColor]];
        [self setBackgroundColor:[UIColor colorWithPatternImage:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_BACKGROUNDTEXTURE]]];
        
        numRows = CELL_ROWS;
        numColumns = CELL_COLUMNS;
        selectedSnapCellView = nil;
        if( snapCellViewList == nil )
        {
            NSAssert( CELL_ROWS*CELL_COLUMNS == CELL_POSITION_MAX, @"Error on Initializing Cell Map, Number Of Cells");
            snapCellViewList = [[NSMutableArray alloc] initWithCapacity:CELL_POSITION_MAX];
        }
        
        for( int i=0; i<numRows*numColumns; ++i )
        {
            [snapCellViewList addObject:[[SPSnapCellView alloc] init]];
        }
        
        for( int curRow=0; curRow<numRows; ++curRow )
        {
            for( int curColumn=0; curColumn<numColumns; ++curColumn )
            {
                CGRect curCellFrame = CGRectMake( (curColumn-1)*CELL_FRAME_WIDTH, (curRow-1)*CELL_FRAME_HEIGHT, CELL_FRAME_WIDTH, CELL_FRAME_HEIGHT );
                NSLog(@"%f %f %f %f", curCellFrame.origin.x, curCellFrame.origin.y, curCellFrame.size.width, curCellFrame.size.height);
                SPSnapCellView* snapCellView = [snapCellViewList objectAtIndex:curRow*numColumns+curColumn];
                [snapCellView setFrame:curCellFrame];
                snapCellView.cellPosition = curRow*numColumns+curColumn;
                [self addSubview:snapCellView];
            }
        }
        
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


-(SPSnapCellView*)getSelectedSnapCellView:(CGPoint)selectingPoint
{
    selectingPoint.x = selectingPoint.x - self.frame.origin.x;
    selectingPoint.y = selectingPoint.y - self.frame.origin.y;

    NSAssert(self.snapCellViewList!=nil, @"snap cell view list doens't initialized");

    self.selectedSnapCellView = nil;
    for( SPSnapCellView* cellView in self.snapCellViewList )
    {
        if( CGRectContainsPoint(cellView.frame, selectingPoint) == YES )
        {
            self.selectedSnapCellView = cellView;
        }
        else
        {
            [cellView onDeselected];
        }
    }
    return self.selectedSnapCellView;
}

-(SPSnapImageView*)getNextSnapImageView:(SnapImageDirection)direction UpdateSelected:(BOOL)willUpdate;
{
    SPSnapCellView* selectedSnapCell = self.selectedSnapCellView;
    NSInteger selectedSubCellIndex = [selectedSnapCell.subCellList indexOfObject:selectedSnapCell.selectedSubCell];
    NSInteger nextSubCellIndex=0;
    
    SPSnapImageView* nextSnapImageView = [selectedSnapCell getNextSnapImageView:direction UpdateSelected:willUpdate];
    if( nextSnapImageView != nil )
    {
        return nextSnapImageView;
    }
    
    if( [self canMoveToDirection:direction] == NO )
    {
        return nil;
    }
    
    // Inspect Next Cell ( Moving Cell To Next )    
    NSInteger selectedIndex = [self.snapCellViewList indexOfObject:selectedSnapCell];
    NSInteger nextCellIndex = -1;
    switch (direction) {
        case DIR_RIGHT:
            if(selectedIndex==CELL_POSITION_TOPRIGHT
               ||selectedIndex==CELL_POSITION_BOTTOMRIGHT
               ||selectedIndex==CELL_POSITION_RIGHT)
            {
                nextCellIndex = -1;
            }
            else
            {
                nextCellIndex = (selectedIndex+1); // selectedIndex+1;
                nextSubCellIndex = selectedSubCellIndex-1;
            }
            break;
        case DIR_LEFT:
            if(selectedIndex==CELL_POSITION_TOPLEFT
               ||selectedIndex==CELL_POSITION_BOTTOMLEFT
               ||selectedIndex==CELL_POSITION_LEFT)
            {
                nextCellIndex = -1;
            }
            else
            {
                nextCellIndex = (selectedIndex-1); // selectedIndex-1;
                nextSubCellIndex = selectedSubCellIndex+1;
            }
            break;
        case DIR_DOWN:
            if(selectedIndex==CELL_POSITION_BOTTOMCENTER
               ||selectedIndex==CELL_POSITION_BOTTOMRIGHT
               ||selectedIndex==CELL_POSITION_BOTTOMLEFT)
            {
                nextCellIndex = -1;
            }
            else
            {
                nextCellIndex = (selectedIndex+self.numColumns); //selectedIndex+self.numColumns;
                nextSubCellIndex = selectedSubCellIndex-SNAPCELLVIEW_SUBCELL_COLUMNS;
            }
            break;
        case DIR_UP:
            if(selectedIndex==CELL_POSITION_TOPRIGHT
               ||selectedIndex==CELL_POSITION_TOPLEFT
               ||selectedIndex==CELL_POSITION_TOPCENTER)
            {
                nextCellIndex = -1;
            }
            else
            {
                nextCellIndex = (selectedIndex-self.numColumns); //selectedIndex-self.numColumns;
                nextSubCellIndex = selectedSubCellIndex+SNAPCELLVIEW_SUBCELL_COLUMNS;
            }
            break;
        default:
            NSAssert(NO, @"Wrong Direction");
            break;
    }
    
//    NSAssert( (nextCellIndex>=0) && (nextCellIndex<CELL_POSITION_MAX) , @"error to find next cell, We Had To Load New Cell to the Direction");
    if( nextCellIndex<0 || (nextCellIndex>=CELL_POSITION_MAX) )
    {
        if( willUpdate == YES )
            self.selectedSnapCellView = nil;
        return nil;
    }
    selectedSnapCell = [self.snapCellViewList objectAtIndex:nextCellIndex];
    if( willUpdate == YES)
    {
        [self onViewMoveToNextCell:direction WithMove:YES];
        self.selectedSnapCellView = selectedSnapCell;
    }

    nextSnapImageView = [selectedSnapCell getSnapImageViewWithPosition:nextSubCellIndex UpdateSelected:willUpdate];
    return nextSnapImageView;
}

-(void)moveCellsWithOffset:(CGPoint)transition
{
    for( SPSnapCellView* snapCellView in self.snapCellViewList )
    {
        CGRect newFrame = snapCellView.frame;
        newFrame.origin.x += transition.x;
        newFrame.origin.y += transition.y;
        [snapCellView setFrame:newFrame];
    }
}

-(SPSnapImageView*)getSelectedSnapImageView:(CGPoint)selectingPoint
{
    SPSnapCellView* snapCellView = [self getSelectedSnapCellView:selectingPoint];
    if( snapCellView == nil )
        return nil;
    
    SPSnapImageView* selectedSnapImageView = [snapCellView getSelectedSnapImageView:selectingPoint];
    
    return selectedSnapImageView;
}

-(void)onViewMoveToNextCell:(SnapImageDirection)direction WithMove:(BOOL)willMove
{
    if( [self canMoveToDirection:direction] == NO )
        return;
    
    if( willMove == YES )
    {
        // Move Views
        CGPoint moveOffset;
        switch (direction) {
            case DIR_LEFT:
                moveOffset = CGPointMake(CELL_FRAME_WIDTH, 0.f);
                break;
            case DIR_RIGHT:
                moveOffset = CGPointMake(-CELL_FRAME_WIDTH, 0.f);
                break;
            case DIR_DOWN:
                moveOffset = CGPointMake(0.f, -CELL_FRAME_HEIGHT);
                break;
            case DIR_UP:
                moveOffset = CGPointMake(0.f, CELL_FRAME_HEIGHT);
                break;
            default:
                moveOffset = CGPointMake(0.f,0.f);
                break;
        }
        
        [UIView animateWithDuration:0.2f animations:^{
            for( SPSnapCellView* snapCellView in self.snapCellViewList )
            {
                CGRect newFrame = CGRectMake(snapCellView.frame.origin.x+moveOffset.x,
                                             snapCellView.frame.origin.y+moveOffset.y,
                                             snapCellView.frame.size.width,
                                             snapCellView.frame.size.height);
                [snapCellView setFrame:newFrame];
            }
        } completion:^(BOOL finished) {
            [self onViewMoveToNextCellFinished:direction];
        }];
    }
    else
    {
        [self onViewMoveToNextCellFinished:direction];
    }
    
}

-(void)onViewMoveToNextCellFinished:(SnapImageDirection)direction
{
    // Load Append Views with JSON Cell Data
    
    // Do Nothing
    // when subclassing this as a parent class
    // you have to Implement this block with reloading image views with spotInfos
    // Load Append Views (animation)
    SPSnapCellView* cellTOPLEFT = [self.snapCellViewList objectAtIndex:CELL_POSITION_TOPLEFT];
    SPSnapCellView* cellTOPCENTER = [self.snapCellViewList objectAtIndex:CELL_POSITION_TOPCENTER];
    SPSnapCellView* cellTOPRIGHT = [self.snapCellViewList objectAtIndex:CELL_POSITION_TOPRIGHT];
    SPSnapCellView* cellLEFT = [self.snapCellViewList objectAtIndex:CELL_POSITION_LEFT];
    SPSnapCellView* cellCENTER = [self.snapCellViewList objectAtIndex:CELL_POSITION_CENTER];
    SPSnapCellView* cellRIGHT = [self.snapCellViewList objectAtIndex:CELL_POSITION_RIGHT];
    SPSnapCellView* cellBOTTOMLEFT = [self.snapCellViewList objectAtIndex:CELL_POSITION_BOTTOMLEFT];
    SPSnapCellView* cellBOTTOMCENTER = [self.snapCellViewList objectAtIndex:CELL_POSITION_BOTTOMCENTER];
    SPSnapCellView* cellBOTTOMRIGHT = [self.snapCellViewList objectAtIndex:CELL_POSITION_BOTTOMRIGHT];
    
    switch (direction) {
        case DIR_RIGHT:
        {
            // move left
            [self.snapCellViewList setObject:cellTOPCENTER atIndexedSubscript:CELL_POSITION_TOPLEFT];
            [self.snapCellViewList setObject:cellTOPRIGHT atIndexedSubscript:CELL_POSITION_TOPCENTER];
            [self.snapCellViewList setObject:cellCENTER atIndexedSubscript:CELL_POSITION_LEFT];
            [self.snapCellViewList setObject:cellRIGHT atIndexedSubscript:CELL_POSITION_CENTER];
            [self.snapCellViewList setObject:cellBOTTOMCENTER atIndexedSubscript:CELL_POSITION_BOTTOMLEFT];
            [self.snapCellViewList setObject:cellBOTTOMRIGHT atIndexedSubscript:CELL_POSITION_BOTTOMCENTER];
            // append            
            [cellTOPLEFT setFrame:CGRectMake(cellTOPRIGHT.frame.origin.x+CELL_FRAME_WIDTH,
                                             cellTOPRIGHT.frame.origin.y,
                                             CELL_FRAME_WIDTH, CELL_FRAME_HEIGHT)];
            [cellLEFT setFrame:CGRectMake(cellRIGHT.frame.origin.x+CELL_FRAME_WIDTH,
                                          cellRIGHT.frame.origin.y,
                                          CELL_FRAME_WIDTH, CELL_FRAME_HEIGHT)];
            [cellBOTTOMLEFT setFrame:CGRectMake(cellBOTTOMRIGHT.frame.origin.x+CELL_FRAME_WIDTH,
                                                cellBOTTOMRIGHT.frame.origin.y,
                                                CELL_FRAME_WIDTH, CELL_FRAME_HEIGHT)];
            
            [self.snapCellViewList setObject:cellTOPLEFT atIndexedSubscript:CELL_POSITION_TOPRIGHT];
            [self.snapCellViewList setObject:cellLEFT atIndexedSubscript:CELL_POSITION_RIGHT];
            [self.snapCellViewList setObject:cellBOTTOMLEFT atIndexedSubscript:CELL_POSITION_BOTTOMRIGHT];
            break;
        }
        case DIR_LEFT:
        {
            // move right
            [self.snapCellViewList setObject:cellTOPCENTER atIndexedSubscript:CELL_POSITION_TOPRIGHT];
            [self.snapCellViewList setObject:cellTOPLEFT atIndexedSubscript:CELL_POSITION_TOPCENTER];
            [self.snapCellViewList setObject:cellCENTER atIndexedSubscript:CELL_POSITION_RIGHT];
            [self.snapCellViewList setObject:cellLEFT atIndexedSubscript:CELL_POSITION_CENTER];
            [self.snapCellViewList setObject:cellBOTTOMCENTER atIndexedSubscript:CELL_POSITION_BOTTOMRIGHT];
            [self.snapCellViewList setObject:cellBOTTOMLEFT atIndexedSubscript:CELL_POSITION_BOTTOMCENTER];
            // append
            [cellTOPRIGHT setFrame:CGRectMake(cellTOPLEFT.frame.origin.x-CELL_FRAME_WIDTH,
                                              cellTOPLEFT.frame.origin.y,
                                              CELL_FRAME_WIDTH, CELL_FRAME_HEIGHT)];
            [cellRIGHT setFrame:CGRectMake(cellLEFT.frame.origin.x-CELL_FRAME_WIDTH,
                                           cellLEFT.frame.origin.y,
                                           CELL_FRAME_WIDTH, CELL_FRAME_HEIGHT)];
            [cellBOTTOMRIGHT setFrame:CGRectMake(cellBOTTOMLEFT.frame.origin.x-CELL_FRAME_WIDTH,
                                                 cellBOTTOMLEFT.frame.origin.y,
                                                 CELL_FRAME_WIDTH, CELL_FRAME_HEIGHT)];
            [self.snapCellViewList setObject:cellTOPRIGHT atIndexedSubscript:CELL_POSITION_TOPLEFT];
            [self.snapCellViewList setObject:cellRIGHT atIndexedSubscript:CELL_POSITION_LEFT];
            [self.snapCellViewList setObject:cellBOTTOMRIGHT atIndexedSubscript:CELL_POSITION_BOTTOMLEFT];
            break;
        }
            
        case DIR_DOWN:
        {
            // move up
            [self.snapCellViewList setObject:cellLEFT atIndexedSubscript:CELL_POSITION_TOPLEFT];
            [self.snapCellViewList setObject:cellCENTER atIndexedSubscript:CELL_POSITION_TOPCENTER];
            [self.snapCellViewList setObject:cellRIGHT atIndexedSubscript:CELL_POSITION_TOPRIGHT];
            [self.snapCellViewList setObject:cellBOTTOMLEFT atIndexedSubscript:CELL_POSITION_LEFT];
            [self.snapCellViewList setObject:cellBOTTOMCENTER atIndexedSubscript:CELL_POSITION_CENTER];
            [self.snapCellViewList setObject:cellBOTTOMRIGHT atIndexedSubscript:CELL_POSITION_RIGHT];
            // append
            [cellTOPLEFT setFrame:CGRectMake(cellBOTTOMLEFT.frame.origin.x,
                                             cellBOTTOMLEFT.frame.origin.y+CELL_FRAME_HEIGHT,
                                             CELL_FRAME_WIDTH, CELL_FRAME_HEIGHT)];
            [cellTOPCENTER setFrame:CGRectMake(cellBOTTOMCENTER.frame.origin.x,
                                               cellBOTTOMCENTER.frame.origin.y+CELL_FRAME_HEIGHT,
                                               CELL_FRAME_WIDTH, CELL_FRAME_HEIGHT)];
            [cellTOPRIGHT setFrame:CGRectMake(cellBOTTOMRIGHT.frame.origin.x,
                                              cellBOTTOMRIGHT.frame.origin.y+CELL_FRAME_HEIGHT,
                                              CELL_FRAME_WIDTH, CELL_FRAME_HEIGHT)];
            [self.snapCellViewList setObject:cellTOPLEFT atIndexedSubscript:CELL_POSITION_BOTTOMLEFT];
            [self.snapCellViewList setObject:cellTOPCENTER atIndexedSubscript:CELL_POSITION_BOTTOMCENTER];
            [self.snapCellViewList setObject:cellTOPRIGHT atIndexedSubscript:CELL_POSITION_BOTTOMRIGHT];
            break;
        }
        case DIR_UP:
        {
            // move down
            [self.snapCellViewList setObject:cellTOPLEFT atIndexedSubscript:CELL_POSITION_LEFT];
            [self.snapCellViewList setObject:cellTOPCENTER atIndexedSubscript:CELL_POSITION_CENTER];
            [self.snapCellViewList setObject:cellTOPRIGHT atIndexedSubscript:CELL_POSITION_RIGHT];
            [self.snapCellViewList setObject:cellLEFT atIndexedSubscript:CELL_POSITION_BOTTOMLEFT];
            [self.snapCellViewList setObject:cellCENTER atIndexedSubscript:CELL_POSITION_BOTTOMCENTER];
            [self.snapCellViewList setObject:cellRIGHT atIndexedSubscript:CELL_POSITION_BOTTOMRIGHT];
            // append
            [cellBOTTOMLEFT setFrame:CGRectMake(cellTOPLEFT.frame.origin.x,
                                                cellTOPLEFT.frame.origin.y-CELL_FRAME_HEIGHT,
                                                CELL_FRAME_WIDTH, CELL_FRAME_HEIGHT)];
            [cellBOTTOMCENTER setFrame:CGRectMake(cellTOPCENTER.frame.origin.x,
                                                  cellTOPCENTER.frame.origin.y-CELL_FRAME_HEIGHT,
                                                  CELL_FRAME_WIDTH, CELL_FRAME_HEIGHT)];
            [cellBOTTOMRIGHT setFrame:CGRectMake(cellTOPRIGHT.frame.origin.x,
                                                 cellTOPRIGHT.frame.origin.y-CELL_FRAME_HEIGHT,
                                                 CELL_FRAME_WIDTH, CELL_FRAME_HEIGHT)];
            [self.snapCellViewList setObject:cellBOTTOMLEFT atIndexedSubscript:CELL_POSITION_TOPLEFT];
            [self.snapCellViewList setObject:cellBOTTOMCENTER atIndexedSubscript:CELL_POSITION_TOPCENTER];
            [self.snapCellViewList setObject:cellBOTTOMRIGHT atIndexedSubscript:CELL_POSITION_TOPRIGHT];
            break;
        }
        default:
            break;
    }

}

-(void)addSnapCellViewWithCellInfo:(SPCellInfo*)cellInfo CellPosition:(CELL_POSITION)cellPosition
{
    SPSnapCellView* cellView = [snapCellViewList objectAtIndex:cellPosition];
    NSAssert(cellView != nil, @"add snap cell view before initialize snap map view");
    
    [cellView loadWithCellInfo:cellInfo];
}

-(void)loadWithCellInfoList:(NSMutableArray*)cellInfoList
{
    NSAssert(cellInfoList.count == CELL_POSITION_MAX, @"inappropriate cell info list. check the size of it");
    NSInteger cellPosition = CELL_POSITION_TOPLEFT;
    for( SPCellInfo* cellInfo in cellInfoList )
    {
//        NSAssert([cellInfo isMemberOfClass:[SPCellInfo class]] == YES, @"inappropriate cell info list. check the type of it");
        if( [cellInfo isMemberOfClass:[NSNull class]]==NO )
        {
            NSLog(@"%d", cellInfo.postList.count);
        }
        [self addSnapCellViewWithCellInfo:cellInfo CellPosition:cellPosition++];
        
    }
}

-(void)reloadWithCellInfoList:(NSMutableArray*)cellInfoList At:(SnapImageDirection)direction
{
    if( direction == DIR_RIGHT )
    {
        SPSnapCellView* cellTopRight = [self.snapCellViewList objectAtIndex:CELL_POSITION_TOPRIGHT];
        SPSnapCellView* cellRight = [self.snapCellViewList objectAtIndex:CELL_POSITION_RIGHT];
        SPSnapCellView* cellBottomRight = [self.snapCellViewList objectAtIndex:CELL_POSITION_BOTTOMRIGHT];
        
        [cellTopRight removeAllSnapImageViews];
        [cellRight removeAllSnapImageViews];
        [cellBottomRight removeAllSnapImageViews];
        
        [cellTopRight loadWithCellInfo:[cellInfoList objectAtIndex:CELL_POSITION_TOPRIGHT]];
        [cellRight loadWithCellInfo:[cellInfoList objectAtIndex:CELL_POSITION_RIGHT]];
        [cellBottomRight loadWithCellInfo:[cellInfoList objectAtIndex:CELL_POSITION_BOTTOMRIGHT]];
    }
    else if( direction == DIR_LEFT )
    {
        SPSnapCellView* cellTopLeft = [self.snapCellViewList objectAtIndex:CELL_POSITION_TOPLEFT];
        SPSnapCellView* cellLeft = [self.snapCellViewList objectAtIndex:CELL_POSITION_LEFT];
        SPSnapCellView* cellBottomLeft = [self.snapCellViewList objectAtIndex:CELL_POSITION_BOTTOMLEFT];

        [cellTopLeft removeAllSnapImageViews];
        [cellLeft removeAllSnapImageViews];
        [cellBottomLeft removeAllSnapImageViews];
        
        [cellTopLeft loadWithCellInfo:[cellInfoList objectAtIndex:CELL_POSITION_TOPLEFT]];
        [cellLeft loadWithCellInfo:[cellInfoList objectAtIndex:CELL_POSITION_LEFT]];
        [cellBottomLeft loadWithCellInfo:[cellInfoList objectAtIndex:CELL_POSITION_BOTTOMLEFT]];
    }
    else if( direction == DIR_DOWN )
    {
        SPSnapCellView* cellBottomLeft = [self.snapCellViewList objectAtIndex:CELL_POSITION_BOTTOMLEFT];
        SPSnapCellView* cellBottomCenter = [self.snapCellViewList objectAtIndex:CELL_POSITION_BOTTOMCENTER];
        SPSnapCellView* cellBottomRight= [self.snapCellViewList objectAtIndex:CELL_POSITION_BOTTOMRIGHT];
        
        [cellBottomLeft removeAllSnapImageViews];
        [cellBottomCenter removeAllSnapImageViews];
        [cellBottomRight removeAllSnapImageViews];

        [cellBottomLeft loadWithCellInfo:[cellInfoList objectAtIndex:CELL_POSITION_BOTTOMLEFT]];
        [cellBottomCenter loadWithCellInfo:[cellInfoList objectAtIndex:CELL_POSITION_BOTTOMCENTER]];
        [cellBottomRight loadWithCellInfo:[cellInfoList objectAtIndex:CELL_POSITION_BOTTOMRIGHT]];
    }
    else if( direction == DIR_UP )
    {
        SPSnapCellView* cellTopLeft = [self.snapCellViewList objectAtIndex:CELL_POSITION_TOPLEFT];
        SPSnapCellView* cellTopCenter = [self.snapCellViewList objectAtIndex:CELL_POSITION_TOPCENTER];
        SPSnapCellView* cellTopRight = [self.snapCellViewList objectAtIndex:CELL_POSITION_TOPRIGHT];

        [cellTopLeft removeAllSnapImageViews];
        [cellTopCenter removeAllSnapImageViews];
        [cellTopRight removeAllSnapImageViews];
        
        [cellTopLeft loadWithCellInfo:[cellInfoList objectAtIndex:CELL_POSITION_TOPLEFT]];
        [cellTopCenter loadWithCellInfo:[cellInfoList objectAtIndex:CELL_POSITION_TOPCENTER]];
        [cellTopRight loadWithCellInfo:[cellInfoList objectAtIndex:CELL_POSITION_TOPRIGHT]];
    }
    
}

-(void)removeAllSnapCells
{
    for( SPSnapCellView* snapCellView in self.snapCellViewList )
    {
        [snapCellView removeAllSnapImageViews];
    }
}

-(BOOL)canMoveToDirection:(SnapImageDirection)direction
{
    SPSnapCellView* snapCellView = nil;
    switch (direction) {
        case DIR_RIGHT:
        {
            snapCellView = [self.snapCellViewList objectAtIndex:CELL_POSITION_RIGHT];
            break;
        }
        case DIR_LEFT:
        {
            snapCellView = [self.snapCellViewList objectAtIndex:CELL_POSITION_LEFT];
            break;
        }
        case DIR_UP:
        {
            snapCellView = [self.snapCellViewList objectAtIndex:CELL_POSITION_TOPCENTER];
            break;
        }
        case DIR_DOWN:
        {
            snapCellView = [self.snapCellViewList objectAtIndex:CELL_POSITION_BOTTOMCENTER];
            break;
        }
        default:
            break;
    }
    return snapCellView.isValidCell;
}

@end
