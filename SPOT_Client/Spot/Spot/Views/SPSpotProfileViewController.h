//
//  SPSpotProfileViewController.h
//  Spot
//
//  Created by Sinhyub Kim on 11/8/12.
//  Copyright (c) 2012 Sinhyub Kim. All rights reserved.
//

@interface SPSpotProfileViewController : UIViewController
@property (strong, nonatomic) UILabel*          popularityLabel;
@property (strong, nonatomic) UILabel*          spotKingLabel;
@property (strong, nonatomic) UILabel*          spotKingNameLabel;
@property (strong, nonatomic) UIImageView*      spotKingIcon;
@property (strong, nonatomic) UIImageView*      spotQueenIcon;
@property (strong, nonatomic) SPSnapImageView*  spotKingImageView;
@property (strong, nonatomic) UILabel*          spotQueenLabel;
@property (strong, nonatomic) UILabel*          spotQueenNameLabel;
@property (strong, nonatomic) SPSnapImageView*  spotQueenImageView;
@property (strong, nonatomic) UITextField*      spotDescriptionLabel;
@property (strong, nonatomic) SPSpotInfo*       spotInfo;


@property (strong, nonatomic) SPSnapMapViewController* memberListViewController;


-(void) loadDataWithSpotID:(NSInteger)spotID;
-(void) onJOINButtonPushed;


@end
