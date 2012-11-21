//
//  SPServerObject.h
//  Spot
//
//  Created by Sinhyub Kim on 11/9/12.
//  Copyright (c) 2012 Sinhyub Kim. All rights reserved.
//

@interface SPServerObject : NSObject
@property (strong, nonatomic)   SPUserProfileInfo*  myUserProfileInfo;
@property (strong, nonatomic)   UIImage*            myUserProfileImage;
@property (strong, nonatomic)   NSMutableArray*     spotMapCellInfoList;
@property (nonatomic)           BOOL                isSignedIn;

+(SPServerObject*) getInstance;
+(id) allocWithZone:(NSZone *)zone;
-(id) copyWithZone:(NSZone *)zone;
-(void) loadMyProfileInfo:(BOOL)isLogInRoutine;

-(void) onSignInWithServerKey:(NSString*)serverKey_ UserID:(NSString*)userID_;
-(void) onSignOut;

-(BOOL) isMySpot:(NSInteger)spotID;


@end
