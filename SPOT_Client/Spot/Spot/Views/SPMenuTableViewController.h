//
//  SPMenuTableViewController.h
//  Spot
//
//  Created by Sinhyub Kim on 11/5/12.
//  Copyright (c) 2012 Sinhyub Kim. All rights reserved.
//




enum {
    SPMenuTableSectionMain = 0,
    SPMenuTableSectionPhysicalSpot = 1,
    SPMenuTableSectionLogicalSpot = 2,
    SPMenuTableSectionMax,
};


@interface CellObject : NSObject
@property (nonatomic) NSInteger tag;
@property (strong, nonatomic) NSString* cellText;
@property (nonatomic) SEL action;
@property (weak, nonatomic) UIImage* cellImage;
@end

@interface SectionDataContainer : NSObject
@property (strong, nonatomic) NSString* sectionName;
@property (strong, nonatomic) NSMutableArray* cells;
//@property (strong, nonatomic) UIImage* sectionImage;
@end

@interface SPMenuTableViewController : UITableViewController

@property (strong, nonatomic) SPMainViewController* mainViewController;
@property (strong, nonatomic) NSMutableArray* tableData;
@property (strong, nonatomic) UIView* closeMenubarView;
@property (strong, nonatomic) id savedSender;

// SINGLETON
+ (SPMenuTableViewController*) getInstance;
+ (id)allocWithZone:(NSZone *)zone;
- (id)copyWithZone:(NSZone *)zone;
////////////////////////////////////

- (void)setRootViewAsParentOfMainView:(UIView*)secondView;

-(void) initializeTableViewWithActions;
-(void) emptySelector;
-(void) onSignOutMenuSelected;
-(void) onPhysicalSpotMapMenuSelected;
-(void) onLogicalSpotMapMenuSelected;
-(void) onMyProfileMenuSelected;
-(void) onFavoriteMenuSelected;
-(void) onUserMapMenuSelected:(id)sender;
-(void) onNavigationMenuBarButtonPushed:(id)sender;

-(void) openUserMap:(NSString*)spotName;

// *NOTE*
// loadingViewController doesn't use MenuTableViewController
// only one exception of view-controlling

-(void) openMenuBar:(id)sender;
-(void) hideMenuBar:(id)sender;
-(void)openAndCloseMenuBar:(id)sender;

#ifdef DEV_TESTGENERATOR_VER
-(void) openTestGenerator;
#endif  //DEV_TESTGENERATOR_VER
@end

//static SPMenuTableViewController* s_SPMenuTableViewController;