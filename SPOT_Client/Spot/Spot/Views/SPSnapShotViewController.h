//
//  SPSnapShotViewController.h
//  Spot
//
//  Created by redd0g on 12. 11. 11..
//  Copyright (c) 2012년 Sinhyub Kim. All rights reserved.
//

@interface SPSnapShotViewController : UIViewController <UIScrollViewDelegate,UITextFieldDelegate>
@property (strong, nonatomic) SPSnapInfo*   snapInfo;
@property (strong, nonatomic) SPSnapImageView*  snapImageView;
@property (strong, nonatomic) UIImageView*  profileImage;
@property (strong, nonatomic) UILabel*      snapDescription;
@property (strong, nonatomic) UILabel*      userNameLabel;
@property (strong, nonatomic) UIButton*     likeButton;
@property (strong, nonatomic) UIButton*     commentButton;
@property (nonatomic) CGPoint               contentsOffset;
@property (strong, nonatomic) NSMutableArray*   commentInfoList;
@property (strong, nonatomic) UITextField*  commentTextField;
@property (strong, nonatomic) UIView*       commentBoxView;

- (id) initWithSnapInfo:(SPSnapImageView*)snapImageView_;
- (void)loadView;
- (void)handleTapGesture:(UITapGestureRecognizer*) sender;
- (void)loadUserProfileView;

- (void)loadCommentsFromServer;
- (void)sendLike;
- (void)sendDislike;
- (void)displayComments;
- (void)onLikeButtonPushedUp:(id)sender;
- (void)onCommentButtonPushedUp:(id)sender;

- (void)textFieldDidBeginEditing:(UITextField *)textField;
- (void)textFieldDidEndEditing:(UITextField *)textField;
- (void)moveTextField:(UITextField*)textField DerectionTo:(BOOL)isUp;

@end
