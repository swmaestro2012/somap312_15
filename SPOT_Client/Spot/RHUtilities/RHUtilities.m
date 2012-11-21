//
//  RHUtilities.m
//  RoughHandsFramework_Chat
//
//  Created by Sinhyub Kim on 10/18/12.
//  Copyright (c) 2012 Sinhyub Kim. All rights reserved.
//

@implementation RHUtilities

+(void)initializeUtilities
{
    [RHUtilities checkAndSetUUID];
    
    // To Initialize Instance just call Singleton Methods
    [RHProtocolSender getInstance];
    [RHImageManager getInstance];
}

+(void)checkAndSetUUID
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    if( [userDefaults objectForKey:UUID_KEY] == nil )
    {
        CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
        NSString* uuidString = (__bridge NSString*)CFUUIDCreateString(kCFAllocatorDefault, uuid);
        [userDefaults setObject:uuidString forKey:UUID_KEY];
    }
}

+(NSString*)getUUID
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* uuidString = [userDefaults objectForKey:UUID_KEY];
    if( uuidString == nil )
    {
        return UUID_NONE;
    }

    return uuidString;
}

+(void)checkAndRequestPushToken
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSData* pushToken = [userDefaults objectForKey:PUSHTOKEN_KEY];
    if( pushToken == nil )
    {
        // Request PushToken To APNS
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    }
    else if( [((NSString*)pushToken.description) compare:PUSHTOKEN_NONE] == NSOrderedSame )// [pushToken isMemberOfClass:[NSString class]]==YES )
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    }
    else
    {
        SPUserInfo* myUserInfo = [SPServerObject getInstance].myUserProfileInfo.userInfo;
        NSAssert( myUserInfo != nil, @"Userinfo has to be initialized before Reequest PUSH TOKEN" );
        NSString* tokenPostURL = [[NSString alloc] initWithFormat:URL_TOKEN,myUserInfo.userID];
        
        NSLog(@"%@",pushToken.description);
        NSString* pushTokenString = pushToken.description;
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
//        NSAssert(NO, @"PushToken did not cleared");
    }
    
    // In fact, we have to request whenever Signing-in to server.
//    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
}

+(void)setPushToken:(NSData*)pushToken
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:(pushToken==nil)?PUSHTOKEN_NONE:pushToken forKey:PUSHTOKEN_KEY];
}

+(NSData*)getPushToken
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSData* pushToken = [userDefaults objectForKey:PUSHTOKEN_KEY];
    if( pushToken == nil )
    {
        return nil;
    }
    else if( [pushToken isMemberOfClass:[NSString class]] == YES )
    {
        if( [((NSString*)pushToken) compare:PUSHTOKEN_NONE] == NSOrderedSame )
        {
            return nil;
        }
    }
    
    return pushToken;
}


+(void)setServerKey:(NSString*) serverKey
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:serverKey forKey:SERVERKEY_KEY];
}

+(NSString*)getServerKey
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* serverKey = [userDefaults objectForKey:SERVERKEY_KEY];
    if( serverKey == nil )
    {
        return SERVERKEY_NONE;
    }
    
    return serverKey;
}

+(void)setUserID:(NSString*)userID
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:userID forKey:USERID_KEY];
}

+(NSString*)getUserID
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* userID = [userDefaults objectForKey:USERID_KEY];
    if( userID == nil )
    {
        return USERID_NONE;
    }
    
    return userID;
}

+(void) handleError:(NSError*) error WithParentViewController:(UIViewController*) parentViewController
{
    UIAlertView *errorPopUp = [[UIAlertView alloc] initWithTitle:@"Network Error"
                                                         message:error.description
                                                        delegate:parentViewController
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
    
    
//    UIWebView* webView
    [errorPopUp show];

}

+(void) popUpErrorMessage:(NSString*)message WithParentViewController:(UIViewController *)parentViewController
{
#ifndef SERVICE_VER
    UIAlertView *errorPopUp = [[UIAlertView alloc] initWithTitle:@"SPOT GUIDE"
                                                         message:message
                                                        delegate:parentViewController
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
    [errorPopUp show];
#endif
}

+ (CLLocation*)getCurrentLocationData
{
    CLLocationManager* locationManager = [[CLLocationManager alloc] init];
    locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    CLLocation* currentLocation = [locationManager location];
    [locationManager stopUpdatingLocation];
    return currentLocation;
}



@end
