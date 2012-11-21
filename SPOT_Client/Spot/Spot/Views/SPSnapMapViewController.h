//
//  SPSpotMapViewController.h
//  Spot
//
//  Created by Sinhyub Kim on 11/5/12.
//  Copyright (c) 2012 Sinhyub Kim. All rights reserved.
//

@interface SPSnapMapViewController : UIViewController


-(void)handleTapGesture:(UITapGestureRecognizer*) sender;
-(void)handlePopUpClosingTapGesture:(UITapGestureRecognizer*) sender;
-(void)handlePanGesture:(UIPanGestureRecognizer*) sender;
-(void)handlePopUpSlidingPanGesture:(UIPanGestureRecognizer*) sender;


-(void)openPopUpWindowWithImage:(UIImage*) image;
-(void)closePopUpWindow;

-(void)addSpotMapGestureRecognizers;
-(void)removeSpotMapGestureRecognizers;

-(void)onPopUpGotoButtonPushedUp:(UIButton*) sender;

-(void)selectImage:(SPSnapImageView*) selectedImageView;
@end
