//
//  SPUserProfileEditViewController.h
//  Spot
//
//  Created by redd0g on 12. 11. 13..
//  Copyright (c) 2012년 Sinhyub Kim. All rights reserved.
//


@interface SPUserProfileEditViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    UITextField* inputMessage;
}
@property (strong, nonatomic) NSString* field;
@property (strong, nonatomic) NSString* helpMessage;
@property (strong, nonatomic) UIImageView* selectedImageView;
@property (strong, nonatomic) UIButton* selectImageButton;
@property (nonatomic)  float selectedSnapLatitude;
@property (nonatomic)  float selectedSnapLongitude;
@property (nonatomic)  float selectedSnapAltitude;

@property (weak, nonatomic) SPUserProfileViewController* userProfileViewController;

- (id) initWithField:(NSString*)field WithHelpMessage:(NSString*)helpMessage UserProfileViewController:(SPUserProfileViewController*)userProfileViewController_;

- (void)pickAnImageFromAssetLibrary;

- (void)postStringData;
- (void)postImageData;
@end
