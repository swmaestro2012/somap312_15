//
//  SPSpotMapViewController.m
//  Spot
//
//  Created by Sinhyub Kim on 11/10/12.
//  Copyright (c) 2012 Sinhyub Kim. All rights reserved.
//

@interface SPSpotMapViewController ()

@end

@implementation SPSpotMapViewController
@synthesize isPhysicalSpot;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        isPhysicalSpot = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//    [self loadSpotMapViewFromServer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    SPSpotMapView* spotMapView = [[SPSpotMapView alloc] initWithFrame:CGRectMake(SNAPMAP_FRAME_X, SNAPMAP_FRAME_Y, SNAPMAP_FRAME_WIDTH, SNAPMAP_FRAME_HEIGHT)];
    self.view = spotMapView;
}

- (void)loadSpotMapViewFromServer:(BOOL)isPhysicalSpot_
{
    self.isPhysicalSpot = isPhysicalSpot_;
//    CLLocation* currentLocation = [RHUtilities getCurrentLocationData];
//    double lat = currentLocation.coordinate.latitude;
//    double lng = currentLocation.coordinate.longitude;
    
//    double lat = 3.000f;
//    double lng = 2.0000f;
//    NSString* latString = [[NSString alloc] initWithFormat:@"%f",lat];
//    NSString* lngString = [[NSString alloc] initWithFormat:@"%f",lng];
//
//    NSMutableDictionary* curGPS = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"gps",@"mode", latString,@"lat",lngString,@"lng", nil];
    [((SPSnapMapView*)self.view) removeAllSnapCells];
    
    ((SPSpotMapView*)self.view).curCellX = 0;
    ((SPSpotMapView*)self.view).curCellY = 0;
    
    NSNumber* cellX = [NSNumber numberWithInteger:((SPSpotMapView*)self.view).curCellX];
    NSNumber* cellY = [NSNumber numberWithInteger:((SPSpotMapView*)self.view).curCellY];
    
    NSMutableDictionary* curGPS = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"cell_position",@"mode", cellX, @"cell_x",cellY,@"cell_y", nil];
    
    [[RHProtocolSender getInstance] getJSONFromURL:isPhysicalSpot?[NSURL URLWithString:URL_PHYSICALSPOTMAP]:[NSURL URLWithString:URL_LOGICALSPOTMAP] WithJSON:curGPS Success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        int result = [[JSON valueForKey:@"success"] intValue];
        if( result == 0 )
        {
            // Error Handling
            [RHUtilities popUpErrorMessage:[JSON valueForKey:@"message"] WithParentViewController:nil];
            return;
        }
        
        NSMutableDictionary* spotMapJSON = [JSON valueForKey:@"data"];
        
        NSLog(@"%@", spotMapJSON.description);
        
        NSMutableArray* cellInfoList = [[NSMutableArray alloc] init];
        
        NSMutableDictionary* cellInfoJSON = nil;
        SPCellInfo* cellInfo =nil;
        
        cellInfoJSON = [spotMapJSON valueForKey:@"cell_0"];
        if( [cellInfoJSON isMemberOfClass:[NSNull class]] == YES )
        {
            [cellInfoList addObject:[[NSNull alloc] init]];
        }
        else
        {
            cellInfo= [[SPCellInfo alloc] initWithJSONDictionary:cellInfoJSON];
            [cellInfoList addObject:cellInfo];
        }
        
        cellInfoJSON = [spotMapJSON valueForKey:@"cell_1"];
        if( [cellInfoJSON isMemberOfClass:[NSNull class]] == YES )
        {
            [cellInfoList addObject:[[NSNull alloc] init]];
        }
        else
        {
            cellInfo = [[SPCellInfo alloc] initWithJSONDictionary:cellInfoJSON];
            [cellInfoList addObject:cellInfo];
        }
             
        cellInfoJSON = [spotMapJSON valueForKey:@"cell_2"];
        if( [cellInfoJSON isMemberOfClass:[NSNull class]] == YES )
        {
            [cellInfoList addObject:[[NSNull alloc] init]];
        }
        else
        {
            cellInfo = [[SPCellInfo alloc] initWithJSONDictionary:cellInfoJSON];
            [cellInfoList addObject:cellInfo];
        }
             
        cellInfoJSON = [spotMapJSON valueForKey:@"cell_3"];
         if( [cellInfoJSON isMemberOfClass:[NSNull class]] == YES )
         {
             [cellInfoList addObject:[[NSNull alloc] init]];
         }
         else
         {
             cellInfo = [[SPCellInfo alloc] initWithJSONDictionary:cellInfoJSON];
             [cellInfoList addObject:cellInfo];
         }
        
        cellInfoJSON = [spotMapJSON valueForKey:@"cell_4"];
        if( [cellInfoJSON isMemberOfClass:[NSNull class]] == YES )
        {
            [cellInfoList addObject:[[NSNull alloc] init]];
        }
        else
        {
            cellInfo = [[SPCellInfo alloc] initWithJSONDictionary:cellInfoJSON];
            [cellInfoList addObject:cellInfo];
        }
        
        cellInfoJSON = [spotMapJSON valueForKey:@"cell_5"];
        if( [cellInfoJSON isMemberOfClass:[NSNull class]] == YES )
        {
            [cellInfoList addObject:[[NSNull alloc] init]];
        }
        else
        {
            cellInfo = [[SPCellInfo alloc] initWithJSONDictionary:cellInfoJSON];
            [cellInfoList addObject:cellInfo];
        }
        
        cellInfoJSON = [spotMapJSON valueForKey:@"cell_6"];
        if( [cellInfoJSON isMemberOfClass:[NSNull class]] == YES )
        {
            [cellInfoList addObject:[[NSNull alloc] init]];
        }
        else
        {
            cellInfo = [[SPCellInfo alloc] initWithJSONDictionary:cellInfoJSON];
            [cellInfoList addObject:cellInfo];
        }
        cellInfoJSON = [spotMapJSON valueForKey:@"cell_7"];
        if( [cellInfoJSON isMemberOfClass:[NSNull class]] == YES )
        {
            [cellInfoList addObject:[[NSNull alloc] init]];
        }
        else
        {
            cellInfo = [[SPCellInfo alloc] initWithJSONDictionary:cellInfoJSON];
            [cellInfoList addObject:cellInfo];
        }
        
        cellInfoJSON = [spotMapJSON valueForKey:@"cell_8"];
        if( [cellInfoJSON isMemberOfClass:[NSNull class]] == YES )
        {
            [cellInfoList addObject:[[NSNull alloc] init]];
        }
        else
        {
            cellInfo = [[SPCellInfo alloc] initWithJSONDictionary:cellInfoJSON];
            [cellInfoList addObject:cellInfo];
        }
        
        [((SPSnapMapView*)self.view) loadWithCellInfoList:cellInfoList];

    } Failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [RHUtilities handleError:error WithParentViewController:self];
    } TimeOut:10.0f];
    
}

@end
