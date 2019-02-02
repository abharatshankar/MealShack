//
//  searchItemsDisplayViewController.m
//  MealShack
//
//  Created by ashwin challa on 8/2/17.
//  Copyright © 2017 Possibillion. All rights reserved.
//

#import "searchItemsDisplayViewController.h"
#import "ServiceManager.h"
#import "Utilities.h"
#import "Constants.h"
#import "searchItemsTableViewCell.h"
#import "SWRevealViewController.h"
#import "UIImageView+WebCache.h"
#import "RestaurantsMenuViewController.h"
#import "LcnManager.h"

@interface searchItemsDisplayViewController ()<ServiceHandlerDelegate,UISearchResultsUpdating,UISearchBarDelegate>
{
    NSMutableArray *totalSearchArray,* beforeSearchTitlesArray;
    NSMutableArray * searchImages;
    NSString * imageString,*searchTrending;
    NSMutableArray * filteredArray;
    BOOL * isSearching;
}

@end

@implementation searchItemsDisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    SWRevealViewController *revealController = [self revealViewController];
    
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    //Search Controller & Search Bar decalration and delegates
    self.searchController=[[UISearchController alloc]initWithSearchResultsController:nil];
    self.searchTableView.tableHeaderView=self.searchController.searchBar;
    self.searchController.searchResultsUpdater=self;
    self.searchController.searchBar.delegate=self;
    //----------end of declaring search--------------
    
    
    filteredArray = [[NSMutableArray alloc]init];
    
    
    self.searchController.hidesNavigationBarDuringPresentation = false;
    self.searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
   
    
    
    ////////////////// ///////////////// this is to add buttons in navigation /////////////////////////////////////
    NSMutableArray *arrLeftBarItems = [[NSMutableArray alloc] init];
    UIButton *btnLib1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnLib1 setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    btnLib1.frame = CGRectMake(0, 0, 22, 22);
    btnLib1.showsTouchWhenHighlighted=YES;
    UIBarButtonItem *barButtonItem2 = [[UIBarButtonItem alloc] initWithCustomView:btnLib1];
    [arrLeftBarItems addObject:barButtonItem2];
    [btnLib1 addTarget:self action:@selector(Back_Click:) forControlEvents:UIControlEventTouchUpInside];
    
    NSLayoutConstraint * widthConstraint = [btnLib1.widthAnchor constraintEqualToConstant:30];
    NSLayoutConstraint * HeightConstraint =[btnLib1.heightAnchor constraintEqualToConstant:30];
    [widthConstraint setActive:YES];
    [HeightConstraint setActive:YES];
    
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, 420, 22)];
    statusBarView.backgroundColor = BGNavigationCOLOR;
    [self.navigationController.navigationBar addSubview:statusBarView];
    //////////////////end of navigation button declaration /////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    _searchTableView.delegate = self;
    _searchTableView.dataSource = self;
    
    //totalSearchArray = [[NSMutableArray alloc]initWithObjects:@"Satay Chicken",@"Chicken",@"Chapati",@"Chocolate",@"Mutton Chops",@"Samosa",@"Dosa",@"Masala Dosa",@"Pizza", nil];
    
    searchImages =[[NSMutableArray alloc]init];
    
    self.searchController.searchBar.text = _searchTrendingString;
    
//    [self searchServiceCall];
    [_searchTableView reloadData];
    
    ///////////////////////////////////////////////////////////////////////////////////////////
    // this is to dispalay left navigation barButtonItem (back button)
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.leftBarButtonItems = arrLeftBarItems;
    /////////////////////////////////////////////////////////
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)searchServiceCall
{
    if ([Utilities isInternetConnectionExists])
    {
        
        
        //loading UI Starting on mainThread
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
        });
        
        NSDictionary *requestDict;
        
        NSString* strLatitude = [NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:@"selectedlat"]];
        NSString* strLongitude = [NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:@"selectedlong"]];
        if (![[Utilities null_ValidationString:strLatitude] isEqualToString:@""])
        {
            strLatitude = [NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:@"selectedlat"]];
            strLongitude = [NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:@"selectedlong"]];
            
            
        }
        else
        {
            strLatitude = [NSString stringWithFormat:@"%f",[[LcnManager sharedManager]locationManager].location.coordinate.latitude];
            strLongitude = [NSString stringWithFormat:@"%f", [[LcnManager sharedManager]locationManager].location.coordinate.longitude];
            
            
        }
        

        
        
        //Request URL
        NSString *urlStr = [NSString stringWithFormat:@"%@search",BASEURL];
        //parameters
        
        
            requestDict = @{
                            @"search_info":_searchTrendingString,
                            @"latitude":strLatitude ,
                            @"longitude":strLongitude
                            
                            };
        
        
        //Running Request in background thread
        dispatch_async(dispatch_get_main_queue(), ^{

            
            ServiceManager *service = [ServiceManager sharedInstance];
            
            service.delegate = self;
            [service  handleRequestWithDelegates:urlStr info:requestDict];
            
        });
        
    }
    else
    {
        [Utilities displayCustemAlertViewWithOutImage:@"Internet connection error" :self.view];
    }
    
    
}

# pragma mark - Webservice Delegates

- (void)responseDic:(NSDictionary *)info
{
    [self handleResponse:info];
}
- (void)failResponse:(NSError*)error
{
    ////@"Error");
    dispatch_async(dispatch_get_main_queue(), ^{
        [Utilities removeLoading:self.view];
        
    });
}
-(void)handleResponse :(NSDictionary *)responseInfo
{
    NSLog(@"responseInfo :::%@",responseInfo);
    @try {
        if([[responseInfo valueForKey:@"status"] intValue] == 1)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                totalSearchArray = [responseInfo objectForKey:@"result"];
                [_searchTableView reloadData];
                
            });
            
        }
        
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *str = [NSString stringWithFormat:@"%@",[responseInfo valueForKey:@"result"]];
                [Utilities displayCustemAlertViewWithOutImage:str :self.view];
            });
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities removeLoading:self.view];
        });
        
    }
    
    @catch (NSException *exception) {
        
    }
    @finally {
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities removeLoading:self.view];
        });
        [self.view endEditing:YES];
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"SearchCell";
    
        
        searchItemsTableViewCell *cell = (searchItemsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[searchItemsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        }
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    searchImages  = [[totalSearchArray objectAtIndex:indexPath.row] objectForKey:@"logo"];
    
    //api
   // imageString = [NSString stringWithFormat:@"http://35.240.151.154//uploads/establishment/%@",searchImages];
    
    imageString = [NSString stringWithFormat:@"%@%@",RESTAURENTS_IMAGE_URL,searchImages];
    
    NSLog(@"===image url  == %@",imageString);
    
    NSURL *url = [NSURL URLWithString:imageString];
    [cell.restaurantsImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
    
    cell.restaurantName.text =[[totalSearchArray objectAtIndex:indexPath.row]objectForKey:@"name"];
    cell.restaurantAddress.text = [[totalSearchArray objectAtIndex:indexPath.row]objectForKey:@"address"];
    cell.itemName.text = [[totalSearchArray objectAtIndex:indexPath.row]objectForKey:@"item_name"];
    cell.textLabel.text = @"";
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        return 150;
}
# pragma mark - search delegate method
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController;
{
    [self searchServiceCall];
    //NSPredicate * predicate=[NSPredicate predicateWithFormat:@"SELF contains[c]%@",searchController.searchBar.text];
    // filteredArray=[self.letterAArray filteredArrayUsingPredicate:predicate];
    
    // [self.tableView reloadData];
}

- (void)searchTableList
{
    NSString *searchString = self.searchController.searchBar.text;
    [self searchServiceCall];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    searchBar = self.searchController.searchBar;
    
    [searchBar setShowsCancelButton:NO];
    //Remove all objects first.
    ////[filteredContentList removeAllObjects];
    
    if([searchText length] != 0) {
        //isSearching = YES;
        [searchBar setShowsCancelButton:NO];
        [self searchTableList];
    }
    else {
        //isSearching = NO;
        [searchBar setShowsCancelButton:NO];
    }
    [_searchTableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Cancel clicked");
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Search Clicked");
    [self searchTableList];
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.searchController.searchBar setShowsCancelButton:NO];
    self.searchController.dimsBackgroundDuringPresentation = NO;
}
# pragma mark - end of search delegate method


-(void)Back_Click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
////Table view method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    
        return totalSearchArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.searchController.active)
    {
        
    }
    else
    {
        switch (indexPath.row)
        {
                isSearching = YES;
            case 1:
            {
                searchTrending =@"Chicken";
                self.searchController.searchBar.text = @"Chicken";
                self.searchTableView.reloadData;
                self.searchController.searchBar.canBecomeFirstResponder ;
            }
                break;
                
            case 2:
            {
                searchTrending =@"Satay Chicken";
            }
                break;
            case 3:
            {
                searchTrending =@"Chapati";
            }
                break;
            case 4:
            {
                searchTrending =@"Chocolate";
            }
                break;
            case 5:
            {
                searchTrending =@"Mutton Chops";
            }
                break;
            case 6:
            {
                searchTrending =@"Samosa";
            }
                break;
            case 7:
            {
                searchTrending =@"Dosa";
            }
                break;
            case 8:
            {
                searchTrending =@"Masala Dosa";
            }
                break;
            case 9:
            {
                searchTrending =@"Pizza";
            }
                break;
            default:
                break;
        }
    }
    [self searchServiceCall];
    [self.searchTableView reloadData];
}



@end
