//
//  SPServerObject.m
//  Spot
//
//  Created by Sinhyub Kim on 11/9/12.
//  Copyright (c) 2012 Sinhyub Kim. All rights reserved.
//

static SPServerObject* s_ServerObject;

@implementation SPServerObject
@synthesize myUserProfileInfo;
@synthesize myUserProfileImage;
@synthesize isSignedIn;
@synthesize spotMapCellInfoList;

+ (id)allocWithZone:(NSZone *)zone
{
    return [self getInstance];
    //    return [[self getInstance] retain];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

+ (SPServerObject*) getInstance
{
    if ( s_ServerObject == nil )
    {
        s_ServerObject = [[super allocWithZone:NULL] init];
        s_ServerObject.isSignedIn = NO;
    }
    return s_ServerObject;
}

-(void) loadMyProfileInfo:(BOOL)isLogInRoutine
{
    NSAssert(self.isSignedIn==YES, @"Load MyProfile before SignIn");
    
    NSString* myUserIDString = [RHUtilities getUserID];
    NSAssert(myUserIDString !=nil, @"USERID Doesn't initialized");
//    NSAssert([myUserIDString compare:USERID_NONE]!= NSOrderedSame, @"USERID Doesn't initialized");
    NSInteger myUserID = [myUserIDString intValue];

    NSString* myProfileURL = [[NSString alloc] initWithFormat:URL_USER,myUserID];
    [[RHProtocolSender getInstance] getJSONFromURL:[NSURL URLWithString:myProfileURL] WithJSON:nil Success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSDictionary* JSONDictionary = JSON;
        int result = [[JSON valueForKey:@"success"] intValue];
        if( result == 0 )
        {
            // Error Handling
            [RHUtilities popUpErrorMessage:[JSON valueForKey:@"message"] WithParentViewController:nil];
            return;
        }
        
        NSDictionary* myUserProfileJSONDictionary = [JSONDictionary valueForKey:@"data"];
//        NSAssert(self.myUserProfileInfo == nil, @"Spot Info is already initialized");
        NSLog(@"%@", myUserProfileJSONDictionary.description);
        self.myUserProfileInfo = [[SPUserProfileInfo alloc] initWithJSONDictionary:myUserProfileJSONDictionary];
        
        [[SPMenuTableViewController getInstance] initializeTableViewWithActions];

        if( isLogInRoutine == YES )
            [RHUtilities checkAndRequestPushToken];

    } Failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"%@", error.description);
        [RHUtilities handleError:error WithParentViewController:nil];
    } TimeOut:10.f];
    
    
    NSString* profileImageURL = [[NSString alloc] initWithFormat:URL_USER_PROFILEIMAGE, myUserID];
    self.myUserProfileImage = [[UIImage alloc] init];
    [[RHProtocolSender getInstance] getImageFromURL:[NSURL URLWithString:profileImageURL] WithJSON:nil Success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        
        self.myUserProfileImage = image;
    } Failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
    } TimeOut:15.0f];
}

-(void) onSignOut
{
    [[SPServerObject getInstance] setIsSignedIn:NO];
    [RHUtilities setUserID:USERID_NONE];
    [RHUtilities setServerKey:SERVERKEY_NONE];
    [RHUtilities setPushToken:nil];
    [[RHProtocolSender getInstance] setServerKey:SERVERKEY_NONE];
    [[RHProtocolSender getInstance] setUserID:USERID_NONE];
    self.myUserProfileInfo = nil;
}

-(void) onSignInWithServerKey:(NSString*)serverKey_ UserID:(NSString*)userID_
{
    if( serverKey_ != nil)
    {
        [RHUtilities setServerKey:serverKey_];
        [[RHProtocolSender getInstance] setServerKey:serverKey_];
    }
    if( userID_ != nil)
    {
        [RHUtilities setUserID:userID_];
    }
    
    [[SPServerObject getInstance] setIsSignedIn:YES];
    [[SPServerObject getInstance] loadMyProfileInfo:YES];
}

- (BOOL)isMySpot:(NSInteger)spotID
{
    for(SPSpotInfo* curSpotInfo in self.myUserProfileInfo.physicalSpotList)
    {
        if( curSpotInfo.spotID == spotID )
        {
            return YES;
        }
    }
    
    for(SPSpotInfo* curSpotInfo in self.myUserProfileInfo.logicalSpotList)
    {
        if( curSpotInfo.spotID == spotID )
        {
            return YES;
        }
    }
    
    return NO;
}

@end
