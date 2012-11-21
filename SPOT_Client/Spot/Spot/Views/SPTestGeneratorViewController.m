//
//  SPTestGeneratorViewController.m
//  Spot
//
//  Created by Sinhyub Kim on 11/15/12.
//  Copyright (c) 2012 Sinhyub Kim. All rights reserved.
//


@interface SPTestGeneratorViewController ()

@end

@implementation SPTestGeneratorViewController
@synthesize buttonLoadingImages;
@synthesize buttonPostSnapsToSpot;
@synthesize labelLoadingImages;
@synthesize hiphopperImageArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(45.0f, 0.0f, 70.0f, 30.0f)];
        [titleLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
        [titleLabel setText:@"Test Generator"];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [self.navigationItem setTitleView:titleLabel];
        
        UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [menuButton addTarget:[SPMenuTableViewController getInstance] action:@selector(onNavigationMenuBarButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
        [menuButton setBackgroundImage:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_MENU_CLOSED] forState:UIControlStateNormal];
        UIBarButtonItem *menuBarButton = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
        [self.navigationItem setLeftBarButtonItem:menuBarButton];
        

        if( hiphopperImageArray == nil )
        {
            hiphopperImageArray = [[NSMutableArray alloc] initWithCapacity:160];
        }
        
        {
            self.buttonLoadingImages = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [self.buttonLoadingImages setFrame:CGRectMake(70.0, 150.0, 200.0, 30.0)];
            [self.buttonLoadingImages setTitle:@"Load HiphopperImages" forState:UIControlStateNormal];
            [self.buttonLoadingImages addTarget:self action:@selector(onButtonLoadingImagesPushedUp:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview: self.buttonLoadingImages];
        }

        {
            self.buttonPostSnapsToSpot = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [self.buttonPostSnapsToSpot setFrame:CGRectMake(70.0, 190.0, 200.0, 30.0)];
            [self.buttonPostSnapsToSpot setTitle:@"Post Snaps To SPOT!" forState:UIControlStateNormal];
            [self.buttonPostSnapsToSpot addTarget:self action:@selector(onButtonPostSnapsToSpotPushedUp:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview: self.buttonPostSnapsToSpot];
        }
        
        {
            self.labelLoadingImages = [[UILabel alloc] initWithFrame:CGRectMake(30.0f, 50.0, 250.0, 30.0)];
            [self.labelLoadingImages setText:@"0 Images loaded"];
            [self.labelLoadingImages setBackgroundColor:[UIColor whiteColor]];
            [self.view addSubview:self.labelLoadingImages];
        }

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
        
//    UIImageView* imageGet = [[UIImageView alloc] initWithImage:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_PLACEHHOLDER]];
//    [imageGet setFrame:CGRectMake(30,30, 120,160)];
//    [imageGet setContentMode:UIViewContentModeScaleAspectFit];
//    [self.view addSubview: imageGet];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#define HIPHOPER_IMAGEURL_FORMAT @"http://img.hiphoper.com/images/magazine/look_street/%d/%d_st_%02d.jpg"
- (void)getImageFromHiphopperYear:(NSInteger)year YearDate:(NSInteger)yearDate ImageNumber:(NSInteger)imageNumber
                          Success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)) success
                          Failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)) failure
{
//    NSString* hiphoperImage = @"http://img.hiphoper.com/images/magazine/look_street/2012/20121107_st_07.jpg";
//   NSString* hiphoperImageURLFormat = @"http://img.hiphoper.com/images/magazine/look_street/%d/%d_st_0%d.jpg";
    NSString* hiphoperImageURL = [[NSString alloc] initWithFormat:HIPHOPER_IMAGEURL_FORMAT,year,yearDate,imageNumber];
    
    NSLog(@"%@", hiphoperImageURL);

    
    NSURLRequest* imageRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:hiphoperImageURL]];
    AFImageRequestOperation* imageOperation = [AFImageRequestOperation imageRequestOperationWithRequest:imageRequest imageProcessingBlock:^UIImage *(UIImage *image) {
        return image;
    } success:success failure:failure];
    
    [imageOperation start];
}

- (void)signInSPOTWithUserID:(NSString*)userID Password:(NSString*)userPassword
                 WithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject)) success
                     Failure:(void (^)(AFHTTPRequestOperation *operation, NSError* error)) failure
{
    [[RHProtocolSender getInstance] signInWithUserID:userID Password:userPassword WithSuccess:success Failure:failure TimeOut:15.0f];
}

- (void)postSnapWithPostImage:(UIImage*)postImage SpotID:(NSInteger)spotID ModelID:(NSInteger)modelID Description:(NSString*)description Latitude:(float)lat Longitude:(float)lng Altitude:(float)alt
                      Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      Failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure

{
    NSString* spotIDString = [[NSString alloc]initWithFormat:@"%d", spotID];
    NSString* latitudeStr = [[NSString alloc] initWithFormat:@"%f",lat];
    NSString* altitudeStr = [[NSString alloc] initWithFormat:@"%f",alt];
    NSString* longitudeStr = [[NSString alloc] initWithFormat:@"%f",alt];
    
    NSMutableDictionary* postData = [[NSMutableDictionary alloc] initWithObjectsAndKeys:spotIDString,@"spot_id", [NSNumber numberWithInteger:modelID],@"model_id", description,@"description",
                                     latitudeStr,@"latitude",longitudeStr,@"longitude",altitudeStr,@"altitude",  nil];
    [[RHProtocolSender getInstance] postToURL:[NSURL URLWithString:URL_SNAPS]
                                     WithJSON:postData WithImage:postImage Name:@"postImage" FileName:@"postImage.jpg"
                                      Success:success Failure:failure
                          UploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite)
     {
         NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
     }
     ];

}

- (void)onButtonLoadingImagesPushedUp:(id)sender
{
    // 1. Get Images From Hiphoper
    NSArray* yeardateArray = [[NSArray alloc] initWithObjects:
                              [NSNumber numberWithInt:20120905],
//                              [NSNumber numberWithInt:20121031],
  //                            [NSNumber numberWithInt:20121114],
//                              [NSNumber numberWithInt:20121107],
//                              [NSNumber numberWithInt:20121024],
//                              [NSNumber numberWithInt:20121017],
//                              [NSNumber numberWithInt:20121010],
    //                          [NSNumber numberWithInt:20120926],
  //                            [NSNumber numberWithInt:20120919],
                              [NSNumber numberWithInt:20120912], nil];

    for(NSNumber* yearDataNumber in yeardateArray)
    {
        for( int i=0; i<30; ++i )
        {
            [self getImageFromHiphopperYear:2012 YearDate:[yearDataNumber integerValue] ImageNumber:i Success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                [self.hiphopperImageArray addObject:image];
                NSLog(@"Image Load from Hiphopper Completed. Count:%d",self.hiphopperImageArray.count);
                NSString* countString = [[NSString alloc] initWithFormat:@"%d number of Images Loaded",self.hiphopperImageArray.count];
                [self.labelLoadingImages setText:countString];
            } Failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                
            }];
        }
    }

}

- (void)onButtonPostSnapsToSpotPushedUp:(id)sender
{
    // 2. Sign In
    static NSInteger POSTING_SPOT = 10;
    [self autoPostingSnap:0 limitNumber:self.hiphopperImageArray.count postingSpot:POSTING_SPOT++];

}


- (void)autoPostingSnap:(NSInteger)autoID limitNumber:(NSInteger)limitNumber postingSpot:(NSInteger)POSTING_SPOT
{
    if( autoID >= limitNumber)
    {
        return;
    }
    
    NSString* userID = [[NSString alloc] initWithFormat:@"roughhands%d",autoID%100+1];
    NSString* userPassword = @"rough";
    [self signInSPOTWithUserID:userID Password:userPassword WithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        int result = [[responseObject valueForKey:@"success"] intValue];
        if( result == 0 )
        {
            // Error Handling
            [RHUtilities popUpErrorMessage:[responseObject valueForKey:@"message"] WithParentViewController:self];
            [[SPServerObject getInstance] onSignOut];
            return;
        }
        
        [[SPServerObject getInstance] onSignInWithServerKey:[responseObject valueForKey:@"server_key"] UserID:[[responseObject valueForKey:@"user_id"] stringValue]];
        
        NSLog(@"LogIn Completed");
        
        // 2. Load Profile and check joined to  the Spot
        NSString* myUserIDString = [RHUtilities getUserID];
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
            BOOL isJoinedToSpot = NO;
            SPUserProfileInfo* myUserProfileInfo = [[SPUserProfileInfo alloc] initWithJSONDictionary:myUserProfileJSONDictionary];
            for( SPSpotInfo* spotInfo in myUserProfileInfo.physicalSpotList )
            {
                if( spotInfo.spotID == POSTING_SPOT )
                {
                    isJoinedToSpot = YES;
                    break;
                }
            }
            if( isJoinedToSpot == NO )
            {
                for( SPSpotInfo* spotInfo in myUserProfileInfo.logicalSpotList )
                {
                    if( spotInfo.spotID == POSTING_SPOT )
                    {
                        isJoinedToSpot = YES;
                        break;
                    }
                }
            }
            
            if( isJoinedToSpot == NO )
            {
                // Request Join
                NSString* userSpotURL = [[NSString alloc] initWithFormat:URL_SPOT_JOIN, POSTING_SPOT];
                [[RHProtocolSender getInstance] postToURL:[NSURL URLWithString:userSpotURL] WithJSON:nil Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSMutableDictionary* JSON = responseObject;
                    int result = [[JSON valueForKey:@"success"] intValue];
                    if( result == 0 )
                    {
                        // Error Handling
                        [RHUtilities popUpErrorMessage:[JSON valueForKey:@"message"] WithParentViewController:self];
                        return;
                    }
                    
                    // 3. Post Snap
                    NSLog(@"Start to Post");
                    NSString* snapDescription = [[NSString alloc] initWithFormat:@"hello SPOT!! I'm User %d",autoID];
                    NSInteger spotID = POSTING_SPOT;
                    float lat = (float)(random()%100)/(float)100;
                    float lng = (float)(random()%100)/(float)100;
                    
                    UIImage* postImage = [self.hiphopperImageArray objectAtIndex:autoID];
                    [self postSnapWithPostImage:postImage SpotID:spotID ModelID:myUserID Description:snapDescription Latitude:lat Longitude:lng Altitude:3.0f
                                        Success:^(AFHTTPRequestOperation *operation, id responseObject)
                     {
                         NSData* theObject = (NSData*)responseObject;
                         NSString* stringJSON = [[NSString alloc] initWithData:theObject encoding:NSUTF8StringEncoding];
                         NSDictionary* JSON = (NSDictionary*)[stringJSON JSONValue];
                         
                         int result = [[JSON valueForKey:@"success"] intValue];
                         if( result == 0 )
                         {
                             // Error Handling
                             [RHUtilities popUpErrorMessage:[JSON valueForKey:@"message"] WithParentViewController:self];
                             return;
                         }
                         
                         NSLog(@"POST COMPLETED");
                         
                         // Post Next Snap
                         [self autoPostingSnap:(autoID+1) limitNumber:limitNumber postingSpot:POSTING_SPOT];
                     }
                                        Failure:^(AFHTTPRequestOperation *operation, NSError *error)
                     {
                         NSLog(@"POST FAILED : %@", error.description);
                     }];
                } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [RHUtilities handleError:error WithParentViewController:self];
                } TimeOut:10.0f];
            }
            else
            {
                // 3. Post Snap
                NSLog(@"Start to Post");
                NSString* snapDescription = [[NSString alloc] initWithFormat:@"hello SPOT!! I'm User %d",autoID];
                NSInteger spotID = POSTING_SPOT;
                float lat = (float)(random()%100)/(float)100;
                float lng = (float)(random()%100)/(float)100;
                
                UIImage* postImage = [self.hiphopperImageArray objectAtIndex:autoID];
                [self postSnapWithPostImage:postImage SpotID:spotID ModelID:myUserID Description:snapDescription Latitude:lat Longitude:lng Altitude:3.0f
                                    Success:^(AFHTTPRequestOperation *operation, id responseObject)
                 {
                     NSData* theObject = (NSData*)responseObject;
                     NSString* stringJSON = [[NSString alloc] initWithData:theObject encoding:NSUTF8StringEncoding];
                     NSDictionary* JSON = (NSDictionary*)[stringJSON JSONValue];
                     
                     int result = [[JSON valueForKey:@"success"] intValue];
                     if( result == 0 )
                     {
                         // Error Handling
                         [RHUtilities popUpErrorMessage:[JSON valueForKey:@"message"] WithParentViewController:self];
                         return;
                     }
                     
                     NSLog(@"POST COMPLETED");
                     
                     // Post Next Snap
                     [self autoPostingSnap:(autoID+1) limitNumber:limitNumber postingSpot:POSTING_SPOT];
                 }
                                    Failure:^(AFHTTPRequestOperation *operation, NSError *error)
                 {
                     NSLog(@"POST FAILED : %@", error.description);
                 }];
            }

            
            
        } Failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            NSLog(@"%@", error.description);
            [RHUtilities handleError:error WithParentViewController:nil];
        } TimeOut:10.f];

        
        } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"LogIn Failed : %@", error.description);
    }];
}



@end
