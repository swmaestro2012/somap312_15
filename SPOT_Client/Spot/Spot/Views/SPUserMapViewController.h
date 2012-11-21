//
//  SPUserMapViewController.h
//  Spot
//
//  Created by Sinhyub Kim on 11/10/12.
//  Copyright (c) 2012 Sinhyub Kim. All rights reserved.
//

@interface SPUserMapViewController : SPSnapMapViewController

- (void)loadUserMapViewFromServer;
- (void)onNewPostButtonPushed;

-(void)selectImage:(SPSnapImageView*) selectedImageView;
@end
