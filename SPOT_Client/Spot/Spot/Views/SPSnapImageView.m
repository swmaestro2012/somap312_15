//
//  SPSnapImageView.m
//  Spot
//
//  Created by Sinhyub Kim on 11/5/12.
//  Copyright (c) 2012 Sinhyub Kim. All rights reserved.
//

@implementation SPSnapImageView

@synthesize imageView;
@synthesize infoView;
@synthesize infoViewBox;
@synthesize snapInfo;
@synthesize snapImageViewType;


-(id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        if( imageView == nil )
        {
            CGRect imageRect = CGRectMake(SNAP_IMAGE_BORDER, SNAP_IMAGE_BORDER,
                                          frame.size.width-2*SNAP_IMAGE_BORDER, frame.size.height-2*SNAP_IMAGE_BORDER);
            
            imageView = [[UIImageView alloc] initWithFrame:imageRect];
            [imageView setContentMode:UIViewContentModeScaleAspectFit];
            [self addSubview:imageView];
            snapImageViewType = SNAPIMAGEVIEWTYPE_NONE;
            [self setBackgroundColor:[UIColor clearColor]];
        }
        if( infoViewBox == nil )
        {
            infoViewBox = [[UIImageView alloc] initWithFrame:CGRectMake(8,frame.size.height-SNAP_INFO_HEIGHT,SNAP_INFO_WIDTH,SNAP_INFO_HEIGHT)];
            [infoViewBox setImage:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_SNAPMAPBOX]];
//            [self addSubview:infoViewBox];
        }

        if( infoView == nil )
        {
            infoView = [[UILabel alloc] initWithFrame:CGRectMake(8+(SNAP_INFO_WIDTH/6/2),frame.size.height-(+SNAP_INFO_HEIGHT/6/2)-SNAP_INFO_HEIGHT,SNAP_INFO_WIDTH-(SNAP_INFO_WIDTH/6),SNAP_INFO_HEIGHT-(SNAP_INFO_HEIGHT/8))];
            [infoView setBackgroundColor:[UIColor clearColor]];
            [infoView setTextColor:[UIColor whiteColor]];
            [infoView setFont:[UIFont boldSystemFontOfSize:10.0f]];
//            [infoView setFont:[UIFont fontWithName:FONTNAME_NAMSAN size:12.0f]];
            [infoView setText:@"SPOT SPOT%d"];
            [infoView setTextAlignment:NSTextAlignmentCenter];
            [infoView setNumberOfLines:0];
            [infoView setLineBreakMode:NSLineBreakByCharWrapping];
//            [self.imageView addSubview:infoView];
        }
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    if(imageView != nil)
    {
        CGRect imageRect = CGRectMake(SNAP_IMAGE_BORDER, SNAP_IMAGE_BORDER,
                                      frame.size.width-2*SNAP_IMAGE_BORDER, frame.size.height-2*SNAP_IMAGE_BORDER);
        [imageView setFrame:imageRect];
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // TO DO : border

    
    // Drawing code
    CGRect backFrameRect = rect;
    CGSize imageSize = self.imageView.image.size;
    float imageRatio = (float)imageSize.width/(float)imageSize.height;
    float diff = (IMAGE_RATIO_BASIC - imageRatio);
    diff = ABS(diff);
    
    if( diff > 0.03 )
    {
        float newWidth = backFrameRect.size.height*imageRatio;
        float widthDiff = backFrameRect.size.width-newWidth;
        backFrameRect.origin.x = backFrameRect.origin.x+(widthDiff/2)-1;
        backFrameRect.size.width = newWidth+2;
        
        if( self.snapInfo.popularity == 0 )
        {
            CGRect infoViewFrame = CGRectMake((widthDiff)/2 ,rect.size.height-SNAP_INFO_HEIGHT/2*7/6,SNAP_INFO_WIDTH/2,SNAP_INFO_HEIGHT/2);
            [self.infoView setFrame:CGRectMake(infoViewFrame.origin.x+infoViewFrame.size.width/6/2,
                                               infoViewFrame.origin.y+infoViewFrame.size.height/6/2,
                                               infoViewFrame.size.width-infoViewFrame.size.width/6,
                                               infoViewFrame.size.height-infoViewFrame.size.height/6)];
            [self.infoView setFont:[UIFont boldSystemFontOfSize:8.0f]];
            [self.infoViewBox setFrame:infoViewFrame];
        }
        else
        {
            CGRect infoViewFrame = CGRectMake(widthDiff/2 ,rect.size.height-SNAP_INFO_HEIGHT*7/6,SNAP_INFO_WIDTH,SNAP_INFO_HEIGHT);
            [self.infoView setFrame:CGRectMake(infoViewFrame.origin.x+infoViewFrame.size.width/6/2,
                                               infoViewFrame.origin.y+infoViewFrame.size.height/6/2,
                                               infoViewFrame.size.width-infoViewFrame.size.width/6,
                                               infoViewFrame.size.height-infoViewFrame.size.height/6)];
            [self.infoView setFont:[UIFont boldSystemFontOfSize:10.0f]];
            [self.infoViewBox setFrame:infoViewFrame];
        }
    }
//    
//    if( self.imageView.image == nil )
//    {
////        [[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_BACKGROUNDTEXTURE] drawInRect:backFrameRect];
//    }
//    else
//    {
//        CGFloat cornerRadius = 2.0f;
//
//        CGContextRef context = UIGraphicsGetCurrentContext();
//
//        CGPathRef path = [UIBezierPath bezierPathWithRoundedRect:backFrameRect cornerRadius:cornerRadius].CGPath;
//
//        CGContextSetFillColorWithColor(context, [UIColor grayColor].CGColor);
//
//        CGContextAddPath(context, path);
//        CGContextDrawPath(context, kCGPathFill);
//    }
}

- (void)setSnapInfo:(SPSnapInfo*)snapInfo_
{
    snapInfo = snapInfo_;
    NSString* spotName = nil;
    if( snapInfo_ == nil )
    {
        spotName = @"SPOT";
    }
    else
    {
        spotName = [[NSString alloc] initWithFormat:@"%@",snapInfo_.spotName];
    }
    
    [infoView setText:spotName];
    if( snapInfo_ == nil )
    {
        [self.infoView removeFromSuperview];
        [self.infoViewBox removeFromSuperview];
    }
    else
    {
        [self.imageView addSubview:self.infoViewBox];
        [self.imageView addSubview:self.infoView];
    }    
}

- (SPSnapInfo*)getSnapInfo
{
    return snapInfo;
}

- (void)setImage:(UIImage*)image
{
    [self.imageView setImage:image];
}

- (UIImage*)getImage
{
    return self.imageView.image;
}


@end