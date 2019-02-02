//
//  OffersViewController.m
//  MealShack
//
//  Created by Prasad on 24/07/17.
//  Copyright © 2017 Possibillion. All rights reserved.
//

#import "OffersViewController.h"
#import "SWRevealViewController.h"
#import "SideMenuViewController.h"
#import "Constants.h"
#import "Utilities.h"
#import "OffersCell.h"
#import "ServiceManager.h"
#import "UIImageView+WebCache.h"
#import "RestaurantsMenuViewController.h"
#import "LcnManager.h"


@interface OffersViewController ()<ServiceHandlerDelegate>
{
    NSMutableArray *totalOffersArray;
    NSDictionary *requestDict;
    NSMutableArray * offerImages;
    NSString *imageString;
 NSMutableDictionary * totalDic;
    NSString * UnavailableImgStr;
    NSMutableArray * UnavailableImages;
    NSString * TerminateStr;
    
}

@end

@implementation OffersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    totalOffersArray = [[NSMutableArray alloc]init];
    offerImages = [[NSMutableArray alloc]init];
    totalDic= [[NSMutableDictionary alloc]init];
    UnavailableImages = [[NSMutableArray alloc]init];
   
    
    
    // Do any additional setup after loading the view.
    
    _offersTableView.delegate = self;
    _offersTableView.dataSource = self;

    
    SWRevealViewController *revealController = [self revealViewController];
    
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    
    self.title = @"Offers";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:[UIFont fontWithName:@"MyriadPro-Semibold" size:18]}];
    
    
    
    UIButton *toggleBtn= [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 50, 35)];
    [toggleBtn.layer addSublayer:[Utilities customToggleButton]];
    [toggleBtn addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftRevealButtonItem = [[UIBarButtonItem alloc]initWithCustomView:toggleBtn];
    
    
    
    self.navigationController.navigationBar.tintColor = WHITECOLOR;
    UIColor *color1 =  [Utilities getUIColorObjectFromHexString:@"#fd6565" alpha:1];

    self.navigationController.navigationBar.barTintColor = color1;
    self.navigationController.navigationBar.translucent = YES;
    self.navigationItem.leftBarButtonItem = leftRevealButtonItem;
    
    [self OffersService];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)OffersService
{
    [self.view endEditing:YES];
    
    if ([Utilities isInternetConnectionExists]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
        });
        
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
       
        
        NSString *urlStr = [NSString stringWithFormat:@"%@offers",BASEURL];
        requestDict = @{
                        @"user_id":[Utilities getUserID],
                        @"latitude":strLatitude,
                        @"longitude":strLongitude
                        
                        };
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            ServiceManager *service = [ServiceManager sharedInstance];
            service.delegate = self;
            
            
            [service  handleRequestWithDelegates:urlStr info:requestDict];
            // [self uploadImagetoServer:urlStr];
            
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
    
    NSLog(@"responseInfo :%@",responseInfo);
    
    if([[responseInfo valueForKey:@"status"] intValue] == 1)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
        
            
        TerminateStr = [responseInfo objectForKey:@"terminate_status"];
        totalOffersArray = [responseInfo objectForKey:@"data"];
       
        [_offersTableView reloadData];
       
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
    
   // [_offersTableView reloadData];
    
}


-(void)viewWillAppear:(BOOL)animated {
    
    
    SWRevealViewController *revealController = [self revealViewController];
    
    revealController.panGestureRecognizer.enabled = YES;
    [self.navigationController setNavigationBarHidden:NO animated:YES];

}
    
    
    

////Table view method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return totalOffersArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell...
    
    static NSString *CellIdentifier = @"OffersCell";
    
    OffersCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[OffersCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    NSLog(@"cellForRowAtIndexPath");
    [Utilities addShadowtoView:cell.bgview];

    offerImages  = [[totalOffersArray objectAtIndex:indexPath.row] objectForKey:@"image"];
    UnavailableImages  = [[totalOffersArray objectAtIndex:indexPath.row] objectForKey:@"unavailable_image"];

    imageString = [NSString stringWithFormat:@"%@%@",OFFERS_IMAGE_URL,offerImages];
    UnavailableImgStr =[NSString stringWithFormat:@"%@%@",RESTAURENTS_IMAGE_URL,UnavailableImages];

    
    NSLog(@"===image url  == %@",imageString);
    
    NSURL *url = [NSURL URLWithString:imageString];
    //[cell.offersImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
    
    
     if ([TerminateStr isEqualToString:@"0"])
     {
         [cell.offersImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
         cell.ImgUnavailable.hidden = YES;
         cell.LblUnvailable.hidden = YES;
         cell.userInteractionEnabled = YES;
         
         if (![[[totalOffersArray objectAtIndex:indexPath.row] objectForKey:@"terminate_status"] isEqualToString:@"1"])
         {
             
             
             UnavailableImgStr =[NSString stringWithFormat:@"%@%@",RESTAURENTS_IMAGE_URL,UnavailableImages];
             
             NSLog(@"===image url  == %@",UnavailableImgStr);
             
             NSURL *url = [NSURL URLWithString:UnavailableImgStr];
             [cell.ImgUnavailable sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
             
             
             cell.ImgUnavailable.hidden = NO;
             cell.LblUnvailable.hidden = NO;
             cell.userInteractionEnabled = NO;
             
             
             /////for drivers
             UnavailableImgStr = [NSString stringWithFormat:@"%@%@",RESTAURENTS_IMAGE_URL,UnavailableImages];
             
             NSLog(@"===image url  == %@",UnavailableImgStr);
             
             NSURL *url1 = [NSURL URLWithString:UnavailableImgStr];
             [cell.ImgUnavailable sd_setImageWithURL:url1 placeholderImage:[UIImage imageNamed:@""]];
             
             [cell setUserInteractionEnabled:NO];
             cell.LblUnvailable.hidden = NO;
             [cell.ImgUnavailable setUserInteractionEnabled:NO];
             
         }
         else
         {
             [cell.offersImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
             cell.ImgUnavailable.hidden = YES;
             cell.LblUnvailable.hidden = YES;
             cell.userInteractionEnabled = YES;
             
             // for drivers
             NSString * stringConvertion = [NSString stringWithFormat:@"%d",[[[totalOffersArray objectAtIndex:indexPath.row] objectForKey:@"restauant_availability"] intValue]];
             
             if (![stringConvertion intValue] == 1 )
             {
                 
                 UnavailableImgStr = [NSString stringWithFormat:@"%@%@",RESTAURENTS_IMAGE_URL,UnavailableImages];
                 
                 NSLog(@"===image url  == %@",UnavailableImgStr);
                 
                 NSURL *url2 = [NSURL URLWithString:UnavailableImgStr];
                 [cell.ImgUnavailable sd_setImageWithURL:url2 placeholderImage:[UIImage imageNamed:@""]];
                 
                 
                 
                 [cell setUserInteractionEnabled:NO];
                 cell.ImgUnavailable.hidden = NO;
                 cell.LblUnvailable.hidden = NO;
                 cell.userInteractionEnabled = NO;
                 
                 
                 
                 
             }
             else
             {
                 [cell.offersImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
                 
                 cell.ImgUnavailable.hidden = YES;
                 cell.LblUnvailable.hidden = YES;
                 cell.userInteractionEnabled = YES;
                 
                 
             }
             
             
         }

     }
    else
    {
        UnavailableImgStr =[NSString stringWithFormat:@"%@%@",RESTAURENTS_IMAGE_URL,UnavailableImages];
        
        NSLog(@"===image url  == %@",UnavailableImgStr);
        
        NSURL *url = [NSURL URLWithString:UnavailableImgStr];
        [cell.ImgUnavailable sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
        
        
        cell.ImgUnavailable.hidden = NO;
        cell.LblUnvailable.hidden = NO;
        cell.userInteractionEnabled = NO;
    }
    
   
    
    cell.OffLabel.text =[[totalOffersArray objectAtIndex:indexPath.row]objectForKey:@"offer_name"];
    cell.offers_restaurantName.text = [[totalOffersArray objectAtIndex:indexPath.row]objectForKey:@"name"];    return cell;
    
}

#pragma mark - Tableview delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RestaurantsMenuViewController * Menu = [storyboard instantiateViewControllerWithIdentifier:@"RestaurantsMenuViewController"];
    Menu.establishment_idStr =[[totalOffersArray objectAtIndex:indexPath.row] objectForKey:@"establishment_id"];
    [self.navigationController pushViewController:Menu animated:YES];
    

}

@end
