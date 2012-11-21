//
//  SPSnapImageView.h
//  Spot
//
//  Created by Sinhyub Kim on 11/5/12.
//  Copyright (c) 2012 Sinhyub Kim. All rights reserved.
//

typedef enum SNAPIMAGEVIEWTYPE {
    SNAPIMAGEVIEWTYPE_NONE = 0,
    SNAPIMAGEVIEWTYPE_SPOT = 1,
    SNAPIMAGEVIEWTYPE_USER = 2,
    } SNAPIMAGEVIEWTYPE;

@interface SPSnapImageView : UIView

@property (strong, nonatomic)   UIImageView* imageView;
@property (strong, nonatomic)   UILabel*    infoView;
@property (strong, nonatomic)   UIImageView* infoViewBox;
@property (strong, nonatomic, setter=setSnapInfo:, getter=getSnapInfo)   SPSnapInfo* snapInfo;
@property (nonatomic)           SNAPIMAGEVIEWTYPE snapImageViewType;


- (id)initWithFrame:(CGRect)frame;
- (void)drawRect:(CGRect)rect;
- (void)setFrame:(CGRect)rect;
- (void)setImage:(UIImage*)image;
- (void)setSnapInfo:(SPSnapInfo*)snapInfo_;
- (SPSnapInfo*)getSnapInfo;
- (UIImage*)getImage;

@end
