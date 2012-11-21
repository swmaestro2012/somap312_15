//
//  SPSearchPersonViewController.m
//  Spot
//
//  Created by Sinhyub Kim on 11/17/12.
//  Copyright (c) 2012 Sinhyub Kim. All rights reserved.
//

@interface SPSearchPersonViewController ()
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (UIView*) tableView:(UITableView*)aTableView viewForHeaderInSection:(NSInteger)section;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@implementation SearchRow
@synthesize userInfo, action, profileImage;
@end

@implementation SearchSection
@synthesize sectionName, searchRowList;
-(id)init
{
    self = [super init];
    if( self )
    {
        searchRowList = [[NSMutableArray alloc] init];
    }
    return self;
}
@end


@implementation SPSearchPersonViewController
@synthesize searchBar, searchController, searchSectionList, spotInfo, postSnapViewController;

- (id)initWithPostSnapViewController:(SPPostSnapViewController*)postSnapViewController_;
{
    self = [super init];
    if( self )
    {
        postSnapViewController = postSnapViewController_;
        spotInfo = postSnapViewController_.spotInfoToPost;

        [self.view setBackgroundColor:[UIColor blackColor]];
        searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(SEARCHPERSON_FRAME_X, SEARCHPERSON_FRAME_Y,
                                                                  SEARCHPERSON_FRAME_WIDTH, SEARCHPERSON_FRAME_HEIGHT)];
        [searchBar setDelegate:self];
        [self.view addSubview:searchBar];
        searchController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
        searchController.delegate = self;
        searchController.searchResultsDataSource = self;
        searchController.searchResultsDelegate = self;
        
        searchSectionList = nil;

        [self loadTableRows:nil];
    }
    return self;
}


- (void)loadTableRows:(NSMutableArray*)resultUserList
{
    if( searchSectionList == nil )
    {
        searchSectionList = [[NSMutableArray alloc] init];
        
        SearchSection* myselfSection = [[SearchSection alloc] init];
        myselfSection.sectionName = @"Myself";
        [self.searchSectionList insertObject:myselfSection atIndex:SPSearchSectionMyself];
        
        SearchSection* peopleInSpotSection = [[SearchSection alloc] init];
        peopleInSpotSection.sectionName = [[NSString alloc] initWithFormat:@"People in %@",self.spotInfo.spotName];
        [self.searchSectionList insertObject:peopleInSpotSection atIndex:SPSearchSectionPeopleInSpot];
    }
    
    
    SearchSection* myselfSection = [self.searchSectionList objectAtIndex:SPSearchSectionMyself];
    [myselfSection.searchRowList removeAllObjects];
    
    SearchRow* myselfRow = [[SearchRow alloc] init];
    myselfRow.userInfo = [SPServerObject getInstance].myUserProfileInfo.userInfo;
    myselfRow.profileImage = [SPServerObject getInstance].myUserProfileImage;
    myselfRow.action = @selector(emptySelector);
    [myselfSection.searchRowList addObject:myselfRow];
    
    
    if( resultUserList != nil )
    {
        SearchSection* peopleInSpotSection = [self.searchSectionList objectAtIndex:SPSearchSectionPeopleInSpot];
        [peopleInSpotSection.searchRowList removeAllObjects];
        for( SPUserInfo* userInfo in resultUserList )
        {
            SearchRow* resultRow = [[SearchRow alloc] init];
            resultRow.userInfo = userInfo;
            resultRow.profileImage = nil;
            resultRow.action = @selector(emptySelector);
            [peopleInSpotSection.searchRowList addObject:resultRow];
        }
    }
    
    [self.searchController.searchResultsTableView reloadData];
    [self.searchController.searchResultsTableView updateConstraints];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    
    return [self.searchSectionList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if( section < 0 || section >= SPSearchSectionMax)
    {
        return 0;
    }
    SearchSection* theSearchSection = [self.searchSectionList objectAtIndex:section];
    return [theSearchSection.searchRowList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"SearchRow"];
    
    SearchSection* searchSection = [self.searchSectionList objectAtIndex:indexPath.section];
    SearchRow* rowData = [searchSection.searchRowList objectAtIndex:indexPath.row];
    
    [cell.textLabel setText:rowData.userInfo.nickname];
    [cell.imageView setImage:rowData.profileImage];
    [cell.textLabel setTextColor:[UIColor blueColor]];
    return cell;
}

-(UIView*) tableView:(UITableView*)aTableView viewForHeaderInSection:(NSInteger)section
{
    SearchSection* searchSection = [self.searchSectionList objectAtIndex:section];
    
    UILabel *sectionHeader = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    sectionHeader.backgroundColor = [UIColor darkGrayColor];
    sectionHeader.font = [UIFont boldSystemFontOfSize:18];
    sectionHeader.textColor = [UIColor whiteColor];
    sectionHeader.text = searchSection.sectionName;
    sectionHeader.textAlignment = NSTextAlignmentCenter;
    
    return sectionHeader;
}


- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSLog(@"%d, %d, %@", range.location, range.location, text);
    return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar_
{
    if( searchBar_ == self.searchBar )
    {
        NSString* searchName = self.searchBar.text;
        [self requestSearchResultsWithKeyword:searchName];
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    SearchSection* section = [self.searchSectionList objectAtIndex:indexPath.section];
    SearchRow* searchRow= [section.searchRowList objectAtIndex:indexPath.row];
    
    SEL action = searchRow.action;
    SPUserInfo* selectedUserInfo = searchRow.userInfo;
    
    NSAssert( selectedUserInfo != nil, @"UserInfo Must be Found, ::didSelectRowAtIndexPAth" );
    
    self.postSnapViewController.modelUserInfo = selectedUserInfo;
    [self.view removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
    
    if(action)
    {
//        [self hideMenuBar:self];
        [self performSelector:action withObject:self afterDelay:MENU_TABLE_CLOSE_DELAY];
    }
}

- (void)emptySelector
{
    
}

- (void)requestSearchResultsWithKeyword:(NSString*)keyword
{
    NSAssert(self.spotInfo!=nil, @"SpotInfo must be NOT NIL ::requestSesaerchResults");
    NSString* searchURL = [[NSString alloc] initWithFormat:URL_SEARCHUSER,self.spotInfo.spotID];
    
    NSMutableDictionary* requestData = [[NSMutableDictionary alloc] initWithObjectsAndKeys:keyword, @"search_keyword", nil];
    [[RHProtocolSender getInstance] postToURL:[NSURL URLWithString:searchURL] WithJSON:requestData Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableDictionary* JSON = responseObject;
        int result = [[JSON valueForKey:@"success"] intValue];
        if( result == 0 )
        {
            // Error Handling
            [RHUtilities popUpErrorMessage:[JSON valueForKey:@"message"] WithParentViewController:nil];
            return;
        }
        
        NSMutableDictionary* searchResultsJSON = [JSON valueForKey:@"data"];
        if( [searchResultsJSON isMemberOfClass:[NSNull class]] == YES )
        {
            NSLog(@"No Result Data For Search%@", keyword);
            return;
        }
        NSLog(@"%@", searchResultsJSON.description);
        
        NSArray* resultUserListJSON = [searchResultsJSON valueForKey:@"user_infos"];
        if( [resultUserListJSON isMemberOfClass:[NSNull class]] == YES )
        {
            NSLog(@"Error in retrieving result Keyword");
            return;
        }
        
        NSMutableArray* userList = [[NSMutableArray alloc] initWithCapacity:resultUserListJSON.count];
        
        for( id userInfoJSON in resultUserListJSON )
        {
            SPUserInfo* userInfo = [[SPUserInfo alloc] initWithJSONDictionary:userInfoJSON];
            [userList addObject:userInfo];
        }
        
        [self loadTableRows:userList];
     
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [RHUtilities handleError:error WithParentViewController:self];
    } TimeOut:15.0f];
    
}


@end
