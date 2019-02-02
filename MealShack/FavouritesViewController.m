//
//  FavouritesViewController.m
//  MealShack
//
//  Created by Prasad on 24/07/17.
//  Copyright © 2017 Possibillion. All rights reserved.
//

#import "FavouritesViewController.h"
#import "SWRevealViewController.h"
#import "SideMenuViewController.h"
#import "Constants.h"
#import "Utilities.h"
#import "FavouritesCell.h"
#import "ServiceManager.h"
#import "RestaurantsMenuViewController.h"
#import "UIImageView+WebCache.h"
#import "RestaurantsViewController.h"
#import "LcnManager.h"
#import "UILabel+SOXGlowAnimation.h"

@interface FavouritesViewController ()<ServiceHandlerDelegate,UIAlertViewDelegate>
{
    NSMutableArray *totalFavArray;
    NSDictionary *requestDict,*requestDict1;
    NSMutableArray * favImages;
    NSString *imageString;
    UIAlertView *alertView;
    BOOL isdelete;
    NSString * TerminateStr;
    NSMutableArray * UnavailableImages;
    NSString * UnavailableImgStr;
    NSString * strImg;
    UILabel *noDataLabel ;
    
}
@end
@implementation FavouritesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    totalFavArray =[[NSMutableArray alloc]init];
    favImages = [[NSMutableArray alloc]init];
    UnavailableImages =[[NSMutableArray alloc]init];
    
    self.shimmer1.hidden = NO;
    self.shimmer2.hidden = NO;
    self.shimmer3.hidden = NO;
    self.shimmer4.hidden = NO;
    self.shimmer5.hidden = NO;
    self.shimmer6.hidden = NO;
    self.shimmer7.hidden = NO;
    self.shimmer8.hidden = NO;
    
    self.favouritesTableview.delegate = self;
    self.favouritesTableview.dataSource = self;
    
    // Do any additional setup after loading the view.
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    self.title = @"Favourites";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:[UIFont fontWithName:@"MyriadPro-Semibold" size:18]}];
    UIButton *toggleBtn= [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 50, 35)];
    [toggleBtn.layer addSublayer:[Utilities customToggleButton]];
    [toggleBtn addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftRevealButtonItem = [[UIBarButtonItem alloc]initWithCustomView:toggleBtn];
    UIColor *color1 =  [Utilities getUIColorObjectFromHexString:@"#fd6565" alpha:1];
    
    self.navigationController.navigationBar.barTintColor = color1;
    self.navigationController.navigationBar.translucent = YES;
    self.navigationItem.leftBarButtonItem = leftRevealButtonItem;
    
    [self favServiceCall];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self favServiceCall];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    SWRevealViewController *revealController = [self revealViewController];
    revealController.panGestureRecognizer.enabled = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)favServiceCall
{
    [self.view endEditing:YES];
    if ([Utilities isInternetConnectionExists]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.shimmer1 addGlowEffectWithWidth:80 duration:1.5];
            [self.shimmer2 addGlowEffectWithWidth:80 duration:1.5];
            [self.shimmer3 addGlowEffectWithWidth:80 duration:1.5];
            [self.shimmer4 addGlowEffectWithWidth:80 duration:1.5];
            [self.shimmer5 addGlowEffectWithWidth:80 duration:1.5];
            [self.shimmer6 addGlowEffectWithWidth:80 duration:1.5];
            [self.shimmer7 addGlowEffectWithWidth:80 duration:1.5];
            [self.shimmer8 addGlowEffectWithWidth:80 duration:1.5];
        });
        
        NSString *str = [NSString stringWithFormat:@"%f",[[LcnManager sharedManager]locationManager].location.coordinate.latitude];
        NSString *strlong = [NSString stringWithFormat:@"%f", [[LcnManager sharedManager]locationManager].location.coordinate.longitude];
        
        NSString *urlStr = [NSString stringWithFormat:@"%@user_favourates",BASEURL];
        requestDict = @{
                        @"user_id":[Utilities getUserID],
                        };
        
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
    NSLog(@"responseInfo :%@",responseInfo);
    if([[responseInfo valueForKey:@"status"] intValue] == 1)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [noDataLabel removeFromSuperview];
            
            TerminateStr = [responseInfo objectForKey:@"terminate_status"];
            totalFavArray = [responseInfo objectForKey:@"favourates"];
            [_favouritesTableview reloadData];
        });
    }
    if([[responseInfo valueForKey:@"status"] intValue] == 2)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (isdelete == YES && [[responseInfo valueForKey:@"data"] isEqualToString:@"Deleted successfully"])
            {
                isdelete = NO;
                [totalFavArray removeAllObjects];
                [self favServiceCall];
            }
            else
            {
                [self.favouritesTableview reloadData];
                
                noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
                
                noDataLabel.text = @"No data found";
                noDataLabel.textColor = GrayColor;
                noDataLabel.textAlignment    = NSTextAlignmentCenter;
                [self.view addSubview:noDataLabel];
                
                
            }
        });
    }
    else
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.favouritesTableview reloadData];
            
        });
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _shimmer1.hidden = YES;
        _shimmer2.hidden = YES;
        _shimmer3.hidden = YES;
        _shimmer4.hidden = YES;
        _shimmer5.hidden = YES;
        _shimmer6.hidden = YES;
        _shimmer7.hidden = YES;
        _shimmer8.hidden = YES;
    });
}

////Table view method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger numOfSections = 0;
    
    if ([totalFavArray count] > 0 )
    {
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        numOfSections                = 1;
        tableView.backgroundView = nil;
        
    }
    else
    {
        [Utilities removeLoading:self.view];
        
        UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, tableView.bounds.size.height)];
        //        noDataLabel.text             = @"No Favourites";
        //        noDataLabel.textColor        = GrayColor;
        //        noDataLabel.textAlignment    = NSTextAlignmentCenter;
        //        tableView.backgroundView = noDataLabel;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return numOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return totalFavArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Configure the cell...
    
    static NSString *CellIdentifier = @"FavouritesCell";
    
    FavouritesCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[FavouritesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    NSLog(@"cellForRowAtIndexPath");
    
    if ([totalFavArray  count] > 0)
    {
        
        [Utilities addShadowtoView:cell.bgview];
        
        favImages  = [[totalFavArray objectAtIndex:indexPath.row] objectForKey:@"logo"];
        UnavailableImages  = [Utilities null_ValidationString:[[totalFavArray objectAtIndex:indexPath.row] objectForKey:@"unavailable_image"]];
        
        imageString = [NSString stringWithFormat:@"%@%@",RESTAURENTS_IMAGE_URL,favImages];
        UnavailableImgStr = [NSString stringWithFormat:@"%@%@",RESTAURENTS_IMAGE_URL,UnavailableImages];
        
        NSURL *url = [NSURL URLWithString:imageString];
        
        if ([TerminateStr intValue]==0)
        {
            [cell.favImgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
            
            cell.imgUnavailable.hidden = YES;
            cell.RestUnavailable.hidden = YES;
            cell.userInteractionEnabled = YES;
            
            
            if (![[[totalFavArray objectAtIndex:indexPath.row] objectForKey:@"terminate_status"] intValue]==1)
            {
                
                UnavailableImgStr = [NSString stringWithFormat:@"%@%@",RESTAURENTS_IMAGE_URL,UnavailableImages];
                
                NSURL *url = [NSURL URLWithString:UnavailableImgStr];
                [cell.imgUnavailable sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
                
                cell.imgUnavailable.hidden =  NO;
                cell.RestUnavailable.hidden = NO;
                cell.userInteractionEnabled = NO;
                
                /////for drivers
                UnavailableImgStr =[NSString stringWithFormat:@"%@%@",RESTAURENTS_IMAGE_URL,UnavailableImages];
                
                NSURL *url1 = [NSURL URLWithString:UnavailableImgStr];
                [cell.imgUnavailable sd_setImageWithURL:url1 placeholderImage:[UIImage imageNamed:@""]];
                
                [cell setUserInteractionEnabled:NO];
                cell.RestUnavailable.hidden = NO;
                [cell.imgUnavailable setUserInteractionEnabled:NO];
                
            }
            else
            {
                [cell.favImgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
                cell.imgUnavailable.hidden = YES;
                cell.RestUnavailable.hidden = YES;
                cell.userInteractionEnabled = YES;
                
                // for drivers
                NSString * stringConvertion = [NSString stringWithFormat:@"%d",[[[totalFavArray objectAtIndex:indexPath.row] objectForKey:@"restauant_availability"] intValue]];
                
                if (![stringConvertion intValue] == 1 )
                {
                    
                    UnavailableImgStr = [NSString stringWithFormat:@"%@%@",RESTAURENTS_IMAGE_URL,UnavailableImages];
                    
                    NSURL *url2 = [NSURL URLWithString:UnavailableImgStr];
                    [cell.imgUnavailable sd_setImageWithURL:url2 placeholderImage:[UIImage imageNamed:@""]];
                    
                    cell.imgUnavailable.hidden  = NO;
                    cell.RestUnavailable.hidden = NO;
                    cell.userInteractionEnabled = NO;
                    
                }
                else
                {
                    [cell.favImgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
                    
                    cell.imgUnavailable.hidden =  YES;
                    cell.RestUnavailable.hidden = YES;
                    cell.userInteractionEnabled = YES;
                }
            }
        }
        else
        {
            UnavailableImgStr =[NSString stringWithFormat:@"%@%@",RESTAURENTS_IMAGE_URL,UnavailableImages];
            
            NSURL *url = [NSURL URLWithString:UnavailableImgStr];
            [cell.imgUnavailable sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
            
            cell.imgUnavailable.hidden =  NO;
            cell.RestUnavailable.hidden = NO;
            cell.userInteractionEnabled = NO;
        }
        
        cell.restaurantName.adjustsFontSizeToFitWidth = YES;
        
        cell.cuisinesLabel.text  =[NSString stringWithFormat:@"%@",[Utilities null_ValidationString: [[totalFavArray objectAtIndex:indexPath.row]objectForKey:@"cuisines"]]];
        cell.restaurantName.text = [NSString stringWithFormat:@"%@",[Utilities null_ValidationString:[[totalFavArray objectAtIndex:indexPath.row]objectForKey:@"name"]]];
        cell.restaurantRatingLbl.text = [NSString stringWithFormat:@"%@",[Utilities null_ValidationString:[[totalFavArray objectAtIndex:indexPath.row]objectForKey:@"rating"]]];
        cell.DeliveryMinLabel.text = [NSString stringWithFormat:@"%@mins",[Utilities null_ValidationString:[[totalFavArray objectAtIndex:indexPath.row]objectForKey:@"delivery_time"]]];
        
        strImg = [[totalFavArray objectAtIndex:indexPath.row] objectForKey:@"restaurant_value"];
        
        
        if ([Utilities null_ValidationString:strImg])
        {
            
            if ([strImg isEqualToString:@"1"])
            {
                cell.rupeeRating.image = [UIImage imageNamed:@"3-gray.png"];
            }
            else if ([strImg isEqualToString:@"2"])
            {
                cell.rupeeRating.image = [UIImage imageNamed:@"2-gray.png"];
            }
            //minorder > 501 && minorder < 1000
            else if ([strImg isEqualToString:@"3"])
            {
                cell.rupeeRating.image = [UIImage imageNamed:@"1-gray.png"];
            }
            //minorder > 1000
            else if ([strImg isEqualToString:@"4"])
            {
                cell.rupeeRating.image = [UIImage imageNamed:@"rfourr.png"];
            }
        }
        cell.DeleteButton.tag=indexPath.row;
        
        [cell.DeleteButton addTarget:self action:@selector(DeleteButton_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
    
}

#pragma mark - Tableview delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RestaurantsMenuViewController * Menu = [storyboard instantiateViewControllerWithIdentifier:@"RestaurantsMenuViewController"];
    Menu.establishment_idStr =[[totalFavArray objectAtIndex:indexPath.row] objectForKey:@"establishment_id"];
    [self.navigationController pushViewController:Menu animated:YES];
    
}

- (IBAction)DeleteButton_Clicked:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@""message:@"Are you sure you want to remove from your favourite?"preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* noButton = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
    }];
    
    UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        
        [self.view endEditing:YES];
        NSString *strid = [NSString stringWithFormat:@"%@",[[totalFavArray objectAtIndex:btn.tag] valueForKey:@"establishment_id"]];
        
        if ([Utilities isInternetConnectionExists]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                // [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
            });
            isdelete = YES;
            NSString *urlStr = [NSString stringWithFormat:@"%@addfavourates",BASEURL];
            requestDict = @{
                            @"user_id":[NSString stringWithFormat:@"%@",[Utilities getUserID]],
                            @"restaurant_id":strid,
                            @"type":@"2"
                            };
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
    }];
    [alertController addAction:noButton];
    [alertController addAction:yesButton];
    [self presentViewController:alertController animated:YES completion:nil];
}
@end

