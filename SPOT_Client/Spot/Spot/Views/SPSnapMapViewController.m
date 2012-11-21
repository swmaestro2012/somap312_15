//
//  SPSpotMapViewController.m
//  Spot
//
//  Created by Sinhyub Kim on 11/5/12.
//  Copyright (c) 2012 Sinhyub Kim. All rights reserved.
//

@interface SPSnapMapViewController ()
@property (nonatomic) Boolean  isPopUpOpened;
@property (strong, nonatomic) UIView* popUpBackGroundView;
@property (strong, nonatomic) SPSnapImageView* popUpImageView;
@property (strong, nonatomic) SPSnapImageView* popUpImageViewTempFirst;
@property (strong, nonatomic) SPSnapImageView* popUpImageViewTempSecond;
@property (strong, nonatomic) UITapGestureRecognizer* tapGestureRecognizer;
@property (strong, nonatomic) UITapGestureRecognizer* popUpClosingTapGestureRecognizer;
@property (strong, nonatomic) UIPanGestureRecognizer* panGestureRecognizer;
@property (strong, nonatomic) UIPanGestureRecognizer* popUpSlidingPanGestureRecognizer;

// PopUpSliding states
@property (nonatomic) BOOL isOnAnimation;
@property (nonatomic) BOOL isMoving;
@property (nonatomic) BOOL isHorizontalMoving;
@property (nonatomic) CGPoint fadeoutDistance;
@property (nonatomic) CGRect popUpImageOriginalFrame;
@property (nonatomic) CGRect popUpImageTempFirstFrame;
@property (nonatomic) CGRect popUpImageTempSecondFrame;
@property (nonatomic) CGRect outOfFrame;
@property (weak, nonatomic) SPSnapImageView* nextSnapImageView;
@property (strong, nonatomic) UIButton* popUpGotoProfileButton;

- (void)onPopUpSlidingBegin;
- (void)onPopUpSlidingProgress:(CGPoint)translate;
- (void)onPopUpSlidingEnd:(CGPoint)translate;

@end

@implementation SPSnapMapViewController

@synthesize isPopUpOpened;
@synthesize popUpBackGroundView;
@synthesize popUpImageView;
@synthesize popUpImageViewTempFirst;
@synthesize popUpImageViewTempSecond;
@synthesize tapGestureRecognizer;

@synthesize panGestureRecognizer;
@synthesize popUpClosingTapGestureRecognizer;
@synthesize popUpSlidingPanGestureRecognizer;

// PopUpSliding states
@synthesize isOnAnimation;
@synthesize isMoving;
@synthesize isHorizontalMoving;
@synthesize fadeoutDistance;
@synthesize popUpImageOriginalFrame;
@synthesize popUpImageTempFirstFrame;
@synthesize popUpImageTempSecondFrame;
@synthesize outOfFrame;
@synthesize nextSnapImageView;
@synthesize popUpGotoProfileButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        isPopUpOpened = NO;
        
        UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(45.0f, 0.0f, 70.0f, 30.0f)];
        [titleLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
        [titleLabel setText:@"SPOT MAP"];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [self.navigationItem setTitleView:titleLabel];
        
        UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [menuButton addTarget:[SPMenuTableViewController getInstance] action:@selector(onNavigationMenuBarButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
        [menuButton setBackgroundImage:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_MENU_CLOSED] forState:UIControlStateNormal];
        UIBarButtonItem *menuBarButton = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
        [self.navigationItem setLeftBarButtonItem:menuBarButton];
        
        // PopUp Sliding states
        self.isOnAnimation = NO;
        self.isMoving = NO;
        self.isHorizontalMoving = YES;
        self.outOfFrame = CGRectMake(MAIN_FRAME_WIDTH, MAIN_FRAME_HEIGHT, POPUP_IMAGE_FRAME_WIDTH, POPUP_IMAGE_FRAME_HEIGHT);
        nextSnapImageView = nil;
        
    }
    return self;
}

- (void)loadView
{
    SPSnapMapView* spotMapView = [[SPSnapMapView alloc] initWithFrame:CGRectMake(SNAPMAP_FRAME_X, SNAPMAP_FRAME_Y, SNAPMAP_FRAME_WIDTH, SNAPMAP_FRAME_HEIGHT)];
    self.view = spotMapView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
//    SPSnapMapView* spotMapView = (SPSnapMapView*)self.view;
//    SPSnapImageView* selectedSnapImageView = [spotMapView getSelectedSnapImageView:CGPointMake(30.0f,30.0f)];
//    //        if( selectedSnapImageView == nil )
//    [self openPopUpWindowWithImage:selectedSnapImageView.imageView.image];
    
 //   [self closePopUpWindow];
//            [self openPopUpWindowWithImage:nil];
//            [self closePopUpWindow];

    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self addSpotMapGestureRecognizers];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self removeSpotMapGestureRecognizers];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)addSpotMapGestureRecognizers
{
    if( self.tapGestureRecognizer == nil )
    {
        self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        [self.view addGestureRecognizer:self.tapGestureRecognizer];
    }
    [self.tapGestureRecognizer setEnabled:YES];
    
    if( self.panGestureRecognizer == nil )
    {
        self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        [self.view addGestureRecognizer:self.panGestureRecognizer];
    }
    [self.panGestureRecognizer setEnabled:YES];
    
    if( self.popUpSlidingPanGestureRecognizer == nil )
    {
        self.popUpSlidingPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePopUpSlidingPanGesture:)];
        SPMainViewController* mainViewController = [SPMenuTableViewController getInstance].mainViewController;
        [mainViewController.view addGestureRecognizer:self.popUpSlidingPanGestureRecognizer];
    }
    [self.popUpSlidingPanGestureRecognizer setEnabled:YES];
    
    if( self.popUpClosingTapGestureRecognizer == nil )
    {
        self.popUpClosingTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlePopUpClosingTapGesture:)];
        SPMainViewController* mainViewController = [SPMenuTableViewController getInstance].mainViewController;
        [mainViewController.view addGestureRecognizer:self.popUpClosingTapGestureRecognizer];
    }
    [self.popUpClosingTapGestureRecognizer setEnabled:YES];

}

-(void)removeSpotMapGestureRecognizers
{
    if( self.tapGestureRecognizer )
        [self.tapGestureRecognizer setEnabled:NO];
    if( self.panGestureRecognizer )
        [self.panGestureRecognizer setEnabled:NO];
    if( self.popUpClosingTapGestureRecognizer )
        [self.popUpClosingTapGestureRecognizer setEnabled:NO];
    if( self.popUpSlidingPanGestureRecognizer )
        [self.popUpSlidingPanGestureRecognizer setEnabled:NO];
}

- (void)onPopUpSlidingBegin
{
    self.popUpImageOriginalFrame = self.popUpImageView.frame;   
}
- (void)onPopUpSlidingProgress:(CGPoint)translate
{
    NSAssert([self.view isKindOfClass:[SPSnapMapView class]]==YES, @"SnspMapViewController has to have SnapMapView as own view");
    if( self.isMoving == NO )
    {
        if( ABS(translate.x) > ABS(translate.y) )
        {
            self.isHorizontalMoving = YES;
            self.popUpImageTempFirstFrame = CGRectMake(self.popUpImageOriginalFrame.origin.x-HORIZONTAL_POPUPIMAGE_DISTANCE,
                                                       self.popUpImageOriginalFrame.origin.y,
                                                       self.popUpImageOriginalFrame.size.width,
                                                       self.popUpImageOriginalFrame.size.height);
            self.popUpImageTempSecondFrame = CGRectMake(self.popUpImageOriginalFrame.origin.x+HORIZONTAL_POPUPIMAGE_DISTANCE,
                                                        self.popUpImageOriginalFrame.origin.y,
                                                        self.popUpImageOriginalFrame.size.width,
                                                        self.popUpImageOriginalFrame.size.height);
            
            [self.popUpImageViewTempFirst setFrame:self.popUpImageTempFirstFrame];
            [self.popUpImageViewTempSecond setFrame:self.popUpImageTempSecondFrame];
            
            SPSnapImageView* tempSnapImageView = [((SPSnapMapView*)self.view) getNextSnapImageView:DIR_LEFT UpdateSelected:NO];
            if( tempSnapImageView != nil )
            {
                [self.popUpImageViewTempFirst setImage:tempSnapImageView.imageView.image];
                [self.popUpImageViewTempFirst setSnapInfo:tempSnapImageView.snapInfo];
            }
            else
            {
                [self.popUpImageViewTempFirst setImage:nil];
                [self.popUpImageViewTempFirst setSnapInfo:nil];
            }

            
            tempSnapImageView = [((SPSnapMapView*)self.view) getNextSnapImageView:DIR_RIGHT UpdateSelected:NO];
            if( tempSnapImageView != nil )
            {
                [self.popUpImageViewTempSecond setImage:tempSnapImageView.imageView.image];
                [self.popUpImageViewTempSecond setSnapInfo:tempSnapImageView.snapInfo];
            }
            else
            {
                [self.popUpImageViewTempSecond setImage:nil];
                [self.popUpImageViewTempSecond setSnapInfo:nil];
            }
        }
        else
        {
            self.isHorizontalMoving = NO;
            self.popUpImageTempFirstFrame = CGRectMake(self.popUpImageOriginalFrame.origin.x,
                                                       self.popUpImageOriginalFrame.origin.y-VERTICAL_POPUPIMAGE_DISTANCE,
                                                       self.popUpImageOriginalFrame.size.width,
                                                       self.popUpImageOriginalFrame.size.height);
            self.popUpImageTempSecondFrame = CGRectMake(self.popUpImageOriginalFrame.origin.x,
                                                        self.popUpImageOriginalFrame.origin.y+VERTICAL_POPUPIMAGE_DISTANCE,
                                                        self.popUpImageOriginalFrame.size.width,
                                                        self.popUpImageOriginalFrame.size.height);
            SPSnapImageView* tempSnapImageView = [((SPSnapMapView*)self.view) getNextSnapImageView:DIR_UP UpdateSelected:NO];
            if( tempSnapImageView != nil )
            {
                [self.popUpImageViewTempFirst setImage:tempSnapImageView.imageView.image];
                [self.popUpImageViewTempFirst setSnapInfo:tempSnapImageView.snapInfo];
            }
            else
            {
                [self.popUpImageViewTempFirst setImage:nil];
                [self.popUpImageViewTempFirst setSnapInfo:nil];
            }
            tempSnapImageView = [((SPSnapMapView*)self.view) getNextSnapImageView:DIR_DOWN UpdateSelected:NO];
            if( tempSnapImageView != nil )
            {
                [self.popUpImageViewTempSecond setImage:tempSnapImageView.imageView.image];
                [self.popUpImageViewTempSecond setSnapInfo:tempSnapImageView.snapInfo];
            }
            else
            {
                [self.popUpImageViewTempSecond setImage:nil];
                [self.popUpImageViewTempSecond setSnapInfo:nil];
            }
            
        }
        
        self.isMoving = YES;
    }
    
    if( self.isHorizontalMoving == YES )
    {
        translate.y=0;
    }
    else
    {
        translate.x=0;
    }
    
    CGRect moveToFrame = CGRectMake(self.popUpImageOriginalFrame.origin.x+translate.x,
                                    self.popUpImageOriginalFrame.origin.y+translate.y,
                                    self.popUpImageOriginalFrame.size.width,
                                    self.popUpImageOriginalFrame.size.height);
    CGRect moveToFrameTempFirst = CGRectMake(self.popUpImageTempFirstFrame.origin.x+translate.x,
                                             self.popUpImageTempFirstFrame.origin.y+translate.y,
                                             self.popUpImageTempFirstFrame.size.width,
                                             self.popUpImageTempFirstFrame.size.height);
    CGRect moveToFrameTempSecond = CGRectMake(self.popUpImageTempSecondFrame.origin.x+translate.x,
                                              self.popUpImageTempSecondFrame.origin.y+translate.y,
                                              self.popUpImageTempSecondFrame.size.width,
                                              self.popUpImageTempSecondFrame.size.height);
    
    [self.popUpImageView setFrame:moveToFrame];
    [self.popUpImageViewTempFirst setFrame:moveToFrameTempFirst];
    [self.popUpImageViewTempSecond setFrame:moveToFrameTempSecond];
}
-(void)onPopUpSlidingEnd:(CGPoint)translate
{
    SnapImageDirection swipeDirection = DIR_NONE;
    if ( self.isHorizontalMoving && (translate.x >= DRAG_MEASUREMENT) )
    {
        swipeDirection = DIR_LEFT;
        self.nextSnapImageView = self.popUpImageViewTempFirst;
        self.fadeoutDistance = CGPointMake(MAIN_FRAME_WIDTH,0.f);
        NSAssert(self.nextSnapImageView != nil, @"nil nextSnapImage");
    }
    else if ( self.isHorizontalMoving && (translate.x <= -DRAG_MEASUREMENT) )
    {
        swipeDirection = DIR_RIGHT;
        self.nextSnapImageView = self.popUpImageViewTempSecond;
        self.fadeoutDistance = CGPointMake(-MAIN_FRAME_WIDTH, 0.f);
        NSAssert(self.nextSnapImageView != nil, @"nil nextSnapImage");
    }
    else if ( (self.isHorizontalMoving==NO) && (translate.y >= DRAG_MEASUREMENT) )
    {
        swipeDirection = DIR_UP;
        self.nextSnapImageView = self.popUpImageViewTempFirst;
        self.fadeoutDistance = CGPointMake(0.f, MAIN_FRAME_HEIGHT);
        NSAssert(self.nextSnapImageView != nil, @"nil nextSnapImage");
    }
    else if ( (self.isHorizontalMoving==NO) && (translate.y <= -DRAG_MEASUREMENT) )
    {
        swipeDirection = DIR_DOWN;
        self.nextSnapImageView = self.popUpImageViewTempSecond;
        self.fadeoutDistance = CGPointMake(0.f, -MAIN_FRAME_HEIGHT);
        NSAssert(self.nextSnapImageView != nil, @"nil nextSnapImage");
    }
    
    // Check next side of image is exist
    if( nil == [((SPSnapMapView*)self.view) getNextSnapImageView:swipeDirection UpdateSelected:NO])
        self.nextSnapImageView = nil;
    
    if( self.nextSnapImageView == nil )
    {
        // NO Auto Sliding to Next
        // return to original Position
        self.isOnAnimation = YES;
        [UIView animateWithDuration:0.2f animations:^{
            [self.popUpImageView setFrame:self.popUpImageOriginalFrame];
            [self.popUpImageViewTempFirst setFrame:self.popUpImageTempFirstFrame];
            [self.popUpImageViewTempSecond setFrame:self.popUpImageTempSecondFrame];
        } completion:^(BOOL finished) {
            self.isOnAnimation = NO;
            NSLog(@"returned to Original Position");
        }];
    }
    else
    {
        // Auto Sliding to Next Image
        CGRect fadeOutRect = CGRectMake(self.popUpImageOriginalFrame.origin.x+self.fadeoutDistance.x,
                                        self.popUpImageOriginalFrame.origin.y+self.fadeoutDistance.y,
                                        self.popUpImageOriginalFrame.size.width,
                                        self.popUpImageOriginalFrame.size.height);
        
        CGRect fadeOutRectTempFirst = CGRectMake(self.popUpImageTempFirstFrame.origin.x+self.fadeoutDistance.x,
                                                 self.popUpImageTempFirstFrame.origin.y+self.fadeoutDistance.y,
                                                 self.popUpImageTempFirstFrame.size.width,
                                                 self.popUpImageTempFirstFrame.size.height);
        
        CGRect fadeOutRectTempSecond = CGRectMake(self.popUpImageTempSecondFrame.origin.x+self.fadeoutDistance.x,
                                                  self.popUpImageTempSecondFrame.origin.y+self.fadeoutDistance.y,
                                                  self.popUpImageTempSecondFrame.size.width,
                                                  self.popUpImageTempSecondFrame.size.height);
        
        self.isOnAnimation = YES;
        [UIView animateWithDuration:0.2f animations:^{
            [self.popUpImageView setFrame:fadeOutRect];
            [self.popUpImageViewTempFirst setFrame:fadeOutRectTempFirst];
            [self.popUpImageViewTempSecond setFrame:fadeOutRectTempSecond];
        } completion:^(BOOL finished) {
            if( finished == YES )
            {
                // Update To own View
                SPSnapImageView* newSnapImageViewFromSpotMapView = [((SPSnapMapView*)self.view) getNextSnapImageView:swipeDirection UpdateSelected:YES];
                
                // Exchage Images
                [self.popUpImageView setImage:newSnapImageViewFromSpotMapView.imageView.image];
                
                // Arange Position of Original
                [self.popUpImageViewTempFirst setFrame:self.outOfFrame];
                [self.popUpImageViewTempSecond setFrame:self.outOfFrame];
                [self.popUpImageView setFrame:self.popUpImageOriginalFrame];
                
                NSLog(@"AutoSliding Completed");
            }
            self.isOnAnimation = NO;
        }];
    }
    self.nextSnapImageView = nil;
    self.isMoving = NO;
}
-(void)handlePopUpSlidingPanGesture:(UIPanGestureRecognizer*) sender
{
 
    if( self.isPopUpOpened == NO )
        return;
    
    if( self.isOnAnimation == YES )
        return;
    
    CGPoint translate = [sender translationInView:self.view];
    
    
    if( sender.state == UIGestureRecognizerStateBegan )
    {
        [self onPopUpSlidingBegin];
    }
    else if( sender.state == UIGestureRecognizerStateChanged )
    {
        [self onPopUpSlidingProgress:translate];
    }
    else if( sender.state == UIGestureRecognizerStateEnded )
    {
        [self onPopUpSlidingEnd:translate];
        
        [sender setTranslation:CGPointMake(0,0) inView:self.view];
    }
}

-(void)handlePanGesture:(UIPanGestureRecognizer*) sender
{
    if( self.isPopUpOpened == YES )
    {
        return;
    }
    if( self.isOnAnimation == YES )
    {
        return;
    }

    
    static CGPoint totalTranslatedOffset;
    
    if( sender.state == UIGestureRecognizerStateBegan )
    {
        
    }
    else if( sender.state == UIGestureRecognizerStateChanged )
    {
        CGPoint translate = [sender translationInView:self.view];
        if( self.isMoving == NO )
        {
            self.isHorizontalMoving = NO;
            self.isMoving = YES;
            totalTranslatedOffset = CGPointMake(0,0);
            if( ABS(translate.x) > ABS(translate.y) )
            {
                self.isHorizontalMoving = YES;
            }
        }
        if( self.isHorizontalMoving )
        {
            translate.y=0;
        }
        else
        {
            translate.x=0;
        }

        
        for( UIView* subView in self.view.subviews)
        {
            CGRect newFrame = subView.frame;
            
            newFrame.origin.x += translate.x;
            newFrame.origin.y += translate.y;
            
            subView.frame = newFrame;
        }
        totalTranslatedOffset.x += translate.x;
        totalTranslatedOffset.y += translate.y;
        
        [sender setTranslation:CGPointMake(0,0) inView:self.view];
    }
    else if( sender.state == UIGestureRecognizerStateEnded )
    {
        self.isMoving = NO;
        CGPoint autoSlidingOffset;
        
        SnapImageDirection swipeDirection = DIR_NONE;
        if ( self.isHorizontalMoving && (totalTranslatedOffset.x >= DRAG_MEASUREMENT_MAP) )
        {
            swipeDirection = DIR_LEFT;
            autoSlidingOffset = CGPointMake((CELL_FRAME_WIDTH-ABS(totalTranslatedOffset.x)),0);
        }
        else if ( self.isHorizontalMoving && (totalTranslatedOffset.x <= -DRAG_MEASUREMENT_MAP) )
        {
            swipeDirection = DIR_RIGHT;
            autoSlidingOffset = CGPointMake(-(CELL_FRAME_WIDTH-ABS(totalTranslatedOffset.x)),0);
        }
        else if ( (self.isHorizontalMoving==NO) && (totalTranslatedOffset.y >= DRAG_MEASUREMENT_MAP) )
        {
            swipeDirection = DIR_UP;
            autoSlidingOffset = CGPointMake(0,(CELL_FRAME_HEIGHT-ABS(totalTranslatedOffset.y)));
        }
        else if ( (self.isHorizontalMoving==NO) && (totalTranslatedOffset.y <= -DRAG_MEASUREMENT_MAP) )
        {
            swipeDirection = DIR_DOWN;
            autoSlidingOffset = CGPointMake(0,-(CELL_FRAME_HEIGHT-ABS(totalTranslatedOffset.y)));
        }
        
        
        BOOL canMove = YES;
        if( swipeDirection == DIR_NONE || [((SPSnapMapView*)self.view) canMoveToDirection:swipeDirection]==NO )
        {
            canMove = NO;
        }
        
        if( canMove == NO )
        {
            // return to original frame
            self.isOnAnimation = YES;
            [UIView animateWithDuration:0.2f animations:^{
                //for( SPSnapCellView* cellView in ((SPSnapMapView*)self.view).snapCellViewList )
                for( UIView* subView in self.view.subviews )
                {
                    CGRect newFrame = CGRectMake(subView.frame.origin.x -totalTranslatedOffset.x, subView.frame.origin.y - totalTranslatedOffset.y,
                                                 subView.frame.size.width, subView.frame.size.height);
                    [subView setFrame:newFrame];
                }
            } completion:^(BOOL finished) {
                self.isOnAnimation = NO;
            }];
        }
        else
        {
            [((SPSnapMapView*)self.view) onViewMoveToNextCell:swipeDirection WithMove:NO];
            // Auto Sliding to Next Image
            self.isOnAnimation = YES;
            [UIView animateWithDuration:0.2f animations:^{
                for( UIView* subView in self.view.subviews )
                {
                    CGRect newFrame = CGRectMake(subView.frame.origin.x + autoSlidingOffset.x, subView.frame.origin.y + autoSlidingOffset.y,
                                                 subView.frame.size.width, subView.frame.size.height);
                    [subView setFrame:newFrame];
                }
            } completion:^(BOOL finished) {
                self.isOnAnimation = NO;
            }];
        }
    
    }
}


-(void)handlePopUpClosingTapGesture:(UITapGestureRecognizer*) sender
{
    if( self.isPopUpOpened == YES )
    {
        CGPoint selectPoint = [sender locationInView:self.popUpImageView];
        if( CGRectContainsPoint(self.popUpGotoProfileButton.frame, selectPoint) )
        {
            [self onPopUpGotoButtonPushedUp:self.popUpGotoProfileButton];
            return;
        }
        [self closePopUpWindow];
    }
}
-(void)handleTapGesture:(UITapGestureRecognizer*) sender
{
    CGPoint tapPoint = [sender locationInView:self.view];
    if( self.isOnAnimation == YES )
    {
        return;
    }
    
    if( self.isPopUpOpened == NO )
    {
        SPSnapMapView* snapMapView = (SPSnapMapView*)self.view;
        SPSnapImageView* selectedSnapImageView = [snapMapView getSelectedSnapImageView:tapPoint];
        if( selectedSnapImageView == nil )
            return;
        
        //      SpotInfo* selectedSpotInfo = selectedSnapImageView.spotInfo;
        
        [selectedSnapImageView setBackgroundColor:[UIColor lightGrayColor]];
        [self selectImage:selectedSnapImageView];
        
    }
    
}

-(void)selectImage:(SPSnapImageView*) selectedImageView
{
    [self openPopUpWindowWithImage:selectedImageView.imageView.image];
}

-(void)openPopUpWindowWithImage:(UIImage *)image
{
    if( self.isPopUpOpened == YES )
    {
        return;
    }
    self.isPopUpOpened = YES;
    
    SPMainViewController* mainViewController = [SPMenuTableViewController getInstance].mainViewController;
    
    if( self.popUpBackGroundView == nil )
    {
        self.popUpBackGroundView = [[UIView alloc] initWithFrame:mainViewController.view.window.frame];
        [self.popUpBackGroundView setBackgroundColor:[UIColor blackColor]];
        [self.popUpBackGroundView setAlpha:0.85];
    }
    [mainViewController.view addSubview:self.popUpBackGroundView];

    //[self.view addSubview:self.popUpBackGroundView];
    
    if( self.popUpImageView == nil )
    {
        self.popUpImageView = [[SPSnapImageView alloc] init];
        [self.popUpImageView.imageView setContentMode:UIViewContentModeScaleAspectFit];
    }
    [self.popUpImageView setFrame:CGRectMake(POPUP_IMAGE_FRAME_X,POPUP_IMAGE_FRAME_Y,POPUP_IMAGE_FRAME_WIDTH,POPUP_IMAGE_FRAME_HEIGHT)];
    [self.popUpImageView setImage:image];
    [mainViewController.view addSubview:self.popUpImageView];
    [self.popUpImageView setAlpha:1.0];
    
    if( self.popUpImageViewTempFirst == nil )
    {
        self.popUpImageViewTempFirst = [[SPSnapImageView alloc] initWithFrame:self.popUpImageView.frame];
    }
    [mainViewController.view addSubview:self.popUpImageViewTempFirst];
    
    if( self.popUpImageViewTempSecond == nil )
    {
        self.popUpImageViewTempSecond = [[SPSnapImageView alloc] initWithFrame:self.popUpImageView.frame];
    }
    [mainViewController.view addSubview:self.popUpImageViewTempSecond];
    

    if( self.popUpGotoProfileButton == nil )
    {
        self.popUpGotoProfileButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.popUpGotoProfileButton setFrame:CGRectMake(POPUP_GOTOPROFILE_BUTTON_X-40, POPUP_GOTOPROFILE_BUTTON_Y-40, POPUP_GOTOPROFILE_BUTTON_WIDTH, POPUP_GOTOPROFILE_BUTTON_HEIGHT)];
        [self.popUpGotoProfileButton setBackgroundImage:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_BAR320]  forState:UIControlStateNormal];
        [self.popUpGotoProfileButton setBackgroundImage:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_BAR320]  forState:UIControlStateHighlighted];
        [self.popUpGotoProfileButton setTitle:@"Open Profile" forState:UIControlStateNormal];
//        [self.popUpGotoProfileButton setBackgroundImage:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_ICON_OPENPROFILE]  forState:UIControlStateNormal];
//        [self.popUpGotoProfileButton setBackgroundImage:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_ICON_OPENPROFILE]  forState:UIControlStateHighlighted];
        [self.popUpGotoProfileButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
        [self.popUpGotoProfileButton addTarget:self action:@selector(onPopUpGotoButtonPushedUp:) forControlEvents:UIControlEventTouchUpInside];
        
    }
//    [mainViewController.view addSubview: self.popUpGotoProfileButton];
    [self.popUpImageView addSubview:self.popUpGotoProfileButton];
    
    // Arrange Position of Side PopUp Views
    // default as horizontal sliding
    self.popUpImageOriginalFrame = self.popUpImageView.frame;
    self.popUpImageTempFirstFrame = CGRectMake(popUpImageOriginalFrame.origin.x-HORIZONTAL_POPUPIMAGE_DISTANCE,
                                          popUpImageOriginalFrame.origin.y,
                                          popUpImageOriginalFrame.size.width,
                                          popUpImageOriginalFrame.size.height);
    self.popUpImageTempSecondFrame = CGRectMake(popUpImageOriginalFrame.origin.x+HORIZONTAL_POPUPIMAGE_DISTANCE,
                                           popUpImageOriginalFrame.origin.y,
                                           popUpImageOriginalFrame.size.width,
                                           popUpImageOriginalFrame.size.height);
    
    [self.popUpImageViewTempFirst setFrame:popUpImageTempFirstFrame];
    [self.popUpImageViewTempSecond setFrame:popUpImageTempSecondFrame];
    
    
    // View Closing Gesture
    // View Floating Gesture
    [self.popUpClosingTapGestureRecognizer setEnabled:YES];
    [self.popUpSlidingPanGestureRecognizer setEnabled:YES];
}

-(void)closePopUpWindow
{
    if( self.isPopUpOpened == NO)
    {
        NSAssert(self.isPopUpOpened==YES, @"Pop Up is already Closed");
        return;
    }
    
    self.isPopUpOpened = NO;
    
    [self.popUpImageView removeFromSuperview];
    [self.popUpImageViewTempFirst removeFromSuperview];
    [self.popUpImageViewTempSecond removeFromSuperview];
    [self.popUpBackGroundView removeFromSuperview];
    [self.popUpGotoProfileButton removeFromSuperview];
    
    [self.popUpClosingTapGestureRecognizer setEnabled:NO];
    [self.popUpSlidingPanGestureRecognizer setEnabled:NO];
}


-(void)onPopUpGotoButtonPushedUp:(UIButton*) sender
{
    [self closePopUpWindow];
    
    SPSpotProfileViewController* spotProfileViewController = [[SPSpotProfileViewController alloc] init];

    SPSnapCellView* selectedCell = ((SPSnapMapView*)self.view).selectedSnapCellView;
    NSAssert(selectedCell != nil, @"no selected cell");
    SPSubCell* selectedSubCell = selectedCell.selectedSubCell;
    NSAssert(selectedSubCell != nil, @"no selected subcell");
    SPSnapImageView* selectedSnapImage = selectedSubCell.selectedSnapImageView;
    NSAssert(selectedSnapImage != nil, @"no selected snapImage");
    SPSnapInfo* selectedSnapInfo = ((SPSnapMapView*)self.view).selectedSnapCellView.selectedSubCell.selectedSnapImageView.snapInfo;
    NSAssert(selectedSnapInfo != nil, @"no selected Snap info");
    
    [spotProfileViewController loadDataWithSpotID:selectedSnapInfo.spotID];
    [self.navigationController pushViewController:spotProfileViewController animated:YES];
}


@end
