//
//  SPPostSnapViewController.m
//  Spot
//
//  Created by Sinhyub Kim on 11/5/12.
//  Copyright (c) 2012 Sinhyub Kim. All rights reserved.
//

@interface SPPostSnapViewController ()
- (void)initializeDescriptionPlaceHolder;
@end

@implementation SPPostSnapViewController

@synthesize selectedSnapView;
@synthesize selectedSnapAltitude;
@synthesize selectedSnapLatitude;
@synthesize selectedSnapLongitude;
@synthesize chooseSnapButton;
@synthesize chooseModelButton;
@synthesize postSnapButton;
@synthesize modelLabel;
@synthesize spotInfoToPost;

@synthesize descriptionTextView;
@synthesize isDescriptionTextPlaceHolder;
@synthesize isOnEditingDescriptionText;
@synthesize modelUserInfo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (id)initWithSpotInfo:(SPSpotInfo*)spotInfo_
{
    self = [super init];
    if( self )
    {
        spotInfoToPost = spotInfo_;
        // default model is myself
        modelUserInfo = [SPServerObject getInstance].myUserProfileInfo.userInfo;
        
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_BACKGROUNDTEXTURE]]];
        
        isOnEditingDescriptionText = NO;
        
        
        if( self.selectedSnapView == nil )
        {
            CGRect selectedImageFrame = CGRectMake(SELECTED_IMAGE_FRAME_X,
                                                   SELECTED_IMAGE_FRAME_Y,
                                                   SELECTED_IMAGE_FRAME_WIDTH,
                                                   SELECTED_IMAGE_FRAME_HEIGHT);
            self.selectedSnapView = [[SPSnapImageView alloc] initWithFrame:selectedImageFrame];
            [self.selectedSnapView setBackgroundColor:[UIColor grayColor]];
            [self.selectedSnapView.imageView setContentMode:UIViewContentModeScaleAspectFit];
            [self.selectedSnapView.imageView setImage:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_PLACEHHOLDER]];
            [self.view addSubview:self.selectedSnapView];
        }
        
        if( self.chooseSnapButton == nil )
        {
            CGRect choosePhotoButtonFrame = CGRectMake(CHOOSESNAP_BUTTON_FRAME_X,
                                                       CHOOSESNAP_BUTTON_FRAME_Y,
                                                       CHOOSESNAP_BUTTON_FRAME_WIDTH,
                                                       CHOOSESNAP_BUTTON_FRAME_HEIGHT);
            
            self.chooseSnapButton = [UIButton buttonWithType:UIButtonTypeCustom];
            
            [self.chooseSnapButton setBackgroundImage:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_BUTTON]  forState:UIControlStateNormal];
            [self.chooseSnapButton setBackgroundImage:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_BUTTON_PRESSED]  forState:UIControlStateHighlighted];
            
            [self.chooseSnapButton setFrame:choosePhotoButtonFrame];
            [self.chooseSnapButton setTitle:@"Choose Snap from Library" forState:UIControlStateNormal];
            [self.chooseSnapButton.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
            [self.chooseSnapButton addTarget:self action:@selector(onChooseSnapButtonPushedUp:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview: self.chooseSnapButton];
        }
        
        if( self.postSnapButton == nil )
        {
            CGRect postSnapButtonFrame = CGRectMake(POSTSNAP_BUTTON_FRAME_X,
                                                    POSTSNAP_BUTTON_FRAME_Y,
                                                    POSTSNAP_BUTTON_FRAME_WIDTH,
                                                    POSTSNAP_BUTTON_FRAME_HEIGHT);
            self.postSnapButton = [UIButton buttonWithType:UIButtonTypeCustom];
            
            [self.postSnapButton setBackgroundImage:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_BUTTON]  forState:UIControlStateNormal];
            [self.postSnapButton setBackgroundImage:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_BUTTON_PRESSED]  forState:UIControlStateHighlighted];
            
            [self.postSnapButton setFrame:postSnapButtonFrame];
            [self.postSnapButton setTitle:@"Post !" forState:UIControlStateNormal];
            [self.postSnapButton.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
            [self.postSnapButton addTarget:self action:@selector(onPostSnapButtonPushedUp:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview: self.postSnapButton];
        }
        
        if( self.chooseModelButton == nil )
        {
            CGRect chooseSpotButtonFrame = CGRectMake(CHOOSESPOT_BUTTON_FRAME_X,
                                                      CHOOSESPOT_BUTTON_FRAME_Y,
                                                      CHOOSESPOT_BUTTON_FRAME_WIDTH,
                                                      CHOOSESPOT_BUTTON_FRAME_HEIGHT);
            self.chooseModelButton = [UIButton buttonWithType:UIButtonTypeCustom];
            
            [self.chooseModelButton setBackgroundImage:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_BUTTON]  forState:UIControlStateNormal];
            [self.chooseModelButton setBackgroundImage:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_BUTTON_PRESSED]  forState:UIControlStateHighlighted];
            [self.chooseModelButton setFrame:chooseSpotButtonFrame];
            [self.chooseModelButton setTitle:@"Choose Model of This Snap" forState:UIControlStateNormal];
            [self.chooseModelButton.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
            [self.chooseModelButton addTarget:self action:@selector(onSearchPersonButtonPushedUp:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview: self.chooseModelButton];
        }
        
        if( self.modelLabel == nil)
        {
            self.modelLabel = [[UILabel alloc] initWithFrame:CGRectMake(CHOOSESNAP_MODELLABEL_FRAME_X, CHOOSESNAP_MODELLABEL_FRAME_Y,
                                                                        CHOOSESNAP_MODELLABEL_FRAME_WIDTH, CHOOSESNAP_MODELLABEL_FRAME_HEIGHT)];

            [self.modelLabel setShadowColor:[UIColor grayColor]];
            [self.modelLabel setShadowOffset:CGSizeMake(0,1)];
            [self.modelLabel setTextAlignment:NSTextAlignmentCenter];
            [self.modelLabel setText:self.modelUserInfo.nickname];
            [self.modelLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
            [self.modelLabel setTextColor:[UIColor whiteColor]];
            [self.modelLabel setBackgroundColor:[UIColor clearColor]];

            [self.view addSubview:self.modelLabel];
        }
        
        if( self.descriptionTextView == nil )
        {
            CGRect descriptionTextViewFrame = CGRectMake(DESCRIPTION_TEXTVIEW_FRAME_X,
                                                         DESCRIPTION_TEXTVIEW_FRAME_Y,
                                                         DESCRIPTION_TEXTVIEW_FRAME_WIDTH,
                                                         DESCRIPTION_TEXTVIEW_FRAME_HEIGHT);
            
            self.descriptionTextView = [[UITextView alloc] initWithFrame:descriptionTextViewFrame];
            [self.descriptionTextView setAutocorrectionType:UITextAutocorrectionTypeNo];
            [self.descriptionTextView setAutocapitalizationType:UITextAutocapitalizationTypeNone];
            [self.descriptionTextView setFont:[UIFont systemFontOfSize:15.0f]];
            [self.descriptionTextView setEditable:YES];
            [self.descriptionTextView setDelegate:self];
            [self.descriptionTextView setReturnKeyType:UIReturnKeyDefault];
            [self.descriptionTextView setText:DESCRIPTION_TEXTVIEW_PLACEHOLDER];
            [self.view addSubview:self.descriptionTextView];
        }
        
        UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(45.0f, 0.0f, 70.0f, 30.0f)];
        [titleLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
        [titleLabel setText:@"Post Snap"];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [self.navigationItem setTitleView:titleLabel];
        
        
        [self initializeDescriptionPlaceHolder];
        
        
        [self.navigationItem setLeftBarButtonItem:nil];
        [self.navigationItem setRightBarButtonItem:nil];
        
        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        [self.view addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)initializeDescriptionPlaceHolder
{
    isDescriptionTextPlaceHolder = YES;
    [self.descriptionTextView setTextColor:[UIColor grayColor]];
    [self.descriptionTextView setText:DESCRIPTION_TEXTVIEW_PLACEHOLDER];
    [self.selectedSnapView.imageView setImage:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_PLACEHHOLDER]];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    [[RHImageManager getInstance] removeImageByKey:IMAGE_KEY_PICKER_SELECTED];
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.isOnEditingDescriptionText = YES;
    if( self.isDescriptionTextPlaceHolder == YES )
    {
        self.isDescriptionTextPlaceHolder = NO;
        [self.descriptionTextView setTextColor:[UIColor blackColor]];
        self.descriptionTextView.text = @"";
    }
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView;
{
    self.isOnEditingDescriptionText = NO;
    
    return YES;
}


-(void)handleTapGesture:(UIPanGestureRecognizer*) sender
{
    CGPoint tapPoint = [sender locationInView:self.view];
    
    if( self.isOnEditingDescriptionText == YES )
    {
        CGRect descriptionArea = self.descriptionTextView.frame;
        if( CGRectContainsPoint(descriptionArea, tapPoint) == NO )
        {
            [self.descriptionTextView endEditing:YES];
        }
    }
    
    if( CGRectContainsPoint(self.selectedSnapView.frame, tapPoint) == YES )
    {
        [self pickAnImageFromAssetLibrary];
    }
}

-(void)pickAnImageFromAssetLibrary
{
    UIImagePickerController *picker;
    picker = [[UIImagePickerController alloc] init];
    [picker setDelegate:self];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:true completion:^{
        
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker
{
    [picker  dismissViewControllerAnimated:NO completion:^{
        
    }];
    
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    // Get Metadata from selected Image
    NSURL *referenceURL = [info objectForKey:UIImagePickerControllerReferenceURL];
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library assetForURL:referenceURL resultBlock:^(ALAsset *asset) {
        ALAssetRepresentation *rep = [asset defaultRepresentation];
        NSDictionary* metadata = rep.metadata;
        NSDictionary* GPSData = [metadata valueForKey:@"{GPS}"];
        
        // Get GPS Lat / Long from the metadata
        id value = nil;
        self.selectedSnapLatitude = 0.f;
        self.selectedSnapLongitude = 0.f;
        self.selectedSnapAltitude = 0.f;
        
        value = [GPSData valueForKey:@"Altitude"];
        if( [value isMemberOfClass:[NSNull class]] == NO )
            self.selectedSnapAltitude = [value floatValue];
        value = [GPSData valueForKey:@"Latitude"];
        if( [value isMemberOfClass:[NSNull class]] == NO )
            self.selectedSnapLatitude = [value floatValue];
        value = [GPSData valueForKey:@"Longitude"];
        if( [value isMemberOfClass:[NSNull class]] == NO )
            self.selectedSnapLongitude = [value floatValue];
        
        
        ///////////TESTTESTTEST///////////
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        if( image.imageOrientation == UIImageOrientationUp && image.size.width > image.size.height )
        {
            [RHUtilities popUpErrorMessage:ERROR_NO_PORTRAIT_ORIENTATION_SNAP_TO_POST WithParentViewController:self];
            return;
        }

        
        UIGraphicsBeginImageContext( CGSizeMake(900,1200) );// a CGSize that has the size you want
        [image drawInRect:CGRectMake(0,0, 900,1200)];
        //    [originalImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
        //image is the original UIImage
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        [[RHImageManager getInstance] pushImage:image ForKey:IMAGE_KEY_PICKER_SELECTED];

        ////////////////TESTEND////

        
            //ORIGINAL
//        // Close ImagePickerView and set image data to ImageManager
//        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
//        [[RHImageManager getInstance] pushImage:image ForKey:IMAGE_KEY_PICKER_SELECTED];
        
        
        
        [picker dismissViewControllerAnimated:YES completion:^{
            UIImage* pickedImage = [[RHImageManager getInstance] getImageByKey:IMAGE_KEY_PICKER_SELECTED];
            [self.selectedSnapView.imageView setImage:pickedImage];
            
        }];
        
    } failureBlock:^(NSError *error) {
        NSLog(@"%@", error.description);
//        [RHUtilities handleError:error WithParentViewController:self];
    }];
}


-(void) onChooseSnapButtonPushedUp:(UIButton*) sender
{
    [[RHImageManager getInstance] removeImageByKey:IMAGE_KEY_PICKER_SELECTED];
    if( sender != self.chooseSnapButton )
    {
        return;
    }
    
    [self pickAnImageFromAssetLibrary];
}

- (void)onSearchPersonButtonPushedUp:(UIButton*) sender
{
    SPSearchPersonViewController* searchPersonViewController = [[SPSearchPersonViewController alloc] initWithPostSnapViewController:self];
    [self.navigationController pushViewController:searchPersonViewController animated:YES];
}

-(void) onPostSnapButtonPushedUp:(UIButton*) sender
{
    if( sender != self.postSnapButton )
    {
        return;
    }
    
    if( self.isDescriptionTextPlaceHolder == YES )
    {
        [RHUtilities popUpErrorMessage:ERROR_NO_DESCRIPTION_TO_POST WithParentViewController:self];
        return;
    }
    
    NSAssert(self.spotInfoToPost != nil, @"SPOT INFO IS NULL. WHY?");
    NSString* spotID = [[NSString alloc]initWithFormat:@"%d", self.spotInfoToPost.spotID];
    NSString* description = self.descriptionTextView.text;
    UIImage* originalImage = [[RHImageManager getInstance] getImageByKey:IMAGE_KEY_PICKER_SELECTED];
    
    if( originalImage == nil)
    {
        [RHUtilities popUpErrorMessage:ERROR_NO_SNAP_TO_POST WithParentViewController:self];
        return;
    }
    
    UIImage* postImage = originalImage;
    
//    UIGraphicsBeginImageContext( CGSizeMake(960,860) );// a CGSize that has the size you want
//    [originalImage drawInRect:CGRectMake(0,0, 960,860)];
////    [originalImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
//    //image is the original UIImage
//    UIImage* postImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    
    
    [self.postSnapButton setEnabled:NO];
    
    NSString* latitudeStr = [[NSString alloc] initWithFormat:@"%f",self.selectedSnapLatitude];
    NSString* altitudeStr = [[NSString alloc] initWithFormat:@"%f",self.selectedSnapAltitude];
    NSString* longitudeStr = [[NSString alloc] initWithFormat:@"%f",self.selectedSnapLongitude];
    
    NSMutableDictionary* postData = [[NSMutableDictionary alloc] initWithObjectsAndKeys:spotID,@"spot_id",description,@"description",latitudeStr,@"latitude",longitudeStr,@"longitude",altitudeStr,@"altitude", [NSNumber numberWithInteger:self.modelUserInfo.userID], @"model_id", nil];
    [[RHProtocolSender getInstance] postToURL:[NSURL URLWithString:URL_SNAPS]
                                     WithJSON:postData WithImage:postImage Name:@"postImage" FileName:@"postImage.jpg"
                                      Success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [self.postSnapButton setEnabled:YES];
         
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
         
         [RHUtilities popUpErrorMessage:@"POST COMPLETED" WithParentViewController:self];
         
         [self initializeDescriptionPlaceHolder];
         
         [[RHImageManager getInstance] removeImageByKey:IMAGE_KEY_PICKER_SELECTED];
         [self.selectedSnapView.imageView setImage:nil];
         self.selectedSnapAltitude = 0.f;
         self.selectedSnapLatitude = 0.f;
         self.selectedSnapLongitude = 0.f;
         
         [self.navigationController popViewControllerAnimated:YES];
     }
                                      Failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [self.postSnapButton setEnabled:YES];
         [RHUtilities handleError:error WithParentViewController:self];
     }
                          UploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite)
     {
         NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
     }
     ];
    
}

- (void)setModelUserInfo:(SPUserInfo*)modelUserInfo_
{
    modelUserInfo = modelUserInfo_;
    [self.modelLabel setText:self.modelUserInfo.nickname];
}

@end
