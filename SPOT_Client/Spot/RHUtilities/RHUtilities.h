//
//  RHUtilities.h
//  RoughHandsFramework_Chat
//
//  Created by Sinhyub Kim on 10/18/12.
//  Copyright (c) 2012 Sinhyub Kim. All rights reserved.
//

#define UUID_KEY @"UUIDForRoughHands"
#define UUID_NONE @"UUID_NONE"

#define PUSHTOKEN_KEY @"PUSHTOKENForRoughHands"
#define PUSHTOKEN_NONE @"PUSHTOKEN_NONE"

#define SERVERKEY_KEY @"ServerKeyForRoughHands"
#define SERVERKEY_NONE @"ServerKey_NONE"

#define USERID_KEY @"UserID"
#define USERID_NONE @"UserID_NONE"



@interface RHUtilities : NSObject

+ (void)initializeUtilities;

+ (void)checkAndSetUUID;
+ (NSString*)getUUID;

+(void)checkAndRequestPushToken;
+(void)setPushToken:(NSData*)pushToken;
+(NSData*)getPushToken;


+ (void)setServerKey:(NSString*)serverKey;
+ (NSString*)getServerKey;

+ (void)setUserID:(NSString*)userID;
+ (NSString*)getUserID;

+ (void)handleError:(NSError*) error WithParentViewController:(UIViewController*) parentViewController;
+ (void)popUpErrorMessage:(NSString*)message WithParentViewController:(UIViewController *)parentViewController;

+ (CLLocation*)getCurrentLocationData;

@end


@protocol JSONObjectDelegate <NSObject>

- (void) callbackWith:(NSMutableDictionary*)JSON;

@end

@protocol ImageObjectDelegate <NSObject>

@end
