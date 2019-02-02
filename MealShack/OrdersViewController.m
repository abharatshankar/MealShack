//
//  OrdersViewController.m
//  MealShack
//
//  Created by Prasad on 24/07/17.
//  Copyright © 2017 Possibillion. All rights reserved.
//

#import "OrdersViewController.h"
#import "SWRevealViewController.h"
#import "SideMenuViewController.h"
#import "Constants.h"
#import "Utilities.h"
#import "OrdersCell.h"
#import "ServiceManager.h"
#import "OrderSummaryViewController.h"
#import "ReviewOrderViewController.h"
#import "SingleTon.h"
#import "UILabel+SOXGlowAnimation.h"



@interface OrdersViewController ()<ServiceHandlerDelegate>
{
    NSMutableArray * totalOrdersArray ,*arrcartItems;
    NSDictionary *requestDict;
   // NSMutableArray *arritem;
     NSMutableArray *arrOrder,*arrItem;
     NSArray *arrTemp;
    NSString *strItemName,*strPrice,*strQuantity;
     NSInteger variantTag;
    SingleTon * singleToninstance;
    NSMutableArray*reOrderArr;
    NSDictionary * totaldict;
    BOOL  isOrders,isgetcart, isDelete;
    NSString *establishmentString, * OrderID;
    NSMutableArray * arrReorder;
    
    NSString * StrGrand , *strWallet;
    int grand, wallet;
}

@end

@implementation OrdersViewController
@synthesize OrdersTableView;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    _ordershimmer1.hidden = NO;
    _ordershimmer2.hidden = NO;
    _ordershimmer3.hidden = NO;
    
    
    self.OrdersTableView.hidden  = YES;
    
     singleToninstance = [SingleTon singleTonMethod];
     arrOrder=[[NSMutableArray alloc]init];
    arrcartItems = [[NSMutableArray alloc]init];
    
    totalOrdersArray = [[NSMutableArray alloc]init];
    arrItem=[[NSMutableArray alloc]init];
    
    
  
    
    OrdersTableView.delegate = self;
    OrdersTableView.dataSource = self;

    
    SWRevealViewController *revealController = [self revealViewController];
    
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    self.title = @"Previous Orders";
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
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
     isOrders = NO;
     dispatch_async(dispatch_get_main_queue(), ^{
     [self OrdersService];
         
    //  [self GetCartServiceCall];

     });
   
   
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
    
    SWRevealViewController *revealController = [self revealViewController];
    
    revealController.panGestureRecognizer.enabled = YES;
}




-(void)OrdersService
{
    [self.view endEditing:YES];
    
    if ([Utilities isInternetConnectionExists]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.ordershimmer1 addGlowEffectWithWidth:80 duration:1.5];
            [self.ordershimmer2 addGlowEffectWithWidth:80 duration:1.5];
            [self.ordershimmer3 addGlowEffectWithWidth:80 duration:1.5];

            
        });
        
        
        NSString *urlStr = [NSString stringWithFormat:@"%@user_order_history",BASEURL];
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
  
    
    
           if (isOrders == YES)
           {
            
               if([[responseInfo valueForKey:@"status"] intValue] == 1)
                {
                dispatch_async(dispatch_get_main_queue(), ^{

              reOrderArr = [[NSMutableArray alloc]init];
               reOrderArr = [responseInfo valueForKey:@"items_list"];
                    
                    arrReorder = [[NSMutableArray alloc]init];
                    arrReorder = [responseInfo valueForKey:@"wallet_amount"];
                    
               totaldict = responseInfo;
               
               
               singleToninstance.isFromOrders = YES;
               
               
               UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
               ReviewOrderViewController * review = [storyboard instantiateViewControllerWithIdentifier:@"ReviewOrderViewController"];
                review.dicttotal = totaldict ;
               
               [self.navigationController pushViewController:review animated:YES];
                              
                    });
                 }
             
               
               
           }
           else if(isgetcart == YES)
           {
               isgetcart = NO;
               
               if([[responseInfo valueForKey:@"status"] intValue] == 1)
               {
                   dispatch_async(dispatch_get_main_queue(), ^{
                       
                       [self.ordershimmer1 addGlowEffectWithWidth:80 duration:1.5];
                       [self.ordershimmer2 addGlowEffectWithWidth:80 duration:1.5];
                       [self.ordershimmer3 addGlowEffectWithWidth:80 duration:1.5];

                    
                       arrcartItems = [responseInfo valueForKey:@"cart_items"];
                       establishmentString = [[arrcartItems objectAtIndex:0] valueForKey:@"establishment_id"];
                       NSLog(@"GET CART responseInfo :%@",responseInfo);
                       
                       
                   });
               }
                else if ([[responseInfo valueForKey:@"status"] intValue] == 2)
                {
                    
                }

           }
    
           else if (isDelete == YES)
           {
               isDelete = NO;
                dispatch_async(dispatch_get_main_queue(), ^{
               [USERDEFAULTS removeObjectForKey:@"seltctedRestLat"];
               [USERDEFAULTS removeObjectForKey:@"seltctedRestLong"];
               [USERDEFAULTS removeObjectForKey:@"seltctedRestGST"];
               [USERDEFAULTS removeObjectForKey:@"establishment_id"];
               
              [self reorderServiceCall];
                });
           }
           
           else if ([[responseInfo valueForKey:@"status"] intValue] == 1)
           {
               
            dispatch_async(dispatch_get_main_queue(), ^{
                
                _ordershimmer1.hidden = YES;
                _ordershimmer2.hidden = YES;
                _ordershimmer3.hidden = YES;
                
                self.OrdersTableView.hidden  = NO;
            singleToninstance.isFromOrders = NO;
            totalOrdersArray = [responseInfo objectForKey:@"order_info"];
            arrItem = [responseInfo valueForKeyPath:@"order_info.items"];
                
                
             
              [OrdersTableView reloadData];
                [self GetCartServiceCall];
                
            });
            
           }
    
            else if ([[responseInfo valueForKey:@"status"] intValue] == 2)
            {
                   dispatch_async(dispatch_get_main_queue(), ^{
                       NSString *str = [NSString stringWithFormat:@"%@",[responseInfo valueForKey:@"result"]];
                      // [Utilities displayCustemAlertViewWithOutImage:str :self.view];
                   });

              }

    
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *str = [NSString stringWithFormat:@"%@",[responseInfo valueForKey:@"result"]];
            //[Utilities displayCustemAlertViewWithOutImage:str :self.view];
        });
        
    }
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [Utilities removeLoading:self.view];
    });
    

    
}


////Table view method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return totalOrdersArray.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell...
    
    static NSString *CellIdentifier = @"OrdersCell";
    
   OrdersCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
    cell = [[OrdersCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    
    [Utilities addShadowtoView:cell.bgView];
    
    if ([totalOrdersArray count] > 0)
    {
   
        if ([[[totalOrdersArray objectAtIndex:indexPath.row] valueForKey:@"items"] count] > 0)
        {
            
        
            NSDictionary *dict=[[[totalOrdersArray objectAtIndex:indexPath.row] valueForKey:@"items"] objectAtIndex:0];
            
           //   NSDictionary *dict=[arrItem objectAtIndex:indexPath.row];
            
            [cell.restaurantNameLabel adjustsFontSizeToFitWidth];
            [cell.itemname adjustsFontSizeToFitWidth];
            [cell.createdDateLabel adjustsFontSizeToFitWidth];
            
        cell.restaurantNameLabel.text = [[totalOrdersArray objectAtIndex:indexPath.row] valueForKey:@"name"] ;
            
            StrGrand =  [NSString stringWithFormat:@"%@",[[totalOrdersArray objectAtIndex:indexPath.row] valueForKey:@"grand_total"]];
            
            grand = [StrGrand intValue];
        //cell.totalItemsPrice.text =[NSString stringWithFormat:@"₹%@",[[totalOrdersArray objectAtIndex:indexPath.row] valueForKey:@"grand_total"]];
            
            strWallet = [NSString stringWithFormat:@"%@",[[totalOrdersArray objectAtIndex:indexPath.row] valueForKey:@"wallet_amount"]];
            
            wallet = [strWallet intValue];
            
            if ([strWallet intValue] == 0)
            
            {
            
            cell.totalItemsPrice.text =[NSString stringWithFormat:@"₹%@",[[totalOrdersArray objectAtIndex:indexPath.row] valueForKey:@"grand_total"]];
            
            }
            
            
            else
            {
                cell.totalItemsPrice.text = [NSString stringWithFormat:@"₹%d.00", grand - wallet];
            }
            
        
        
            NSString * dateStr = [NSString stringWithFormat:@"%@",[[totalOrdersArray objectAtIndex:indexPath.row] valueForKey:@"created_on"]];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *date  = [dateFormatter dateFromString:dateStr];
            
            // Convert to new Date Format
            [dateFormatter setDateFormat:@"dd MMM, yyy hh:mm a"];
            NSString *newDate = [dateFormatter stringFromDate:date];
            
            cell.createdDateLabel.text = newDate;
            
            cell.itemName1.text =[NSString stringWithFormat:@"%@",[dict valueForKey:@"item_name"]];
            cell.quantityLabel.text= [NSString stringWithFormat:@"%@",[dict valueForKey:@"quantity"]];
            cell.priceLabel.text =[NSString stringWithFormat:@"₹%@",[dict valueForKey:@"price"]];
    

            
            if ([[[totalOrdersArray objectAtIndex:indexPath.row]objectForKey:@"drv_status"]isEqualToString:@"4"])
                 {
                cell.reorderBtn.hidden = NO;
                cell.reorderBtn.tag=indexPath.row;
                [cell.reorderBtn addTarget:self action:@selector(ReOrderButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            }
            else
            {
                cell.reorderBtn.hidden = YES;
            }
            

        }
        
        
     }
    
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 116;
}


-(void)ReOrderButtonAction:(UIButton*)sender
{
    
    
    UIButton *btn=(UIButton *)sender;
    variantTag =btn.tag;
     OrderID = [[totalOrdersArray objectAtIndex:variantTag] valueForKey:@"order_id"];
    
    if (arrcartItems.count > 0)
    {
    
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@""message:@"Do you want to delete previously added items?"preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* noButton = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault
                                   
                                                         handler:^(UIAlertAction * action){
                                                         }];
        
        
        UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Yes"style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                    
                                    {
                                        [self deleteCartServiceCall];
                                        
                                    }];
        
        
        [alertController addAction:noButton];
        [alertController addAction:yesButton];
        
        [self presentViewController:alertController animated:YES completion:nil];
        

    }
    else
    {
        [self reorderServiceCall];
    }
    
    
}
//delete cart service call
-(void)deleteCartServiceCall
{
    
    if ([Utilities isInternetConnectionExists]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.ordershimmer1 addGlowEffectWithWidth:80 duration:1.5];
            [self.ordershimmer2 addGlowEffectWithWidth:80 duration:1.5];
            [self.ordershimmer3 addGlowEffectWithWidth:80 duration:1.5];
        });
        
       
        NSString *urlStr = [NSString stringWithFormat:@"%@deleteCartItems",BASEURL];
        
        requestDict = @{
                        @"user_id":[Utilities getUserID],
                        @"establishment_id":[USERDEFAULTS valueForKey:@"establishmentString"],
                        
                        };
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            ServiceManager *service = [ServiceManager sharedInstance];
            service.delegate = self;
            
            isDelete = YES;
            
            [service  handleRequestWithDelegates:urlStr info:requestDict];
            
            
        });
        
        
    }
    else
    {
        [Utilities displayCustemAlertViewWithOutImage:@"Internet connection error" :self.view];
    }
}

//reorder service call
-(void)reorderServiceCall
{
    if ([Utilities isInternetConnectionExists]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.ordershimmer1 addGlowEffectWithWidth:80 duration:1.5];
            [self.ordershimmer2 addGlowEffectWithWidth:80 duration:1.5];
            [self.ordershimmer3 addGlowEffectWithWidth:80 duration:1.5];
        });
        
        
        
        NSString *urlStr = [NSString stringWithFormat:@"%@reorder_items",BASEURL];
        
       
        requestDict = @{
                        @"order_id":[NSString stringWithFormat:@"%@",OrderID],
                        @"user_id":[Utilities getUserID]
                        
                        };
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            ServiceManager *service = [ServiceManager sharedInstance];
            service.delegate = self;
            
            isOrders = YES;
            [service  handleRequestWithDelegates:urlStr info:requestDict];
            
        });
        
        
    }
    else
    {
        [Utilities displayCustemAlertViewWithOutImage:@"Internet connection error" :self.view];
    }

}
//cart service call
-(void)GetCartServiceCall
{
    [self.view endEditing:YES];
    
    if ([Utilities isInternetConnectionExists]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.ordershimmer1 addGlowEffectWithWidth:80 duration:1.5];
            [self.ordershimmer2 addGlowEffectWithWidth:80 duration:1.5];
            [self.ordershimmer3 addGlowEffectWithWidth:80 duration:1.5];
           
        });
        
        isgetcart = YES;
        
        NSString *urlStr = [NSString stringWithFormat:@"%@userCartItems",BASEURL];
        requestDict = @{
                        @"user_id":[Utilities getUserID]
                        
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

#pragma mark - Tableview delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
   OrderSummaryViewController * summary = [storyboard instantiateViewControllerWithIdentifier:@"OrderSummaryViewController"];
    summary.strOrderID = [NSString stringWithFormat:@"%@",[[totalOrdersArray objectAtIndex:indexPath.row] valueForKey:@"order_id"]];
    
    [self.navigationController pushViewController:summary animated:YES];
    NSString *str = [NSString stringWithFormat:@"%@",[[totalOrdersArray objectAtIndex:indexPath.row] valueForKey:@"to_lat"]];
    NSString *str1 = [NSString stringWithFormat:@"%@",[[totalOrdersArray objectAtIndex:indexPath.row] valueForKey:@"to_long"]];

    [USERDEFAULTS setObject:str forKey:@"str"];
    [USERDEFAULTS setObject:str1 forKey:@"str1"];

}
@end
