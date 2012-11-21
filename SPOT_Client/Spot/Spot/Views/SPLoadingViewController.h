//
//  SPLoadingViewController.h
//  Spot
//
//  Created by Sinhyub Kim on 11/5/12.
//  Copyright (c) 2012 Sinhyub Kim. All rights reserved.
//


@interface SPLoadingViewController : UIViewController <UITextFieldDelegate>

// Sign In View
@property (strong, nonatomic) UILabel* userIDLabel;
@property (strong, nonatomic) UILabel* userPasswordLabel;
@property (strong, nonatomic) UIButton* m_SignInButton;
@property (strong, nonatomic) UIButton* m_SignUpButton;
@property (strong, nonatomic) UITextField* m_UserIDText;
@property (strong, nonatomic) UITextField* m_UserPasswordText;

// Sign Up View
@property (strong, nonatomic) UILabel* userNewPasswordLabel;
@property (strong, nonatomic) UILabel* userNewPasswordConfirmLabel;
@property (strong, nonatomic) UILabel* userNewPhoneNumberLabel;
@property (strong, nonatomic) UILabel* userNewEmailLabel;
@property (strong, nonatomic) UITextField* userNewPasswordText;
@property (strong, nonatomic) UITextField* userNewPasswordConfirmText;
@property (strong, nonatomic) UITextField* userNewPhoneNumberText;
@property (strong, nonatomic) UITextField* userNewEmailText;
@property (strong, nonatomic) UIScrollView* userNewContractView;
@property (strong, nonatomic) UIButton* userNewCancelButton;
@property (strong, nonatomic) UIButton* userNewSubmitButton;

@property (strong, nonatomic) UIPanGestureRecognizer* panGestureRecognizer;


-(void)clearView;
-(void)displaySignInView;
-(void)displaySignUpView;
-(void)onSignInButtonPushedUp:(UIButton*) sender;
-(void)onSignUpButtonPushedUp:(UIButton*) sender;
-(void)onUserNewCancelButtonPushedUp:(UIButton*) sender;
-(void)onUserNewSubmitButtonPushedUp:(UIButton*) sender;
-(void)sendSignInData:(NSString*)userID Password:(NSString*) password;

-(void)handlePanGesture:(UIPanGestureRecognizer*) sender;

@end

