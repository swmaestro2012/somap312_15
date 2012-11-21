//  SPAppDelegate.m
//  Spot
//
//  Created by Sinhyub Kim on 11/4/12.
//  Copyright (c) 2012 Sinhyub Kim. All rights reserved.
//

@implementation SPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Push Notification Code
    
    [[UIApplication sharedApplication] setDelegate:self];
//    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    
    
    // Generate UUID for RoughHands App Authentication
    [RHUtilities initializeUtilities];
    // Call GetInstance to Initialize RHProtocolSender
    [RHProtocolSender getInstance];

    
    CGRect rootViewRect = CGRectMake(ROOT_FRAME_X, ROOT_FRAME_Y, ROOT_FRAME_WIDTH, ROOT_FRAME_HEIGHT);
    self.window = [[UIWindow alloc] initWithFrame:rootViewRect];//[[UIScreen mainScreen] bounds]];
    
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    
    SPRootViewController* rootViewController = [[SPRootViewController alloc] init];
    [rootViewController.view setFrame:self.window.frame];
    self.window.rootViewController = rootViewController;
//    [rootViewController.view setBackgroundColor:[UIColor blackColor]];
    
    [self checkSessionAndSelectFirstView];

    NSArray* tempFonts = [UIFont familyNames];
	for(NSString* aFont in tempFonts)
		NSLog(@"%@", aFont);
    
//    sleep(2);
    
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)checkSessionAndSelectFirstView
{
#ifdef DEV_TESTGENERATOR_VER
    [[SPMenuTableViewController getInstance] openTestGenerator];
#else // DEV_TESTGENERATOR_VER
    #ifdef DEV_NOLOGIN_VER
    [[SPMenuTableViewController getInstance] onPhysicalSpotMapMenuSelected];
    #else
        #ifdef DEV_SERVICE_VER
            SPMainViewController* mainViewController = [SPMenuTableViewController getInstance].mainViewController;
            
            RHProtocolSender* protocolSender = [RHProtocolSender getInstance];
            [protocolSender isSessionValidWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSMutableDictionary* JSON = responseObject;
                int result = [[JSON valueForKey:@"success"] intValue];
                if( result == 0 )
                {
                    [RHUtilities popUpErrorMessage:[JSON valueForKey:@"message"] WithParentViewController:self.window.rootViewController];
                    [[SPMenuTableViewController getInstance] hideMenuBar:self];
                    [mainViewController loadLoadingViewControllerWithSignInView:YES];
                    return;
                }
                
                [[SPServerObject getInstance] onSignInWithServerKey:nil UserID:nil];
                [[SPMenuTableViewController getInstance] onPhysicalSpotMapMenuSelected];
            } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [RHUtilities handleError:error WithParentViewController:mainViewController];
                [[SPServerObject getInstance] onSignOut];
                [[SPMenuTableViewController getInstance] hideMenuBar:self];
                [mainViewController loadLoadingViewControllerWithSignInView:YES];
            }];
        #endif // DEV_SERVICE_VER
    #endif // DEV_NOLOGIN_VER
#endif // DEV_TESTGENERATOR_VER

#ifdef DEV_SNAPSHOTVIEWTEST_VER
    SPMainViewController* mainViewController = [SPMenuTableViewController getInstance].mainViewController;
    
    RHProtocolSender* protocolSender = [RHProtocolSender getInstance];
    [protocolSender isSessionValidWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableDictionary* JSON = responseObject;
        int result = [[JSON valueForKey:@"success"] intValue];
        if( result == 0 )
        {
            [RHUtilities popUpErrorMessage:[JSON valueForKey:@"message"] WithParentViewController:self.window.rootViewController];
            [[SPMenuTableViewController getInstance] hideMenuBar:self];
            [mainViewController loadLoadingViewControllerWithSignInView:YES];
            return;
        }
        
        [[SPServerObject getInstance] onSignInWithServerKey:nil UserID:nil];
        [[SPMenuTableViewController getInstance] onPhysicalSpotMapMenuSelected];
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [RHUtilities handleError:error WithParentViewController:mainViewController];
        [[SPServerObject getInstance] onSignOut];
        [[SPMenuTableViewController getInstance] hideMenuBar:self];
        [mainViewController loadLoadingViewControllerWithSignInView:YES];
    }];
#endif
    

}

// Push Notification Code
-(void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"Registered Device token %@", deviceToken);
    
    [RHUtilities setPushToken:deviceToken];
    // TO DO :
    // send deviceToken to server
    SPUserInfo* myUserInfo = [SPServerObject getInstance].myUserProfileInfo.userInfo;
    NSAssert( myUserInfo != nil, @"Userinfo has to be initialized before Reequest PUSH TOKEN" );
    NSString* tokenPostURL = [[NSString alloc] initWithFormat:URL_TOKEN,myUserInfo.userID];
    
    NSLog(@"%@",deviceToken.description);
    NSString* pushTokenString = deviceToken.description;
    pushTokenString = [pushTokenString stringByReplacingOccurrencesOfString:@"<" withString:@""];
    pushTokenString = [pushTokenString stringByReplacingOccurrencesOfString:@">" withString:@""];
    NSLog(@"%@", pushTokenString);
    
    NSMutableDictionary* tokenData = [[NSMutableDictionary alloc] initWithObjectsAndKeys:pushTokenString, @"token", nil];
    
    
    
    
    
    [[RHProtocolSender getInstance] postToURL:[NSURL URLWithString:tokenPostURL] WithJSON:tokenData Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        int result = [[responseObject valueForKey:@"success"] intValue];
        if( result == 0 )
        {
            // Error Handling
            [RHUtilities popUpErrorMessage:[responseObject valueForKey:@"message"] WithParentViewController:nil];
            return;
        }
        
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [RHUtilities handleError:error WithParentViewController:nil];
    } TimeOut:20.0f];

}
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSLog(@"Error in registration. Error: %@", err);
}

-(void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //~
    NSLog(@"%@", userInfo.description);
    NSDictionary* apsData = [userInfo valueForKey:@"aps"];
    NSString* alert = [apsData valueForKey:@"alert"];
//    NSInteger badgeCount = [[apsData valueForKey:@"badge"] integerValue];
    
    [RHUtilities popUpErrorMessage:alert WithParentViewController:nil];
}
@end
