//
//  SPTestGeneratorViewController.h
//  Spot
//
//  Created by Sinhyub Kim on 11/15/12.
//  Copyright (c) 2012 Sinhyub Kim. All rights reserved.
//

//#define POSTING_SPOT 3

@interface SPTestGeneratorViewController : UIViewController
@property (strong, nonatomic)   UIButton* buttonLoadingImages;
@property (strong, nonatomic)   UIButton* buttonPostSnapsToSpot;
@property (strong, nonatomic)   UILabel* labelLoadingImages;
@property (strong, nonatomic)   NSMutableArray* hiphopperImageArray;


- (void)getImageFromHiphopperYear:(NSInteger)year YearDate:(NSInteger)yearDate ImageNumber:(NSInteger)imageNumber
                          Success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)) success
                          Failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)) failure;


- (void)signInSPOTWithUserID:(NSString*)userID Password:(NSString*)userPassword
                 WithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject)) success
                     Failure:(void (^)(AFHTTPRequestOperation *operation, NSError* error)) failure;

- (void)postSnapWithPostImage:(UIImage*)postImage SpotID:(NSInteger)spotID ModelID:(NSInteger)modelID Description:(NSString*)description Latitude:(float)lat Longitude:(float)lng Altitude:(float)alt
                      Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      Failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)onButtonLoadingImagesPushedUp:(id)sender;
- (void)onButtonPostSnapsToSpotPushedUp:(id)sender;
@end
