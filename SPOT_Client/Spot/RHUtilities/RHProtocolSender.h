//
//  RHProtocolSender.h
//  TestPageNetwork
//
//  Created by Sinhyub Kim on 10/11/12.
//  Copyright (c) 2012 Sinhyub Kim. All rights reserved.
//

#define URL_SIGNIN @"http://roughhands.kr/users/signin/"
#define URL_CHECKSESSION @"http://roughhands.kr/users/checksession/"
#define URL_SIGNOUT @"http://roughhands.kr/users/signout/"
#define URL_USER @"http://roughhands.kr/users/%d/"
#define URL_USERS @"http://roughhands.kr/users/"
#define URL_USER_PROFILE @"http://roughhands.kr/users/%d/"
// USERS : GET : retrieve all users list
// USERS : POST : SignUp (add a user to UserDB)
#define URL_USER_PROFILESNAP @"http://roughhands.kr/users/%d/profile_snap/"
#define URL_USER_PROFILEIMAGE @"http://roughhands.kr/users/%d/profile_image/"
#define URL_USER_SPOTS @"http://roughhands.kr/users/%d/spots/"
#define URL_IMAGE @"http://roughhands.kr/images/%d/"
#define URL_IMAGES @"http://roughhands.kr/images/"
#define URL_SNAPS @"http://roughhands.kr/snaps/"
#define URL_SNAP @"http://roughhands.kr/snaps/%d/"
#define URL_SPOT @"http://roughhands.kr/spots/%d/"

#define URL_SPOT_JOIN @"http://roughhands.kr/spots/%d/join/"
#define URL_PHYSICALSPOTMAP @"http://roughhands.kr/spots/physical_map/"
#define URL_LOGICALSPOTMAP @"http://roughhands.kr/spots/logical_map/"
#define URL_USERMAP @"http://roughhands.kr/spots/%d/map/"




#define URL_COMMENTS @"http://roughhands.kr/snaps/%d/comments/"
#define URL_LIKE @"http://roughhands.kr/snaps/%d/like/"
#define URL_DISLIKE @"http://roughhands.kr/snaps/%d/dislike/"

#define URL_SEARCHUSER @"http://roughhands.kr/spots/%d/search_users/"

#define URL_TOKEN @"http://roughhands.kr/users/%d/token/"

#define URL_FAVORITE @"http://roughhands.kr/users/%d/favorite/"

@interface RHProtocolSender : NSObject

@property (strong, nonatomic) SBJsonWriter* JSONWriter;
@property (strong, atomic, getter=getServerKey) NSString* serverKey;
@property (strong, atomic, getter=getUserID) NSString* userID;

+ (RHProtocolSender*) getInstance;

- (void) initializeRoughHands;
+ (id)allocWithZone:(NSZone *)zone;
- (id)copyWithZone:(NSZone *)zone;

- (NSString*)getServerKey;
- (NSString*)getUserID;

- (void)isSessionValidWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject)) success
                          Failure:(void (^)(AFHTTPRequestOperation *operation, NSError* error)) failure;
- (void)signInWithUserID:(NSString*)userID_ Password:(NSString*)password_
           WithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject)) success
               Failure:(void (^)(AFHTTPRequestOperation *operation, NSError* error)) failure
                 TimeOut:(float)timeOut;
- (void)signOutSessionWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject)) success
                          Failure:(void (^)(AFHTTPRequestOperation *operation, NSError* error)) failure;





// BASE NETWORK METHODS
- (void) postToURL:(NSURL*)targetURL
          WithJSON:(NSMutableDictionary*)dataDictionary
           Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject)) success
           Failure:(void (^)(AFHTTPRequestOperation *operation, NSError* error)) failure
           TimeOut:(NSTimeInterval) timeout;

- (void)       postToURL:(NSURL*)targetURL
                WithJSON:(NSMutableDictionary *)dataDictionary
               WithImage:(UIImage*)postImage Name:(NSString*)name FileName:(NSString*) fileName
                 Success:(void (^)(AFHTTPRequestOperation *, id))success
                 Failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
     UploadProgressBlock:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))  uploadProgressBlock;
//TO DO :: implement Timeout
//       TimeOut:(NSTimeInterval)timeout


- (void) getImageFromURL:(NSURL*)targetURL
           WithImageView:(UIImageView*) targetView
                WithJSON:(NSMutableDictionary *)dataDictionary
         WithPlaceholder:(UIImage*) placeholderImage
                 Success:(void (^)(NSURLRequest* request, NSHTTPURLResponse* response, UIImage* image)) success
                 Failure:(void (^)(NSURLRequest* request, NSHTTPURLResponse* response, NSError* error)) failure
                 TimeOut:(NSTimeInterval) timeout;


- (void) getImageFromURL:(NSURL*)targetURL
                WithJSON:(NSMutableDictionary *)dataDictionary
                 Success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)) success
                 Failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)) failure
                 TimeOut:(NSTimeInterval) timeout;

//    NSURL *url = [NSURL URLWithString:@"http://192.168.1.189/image"];
- (void) getJSONFromURL:(NSURL*)targetURL
               WithJSON:(NSMutableDictionary *)dataDictionary
                Success:(void (^)(NSURLRequest* request, NSHTTPURLResponse* response, id JSON)) success
                Failure:(void (^)(NSURLRequest* request, NSHTTPURLResponse* response, NSError* error, id JSON)) failure
                TimeOut:(NSTimeInterval) timeout;

//redd0g's io
- (void) getFromURL:(NSURL*)url onSuccess:(void (^)(id JSON))action;
- (void) getFromURL:(NSURL*)url onSuccess:(void (^)(id JSON))action onFailure:(void(^)(NSError* error))failAction;
@end


//// POST PROTOCOL WITH IMAGE EXAMPLE
//NSMutableDictionary* postDictionary = [[NSMutableDictionary alloc] init];
//[postDictionary setValue:@"99" forKey:@"Post ID"];
//[postDictionary setValue:@"title #2" forKey:@"Post Title"];
//[postDictionary setValue:@"fl\0ow" forKey:@"Post Owner"];
//
//NSURL *multiPostUrl = [NSURL URLWithString:URL_IMAGES];
//UIImage* postImage = [UIImage imageNamed:@"placeHolder.JPG"];
//
//[[RHProtocolSender getInstance] postToURL:multiPostUrl WithJSON:postDictionary WithImage:postImage Name:@"ImgNAME44" FileName:@"placeHolder.JPG" Success:^(AFHTTPRequestOperation * operation, id object) {
//    [RHUtilities popUpErrorMessage:@"SUCCESS POST" WithParentViewController:self];
//} Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//    [RHUtilities handleError:error WithParentViewController:self];
//} UploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite)
// {
//     
// }];


//static RHProtocolSender* s_ProtocolSender;