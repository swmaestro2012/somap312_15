//
//  SPMenuTableViewController.m
//  Spot
//
//  Created by Sinhyub Kim on 11/5/12.
//  Copyright (c) 2012 Sinhyub Kim. All rights reserved.
//

@interface SPMenuTableViewController ()
@property (atomic) BOOL isMenuOpened;
@property (nonatomic) CGRect menuClosedWindow;
@property (nonatomic) CGRect menuOpenedWindow;
-(void)tapGestureHandler:(UITapGestureRecognizer*)sender;
@end


@implementation CellObject
@synthesize tag, cellText, action, cellImage;
@end


@implementation SectionDataContainer
@synthesize sectionName, cells;//, sectionImage;
-(id) init
{
    self = [super init];
    if(self)
    {
        self.cells = [[NSMutableArray alloc] init];
    }
    return self;
}
@end


static SPMenuTableViewController* s_SPMenuTableViewController = nil;

@implementation SPMenuTableViewController
@synthesize mainViewController;
@synthesize tableData;

@synthesize isMenuOpened;
@synthesize menuOpenedWindow;
@synthesize menuClosedWindow;
@synthesize closeMenubarView;
@synthesize savedSender;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
        
        // Dynamic Menu Opening
        self.isMenuOpened = NO;

        self.menuClosedWindow = CGRectMake(MAIN_FRAME_X, MAIN_FRAME_Y,
                                           MAIN_FRAME_WIDTH, MAIN_FRAME_HEIGHT);
        self.menuOpenedWindow = CGRectMake(self.menuClosedWindow.origin.x+MENU_TABLE_FRAME_WIDTH, self.menuClosedWindow.origin.y,
                                           self.menuClosedWindow.size.width, self.menuClosedWindow.size.height);

        
        // Main View Controller
        if( mainViewController == nil )
        {
            mainViewController = [[SPMainViewController alloc] init];
        }
        
        if(tableData == nil)
        {
            tableData = [[NSMutableArray alloc] initWithCapacity:SPMenuTableSectionMax];
        }
        
    }
    return self;
}

+(SPMenuTableViewController*) getInstance
{
    if ( s_SPMenuTableViewController == nil )
    {
        s_SPMenuTableViewController = [[super allocWithZone:NULL] initWithStyle:UITableViewStylePlain];

    }
    return s_SPMenuTableViewController;
}


+ (id)allocWithZone:(NSZone *)zone
{
    return [self getInstance];
    //    return [[self getInstance] retain];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.backgroundView = nil;
    [self.view setFrame:CGRectMake(MENU_TABLE_FRAME_X, MENU_TABLE_FRAME_Y, MENU_TABLE_FRAME_WIDTH, MENU_TABLE_FRAME_HEIGHT)];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self initializeTableViewWithActions];
    
}


- (void)initializeTableViewWithActions
{
    if(tableData != nil)
    {
        [tableData removeAllObjects];
    }
    
    SectionDataContainer* mainSectionData = [[SectionDataContainer alloc] init];
    mainSectionData.sectionName = @"Menu";
//    mainSectionData.sectionImage = [[RHImageManager getInstance] getImageByKey:IMAGE_KEY_MENUSECTION_MENU];
    
//    CellObject* titleLogoCell = [[CellObject alloc] init];
//    titleLogoCell.cellText = nil;//MENUCELL_TITLE_LOGO;
//    titleLogoCell.action = @selector(emptySelector);
//    titleLogoCell.cellImage = [[RHImageManager getInstance] getImageByKey:IMAGE_KEY_LOGO];
//    [mainSectionData.cells addObject:titleLogoCell];
    
    CellObject* myProfileCell = [[CellObject alloc] init];
    myProfileCell.cellText = MENUCELL_TITLE_MYPROFILE;
    myProfileCell.action = @selector(onMyProfileMenuSelected);
    myProfileCell.cellImage = [[RHImageManager getInstance] getImageByKey:IMAGE_KEY_MENUBARICON_PROFILE];
    [mainSectionData.cells addObject:myProfileCell];

    CellObject* favoriteCell = [[CellObject alloc] init];
    favoriteCell.cellText = MENUCELL_TITLE_FAVORITE;
    favoriteCell.action = @selector(onFavoriteMenuSelected);
    favoriteCell.cellImage = [[RHImageManager getInstance] getImageByKey:IMAGE_KEY_MENUBARICON_PROFILE];
    [mainSectionData.cells addObject:favoriteCell];

    
    CellObject* physicalSpotMapCell = [[CellObject alloc] init];
    physicalSpotMapCell.cellText = MENUCELL_TITLE_PHYSICALSPOTMAP;
    physicalSpotMapCell.action = @selector(onPhysicalSpotMapMenuSelected);
    physicalSpotMapCell.cellImage = [[RHImageManager getInstance] getImageByKey:IMAGE_KEY_MENUBARICON_LOCATION];
    [mainSectionData.cells addObject:physicalSpotMapCell];

    
    CellObject* logicalSpotMapCell = [[CellObject alloc] init];
    logicalSpotMapCell.cellText = MENUCELL_TITLE_LOGICALSPOTMAP;
    logicalSpotMapCell.action = @selector(onLogicalSpotMapMenuSelected);
    logicalSpotMapCell.cellImage = [[RHImageManager getInstance] getImageByKey:IMAGE_KEY_MENUBARICON_LOCATION];
    [mainSectionData.cells addObject:logicalSpotMapCell];
    
    CellObject* signOutCell = [[CellObject alloc] init];
    signOutCell.cellText = MENUCELL_TITLE_SIGNOUT;
    signOutCell.action = @selector(onSignOutMenuSelected);
    signOutCell.cellImage = [[RHImageManager getInstance] getImageByKey:IMAGE_KEY_MENUBARICON_SIGNOUT];
    [mainSectionData.cells addObject:signOutCell];

    [tableData insertObject:mainSectionData atIndex:SPMenuTableSectionMain];
    
    
  /*  UITableViewCell* rowNULL = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"MenuCell"];
    [rowNULL.textLabel setText:MENUCELL_TITLE_NULL];
    [rowNULL.textLabel setTextColor:[UIColor lightGrayColor]];
    [self.rowList addObject:rowNULL];
    */
        
    
    SectionDataContainer* physicalSpotSectionData = [[SectionDataContainer alloc] init];
    physicalSpotSectionData.sectionName = @"my SPOT list";
//    physicalSpotSectionData.sectionImage =
//    spotSectionData.sectionImage = [[RHImageManager getInstance] getImageByKey:IMAGE_KEY_MENUSECTION_SPOTLIST];

    NSArray* physicalSpotList = [SPServerObject getInstance].myUserProfileInfo.physicalSpotList;
    if( physicalSpotList != nil )
    {
        for( SPSpotInfo* spotInfo in physicalSpotList)
        {
            CellObject* spotCell = [[CellObject alloc] init];
            spotCell.cellText = spotInfo.spotName;
            spotCell.action = @selector(onUserMapMenuSelected:);
            spotCell.cellImage = [[RHImageManager getInstance] getImageByKey:IMAGE_KEY_MENUBARICON_USERMAP];
            [physicalSpotSectionData.cells addObject:spotCell];
        }
    }
    
    [tableData insertObject:physicalSpotSectionData atIndex:SPMenuTableSectionPhysicalSpot];
    
    
    SectionDataContainer* logicalSpotSectionData = [[SectionDataContainer alloc] init];
    logicalSpotSectionData.sectionName = @"my VIRTUAL SPOT list ";
    //    spotSectionData.sectionImage = [[RHImageManager getInstance] getImageByKey:IMAGE_KEY_MENUSECTION_SPOTLIST];
    
    NSArray* logicalSpotList = [SPServerObject getInstance].myUserProfileInfo.logicalSpotList;
    if( logicalSpotList != nil )
    {
        for( SPSpotInfo* spotInfo in logicalSpotList)
        {
            CellObject* spotCell = [[CellObject alloc] init];
            spotCell.cellText = spotInfo.spotName;
            spotCell.action = @selector(onUserMapMenuSelected:);
            spotCell.cellImage = [[RHImageManager getInstance] getImageByKey:IMAGE_KEY_MENUBARICON_USERMAP];
            [logicalSpotSectionData.cells addObject:spotCell];
        }
    }
    
    [tableData insertObject:logicalSpotSectionData atIndex:SPMenuTableSectionLogicalSpot];

    
    [(UITableView*)self.view reloadData];
    [(UITableView*)self.view updateConstraints];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    [self.view setBackgroundColor:[[UIColor alloc] initWithPatternImage: [[RHImageManager getInstance]getImageByKey:IMAGE_KEY_BACKGROUNDTEXTURE] ]];
    [self.view setBackgroundColor:[UIColor blackColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.tableData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if( section >= 0 && section < SPMenuTableSectionMax)
    {
        return [((SectionDataContainer*)[self.tableData objectAtIndex:section]).cells count];
    }
    return 0;
}

-(UIView*) tableView:(UITableView*)aTableView viewForHeaderInSection:(NSInteger)section
{
    SectionDataContainer* sectionData = [tableData objectAtIndex:section];
    
    UILabel *sectionHeader = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 230, 30)];
//    sectionHeader.backgroundColor = [UIColor  darkGrayColor];
    sectionHeader.backgroundColor = [UIColor colorWithPatternImage:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_MENUBARSECTION]];
    sectionHeader.font = [UIFont boldSystemFontOfSize:18];
    sectionHeader.textColor = [UIColor darkGrayColor];
    sectionHeader.text = sectionData.sectionName;
    sectionHeader.textAlignment = NSTextAlignmentCenter;

    
//    UIImageView* sectionHeader = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,MENU_TABLE_FRAME_WIDTH, MENU_TABLE_FRAME_HEIGHT)];
//    [sectionHeader setImage:sectionData.sectionImage];
    
    return sectionHeader;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SectionDataContainer* sectionData = [tableData objectAtIndex:indexPath.section];
    CellObject* cellData = [sectionData.cells objectAtIndex:indexPath.row];
    
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"MenuCell"];
    [cell.textLabel setText:cellData.cellText];
    [cell.textLabel setTextColor:[UIColor lightGrayColor]];
    [cell.imageView setImage:cellData.cellImage];
    [cell.textLabel setBackgroundColor:[UIColor clearColor]];
    [cell setBackgroundView:[[UIImageView alloc] initWithImage:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_MENUBAR]]];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SectionDataContainer* sectionData = [tableData objectAtIndex:indexPath.section];
    CellObject* cellData = [sectionData.cells objectAtIndex:indexPath.row];

    SEL action = cellData.action;
    
    if(action)
    {
        [self hideMenuBar:self];
        [self performSelector:action withObject:self afterDelay:MENU_TABLE_CLOSE_DELAY];
    }    
}

-(void)emptySelector
{
    
}

-(void)onSignOutMenuSelected
{
    [[RHProtocolSender getInstance] signOutSessionWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableDictionary* JSON = responseObject;
        int result = [[JSON valueForKey:@"success"] intValue];
        if( result == 0 )
        {
            // Error Handling
            [RHUtilities popUpErrorMessage:[JSON valueForKey:@"message"] WithParentViewController:self];
        }
        [[SPMenuTableViewController getInstance].mainViewController loadLoadingViewControllerWithSignInView:YES];
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [RHUtilities handleError:error WithParentViewController:self];
        [[SPMenuTableViewController getInstance].mainViewController loadLoadingViewControllerWithSignInView:YES];
    }];
    
    [[SPServerObject getInstance] onSignOut];
}

-(void)onPhysicalSpotMapMenuSelected
{
    [self.mainViewController loadSpotMapViewController:YES];
}

-(void)onLogicalSpotMapMenuSelected
{
    [self.mainViewController loadSpotMapViewController:NO];
}

-(void)onUserMapMenuSelected:(id)sender
{
    NSIndexPath* selectedIndexPath = [((UITableView*)self.view) indexPathForSelectedRow];
    SectionDataContainer* sectionData = [tableData objectAtIndex:selectedIndexPath.section];
    CellObject* cellData = [sectionData.cells objectAtIndex:selectedIndexPath.row];

    [self openUserMap:cellData.cellText];
}

- (void)onMyProfileMenuSelected
{
     [self.mainViewController loadMyProfileViewController];
}

- (void) onFavoriteMenuSelected
{
    [self.mainViewController loadFavoriteViewController];
}


- (void)onNavigationMenuBarButtonPushed:(id)sender
{    
    if( self.isMenuOpened == YES )
    {
        [self hideMenuBar:sender];
        return;
    }
    
    [self openMenuBar:sender];
}

-(void) openUserMap:(NSString*)spotName
{
    [self.mainViewController loadUserMapViewControllerWithSpotName:spotName];
}

-(void)openMenuBar:(id)sender
{
    self.isMenuOpened = YES;
    
    self.savedSender = sender;
    
    
    UITapGestureRecognizer* closeMenuGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandler:)];
    self.closeMenubarView = [[UIView alloc] initWithFrame:CGRectMake(MAIN_FRAME_X,MAIN_FRAME_Y, MAIN_FRAME_WIDTH, MAIN_FRAME_HEIGHT)];
    [closeMenubarView addGestureRecognizer:closeMenuGesture];
    
    [self.mainViewController.view addSubview:closeMenubarView];
    
    
    [UIView animateWithDuration:MENU_TABLE_OPEN_DELAY animations:^{
        [self.mainViewController.view setFrame:self.menuOpenedWindow];
        
    } completion:^(BOOL finished) {
        NSLog(@"Completely Opened");
        if( [sender isKindOfClass:[UIButton class]] == YES )
            [((UIButton*)sender) setBackgroundImage:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_MENU_OPENED] forState:UIControlStateNormal];
        
    }];
}

-(void)openAndCloseMenuBar:(id)sender
{
    self.isMenuOpened = YES;
    
    [UIView animateWithDuration:MENU_TABLE_OPEN_DELAY animations:^{
        [self.mainViewController.view setFrame:self.menuOpenedWindow];
    } completion:^(BOOL finished) {
        NSLog(@"Completely Opened");
        if( [sender isKindOfClass:[UIButton class]] == YES )
            [((UIButton*)sender) setBackgroundImage:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_MENU_OPENED] forState:UIControlStateNormal];

        self.isMenuOpened = NO;
        [UIView animateWithDuration:MENU_TABLE_CLOSE_DELAY animations:^{
            [self.mainViewController.view setFrame:self.menuClosedWindow];
            
        } completion:^(BOOL finished) {
            NSLog(@"Completely Closed");
            if( [sender isKindOfClass:[UIButton class]] == YES )
                [((UIButton*)sender) setBackgroundImage:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_MENU_CLOSED] forState:UIControlStateNormal];
        }];
        
    }];
}


-(void)hideMenuBar:(id)sender
{
    self.isMenuOpened = NO;
    [UIView animateWithDuration:MENU_TABLE_CLOSE_DELAY animations:^{
        [self.mainViewController.view setFrame:self.menuClosedWindow];
        
    } completion:^(BOOL finished) {
        NSLog(@"Completely Closed");
        if( [sender isKindOfClass:[UIButton class]] == YES )
            [((UIButton*)sender) setBackgroundImage:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_MENU_CLOSED] forState:UIControlStateNormal];
    }];
   
}


- (void)setRootViewAsParentOfMainView:(UIView*)rootView
{
    [rootView addSubview:self.mainViewController.view];
}

-(void)tapGestureHandler:(UITapGestureRecognizer*)sender
{
    //CGPoint tapPoint = [sender locationInView:self.view];
    
    [self.closeMenubarView removeFromSuperview];
    self.closeMenubarView = nil;
    
    [self hideMenuBar:self.savedSender];
    self.savedSender = nil;
}


#ifdef DEV_TESTGENERATOR_VER
-(void) openTestGenerator
{
    [self.mainViewController loadTestGeneratorViewController];
}
#endif //DEV_TESTGENERATOR_VER

@end