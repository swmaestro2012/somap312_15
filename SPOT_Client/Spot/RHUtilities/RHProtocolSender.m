//
//  RHProtocolSender.m
//  TestPageNetwork
//
//  Created by Sinhyub Kim on 10/11/12.
//  Copyright (c) 2012 Sinhyub Kim. All rights reserved.
//

static RHProtocolSender* s_ProtocolSender = nil;

@implementation RHProtocolSender

@synthesize JSONWriter;
@synthesize serverKey;
@synthesize userID;


+ (id)allocWithZone:(NSZone *)zone
{
    return [self getInstance];
    //    return [[self getInstance] retain];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

+ (RHProtocolSender*) getInstance
{
    if ( s_ProtocolSender == nil )
    {
        s_ProtocolSender = [[super allocWithZone:NULL] init];
        [s_ProtocolSender initializeRoughHands];
    }
    return s_ProtocolSender;
}

- (void) setServerKey:(NSString *)serverKey_
{
    serverKey = serverKey_;
}

- (NSString*) getServerKey
{
    if( serverKey == nil )
    {
        serverKey = [RHUtilities getServerKey];
    }
    return serverKey;
//    return [RHUtilities getServerKey];
}

- (void) setUserID:(NSString *)userID_
{
    userID = userID_;
}

- (NSString*) getUserID
{
    if( userID == nil )
    {
        id value = [RHUtilities getUserID];
        if( [value isMemberOfClass:[NSString class]] == NO )
            value = USERID_NONE;
        userID = value;
    }
    return userID;
    //    return [RHUtilities getServerKey];
}



- (void) initializeRoughHands
{
    self.JSONWriter = [[SBJsonWriter alloc] init];
    self.JSONWriter.humanReadable = FALSE;    
}

- (void) isSessionValidWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject)) success
                          Failure:(void (^)(AFHTTPRequestOperation *operation, NSError* error)) failure
{
    NSURL* checkSessionURL = [NSURL URLWithString:URL_CHECKSESSION];
    [self postToURL:checkSessionURL WithJSON:nil Success:success Failure:failure TimeOut:3.0];
}

- (void)signInWithUserID:(NSString*)userID_ Password:(NSString*)password_
           WithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject)) success
               Failure:(void (^)(AFHTTPRequestOperation *operation, NSError* error)) failure
               TimeOut:(float)timeOut

{
    NSMutableDictionary* signInData = [[NSMutableDictionary alloc]init];
    [signInData setValue:userID_ forKey:@"user_id"];
    [signInData setValue:password_ forKey:@"user_password"];
    
    RHProtocolSender* protocolSender = [RHProtocolSender getInstance];
    [protocolSender postToURL:[NSURL URLWithString:URL_SIGNIN]
                     WithJSON:signInData
                      Success:success
                      Failure:failure TimeOut:timeOut];    
}


- (void)signOutSessionWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject)) success
                           Failure:(void (^)(AFHTTPRequestOperation *operation, NSError* error)) failure
{
    NSURL* signOutURL = [NSURL URLWithString:URL_SIGNOUT];
    [self postToURL:signOutURL WithJSON:nil Success:success Failure:failure TimeOut:3.0];
    [RHUtilities setServerKey:SERVERKEY_NONE];
}



- (void) postToURL:(NSURL*)targetURL
          WithJSON:(NSMutableDictionary*)dataDictionary
           Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject)) success
           Failure:(void (^)(AFHTTPRequestOperation *operation, NSError* error)) failure
           TimeOut:(NSTimeInterval) timeout
{
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:targetURL
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval: timeout];
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setValue:@"application/JSON" forHTTPHeaderField:@"contentType"];
    [postRequest setValue:[RHUtilities getUUID] forHTTPHeaderField:@"device_id"];
    [postRequest setValue:[self getServerKey] forHTTPHeaderField:@"server_key"];
    [postRequest setValue:[self getUserID] forHTTPHeaderField:@"user_id"];
    
    NSLog(@"device_id:%@", [RHUtilities getUUID]);
    NSLog(@"server_key:%@", [self getServerKey]);
    
    NSString* jsonString = nil;
    if (dataDictionary == nil)
    {
        jsonString = @"{}";
    }
    else
    {
        jsonString = [self.JSONWriter stringWithObject:dataDictionary];
    }
    [postRequest setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFJSONRequestOperation* postOperation = [[AFJSONRequestOperation alloc] initWithRequest:postRequest];
    [postOperation setCompletionBlockWithSuccess:success failure:failure];
    
    [postOperation start];
}

- (void)       postToURL:(NSURL*)targetURL
                WithJSON:(NSMutableDictionary *)dataDictionary
               WithImage:(UIImage*)postImage Name:(NSString*)name FileName:(NSString*) fileName
                 Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                 Failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
     UploadProgressBlock:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))  uploadProgressBlock
    //TO DO :: implement Timeout
    //       TimeOut:(NSTimeInterval)timeout
{
    assert(postImage != nil);
    
    // TO DO : Make HTTPClient as a Member variable and reuse it.
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:targetURL];

    NSData *imageData = UIImageJPEGRepresentation(postImage, 1);
    NSMutableURLRequest *multiDataRequest = [httpClient multipartFormRequestWithMethod:@"POST" path:@"" parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        
        NSMutableDictionary* headerData = [[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                    @"application/JSON",@"contentType",
                                    @"form-data; name=\"data\"", @"Content-Disposition",
                                           nil];
        
        NSString* jsonString = nil;
        if (dataDictionary == nil)
        {
            jsonString = @"{}";
        }
        else
        {
            jsonString = [self.JSONWriter stringWithObject:dataDictionary];
        }
        
        [formData appendPartWithHeaders:headerData body:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
        [formData appendPartWithFileData:imageData name:name fileName:fileName mimeType:@"image/jpeg"];
    }];

    [multiDataRequest addValue:[RHUtilities getUUID] forHTTPHeaderField:@"device_id"];
    [multiDataRequest addValue:[self getServerKey] forHTTPHeaderField:@"server_key"];
    [multiDataRequest addValue:[self getUserID] forHTTPHeaderField:@"user_id"];
    
    AFHTTPRequestOperation *multiDataOperation = [[AFHTTPRequestOperation alloc] initWithRequest:multiDataRequest];

    [multiDataOperation setCompletionBlockWithSuccess:success failure:failure];
    [multiDataOperation setUploadProgressBlock:uploadProgressBlock];
    
    [multiDataOperation start];
}

- (void) getImageFromURL:(NSURL*)targetURL
           WithImageView:(UIImageView*) targetView
                WithJSON:(NSMutableDictionary *)dataDictionary
         WithPlaceholder:(UIImage*) placeholderImage
                 Success:(void (^)(NSURLRequest* request, NSHTTPURLResponse* response, UIImage* image)) success
                 Failure:(void (^)(NSURLRequest* request, NSHTTPURLResponse* response, NSError* error)) failure
                 TimeOut:(NSTimeInterval) timeout
{
    // Get JSON
    NSMutableURLRequest *getRequest = [NSMutableURLRequest requestWithURL:targetURL
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval: timeout];
    [getRequest setHTTPMethod:@"GET"];
    [getRequest setValue:@"application/JSON" forHTTPHeaderField:@"contentType"];
    [getRequest setValue:[RHUtilities getUUID] forHTTPHeaderField:@"device_id"];
    [getRequest setValue:[self getServerKey] forHTTPHeaderField:@"server_key"];
    [getRequest setValue:[self getUserID] forHTTPHeaderField:@"user_id"];
    
    NSString* jsonString = nil;
    if (dataDictionary == nil)
    {
        jsonString = @"{}";
    }
    jsonString = [self.JSONWriter stringWithObject:dataDictionary];
    [getRequest setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [targetView setImageWithURLRequest:getRequest placeholderImage:placeholderImage success:success failure:failure];
}

- (void) getImageFromURL:(NSURL*)targetURL
                WithJSON:(NSMutableDictionary *)dataDictionary
                 Success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)) success
                 Failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)) failure
                 TimeOut:(NSTimeInterval) timeout
{
//    NSURLRequest* imageURLRequest = [[NSURLRequest alloc] initWithURL:targetURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeout];
//
//    AFImageRequestOperation* imageRequestOperation = [[AFImageRequestOperation alloc] initWithRequest:imageURLRequest];
//    [imageRequestOperation setCompletionBlockWithSuccess:success failure:failure];
//    [imageRequestOperation start];
    
    NSMutableURLRequest *imageRequest = [NSMutableURLRequest requestWithURL:targetURL
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval: timeout];
    [imageRequest setHTTPMethod:@"GET"];
    [imageRequest setValue:@"application/JSON" forHTTPHeaderField:@"contentType"];
    [imageRequest setValue:[RHUtilities getUUID] forHTTPHeaderField:@"device_id"];
    [imageRequest setValue:[self getServerKey] forHTTPHeaderField:@"server_key"];
    [imageRequest setValue:[self getUserID] forHTTPHeaderField:@"user_id"];
    
    NSString* jsonString = nil;
    if (dataDictionary == nil)
    {
        jsonString = @"{}";
    }
    jsonString = [self.JSONWriter stringWithObject:dataDictionary];
    [imageRequest setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFImageRequestOperation* imageOperation = [AFImageRequestOperation imageRequestOperationWithRequest:imageRequest imageProcessingBlock:^UIImage *(UIImage *image) {
        return image;
    } success:success failure:failure];
    
    [imageOperation start];    
}



//    NSURL *url = [NSURL URLWithString:@"http://192.168.1.189/image"];
- (void) getJSONFromURL:(NSURL*)targetURL
                Success:(void (^)(NSURLRequest* request, NSHTTPURLResponse* response, id JSON)) success
                Failure:(void (^)(NSURLRequest* request, NSHTTPURLResponse* response, NSError* error, id JSON)) failure
                TimeOut:(NSTimeInterval) timeout
{
    // Get JSON
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:timeout];

    AFJSONRequestOperation* operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:success failure:failure];

    [operation start];
}

- (void) getJSONFromURL:(NSURL*)targetURL
               WithJSON:(NSMutableDictionary *)dataDictionary
                Success:(void (^)(NSURLRequest* request, NSHTTPURLResponse* response, id JSON)) success
                Failure:(void (^)(NSURLRequest* request, NSHTTPURLResponse* response, NSError* error, id JSON)) failure
                TimeOut:(NSTimeInterval) timeout
{
    // Get JSON
    NSMutableURLRequest *getRequest = [NSMutableURLRequest requestWithURL:targetURL
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval: timeout];
    [getRequest setHTTPMethod:@"GET"];
    [getRequest setValue:@"application/JSON" forHTTPHeaderField:@"contentType"];
    [getRequest setValue:[RHUtilities getUUID] forHTTPHeaderField:@"device_id"];
    [getRequest setValue:[self getServerKey] forHTTPHeaderField:@"server_key"];
    [getRequest setValue:[self getUserID] forHTTPHeaderField:@"user_id"];
    
    NSString* jsonString = nil;
    if (dataDictionary == nil)
    {
        jsonString = @"{}";
    }
    else
        jsonString = [self.JSONWriter stringWithObject:dataDictionary];
    [getRequest setValue:jsonString forHTTPHeaderField:@"JSON_data"];
//    [getRequest setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFJSONRequestOperation* getOperation = [AFJSONRequestOperation JSONRequestOperationWithRequest:getRequest success:success failure:failure];
    
    [getOperation start];
}


- (void) getFromURL:(NSURL*)url onSuccess:(void (^)(id JSON))action
{
    
    [self getFromURL:url onSuccess:action onFailure:^(NSError *error) {}];
}

- (void) getFromURL:(NSURL*)url onSuccess:(void (^)(id JSON))action onFailure:(void(^)(NSError* error))failAction
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData
                                         timeoutInterval:0.5];
    
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/JSON" forHTTPHeaderField:@"contentType"];
    [request setValue:[RHUtilities getUUID] forHTTPHeaderField:@"device_id"];
    [request setValue:[self getServerKey] forHTTPHeaderField:@"server_key"];
    [request setValue:[self getUserID] forHTTPHeaderField:@"user_id"];
    
    AFJSONRequestOperation* operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest* request, NSHTTPURLResponse* response, id JSON)
                                         {
                                             action(JSON);
                                             
                                         }
                                                                                        failure:^(NSURLRequest* request, NSHTTPURLResponse* response, NSError* error, id JSON)
                                         {
                                             failAction(error);
                                         }
                                         ];
    [operation start];
}



@end


//    // Post Image
//    NSURL* postURL = [NSURL URLWithString:@"http://192.168.1.189/image/post_image"];
//
//    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:postURL
//                                                 cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:3.0];
//    [postRequest setHTTPMethod:@"POST"];
//    UIImage* postImage = [UIImage imageNamed:@"uploadImage.JPG"];
//
//    if (postImage != nil)
//    {
//        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50.0f, 150.0f, 200, 200)];
//        [imageView setImage: postImage];
//        [self.view addSubview: imageView];
//
//
//        [postRequest setHTTPBody:[NSJSONSerialization JSONObjectWithData:UIImageJPEGRepresentation(postImage, 1.0) options:NSJSONReadingMutableContainers error:nil]];
//        [postRequest setHTTPBody:[@"TestPosting" dataUsingEncoding:NSUTF8StringEncoding]];
//        AFHTTPRequestOperation* postOperation = [[AFHTTPRequestOperation alloc] initWithRequest:postRequest];
//        [postOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
//         {
//
//         }
//                                             failure:^(AFHTTPRequestOperation *operation, NSError *error)
//         {
//
//         }];
//
//        [postOperation start];
//    }






///////////////////////////////
// SAVE HARD CODEs



//
//
//                //    // Additional Label add as childview
//                //    NSURL *url = [NSURL URLWithString:@"http://api.twitter.com/statuses/public_timeline.json?count=3"];
//                //    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//                //    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
//                //    {
//                //        id nameList = [[JSON valueForKey:@"user"] valueForKey:@"name"];
//                //        NSString* nameString = [[NSString alloc] initWithFormat:@"name : %@", nameList[0]];
//                //
//                //        self.messageLabel.text = nameString;
//                //
//                //    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
//                //
//                //        NSString* errorString = [[NSString alloc] initWithFormat:@"error : %@", [[JSON valueForKey:@"errors"] valueForKey:@"message"][0]];
//                //        self.messageLabel.text = errorString;
//                //    }];
//                //
//                //    [operation start];
//
//
//                // GET Image
//
//                UIImage* placeHolderImage = [UIImage imageNamed:@"uploadImage.JPG"];
//                UIImageView* downloadImageView = [[UIImageView alloc] initWithFrame:CGRectMake(50.0f, 150.0f, 200,200)];
//
//                //:[NSURL URLWithString:@"http://192.168.2.189/media/iu.jpg"] placeholderImage:placeHolderImage]];
//
//
//                NSURL* imageURL = [NSURL URLWithString:@"http://192.168.1.189/image/get_image/?image_id=5"];
//                NSURLRequest* imageURLRequest = [[NSURLRequest alloc] initWithURL:imageURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];
//
//                [downloadImageView setImageWithURLRequest:imageURLRequest placeholderImage:placeHolderImage success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
//                    self.messageLabel.text = @"SUCCESS LOADING";
//                } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
//                    NSLog(@"%@", error);
//                    NSString* errorString = [[NSString alloc] initWithFormat:@"%@", error];
//                    self.messageLabel.text = errorString;
//                }];
//
//                [self.view addSubview:downloadImageView];
//
//
//
//
//                //    // POST PROTOCOL WITH IMAGE
//                //    NSMutableDictionary* postDictionary = [[NSMutableDictionary alloc] init];
//                //    [postDictionary setValue:@"99" forKey:@"Post ID"];
//                //    [postDictionary setValue:@"title #2" forKey:@"Post Title"];
//                //    [postDictionary setValue:@"fl\0ow" forKey:@"Post Owner"];
//                //
//                //    NSURL *multiPostUrl = [NSURL URLWithString:@"http://192.168.1.189/image/post_image/"];
//                //    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:multiPostUrl];
//                //    UIImage* postImage = [UIImage imageNamed:@"uploadImage.JPG"];
//                //
//                //    if (postImage != nil)
//                //    {
//                //        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50.0f, 150.0f, 200, 200)];
//                //        [imageView setImage: postImage];
//                //        [self.view addSubview: imageView];
//                //
//                //        NSData *imageData = UIImageJPEGRepresentation(postImage, 1);
//                //        NSMutableURLRequest *multiPostRequest = [httpClient multipartFormRequestWithMethod:@"POST" path:@"" parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
//                //            [formData appendPartWithFileData:imageData name:@"FlowPost" fileName:@"uploadImage.jpg" mimeType:@"image/jpeg"];
//                //    //        [formData appendPartWithFileData:imageData name:@"FlowPost1" fileName:@"uploadImage.jpg" mimeType:@"image/jpeg"];
//                //    //        [formData appendPartWithFileData:imageData name:@"FlowPost2" fileName:@"uploadImage.jpg" mimeType:@"image/jpeg"];
//                //            [formData appendPartWithFormData:[[postDictionary description] dataUsingEncoding:NSUTF8StringEncoding] name:@"data"];
//                //        }];
//                //
//                //
//                //        AFHTTPRequestOperation *multiPostOperation = [[AFHTTPRequestOperation alloc] initWithRequest:multiPostRequest];
//                //
//                //        [multiPostOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
//                //         {
//                //             self.messageLabel.text = @"SUCCESS POSTING";
//                //         }
//                //                                             failure:^(AFHTTPRequestOperation *operation, NSError *error)
//                //         {
//                //             NSLog(@"%@", error);
//                //             NSString* errorString = [[NSString alloc] initWithFormat:@"%@", error];
//                //             self.messageLabel.text = errorString;
//                //         }];
//                //
//                //        [multiPostOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
//                //            NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
//                //        }] ;
//                //
//                //        [multiPostOperation start];
//                //
//                //    }
//                //
//
//
//
//
//                //
//                //    // Post JSON
//                //    NSURL* postURL = [NSURL URLWithString:@"http://192.168.1.189/image/post_image/"];
//                //
//                //    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:postURL
//                //                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:3.0];
//                //    [postRequest setHTTPMethod:@"POST"];
//                //    [postRequest setValue:@"application/json" forHTTPHeaderField:@"contentType"];
//                //    [postRequest a]
//                //
//                ////    NSData* jsonPost = [NSJSONSerialization
//                //    NSMutableDictionary* postDictionary = [[NSMutableDictionary alloc] init];
//                //    [postDictionary setValue:@"99" forKey:@"Post ID"];
//                //    [postDictionary setValue:@"title #2" forKey:@"Post Title"];
//                //    [postDictionary setValue:@"fl\0ow" forKey:@"Post Owner"];
//                ////
//                ////    NSData* jsonPost = [NSJSONSerialization dataWithJSONObject:postDictionary options:NSJSONWritingPrettyPrinted error:nil];
//                //
//                //    [postRequest setHTTPBody:[[postDictionary description] dataUsingEncoding:NSUTF8StringEncoding]];
//                //
//                //    AFHTTPRequestOperation* postOperation = [[AFHTTPRequestOperation alloc] initWithRequest:postRequest];
//                //    [postOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
//                //     {
//                //         self.messageLabel.text = @"SUCCESS POSTING";
//                //     }
//                //                                         failure:^(AFHTTPRequestOperation *operation, NSError *error)
//                //     {
//                //         NSLog(@"%@", error);
//                //         NSString* errorString = [[NSString alloc] initWithFormat:@"%@", error];
//                //         self.messageLabel.text = errorString;
//                //     }];
//                //
//                //    [postOperation start];
//                //
//                //
//                //
//                //
//                //
//
//                //    // Post Image
//                //    NSURL* postURL = [NSURL URLWithString:@"http://192.168.1.189/image/post_image"];
//                //
//                //    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:postURL
//                //                                                 cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:3.0];
//                //    [postRequest setHTTPMethod:@"POST"];
//                //    UIImage* postImage = [UIImage imageNamed:@"uploadImage.JPG"];
//                //
//                //    if (postImage != nil)
//                //    {
//                //        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50.0f, 150.0f, 200, 200)];
//                //        [imageView setImage: postImage];
//                //        [self.view addSubview: imageView];
//                //
//                //
//                //        [postRequest setHTTPBody:[NSJSONSerialization JSONObjectWithData:UIImageJPEGRepresentation(postImage, 1.0) options:NSJSONReadingMutableContainers error:nil]];
//                //        [postRequest setHTTPBody:[@"TestPosting" dataUsingEncoding:NSUTF8StringEncoding]];
//                //        AFHTTPRequestOperation* postOperation = [[AFHTTPRequestOperation alloc] initWithRequest:postRequest];
//                //        [postOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
//                //         {
//                //
//                //         }
//                //                                             failure:^(AFHTTPRequestOperation *operation, NSError *error)
//                //         {
//                //
//                //         }];
//                //
//                //        [postOperation start];
//                //    }
//
//
//                //    // Get JSON
//                //    NSURL *url = [NSURL URLWithString:@"http://192.168.1.189/image"];
//                //    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//                //
//                ////    AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//                ////    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//                ////        NSString* responseString = [[NSString alloc] initWithFormat:@"%@", operation.responseString];
//                //////        NSJSONSerialization
//                ////        self.messageLabel.text = responseString;
//                ////
//                ////    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                ////         NSString* errorString = [[NSString alloc] initWithFormat:@"%@", error];
//                ////         self.messageLabel.text = errorString;
//                ////    }];
//                //
//                //    AFJSONRequestOperation* operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
//                //    {
//                //         self.messageLabel.text = [[NSString alloc] initWithFormat:@"%@ %@ %@", [JSON valueForKey:@"success"], [JSON valueForKey:@"a"], [JSON valueForKey:@"data"]];
//                //
//                //
//                //    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
//                //
//                //         NSString* errorString = [[NSString alloc] initWithFormat:@"%@", error];
//                //         self.messageLabel.text = errorString;
//                //     }];
//                //
//                //    [operation start];
//
//

