//
//  SPFavoriteViewController.h
//  Spot
//
//  Created by Sinhyub Kim on 11/20/12.
//  Copyright (c) 2012 Sinhyub Kim. All rights reserved.
//


@interface SPFavoriteViewController : UIViewController
{
    enum{
        snapWidth = 240,
        snapHeight = 320,
        snapInterval = 50,
    };
}
@property (strong, nonatomic)   NSMutableArray* favoriteSnapList;
@property (strong, nonatomic)   NSMutableArray* favoriteSnapImageViewList;


- (void)loadMyFavoriteSnapListFromServer;
- (void)displayMyFavoriteSnapList;
- (void)gotoProfileButton:(id)sender;
@end
