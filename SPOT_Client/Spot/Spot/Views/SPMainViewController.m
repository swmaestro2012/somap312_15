//
//  SPMainViewController.m
//  Spot
//
//  Created by Sinhyub Kim on 11/5/12.
//  Copyright (c) 2012 Sinhyub Kim. All rights reserved.
//


@implementation SPMainViewController
@synthesize currentViewController;
//@synthesize spotMapViewController;
//@synthesize userMapViewController;
//@synthesize userProfileViewController;
//@synthesize spotMapNavigationController;
//@synthesize userMapNavigationController;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        currentViewController = nil;
        
        CGRect mainViewRect = CGRectMake(MAIN_FRAME_X, MAIN_FRAME_Y, MAIN_FRAME_WIDTH, MAIN_FRAME_HEIGHT);
        [self.view setFrame:mainViewRect];
        [self.view setClipsToBounds:YES];
        
//        UIImageView* backgroundImage = [[UIImageView alloc] initWithImage:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_PLACEHHOLDER]];
//        [backgroundImage setFrame:CGRectMake(MAIN_FRAME_X, MAIN_FRAME_Y, MAIN_FRAME_WIDTH, MAIN_FRAME_HEIGHT-20)];
//        [backgroundImage setClipsToBounds:NO];
//        [self.view addSubview:backgroundImage];
        [self.view setBackgroundColor:[UIColor blackColor]];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.


//    [self.view setBackgroundColor:[UIColor blueColor]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController*)changeCurrentViewControllerAs:(UIViewController*)newViewController// WithNavigationController:(UINavigationController*)newNavigationController
{
    UIViewController* oldViewController = self.currentViewController;
//    UINavigationController* oldNavigationController = self.navigationController;
    
    if( self.currentViewController != nil )
    {
        [self.currentViewController.view removeFromSuperview];
    }
    
//    if( self.currentNavigationController != nil)
//    {
//        self.currentNavigationController = nil;
//    }
    
    [self setCurrentViewController:newViewController];
    [self.view addSubview:self.currentViewController.view];
    [self.currentViewController.navigationController didMoveToParentViewController:self];
    [self.currentViewController didMoveToParentViewController:self];

//    [self setCurrentNavigationController:newNavigationController];
    
    return oldViewController;
}

- (void)loadLoadingViewControllerWithSignInView:(BOOL)isSignInView
{
//    if( self.loadingViewController == nil )
//    {
//        self.loadingViewController = [[SPLoadingViewController alloc] init];
//        
//        // Loading View doesn't use NavigationController
//        // Just Add View as a SubView of mainViewController
//        [self.loadingViewController.view setFrame:CGRectMake(MAIN_FRAME_X, MAIN_FRAME_Y, MAIN_FRAME_WIDTH, MAIN_FRAME_HEIGHT)];
//        [self.view addSubview:self.loadingViewController.view];
//    }
//    
//    if( isSignInView == YES )
//    {
//        [self.loadingViewController displaySignInView];
//    }
//    else
//    {
//        [self.loadingViewController displaySignUpView];
//    }
//    
//    [self changeCurrentViewControllerAs:self.loadingViewController];


    SPLoadingViewController* loadingViewController = [[SPLoadingViewController alloc] init];

    // Loading View doesn't use NavigationController
    // Just Add View as a SubView of mainViewController
    [loadingViewController.view setFrame:CGRectMake(MAIN_FRAME_X, MAIN_FRAME_Y, MAIN_FRAME_WIDTH, MAIN_FRAME_HEIGHT)];
    [self.view addSubview:loadingViewController.view];

    if( isSignInView == YES )
    {
        [loadingViewController displaySignInView];
    }
    else
    {
        [loadingViewController displaySignUpView];
    }

    [self changeCurrentViewControllerAs:loadingViewController];

}

- (void)loadSpotMapViewController:(BOOL)isPhysicalSpot
{
    SPSpotMapViewController* spotMapViewController = [[SPSpotMapViewController alloc] init];//[[SPSnapMapViewController alloc] init];

    // Spot Map View as a new NavigationController Root View
    UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:
                                                     [[UIViewController alloc]init]];
    
    [navigationController.view setFrame:CGRectMake(NAVIGATION_FRAME_X, NAVIGATION_FRAME_Y,
                                                   NAVIGATION_FRAME_WIDTH, NAVIGATION_FRAME_HEIGHT)];
    [navigationController.navigationBar setFrame:CGRectMake(NAVIGATIONBAR_FRAME_X, NAVIGATIONBAR_FRAME_Y,
                                                            NAVIGATIONBAR_FRAME_WIDTH, NAVIGATIONBAR_FRAME_HEIGHT)];
    [navigationController.navigationBar setBackgroundImage:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_NAVBAR320] forBarMetrics:UIBarMetricsDefault];
    [navigationController setNavigationBarHidden:NO];
    [navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    [navigationController setToolbarHidden:YES];
    [navigationController.toolbar setBarStyle:UIBarStyleBlackTranslucent];
        
        
    [self.view addSubview:navigationController.view];

    [navigationController pushViewController:spotMapViewController animated:NO];
        
    NSAssert(navigationController == spotMapViewController.navigationController, @"Error in setting up NavigationController of SpotMapViewController");
    
    [((UIButton*)(spotMapViewController.navigationItem.leftBarButtonItem).customView) setBackgroundImage:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_MENU_CLOSED] forState:UIControlStateNormal];
    
    [((SPSpotMapView*)spotMapViewController.view) setIsPhysicalSpotMapView:isPhysicalSpot];
    [spotMapViewController loadSpotMapViewFromServer:isPhysicalSpot];
    [self changeCurrentViewControllerAs:navigationController];
}

- (void)loadUserMapViewControllerWithSpotName:(NSString*)spotName
{    
    SPUserMapViewController* userMapViewController = [[SPUserMapViewController alloc] init];
        
    // User Map View as a new NavigationController Root View
    UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:
                                                    [[UIViewController alloc]init]];
    
    [navigationController.view setFrame:CGRectMake(NAVIGATION_FRAME_X, NAVIGATION_FRAME_Y,
                                                   NAVIGATION_FRAME_WIDTH, NAVIGATION_FRAME_HEIGHT)];
    [navigationController.navigationBar setFrame:CGRectMake(NAVIGATIONBAR_FRAME_X, NAVIGATIONBAR_FRAME_Y,
                                                            NAVIGATIONBAR_FRAME_WIDTH, NAVIGATIONBAR_FRAME_HEIGHT)];
    [navigationController.navigationBar setBackgroundImage:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_NAVBAR320] forBarMetrics:UIBarMetricsDefault];
    [navigationController setNavigationBarHidden:NO];
    [navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    [navigationController setToolbarHidden:YES];
    [navigationController.toolbar setBarStyle:UIBarStyleBlackTranslucent];
    
    
    [self.view addSubview:navigationController.view];
    
    [navigationController pushViewController:userMapViewController animated:NO];
    
    SPSpotInfo* spotInfo = nil;
    for( SPSpotInfo* curSpotInfo in [SPServerObject getInstance].myUserProfileInfo.physicalSpotList )
    {
        if( [curSpotInfo.spotName compare:spotName]==NSOrderedSame )
        {
            spotInfo = curSpotInfo;
            break;
        }
    }
    
    if( spotInfo == nil )
    {
        for( SPSpotInfo* curSpotInfo in [SPServerObject getInstance].myUserProfileInfo.logicalSpotList )
        {
            if( [curSpotInfo.spotName compare:spotName]==NSOrderedSame )
            {
                spotInfo = curSpotInfo;
                break;
            }
        }
    }
    
    NSAssert(spotInfo != nil, @"spot info must be found");
    [((SPUserMapView*)userMapViewController.view) setSpotInfo:spotInfo];
    
    [((UIButton*)(userMapViewController.navigationItem.leftBarButtonItem).customView) setBackgroundImage:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_MENU_CLOSED] forState:UIControlStateNormal];

    
    [userMapViewController loadUserMapViewFromServer];
    UIViewController* oldViewController = [self changeCurrentViewControllerAs:navigationController];

    NSAssert(oldViewController != nil, @"CurrentViewController have to be NOT NIL");
}


- (void)loadMyProfileViewController
{
    
    NSInteger userID = [[SPServerObject getInstance].myUserProfileInfo.userInfo userID];
    SPUserProfileViewController* userProfileViewController = [[SPUserProfileViewController alloc] initWithUserId:userID];
    
    
    UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:userProfileViewController];
    
    [navigationController.view setFrame:CGRectMake(NAVIGATION_FRAME_X, NAVIGATION_FRAME_Y,
                                                   NAVIGATION_FRAME_WIDTH, NAVIGATION_FRAME_HEIGHT)];
    [navigationController.navigationBar setFrame:CGRectMake(NAVIGATIONBAR_FRAME_X, NAVIGATIONBAR_FRAME_Y,
                                                            NAVIGATIONBAR_FRAME_WIDTH, NAVIGATIONBAR_FRAME_HEIGHT)];
    [navigationController.navigationBar setBackgroundImage:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_NAVBAR320] forBarMetrics:UIBarMetricsDefault];
    [navigationController setNavigationBarHidden:NO];
    [navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    [navigationController setToolbarHidden:YES];
    [navigationController.toolbar setBarStyle:UIBarStyleBlackTranslucent];
    [self.view addSubview:navigationController.view];
    
    //[navigationController pushViewController: self.userProfileViewController animated:NO];
    
    NSAssert(navigationController == userProfileViewController.navigationController, @"Error in setting up NavigationController of SpotMapViewController");


    [((UIButton*)(userProfileViewController.navigationItem.leftBarButtonItem).customView) setBackgroundImage:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_MENU_CLOSED] forState:UIControlStateNormal];
    
    [self changeCurrentViewControllerAs:navigationController];
}

- (void)loadFavoriteViewController
{
    SPFavoriteViewController* favoriteViewController = [[SPFavoriteViewController alloc] init];
    UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:favoriteViewController];
    
    [navigationController.view setFrame:CGRectMake(NAVIGATION_FRAME_X, NAVIGATION_FRAME_Y,
                                                   NAVIGATION_FRAME_WIDTH, NAVIGATION_FRAME_HEIGHT)];
    [navigationController.navigationBar setFrame:CGRectMake(NAVIGATIONBAR_FRAME_X, NAVIGATIONBAR_FRAME_Y,
                                                            NAVIGATIONBAR_FRAME_WIDTH, NAVIGATIONBAR_FRAME_HEIGHT)];
    [navigationController.navigationBar setBackgroundImage:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_NAVBAR320] forBarMetrics:UIBarMetricsDefault];
    [navigationController setNavigationBarHidden:NO];
    [navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    [navigationController setToolbarHidden:YES];
    [navigationController.toolbar setBarStyle:UIBarStyleBlackTranslucent];
    [self.view addSubview:navigationController.view];
    
    //[navigationController pushViewController: self.userProfileViewController animated:NO];
    
    NSAssert(navigationController == favoriteViewController.navigationController, @"Error in setting up NavigationController of SpotMapViewController");
    
    [self changeCurrentViewControllerAs:navigationController];    
}


#ifdef DEV_TESTGENERATOR_VER
//@synthesize testGeneratorViewController;
//@synthesize testGeneratorNavigationController;
- (void)loadTestGeneratorViewController
{
    SPTestGeneratorViewController* testGeneratorViewController = [[SPTestGeneratorViewController alloc] init];
        
        
    UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:testGeneratorViewController];
    
    [navigationController.view setFrame:CGRectMake(NAVIGATION_FRAME_X, NAVIGATION_FRAME_Y,
                                                   NAVIGATION_FRAME_WIDTH, NAVIGATION_FRAME_HEIGHT)];
    [navigationController.navigationBar setFrame:CGRectMake(NAVIGATIONBAR_FRAME_X, NAVIGATIONBAR_FRAME_Y,
                                                            NAVIGATIONBAR_FRAME_WIDTH, NAVIGATIONBAR_FRAME_HEIGHT)];
    [navigationController.navigationBar setBackgroundImage:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_NAVBAR320] forBarMetrics:UIBarMetricsDefault];
    [navigationController setNavigationBarHidden:NO];
    [navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    [navigationController setToolbarHidden:YES];
    [navigationController.toolbar setBarStyle:UIBarStyleBlackTranslucent];
    [self.view addSubview:navigationController.view];
    
    //[navigationController pushViewController: self.testGeneratorViewController animated:NO];
        
    NSAssert(navigationController == testGeneratorViewController.navigationController, @"Error in setting up NavigationController of SpotMapViewController");

    
    [((UIButton*)(testGeneratorViewController.navigationItem.leftBarButtonItem).customView) setBackgroundImage:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_MENU_CLOSED] forState:UIControlStateNormal];
    [self changeCurrentViewControllerAs:navigationController];
    
}
#endif //DEV_TESTGENERATOR_VER

@end
