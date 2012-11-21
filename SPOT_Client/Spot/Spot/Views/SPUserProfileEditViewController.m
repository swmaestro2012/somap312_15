//
//  SPUserProfileEditViewController.m
//  Spot
//
//  Created by redd0g on 12. 11. 13..
//  Copyright (c) 2012년 Sinhyub Kim. All rights reserved.
//

@interface SPUserProfileEditViewController ()

@end

@implementation SPUserProfileEditViewController
@synthesize field, helpMessage, userProfileViewController, selectedImageView, selectedSnapLatitude, selectedSnapAltitude, selectedSnapLongitude, selectImageButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) initWithField:(NSString*)field_ WithHelpMessage:(NSString*)helpMessage_ UserProfileViewController:(SPUserProfileViewController*)userProfileViewController_
{
    self = [super self];
    if(self)
    {
        field = field_;
        helpMessage = helpMessage_;
        userProfileViewController = userProfileViewController_;
        
        [self.view setBackgroundColor:[[UIColor alloc] initWithPatternImage: [[RHImageManager getInstance]getImageByKey:IMAGE_KEY_BACKGROUNDTEXTURE] ]];
        
        UIBarButtonItem* confirmBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Confirm" style:UIBarButtonItemStylePlain target:self action:@selector(onNavigationConfirmBarButtonPushed)];
        [self.navigationItem setRightBarButtonItem:confirmBarButtonItem];
        
        
        UILabel* helpMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.f, 20, 280, 21)];
        [helpMessageLabel setText:helpMessage];
        [helpMessageLabel setTextAlignment:NSTextAlignmentCenter];
        [helpMessageLabel setTextColor:[UIColor whiteColor]];
        [helpMessageLabel setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:helpMessageLabel];
        
        
        if( [self.field compare:@"profile_snap"] == NSOrderedSame || [self.field compare:@"profile_image"] == NSOrderedSame )
        {
            selectImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [selectImageButton setFrame:CGRectMake(60.0, 50.0, 200.0, 30.0)];
            [selectImageButton setBackgroundImage:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_SIGNINBUTTON]  forState:UIControlStateNormal];
            [selectImageButton setBackgroundImage:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_SIGNINBUTTON_PRESSED]  forState:UIControlStateHighlighted];
            [selectImageButton setTitle:@"Select Image" forState:UIControlStateNormal];
            [selectImageButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
            [selectImageButton addTarget:self action:@selector(pickAnImageFromAssetLibrary) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview: selectImageButton];

        }
        else
        {
            //UITextField*
            inputMessage = [[UITextField alloc] initWithFrame:CGRectMake(20, 70, 280, 40)];
            [inputMessage setBackgroundColor:[UIColor whiteColor]];
            [inputMessage setBorderStyle:UITextBorderStyleRoundedRect];
            [inputMessage setAutocorrectionType:UITextAutocorrectionTypeNo];
            [inputMessage setClearButtonMode:UITextFieldViewModeWhileEditing];
            [self.view addSubview:inputMessage];
        }
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)onNavigationConfirmBarButtonPushed
{

    if( [self.field compare:@"profile_snap"] == NSOrderedSame )
    {
        [self postImageData];
    }
    else if( [self.field compare:@"profile_image"] == NSOrderedSame )
    {
        [self postImageData];
    }
    else
    {
        [self postStringData];
    }
    
}

- (void)postStringData
{
    //send to server with field
    NSMutableDictionary* updateData = [[NSMutableDictionary alloc] initWithObjectsAndKeys:inputMessage.text, self.field, nil];
    
    NSInteger userId = [[SPServerObject getInstance].myUserProfileInfo.userInfo userID];
    
    [[RHProtocolSender getInstance] postToURL:[NSURL URLWithString:[[NSString alloc] initWithFormat:URL_USER_PROFILE, userId]] WithJSON:updateData
                                      Success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSMutableDictionary* JSON = responseObject;
         int result = [[JSON valueForKey:@"success"] intValue];
         if( result == 0 )
         {
             // Error Handling
             [RHUtilities popUpErrorMessage:[JSON valueForKey:@"message"] WithParentViewController:nil];
             return;
         }
         
         [[SPServerObject getInstance] loadMyProfileInfo:NO];
         NSInteger userID = [SPServerObject getInstance].myUserProfileInfo.userInfo.userID;
         [self.userProfileViewController loadUserProfileFromServer:userID];
         [self.navigationController popViewControllerAnimated:YES];
     }
                                      Failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [RHUtilities handleError:error WithParentViewController:self];
     }
                                      TimeOut:0.5];
    
}

- (void)postImageData
{
    if( self.selectedImageView == nil || self.selectedImageView.image==nil )
    {
        [RHUtilities popUpErrorMessage:@"Select an Image to make Profile Snap" WithParentViewController:self];
        return;
    }
    
    //send to server with field
    NSInteger userId = [[SPServerObject getInstance].myUserProfileInfo.userInfo userID];

    NSString* postSnapURL = nil;
    if( [self.field compare:@"profile_snap"] == NSOrderedSame )
        postSnapURL = [[NSString alloc] initWithFormat:URL_USER_PROFILESNAP, userId];
    else if( [self.field compare:@"profile_image"] == NSOrderedSame )
        postSnapURL = [[NSString alloc] initWithFormat:URL_USER_PROFILEIMAGE, userId];
    else
    {
        [RHUtilities popUpErrorMessage:@"error command" WithParentViewController:self];
        return;
    }
    
    
    [[RHProtocolSender getInstance] postToURL:[NSURL URLWithString:postSnapURL] WithJSON:nil WithImage:self.selectedImageView.image Name:@"snapProfile" FileName:@"snapProfile" Success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSData* theObject = (NSData*)responseObject;
        NSString* stringJSON = [[NSString alloc] initWithData:theObject encoding:NSUTF8StringEncoding];
        NSDictionary* JSON = (NSDictionary*)[stringJSON JSONValue];
        
        NSLog(@"%@", JSON.description);
        int result = [[JSON valueForKey:@"success"] intValue];
        if( result == 0 )
        {
            // Error Handling
            [RHUtilities popUpErrorMessage:[JSON valueForKey:@"message"] WithParentViewController:nil];
            return;
        }
        
        [[SPServerObject getInstance] loadMyProfileInfo:NO];
        NSInteger userID = [SPServerObject getInstance].myUserProfileInfo.userInfo.userID;
        [self.userProfileViewController loadUserProfileFromServer:userID];
        [self.navigationController popViewControllerAnimated:YES];
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [RHUtilities handleError:error WithParentViewController:self];
    } UploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
    }];
    
}


///////////////////Image Picker Controller///////////
-(void)pickAnImageFromAssetLibrary
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
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
        
        
        /////////// resize /////////////////////
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
        
        self.selectedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 90,
                                                                               240, 320)];
        [self.selectedImageView setImage:image];
        [self.selectedImageView setContentMode:UIViewContentModeScaleAspectFit];
        [self.view addSubview:self.selectedImageView];
    
        
        [picker dismissViewControllerAnimated:YES completion:^{
            
        }];
        
    } failureBlock:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
}


/////////////////////////////////////////////////////


@end
