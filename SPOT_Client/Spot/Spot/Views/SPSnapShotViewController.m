//
//  SPSnapShotViewController.m
//  Spot
//
//  Created by redd0g on 12. 11. 11..
//  Copyright (c) 2012년 Sinhyub Kim. All rights reserved.
//

@interface SPSnapShotViewController ()
@property (strong, nonatomic) UITapGestureRecognizer* tapGestureRecognizer;
- (void)postComment:(NSString*)comment;
@end

@implementation SPSnapShotViewController

@synthesize snapInfo;
@synthesize snapImageView;
@synthesize profileImage;
@synthesize snapDescription;
@synthesize tapGestureRecognizer;
@synthesize userNameLabel;
@synthesize likeButton;
@synthesize commentButton;
@synthesize contentsOffset;
@synthesize commentInfoList;
@synthesize commentTextField;
@synthesize commentBoxView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        snapImageView = [[SPSnapImageView alloc] initWithFrame:CGRectMake(SNAPSHOT_SNAPSHOT_FRAME_X, SNAPSHOT_SNAPSHOT_FRAME_Y,
                                                                      SNAPSHOT_SNAPSHOT_FRAME_WIDTH, SNAPSHOT_SNAPSHOT_FRAME_HEIGHT)];
        [snapImageView setContentMode:UIViewContentModeScaleAspectFit];
        [self.view addSubview:snapImageView];
        
        snapDescription = [[UILabel alloc] initWithFrame:CGRectMake(SNAPSHOT_DESCRIPTION_FRAME_X, SNAPSHOT_DESCRIPTION_FRAME_Y,
                                                                 SNAPSHOT_DESCRIPTION_FRAME_WIDTH, SNAPSHOT_DESCRIPTION_FRAME_HEIGHT)];
        [snapDescription setBackgroundColor:[UIColor whiteColor]];
        snapDescription.viewForBaselineLayout.layer.cornerRadius = 4;
        [snapDescription setFont:[UIFont systemFontOfSize:12.0f]];
        [snapDescription setTextAlignment:NSTextAlignmentLeft];
        [snapDescription setNumberOfLines:0];
        [snapDescription setLineBreakMode:NSLineBreakByWordWrapping];

//        [snapDescription.viewForBaselineLayout.layer.corner]
        
        [self.view addSubview:snapDescription];

        userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(SNAPSHOT_USERNAME_FRAME_X,SNAPSHOT_USERNAME_FRAME_Y, SNAPSHOT_USERNAME_FRAME_WIDTH,SNAPSHOT_USERNAME_FRAME_HEIGHT)];
        [userNameLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [userNameLabel setBackgroundColor:[UIColor clearColor]];
        [userNameLabel setTextColor:[UIColor whiteColor]];
        [userNameLabel setText:@"SPOT USER"];
        [self.view addSubview: userNameLabel];
        
        UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(45.0f, 0.0f, 70.0f, 30.0f)];
        [titleLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
        [titleLabel setText:@"SNAP SHOT"];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [self.navigationItem setTitleView:titleLabel];

//        [userDesc addTarget:self action:@selector(onUserDescPushed) forControlEvents:UIControlEventAllTouchEvents];
        
        
        profileImage = [[UIImageView alloc] initWithFrame:CGRectMake(SNAPSHOT_PROFILE_FRAME_X, SNAPSHOT_PROFILE_FRAME_Y,
                                                                     SNAPSHOT_PROFILE_FRAME_WIDTH, SNAPSHOT_PROFILE_FRAME_HEIGHT)];
        [profileImage setContentMode:UIViewContentModeScaleAspectFit];
        [self.view addSubview:profileImage];
        
        tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        [self.view addGestureRecognizer:tapGestureRecognizer];
        
        commentInfoList = [[NSMutableArray alloc] init];
        
        commentTextField = [[UITextField alloc] initWithFrame:CGRectMake(SNAPSHOT_COMMENTTEXTFIELD_FRAME_X, SNAPSHOT_COMMENTTEXTFIELD_FRAME_Y,
                                                                         SNAPSHOT_COMMENTTEXTFIELD_FRAME_WIDTH, SNAPSHOT_COMMENTTEXTFIELD_FRAME_HEIGHT)];
        [commentTextField setDelegate:self];
        [commentTextField setBorderStyle:UITextBorderStyleRoundedRect];
        [commentTextField setPlaceholder:@"write a comment... "];
        [commentTextField setKeyboardType:UIKeyboardTypeDefault];
        commentTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        commentTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        
        commentBoxView = [[UIView alloc] initWithFrame:CGRectMake(SNAPSHOT_COMMENTBOX_FRAME_X, SNAPSHOT_COMMENTBOX_FRAME_Y,
                                                                  SNAPSHOT_COMMENTBOX_FRAME_WIDTH, SNAPSHOT_COMMENTBOX_FRAME_HEIGHT)];
        [commentBoxView setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:commentBoxView];
        
        likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [likeButton setFrame:CGRectMake(SNAPSHOT_LIKEBUTTON_FRAME_X, SNAPSHOT_LIKEBUTTON_FRAME_Y, SNAPSHOT_LIKEBUTTON_FRAME_WIDTH, SNAPSHOT_LIKEBUTTON_FRAME_HEIGHT)];
        [likeButton setBackgroundImage:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_SIGNINBUTTON]  forState:UIControlStateNormal];
        [likeButton setBackgroundImage:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_SIGNINBUTTON_PRESSED]  forState:UIControlStateHighlighted];
        [likeButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
        [likeButton setTitle:@"Like" forState:UIControlStateNormal];
        [likeButton setEnabled:NO];
        [likeButton addTarget:self action:@selector(onLikeButtonPushedUp:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview: self.likeButton];

        
        commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [commentButton setFrame:CGRectMake(SNAPSHOT_COMMENTBUTTON_FRAME_X, SNAPSHOT_COMMENTBUTTON_FRAME_Y, SNAPSHOT_COMMENTBUTTON_FRAME_WIDTH, SNAPSHOT_COMMENTBUTTON_FRAME_HEIGHT)];
        [commentButton setBackgroundImage:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_SIGNINBUTTON]  forState:UIControlStateNormal];
        [commentButton setBackgroundImage:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_SIGNINBUTTON_PRESSED]  forState:UIControlStateHighlighted];
        [commentButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
        [commentButton setTitle:@"Comment" forState:UIControlStateNormal];
        [commentButton addTarget:self action:@selector(onCommentButtonPushedUp:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview: self.commentButton];
        
//
//        UIButton *profileButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 30)];
//        [profileButton setTitle:@"Profile" forState:UIControlStateNormal];
//        [profileButton addTarget:self action:@selector(loadUserProfileView) forControlEvents:UIControlEventTouchUpInside];
//        [profileButton setBackgroundImage:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_BUTTON] forState:UIControlStateNormal];
//        UIBarButtonItem *profileBarButton = [[UIBarButtonItem alloc] initWithCustomView:profileButton];
//        [self.navigationItem setRightBarButtonItem:profileBarButton];

        
        
        UIBarButtonItem *profileButton = [[UIBarButtonItem alloc] initWithTitle:@"Profile" style:UIBarButtonItemStylePlain target:self action:@selector(loadUserProfileView)];
        [self.navigationItem setRightBarButtonItem:profileButton];
    }
    return self;
}

- (id) initWithSnapInfo:(SPSnapImageView*)snapImageView_
{
    self = [super init];
    if(self)
    {
        [snapImageView setImage:snapImageView_.imageView.image];
        snapInfo = snapImageView_.snapInfo;
        NSAssert(snapInfo!=nil, @"Snap info must not be nil. check initWithSnapInfo");
        
        [snapDescription setText:snapInfo.description];
        NSString* snapURL = [[NSString alloc] initWithFormat:URL_SNAP,snapInfo.snapID];
        [[RHProtocolSender getInstance] getJSONFromURL:[NSURL URLWithString:snapURL] WithJSON:nil Success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            int result = [[JSON valueForKey:@"success"] intValue];
            if( result == 0 )
            {
                // Error Handling
                [RHUtilities popUpErrorMessage:[JSON valueForKey:@"message"] WithParentViewController:nil];
                return;
            }

            NSMutableDictionary* dataJSON = [JSON valueForKey:@"data"];
            NSMutableDictionary* snapInfoJSON = [dataJSON valueForKey:@"snap"];
            NSLog(@"%@", snapInfoJSON.description);
            self.snapInfo = [[SPSnapInfo alloc] initWithJSONDictionary:snapInfoJSON];
            [self.snapDescription setText:self.snapInfo.description];
        } Failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [RHUtilities handleError:error WithParentViewController:self];
        } TimeOut:15.0f];
        
        [userNameLabel setText:snapInfo.userName];
        [self loadCommentsFromServer];
        
        [[RHProtocolSender getInstance] getImageFromURL:[NSURL URLWithString:[[NSString alloc] initWithFormat:URL_USER_PROFILEIMAGE, snapInfo.userID]] WithImageView:profileImage
                                               WithJSON:nil WithPlaceholder:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_KINGICON]
                                                Success:^(NSURLRequest* request, NSHTTPURLResponse* response, UIImage* image)
         {
             NSLog(@"Success");
             
         }
                                                Failure:^(NSURLRequest* request, NSHTTPURLResponse* response, NSError* error)
         {
             NSLog(@"Image Fail");
         }TimeOut:30.f];
        
        NSString* isLikeURL = [[NSString alloc] initWithFormat:URL_LIKE,self.snapInfo.snapID];
        [[RHProtocolSender getInstance] getJSONFromURL:[NSURL URLWithString:isLikeURL] WithJSON:nil Success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            int result = [[JSON valueForKey:@"success"] intValue];
            if( result == 0 )
            {
                // Error Handling
                [RHUtilities popUpErrorMessage:[JSON valueForKey:@"message"] WithParentViewController:nil];
                return;
            }
            
            NSMutableDictionary* isLikedJSON = [JSON valueForKey:@"data"];
            id value = [isLikedJSON valueForKey:@"liked"];
            if( [value isMemberOfClass:[NSNull class]] == YES )
                return;
            BOOL isLiked = [value boolValue];
            if( isLiked == YES )
            {
                [self.likeButton setTitle:@"Unlike" forState:UIControlStateNormal];
                [self.likeButton setEnabled:YES];
            }
            else
            {
                [self.likeButton setTitle:@"Like" forState:UIControlStateNormal];
                [self.likeButton setEnabled:YES];
            }

        } Failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [RHUtilities handleError:error WithParentViewController:self];
        } TimeOut:15.0f];
    }
    return self;
}

- (void)loadView
{
    UIScrollView* snapShotView = [[UIScrollView alloc]initWithFrame:CGRectMake(SNAPSHOT_FRAME_X, SNAPSHOT_FRAME_Y, SNAPSHOT_FRAME_WIDTH, SNAPSHOT_FRAME_HEIGHT)];
    [snapShotView setContentSize:CGSizeMake(SNAPSHOT_FRAME_WIDTH, SNAPSHOT_DESCRIPTION_FRAME_HEIGHT+SNAPSHOT_DESCRIPTION_FRAME_Y+100)];
//    [snapShotView setBackgroundColor:[UIColor blackColor]];
    [snapShotView setBackgroundColor:[UIColor colorWithPatternImage:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_BACKGROUNDTEXTURE]]];
    [snapShotView setDelegate:self];
    self.view = snapShotView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint moveOffset = CGPointMake(scrollView.contentOffset.x - self.contentsOffset.x, scrollView.contentOffset.y - self.contentsOffset.y);
    self.contentsOffset = scrollView.contentOffset;
    
    [self.commentButton setFrame:CGRectOffset(self.commentButton.frame, moveOffset.x, moveOffset.y)];
    [self.likeButton setFrame:CGRectOffset(self.likeButton.frame, moveOffset.x, moveOffset.y)];
    [self.commentTextField setFrame:CGRectOffset(self.commentTextField.frame,moveOffset.x,moveOffset.y)];
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

- (void)handleTapGesture:(UITapGestureRecognizer*) sender
{
    CGPoint tapPoint = [sender locationInView:self.view];
    if( CGRectContainsPoint(self.snapImageView.frame, tapPoint) || CGRectContainsPoint(self.profileImage.frame, tapPoint) )
    {
        [self loadUserProfileView];
    }
}

- (void)loadUserProfileView
{
    SPUserProfileViewController* userProfileViewController = [[SPUserProfileViewController alloc] initWithUserId:snapInfo.userID];
    [userProfileViewController.navigationItem setLeftBarButtonItem:nil];
    [self.navigationController pushViewController:userProfileViewController animated:YES];
}

- (void)loadCommentsFromServer
{
    NSString* commentURL = [[NSString alloc] initWithFormat:URL_COMMENTS, self.snapInfo.snapID];
    [[RHProtocolSender getInstance] getJSONFromURL:[NSURL URLWithString:commentURL] WithJSON:nil Success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
    {
        int result = [[JSON valueForKey:@"success"] intValue];
        if( result == 0 )
        {
            // Error Handling
            [RHUtilities popUpErrorMessage:[JSON valueForKey:@"message"] WithParentViewController:nil];
            return;
        }
        
        NSMutableDictionary* commentsJSON = [JSON valueForKey:@"data"];
        NSLog(@"%@", commentsJSON.description);
        
        NSMutableArray* commentListJSON = [commentsJSON valueForKey:@"comment_list"];
        
        if( [commentListJSON isMemberOfClass:[NSNull class]] == YES )
        {
            return;
        }
        
        [self.commentInfoList removeAllObjects];
        for( id commentJSON in commentListJSON )
        {
            SPCommentInfo* commentInfo = [[SPCommentInfo alloc] initWithJSONDictionary:commentJSON];
            [self.commentInfoList addObject:commentInfo];
        }
        
        [self displayComments];
    } Failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [RHUtilities handleError:error WithParentViewController:self];
    } TimeOut:15.0f];
}

- (void)displayComments
{
    UIScrollView* snapshotView = ((UIScrollView*)self.view);
    int commentCountBefore = self.commentBoxView.subviews.count;
    
    // remove all comments
    for( UIView* commentLabels in self.commentBoxView.subviews )
    {
        [commentLabels removeFromSuperview];
    }
    
    // load commenets
    int commentCount = 0;
    for( SPCommentInfo* commentInfo in self.commentInfoList)
    {
        int commentHeight = (SNAPSHOT_COMMENT_FRAME_HEIGHT+SNAPSHOT_PROFILEIMAGE_FRAME_HEIGHT+1)*commentCount++;
        
        UIImageView* commentProfile =  [[UIImageView alloc] initWithFrame:CGRectMake(0,commentHeight, SNAPSHOT_PROFILEIMAGE_FRAME_WIDTH, SNAPSHOT_PROFILEIMAGE_FRAME_HEIGHT)];
        [commentProfile setImage:[[RHImageManager getInstance] getImageByKey:(commentInfo.userInfo.gender==@"F")?IMAGE_KEY_FEMALE:IMAGE_KEY_MALE]];
        [self.commentBoxView addSubview:commentProfile];

        UILabel* profileName = [[UILabel alloc] initWithFrame:CGRectMake(SNAPSHOT_PROFILEIMAGE_FRAME_WIDTH+5,commentHeight, SNAPSHOT_PROFILENAME_WIDTH, SNAPSHOT_PROFILENAME_HEIGHT)];
        [profileName setText:commentInfo.userInfo.nickname];
        [profileName setTextColor:[UIColor whiteColor]];
        [profileName setBackgroundColor:[UIColor clearColor]];
        [self.commentBoxView addSubview:profileName];

        
        UILabel* newComment = [[UILabel alloc] initWithFrame:CGRectMake(0,commentHeight+SNAPSHOT_PROFILEIMAGE_FRAME_HEIGHT, SNAPSHOT_COMMENT_FRAME_WIDTH, SNAPSHOT_COMMENT_FRAME_HEIGHT)];
        [newComment setText:commentInfo.comment];
        [newComment setTextColor:[UIColor whiteColor]];
        [newComment setBackgroundColor:[UIColor clearColor]];
        [self.commentBoxView addSubview:newComment];
    }
    
    const int commentDiff = (self.commentBoxView.subviews.count-commentCountBefore)/3;
    [snapshotView setContentSize:CGSizeMake(snapshotView.contentSize.width, snapshotView.contentSize.height+(SNAPSHOT_COMMENT_FRAME_HEIGHT+SNAPSHOT_PROFILEIMAGE_FRAME_HEIGHT+1)*commentDiff)];
}

- (void)onLikeButtonPushedUp:(id)sender
{
    if( sender != self.likeButton )
        return;
    
    if( [self.likeButton.titleLabel.text compare:@"Like"] == NSOrderedSame )
    {
        [self sendLike];
        [self.likeButton setEnabled:NO];
    }
    else if( [self.likeButton.titleLabel.text compare:@"Unlike"] == NSOrderedSame )
    {
        [self sendDislike];
        [self.likeButton setEnabled:NO];
    }
}

- (void)sendLike
{
    NSString* likeURL = [[NSString alloc] initWithFormat:URL_LIKE,self.snapInfo.snapID];
    [[RHProtocolSender getInstance] postToURL:[NSURL URLWithString:likeURL] WithJSON:nil Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableDictionary* JSON = responseObject;
        int result = [[JSON valueForKey:@"success"] intValue];
        if( result == 0 )
        {
            // Error Handling
            [RHUtilities popUpErrorMessage:[JSON valueForKey:@"message"] WithParentViewController:self];
            return;
        }
        
        // TO DO : LIKE update
        [self.likeButton setTitle:@"Unlike" forState:UIControlStateNormal];
        [self.likeButton setEnabled:YES];

    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [RHUtilities handleError:error WithParentViewController:self];
    } TimeOut:15.0f];
}

- (void)sendDislike
{
    NSString* likeURL = [[NSString alloc] initWithFormat:URL_DISLIKE,self.snapInfo.snapID];
    [[RHProtocolSender getInstance] postToURL:[NSURL URLWithString:likeURL] WithJSON:nil Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableDictionary* JSON = responseObject;
        int result = [[JSON valueForKey:@"success"] intValue];
        if( result == 0 )
        {
            // Error Handling
            [RHUtilities popUpErrorMessage:[JSON valueForKey:@"message"] WithParentViewController:self];
            return;
        }
        
        // TO DO : LIKE update
        [self.likeButton setTitle:@"Like" forState:UIControlStateNormal];
        [self.likeButton setEnabled:YES];
        
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [RHUtilities handleError:error WithParentViewController:self];
    } TimeOut:15.0f];

}


- (void)onCommentButtonPushedUp:(id)sender
{
    if( [((UIButton*)sender).titleLabel.text compare:@"Comment"] == NSOrderedSame )
    {
        [self.view addSubview:commentTextField];
        [((UIButton*)sender) setTitle:@"POST" forState:UIControlStateNormal];
    }
    else if( [((UIButton*)sender).titleLabel.text compare:@"POST"] == NSOrderedSame )
    {
        [self.commentTextField removeFromSuperview];
        [((UIButton*)sender) setTitle:@"Comment" forState:UIControlStateNormal];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if( self.commentTextField == textField )
    {
        [self moveTextField:textField DerectionTo:YES];
    }
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if( self.commentTextField == textField )
    {
        NSString* commentString = self.commentTextField.text;
        if( commentString != nil && [commentString compare:@""]!=NSOrderedSame )
        {
            [self postComment:commentString];
        }
        [self.commentTextField setText:nil];
        [self moveTextField:textField DerectionTo:NO];
        
    }

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self onCommentButtonPushedUp:self.commentButton];
    return YES;
}



- (void)moveTextField:(UITextField*)textField DerectionTo:(BOOL)isUp
{
    if( textField != self.commentTextField )
        return;
    
    const int movementDistance = 215;  // Keyboard Height
    const float movementDuration = 0.25f; // tweak as needed
    
    int movement = (isUp ? -movementDistance : movementDistance);
    
    [UIView animateWithDuration:movementDuration animations:^{
        textField.frame = CGRectOffset(textField.frame, 0, movement);
        self.commentButton.frame = CGRectOffset(self.commentButton.frame, 0, movement);
    }];
}

- (void)postComment:(NSString*)comment
{
    NSString* commentURL = [[NSString alloc] initWithFormat:URL_COMMENTS,self.snapInfo.snapID];
    NSMutableDictionary* commentData = [[NSMutableDictionary alloc] initWithObjectsAndKeys:comment,@"comment", nil];
    [[RHProtocolSender getInstance] postToURL:[NSURL URLWithString:commentURL] WithJSON:commentData Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableDictionary* JSON = responseObject;
        int result = [[JSON valueForKey:@"success"] intValue];
        if( result == 0 )
        {
            // Error Handling
            [RHUtilities popUpErrorMessage:[JSON valueForKey:@"message"] WithParentViewController:self];
            return;
        }

        SPCommentInfo* newCommentInfo = [[SPCommentInfo alloc] init];
        newCommentInfo.comment = comment;
        [self.commentInfoList addObject:newCommentInfo];
        [self displayComments];

        
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [RHUtilities handleError:error WithParentViewController:self];
    } TimeOut:15.0f];
}
@end
