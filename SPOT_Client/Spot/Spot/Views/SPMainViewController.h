//
//  SPMainViewController.h
//  Spot
//
//  Created by Sinhyub Kim on 11/5/12.
//  Copyright (c) 2012 Sinhyub Kim. All rights reserved.
//

@interface SPMainViewController : UIViewController

@property (strong, nonatomic) UIViewController* currentViewController;
// NOTE : DON'T USING ViewController Reuse NO MORE. Just release and reallocation
//@property (strong, nonatomic) UINavigationController* currentNavigationController;

//@property (strong, nonatomic) SPLoadingViewController* loadingViewController;
//@property (strong, nonatomic) SPSpotMapViewController* spotMapViewController;
//@property (strong, nonatomic) SPUserMapViewController* userMapViewController;
//@property (strong, nonatomic) SPUserProfileViewController* userProfileViewController;

//@property (strong, nonatomic) UINavigationController* spotMapNavigationController;
//@property (strong, nonatomic) UINavigationController* userMapNavigationController;
//@property (strong, nonatomic) UINavigationController* userProfileNavigationController;


- (void)loadLoadingViewControllerWithSignInView:(BOOL)isSignInView; // signIn or signOut
- (void)loadSpotMapViewController:(BOOL)isPhysicalSpot;
- (void)loadUserMapViewControllerWithSpotName:(NSString*)spotName;
- (void)loadMyProfileViewController;
- (void)loadFavoriteViewController;
- (UIViewController*)changeCurrentViewControllerAs:(UIViewController*)newViewController;


#ifdef DEV_TESTGENERATOR_VER
//@property (strong, nonatomic) SPTestGeneratorViewController* testGeneratorViewController;
//@property (strong, nonatomic) UINavigationController* testGeneratorNavigationController;
- (void)loadTestGeneratorViewController;
#endif //DEV_TESTGENERATOR_VER
@end

