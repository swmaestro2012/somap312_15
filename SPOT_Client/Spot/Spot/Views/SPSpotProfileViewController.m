//
//  SPSpotProfileViewController.m
//  Spot
//
//  Created by Sinhyub Kim on 11/8/12.
//  Copyright (c) 2012 Sinhyub Kim. All rights reserved.
//

@interface SPSpotProfileViewController ()

@end

@implementation SPSpotProfileViewController

@synthesize popularityLabel;
@synthesize spotKingLabel;
@synthesize spotKingImageView;
@synthesize spotQueenLabel;
@synthesize spotQueenImageView;
@synthesize spotDescriptionLabel;
@synthesize memberListViewController;
@synthesize spotInfo;
@synthesize spotKingIcon;
@synthesize spotQueenIcon;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        [self.view setFrame:CGRectMake(SPOTPROFILE_FRAME_X, SPOTPROFILE_FRAME_Y, SPOTPROFILE_FRAME_WIDTH, SPOTPROFILE_FRAME_HEIGHT)];
//        [self.view setBackgroundColor:[[UIColor alloc] initWithPatternImage: [[RHImageManager getInstance]getImageByKey:IMAGE_KEY_BACKGROUNDTEXTURE] ]];
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_BACKGROUNDTEXTURE]]];
//        [self.view setBackgroundColor:[UIColor blackColor]];
       
        
        [((UIScrollView*)self.view) setContentSize:CGSizeMake(SPOTPROFILE_FRAME_WIDTH, SPOTPROFILE_FRAME_HEIGHT+60)];
        if( self.spotKingLabel == nil )
        {
            self.spotKingLabel = [[UILabel alloc] initWithFrame:CGRectMake(SPOTPROFILE_SPOTKINGLABEL_X, SPOTPROFILE_SPOTKINGLABEL_Y, SPOTPROFILE_SPOTKINGLABEL_WIDTH, SPOTPROFILE_SPOTKINGLABEL_HEIGHT)];
            [self.spotKingLabel setShadowColor:[UIColor grayColor]];
            [self.spotKingLabel setShadowOffset:CGSizeMake(0,1)];
            [self.spotKingLabel setTextAlignment:NSTextAlignmentCenter];
            [self.spotKingLabel setText:SPOTPROFILE_SPOTKINGLABEL_DEFAULT];
            [self.spotKingLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
            [self.spotKingLabel setTextColor:[UIColor whiteColor]];
            [self.spotKingLabel setBackgroundColor:[UIColor clearColor]];

            [self.view addSubview:self.spotKingLabel];
        }
        
        if( self.spotKingIcon == nil )
        {
            self.spotKingIcon = [[UIImageView alloc] initWithFrame:CGRectMake(SPOTPROFILE_SPOTKINGICON_X,SPOTPROFILE_SPOTKINGICON_Y,SPOTPROFILE_SPOTKINGICON_WIDTH,SPOTPROFILE_SPOTKINGICON_HEIGHT)];
            [self.spotKingIcon setImage:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_KINGICON]];
            [self.view addSubview: self.spotKingIcon];
        }
        
        if( self.spotQueenIcon == nil )
        {
            self.spotQueenIcon = [[UIImageView alloc] initWithFrame:CGRectMake(SPOTPROFILE_SPOTQUEENICON_X,SPOTPROFILE_SPOTQUEENICON_Y, SPOTPROFILE_SPOTQUEENICON_WIDTH,SPOTPROFILE_SPOTQUEENICON_HEIGHT)];
            [self.spotQueenIcon setImage:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_QUEENICON]];
            [self.view addSubview: self.spotQueenIcon];
        }
        
        if( self.spotKingNameLabel == nil )
        {
            self.spotKingNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(SPOTPROFILE_SPOTKINGNAMELABEL_X, SPOTPROFILE_SPOTKINGNAMELABEL_Y, SPOTPROFILE_SPOTKINGNAMELABEL_WIDTH, SPOTPROFILE_SPOTKINGNAMELABEL_HEIGHT)];
            [self.spotKingNameLabel setShadowColor:[UIColor grayColor]];
            [self.spotKingNameLabel setShadowOffset:CGSizeMake(1,1)];
            [self.spotKingNameLabel setTextAlignment:NSTextAlignmentCenter];
            [self.spotKingNameLabel setText:SPOTPROFILE_SPOTKINGNAMELABEL_DEFAULT];
            [self.spotKingNameLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
            [self.spotKingNameLabel setTextColor:[UIColor whiteColor]];
            [self.spotKingNameLabel setBackgroundColor:[UIColor clearColor]];
            
            [self.view addSubview:self.spotKingNameLabel];

        }
        
        if( self.spotKingImageView == nil )
        {
            self.spotKingImageView = [[SPSnapImageView alloc] initWithFrame:CGRectMake(SPOTPROFILE_SPOTKINGIMAGEVIEW_X, SPOTPROFILE_SPOTKINGIMAGEVIEW_Y, SPOTPROFILE_SPOTKINGIMAGEVIEW_WIDTH, SPOTPROFILE_SPOTKINGIMAGEVIEW_HEIGHT)];
            [self.spotKingImageView setImage:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_PLACEHHOLDER]];
            [self.spotKingImageView setContentMode:UIViewContentModeScaleAspectFit];
            [self.view addSubview:self.spotKingImageView];
        }
        
        if( self.spotQueenLabel == nil )
        {
            self.spotQueenLabel = [[UILabel alloc] initWithFrame:CGRectMake(SPOTPROFILE_SPOTQUEENLABEL_X, SPOTPROFILE_SPOTQUEENLABEL_Y, SPOTPROFILE_SPOTQUEENLABEL_WIDTH, SPOTPROFILE_SPOTQUEENLABEL_HEIGHT)];
            [self.spotQueenLabel setShadowColor:[UIColor grayColor]];
            [self.spotQueenLabel setShadowOffset:CGSizeMake(1,1)];
            [self.spotQueenLabel setTextAlignment:NSTextAlignmentCenter];
            [self.spotQueenLabel setText:SPOTPROFILE_SPOTQUEENLABEL_DEFAULT];
            [self.spotQueenLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
            [self.spotQueenLabel setTextColor:[UIColor whiteColor]];
            [self.spotQueenLabel setBackgroundColor:[UIColor clearColor]];
            [self.view addSubview:self.spotQueenLabel];
        }
        
        if( self.spotQueenNameLabel == nil )
        {
            self.spotQueenNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(SPOTPROFILE_SPOTQUEENNAMELABEL_X, SPOTPROFILE_SPOTQUEENNAMELABEL_Y, SPOTPROFILE_SPOTQUEENNAMELABEL_WIDTH, SPOTPROFILE_SPOTQUEENNAMELABEL_HEIGHT)];
            [self.spotQueenNameLabel setShadowColor:[UIColor grayColor]];
            [self.spotQueenNameLabel setShadowOffset:CGSizeMake(1,1)];
            [self.spotQueenNameLabel setTextAlignment:NSTextAlignmentCenter];
            [self.spotQueenNameLabel setText:SPOTPROFILE_SPOTQUEENNAMELABEL_DEFAULT];
            [self.spotQueenNameLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
            [self.spotQueenNameLabel setTextColor:[UIColor whiteColor]];
            [self.spotQueenNameLabel setBackgroundColor:[UIColor clearColor]];
            
            [self.view addSubview:self.spotQueenNameLabel];
        }
        
        if( self.spotQueenImageView == nil )
        {
            self.spotQueenImageView = [[SPSnapImageView alloc] initWithFrame:CGRectMake(SPOTPROFILE_SPOTQUEENIMAGEVIEW_X, SPOTPROFILE_SPOTQUEENIMAGEVIEW_Y, SPOTPROFILE_SPOTQUEENIMAGEVIEW_WIDTH, SPOTPROFILE_SPOTQUEENIMAGEVIEW_HEIGHT)];
            [self.spotQueenImageView setImage:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_PLACEHHOLDER]];
            [self.spotQueenImageView setContentMode:UIViewContentModeScaleAspectFit];
            [self.view addSubview:self.spotQueenImageView];
        }
        
        if( self.popularityLabel == nil)
        {
            self.popularityLabel = [[UILabel alloc] initWithFrame:CGRectMake(SPOTPROFILE_SPOTPOPULARITYLABEL_X, SPOTPROFILE_SPOTPOPULARITYLABEL_Y, SPOTPROFILE_SPOTPOPULARITYLABEL_WIDTH, SPOTPROFILE_SPOTPOPULARITYLABEL_HEIGHT)];
            [self.popularityLabel setText:SPOTPROFILE_SPOTPOPULARITYLABEL_DEFAULT];
            [self.popularityLabel setTextAlignment:NSTextAlignmentRight];
            [self.popularityLabel setFont:[UIFont systemFontOfSize:12.0f]];
            [self.popularityLabel setShadowColor:[UIColor grayColor]];
            [self.popularityLabel  setShadowOffset:CGSizeMake(1,1)];
            [self.popularityLabel setTextColor:[UIColor whiteColor]];
            [self.popularityLabel setBackgroundColor:[UIColor clearColor]];
            [self.view addSubview:self.popularityLabel];
        }

        
        if( self.spotDescriptionLabel == nil )
        {
            self.spotDescriptionLabel = [[UITextField alloc] initWithFrame:CGRectMake(SPOTPROFILE_SPOTDESCRIPTIONLABEL_X, SPOTPROFILE_SPOTDESCRIPTIONLABEL_Y, SPOTPROFILE_SPOTDESCRIPTIONLABEL_WIDTH, SPOTPROFILE_SPOTDESCRIPTIONLABEL_HEIGHT)];
            self.spotDescriptionLabel.viewForBaselineLayout.layer.cornerRadius = 6;
            [self.spotDescriptionLabel setTextAlignment:NSTextAlignmentLeft];
            [self.spotDescriptionLabel setBackgroundColor:[UIColor whiteColor]];
            [self.spotDescriptionLabel setEnabled:NO];
            [self.view addSubview:self.spotDescriptionLabel];
            
        }
        
        
//        //////// TEST King / Queen
//        UIImageView* kingIcon = [[UIImageView alloc] initWithImage:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_BACKGROUNDTEXTURE]];
//        UIImageView* kingIcon1 = [[UIImageView alloc] initWithImage:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_KINGICON1]];
//        UIImageView* kingIcon2 = [[UIImageView alloc] initWithImage:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_KINGICON2]];
//        UIImageView* queenIcon1 = [[UIImageView alloc] initWithImage:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_QUEENICON1]];
//        
//        [kingIcon1 setFrame:CGRectMake(10, 30, 20, 20)];
//        [kingIcon setFrame:CGRectMake(30, 30, 44, 44)];
//        [kingIcon2 setFrame:CGRectMake(60, 30, 30, 30)];
//        [queenIcon1 setFrame:CGRectMake(110, 30, 50, 50)];
//        
//        [self.view addSubview:kingIcon];
//        [self.view addSubview:kingIcon1];
//        [self.view addSubview:kingIcon2];
//        [self.view addSubview:queenIcon1];
        
        
        
        
        UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(45.0f, 0.0f, 70.0f, 30.0f)];
        [titleLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
        [titleLabel setText:@">SPOT NAME GOES HERE<"];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setShadowColor:[UIColor grayColor]];
        [titleLabel setShadowOffset:CGSizeMake(1,1)];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [self.navigationItem setTitleView:titleLabel];
        
        UIBarButtonItem* joinBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"JOIN" style:UIBarButtonItemStylePlain target:self action:@selector(onJOINButtonPushed)];
        [self.navigationItem setRightBarButtonItem:joinBarButtonItem];
    
    }
    return self;
}

- (void)loadView
{
    self.view = [[UIScrollView alloc] initWithFrame:CGRectMake(SPOTPROFILE_FRAME_X, SPOTPROFILE_FRAME_Y, SPOTPROFILE_FRAME_WIDTH, SPOTPROFILE_FRAME_HEIGHT)];
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

-(void) onJOINButtonPushed
{
    BOOL isMySpot = [[SPServerObject getInstance] isMySpot:self.spotInfo.spotID];

    if( isMySpot == NO)
    {
        // Request Join
        NSString* userSpotURL = [[NSString alloc] initWithFormat:URL_SPOT_JOIN, self.spotInfo.spotID];
        [[RHProtocolSender getInstance] postToURL:[NSURL URLWithString:userSpotURL] WithJSON:nil Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSMutableDictionary* JSON = responseObject;
            int result = [[JSON valueForKey:@"success"] intValue];
            if( result == 0 )
            {
                // Error Handling
                [RHUtilities popUpErrorMessage:[JSON valueForKey:@"message"] WithParentViewController:self];
                return;
            }
            
            [((UIBarButtonItem*)self.navigationItem.rightBarButtonItem) setTitle:@"Enter"];
            [[SPServerObject getInstance] loadMyProfileInfo:NO];
            
        } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [RHUtilities handleError:error WithParentViewController:self];
        } TimeOut:10.0f];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
        [[SPMenuTableViewController getInstance] openUserMap:self.spotInfo.spotName];
        [[SPMenuTableViewController getInstance] openAndCloseMenuBar:self];
    }
}

-(void) loadDataWithSpotID:(NSInteger)spotID
{
    NSString* spotURL = [[NSString alloc] initWithFormat:URL_SPOT,spotID];
    
    [[RHProtocolSender getInstance] getJSONFromURL:[NSURL URLWithString:spotURL] WithJSON:nil Success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
    {
        NSDictionary* JSONDictionary = JSON;
        int result = [[JSON valueForKey:@"success"] intValue];
        if( result == 0 )
        {
            // Error Handling
            [RHUtilities popUpErrorMessage:[JSON valueForKey:@"message"] WithParentViewController:self];
            return;
        }
        
        NSLog(@"%@", JSONDictionary.description);
        
        // SPOT INFO
        NSAssert(self.spotInfo == nil, @"Spot Info is already initialized");
        self.spotInfo = [[SPSpotInfo alloc] initWithJSONDictionary: [[JSONDictionary valueForKey:@"data"] valueForKey:@"spot"]];
        
        // SPOT TITLE TO NAVIGATION BAR
        NSAssert( [self.navigationItem.titleView isMemberOfClass:[UILabel class]] == YES, @"Navigation Bar's Title View has to be a UILable" );
        [((UILabel*)self.navigationItem.titleView) setText:self.spotInfo.spotName];
        
        // SPOT POPULARITY
        NSString* popularityText = [[NSString alloc] initWithFormat:@"GRADE %d",self.spotInfo.popularity];
        [self.popularityLabel setText:popularityText];
        
        // King / Queen Name
        SPUserInfo* kingUserInfo = self.spotInfo.kingUserInfo;
//        NSAssert( kingUserInfo!=nil, @"loadData SpotProfile : King UserInfo is nil" );
        [self.spotKingNameLabel setText:kingUserInfo.nickname];
        
        SPUserInfo* queenUserInfo = self.spotInfo.queenUserInfo;
//        NSAssert( queenUserInfo!=nil, @"loadData SpotProfile : Queen UserInfo is nil" );
        [self.spotQueenNameLabel setText:queenUserInfo.nickname];
        
        // King / Queen Image
        [self.spotDescriptionLabel setText:self.spotInfo.description];
        
        
        // Set Navigation Item
        BOOL isMySpot = [[SPServerObject getInstance] isMySpot:self.spotInfo.spotID];
        if( isMySpot == YES )
        {
            [((UIBarButtonItem*)self.navigationItem.rightBarButtonItem) setTitle:@"Enter"];
        }
        
        NSString* kingProfileSnapURL = [[NSString alloc] initWithFormat:URL_USER_PROFILESNAP,kingUserInfo.userID];
        [[RHProtocolSender getInstance] getImageFromURL:[NSURL URLWithString:kingProfileSnapURL] WithImageView:self.spotKingImageView.imageView WithJSON:nil WithPlaceholder:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_PLACEHHOLDER] Success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            [self.spotKingImageView setNeedsDisplay];
        } Failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            
        } TimeOut:10.0f];
        
        NSString* queenProfileSnapURL = [[NSString alloc] initWithFormat:URL_USER_PROFILESNAP,queenUserInfo.userID];
        [[RHProtocolSender getInstance] getImageFromURL:[NSURL URLWithString:queenProfileSnapURL] WithImageView:self.spotQueenImageView.imageView WithJSON:nil WithPlaceholder:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_PLACEHHOLDER] Success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            [self.spotQueenImageView setNeedsDisplay];
        } Failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            
        } TimeOut:10.0f];

        
    } Failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"%@", error);
        [RHUtilities handleError:error WithParentViewController:self];
    } TimeOut:8.0f];
}

@end
