//
//  SPSnapCellView.m
//  Spot
//
//  Created by Sinhyub Kim on 11/10/12.
//  Copyright (c) 2012 Sinhyub Kim. All rights reserved.
//

@implementation SPSubCell
@synthesize snapImageViewList;
@synthesize selectedSnapImageView;
@synthesize capacity;
@synthesize nextSnapImageIndex;
//@synthesize numAllocatedSnapImageViews;
@synthesize popularity;
-(id) init
{
    self = [super init];
    if( self )
    {
        snapImageViewList = [[NSMutableArray alloc] init];
        capacity = 0;
        nextSnapImageIndex = 0;
        popularity = 1;
    }
    return self;
}

-(void) addSnapImage:(SPSnapInfo*)snapInfo
{
    if( self.nextSnapImageIndex == 0)
    {
        //determine type of imageview (frame size) by popularity
        if( snapInfo == nil )
            self.popularity = 1;
        else
            self.popularity = snapInfo.popularity;
    }
    else{
        NSAssert( self.popularity == snapInfo.popularity, @"WRONG Popularity of snap is added to subcell");
    }
    
    if( snapInfo == nil )
    {
        return;
    }
    
    NSInteger newSnapImageIndex = self.nextSnapImageIndex++;
    
    SPSnapImageView* newImageView = [[SPSnapImageView alloc] init];
    [self.snapImageViewList addObject:newImageView];

    // Set Frame Size
    if( self.popularity >= 1)
    {
        // NORMAL SIZE OF SNAP (subcell contains just one image)
        [newImageView setFrame:CGRectMake(0.f,0.f,SNAP_CLASS1_WIDTH,SNAP_CLASS1_HEIGHT)];
        self.capacity += SNAP_CAPACITY_POPULARITY1;
    }
    else
    {
        // HARF SIZE OF NORMAL SNAP
        [newImageView setFrame:CGRectMake((newSnapImageIndex%2)*SNAP_CLASS2_WIDTH,(newSnapImageIndex/2)*SNAP_CLASS2_HEIGHT,
                                          SNAP_CLASS2_WIDTH,SNAP_CLASS2_HEIGHT)];
        self.capacity += SNAP_CAPACITY_POPULARITY0;
    }
    
    [newImageView setSnapInfo:snapInfo];

    NSString* imageURL = [[NSString alloc] initWithFormat:URL_IMAGE, snapInfo.imageID];
    [[RHProtocolSender getInstance] getImageFromURL:[NSURL URLWithString:imageURL] WithImageView:newImageView.imageView WithJSON:nil WithPlaceholder:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_PLACEHHOLDER] Success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
     {
         [newImageView setNeedsDisplay];
     } Failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)
     {
         
     } TimeOut:10.0f];

    [self addSubview:newImageView];
}

-(void) removeAllSnapImageViews
{
    self.capacity = 0;
    self.nextSnapImageIndex=0;
    self.selectedSnapImageView = 0;
    for( SPSnapImageView* snapImageView in self.snapImageViewList )
    {
        [snapImageView.imageView setImage:nil];
        [snapImageView removeFromSuperview];
        [snapImageView setSnapInfo:nil];
    }
    [self.snapImageViewList removeAllObjects];
}

- (SPSnapImageView*)getSelectedSnapImageView:(CGPoint)selectingPoint
{
    selectingPoint.x = selectingPoint.x - self.frame.origin.x;
    selectingPoint.y = selectingPoint.y - self.frame.origin.y;
    
    for( SPSnapImageView* snapImageView in self.snapImageViewList )
    {
        if( CGRectContainsPoint(snapImageView.frame, selectingPoint)==YES )
        {
            self.selectedSnapImageView = snapImageView;
            return snapImageView;
        }
    }
    
    return nil;
}

-(SPSnapImageView*)getNextSnapImageView:(SnapImageDirection)direction UpdateSelected:(BOOL)willUpdate
{
    SPSnapImageView* selectedSnapImage = self.selectedSnapImageView;
    if( direction == DIR_NONE )
    {
        // return first SnapImage
        if( 0 >= self.nextSnapImageIndex )
        {
            self.selectedSnapImageView = nil;
            return nil;
        }
        selectedSnapImage = [self.snapImageViewList objectAtIndex:0];
        if( willUpdate == YES )
            self.selectedSnapImageView = selectedSnapImage;
        return selectedSnapImage;
    }
    
    if( self.popularity >= 1 )
    {
        if( willUpdate )
        {
            [self onDeselected];
            self.selectedSnapImageView = nil;
        }
        return nil;
    }

    NSInteger selectedIndex = [self.snapImageViewList indexOfObject:selectedSnapImage];
    NSInteger nextIndex = 0;
    
    switch (direction) {
        case DIR_RIGHT:
            if( selectedIndex == POSITION_BOTTOMRIGHT || selectedIndex == POSITION_TOPRIGHT )
                nextIndex = -1;
            else
                nextIndex = selectedIndex+1;
            break;
        case DIR_LEFT:
            if( selectedIndex == POSITION_BOTTOMLEFT || selectedIndex == POSITION_TOPLEFT )
                nextIndex = -1;
            else
                nextIndex = selectedIndex-1;
            break;
        case DIR_DOWN:
            if( selectedIndex == POSITION_BOTTOMLEFT || selectedIndex == POSITION_BOTTOMRIGHT )
                nextIndex = -1;
            else
                nextIndex = selectedIndex+2;
            break;
        case DIR_UP:
            if( selectedIndex == POSITION_TOPLEFT || selectedIndex == POSITION_TOPRIGHT )
                nextIndex = -1;
            else
                nextIndex = selectedIndex-2;
            break;
        default:
            NSAssert(NO, @"invalid Direction");
            break;
    }
    
    if( (nextIndex<0) || (nextIndex>=self.nextSnapImageIndex ))
    {
        if( willUpdate == YES )
        {
            [self onDeselected];
            self.selectedSnapImageView = nil;
        }
        return nil;
    }
    
    selectedSnapImage = [self.snapImageViewList objectAtIndex:nextIndex];
    if( willUpdate == YES)
        self.selectedSnapImageView = selectedSnapImage;
    
    return selectedSnapImage;
}

-(void)onDeselected
{
    self.selectedSnapImageView = nil;
}

@end

@implementation SPSnapCellView
@synthesize cellInfo;
@synthesize selectedSubCell;
@synthesize cellIndex;
@synthesize cellCapacity;
@synthesize subCellList;
@synthesize nextSubCellIndexToAddImage;
@synthesize cellPosition;
@synthesize isValidCell;

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self)
    {
        NSLog(@"%f, %f, %d, %d", frame.origin.x, frame.origin.y, CELL_FRAME_WIDTH, CELL_FRAME_HEIGHT);
        [self setFrame:CGRectMake(frame.origin.x, frame.origin.y, CELL_FRAME_WIDTH, CELL_FRAME_HEIGHT)];
        
        
        cellInfo = nil;
        selectedSubCell = nil;
        cellIndex = 0;
        cellCapacity = 0;
       // nextSubCellIndexToAddImage = 0;
        if( subCellList == nil )
        {
            subCellList = [[NSMutableArray alloc]initWithCapacity:SNAPCELLVIEW_SUBCELL_ROWS*SNAPCELLVIEW_SUBCELL_COLUMNS];
            
            for( int i=0; i<SNAPCELLVIEW_SUBCELL_COLUMNS*SNAPCELLVIEW_SUBCELL_ROWS; ++i)
            {
                [self.subCellList addObject:[[SPSubCell alloc] init]];
            }
            
            for( int i=0; i<SNAPCELLVIEW_SUBCELL_ROWS; ++i)
            {
                for( int j=0; j<SNAPCELLVIEW_SUBCELL_COLUMNS; ++j)
                {
                    SPSubCell* newSubCell = [subCellList objectAtIndex:i*SNAPCELLVIEW_SUBCELL_COLUMNS+j];
//                    [newSubCell setFrame:CGRectMake(j*(CELL_FRAME_WIDTH/2),i*(CELL_FRAME_HEIGHT/2),CELL_FRAME_WIDTH/2,CELL_FRAME_HEIGHT/2)];
                    [newSubCell setFrame:CGRectMake(j*(CELL_FRAME_WIDTH/2),i*(CELL_FRAME_HEIGHT/2),CELL_FRAME_WIDTH/2,CELL_FRAME_HEIGHT/2)];
                    [self addSubview:newSubCell];
                    [subCellList addObject:newSubCell];
//                    NSLog(@"%f %f %f %f", newSubCell.frame.origin.x, newSubCell.frame.origin.y, newSubCell.frame.size.width, newSubCell.frame.size.height);
                }
            }
        }
        cellPosition = CELL_POSITION_MAX; // not a value
        isValidCell = NO;
        
//        // TEST TEST TEST TEST DATA GENERATION
//        
//        RHProtocolSender* protocolSender = [RHProtocolSender getInstance];
//        
//        static NSInteger count = 0;
//        
//        UIImage* placeHolderImage = [[RHImageManager getInstance] getImageByKey:IMAGE_KEY_PLACEHHOLDER];
//        for( int i=0; i<2; ++i)
//        {
//            for( int j=0; j<2; ++j)
//            {
//                SPSubCell* subCell = [self.subCellList objectAtIndex:i*2+j];
//                SPSnapImageView* snapImageView = [[SPSnapImageView alloc] init];
//                [subCell.snapImageViewList addObject:snapImageView];
//                [subCell addSubview:snapImageView];
//                [snapImageView setFrame:CGRectMake(0, 0, SNAP_CLASS1_WIDTH, SNAP_CLASS1_HEIGHT)];
//                
//                NSString* urlString = [[NSString alloc] initWithFormat:URL_IMAGE,(count++%5+2)];
//                
//                [protocolSender getImageFromURL:[NSURL URLWithString:urlString] WithImageView:snapImageView.imageView WithJSON:nil WithPlaceholder:placeHolderImage Success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
//                    [snapImageView setNeedsDisplay];
//                } Failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
//                    
//                } TimeOut:5.0];
//            }
//        }

    }
    return self;
}

-(void) addSnapImage:(SPSnapInfo*)snapInfo
{
    if( snapInfo == nil )
    {
        SPSubCell* nextSubCellToAddImage = [self.subCellList objectAtIndex:self.nextSubCellIndexToAddImage++];
        [nextSubCellToAddImage addSnapImage:nil];
        return;
    }
    NSInteger newSnapCapacity = (snapInfo.popularity>=1)?SNAP_CAPACITY_POPULARITY1:SNAP_CAPACITY_POPULARITY0;
    self.cellCapacity += newSnapCapacity;
    NSAssert(self.cellCapacity <= MAX_CELL_CAPACITY, @"Cell capacity can not exceed MAX_CELL_CAPACITY");
    NSAssert(self.nextSubCellIndexToAddImage<=4, @"SubCell Index has to be lower than 4");
    SPSubCell* nextSubCellToAddImage = [self.subCellList objectAtIndex:self.nextSubCellIndexToAddImage];
//    NSLog(@"nextSubCell index %d", self.nextSubCellIndexToAddImage);
    if( nextSubCellToAddImage.capacity >= 4 )
    {
        self.nextSubCellIndexToAddImage = (self.nextSubCellIndexToAddImage+1);
        nextSubCellToAddImage = [self.subCellList objectAtIndex:self.nextSubCellIndexToAddImage];
    }
    
    [nextSubCellToAddImage addSnapImage:snapInfo];
}

-(void) removeAllSnapImageViews
{
    self.cellCapacity = 0;
    self.nextSubCellIndexToAddImage = 0;
    for( SPSubCell* subCell in self.subCellList )
    {
        [subCell removeAllSnapImageViews];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void) loadWithCellInfo:(SPCellInfo*)cellInfo_
{
    self.cellInfo = cellInfo_;
    [self removeAllSnapImageViews];
    
    if( [cellInfo_ isMemberOfClass:[NSNull class]] == YES )
    {
        self.isValidCell = NO;
    }
    else
    {
        self.isValidCell = YES;
        for( SPSnapInfo* snapInfo in cellInfo_.postList )
        {
            NSLog(@"popularity : %d", snapInfo.popularity);
            [self addSnapImage:snapInfo];
        }
    }
}

- (SPSnapImageView*)getSelectedSnapImageView:(CGPoint)selectingPoint
{
    selectingPoint.x = selectingPoint.x - self.frame.origin.x;
    selectingPoint.y = selectingPoint.y - self.frame.origin.y;
  
    SPSnapImageView* selectedSnapImageView = nil;
    for( SPSubCell* subCell in self.subCellList )
    {
        selectedSnapImageView = [subCell getSelectedSnapImageView:selectingPoint];
        if( selectedSnapImageView != nil)
        {
            self.selectedSubCell = subCell;
            return [subCell getSelectedSnapImageView:selectingPoint];
        }
    }
    return nil;
}

- (SPSnapImageView*)getNextSnapImageView:(SnapImageDirection)direction UpdateSelected:(BOOL)willUpdate
{
    SPSnapImageView* nextSnapImageView = nil;
    
    SPSubCell* selectedSubCellView = self.selectedSubCell;
    
    if( selectedSubCellView != nil )
    {
        // Inspect Current SubCell
        nextSnapImageView = [selectedSubCellView getNextSnapImageView:direction UpdateSelected:willUpdate];
        if( nextSnapImageView != nil )
        {
            return nextSnapImageView;
        }
    }
    
    // Move To Next SubCell
    NSInteger selectedIndex = [self.subCellList indexOfObject:selectedSubCellView];
    NSInteger nextIndex = 0;
    switch (direction) {
        case DIR_RIGHT:
            if( selectedIndex==POSITION_BOTTOMRIGHT || selectedIndex==POSITION_TOPRIGHT)
                nextIndex = -1;
            else
                nextIndex = selectedIndex+1;
            break;
        case DIR_LEFT:
            if( selectedIndex==POSITION_TOPLEFT || selectedIndex == POSITION_BOTTOMLEFT )
                nextIndex = -1;
            else
                nextIndex = selectedIndex-1;
            break;
        case DIR_DOWN:
            if( selectedIndex==POSITION_BOTTOMLEFT || selectedIndex==POSITION_BOTTOMRIGHT )
                nextIndex = -1;
            else
                nextIndex = selectedIndex+2;
            break;
        case DIR_UP:
            if( selectedIndex==POSITION_TOPLEFT || selectedIndex == POSITION_TOPRIGHT )
                nextIndex = -1;
            else
                nextIndex = selectedIndex-2;
            break;
        default:
            NSAssert(NO, @"invalid Direction");
            break;
    }
    if( (nextIndex<0) || (nextIndex>4) )
    {
        // Move To Next Cell
        if( willUpdate )
        {
            [self onDeselected];
            self.selectedSubCell = nil;
        }
        return nil;
    }
    
    SPSubCell* nextSubCellView = [self.subCellList objectAtIndex:nextIndex];
    NSAssert(nextSubCellView!=nil, @"wrong index for SubCellList, check the direction or subCellList");
    selectedSubCellView = nextSubCellView;
    if( willUpdate == YES )
    {
        self.selectedSubCell = selectedSubCellView;
    }

    return [nextSubCellView getNextSnapImageView:DIR_NONE UpdateSelected:willUpdate];
}

- (SPSnapImageView*)getSnapImageViewWithPosition:(SnapSubCellPosition)position UpdateSelected:(BOOL)willUpdate
{
    SPSubCell* selectedSubCellView = [self.subCellList objectAtIndex:position];
    
    if( willUpdate == YES )
    {
        self.selectedSubCell = selectedSubCellView;
    }
    
    SPSnapImageView* snapImageView = [selectedSubCellView getNextSnapImageView:DIR_NONE UpdateSelected:willUpdate];
    return snapImageView;
}

-(void)onDeselected
{
    [self.selectedSubCell onDeselected];
    self.selectedSubCell = nil;
}


@end
