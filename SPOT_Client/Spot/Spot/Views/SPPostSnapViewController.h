//
//  SPPostSnapViewController.h
//  Spot
//
//  Created by Sinhyub Kim on 11/5/12.
//  Copyright (c) 2012 Sinhyub Kim. All rights reserved.
//

@interface SPPostSnapViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate>

@property (strong, nonatomic)   SPSnapImageView*    selectedSnapView;
@property (nonatomic)           float               selectedSnapLatitude;
@property (nonatomic)           float               selectedSnapLongitude;
@property (nonatomic)           float               selectedSnapAltitude;
@property (strong, nonatomic)   UIButton*           chooseSnapButton;
@property (strong, nonatomic)   UIButton*           chooseModelButton;
@property (strong, nonatomic)   UIButton*           postSnapButton;
@property (strong, nonatomic)   UILabel*            modelLabel;
@property (strong, nonatomic)   UITextView*         descriptionTextView;
@property (weak, nonatomic)     SPSpotInfo*         spotInfoToPost;
@property (strong, nonatomic, setter=setModelUserInfo:) SPUserInfo* modelUserInfo;

@property (nonatomic) BOOL isDescriptionTextPlaceHolder;
@property (atomic)    BOOL isOnEditingDescriptionText;


- (id)initWithSpotInfo:(SPSpotInfo*)spotInfo_;
- (void)handleTapGesture:(UITapGestureRecognizer*) sender;
- (void)pickAnImageFromAssetLibrary;
- (void)onChooseSnapButtonPushedUp:(UIButton*) sender;
- (void)onSearchPersonButtonPushedUp:(UIButton*) sender;
- (void)onPostSnapButtonPushedUp:(UIButton*) sender;

- (void)setModelUserInfo:(SPUserInfo*)modelUserInfo_;

@end
