//
//  SPRootViewController.m
//  Spot
//
//  Created by Sinhyub Kim on 11/5/12.
//  Copyright (c) 2012 Sinhyub Kim. All rights reserved.
//


@interface SPRootViewController ()

@end

@implementation SPRootViewController
@synthesize menuTableViewController;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        CGRect rootViewFrame = CGRectMake(ROOT_FRAME_X, ROOT_FRAME_Y, ROOT_FRAME_WIDTH, ROOT_FRAME_HEIGHT);
        [self.view setFrame:rootViewFrame];
//        UIImageView* backgroundImage = [[UIImageView alloc] initWithImage:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_PLACEHHOLDER]];
//        [backgroundImage setFrame:rootViewFrame];
//        [backgroundImage setClipsToBounds:NO];
//        [self.view addSubview:backgroundImage];


        if( self.menuTableViewController == nil )
        {
            self.menuTableViewController = [SPMenuTableViewController getInstance];
            [self.view addSubview:self.menuTableViewController.view];
            [self.menuTableViewController didMoveToParentViewController:self];
            
            
            // Initialize MainView From RootView Controller
            // To avoid View Hierarchy Problem,
            [self.menuTableViewController setRootViewAsParentOfMainView:self.view];
//            [self.menuTableViewController.mainViewController loadSpotMapViewController];
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

@end
