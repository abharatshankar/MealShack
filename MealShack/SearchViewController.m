//
// SearchViewController.m
//  MealShack
//
//  Created by Prasad on 27/07/17.
//  Copyright © 2017 Possibillion. All rights reserved.
//
#define ACCEPTABLE_CHARECTERS @" ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_."
#import "SearchViewController.h"
#import "ServiceManager.h"
#import "Utilities.h"
#import "Constants.h"
#import "SearchCell.h"
#import "SWRevealViewController.h"
#import "UIImageView+WebCache.h"
#import "searchItemsDisplayViewController.h"
#import "LcnManager.h"
#import "RestaurantsMenuViewController.h"
#import "ISMessages.h"

@interface SearchViewController ()<ServiceHandlerDelegate,UISearchResultsUpdating,UISearchBarDelegate>
{
    NSMutableArray *totalSearchArray,* beforeSearchTitlesArray;
    NSMutableArray * searchImages;
    NSString * imageString,*searchTrending;
    NSMutableArray * filteredArray;
    BOOL * isSearching,* isSearchCancel;
    NSMutableArray * UnavailableImages;
    NSString * UnavailableImgStr;
    NSString * TerminateStr;
}

@end

@implementation SearchViewController

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
    self.definesPresentationContext = NO;
    self.searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    beforeSearchTitlesArray = [[NSMutableArray alloc]init];
    //this array is for default titles displayed in normal tableview cell
//    beforeSearchTitlesArray= [[NSMutableArray alloc]initWithObjects:@"Trending",
//                              @"Chicken",
//                              @"Satay Chicken",
//                              @"Chapati",
//                              @"Chocolate",
//                              @"Mutton chops",
//                              @"Samosa",
//                              @"Dosa",
//                              @"Masala Dosa",
//                              @"Pizza",
//                              nil];
    
    
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
    statusBarView.backgroundColor = CLEARCOLOR;
    [self.navigationController.navigationBar addSubview:statusBarView];
                    //////////////////end of navigation button declaration /////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.leftBarButtonItems = arrLeftBarItems;

    
    _searchTableView.delegate = self;
    _searchTableView.dataSource = self;
    
    
    searchImages =[[NSMutableArray alloc]init];
    UnavailableImages = [[NSMutableArray alloc]init];
    
     [self TrendinglistService];
    
    
    
    ///////////////////////////////////////////////////////////////////////////////////////////
    // this is to dispalay left navigation barButtonItem (back button)
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
//                                                  forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [UIImage new];
//    self.navigationController.navigationBar.translucent = NO;
//    self.navigationItem.leftBarButtonItems = arrLeftBarItems;
    
//    self.navigationController.navigationBar.tintColor = WHITECOLOR;
//    self.navigationController.navigationBar.barTintColor = REDCOLOR;
//    self.navigationController.navigationBar.translucent = YES;
//    self.navigationItem.leftBarButtonItems = arrLeftBarItems;

    /////////////////////////////////////////////////////////

}
-(void)viewWillAppear:(BOOL)animated
{
    _searchController.searchBar.hidden =NO;
    
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    _searchController.searchBar.hidden =YES;
    _searchController.searchBar.text = nil;
   
   
    
}



-(void)TrendinglistService
{
    NSString *StrUrl = [NSString stringWithFormat:@"%@trendingItems",BASEURL];
    
    NSLog(@"StrUrl:%@",StrUrl);
    
    // NSMutableURLRequest *request =[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:str_country]];
    NSMutableURLRequest*request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:StrUrl] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    
    StrUrl = nil;
    NSData *returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil ];
    request=nil;
    NSString *returnString = [[NSString alloc]initWithData:returnData encoding:NSUTF8StringEncoding];
    
    NSLog(@"returnString:%@",returnString);
    if (returnString==nil || returnString==NULL || [returnString isEqualToString:@""] || [returnString isEqual:nil]) {
        NSLog(@"Network Not Reachable");
    }
    else{
        returnString=nil;
        
        NSError *jsonError;
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:returnData
                                                             options:kNilOptions
                                                               error:&jsonError];
        NSLog(@"Dict value:%@",dict);
        
        if (dict==nil||dict==NULL)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"No Response From Server" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
        }
        
        
        else {
            // NSDictionary *create_result_dict;
            NSString *statuscode;
            NSString *message;
            
            statuscode = [dict objectForKey:@"status"];
            message = [dict objectForKey:@"result"];
            NSLog(@"info:%@",[dict objectForKey:@"items"]);
            int status = [statuscode intValue];
            if (status==1){
                
                beforeSearchTitlesArray = [dict objectForKey:@"items"];
            
                
            }
            else if (status==2&&([message isEqualToString:@"Email and Password Authentication Error."]||[message isEqualToString:@"This customer email already exists"])){
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }
    }
    

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isSearching == NO)
    {
        return 50;
    }
    else
        return 150;
}
# pragma mark - search delegate method
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController;
{
    //[self searchServiceCall];
    
    
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
        isSearching = YES;
        [searchBar setShowsCancelButton:NO];
        [self searchTableList];
    }
    else {
       // isSearching = NO;
        [searchBar setShowsCancelButton:YES];
        [self searchTableList];
        
       

    }
   
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
   // isSearching = NO;
    
    ////edited g3
    isSearching = YES;
    isSearchCancel = YES;
    
    [_searchTableView reloadData];
    
    NSLog(@"Cancel clicked");
   
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Search Clicked");
    
//    [self searchTableList];
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
//    [self.searchController.searchBar setShowsCancelButton:NO];
    self.searchController.dimsBackgroundDuringPresentation = NO;
//    
//    if([searchText length] != 0) {
//        //isSearching = YES;
//        [searchBar setShowsCancelButton:NO];
//        [self searchTableList];
//    }
//    else {
//        //isSearching = NO;
//        [searchBar setShowsCancelButton:NO];
//    }
//    [_searchTableView reloadData];
    
    
}
# pragma mark - end of search delegate method


-(void)Back_Click:(id)sender
{
    if (self.searchController.searchBar.text.length>0 || self.searchController.isActive == YES) {
        [ISMessages showCardAlertWithTitle:nil
                                   message:@"Please Clear Search"
                                  duration:2.f
                               hideOnSwipe:YES
                                 hideOnTap:YES
                                 alertType:ISAlertTypeInfo
                             alertPosition:ISAlertPositionTop
                                   didHide:^(BOOL finished) {
                                       NSLog(@"Alert did hide.");
                                       
                                       [Utilities removeLoading:self.view];
                                       //[ activityIndicatorView stopAnimating];
                                       
                                   }];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////Table view method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger numOfSections = 0;
    
  
    
    if ([totalSearchArray count] > 0  || [beforeSearchTitlesArray count] > 0 )
    {
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        numOfSections                = 1;
        tableView.backgroundView = nil;
    }
    
    else
    {
        
        [Utilities removeLoading:self.view];
        
        UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, tableView.bounds.size.height)];
        noDataLabel.text             = @"No data found";
        noDataLabel.textColor        = GrayColor;
        noDataLabel.textAlignment    = NSTextAlignmentCenter;
        tableView.backgroundView = noDataLabel;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return numOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isSearching == YES )
    {
        isSearchCancel = NO;
        return totalSearchArray.count;
    }
    else
    {
        if (self.searchController.searchBar.text.length==0 && isSearchCancel == YES)
        {
            
            NSLog(@"beforeSearchTitlesArray called");
            
          
            return beforeSearchTitlesArray.count;
        }
        else
            return beforeSearchTitlesArray.count;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
     searchTrending = [[beforeSearchTitlesArray objectAtIndex:indexPath.row]objectForKey:@"item_name"];
    
////    switch (indexPath.row)
////    {
////        case 1:
////        {
////        searchTrending =@"Chicken";
////            
////        }
////            break;
////            
////        case 2:
////        {
////            searchTrending =@"Satay Chicken";
////        }
////            break;
////        case 3:
////        {
////             searchTrending =@"Chapati";
////           
////        }
////            break;
////        case 4:
////        {
////             searchTrending =@"Chocolate";
////        }
////            break;
////        case 5:
////        {
////             searchTrending =@"Mutton Chops";
////           
////        }
//            break;
//        case 6:
//        {
//             searchTrending =@"Samosa";
//           
//        }
//            break;
//        case 7:
//        {
//             searchTrending =@"Dosa";
//          
//        }
//            break;
//        case 8:
//        {
//             searchTrending =@"Masala Dosa";
//          
//        }
//            break;
//        case 9:
//        {
//            searchTrending =@"Pizza";
//          
//        }
//            break;
//        default:
//            break;
//    }
    
     isSearching = YES;
    
    NSString *strcheck;
    if (isSearchCancel == NO) {
        
        strcheck = [[totalSearchArray objectAtIndex:indexPath.row] objectForKey:@"establishment_id"];
    }
    

    
    if([[Utilities null_ValidationString:strcheck] isEqualToString:@""])
    {
        [self searchServiceCall];
    }
    else
    {
         dispatch_async(dispatch_get_main_queue(), ^{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        RestaurantsMenuViewController * Menu = [storyboard instantiateViewControllerWithIdentifier:@"RestaurantsMenuViewController"];
    Menu.establishment_idStr =[[totalSearchArray objectAtIndex:indexPath.row] objectForKey:@"establishment_id"];
        [_searchController.searchBar resignFirstResponder];
        [self.navigationController pushViewController:Menu animated:YES];
             
         });
        

    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"SearchCell";
    
    
    if (isSearching == YES)
    {
        
        SearchCell *cell = (SearchCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[SearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        }
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        cell.bgview.hidden = NO;
       
        searchImages  = [[totalSearchArray objectAtIndex:indexPath.row] objectForKey:@"logo"];
        UnavailableImages  = [[totalSearchArray objectAtIndex:indexPath.row] objectForKey:@"unavailable_image"];
        
        imageString = [NSString stringWithFormat:@"%@%@",RESTAURENTS_IMAGE_URL,searchImages];
        
        UnavailableImgStr = [NSString stringWithFormat:@"%@%@",RESTAURENTS_IMAGE_URL,UnavailableImages];
        
        NSLog(@"===image url  == %@",imageString);
        
        NSURL *url = [NSURL URLWithString:imageString];
        [cell.restaurantImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
        
        
        
        if ([TerminateStr intValue] == 0)
        {
            [cell.restaurantImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
            
            cell.imgUnavailable.hidden = YES;
            cell.restUnavailable.hidden = YES;
            cell.userInteractionEnabled = YES;
            
            
            if (![[[totalSearchArray objectAtIndex:indexPath.row] objectForKey:@"terminate_status"] intValue] == 1)
            {
                
                
                UnavailableImgStr = [NSString stringWithFormat:@"%@%@",RESTAURENTS_IMAGE_URL,UnavailableImages];
                
                NSLog(@"===image url  == %@",UnavailableImgStr);
                
                NSURL *url = [NSURL URLWithString:UnavailableImgStr];
                [cell.imgUnavailable sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
                
                
                cell.imgUnavailable.hidden = NO;
                cell.restUnavailable.hidden = NO;
                cell.userInteractionEnabled = NO;
                
                
                /////for drivers
                UnavailableImgStr = [NSString stringWithFormat:@"%@%@",RESTAURENTS_IMAGE_URL,UnavailableImages];
                
                NSLog(@"===image url  == %@",UnavailableImgStr);
                
                NSURL *url1 = [NSURL URLWithString:UnavailableImgStr];
                [cell.imgUnavailable sd_setImageWithURL:url1 placeholderImage:[UIImage imageNamed:@""]];
                
                [cell setUserInteractionEnabled:NO];
                cell.restUnavailable.hidden = NO;
                [cell.imgUnavailable setUserInteractionEnabled:NO];
                
            }
            else
            {
                [cell.restaurantImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
                cell.imgUnavailable.hidden = YES;
                cell.restUnavailable.hidden = YES;
                cell.userInteractionEnabled = YES;
                
                // for drivers
                NSString * stringConvertion = [NSString stringWithFormat:@"%d",[[[totalSearchArray objectAtIndex:indexPath.row] objectForKey:@"restauant_availability"] intValue]];
                
                if (![stringConvertion intValue] == 1 )
                {
                    
                    UnavailableImgStr = [NSString stringWithFormat:@"%@%@",RESTAURENTS_IMAGE_URL,UnavailableImages];
                    
                    NSLog(@"===image url  == %@",UnavailableImgStr);
                    
                    NSURL *url2 = [NSURL URLWithString:UnavailableImgStr];
                    [cell.imgUnavailable sd_setImageWithURL:url2 placeholderImage:[UIImage imageNamed:@""]];
                    
                    
                    
                    cell.imgUnavailable.hidden = NO;
                    cell.restUnavailable.hidden = NO;
                    cell.userInteractionEnabled = NO;
                    
                    
                    
                }
                else
                {
                    [cell.restaurantImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
                    
                    cell.imgUnavailable.hidden = YES;
                    cell.restUnavailable.hidden = YES;
                    cell.userInteractionEnabled = YES;
                    
                    
                }
                
                
            }

        }
        else
        {
            UnavailableImgStr =[NSString stringWithFormat:@"%@%@",RESTAURENTS_IMAGE_URL,UnavailableImages];
            
            NSLog(@"===image url  == %@",UnavailableImgStr);
            
            NSURL *url = [NSURL URLWithString:UnavailableImgStr];
            [cell.imgUnavailable sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
            
            
            cell.imgUnavailable.hidden = NO;
            cell.restUnavailable.hidden = NO;
            cell.userInteractionEnabled = NO;
            
 
        }
        
        
        
        
    cell.restaurantName.text =[[totalSearchArray objectAtIndex:indexPath.row]objectForKey:@"name"];
    cell.resaturantAddress.text = [[totalSearchArray objectAtIndex:indexPath.row]objectForKey:@"address"];
    cell.itemName.text = [[totalSearchArray objectAtIndex:indexPath.row]objectForKey:@"item_name"];
    cell.textLabel.text = @"";
    [Utilities setBorderView:cell.bgview :5 :LIGHTGRYCOLOR];

        
         return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.textLabel.text = [[beforeSearchTitlesArray objectAtIndex:indexPath.row]objectForKey:@"item_name"];
        
        
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:17];
        cell.textLabel.textColor = REDCOLOR;
        

//        if (indexPath.row == 0)
//        {
//           cell.textLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:17];
//            cell.textLabel.textColor = [UIColor blackColor];
////            cell.userInteractionEnabled = NO;
//        }
        
         return cell;
    }
    
    
    
    
   
    
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
        
        if (searchTrending!= nil)
        {
            requestDict = @{
                            @"search_info":searchTrending,
                            @"latitude":strLatitude ,
                            @"longitude":strLongitude
                            
                            };
        }
  
            else{
                requestDict = @{
                                @"search_info":self.searchController.searchBar.text,
                                    //self.searchController.searchBar.text,
                                @"latitude":strLatitude,
                                @"longitude":strLongitude
                                
                                };
                
                
            }
      //  }
    //Running Request in background thread
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
           
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
                
               
                TerminateStr = [responseInfo objectForKey:@"terminate_status"];
                totalSearchArray = [responseInfo objectForKey:@"result"];
                
                [_searchTableView reloadData];
                
                

            });
            
        }
       else if([[responseInfo valueForKey:@"status"] intValue] == 2)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [totalSearchArray removeAllObjects];
               
                [_searchTableView reloadData];
            });

            
           
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *str = [NSString stringWithFormat:@"%@",[responseInfo valueForKey:@"response"]];
                //[Utilities displayCustemAlertViewWithOutImage:str :self.view];
               // [_searchController.searchBar resignFirstResponder];
                [_searchTableView reloadData];
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




@end
