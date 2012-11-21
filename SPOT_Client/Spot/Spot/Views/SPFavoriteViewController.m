//
//  SPFavoriteViewController.m
//  Spot
//
//  Created by Sinhyub Kim on 11/20/12.
//  Copyright (c) 2012 Sinhyub Kim. All rights reserved.
//


@interface SPFavoriteViewController ()

@end

@implementation SPFavoriteViewController
@synthesize favoriteSnapList;
@synthesize favoriteSnapImageViewList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        favoriteSnapList = [[NSMutableArray alloc] init];
        favoriteSnapImageViewList = [[NSMutableArray alloc] init];
        [self loadMyFavoriteSnapListFromServer];
        
        UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(45.0f, 0.0f, 70.0f, 30.0f)];
        [titleLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
        [titleLabel setText:@"Favorite SNAPs"];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [self.navigationItem setTitleView:titleLabel];
        
        UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [menuButton addTarget:[SPMenuTableViewController getInstance] action:@selector(onNavigationMenuBarButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
        [menuButton setBackgroundImage:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_MENU_CLOSED] forState:UIControlStateNormal];
        UIBarButtonItem *menuBarButton = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
        [self.navigationItem setLeftBarButtonItem:menuBarButton];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)loadView
{
    UIScrollView* scrollView = [[UIScrollView alloc] init];
    [scrollView setBackgroundColor:[UIColor colorWithPatternImage:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_BACKGROUNDTEXTURE]]];
    self.view = scrollView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadMyFavoriteSnapListFromServer
{
    NSInteger myUserID = [SPServerObject getInstance].myUserProfileInfo.userInfo.userID;
    NSString* favoriteURL = [[NSString alloc] initWithFormat:URL_FAVORITE,myUserID];
    
    [[RHProtocolSender getInstance] getJSONFromURL:[NSURL URLWithString:favoriteURL] WithJSON:nil Success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        int result = [[JSON valueForKey:@"success"] intValue];
        if( result == 0 )
        {
            // Error Handling
            [RHUtilities popUpErrorMessage:[JSON valueForKey:@"message"] WithParentViewController:nil];
            return;
        }
        
        NSDictionary* snapListJSON = [JSON valueForKey:@"data"];
        
        NSArray* snapListArray = [snapListJSON valueForKey:@"favorite_snap_list"];
        for( NSDictionary* snapInfoDic in snapListArray )
        {
            SPSnapInfo* snapInfo = [[SPSnapInfo alloc] initWithJSONDictionary:snapInfoDic];
            [self.favoriteSnapList addObject:snapInfo];
        }
        
        [self displayMyFavoriteSnapList];

    } Failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [RHUtilities handleError:error WithParentViewController:self];
    } TimeOut:15.0f];
}

- (void)displayMyFavoriteSnapList
{    
    int snapCount = 0;
    if( [self.favoriteSnapList count])
    
    for( SPSnapInfo* snapInfo in self.favoriteSnapList )
    {
        
        // ImageView
        CGRect currentFrame = CGRectMake((MAIN_FRAME_WIDTH-snapWidth)/2, 30+(snapCount*(snapHeight+snapInterval)), snapWidth, snapHeight);
        SPSnapImageView* snapImageView = [[SPSnapImageView alloc] initWithFrame:currentFrame];
        [snapImageView setSnapInfo:snapInfo];
        [self.view addSubview:snapImageView];
        [self.favoriteSnapImageViewList addObject:snapImageView];
        
        NSString* snapURL = [[NSString alloc] initWithFormat:URL_IMAGE, snapInfo.imageID];
        [[RHProtocolSender getInstance] getImageFromURL:[NSURL URLWithString:snapURL] WithImageView:snapImageView.imageView WithJSON:nil WithPlaceholder:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_PLACEHHOLDER] Success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            
        } Failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            [RHUtilities handleError:error WithParentViewController:self];
        } TimeOut:15.0f];
        
        
        // Go To SNAP
        UIButton* gotoProfileButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [gotoProfileButton setFrame:CGRectMake(currentFrame.origin.x+currentFrame.size.width-POPUP_GOTOPROFILE_BUTTON_WIDTH*3/2,
                                               currentFrame.origin.y+currentFrame.size.height-POPUP_GOTOPROFILE_BUTTON_HEIGHT/2,
                                               POPUP_GOTOPROFILE_BUTTON_WIDTH, POPUP_GOTOPROFILE_BUTTON_HEIGHT)];
        [gotoProfileButton setBackgroundImage:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_BAR320]  forState:UIControlStateNormal];
        [gotoProfileButton setBackgroundImage:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_BAR320]  forState:UIControlStateHighlighted];
        [gotoProfileButton setTitle:@"MORE INFO" forState:UIControlStateNormal];
        //        [self.popUpGotoProfileButton setBackgroundImage:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_ICON_OPENPROFILE]  forState:UIControlStateNormal];
        //        [self.popUpGotoProfileButton setBackgroundImage:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_ICON_OPENPROFILE]  forState:UIControlStateHighlighted];
        [gotoProfileButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
        [gotoProfileButton addTarget:self action:@selector(gotoProfileButton:) forControlEvents:UIControlEventTouchUpInside];
        [gotoProfileButton setTag:snapInfo.snapID];
        [self.view addSubview:gotoProfileButton];
        
        snapCount++;
    }
    
    UIScrollView* scrollView = (UIScrollView*)self.view;
    [scrollView setContentSize:CGSizeMake(MAIN_FRAME_WIDTH, 50+(snapHeight+snapInterval)*snapCount)];

}

- (void)gotoProfileButton:(id)sender
{
    if( [sender isMemberOfClass:[UIButton class]] == NO )
    {
        NSAssert(NO,@"FUCKED UP GIVE ME MORE TIME!!");
        return;
    }
    
    UIButton* gotoProfileButton = sender;
    NSInteger snapID = gotoProfileButton.tag;
    
    SPSnapImageView* selectedSnapImageView = nil;
    for( SPSnapImageView* snapImageView in self.favoriteSnapImageViewList )
    {
        if (snapImageView.snapInfo.snapID == snapID )
        {
            selectedSnapImageView = snapImageView;
        }
    }
    
    if( selectedSnapImageView == nil )
    {
        NSAssert(NO, @"FUCK YOU FUCK YOU");
        return;
    }
    
    SPSnapShotViewController* snapShowView = [[SPSnapShotViewController alloc] initWithSnapInfo:selectedSnapImageView];
    [self.navigationController pushViewController:snapShowView animated:YES];

    
}

@end
