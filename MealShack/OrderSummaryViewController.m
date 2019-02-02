//
//  OrderSummaryViewController.m
//  MealShack
//
//  Created by Prasad on 07/08/17.
//  Copyright © 2017 Possibillion. All rights reserved.
//

#import "OrderSummaryViewController.h"
#import "OrderSummaryCell.h"
#import "Utilities.h"
#import "ServiceManager.h"
#import "Constants.h"
#import "TrackOrderViewController.h"
#import "SWRevealViewController.h"
#import "SingleTon.h"

@interface OrderSummaryViewController ()<ServiceHandlerDelegate>
{
    NSMutableArray * totalItemsArray;
    NSMutableDictionary * totalDetailsDict;
    NSDictionary *requestDict;
    NSMutableArray * arrtotalItems;
    BOOL isWallet;
     NSMutableDictionary * totalWalletDict;
    NSString * strWallet;
    NSString * StrGrandTotal;
    int grand, wallet;
    NSString *  str_gst, *subtotal;
     float  Gst;
    int gst;
    SingleTon *singleTonInstance;
}
@end

@implementation OrderSummaryViewController
@synthesize strOrderID;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@" - -- - --- %@",strOrderID);
    
    singleTonInstance=[SingleTon singleTonMethod];
    UIColor *color1 =  [Utilities getUIColorObjectFromHexString:@"#fd6565" alpha:1];
    _Btn_Track.backgroundColor = color1;
    totalItemsArray =[[NSMutableArray alloc]init];
    totalDetailsDict=[[NSMutableDictionary alloc]init];
    arrtotalItems=[[NSMutableArray alloc]init];
    
    //////////////////
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
    
    
    UIButton *btntitle = [UIButton buttonWithType:UIButtonTypeCustom];
    [btntitle setTitle:@"Order Summary" forState:UIControlStateNormal];
    btntitle.titleLabel.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:18];
    btntitle.frame = CGRectMake(0, 0, 250, 22);
    btntitle.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btntitle setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    btntitle.showsTouchWhenHighlighted=YES;
    UIBarButtonItem *barButtonItem3 = [[UIBarButtonItem alloc] initWithCustomView:btntitle];
    [arrLeftBarItems addObject:barButtonItem3];
    btntitle.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.leftBarButtonItems = arrLeftBarItems;
    
    self.orders_Scroll.contentSize = CGSizeMake(self.view.frame.size.width-50, self.view.frame.size.height);

    [self orderSummaryService];
    
    _itemsTableview.delegate = self;
    _itemsTableview.dataSource = self;
    
    self.Btn_Track.hidden = NO;
    SWRevealViewController *revealController = [self revealViewController];
    revealController.panGestureRecognizer.enabled = NO;
}
-(void)Back_Click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)TrackButton_Clicked:(id)sender
{
    NSLog(@"Tapped");
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TrackOrderViewController * Track = [storyboard instantiateViewControllerWithIdentifier:@"TrackOrderViewController"];
    Track.strOrderID = [NSString stringWithFormat:@"%@",strOrderID];
    if (Track.strOrderID) {
    }
    else
    {
        Track.strOrderID = singleTonInstance.orderIdStr;
    }
    [self.navigationController pushViewController:Track animated:YES];
}
-(void)orderSummaryService
{
    [self.view endEditing:YES];
    if ([Utilities isInternetConnectionExists]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
        });
        NSString *urlStr = [NSString stringWithFormat:@"%@orderdetails",BASEURL];
        requestDict = @{
                        @"order_id":strOrderID
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
            
            totalDetailsDict = [responseInfo objectForKey:@"orderdetails"];
            arrtotalItems =[[[responseInfo valueForKeyPath:@"orderdetails"] valueForKey:@"orders"] valueForKey:@"items"];
            
             if ([[[totalDetailsDict objectForKey:@"orders"] objectForKey:@"drv_status"]  isEqualToString:@"4"])
             {
                 self.Btn_Track.hidden = YES;
             }
             else
             
            self.Btn_Track.hidden = NO;
            self.itemsTableview.frame = CGRectMake(self.view.frame.origin.x, self.createdonLabel.frame.origin.y+self.createdonLabel.frame.size.height, self.BackView.frame.size.width,arrtotalItems.count*80);
            
            [self.bgview setFrame:CGRectMake(self.view.frame.origin.x,self.itemsTableview.frame.origin.y+ self.itemsTableview.frame.size.height+5, self.BackView.frame.size.width, 384)];
            
            [self.linelbl setFrame:CGRectMake(self.view.frame.origin.x,_itemsTableview.frame.origin.y+_itemsTableview.frame.size.height+1,self.BackView.frame.size.width ,1)];

            self.DeliveryAddLabel.text = [NSString stringWithFormat:@"%@",[Utilities null_ValidationString:[[totalDetailsDict objectForKey:@"orders"] objectForKey:@"delivery_address"]]];
            self.restaurantNameLabel.text = [NSString stringWithFormat:@"%@",[Utilities null_ValidationString:[[totalDetailsDict objectForKey:@"orders"] objectForKey:@"name"]]];
        
       NSString * dateStr = [NSString stringWithFormat:@"%@",[Utilities null_ValidationString:[[totalDetailsDict objectForKey:@"orders"] objectForKey:@"created_on"]]];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *date  = [dateFormatter dateFromString:dateStr];
            
            // Convert to new Date Format
            [dateFormatter setDateFormat:@"dd MMM yyy hh:mm a"];
            NSString *newDate = [dateFormatter stringFromDate:date];
            
            self.createdonLabel.text = newDate;
            
            str_gst = [NSString stringWithFormat:@"%@",[Utilities null_ValidationString:[[totalDetailsDict objectForKey:@"orders"] objectForKey:@"gst_value"]]];
  
        self.DiscountsLabel.text = [NSString stringWithFormat:@"₹%@.00", [Utilities null_ValidationString:[[totalDetailsDict objectForKey:@"orders"] objectForKey:@"discount_amount"]]];
        self.DeliverychargeLabel.text = [NSString stringWithFormat:@"₹%@",[Utilities null_ValidationString:[[totalDetailsDict objectForKey:@"orders"] objectForKey:@"delivery_charge"]]];
        self.TaxesLabel.text = [NSString stringWithFormat:@"₹%@",[Utilities null_ValidationString: [[totalDetailsDict objectForKey:@"orders"] objectForKey:@"taxes"]]];
            
            self.packagingLbl.text = [NSString stringWithFormat:@"₹%@", [Utilities null_ValidationString:[[totalDetailsDict objectForKey:@"orders"] objectForKey:@"packaging_charges"]]];
            
            StrGrandTotal = [NSString stringWithFormat:@"%@", [Utilities null_ValidationString:[[totalDetailsDict objectForKey:@"orders"] objectForKey:@"grand_total"]]];
            grand = [StrGrandTotal intValue];
       
        self.paymentmodelabel.text = [NSString stringWithFormat:@"%@",[Utilities null_ValidationString:[[totalDetailsDict objectForKey:@"orders"] objectForKey:@"payment_mode"]]];
        self.AddInstructnsLabel.text = [NSString stringWithFormat:@"%@",[Utilities null_ValidationString:[[totalDetailsDict objectForKey:@"orders"] objectForKey:@"addtional_instructions"]]];
        strWallet = [NSString stringWithFormat:@"%@",[Utilities null_ValidationString:[[totalDetailsDict objectForKey:@"orders"] objectForKey:@"wallet_amount"]]];
            
            wallet = [strWallet intValue];
            
            if ([strWallet intValue] == 0)
            {
                self.walletamountLbl.hidden = YES;
                self.walletLbl.hidden = YES;
                self.LblDeliveryCharge.frame = CGRectMake(self.LblDeliveryCharge.frame.origin.x, self.packagingLbl.frame.origin.y+ self.packagingLbl.frame.size.height + 10, self.LblDeliveryCharge.frame.size.width, self.LblDeliveryCharge.frame.size.height);
                self.DeliverychargeLabel.frame = CGRectMake(self.DeliverychargeLabel.frame.origin.x,self.packagingLbl.frame.origin.y+self. packagingLbl.frame.size.height + 8,self.DeliverychargeLabel.frame.size.width,self.DeliverychargeLabel.frame.size.height);
                self.LblGrandtotal.frame = CGRectMake(self.LblGrandtotal.frame.origin.x, self.DeliverychargeLabel.frame.origin.y+ self.DeliverychargeLabel.frame.size.height + 8, self.LblGrandtotal.frame.size.width, self.LblGrandtotal.frame.size.height);
                self.grandtotalLabel.frame = CGRectMake(self.grandtotalLabel.frame.origin.x,self.DeliverychargeLabel.frame.origin.y+self.DeliverychargeLabel.frame.size.height +8,self.grandtotalLabel.frame.size.width,self.grandtotalLabel.frame.size.height);
                 self.Linelabel.frame = CGRectMake(self.Linelabel.frame.origin.x, self.grandtotalLabel.frame.origin.y+ self.grandtotalLabel.frame.size.height + 8, self.Linelabel.frame.size.width, 1);
                self.grandtotalLabel.text = [NSString stringWithFormat:@"₹%@", [Utilities null_ValidationString:[[totalDetailsDict objectForKey:@"orders"] objectForKey:@"grand_total"]]];
            }
            else if([strWallet intValue] > 0)
            {
                self.walletamountLbl.hidden = NO;
                self.walletLbl.hidden = NO;
                self.walletamountLbl.text = [NSString stringWithFormat:@"₹%@.00",[Utilities null_ValidationString:[[totalDetailsDict objectForKey:@"orders"] objectForKey:@"wallet_amount"]]];
                self.grandtotalLabel.text =[Utilities null_ValidationString:[NSString stringWithFormat:@"₹%d.00",grand - wallet]];
            }
            int totalprice = 0;
            for (int i=0; i< [arrtotalItems count]; i++)
            {
            totalprice = totalprice + [[[arrtotalItems objectAtIndex:i] valueForKey:@"price"] intValue];
            }
            self.ItemCostLbl.text = [Utilities null_ValidationString:[NSString stringWithFormat:@"₹%d.00",totalprice]];
            
             Gst =  ([str_gst floatValue] * totalprice)/100;
            
            gst = ceil(Gst);
            
            NSLog(@"rounded up %d",gst);
            
            subtotal = [NSString stringWithFormat:@"%@",[Utilities null_ValidationString:[[totalDetailsDict objectForKey:@"orders"] objectForKey:@"total"]]];
            int sub = [subtotal intValue];
            NSString * fnlsubtotal;
            fnlsubtotal = [Utilities null_ValidationString:[NSString stringWithFormat:@"₹%d.00", sub + gst]];
            self.subtotalPrice.text = fnlsubtotal;
             [self.itemsTableview reloadData];
        });
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *str = [NSString stringWithFormat:@"%@",[responseInfo valueForKey:@"message"]];
            [self orderSummaryService];
           // [Utilities displayCustemAlertViewWithOutImage:str :self.view];
        });
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [Utilities removeLoading:self.view];
    });
}
////Table view method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrtotalItems.count;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"OrderSummaryCell";
    OrderSummaryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[OrderSummaryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    NSLog(@"cellForRowAtIndexPath");
    
    if ([arrtotalItems count] > 0 )
    {
        NSDictionary  *dict = [arrtotalItems objectAtIndex:indexPath.row];
        cell.itemNameLabel.text = [NSString stringWithFormat:@"%@",[Utilities null_ValidationString:[dict valueForKey:@"item_name"]]];
        cell.itemQuantLabel.text = [NSString stringWithFormat:@"%@",[Utilities null_ValidationString:[dict valueForKey:@"quantity"]]];
        cell.priceLabel.text = [NSString stringWithFormat:@"₹%@.00",[Utilities null_ValidationString:[dict valueForKey:@"price"]]];
        cell.itemNameLabel.adjustsFontSizeToFitWidth = YES;
        [cell.itemQuantLabel sizeToFit];
        cell.priceLabel.adjustsFontSizeToFitWidth = YES;
    }
    else
    {
        NSLog(@"");
    }
    return cell;
}
@end
