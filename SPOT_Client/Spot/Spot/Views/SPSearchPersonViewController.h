//
//  SPSearchPersonViewController.h
//  Spot
//
//  Created by Sinhyub Kim on 11/17/12.
//  Copyright (c) 2012 Sinhyub Kim. All rights reserved.
//

enum {
    SPSearchSectionMyself = 0,
    SPSearchSectionPeopleInSpot = 1,
    SPSearchSectionMax,
};

@interface SearchRow : NSObject
@property (strong, nonatomic) SPUserInfo*   userInfo;
@property (nonatomic) SEL                   action;
@property (strong, nonatomic) UIImage*      profileImage;
@end

@interface SearchSection : NSObject
@property (strong, nonatomic) NSString*         sectionName;
@property (strong, nonatomic) NSMutableArray*   searchRowList;
@end

@interface SPSearchPersonViewController : UIViewController<UISearchDisplayDelegate,UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (strong, nonatomic) NSMutableArray*               searchSectionList;
@property (strong, nonatomic) UISearchBar*                  searchBar;
@property (strong, nonatomic) UISearchDisplayController*    searchController;
@property (strong, nonatomic) SPSpotInfo*                   spotInfo;
@property (weak, nonatomic) SPPostSnapViewController*       postSnapViewController;


- (id)initWithPostSnapViewController:(SPPostSnapViewController*)postSnapViewController_;
- (void)loadTableRows:(NSMutableArray*)resultUserList;
- (void)emptySelector;
- (UIView*)tableView:(UITableView*)aTableView viewForHeaderInSection:(NSInteger)section;

- (void)requestSearchResultsWithKeyword:(NSString*)keyword;


@end
