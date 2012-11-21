//
//  RHImageManager.m
//  RoughHandsFramework_Chat
//
//  Created by Sinhyub Kim on 10/22/12.
//  Copyright (c) 2012 Sinhyub Kim. All rights reserved.
//

static RHImageManager* s_ImageManager = nil;

@implementation RHImageManager
@synthesize imageList;


// Singleton Methods

+ (id)allocWithZone:(NSZone *)zone
{
    return [self getInstance];
    //    return [[self getInstance] retain];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

+ (RHImageManager*) getInstance
{
    
    if( s_ImageManager == nil)
    {
        s_ImageManager = [[super allocWithZone:NULL] init];
    }
    return s_ImageManager;
}

-(id)init
{
    if (self = [super init])
    {
        // Initialization code here
        self.imageList = [[NSMutableDictionary alloc]init];
        
        UIImage* placeHolderImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"spBorder" ofType:@"png"]];
        [self pushImage:placeHolderImage ForKey:IMAGE_KEY_PLACEHHOLDER];
        
//        UIImage* backgroundImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"texture1" ofType:@"png"]];
//        [self pushImage:backgroundImage ForKey:IMAGE_KEY_BACKGROUNDTEXTURE];
        UIImage* backgroundImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"spBackgroundTexture" ofType:@"png"]];
        [self pushImage:backgroundImage ForKey:IMAGE_KEY_BACKGROUNDTEXTURE];
        
//        UIImage* barBlackButtonImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"BarBlackButton" ofType:@"png"]];
//        [self pushImage:barBlackButtonImage ForKey:IMAGE_KEY_BARBLACKBUTTON];
//        
//        UIImage* barBlackButtonHighlightedImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"BarBlackButtonHighlighted" ofType:@"png"]];
//        [self pushImage:barBlackButtonHighlightedImage ForKey:IMAGE_KEY_BARBLACKBUTTON_HIGHLIGHTED];

        UIImage* spButtonImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"spButton" ofType:@"png"]];
        [self pushImage:spButtonImage ForKey:IMAGE_KEY_BUTTON];
        
        UIImage* spButtonPressedImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"spButtonPressed" ofType:@"png"]];
        [self pushImage:spButtonPressedImage ForKey:IMAGE_KEY_BUTTON_PRESSED];

        UIImage* signInButtonImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"spButton" ofType:@"png"]];
        [self pushImage:signInButtonImage ForKey:IMAGE_KEY_SIGNINBUTTON];
        
        UIImage* signInButtonPressedImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"spButtonPressed" ofType:@"png"]];
        [self pushImage:signInButtonPressedImage ForKey:IMAGE_KEY_SIGNINBUTTON_PRESSED];
        
        UIImage* likeButtonImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"like" ofType:@"png"]];
        [self pushImage:likeButtonImage ForKey:IMAGE_KEY_LIKEBUTTON];
        
        UIImage* commentButtonImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"comment" ofType:@"png"]];
        [self pushImage:commentButtonImage ForKey:IMAGE_KEY_COMMENTBUTTON];

        UIImage* iconLogo = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"spotlogo" ofType:@"png"]];
        [self pushImage:iconLogo ForKey:IMAGE_KEY_LOGO];
        
        
        UIImage* menubarCell = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"spMenuBar" ofType:@"png"]];
        [self pushImage:menubarCell ForKey:IMAGE_KEY_MENUBAR];
        
        UIImage* menubarSection = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"spMenuBarSection" ofType:@"png"]];
        [self pushImage:menubarSection ForKey:IMAGE_KEY_MENUBARSECTION];
        
        
        UIImage* menubarIconLocation = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"spLocation" ofType:@"png"]];
        [self pushImage:menubarIconLocation ForKey:IMAGE_KEY_MENUBARICON_LOCATION];

        UIImage* menubarIconProfile = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"spProfile" ofType:@"png"]];
        [self pushImage:menubarIconProfile ForKey:IMAGE_KEY_MENUBARICON_PROFILE];
        
        UIImage* menubarIconSignout = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"spSignout" ofType:@"png"]];
        [self pushImage:menubarIconSignout ForKey:IMAGE_KEY_MENUBARICON_SIGNOUT];

        UIImage* menubarIconUserMap = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"spUsermap" ofType:@"png"]];
        [self pushImage:menubarIconUserMap ForKey:IMAGE_KEY_MENUBARICON_USERMAP];
        
        
        UIImage* menuOpened = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"menuOpened" ofType:@"png"]];
        [self pushImage:menuOpened ForKey:IMAGE_KEY_MENU_OPENED];
        
        UIImage* menuClosed = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"menuClosed" ofType:@"png"]];
        [self pushImage:menuClosed ForKey:IMAGE_KEY_MENU_CLOSED];


        
        UIImage* snapMapViewBox =[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"spotNameBox" ofType:@"png"]];
        [self pushImage:snapMapViewBox ForKey:IMAGE_KEY_SNAPMAPBOX];

        UIImage* genderImage =[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"gender2" ofType:@"png"]];
        [self pushImage:genderImage ForKey:IMAGE_KEY_GENDER];

        UIImage* femaleImage =[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"female222" ofType:@"png"]];
        [self pushImage:femaleImage ForKey:IMAGE_KEY_FEMALE];

        UIImage* maleImage =[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"male222" ofType:@"png"]];
        [self pushImage:maleImage ForKey:IMAGE_KEY_MALE];
        
        UIImage* kingIcon =[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"king_icon2-2" ofType:@"png"]];
        [self pushImage:kingIcon ForKey:IMAGE_KEY_KINGICON];
        
        UIImage* queenIcon =[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"queen_icon2-2" ofType:@"png"]];
        [self pushImage:queenIcon ForKey:IMAGE_KEY_QUEENICON];
        
        
        
        UIImage* bar320 =[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"spBar320" ofType:@"png"]];
        [self pushImage:bar320 ForKey:IMAGE_KEY_BAR320];
        UIImage* bar640 =[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"spBar640" ofType:@"png"]];
        [self pushImage:bar640 ForKey:IMAGE_KEY_BAR640];
        
        UIImage* navBar320 = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"spBar320" ofType:@"png"]];
        [self pushImage:navBar320 ForKey:IMAGE_KEY_NAVBAR320];
        
    }
    return self;
}

-(void)pushImage:(UIImage*)image ForKey:(NSString*)key
{
    [self.imageList setValue:image forKey:key];
    
}

-(void)removeImageByKey:(NSString*)key
{
    [self.imageList removeObjectForKey:key];
}

-(UIImage*)getImageByKey:(NSString*)key
{
    UIImage* image = [self.imageList valueForKey:key];
    if( image == nil )
    {
        NSLog(@"No Image Matching with the Key");
//        [RHUtilities popUpErrorMessage:@"No Image matching with the Key" WithParentViewController:[RHMainViewController getInstance]];
    }
    return image;
}

@end
