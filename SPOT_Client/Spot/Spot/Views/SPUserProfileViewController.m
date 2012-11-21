//
//  SPUserProfileViewController.m
//  Spot
//
//  Created by redd0g on 12. 11. 8..
//  Copyright (c) 2012년 Sinhyub Kim. All rights reserved.
//


enum {
    SPUserInfoTableSectionInfo = 0,
    SPUserInfoTableSectionSite = 1,
    SPUserInfoTableSectionDesc = 2,
    SPUserInfoTableSectionPhysicalSpot = 3,
    SPUserInfoTableSectionLogicalSpot = 4,
    SPUserInfoTableSectionMax,
};



@interface SPUserProfileViewController ()
@end

@implementation SPUserProfileViewController

@synthesize tableData, userProfileInfo, profileSnap, profileImageBackGround, profileImage, nickName,workingPlace, genderImage, age, tableView, loadedSnapCount;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        userId = 0;
        isMyProfile = NO;
        loadedSnapCount = 0;
        
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_BACKGROUNDTEXTURE]]];
    }
    return self;
}
- (id)initWithUserId:(NSInteger)userIds
{
    self = [super init];
    if(self)
    {
        userId = userIds;

        if([[SPServerObject getInstance].myUserProfileInfo.userInfo userID] == userId)
        {
            isMyProfile = YES;
            userProfileInfo = [SPServerObject getInstance].myUserProfileInfo;
        }
        else
        {
            isMyProfile = NO;
        }
        
        UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(45.0f, 0.0f, 70.0f, 30.0f)];
        [titleLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
        [titleLabel setText:@"User Profile"];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [self.navigationItem setTitleView:titleLabel];
        
        if(tableData == nil)
        {
            tableData = [[NSMutableArray alloc] initWithCapacity:SPUserInfoTableSectionMax];
        }
        
        if( isMyProfile == YES )
        {
            UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
            [menuButton addTarget:[SPMenuTableViewController getInstance] action:@selector(onNavigationMenuBarButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
            [menuButton setBackgroundImage:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_MENU_CLOSED] forState:UIControlStateNormal];
            UIBarButtonItem *menuBarButton = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
            [self.navigationItem setLeftBarButtonItem:menuBarButton];
            
            [titleLabel setText:@"My Profile"];
        }
        
        
        UIColor* labelBackgroundColor = [UIColor whiteColor];
        UIColor* labelTextColor = [UIColor blackColor];
        
        profileSnap = [[UIImageView alloc] initWithFrame:CGRectMake(USERPROFILE_PROFILESNAP_X, USERPROFILE_PROFILESNAP_Y, USERPROFILE_PROFILESNAP_WIDTH, USERPROFILE_PROFILESNAP_HEIGHT)];
        [profileSnap setContentMode:UIViewContentModeScaleAspectFit];
        [self.view addSubview:profileSnap];
        
        profileImageBackGround = [[UIImageView alloc] initWithFrame:CGRectMake(USERPROFILE_PROFILEIMAGE_X-3, USERPROFILE_PROFILEIMAGE_Y-3, USERPROFILE_PROFILEIMAGE_WIDTH+6, USERPROFILE_PROFILEIMAGE_HEIGHT+6)];
        [profileImageBackGround setBackgroundColor:labelBackgroundColor];
        [self.view addSubview:profileImageBackGround];
        
        profileImage = [[UIImageView alloc] initWithFrame:CGRectMake(USERPROFILE_PROFILEIMAGE_X, USERPROFILE_PROFILEIMAGE_Y, USERPROFILE_PROFILEIMAGE_WIDTH, USERPROFILE_PROFILEIMAGE_HEIGHT)];
        [profileImage setContentMode:UIViewContentModeScaleAspectFit];
        [self.view addSubview:profileImage];
        
        
                
        nickName = [[UILabel alloc] initWithFrame:CGRectMake(USERPROFILE_NICKNAME_X, USERPROFILE_NICKNAME_Y, USERPROFILE_NICKNAME_WIDTH, USERPROFILE_NICKNAME_HEIGHT)];
        nickName.viewForBaselineLayout.layer.cornerRadius = 4;
        nickName.textAlignment = NSTextAlignmentCenter;
        [nickName setTextColor:labelTextColor];
        [nickName setBackgroundColor:labelBackgroundColor];
        [self.view addSubview:nickName];
        
        
        workingPlace= [[UILabel alloc] initWithFrame:CGRectMake(USERPROFILE_WORKINGPLACE_X, USERPROFILE_WORKINGPLACE_Y, USERPROFILE_WORKINGPLACE_WIDTH, USERPROFILE_WORKINGPLACE_HEIGHT)];
        workingPlace.viewForBaselineLayout.layer.cornerRadius = 4;
        workingPlace.textAlignment = NSTextAlignmentCenter;
        [workingPlace setTextColor:labelTextColor];
        [workingPlace setBackgroundColor:labelBackgroundColor];
        [self.view addSubview:workingPlace];
        
        
        genderImage = [[UIImageView alloc] initWithFrame:CGRectMake(USERPROFILE_GENDERIMAGE_X, USERPROFILE_GENDERIMAGE_Y, USERPROFILE_GENDERIMAGE_WIDTH, USERPROFILE_GENDERIMAGE_HEIGHT)];
        genderImage.image = [UIImage imageNamed:@"gender.png"];
        genderImage.viewForBaselineLayout.layer.cornerRadius = 4;
        [genderImage setBackgroundColor:labelBackgroundColor];
        [genderImage setContentMode:UIViewContentModeScaleAspectFit];
        [self.view addSubview:genderImage];
        
        age = [[UILabel alloc] initWithFrame:CGRectMake(USERPROFILE_AGE_X,USERPROFILE_AGE_Y,USERPROFILE_AGE_WIDTH,USERPROFILE_AGE_HEIGHT)];
        age.viewForBaselineLayout.layer.cornerRadius = 4;
        age.textAlignment = NSTextAlignmentCenter;
        [age setTextColor:labelTextColor];
        [age setBackgroundColor:labelBackgroundColor];
        [self.view addSubview:age];
        
        [profileSnap setUserInteractionEnabled:YES];
        UITapGestureRecognizer* profileSnapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onProfileSnapPushed)];
        [profileSnap addGestureRecognizer: profileSnapGesture];
        
        [profileImage setUserInteractionEnabled:YES];
        UITapGestureRecognizer* profileImageGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onProfileImagePushed)];
        [profileImage addGestureRecognizer:profileImageGesture];

        [nickName setUserInteractionEnabled:YES];
        UITapGestureRecognizer* nickNameGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onNickNamePushed)];
        [nickName addGestureRecognizer:nickNameGesture];
        
        [age setUserInteractionEnabled:YES];
        UITapGestureRecognizer* ageGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onAgePushed)];
        [age addGestureRecognizer:ageGesture];
        
        [workingPlace setUserInteractionEnabled:YES];
        UITapGestureRecognizer* workingPlaceGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onWorkPlacePushed)];
        [workingPlace addGestureRecognizer:workingPlaceGesture];

        
        tableView = [[UITableView alloc] initWithFrame:CGRectMake(USERPROFILE_TABLE_X,USERPROFILE_TABLE_Y,USERPROFILE_TABLE_WIDTH,USERPROFILE_TABLE_HEIGHT) style:UITableViewStyleGrouped];
        [tableView setBackgroundColor:self.view.backgroundColor];
        [tableView setScrollEnabled:NO];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.backgroundView = nil;
        [self.view addSubview:tableView];
        
        [self loadUserProfileFromServer:userIds];
        [self displayUserProfile];
    }
    return self;
}

- (void) loadView
{
    UIScrollView* scrollView = [[UIScrollView alloc] init];
    scrollView.contentSize = CGSizeMake(320, (USERPROFILE_TABLE_Y+USERPROFILE_TABLE_HEIGHT) );
    scrollView.delegate = self;
    self.view = scrollView;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  
    if(scrollView.contentOffset.y + 500 > scrollView.contentSize.height)
    {
        NSInteger yPoint = scrollView.contentSize.height;
        if(userProfileInfo.snapList)
        {
            NSInteger snapIndex = 0;
            NSInteger snapCount = 3;
            for( SPSnapInfo* snapInfo in userProfileInfo.snapList)
            {
                if(snapIndex < loadedSnapCount)
                {
                    snapIndex++;
                    continue;
                }
                if(snapCount < 0)
                {
                    break;
                }
                //UIImageView* snap = [[UIImageView alloc] initWithFrame:CGRectMake(45, yPoint, USERPROFILE_PROFILESNAP_WIDTH - 50, USERPROFILE_PROFILESNAP_HEIGHT)];
                SPSnapImageView* snap = [[SPSnapImageView alloc] initWithFrame:CGRectMake(45, yPoint, USERPROFILE_PROFILESNAP_WIDTH - 50, USERPROFILE_PROFILESNAP_HEIGHT)];
                [snap setSnapInfo:snapInfo];
                [self.view addSubview:snap];
                
                NSString* profileSnapImageURL = [[NSString alloc] initWithFormat:URL_IMAGE, snapInfo.imageID];
                
                [[RHProtocolSender getInstance] getImageFromURL:[NSURL URLWithString:profileSnapImageURL] WithImageView:snap.imageView WithJSON:nil WithPlaceholder:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_PLACEHHOLDER] Success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                    snap.imageView.image = image;
                } Failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                    
                } TimeOut:15.0f];
                loadedSnapCount++;
                snapCount--;
                
                yPoint += USERPROFILE_PROFILESNAP_HEIGHT + 20;
            }
            

        }
        
        [((UIScrollView*)self.view) setContentSize:CGSizeMake(320, yPoint)];
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    SectionDataContainer* sectionData = [tableData objectAtIndex:section];
    return sectionData.sectionName;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [tableData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SectionDataContainer* sectionData = [tableData objectAtIndex:section];
    return [sectionData.cells count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    SectionDataContainer* sectionData = [tableData objectAtIndex:indexPath.section];
    CellObject* cellData = [sectionData.cells objectAtIndex:indexPath.row];
    switch(indexPath.section)
    {
        case SPUserInfoTableSectionInfo:
        {
            UITableViewCell* tableCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"infoCell"];
            
            [tableCell.imageView setImage:cellData.cellImage];
            [tableCell.textLabel setText:cellData.cellText];
            
            return tableCell;
            
        }
        case SPUserInfoTableSectionSite:
        {
            UITableViewCell* tableCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"siteCell"];
            
            [tableCell.imageView setImage:cellData.cellImage];
            [tableCell.textLabel setText:cellData.cellText];
            if( isMyProfile == YES )
            {
                [tableCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            }

            return tableCell;
            
        }
   
        case SPUserInfoTableSectionDesc:
        {
            UITableViewCell* tableCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"descCell"];
            [tableCell.textLabel setText:cellData.cellText];
            tableCell.textLabel.numberOfLines = 0;
            tableCell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
            if( isMyProfile == YES )
            {
                [tableCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            }
            return tableCell;
        }
        case SPUserInfoTableSectionPhysicalSpot:
        {
            UITableViewCell* tableCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"physicalSpotCell"];
            [tableCell setTag:cellData.tag];
            [tableCell.textLabel setText:cellData.cellText];
            
            return tableCell;
        }
        case SPUserInfoTableSectionLogicalSpot:
        {
            UITableViewCell* tableCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"logicalSpotCell"];
            [tableCell setTag:cellData.tag];
            [tableCell.textLabel setText:cellData.cellText];
            
            return tableCell;
        }
        default:
            break;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView_ didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SectionDataContainer* sectionData = [tableData objectAtIndex:indexPath.section];
    CellObject* cellData = [sectionData.cells objectAtIndex:indexPath.row];
    SEL action = cellData.action;
    
    if(action)
    {
        [self performSelector:cellData.action withObject:tableView_ afterDelay:MENU_TABLE_CLOSE_DELAY];
    }
}

- (void)loadUserProfileFromServer:(NSInteger)userId_
{
    NSString* userProfileURL = [[NSString alloc] initWithFormat:URL_USER, userId_];
    [[RHProtocolSender getInstance] getJSONFromURL:[NSURL URLWithString:userProfileURL] WithJSON:nil Success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSDictionary* JSONDictionary = JSON;
        int result = [[JSON valueForKey:@"success"] intValue];
        if( result == 0 )
        {
            // Error Handling
            [RHUtilities popUpErrorMessage:[JSON valueForKey:@"message"] WithParentViewController:nil];
            return;
        }
        
        NSDictionary* userProfileJSONDictionary = [JSONDictionary valueForKey:@"data"];

        self.userProfileInfo = [[SPUserProfileInfo alloc] initWithJSONDictionary:userProfileJSONDictionary];
        
        [self displayUserProfile];
    } Failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"%@", error.description);
        [RHUtilities handleError:error WithParentViewController:nil];
    } TimeOut:10.f];
    
    
    NSString* profileImageURL = [[NSString alloc] initWithFormat:URL_USER_PROFILEIMAGE, userId_];

    [[RHProtocolSender getInstance] getImageFromURL:[NSURL URLWithString:profileImageURL] WithImageView:self.profileImage WithJSON:nil WithPlaceholder:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_PLACEHHOLDER] Success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        
    } Failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
    } TimeOut:15.0f];
    
    NSString* profileSnapImageURL = [[NSString alloc] initWithFormat:URL_USER_PROFILESNAP, userId_];
    self.profileSnap.image = nil;
    [[RHProtocolSender getInstance] getImageFromURL:[NSURL URLWithString:profileSnapImageURL] WithImageView:self.profileSnap WithJSON:nil WithPlaceholder:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_PLACEHHOLDER] Success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        
        self.profileSnap.image = image;
    } Failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
    } TimeOut:15.0f];


}

- (void)displayUserProfile
{    
    SPUserInfo* userInfo = userProfileInfo.userInfo;
    [nickName setText:userInfo.nickname];
    [workingPlace setText:userInfo.workplace];
    [age setText:userInfo.birthday];
    if([userInfo.gender compare:@"M"])
    {
        [genderImage setImage:[UIImage imageNamed:@"male.png"]];
    }
    else if([userInfo.gender compare:@"F"])
    {
        [genderImage setImage:[UIImage imageNamed:@"female.png"]];
    }
    
    [tableData removeAllObjects];
    
    SectionDataContainer* infoSection = [[SectionDataContainer alloc] init];
    infoSection.sectionName = @"User Information";
    
    CellObject* phoneNoCell = [[CellObject alloc] init];
    phoneNoCell.cellText = userInfo.phoneNumber;
    phoneNoCell.cellImage = [UIImage imageNamed:@"phone.png"];
    phoneNoCell.action = @selector(onPhoneNoCellSelected);
    [infoSection.cells addObject:phoneNoCell];
    
    CellObject* emailCell = [[CellObject alloc] init];
    emailCell.cellText = userInfo.email;
    emailCell.cellImage = [UIImage imageNamed:@"email.png"];
    emailCell.action = @selector(onEmailCellSelected);
    [infoSection.cells addObject:emailCell];
    
    [tableData insertObject:infoSection atIndex:SPUserInfoTableSectionInfo];
    
    SectionDataContainer* siteSection = [[SectionDataContainer alloc] init];
    siteSection.sectionName = @"Site";
    
    CellObject* homepageCell = [[CellObject alloc] init];
    homepageCell.cellText = userInfo.homepage;
    homepageCell.cellImage = [UIImage imageNamed:@"home.png"];
    homepageCell.action = @selector(onHomepageCellSelected);
    [siteSection.cells addObject:homepageCell];
    
    CellObject* facebookCell = [[CellObject alloc] init];
    facebookCell.cellText = userInfo.facebook;
    facebookCell.cellImage = [UIImage imageNamed:@"facebook.png"];
    facebookCell.action = @selector(onFacebookCellSelected);
    [siteSection.cells addObject:facebookCell];
    
    [tableData insertObject:siteSection atIndex:SPUserInfoTableSectionSite];
    
    
    SectionDataContainer* descSection = [[SectionDataContainer alloc] init];
    descSection.sectionName = @"Description";
    
    CellObject* descCell = [[CellObject alloc] init];
    descCell.cellText = userInfo.description;
    descCell.action = @selector(onDescriptionCellSelected);
    [descSection.cells addObject:descCell];
    
    [tableData insertObject:descSection atIndex:SPUserInfoTableSectionDesc];
    
    
    
    SectionDataContainer* physicalSpotSection = [[SectionDataContainer alloc] init];
    physicalSpotSection.sectionName = @"SPOTs";
    
    if(userProfileInfo.physicalSpotList)
    {
        for( SPSpotInfo* spotInfo in userProfileInfo.physicalSpotList)
        {
            CellObject* spotCell = [[CellObject alloc] init];
            spotCell.cellText = spotInfo.spotName;
            spotCell.action = @selector(onSpotCellSelected:);
            spotCell.tag = spotInfo.spotID;
            [physicalSpotSection.cells addObject:spotCell];
        }
    }
    [tableData insertObject:physicalSpotSection atIndex:SPUserInfoTableSectionPhysicalSpot];
    
    SectionDataContainer* logicalSpotSection = [[SectionDataContainer alloc] init];
    logicalSpotSection.sectionName = @"VIRTUAL SPOTs";
    
    if(userProfileInfo.logicalSpotList)
    {
        for( SPSpotInfo* spotInfo in userProfileInfo.logicalSpotList)
        {
            CellObject* spotCell = [[CellObject alloc] init];
            spotCell.cellText = spotInfo.spotName;
            spotCell.action = @selector(onSpotCellSelected:);
            spotCell.tag = spotInfo.spotID;
            [logicalSpotSection.cells addObject:spotCell];
        }
    }
    
    [tableData insertObject:logicalSpotSection atIndex:SPUserInfoTableSectionLogicalSpot];
    

    
    
    NSInteger tableHeight = (userProfileInfo.logicalSpotList.count+userProfileInfo.physicalSpotList.count+12)*(44+1);
    [self.tableView setFrame:CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, tableHeight)];

    
    NSInteger yPoint = (USERPROFILE_TABLE_Y+tableHeight);
    if(userProfileInfo.snapList)
    {
        [userProfileInfo.snapList sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            SPSnapInfo* lhs = (SPSnapInfo*)obj1;
            SPSnapInfo* rhs = (SPSnapInfo*)obj2;
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
            NSDate *ldate = [dateFormatter dateFromString:lhs.snaptime];
            NSDate *rdate = [dateFormatter dateFromString:rhs.snaptime];

            return [ldate compare:rdate];

        }];
        
        
        NSInteger snapCount = 3;
        for( SPSnapInfo* snapInfo in userProfileInfo.snapList)
        {
            if(snapCount < 0 ) break;
            
            //UIImageView* snap = [[UIImageView alloc] initWithFrame:CGRectMake(45, yPoint, USERPROFILE_PROFILESNAP_WIDTH - 50, USERPROFILE_PROFILESNAP_HEIGHT)];
            SPSnapImageView* snap = [[SPSnapImageView alloc] initWithFrame:CGRectMake(45, yPoint, USERPROFILE_PROFILESNAP_WIDTH - 50, USERPROFILE_PROFILESNAP_HEIGHT)];
            [snap setSnapInfo:snapInfo];
            
            [self.view addSubview:snap];
            
            NSString* profileSnapImageURL = [[NSString alloc] initWithFormat:URL_IMAGE, snapInfo.imageID];
            
            [[RHProtocolSender getInstance] getImageFromURL:[NSURL URLWithString:profileSnapImageURL] WithImageView:snap.imageView WithJSON:nil WithPlaceholder:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_PLACEHHOLDER] Success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                snap.imageView.image = image;
            } Failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                
            } TimeOut:15.0f];
            loadedSnapCount++;
            snapCount--;

            yPoint += USERPROFILE_PROFILESNAP_HEIGHT + 20;
        }
    }
    

    [((UIScrollView*)self.view) setContentSize:CGSizeMake(320, yPoint)];
    
    [self.tableView reloadData];
    [self.tableView updateConstraints];

}


////////////////// button selector///////////////////


-(void)onProfileSnapPushed
{
    if( isMyProfile==NO )
        return;
    SPUserProfileEditViewController* editView = [[SPUserProfileEditViewController alloc] initWithField:@"profile_snap" WithHelpMessage:@"Select your profile SNAP" UserProfileViewController:self];
    
    [self.navigationController pushViewController:editView animated:YES];
    
}

-(void)onProfileImagePushed
{
    if( isMyProfile==NO )
        return;
    SPUserProfileEditViewController* editView = [[SPUserProfileEditViewController alloc] initWithField:@"profile_image" WithHelpMessage:@"Select your profile image" UserProfileViewController:self];
    
    [self.navigationController pushViewController:editView animated:YES];
}

-(void)onNickNamePushed
{
    if( isMyProfile==NO || self.nickName!=nil)
        return;
    SPUserProfileEditViewController* editView = [[SPUserProfileEditViewController alloc] initWithField:@"nickname" WithHelpMessage:@"Enter your nickname" UserProfileViewController:self];
    
    [self.navigationController pushViewController:editView animated:YES];
}

-(void)onWorkPlacePushed
{
    if( isMyProfile == NO )
        return;
    
    SPUserProfileEditViewController* editView = [[SPUserProfileEditViewController alloc] initWithField:@"workplace" WithHelpMessage:@"Enter working place" UserProfileViewController:self];
    
    [self.navigationController pushViewController:editView animated:YES];
    
}

-(void)onGenderPushed
{
    //user picker view
    
}

-(void)onAgePushed
{
    if( isMyProfile == NO )
    {
        return;
    }
    SPUserProfileEditViewController* editView = [[SPUserProfileEditViewController alloc] initWithField:@"age" WithHelpMessage:@"Enter Your Age" UserProfileViewController:self];
    
    [self.navigationController pushViewController:editView animated:YES];

}
-(void)onAgePicked
{
    
}

-(void)onPhoneNoCellSelected
{
    return;
    if( isMyProfile == NO )
    {
        return;
    }
    SPUserProfileEditViewController* editView = [[SPUserProfileEditViewController alloc] initWithField:@"phone_number" WithHelpMessage:@"Enter phone number" UserProfileViewController:self];
    
    [self.navigationController pushViewController:editView animated:YES];
}
-(void)onEmailCellSelected
{
    return;
    if( isMyProfile == NO )
    {
        return;
    }
    SPUserProfileEditViewController* editView = [[SPUserProfileEditViewController alloc] initWithField:@"email" WithHelpMessage:@"Enter email address" UserProfileViewController:self];
    
    [self.navigationController pushViewController:editView animated:YES];
}
-(void)onHomepageCellSelected
{
    if( isMyProfile == NO )
    {
        return;
    }
    SPUserProfileEditViewController* editView = [[SPUserProfileEditViewController alloc] initWithField:@"homepage" WithHelpMessage:@"Enter your homepage" UserProfileViewController:self];
    
    [self.navigationController pushViewController:editView animated:YES];
}
-(void)onFacebookCellSelected
{
    if( isMyProfile == NO )
    {
        return;
    }
    SPUserProfileEditViewController* editView = [[SPUserProfileEditViewController alloc] initWithField:@"facebook" WithHelpMessage:@"Enter your facebook" UserProfileViewController:self];
    
    [self.navigationController pushViewController:editView animated:YES];
}
-(void)onDescriptionCellSelected
{
    if( isMyProfile == NO )
    {
        return;
    }
    SPUserProfileEditViewController* editView = [[SPUserProfileEditViewController alloc] initWithField:@"description" WithHelpMessage:@"Enter your description" UserProfileViewController:self];
    
    [self.navigationController pushViewController:editView animated:YES];
}
-(void)onSpotCellSelected:(id) sender
{
    UITableViewCell* tableCell = (UITableViewCell*) sender;
    SPSpotProfileViewController* spotProfileController = [[SPSpotProfileViewController alloc] init];
    [spotProfileController loadDataWithSpotID:tableCell.tag];
    [self.navigationController pushViewController:spotProfileController animated:YES];

}

@end
