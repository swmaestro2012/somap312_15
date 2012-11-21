//
//  SPSpotMapViewController.h
//  Spot
//
//  Created by Sinhyub Kim on 11/10/12.
//  Copyright (c) 2012 Sinhyub Kim. All rights reserved.
//


@interface SPSpotMapViewController : SPSnapMapViewController
@property (nonatomic) BOOL isPhysicalSpot;
- (void)loadSpotMapViewFromServer:(BOOL)isPhysicalSpot;
@end
