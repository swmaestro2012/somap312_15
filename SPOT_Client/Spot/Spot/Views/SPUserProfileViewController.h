//
//  SPUserProfileViewController.h
//  Spot
//
//  Created by redd0g on 12. 11. 8..
//  Copyright (c) 2012년 Sinhyub Kim. All rights reserved.
//


@interface SPUserProfileViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    NSInteger   userId;
    BOOL        isMyProfile;        // MyProfile / OtherUser' Profile
}

@property (strong, nonatomic) NSMutableArray* tableData;
@property (strong, nonatomic) SPUserProfileInfo* userProfileInfo;

@property (strong, nonatomic) UIImageView* profileSnap;
@property (strong, nonatomic) UIImageView* profileImageBackGround;
@property (strong, nonatomic) UIImageView* profileImage;
@property (strong, nonatomic) UILabel* nickName;
@property (strong, nonatomic) UILabel* workingPlace;
@property (strong, nonatomic) UIImageView* genderImage;
@property (strong, nonatomic) UILabel* age;
@property (strong, nonatomic) UITableView* tableView;
@property (nonatomic) NSInteger loadedSnapCount;

- (id) initWithUserId:(NSInteger)userId;

- (void)loadUserProfileFromServer:(NSInteger)userId;
- (void)displayUserProfile;

@end
