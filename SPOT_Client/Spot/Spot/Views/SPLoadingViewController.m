//
//  SPLoadingViewController.m
//  Spot
//
//  Created by Sinhyub Kim on 11/5/12.
//  Copyright (c) 2012 Sinhyub Kim. All rights reserved.
//


@interface SPLoadingViewController ()

@end

@implementation SPLoadingViewController

// sign in view
@synthesize m_SignInButton;
@synthesize m_SignUpButton;
@synthesize m_UserIDText;
@synthesize m_UserPasswordText;

// sign up view
@synthesize userNewPasswordLabel;
@synthesize userNewPasswordConfirmLabel;
@synthesize userNewPhoneNumberLabel;
@synthesize userNewEmailLabel;
@synthesize userNewPasswordText;
@synthesize userNewPasswordConfirmText;
@synthesize userNewPhoneNumberText;
@synthesize userNewEmailText;
@synthesize userNewContractView;
@synthesize userNewCancelButton;
@synthesize userNewSubmitButton;

@synthesize panGestureRecognizer;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.view setFrame:CGRectMake(MAIN_FRAME_X, MAIN_FRAME_Y, MAIN_FRAME_WIDTH, MAIN_FRAME_HEIGHT)];
        
        self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        [self.view addGestureRecognizer:self.panGestureRecognizer];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self displaySignInView];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    if( self.m_UserPasswordText != textField )
    {
        [self.m_UserPasswordText becomeFirstResponder];
        return YES;
    }
    
    [self sendSignInData:self.m_UserIDText.text Password:self.m_UserPasswordText.text];
    
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)clearView
{
    if( self.userIDLabel != nil)
    {
        [self.userIDLabel removeFromSuperview];
        self.userIDLabel = nil;
    }
    
    if( self.userPasswordLabel != nil)
    {
        [self.userPasswordLabel removeFromSuperview];
        self.userPasswordLabel = nil;
    }
    
    if( self.m_UserIDText != nil)
    {
        [self.m_UserIDText removeFromSuperview];
        self.m_UserIDText = nil;
    }
    
    if( self.m_UserPasswordText != nil)
    {
        [self.m_UserPasswordText removeFromSuperview];
        self.m_UserPasswordText = nil;
    }
    
    if( self.m_SignInButton != nil)
    {
        [self.m_SignInButton removeFromSuperview];
        self.m_SignInButton = nil;
    }
    
    if( self.m_SignUpButton != nil)
    {
        [self.m_SignUpButton removeFromSuperview];
        self.m_SignUpButton = nil;
    }
    
    if( self.userNewPasswordLabel != nil)
    {
        [self.userNewPasswordLabel removeFromSuperview];
        self.userNewPasswordLabel = nil;
    }
    
    if( self.userNewPasswordConfirmLabel != nil)
    {
        [self.userNewPasswordConfirmLabel removeFromSuperview];
        self.userNewPasswordConfirmLabel = nil;
    }
    
    if( self.userNewPhoneNumberLabel != nil)
    {
        [self.userNewPhoneNumberLabel removeFromSuperview];
        self.userNewPhoneNumberLabel = nil;
    }
    
    if( self.userNewEmailLabel != nil)
    {
        [self.userNewEmailLabel removeFromSuperview];
        self.userNewEmailLabel = nil;
    }
    
    if( self.userNewPasswordText!= nil)
    {
        [self.userNewPasswordText removeFromSuperview];
        self.userNewPasswordText = nil;
    }
    
    if( self.userNewPasswordConfirmText != nil)
    {
        [self.userNewPasswordConfirmText removeFromSuperview];
        self.userNewPasswordConfirmText = nil;
    }
    
    if( self.userNewPhoneNumberText != nil)
    {
        [self.userNewPhoneNumberText removeFromSuperview];
        self.userNewPhoneNumberText = nil;
    }
    
    if( self.userNewEmailText != nil)
    {
        [self.userNewEmailText removeFromSuperview];
        self.userNewEmailText = nil;
    }
    
    if( self.userNewContractView != nil)
    {
        [self.userNewContractView removeFromSuperview];
        self.userNewContractView = nil;
    }
    
    if( self.userNewSubmitButton != nil)
    {
        [self.userNewSubmitButton removeFromSuperview];
        self.userNewSubmitButton = nil;
    }
    
    if( self.userNewCancelButton != nil)
    {
        [self.userNewCancelButton removeFromSuperview];
        self.userNewCancelButton = nil;
    }
    
}

-(void)displaySignInView
{
    [self clearView];
    
    [self.view setBackgroundColor:[[UIColor alloc] initWithPatternImage: [[RHImageManager getInstance]getImageByKey:IMAGE_KEY_BACKGROUNDTEXTURE]]];
    
    {
        self.userIDLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 150, 70, 30.0)];
        [self.userIDLabel setText:@"Your ID"];
        [self.userIDLabel setBackgroundColor:[UIColor clearColor]];
        [self.userIDLabel setTextColor:[UIColor whiteColor]];
        [self.view addSubview:self.userIDLabel];
    }
    
    {
        self.userPasswordLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 200, 80, 30.0)];
        [self.userPasswordLabel setText:@"Password"];
        [self.userPasswordLabel setBackgroundColor:[UIColor clearColor]];
        [self.userPasswordLabel setTextColor:[UIColor whiteColor]];
        [self.view addSubview:self.userPasswordLabel];
    }
    
    {
        self.m_UserIDText = [[UITextField alloc] initWithFrame:CGRectMake(120, 150, 170, 30.0)];
        self.m_UserIDText.autocorrectionType = UITextAutocorrectionTypeNo;
        self.m_UserIDText.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [self.m_UserIDText setBorderStyle:UITextBorderStyleRoundedRect];
        [self.m_UserIDText setKeyboardAppearance:UIKeyboardTypeDefault];
        [self.m_UserIDText setReturnKeyType:UIReturnKeyDefault];
        [self.m_UserIDText setDelegate:self];
        [self.view addSubview:self.m_UserIDText];
    }
    
    {
        self.m_UserPasswordText = [[UITextField alloc] initWithFrame:CGRectMake(120, 200, 170, 30.0)];
        self.m_UserPasswordText.autocorrectionType = UITextAutocorrectionTypeNo;
        self.m_UserPasswordText.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [self.m_UserPasswordText setBorderStyle:UITextBorderStyleRoundedRect];
        [self.m_UserPasswordText setKeyboardAppearance:UIKeyboardTypeDefault];
        [self.m_UserPasswordText setReturnKeyType:UIReturnKeyDefault];
        [self.m_UserPasswordText setDelegate:self];
        [self.view addSubview:self.m_UserPasswordText];
    }
    
    {
        
        self.m_SignInButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.m_SignInButton setFrame:CGRectMake(30.0, 270.0, 90.0, 30.0)];
        [self.m_SignInButton setBackgroundImage:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_SIGNINBUTTON]  forState:UIControlStateNormal];
        [self.m_SignInButton setBackgroundImage:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_SIGNINBUTTON_PRESSED]  forState:UIControlStateHighlighted];
        [self.m_SignInButton setTitle:@"Sign In" forState:UIControlStateNormal];
        [self.m_SignInButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
        [self.m_SignInButton addTarget:self action:@selector(onSignInButtonPushedUp:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview: self.m_SignInButton];
    }
    
    {
        self.m_SignUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.m_SignUpButton setFrame:CGRectMake(200.0, 270.0, 90.0, 30.0)];
        [self.m_SignUpButton setBackgroundImage:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_SIGNINBUTTON]  forState:UIControlStateNormal];
        [self.m_SignUpButton setBackgroundImage:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_SIGNINBUTTON_PRESSED]  forState:UIControlStateHighlighted];
        [self.m_SignUpButton setTitle:@"Sign Up" forState:UIControlStateNormal];
        [self.m_SignUpButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
        [self.m_SignUpButton addTarget:self action:@selector(onSignUpButtonPushedUp:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview: self.m_SignUpButton];
    }
}

-(void)displaySignUpView
{
    [self clearView];
    
    {
        self.userNewEmailLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 50, 70, 30.0)];
        [self.userNewEmailLabel setText:@"EMail"];
        [self.userNewEmailLabel setBackgroundColor:[UIColor clearColor]];
        [self.userNewEmailLabel setTextColor:[UIColor whiteColor]];
        [self.view addSubview:self.userNewEmailLabel];
    }
    {
        self.userNewEmailText = [[UITextField alloc] initWithFrame:CGRectMake(120, 50, 170, 30.0)];
        self.userNewEmailText.autocorrectionType = UITextAutocorrectionTypeNo;
        self.userNewEmailText.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [self.userNewEmailText setBorderStyle:UITextBorderStyleRoundedRect];
        [self.userNewEmailText setKeyboardAppearance:UIKeyboardTypeDefault];
        [self.userNewEmailText setReturnKeyType:UIReturnKeyDefault];
        [self.userNewEmailText setDelegate:self];
        [self.view addSubview:self.userNewEmailText];
    }
    
    
    {
        self.userNewPasswordLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 90, 70, 30.0)];
        [self.userNewPasswordLabel setText:@"Password"];
        [self.userNewPasswordLabel setBackgroundColor:[UIColor clearColor]];
        [self.userNewPasswordLabel setTextColor:[UIColor whiteColor]];
        [self.view addSubview:self.userNewPasswordLabel];
    }
    
    {
        self.userNewPasswordConfirmLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 130, 70, 30.0)];
        [self.userNewPasswordConfirmLabel setText:@"Password Confirm"];
        [self.userNewPasswordConfirmLabel setBackgroundColor:[UIColor clearColor]];
        [self.userNewPasswordConfirmLabel setTextColor:[UIColor whiteColor]];
        [self.view addSubview:self.userNewPasswordConfirmLabel];
    }
    
    {
        self.userNewPhoneNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 170, 70, 30.0)];
        [self.userNewPhoneNumberLabel setText:@"Phone Number"];
        [self.userNewPhoneNumberLabel setBackgroundColor:[UIColor clearColor]];
        [self.userNewPhoneNumberLabel setTextColor:[UIColor whiteColor]];
        [self.view addSubview:self.userNewPhoneNumberLabel];
    }
    
    {
        self.userNewPasswordText = [[UITextField alloc] initWithFrame:CGRectMake(120, 90, 170, 30.0)];
        self.userNewPasswordText.autocorrectionType = UITextAutocorrectionTypeNo;
        self.userNewPasswordText.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [self.userNewPasswordText setBorderStyle:UITextBorderStyleRoundedRect];
        [self.userNewPasswordText setKeyboardAppearance:UIKeyboardTypeDefault];
        [self.userNewPasswordText setReturnKeyType:UIReturnKeyDefault];
        [self.userNewPasswordText setDelegate:self];
        [self.view addSubview:self.userNewPasswordText];
    }
    
    {
        self.userNewPasswordConfirmText = [[UITextField alloc] initWithFrame:CGRectMake(120, 130, 170, 30.0)];
        self.userNewPasswordConfirmText.autocorrectionType = UITextAutocorrectionTypeNo;
        self.userNewPasswordConfirmText.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [self.userNewPasswordConfirmText setBorderStyle:UITextBorderStyleRoundedRect];
        [self.userNewPasswordConfirmText setKeyboardAppearance:UIKeyboardTypeDefault];
        [self.userNewPasswordConfirmText setReturnKeyType:UIReturnKeyDefault];
        [self.userNewPasswordConfirmText setDelegate:self];
        [self.view addSubview:self.userNewPasswordConfirmText];
    }
    
    {
        self.userNewPhoneNumberText = [[UITextField alloc] initWithFrame:CGRectMake(120, 170, 170, 30.0)];
        self.userNewPhoneNumberText.autocorrectionType = UITextAutocorrectionTypeNo;
        self.userNewPhoneNumberText.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [self.userNewPhoneNumberText setBorderStyle:UITextBorderStyleRoundedRect];
        [self.userNewPhoneNumberText setKeyboardAppearance:UIKeyboardTypeDefault];
        [self.userNewPhoneNumberText setReturnKeyType:UIReturnKeyDefault];
        [self.userNewPhoneNumberText setDelegate:self];
        [self.view addSubview:self.userNewPhoneNumberText];
    }    
    
    {
        self.userNewContractView = [[UIScrollView alloc] initWithFrame:CGRectMake(30,270,260, 130.0)];
        [self.userNewContractView setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:self.userNewContractView];
    }
    
    {
        self.userNewSubmitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.userNewSubmitButton setFrame:CGRectMake(180.0, 230.0, 100.0, 30.0)];
        [self.userNewSubmitButton setBackgroundImage:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_SIGNINBUTTON]  forState:UIControlStateNormal];
        [self.userNewSubmitButton setBackgroundImage:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_SIGNINBUTTON_PRESSED]  forState:UIControlStateHighlighted];
        [self.userNewSubmitButton setTitle:@"Submit" forState:UIControlStateNormal];
        [self.userNewSubmitButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
        [self.userNewSubmitButton addTarget:self action:@selector(onUserNewSubmitButtonPushedUp:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview: self.userNewSubmitButton];
    }
    
    {
        self.userNewCancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.userNewCancelButton setFrame:CGRectMake(30.0, 230.0, 100.0, 30.0)];
        [self.userNewCancelButton setBackgroundImage:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_SIGNINBUTTON]  forState:UIControlStateNormal];
        [self.userNewCancelButton setBackgroundImage:[[RHImageManager getInstance] getImageByKey:IMAGE_KEY_SIGNINBUTTON_PRESSED]  forState:UIControlStateHighlighted];
        [self.userNewCancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [self.userNewCancelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
        [self.userNewCancelButton addTarget:self action:@selector(onUserNewCancelButtonPushedUp:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview: self.userNewCancelButton];
    }
    
}

-(void)onSignInButtonPushedUp:(UIButton*) sender
{
    if( sender.selected)
    {
        [sender setSelected:FALSE];
        return;
    }
    
    [sender setSelected:TRUE];
    
    [self sendSignInData:self.m_UserIDText.text Password:self.m_UserPasswordText.text];
}

-(void)onSignUpButtonPushedUp:(UIButton*) sender
{
    if( sender.selected)
    {
        [sender setSelected:FALSE];
        return;
    }
    
    [sender setSelected:TRUE];
 
    [self displaySignUpView];
}

-(void)onUserNewCancelButtonPushedUp:(UIButton*) sender
{
    [sender setEnabled:NO];
    
    [self displaySignInView];
}

-(void)onUserNewSubmitButtonPushedUp:(UIButton*) sender
{
    [sender setEnabled:NO];
    
    NSString* newUserID = self.userNewEmailText.text;
    NSString* newUserPassword = self.userNewPasswordText.text;
    NSString* newUserPasswordConfirm = self.userNewPasswordConfirmText.text;
    NSString* newUserPhoneNumber = self.userNewPhoneNumberText.text;
    NSString* newUserEmail = self.userNewEmailText.text;
    
    if( [newUserPassword compare:newUserPasswordConfirm] == true )
    {
        [RHUtilities popUpErrorMessage:@"Passwords are not matched" WithParentViewController:self];
        return;
    }
    
    RHProtocolSender* protocolSender = [RHProtocolSender getInstance];
    NSMutableDictionary* signUpData = [[NSMutableDictionary alloc] initWithObjectsAndKeys:newUserID, @"user_id",   newUserPassword, @"user_password", newUserPhoneNumber, @"phone_number", newUserEmail, @"email", nil];
    // TO DO : MUST USE user_password
    
    [protocolSender postToURL:[NSURL URLWithString:URL_USERS] WithJSON:signUpData
                      Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                          
                          NSMutableDictionary* JSON = responseObject;
                          
                          int result = [[JSON valueForKey:@"success"] intValue];
                          if( result == 0 )
                          {
                              // Error Handling
                              [RHUtilities popUpErrorMessage:[JSON valueForKey:@"message"] WithParentViewController:self];
                              [sender setEnabled:YES];
                              return;
                          }
                          
                          //[RHUtilities popUpErrorMessage:@"Sign Up Completed" WithParentViewController:self];
                          // 1. automatically sign-in
                          [self sendSignInData:newUserID Password:newUserPassword];
                      }
                      Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          [RHUtilities handleError:error WithParentViewController:self];
                          [sender setEnabled:YES];
                      } TimeOut:5.0];
}

-(void)sendSignInData:(NSString*)userID Password:(NSString*) password
{
    [[RHProtocolSender getInstance] signInWithUserID:userID Password:password WithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableDictionary* JSON = responseObject;
        
        int result = [[JSON valueForKey:@"success"] intValue];
        if( result == 0 )
        {
            // Error Handling
            [RHUtilities popUpErrorMessage:[JSON valueForKey:@"message"] WithParentViewController:self];
            [[SPServerObject getInstance] onSignOut];
            return;
        }
        
        [[SPServerObject getInstance] onSignInWithServerKey:[JSON valueForKey:@"server_key"] UserID:[[JSON valueForKey:@"user_id"] stringValue]];
        
        self.m_UserIDText.text = @"";
        self.m_UserPasswordText.text = @"";
        
        // To MainViewController
        [[SPMenuTableViewController getInstance] onPhysicalSpotMapMenuSelected];
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[SPServerObject getInstance] setIsSignedIn:NO];
        [RHUtilities handleError:error WithParentViewController:self];
        
        [[SPServerObject getInstance] onSignOut];
        //   [[SPMainViewController getInstance] onSignOutComplete];
    } TimeOut:15.0f];    
}

-(void)handlePanGesture:(UIPanGestureRecognizer*) sender
{
    static CGPoint oldTranslate;
    if( sender.state == UIGestureRecognizerStateBegan)
    {
        oldTranslate = [sender translationInView:self.view];
    }

    if( sender.state == UIGestureRecognizerStateChanged)
    {
        CGPoint newTranslate = [sender translationInView:self.view];
        CGPoint offset = CGPointMake(newTranslate.x - oldTranslate.x, newTranslate.y - oldTranslate.y);
        for( UIView* subview in self.view.subviews )
        {
            [subview setFrame:CGRectOffset(subview.frame, 0, offset.y)];
        }
        
        oldTranslate = newTranslate;
    }
    if( sender.state == UIGestureRecognizerStateEnded)
    {
        oldTranslate = CGPointMake(0.f,0.f);
    }
}

@end