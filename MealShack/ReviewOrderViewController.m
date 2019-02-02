 //
//  ReviewOrderViewController.m
//  MealShack
//
//  Created by Prasad on 10/08/17.
//  Copyright © 2017 Possibillion. All rights reserved.
//

#import "ReviewOrderViewController.h"
#import "ServiceManager.h"
#import "Utilities.h"
#import "Constants.h"
#import "PaymentMenuViewController.h"
#import "ReviewOrderCell.h"
#import "CartModel.h"
#import "user_AddressViewCell.h"
#import "UIImageView+WebCache.h"
#import "ImageCache.h"
#import "AddAddressManually.h"
#import "SingleTon.h"

@interface ReviewOrderViewController ()<ServiceHandlerDelegate,ReviewOrderCellDelegate>
{
    NSDictionary *requestDict;
    NSMutableArray* totalItemsArray;
    NSMutableArray * totalAddressArray;
    NSMutableDictionary *totalDetailsDict;
    NSMutableArray *arrfoodTypeList;
    NSString * totalpriceStr;
   IBOutlet UIButton * upArrowBtn;
    
    SingleTon * singleTonInstance;
    
    NSString * establishmentString;
    NSString *strtotal;
    
    NSMutableArray * itemsAlreadyInDataBaseArray,*arrAddressList;
    NSManagedObject * obj;

    
  IBOutlet  UITableView * AddressTableView;
    UIButton * AddNewBtn;
    BOOL  boolUpdate ,expandClicked, isaddress,isdelivery ,iscouponcode,isDelete;
    NSString * lblqtystr,*itemCountStr;
    UIView * hideTableView;
    IBOutlet UILabel *subtotalcost,*TaxesCost,*lblgst,*lblitemCost;
    int finalTotal;
    IBOutlet UILabel *lblsubTotal;
     IBOutlet UILabel *lblDeliveryChargeCost;
     IBOutlet UILabel *lblGrandTotalCost;
    IBOutlet UILabel *lblDiscountsCost;
    NSString *strDistance;
    NSString * str_gst;
    NSString * establishID;
    NSMutableArray* reorderArr;
     NSString  *str_Price;
    int gst;
    float Gst;
    int a;
    NSString *addressSelectedStr;
    int disco;
    int GrandTotal;
    float DeliveryCost;
    int rounded;
    NSMutableArray * DiscountsArr;
    int  coupn;
    NSString* strCartCountDisplay;
    NSString * coupnStr;
    NSString *strvl;
    NSMutableDictionary * offerDict;
    BOOL CoupnApp;
    NSString * StrAddress;
    int DelivryCharge;
    NSString * strItemCost,* strItemGst ;
    int totalRoundUp;
    NSString * StrItemCos, * StrGst, * StrGrandTotal, *StrDeliveryCost, * StrSubTotal, *StrDiscounts, * strgrand;
    NSString * ItemCosStr, * GstStr, * GrandTotalStr, *DeliveryCostStr, * SubTotalStr, *DiscountsStr;
    
    BOOL isWallet;
    NSMutableArray * totalWalletArr;
    NSString * WalletStr, * strWallet;
    NSString * PackingStr,*dummyPackaing;
    int wallet;
     NSString * wallet_amount, *walletMoney, *walletNil;
    NSDictionary *proceedDict;
    NSString * reorderWallet, *reordersubtotal, *reordergst;
    NSString* strGrand, * StrTotalgrand;
   
  
}

@end

@implementation ReviewOrderViewController
@synthesize  dicttotal,strDeliverycharge,WalletMny,packagingMny;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    singleTonInstance =   [SingleTon singleTonMethod];
    
    
     self.scroll_items.contentSize = CGSizeMake(self.view.frame.size.width-50, self.view.frame.size.height);
    
    
    expandClicked = YES;
    addressView.hidden = YES;
    
     arrfoodTypeList = [[NSMutableArray alloc] init];
    itemsAlreadyInDataBaseArray = [[NSMutableArray alloc] init];
    totalDetailsDict = [[NSMutableDictionary alloc] init];
    
    self.AD= [[UIApplication sharedApplication]delegate];

    
    _OrderItemsTableView.delegate = self;
    _OrderItemsTableView.dataSource = self;

    
    addressView.backgroundColor = [UIColor whiteColor];

    upArrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    upArrowBtn.frame = CGRectMake(AddressTableView.frame.size.width-40, AddressTableView.frame.size.height+AddressTableView.frame.origin.y-10, 30, 34);
    
    //[Utilities setBorderView:addressView :3 :GrayColor];
    [upArrowBtn addTarget:self
                  action:@selector(upArrowAction)
        forControlEvents:UIControlEventTouchUpInside];
    
    [upArrowBtn setImage:[UIImage imageNamed:@"uparrow.png"] forState:UIControlStateNormal];

    [addressView addSubview:upArrowBtn];
    [addressView addSubview:AddressTableView];
    
    // _downarrowImg.hidden = NO;
        
    totalItemsArray = [[NSMutableArray alloc]init];
    totalAddressArray= [[NSMutableArray alloc]init];
    offerDict = [[NSMutableDictionary alloc]init];
    totalWalletArr = [[NSMutableArray alloc]init];
  
    
    
    
    //////////////////
    NSMutableArray *arrLeftBarItems = [[NSMutableArray alloc] init];
    UIButton *btnLib1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnLib1 setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    btnLib1.frame = CGRectMake(0, 0, 22, 22);
    btnLib1.showsTouchWhenHighlighted=YES;
    UIBarButtonItem *barButtonItem2 = [[UIBarButtonItem alloc] initWithCustomView:btnLib1];
    [arrLeftBarItems addObject:barButtonItem2];
    [btnLib1 addTarget:self action:@selector(Back_Click:) forControlEvents:UIControlEventTouchUpInside];
    
    //used for button images
    NSLayoutConstraint * widthConstraint = [btnLib1.widthAnchor constraintEqualToConstant:30];
    NSLayoutConstraint * HeightConstraint =[btnLib1.heightAnchor constraintEqualToConstant:30];
    [widthConstraint setActive:YES];
    [HeightConstraint setActive:YES];
    
    
    
    UIButton *btntitle = [UIButton buttonWithType:UIButtonTypeCustom];
    [btntitle setTitle:@"Review Order" forState:UIControlStateNormal];
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
    
    
    if (singleTonInstance.isFromOrders == YES)
    {
        
    
         _downarrowImg.hidden = YES;
        
        reorderArr = [[NSMutableArray alloc]init];
        reorderArr = [dicttotal valueForKey:@"items_list"];
        
        [lblselectedAddress adjustsFontSizeToFitWidth];
        
        
        lblselectedAddress.text = [[[dicttotal valueForKey:@"items_list"]objectAtIndex:0]valueForKey:@"delivery_address"];
        
        [_restaurantnameLabel adjustsFontSizeToFitWidth];
        
        
    self.restaurantnameLabel.text = [[[dicttotal valueForKey:@"items_list"]objectAtIndex:0]valueForKey:@"name"];
        
       
        int totalprice = 0;
        
        
        for (int i=0; i< [reorderArr count]; i++)
        {
            totalprice = totalprice + [[[reorderArr objectAtIndex:i] valueForKey:@"total"] intValue];
        }
        
        strItemCost = [NSString stringWithFormat:@"%d.00",totalprice];
        lblitemCost.text = strItemCost;
        
        int itemcos = [strItemCost intValue];
        
        
        
        strItemGst = [[[dicttotal valueForKey:@"items_list"]objectAtIndex:0]valueForKey:@"gst_value"];
        
        reordergst =  [[[dicttotal valueForKey:@"items_list"]objectAtIndex:0]valueForKey:@"taxes"];
        lblgst.text = reordergst ;
        
        int gst = [reordergst intValue];
        
        
    lblDiscountsCost.text =[[[dicttotal valueForKey:@"items_list"]objectAtIndex:0]valueForKey:@"discount_amount"];
        
        
        
       float gsT =  ([strItemGst floatValue] *totalprice)/100;
        
       int gstVal = ceil(gsT);
        
        NSLog(@"rounded up %d",gstVal);
        
        
        int subtotalVal = gstVal + totalprice;
        

    
       lblsubTotal.text = [NSString stringWithFormat:@"%d.00",subtotalVal];
    
        
        
    StrAddress =[[[dicttotal valueForKey:@"items_list"]objectAtIndex:0]valueForKey:@"delivery_charge"];
        
        
        lblDeliveryChargeCost.text = StrAddress;
        
        int delvry = [StrAddress intValue];
        
    [USERDEFAULTS setObject:StrAddress forKey:@"result"];
    
        
        WalletStr = [NSString stringWithFormat:@"%@",[dicttotal valueForKey:@"wallet_amount"]];
        
        
        PackingStr = [NSString stringWithFormat:@"%@",[dicttotal valueForKey:@"packaging_charges"]];
        
       WalletMny.text = WalletStr ;
        
        packagingMny.text = PackingStr;
        

        
        int walt = [WalletStr intValue];
        
  
         GrandTotalStr =  [NSString stringWithFormat:@"%d.00",itemcos + gst + delvry];
        
         int grandTot = [GrandTotalStr intValue];
        
        
        if ([WalletStr intValue] == 0)
        {
           
            
                lblGrandTotalCost.text =  GrandTotalStr;
    
        }
        
        else
        {
        if ([WalletStr intValue] > [GrandTotalStr intValue])
        {
            
          
            
            
            lblGrandTotalCost.text = [NSString stringWithFormat:@"0.00"];
            
            strWallet = [NSString stringWithFormat:@"%d",wallet - grandTot];
            NSLog(@"%@strWallet",strWallet);
            
            _CouponcodeTxtfield.userInteractionEnabled = NO;
            
            
            
            wallet_amount = [NSString stringWithFormat:@"%@",GrandTotalStr];
            NSLog(@"%@wallet_amount",wallet_amount);


        }
        
        else if ([WalletStr intValue] > 0 && [WalletStr intValue] < [GrandTotalStr intValue])
        {
            
            lblGrandTotalCost.text =  [NSString stringWithFormat:@"%d.00",itemcos + gst +delvry - walt];
            
            NSLog(@"%@GrandTotalStr",GrandTotalStr);
            
            int grand = [GrandTotalStr intValue];
            
            
            strWallet = [NSString stringWithFormat:@"0.00"];
            NSLog(@"%@strWallet",strWallet);
            _CouponcodeTxtfield.userInteractionEnabled = YES;
            
            walletMoney = [NSString stringWithFormat:@"%d",wallet];
            NSLog(@"%@walletMoney",walletMoney);
            

        }
        
      else if  ([WalletStr intValue] == [GrandTotalStr intValue])
      {
          lblGrandTotalCost.text = [NSString stringWithFormat:@"%d.00",itemcos + gst +delvry - walt];
          
          _CouponcodeTxtfield.userInteractionEnabled = NO;
          
          walletNil = [NSString stringWithFormat:@"%@",WalletStr];
          NSLog(@"%@walletNil",walletNil);
          
    }
        }
    
        
        
        //lblGrandTotalCost.text = strGrand;
        
        
        
   // self.OrderItemsTableView.frame = CGRectMake(self.view.frame.origin.x,self.restaurantnameLabel.frame.origin.y+self.restaurantnameLabel.frame.size.height,self.ReviewView.frame.size.width,totalItemsArray.count*59);
        
        [self.Bgview setFrame:CGRectMake(self.view.frame.origin.x,self.OrderItemsTableView.frame.origin.y+ self.OrderItemsTableView.frame.size.height+5, self.ReviewView.frame.size.width,340)];
        
        [_OrderItemsTableView reloadData];
        
        

    }
    else
    {
    
    [self reviewOrderServiceCall];
        
        
    }
    _CouponcodeTxtfield.userInteractionEnabled = YES;

}
-(void)viewWillAppear:(BOOL)animated
{
    

}



-(IBAction)upArrowAction
{
    AddressTableView.hidden = YES;
   // self.expandbutton.hidden = YES;
    addressView.hidden= NO;
    _downarrowImg.hidden = NO;
    expandClicked = YES;
    
    _AddView.hidden = NO;
    
    [addressView removeFromSuperview];
}


-(void)Back_Click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)CloseButton_Clicked:(id)sender
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@""message:@"Are you sure you want to clear the cart?"preferredStyle:UIAlertControllerStyleAlert];
    
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


-(void)deleteCartServiceCall
{
    [self.view endEditing:YES];
    
    
    if (singleTonInstance.isFromOrders == YES)
    {
        
        if ([Utilities isInternetConnectionExists]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
            });
            NSString *estID = [[reorderArr objectAtIndex:0] valueForKey:@"establishment_id"];
            
            
            NSString *urlStr = [NSString stringWithFormat:@"%@deleteCartItems",BASEURL];
           
            requestDict = @{
                            @"user_id":[Utilities getUserID],
                            @"establishment_id":[NSString stringWithFormat:@"%@",estID]
                            
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

    
    else
    {
        
    if ([Utilities isInternetConnectionExists]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
        });
        NSString *estID = [[totalItemsArray objectAtIndex:0] valueForKey:@"establishment_id"];
       
        singleTonInstance.identifyStr = @"close";
        NSString *urlStr = [NSString stringWithFormat:@"%@deleteCartItems",BASEURL];
       // NSDictionary *requestDict;
        requestDict = @{
                        @"user_id":[Utilities getUserID],
                        @"establishment_id":[NSString stringWithFormat:@"%@",estID]
                            //[USERDEFAULTS valueForKey:@"establishment_id"]
                     
                        };
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            ServiceManager *service = [ServiceManager sharedInstance];
            service.delegate = self;
           
            isDelete = YES;
            
            
            [service  handleRequestWithDelegates:urlStr info:requestDict];
            // [self uploadImagetoServer:urlStr];
            
        });
        
        
    }
    else
    {
        [Utilities displayCustemAlertViewWithOutImage:@"Internet connection error" :self.view];
    }
    }
    
}


- (IBAction)ApplyButton_Clicked:(id)sender
{
    [self.view endEditing:YES];
   
   
    if (singleTonInstance.isFromOrders == YES) {
       
        if ([_CouponcodeTxtfield.text length] > 0)
        {
            
            
            if ([Utilities isInternetConnectionExists]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
                });
                
                
                NSString *urlStr = [NSString stringWithFormat:@"%@apply_coupon",BASEURL];
                requestDict = @{
                                @"coupon_code":[NSString stringWithFormat:@"%@",_CouponcodeTxtfield.text],
                                @"user_id":[Utilities getUserID],
                                @"total_price":[NSString stringWithFormat:@"%@",lblGrandTotalCost.text]
                                };
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    ServiceManager *service = [ServiceManager sharedInstance];
                    service.delegate = self;
                    iscouponcode = YES;
                    
                    [service  handleRequestWithDelegates:urlStr info:requestDict];
                    // [self uploadImagetoServer:urlStr];
                    
                });
                
                
            }
            else
            {
                [Utilities displayCustemAlertViewWithOutImage:@"Internet connection error" :self.view];
            }
        }
        else
        {
            [Utilities displayCustemAlertViewWithOutImage:@"Please enter couponcode" :self.view];
            
        }
        

    }
    else
    {
    
    if ([_CouponcodeTxtfield.text length] > 0)
    {
        
    
    if ([Utilities isInternetConnectionExists]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
        });
        
        
        NSString *urlStr = [NSString stringWithFormat:@"%@apply_coupon",BASEURL];
        requestDict = @{
                        @"coupon_code":[NSString stringWithFormat:@"%@",_CouponcodeTxtfield.text],
                        @"user_id":[Utilities getUserID],
                        @"total_price":[NSString stringWithFormat:@"%@",lblGrandTotalCost.text]
                        };
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            ServiceManager *service = [ServiceManager sharedInstance];
            service.delegate = self;
            iscouponcode = YES;
            
            [service  handleRequestWithDelegates:urlStr info:requestDict];
            // [self uploadImagetoServer:urlStr];
            
        });
        
        
    }
    else
    {
        [Utilities displayCustemAlertViewWithOutImage:@"Internet connection error" :self.view];
    }
    }
    else
    {
        [Utilities displayCustemAlertViewWithOutImage:@"Please enter couponcode" :self.view];
        [_OrderItemsTableView reloadData];


    }
        
        
}
}



- (IBAction)ProceedToPayment:(id)sender
{
    
    if (singleTonInstance.isFromOrders == YES)
    
    {
        PaymentMenuViewController * payment = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"PaymentMenuViewController"];
        payment.strTotal = [NSString stringWithFormat:@"%@",lblGrandTotalCost.text];
        [USERDEFAULTS setObject:[NSString stringWithFormat:@"%@",lblGrandTotalCost.text] forKey:@"grandTotal"];
        [USERDEFAULTS setObject:[NSString stringWithFormat:@"%d",[reorderArr count]] forKey:@"itemcount"];
        [USERDEFAULTS setObject:[NSString stringWithFormat:@"%@",lblselectedAddress.text] forKey:@"deliveryaddress"];
        
        NSMutableArray *arrfinalItems = [[NSMutableArray alloc] init];
        for (int i = 0; i < [reorderArr count]; i++)
        {
            
            NSDictionary  *Dict = @{
                                    @"items_id":[NSString stringWithFormat:@"%@",[[reorderArr objectAtIndex:i] valueForKey:@"items_id"]],
                                    @"price":[NSString stringWithFormat:@"%@",[[reorderArr objectAtIndex:i] valueForKey:@"price"]],
                                    @"quantity":[NSString stringWithFormat:@"%@",[[reorderArr objectAtIndex:i] valueForKey:@"quantity"]]
                                    };
            
            [arrfinalItems addObject:Dict];
            
            
    [USERDEFAULTS setObject:[[reorderArr objectAtIndex:0] objectForKey:@"latitude"] forKey:@"seltctedRestLat"];
        NSLog(@"seltctedRestLat",[NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:@"seltctedRestLat"]]);
            
      [USERDEFAULTS setObject:[[reorderArr objectAtIndex:0] objectForKey:@"latitude"] forKey:@"seltctedRestLong"];
        NSLog(@"seltctedRestLat",[NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:@"seltctedRestLong"]]);

           

            
            [self.navigationController pushViewController:payment animated:YES];

    }
        
        
        
        NSError *error;
        NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:arrfinalItems options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData2 encoding:NSUTF8StringEncoding];
        NSLog(@"jsonData as string:\n%@", jsonString);
        
        NSString *estID = [[reorderArr objectAtIndex:0] valueForKey:@"establishment_id"];
        
        if ([WalletStr intValue] > [GrandTotalStr intValue])
        {
            proceedDict =  @{
                             @"user_id":[Utilities getUserID],
                             @"items":[NSString stringWithFormat:@"%@",jsonString],
                             @"delivery_address":[NSString stringWithFormat:@"%@",lblselectedAddress.text],
                             @"total":[NSString stringWithFormat:@"%@",lblitemCost.text],
                             @"coupon_code":[NSString stringWithFormat:@"%@",_CouponcodeTxtfield.text],
                             @"establishment_id":[NSString stringWithFormat:@"%@",estID],
                             @"latitude":[NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:@"to_lat"]],
                             @"longitude":[NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:@"to_long"]],
                             @"taxes":[NSString stringWithFormat:@"%@",lblgst.text],
                             @"delivery_charge":[NSString stringWithFormat:@"%@",lblDeliveryChargeCost.text],
                             @"addtional_instructions":[NSString stringWithFormat:@"%@",_AddInstructionsField.text],
                             @"discount_amount":[NSString stringWithFormat:@"%@",lblDiscountsCost.text],
                             @"item_gst":[NSString stringWithFormat:@"%d",gst],
                             @"grand_total":[NSString stringWithFormat:@"%@",GrandTotalStr],
                             @"wallet_status":@"1",
                             @"wallet_amount":[NSString stringWithFormat:@"%@",GrandTotalStr]
                             };
            

            
        }
        
        else if ([WalletStr intValue] > 0 && [WalletStr intValue] < [GrandTotalStr intValue])
        {
            
            proceedDict =  @{
                             @"user_id":[Utilities getUserID],
                             @"items":[NSString stringWithFormat:@"%@",jsonString],
                             @"delivery_address":[NSString stringWithFormat:@"%@",lblselectedAddress.text],
                             @"total":[NSString stringWithFormat:@"%@",lblitemCost.text],
                             @"coupon_code":[NSString stringWithFormat:@"%@",_CouponcodeTxtfield.text],
                             @"establishment_id":[NSString stringWithFormat:@"%@",estID],
                             @"latitude":[NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:@"to_lat"]],
                             @"longitude":[NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:@"to_long"]],
                             @"taxes":[NSString stringWithFormat:@"%@",lblgst.text],
                             @"delivery_charge":[NSString stringWithFormat:@"%@",lblDeliveryChargeCost.text],
                             @"addtional_instructions":[NSString stringWithFormat:@"%@",_AddInstructionsField.text],
                             @"discount_amount":[NSString stringWithFormat:@"%@",lblDiscountsCost.text],
                             @"item_gst":[NSString stringWithFormat:@"%d",gst],
                             @"grand_total":[NSString stringWithFormat:@"%@",GrandTotalStr],
                             @"wallet_status":@"1",
                             @"wallet_amount":[NSString stringWithFormat:@"%@",walletMoney]
                             };

        }
        
        else if ([WalletStr intValue] == [GrandTotalStr intValue])
        {
            
            proceedDict =  @{
                             @"user_id":[Utilities getUserID],
                             @"items":[NSString stringWithFormat:@"%@",jsonString],
                             @"delivery_address":[NSString stringWithFormat:@"%@",lblselectedAddress.text],
                             @"total":[NSString stringWithFormat:@"%@",lblitemCost.text],
                             @"coupon_code":[NSString stringWithFormat:@"%@",_CouponcodeTxtfield.text],
                             @"establishment_id":[NSString stringWithFormat:@"%@",estID],
                             @"latitude":[NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:@"to_lat"]],
                             @"longitude":[NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:@"to_long"]],
                             @"taxes":[NSString stringWithFormat:@"%@",lblgst.text],
                             @"delivery_charge":[NSString stringWithFormat:@"%@",lblDeliveryChargeCost.text],
                             @"addtional_instructions":[NSString stringWithFormat:@"%@",_AddInstructionsField.text],
                             @"discount_amount":[NSString stringWithFormat:@"%@",lblDiscountsCost.text],
                             @"item_gst":[NSString stringWithFormat:@"%d",gst],
                             @"grand_total":[NSString stringWithFormat:@"%@",GrandTotalStr],
                             @"wallet_status":@"1",
                             @"wallet_amount":[NSString stringWithFormat:@"%@",walletNil]
                             
                             };

        }
        
        else
        {
        
        
       proceedDict =  @{
                                       @"user_id":[Utilities getUserID],
                                       @"items":[NSString stringWithFormat:@"%@",jsonString],
                                       @"delivery_address":[NSString stringWithFormat:@"%@",lblselectedAddress.text],
                                       @"total":[NSString stringWithFormat:@"%@",lblitemCost.text],
                                       @"coupon_code":[NSString stringWithFormat:@"%@",_CouponcodeTxtfield.text],
                                       @"establishment_id":[NSString stringWithFormat:@"%@",estID],
                                       @"latitude":[NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:@"to_lat"]],
                                       @"longitude":[NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:@"to_long"]],
                                       @"taxes":[NSString stringWithFormat:@"%@",lblgst.text],
                                       @"delivery_charge":[NSString stringWithFormat:@"%@",lblDeliveryChargeCost.text],
                                       @"addtional_instructions":[NSString stringWithFormat:@"%@",_AddInstructionsField.text],
                                       @"discount_amount":[NSString stringWithFormat:@"%@",lblDiscountsCost.text],
                                       @"item_gst":[NSString stringWithFormat:@"%d",gst],
                                       @"grand_total":[NSString stringWithFormat:@"%@",GrandTotalStr],
                                       @"wallet_status":@"0",
                                       @"wallet_amount":[NSString stringWithFormat:@"0.00"]
                            
                                       };
            
        }
        
        payment.dic1 = proceedDict;
        

    }
   else if (isdelivery  == YES)
    {
        
        NSString *strdic = [NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:@"distance"]];
       //NSString *strdic = @"15550";
        
         
        if ( [strdic intValue] > [strDistance intValue] )
        {
            PaymentMenuViewController * payment = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"PaymentMenuViewController"];
            payment.strTotal = [NSString stringWithFormat:@"%@",lblGrandTotalCost.text];
            [USERDEFAULTS setObject:[NSString stringWithFormat:@"%@",lblGrandTotalCost.text] forKey:@"grandTotal"];
            [USERDEFAULTS setObject:[NSString stringWithFormat:@"%d",[totalItemsArray count]] forKey:@"itemcount"];
            [USERDEFAULTS setObject:[NSString stringWithFormat:@"%@",lblselectedAddress.text] forKey:@"deliveryaddress"];

            NSMutableArray *arrfinalItems = [[NSMutableArray alloc] init];
            for (int i = 0; i < [totalItemsArray count]; i++)
            {
                
             NSDictionary  *Dict = @{
                                @"items_id":[NSString stringWithFormat:@"%@",[[totalItemsArray objectAtIndex:i] valueForKey:@"item_id"]],
                                @"price":[NSString stringWithFormat:@"%@",[[totalItemsArray objectAtIndex:i] valueForKey:@"price"]],
                                @"quantity":[NSString stringWithFormat:@"%@",[[totalItemsArray objectAtIndex:i] valueForKey:@"quantity"]]
                                };
                
                [arrfinalItems addObject:Dict];
               

            }
            
            NSError *error;
            NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:arrfinalItems options:NSJSONWritingPrettyPrinted error:&error];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData2 encoding:NSUTF8StringEncoding];
            NSLog(@"jsonData as string:\n%@", jsonString);

            NSString *estID = [[totalItemsArray objectAtIndex:0] valueForKey:@"establishment_id"];
            
            if ([WalletStr intValue] > [StrGrandTotal intValue])
            {
                proceedDict =  @{
                                               @"user_id":[Utilities getUserID],
                                               @"items":[NSString stringWithFormat:@"%@",jsonString],
                                               @"delivery_address":[NSString stringWithFormat:@"%@",lblselectedAddress.text],
                                               @"total":[NSString stringWithFormat:@"%@",lblitemCost.text],
                                               @"coupon_code":[NSString stringWithFormat:@"%@",_CouponcodeTxtfield.text],
                                               @"establishment_id":[NSString stringWithFormat:@"%@",estID],
                                               @"latitude":[NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:@"to_lat"]],
                                               @"longitude":[NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:@"to_long"]],
                                               @"taxes":[NSString stringWithFormat:@"%@",lblgst.text],
                                               @"delivery_charge":[NSString stringWithFormat:@"%@",lblDeliveryChargeCost.text],
                                               @"addtional_instructions":[NSString stringWithFormat:@"%@",_AddInstructionsField.text],
                                               @"discount_amount":[NSString stringWithFormat:@"%@",lblDiscountsCost.text],
                                               @"item_gst":[NSString stringWithFormat:@"%d",gst],
                                               @"grand_total":[NSString stringWithFormat:@"%@",StrGrandTotal],
                                               @"wallet_status":@"1",
                                               @"wallet_amount":[NSString stringWithFormat:@"%@",StrGrandTotal]
                                               };
            }
            else if ([WalletStr intValue] > 0 && [WalletStr intValue]< [StrGrandTotal intValue])
            {
                
                proceedDict =  @{
                                               @"user_id":[Utilities getUserID],
                                               @"items":[NSString stringWithFormat:@"%@",jsonString],
                                               @"delivery_address":[NSString stringWithFormat:@"%@",lblselectedAddress.text],
                                               @"total":[NSString stringWithFormat:@"%@",lblitemCost.text],
                                               @"coupon_code":[NSString stringWithFormat:@"%@",_CouponcodeTxtfield.text],
                                               @"establishment_id":[NSString stringWithFormat:@"%@",estID],
                                               @"latitude":[NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:@"to_lat"]],
                                               @"longitude":[NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:@"to_long"]],
                                               @"taxes":[NSString stringWithFormat:@"%@",lblgst.text],
                                               @"delivery_charge":[NSString stringWithFormat:@"%@",lblDeliveryChargeCost.text],
                                               @"addtional_instructions":[NSString stringWithFormat:@"%@",_AddInstructionsField.text],
                                               @"discount_amount":[NSString stringWithFormat:@"%@",lblDiscountsCost.text],
                                               @"item_gst":[NSString stringWithFormat:@"%d",gst],
                                               @"grand_total":[NSString stringWithFormat:@"%@",StrGrandTotal],
                                               @"wallet_status":@"1",
                                               @"wallet_amount":[NSString stringWithFormat:@"%@",walletMoney]

                                               };
            }
            
            
            else if ([WalletStr intValue] == [StrGrandTotal intValue])
            {
                
                proceedDict =  @{
                                 @"user_id":[Utilities getUserID],
                                 @"items":[NSString stringWithFormat:@"%@",jsonString],
                                 @"delivery_address":[NSString stringWithFormat:@"%@",lblselectedAddress.text],
                                 @"total":[NSString stringWithFormat:@"%@",lblitemCost.text],
                                 @"coupon_code":[NSString stringWithFormat:@"%@",_CouponcodeTxtfield.text],
                                 @"establishment_id":[NSString stringWithFormat:@"%@",estID],
                                 @"latitude":[NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:@"to_lat"]],
                                 @"longitude":[NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:@"to_long"]],
                                 @"taxes":[NSString stringWithFormat:@"%@",lblgst.text],
                                 @"delivery_charge":[NSString stringWithFormat:@"%@",lblDeliveryChargeCost.text],
                                 @"addtional_instructions":[NSString stringWithFormat:@"%@",_AddInstructionsField.text],
                                 @"discount_amount":[NSString stringWithFormat:@"%@",lblDiscountsCost.text],
                                 @"item_gst":[NSString stringWithFormat:@"%d",gst],
                                 @"grand_total":[NSString stringWithFormat:@"%@",StrGrandTotal],
                                 @"wallet_status":@"1",
                                 @"wallet_amount":[NSString stringWithFormat:@"%@",walletNil]
                                 
                                 };

                
            }
            

            else
            {
            proceedDict =  @{
                                           @"user_id":[Utilities getUserID],
                                           @"items":[NSString stringWithFormat:@"%@",jsonString],
                                           @"delivery_address":[NSString stringWithFormat:@"%@",lblselectedAddress.text],
                                           @"total":[NSString stringWithFormat:@"%@",lblitemCost.text],
                                           @"coupon_code":[NSString stringWithFormat:@"%@",_CouponcodeTxtfield.text],
                                           @"establishment_id":[NSString stringWithFormat:@"%@",estID],
                                           @"latitude":[NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:@"to_lat"]],
                                           @"longitude":[NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:@"to_long"]],
                                           @"taxes":[NSString stringWithFormat:@"%@",lblgst.text],
                                           @"delivery_charge":[NSString stringWithFormat:@"%@",lblDeliveryChargeCost.text],
                                           @"addtional_instructions":[NSString stringWithFormat:@"%@",_AddInstructionsField.text],
                                           @"discount_amount":[NSString stringWithFormat:@"%@",lblDiscountsCost.text],
                                           @"item_gst":[NSString stringWithFormat:@"%d",gst],
                                           @"grand_total":[NSString stringWithFormat:@"%@",StrGrandTotal],
                                           @"wallet_status":@"0",
                                           @"wallet_amount":[NSString stringWithFormat:@"0.00"]

                                           };
            }
            
            
            payment.dic1 = proceedDict;
            
          
            [self.navigationController pushViewController:payment animated:YES];
        }
        else
        {
        
      
        [Utilities displayCustemAlertViewWithOutImage:@"We cannot deliver to this address" :self.view];

            
        }

    }
    else
    {
        [Utilities displayCustemAlertViewWithOutImage:@"Please select delivery address" :self.view];

    }
    
    
}


-(void)reviewOrderServiceCall
{
    
    
    [self.view endEditing:YES];
    
    if ([Utilities isInternetConnectionExists]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
        });
        
        
        NSString *urlStr = [NSString stringWithFormat:@"%@userCartItems",BASEURL];
        requestDict = @{
                        @"user_id":[Utilities getUserID]
                        
                        };
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            ServiceManager *service = [ServiceManager sharedInstance];
            service.delegate = self;
            isDelete = NO;
           
            [service  handleRequestWithDelegates:urlStr info:requestDict];
            // [self uploadImagetoServer:urlStr];
            
        });
        
        
    }
    else
    {
        [Utilities displayCustemAlertViewWithOutImage:@"Internet connection error" :self.view];
    }
    
    
    
}



////Table view method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int value;
    
    if (singleTonInstance.isFromOrders==YES)
    {
        return reorderArr.count;
    }
    else
    {
        if(tableView == AddressTableView)
    {
        value =   [arrAddressList count];
    }
    else if(tableView == _OrderItemsTableView)
    {
        
        value =  [totalItemsArray count];
    }
    
        return value;
    }
    
    
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return 59;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell...
  
    static NSString *CellIdentifier = @"ReviewOrderCell";
    if(tableView == _OrderItemsTableView)
    {
        
    ReviewOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ReviewOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    NSLog(@"cellForRowAtIndexPath");
        
        
        if (singleTonInstance.isFromOrders== YES)
        {
            NSDictionary  *dict = [reorderArr  objectAtIndex:0];
            
            strprice = [NSString stringWithFormat:@"%@", [Utilities null_ValidationString:[dict valueForKey:@"price"]]];
            strname = [NSString stringWithFormat:@"%@",[Utilities null_ValidationString:[dict valueForKey:@"item_name"]]];
            strqty = [NSString stringWithFormat:@"%@",[Utilities null_ValidationString:[dict valueForKey:@"quantity"]]];
            
            
            
            
            [Utilities setBorderView:cell.lineView :0 :LIGHTGRYCOLOR];
            
            if (CoupnApp == YES && _CouponcodeTxtfield.text.length > 0)
            {
                cell.IncrementButton.enabled = NO;
                cell.decrementButton.enabled  = NO;
                
                
                [cell.IncrementButton setTitleColor:LIGHTGRYCOLOR forState:UIControlStateNormal];
                [cell.decrementButton setTitleColor:LIGHTGRYCOLOR forState:UIControlStateNormal];
 
                
               
            }
            else
            {
                
                [cell.IncrementButton addTarget:self action:@selector(increaseLabelCount:) forControlEvents:UIControlEventTouchUpInside];
                [cell.decrementButton addTarget:self action:@selector(decreaseLabelCount:) forControlEvents:UIControlEventTouchUpInside];
                
                cell.IncrementButton.enabled = YES;
                cell.decrementButton.enabled  = YES;
                
//                [cell.IncrementButton setTitleColor:BLACKCOLOR forState:UIControlStateNormal];
//                [cell.decrementButton setTitleColor:BLACKCOLOR forState:UIControlStateNormal];

            }
            
            
            
            
            
            cell.IncrementButton.tag=indexPath.row;
            cell.decrementButton.tag=indexPath.row;
            
            [cell.itemNameLbl adjustsFontSizeToFitWidth];
            
            cell.itemNameLbl.text = strname;// capitalizedString];
            cell.itemNameLbl.minimumFontSize = 8;
            cell.itemNameLbl.adjustsFontSizeToFitWidth = YES;
            cell.itemPriceLbl.text  =  strprice;
            cell.lblqty.text = [NSString stringWithFormat:@"%@", [Utilities null_ValidationString:[dict valueForKey:@"quantity"]]];
        }
           else
           {
               NSDictionary  *dict = [totalItemsArray  objectAtIndex:indexPath.row];
               
               strprice = [NSString stringWithFormat:@"%@", [Utilities null_ValidationString:[dict valueForKey:@"price"]]];
               strname = [NSString stringWithFormat:@"%@",[Utilities null_ValidationString:[dict valueForKey:@"item_name"]]];
               strqty = [NSString stringWithFormat:@"%@",[Utilities null_ValidationString:[dict valueForKey:@"quantity"]]];
               
               
               [Utilities setBorderView:cell.lineView :0 :LIGHTGRYCOLOR];
               
               
               if (CoupnApp == YES && _CouponcodeTxtfield.text.length > 0)
               {
                   
                   cell.IncrementButton.enabled = NO;
                   cell.decrementButton.enabled  = NO;
                   
                   
                   [cell.IncrementButton setTitleColor:LIGHTGRYCOLOR forState:UIControlStateNormal];
                   [cell.decrementButton setTitleColor:LIGHTGRYCOLOR forState:UIControlStateNormal];
                   
    
                  
               }
               else
               {
                   
               [cell.IncrementButton addTarget:self action:@selector(increaseLabelCount:) forControlEvents:UIControlEventTouchUpInside];
               [cell.decrementButton addTarget:self action:@selector(decreaseLabelCount:) forControlEvents:UIControlEventTouchUpInside];
                   
                   cell.IncrementButton.enabled = YES;
                   cell.decrementButton.enabled  = YES;
                   
//                   [cell.IncrementButton setTitleColor:BLACKCOLOR forState:UIControlStateNormal];
//                   [cell.decrementButton setTitleColor:BLACKCOLOR forState:UIControlStateNormal];
//

               }
               
               
               cell.IncrementButton.tag=indexPath.row;
               cell.decrementButton.tag=indexPath.row;
               
               cell.itemNameLbl.text = strname;// capitalizedString];
               cell.itemPriceLbl.text  =  strprice;
               cell.lblqty.text = [NSString stringWithFormat:@"%@", [Utilities null_ValidationString:[dict valueForKey:@"quantity"]]];

           }
        
        
    return cell;
    
    
    }
    else
    {
        
        static NSString *simpleTableIdentifier = @"user_AddressViewCell";
        
        user_AddressViewCell *cell = (user_AddressViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if ([arrAddressList count] > 0 )
        {
            NSDictionary  *dict =[arrAddressList objectAtIndex:indexPath.row];
            
            
            NSString *strtitle = [NSString stringWithFormat:@"%@",[Utilities null_ValidationString:[dict valueForKey:@"address_tag"]]];
            
            NSString *straddress = [NSString stringWithFormat:@"%@",[Utilities null_ValidationString:[dict valueForKey:@"delivery_address"]]];
            
            // cell.btnvariant.tag=indexPath.row;
            // [cell.btnvariant addTarget:self action:@selector(DropDown:) forControlEvents:UIControlEventTouchUpInside];
            
            
            NSString *urlimage = [NSString stringWithFormat:@"%@",[Utilities null_ValidationString:[dict valueForKey:@""]]];
            
            if ([strtitle isEqualToString:@"Office"])
            {
                [cell.imgHome setImage:[UIImage imageNamed:@"suit.png"]];
            }
            else if ([strtitle isEqualToString:@"Home"])
                [cell.imgHome setImage:[UIImage imageNamed:@"homeadd.png"]];
            else if ([strtitle isEqualToString:@"Other"])
                [cell.imgHome setImage:[UIImage imageNamed:@"lmark.png"]];
            
            
            
            
            
            NSString *imageUrl;
            imageUrl = [NSString stringWithFormat:@"%@%@",BASEURLImages,urlimage];
            
            if ([[[ImageCache sharedManager] imageCache] objectForKey:imageUrl])
            {
                cell.mainImage.image =[[[ImageCache sharedManager] imageCache] objectForKey:imageUrl];
            }
            else
            {
                [cell.mainImage sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                                  placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            }
            
            
            
           // cell.lbltitle.text = strtitle;// capitalizedString];
            
            cell.nameLabel.text = strname;// capitalizedString];
            cell.lbladdress.text  =  straddress;
            cell.lblphno.text  =  @"";
            
        }
        
      
        
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        
        return cell;

    }
    
    
}
-(void)increaseLabelCount:(UIButton *)sender
{
    
    
    if ([Utilities isInternetConnectionExists]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
        });
        
        
    boolUpdate = YES;
    
    UIButton *btn=(UIButton *)sender;
    NSIndexPath *indexPath;
    
    ReviewOrderCell *cell = (ReviewOrderCell *)[_OrderItemsTableView cellForRowAtIndexPath:indexPath];
 
    int itemCount;
   
        if (CoupnApp == YES && _CouponcodeTxtfield.text.length>0)
        {
            [Utilities displayCustemAlertViewWithOutImage:@"Coupon Applied" :self.view];
        }
        
        else
        {
            if (singleTonInstance.isFromOrders == YES)
            {
                NSMutableDictionary  *dict1 = [[NSMutableDictionary alloc] init];;
                dict1 =[reorderArr objectAtIndex:btn.tag];
                
                
                establishID =[NSString stringWithFormat:@"%@", [[reorderArr objectAtIndex:0] objectForKey:@"establishment_id"]];
                NSLog(@"----%@", establishID);
                
                
                itemCount =  [[NSString stringWithFormat:@"%@",[dict1 valueForKey:@"quantity"]] intValue];
                itemCount ++;
                
                NSString  *strPrice;
                if (itemCount > 0)
                {
                    
                    
                    strPrice = [NSString stringWithFormat:@"%@",[dict1 valueForKey:@"price"]];
                    
                    [self updateInDB:dict1 itemcount:[NSString stringWithFormat:@"%d",itemCount] variant:strPrice];
                    
                   
                }
                
                cell.lblqty.text = [NSString stringWithFormat:@"%lu", itemCount];
                
                
                
                if([[[reorderArr objectAtIndex:btn.tag] valueForKey:@"items_id"] isEqualToString:[NSString stringWithFormat:@"%@",[dict1 valueForKey:@"items_id"]]])
                    
                {
                    
                    [dict1 removeObjectForKey:@"quantity"];
                    [dict1 setValue:[NSString stringWithFormat:@"%d",itemCount] forKey:@"quantity"];
                    
                    
                    
                    [reorderArr replaceObjectAtIndex:btn.tag withObject:dict1];
                    
                    
                }
                
                
                [_OrderItemsTableView reloadData];
                
                
            }
            else
            {
                
                
                NSMutableDictionary  *dict = [[NSMutableDictionary alloc] init];;
                dict =[totalItemsArray objectAtIndex:btn.tag];
                
                
                establishID =[NSString stringWithFormat:@"%@", [[totalItemsArray objectAtIndex:0] objectForKey:@"establishment_id"]];
                NSLog(@"----%@", establishID);
                
                
                itemCount =  [[NSString stringWithFormat:@"%@",[dict valueForKey:@"quantity"]] intValue];
                itemCount ++;
                
                NSString  *strPrice;
                if (itemCount > 0)
                {
                    
                    
                    strPrice = [NSString stringWithFormat:@"%@",[dict valueForKey:@"price"]];
                    
                    [self updateInDB:dict itemcount:[NSString stringWithFormat:@"%d",itemCount] variant:strPrice];
                    
                  
                    
                    
                }
                
                
                cell.lblqty.text = [NSString stringWithFormat:@"%lu", itemCount];
                
                
                
                if([[[totalItemsArray objectAtIndex:btn.tag] valueForKey:@"item_id"] isEqualToString:[NSString stringWithFormat:@"%@",[dict valueForKey:@"item_id"]]])
                    
                {
                    [dict removeObjectForKey:@"quantity"];
                    [dict setValue:[NSString stringWithFormat:@"%d",itemCount] forKey:@"quantity"];
                    
                    
                    
                    [totalItemsArray replaceObjectAtIndex:btn.tag withObject:dict];
                    
                    
                }
                
                
                [_OrderItemsTableView reloadData];
                
            }

        }
    
       
    
    
    
}
    else
    {
        [Utilities displayCustemAlertViewWithOutImage:@"Internet connection error" :self.view];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [Utilities removeLoading:self.view];
    });
    

}


-(void)decreaseLabelCount:(UIButton *)sender

{
    
    if ([Utilities isInternetConnectionExists]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
        });
        
    boolUpdate = YES;
    UIButton *btn=(UIButton *)sender;
    NSIndexPath *indexPath;
    
    ReviewOrderCell *cell = (ReviewOrderCell *)[_OrderItemsTableView cellForRowAtIndexPath:indexPath];
    
    int itemCount;
    
    if (singleTonInstance.isFromOrders == YES)
    {
        NSMutableDictionary  *dict1 = [[NSMutableDictionary alloc] init];;
        dict1 =[reorderArr objectAtIndex:btn.tag];
        
        
        
        establishID =[NSString stringWithFormat:@"%@", [[reorderArr objectAtIndex:0] objectForKey:@"establishment_id"]];
        NSLog(@"----%@", establishID);
        
        
        
        itemCount =  [[NSString stringWithFormat:@"%@",[dict1 valueForKey:@"quantity"]] intValue];
        
        
        NSString  *strPrice;
        if (itemCount > 0)
        {
            
            

            
            strPrice = [NSString stringWithFormat:@"%@",[dict1 valueForKey:@"price"]];
            itemCount --;
            [self updateInDB:dict1 itemcount:[NSString stringWithFormat:@"%d",itemCount] variant:strPrice];
            
            
         
            
            
        }
        
        else
        {
            [self reviewOrderServiceCall];
        }
        
        
        cell.lblqty.text = [NSString stringWithFormat:@"%lu",itemCount];
        
        if([[[reorderArr objectAtIndex:btn.tag] valueForKey:@"items_id"] isEqualToString:[NSString stringWithFormat:@"%@",[dict1 valueForKey:@"items_id"]]])
            
        {
            [dict1 removeObjectForKey:@"quantity"];
            [dict1 setValue:[NSString stringWithFormat:@"%d",itemCount] forKey:@"quantity"];
            
            
            
            [reorderArr replaceObjectAtIndex:btn.tag withObject:dict1];
            
        }
        
        [_OrderItemsTableView reloadData];
        
        
 
    }

    else
    {
    NSMutableDictionary  *dict = [[NSMutableDictionary alloc] init];;
    dict =[totalItemsArray objectAtIndex:btn.tag];
  
        if (totalItemsArray.count == 1) {
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@""message:@"Are you sure you want to clear the cart?"preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* noButton = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault
                                       
                                                             handler:^(UIAlertAction * action){
                                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                                     [Utilities removeLoading:self.view];
                                                                 });
                                                             }];
            
            
            UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Yes"style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                        
                                        {
                                            [self deleteCartServiceCall];
                                            
                                        }];
            
            
            [alertController addAction:noButton];
            [alertController addAction:yesButton];
            
            [self presentViewController:alertController animated:YES completion:nil];
            return;
        }
    
    establishID =[NSString stringWithFormat:@"%@", [[totalItemsArray objectAtIndex:0] objectForKey:@"establishment_id"]];
    NSLog(@"----%@", establishID);
    

    
    itemCount =  [[NSString stringWithFormat:@"%@",[dict valueForKey:@"quantity"]] intValue];
    
    
    NSString  *strPrice;
    if (itemCount > 0)
    {
        
        

        
        
        strPrice = [NSString stringWithFormat:@"%@",[dict valueForKey:@"price"]];
        itemCount --;
        [self updateInDB:dict itemcount:[NSString stringWithFormat:@"%d",itemCount] variant:strPrice];
        
        
        
    }
        
    
    else
    {
         [self reviewOrderServiceCall];
    }
        
        
    
    
    cell.lblqty.text = [NSString stringWithFormat:@"%lu", itemCount];
    
    if([[[totalItemsArray objectAtIndex:btn.tag] valueForKey:@"item_id"] isEqualToString:[NSString stringWithFormat:@"%@",[dict valueForKey:@"item_id"]]])
    
    {
        [dict removeObjectForKey:@"quantity"];
        [dict setValue:[NSString stringWithFormat:@"%d",itemCount] forKey:@"quantity"];
        
        
        
        [totalItemsArray replaceObjectAtIndex:btn.tag withObject:dict];
       
     }
    
    [_OrderItemsTableView reloadData];
    
    }
    
    
}
    
    else
    {
        [Utilities displayCustemAlertViewWithOutImage:@"Internet connection error" :self.view];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [Utilities removeLoading:self.view];
    });
    

}

    



- (IBAction)updateInDB:(NSDictionary *)itemdict itemcount:(NSString*)itemQty variant:(NSString*)variantPrice

{
    [self.view endEditing:YES];
    
    
    if ([Utilities isInternetConnectionExists]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
        });
        
        
        NSString *urlStr = [NSString stringWithFormat:@"%@addToCart",BASEURL];
        
        
        if (singleTonInstance.isFromOrders == YES)
        {
            requestDict = @{
                            @"establishment_id":establishID,
                            @"user_id":[Utilities getUserID],
                            @"item_id":[NSString stringWithFormat:@"%@",[itemdict valueForKey:@"items_id"]],
                            @"quantity":itemQty,
                            @"price":[NSString stringWithFormat:@"%@",variantPrice],
                            @"gst":[NSString stringWithFormat:@"%@",[itemdict valueForKey:@"gst_value"]],
                            @"device_type":@"ios"

                            };
        }
        else
        {
        requestDict = @{
                        @"establishment_id":establishID,
                            //[NSString stringWithFormat:@"%@",[totalDetailsDict objectForKey:@"establishment_id"]],
                        @"user_id":[Utilities getUserID],
                        @"item_id":[NSString stringWithFormat:@"%@",[itemdict valueForKey:@"item_id"]],
                        @"quantity":itemQty,
                        @"price":[NSString stringWithFormat:@"%@",variantPrice],
                        @"gst":str_gst,
                            //[NSString stringWithFormat:@"%@",[itemdict valueForKey:@"gst_id"]],
                        @"device_type":@"ios"
                        
                        };
        }
        
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


- (IBAction)ExpandButton_Clicked:(id)sender
{
    
    
    if (singleTonInstance.isFromOrders == YES)
    {
        self.expandbutton.hidden = YES;
    }
    else if (expandClicked == YES)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            AddressTableView.hidden = NO;
            expandClicked = NO;
            addressView.hidden = NO;
            _downarrowImg.hidden = YES;
            addressView.hidden = NO;
            [self ServiceCallAddresses];
            

            _AddView.hidden = YES;
            
            [self.view addSubview: addressView];
        });
        
       
    }
    
   
 
}

#pragma mark - Tableview delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _OrderItemsTableView)
    {
        
    }
    else
    {
        NSString *strlat = [NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:@"seltctedRestLat"]];
        NSString *strlog = [NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:@"seltctedRestLong"]];
        

        
    
        NSString *strTOlat = [NSString stringWithFormat:@"%@",[[arrAddressList objectAtIndex:indexPath.row] valueForKey:@"to_lat"]];
        NSString *strTOlog = [NSString stringWithFormat:@"%@",[[arrAddressList objectAtIndex:indexPath.row] valueForKey:@"to_long"]];
        
        [USERDEFAULTS setObject:strTOlat forKey:@"to_lat"];
        [USERDEFAULTS setObject:strTOlog forKey:@"to_long"];
        
        
        strDistance = [[LcnManager sharedManager] calculateDistance:strlat :strlog :strTOlat :strTOlog];
        
        lblselectedAddress.text = [NSString stringWithFormat:@"%@",[[arrAddressList objectAtIndex:indexPath.row] valueForKey:@"delivery_address"]];
        
        NSString *strtitle = [NSString stringWithFormat:@"%@",[Utilities null_ValidationString:[[arrAddressList objectAtIndex:indexPath.row] valueForKey:@"address_tag"]]];
        
        if ([strtitle isEqualToString:@"Office"])
        {
            [self.AddressImg setImage:[UIImage imageNamed:@"suit.png"]];
        }
        else if ([strtitle isEqualToString:@"Home"])
            [self.AddressImg setImage:[UIImage imageNamed:@"homeadd.png"]];
        else if ([strtitle isEqualToString:@"Other"])
            [self.AddressImg setImage:[UIImage imageNamed:@"lmark.png"]];
        

        [self upArrowAction];
      
        [self ServiceCallFOR_Deliverycharge:strlat :strlog :strTOlat :strTOlog];
    }
 
    
}


//servicde call for dedlivery charge

-(void)ServiceCallFOR_Deliverycharge :(NSString *)fromlat:(NSString*)fromlong:(NSString*)toLat:(NSString*)tolong
{
    
    
    [self.view endEditing:YES];
    
    if ([Utilities isInternetConnectionExists]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
        });
        
        NSDictionary *requestDict;
        NSString *urlStr = [NSString stringWithFormat:@"%@deliveryAmount",BASEURL];
        requestDict = @{
                        @"restaurant_latitude":fromlat,
                        @"restaurant_longitude":fromlong,
                        @"user_latitude":toLat,
                        @"user_longitude":tolong
                        
                        };
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            ServiceManager *service = [ServiceManager sharedInstance];
            service.delegate = self;
            
            isdelivery = YES;
            [service  handleRequestWithDelegates:urlStr info:requestDict];
            
        });
        
        
    }
    else
    {
        [Utilities displayCustemAlertViewWithOutImage:@"Internet connection error" :self.view];
    }
}

//service call for address
-(void)ServiceCallAddresses
{
    
    [self.view endEditing:YES];
    
    if ([Utilities isInternetConnectionExists])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
        });
        
        NSDictionary *requestDict;
        NSString *urlStr = [NSString stringWithFormat:@"%@user_delivery_address",BASEURL];
        
        
        requestDict = @{
                        @"user_id":[Utilities getUserID]
                        };
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            ServiceManager *service = [ServiceManager sharedInstance];
            service.delegate = self;
            
            isaddress = YES;
            iscouponcode = NO;
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
            
            if (singleTonInstance.isFromOrders == YES)
            {
                NSMutableArray *  tempArr = [[NSMutableArray alloc]init];
                
                tempArr = [responseInfo valueForKey:@"cart_items"];
                
                
                if (tempArr.count) {
                    [totalItemsArray removeAllObjects];
                    for (int i = 0; i < tempArr.count; i++) {
                        [totalItemsArray addObject:[tempArr objectAtIndex:i]];
                    }
                    
                }
                
              // totalItemsArray = [responseInfo valueForKey:@"cart_items"];
                

                
                totalWalletArr = [responseInfo valueForKey:@"wallet_amount"];
                
                
                if(iscouponcode == YES)
                {
                    
                    WalletStr = [USERDEFAULTS valueForKey:@"waletMoney"];
                    
                    WalletMny.text = WalletStr;

                }
                else{
                
                 totalWalletArr = [responseInfo valueForKey:@"wallet_amount"];
                WalletStr = [NSString stringWithFormat:@"%@",totalWalletArr];
                
                WalletMny.text = WalletStr;
                    
                    [USERDEFAULTS setObject:WalletStr forKey:@"waletMoney"];
                    
                }
                
                wallet = [WalletStr intValue];

             
                
                int totalprice = 0;
                
                
                for (int i = 0; i< [totalItemsArray count]; i++)
                {
                    totalprice = totalprice + [[[totalItemsArray objectAtIndex:i] valueForKey:@"total_price"] intValue];
               
                lblitemCost.text = [NSString stringWithFormat:@"%d.00",totalprice];
                

                str_gst = [NSString stringWithFormat:@"%@", [[totalItemsArray objectAtIndex:i] valueForKey:@"gst_value"]];
               
                
                
                Gst =  ([str_gst floatValue] *totalprice)/100;
                
                gst = ceil(Gst);
                
                NSLog(@"rounded up %d",gst);
                
                //lblgst.text = [NSString stringWithFormat:@"%d.00",gst +totalRoundUp];
                
                int subtotalvalue = gst + totalprice;
                
                
                strvl = [NSString stringWithFormat:@"%@",[[[totalItemsArray  objectAtIndex:i] valueForKey:@"offer"] valueForKey:@"offer_value"]];
                    
                    float disc;
                    disc = ([strvl floatValue]* totalprice)/100;
                    disco = ceil(disc);
                
                
                lblDiscountsCost.text =  [NSString stringWithFormat:@"%d.00",disco];
                
               // finalTotal = subtotalvalue  - disco;
                    finalTotal = subtotalvalue;
                    
                    
                    
                lblsubTotal.text = [NSString stringWithFormat:@"%d.00",finalTotal];
                
                lblDeliveryChargeCost.text = [USERDEFAULTS valueForKey:@"result"];
                DelivryCharge = [[USERDEFAULTS valueForKey:@"result"] intValue];
                    
                    NSString * str = @"5";
                    
                    float Delivery =  ([str floatValue] * DelivryCharge)/100;
                    
                   totalRoundUp = ceil(Delivery);
                    
                    NSLog(@"rounded value %d",totalRoundUp);
                    
                     lblgst.text = [NSString stringWithFormat:@"%d.00",gst +totalRoundUp];
                
            //   lblGrandTotalCost.text = [NSString stringWithFormat:@"%d.00",finalTotal +DelivryCharge+totalRoundUp - disco];
                    GrandTotalStr = [NSString stringWithFormat:@"%d.00",finalTotal +DelivryCharge+totalRoundUp - disco];
                    
                    int grandTot = [GrandTotalStr intValue];
                    
                      if ([WalletStr intValue]  == 0 )
                      {
                          
                          WalletMny.hidden = YES;
                          self.walletLbl.hidden = YES;
                          self.walletLineLbl.hidden = YES;
                          
                          
                          self.DelvryFeeLbl.frame = CGRectMake(self.DelvryFeeLbl.frame.origin.x, self.lblDiscount.frame.origin.y+ self.lblDiscount.frame.size.height + 10, self.DelvryFeeLbl.frame.size.width, self.DelvryFeeLbl.frame.size.height);
                          
                          
                          lblDeliveryChargeCost.frame = CGRectMake(lblDeliveryChargeCost.frame.origin.x, lblDiscountsCost.frame.origin.y+ lblDiscountsCost.frame.size.height + 10, lblDeliveryChargeCost.frame.size.width, lblDeliveryChargeCost.frame.size.height);
                          
                          
                          self.LinelBlDelivery.frame = CGRectMake(self.LinelBlDelivery.frame.origin.x, self.lblDiscount.frame.origin.y+ self.lblDiscount.frame.size.height + 35, self.LinelBlDelivery.frame.size.width, self.LinelBlDelivery.frame.size.height);
                          
                          
                          self.LblGrand.frame = CGRectMake(self.LblGrand.frame.origin.x, self.lblDiscount.frame.origin.y+ self.lblDiscount.frame.size.height + 40, self.LblGrand.frame.size.width, self.LblGrand.frame.size.height);
                          
                          
                          lblGrandTotalCost.frame = CGRectMake(lblGrandTotalCost.frame.origin.x, lblDiscountsCost.frame.origin.y+ lblDiscountsCost.frame.size.height +40,lblGrandTotalCost.frame.size.width, lblGrandTotalCost.frame.size.height);
                          
                          
                          lblGrandTotalCost.text = [NSString stringWithFormat:@"%d.00",finalTotal +DelivryCharge+totalRoundUp - disco];
                          
                          
                          
                      }
                    else
                    {
                        
                        WalletMny.hidden = NO;
                        self.walletLbl.hidden = NO;
                        self.walletLineLbl.hidden = NO;
                        
                        self.DelvryFeeLbl.frame = CGRectMake(5,235,143,21);
                        
                        
                        lblDeliveryChargeCost.frame = CGRectMake(285,235,85,21);
                        
                        
                        self.LinelBlDelivery.frame = CGRectMake(0,255,400,1);
                        
                        
                        self.LblGrand.frame = CGRectMake(5,260,143,20);
                        
                        
                        lblGrandTotalCost.frame = CGRectMake(285,260,85,20);
                        

                    
                    if ([WalletStr intValue] > [GrandTotalStr intValue])
                    {
                        
                        lblGrandTotalCost.text = [NSString stringWithFormat:@"0.00"];
                       
                        strWallet = [NSString stringWithFormat:@"%d",wallet - grandTot];
                        NSLog(@"%@strWallet",strWallet);
                        
                         _CouponcodeTxtfield.userInteractionEnabled = NO;
                        
                        
                        
                        wallet_amount = [NSString stringWithFormat:@"%@",GrandTotalStr];
                        NSLog(@"%@wallet_amount",wallet_amount);
                        
                        
                    }
                    
                    else if ([WalletStr intValue] > 0 && [WalletStr intValue] < [GrandTotalStr intValue])
                    {
                        
                        lblGrandTotalCost.text = [NSString stringWithFormat:@"%d.00",finalTotal +DelivryCharge+totalRoundUp - disco- wallet];
                       
                        int grand = [strgrand intValue];
                        strWallet = [NSString stringWithFormat:@"0.00"];
                        NSLog(@"%@strWallet",strWallet);
                        
                        
                         _CouponcodeTxtfield.userInteractionEnabled = YES;
                        
                        
                        walletMoney = [NSString stringWithFormat:@"%d",wallet];
                        NSLog(@"%@walletMoney",walletMoney);
                        
                        
                        
                    }
                    
                     else if ([WalletStr intValue] == [GrandTotalStr intValue])
                    {
                        
                        lblGrandTotalCost.text = [NSString stringWithFormat:@"%d.00",finalTotal +DelivryCharge+totalRoundUp - disco- wallet];
                        
                        _CouponcodeTxtfield.userInteractionEnabled = NO;

                        walletNil = [NSString stringWithFormat:@"%@",WalletStr];
                        NSLog(@"%@walletNil",walletNil);
                    }
                    
                    }
                    
//                    if ([PackingStr intValue]  == 0 )
//                    {
//                        packagingMny.hidden = YES;
//                        self.packagingLbl.hidden = YES;
//                        self.packagingLineLbl.hidden = YES;
//
//
//                        self.DelvryFeeLbl.frame = CGRectMake(self.DelvryFeeLbl.frame.origin.x, self.lblDiscount.frame.origin.y+ self.lblDiscount.frame.size.height + 10, self.DelvryFeeLbl.frame.size.width, self.DelvryFeeLbl.frame.size.height);
//
//
//                        lblDeliveryChargeCost.frame = CGRectMake(lblDeliveryChargeCost.frame.origin.x, lblDiscountsCost.frame.origin.y+ lblDiscountsCost.frame.size.height + 10, lblDeliveryChargeCost.frame.size.width, lblDeliveryChargeCost.frame.size.height);
//
//
//                        self.LinelBlDelivery.frame = CGRectMake(self.LinelBlDelivery.frame.origin.x, self.lblDiscount.frame.origin.y+ self.lblDiscount.frame.size.height + 35, self.LinelBlDelivery.frame.size.width, self.LinelBlDelivery.frame.size.height);
//
//
//                        self.LblGrand.frame = CGRectMake(self.LblGrand.frame.origin.x, self.lblDiscount.frame.origin.y+ self.lblDiscount.frame.size.height + 40, self.LblGrand.frame.size.width, self.LblGrand.frame.size.height);
//
//
//                        lblGrandTotalCost.frame = CGRectMake(lblGrandTotalCost.frame.origin.x, lblDiscountsCost.frame.origin.y+ lblDiscountsCost.frame.size.height +40,lblGrandTotalCost.frame.size.width, lblGrandTotalCost.frame.size.height);
//
//
//
////                        lblGrandTotalCost.text = [NSString stringWithFormat:@"%d.00",finalTotal +DelivryCharge+totalRoundUp - disco];
//
//                    }
//                    else
//                    {
//
//                        packagingMny.hidden = YES;
//                        self.packagingLbl.hidden = YES;
//                        self.packagingLineLbl.hidden = YES;
//
//
//                }
//
                
//                [_OrderItemsTableView reloadData];
//
//
//
//                }
//
      ///caution :  dont change the response flipflop
                    
                    if ([WalletStr intValue]  == 0 )
                    {
                        
                        
                        
                    }
                    
                    
                    
                }
                
                
                [_OrderItemsTableView reloadData];
                
                
                
            }
            
           else
            {
                 dispatch_async(dispatch_get_main_queue(), ^{
               
               NSMutableArray *  tempArr = [[NSMutableArray alloc]init];
                
                
                tempArr = [responseInfo valueForKey:@"cart_items"];
                     
                     

                
                
                if (tempArr.count) {
                    [totalItemsArray removeAllObjects];
                    for (int i = 0; i < tempArr.count; i++) {
                        [totalItemsArray addObject:[tempArr objectAtIndex:i]];
                    }
                    
                }
                

               // totalItemsArray = [responseInfo valueForKey:@"cart_items"];
                     offerDict = [totalItemsArray valueForKey:@"offer"];
                     
                

                     
                     if(isaddress == YES || isdelivery == YES)
                     {
                        // WalletStr =  [USERDEFAULTS valueForKey:@"walletMoney"];
                     }
                     else
                     {
                         totalWalletArr = [responseInfo valueForKey:@"wallet_amount"];
                         
                         
                         
                         WalletStr = [NSString stringWithFormat:@"%@",totalWalletArr];
                         
                        // [USERDEFAULTS setObject:WalletStr forKey:@"walletMoney"];
                         
                         WalletMny.text = WalletStr;
                     }
                         
                    
                     
                     
                    wallet = [WalletStr intValue];

                     
                    
                     
                     
            
            //size for 30 items
            //change height + some height for more items
            self.ReviewView.frame = CGRectMake(self.view.frame.origin.x,self.AddView.frame.origin.y,self.ReviewView.frame.size.width,self.view.frame.size.height +1400);
                     
                     
            self.restaurantnameLabel.frame = CGRectMake(5,8,159,27);
           
                     
                     if (IS_IPHONE_5 || IS_IPHONE_5S || IS_IPHONE_5C)
                     {
                        self.closebtn.frame = CGRectMake(270,8,17,17);
                     }
                     
                     else if (IS_STANDARD_IPHONE_6 || IS_STANDARD_IPHONE_6S || IS_STANDARD_IPHONE_7 )
                     {
                         self.closebtn.frame = CGRectMake(320,8,17,17);
                     }
                    
                     
                     else if( IS_STANDARD_IPHONE_6S_PLUS || IS_STANDARD_IPHONE_7_PLUS )
                     {
                          self.closebtn.frame = CGRectMake(350,8,17,17);
                     }
                     
                     else
                     {
                         self.closebtn.frame = CGRectMake(320,8,17,17);
                     }

                
            self.OrderItemsTableView.frame = CGRectMake(self.view.frame.origin.x,self.restaurantnameLabel.frame.origin.y+self.restaurantnameLabel.frame.size.height,self.ReviewView.frame.size.width,totalItemsArray.count*59);
                
            [self.Bgview setFrame:CGRectMake(self.view.frame.origin.x,self.OrderItemsTableView.frame.origin.y+ self.OrderItemsTableView.frame.size.height+5, self.ReviewView.frame.size.width,340)];
                     
                     
                     if (totalItemsArray.count > 5) {
                         
                         int count = totalItemsArray.count*59;
                        
                         self.scroll_items.contentSize= CGSizeMake(self.view.frame.size.width-50, self.view.frame.size.height+80+count-354);
                     }
                    
                     if (IS_IPHONE_5 || IS_IPHONE_5S || IS_IPHONE_5C)
                     {
                         
                         if (totalItemsArray.count > 5) {
                             
                             int count = totalItemsArray.count*59;
                             
                             self.scroll_items.contentSize= CGSizeMake(self.view.frame.size.width-50, self.view.frame.size.height+240+count-354);
                         }
                         
                     }
                    
                     if (IS_STANDARD_IPHONE_6 || IS_STANDARD_IPHONE_6S || IS_STANDARD_IPHONE_7 )
                     {
                         
                         if (totalItemsArray.count > 5) {
                             
                             int count = totalItemsArray.count*59;
                             
                             self.scroll_items.contentSize= CGSizeMake(self.view.frame.size.width-50, self.view.frame.size.height+80+count-354);
                         }
                         
                     }

                     
     

                     
//            self.ReviewView.frame = CGRectMake(self.view.frame.origin.x, self.AddView.frame.origin.y+self.AddView.frame.size.height +1, self.ReviewView.frame.size.width,self.OrderItemsTableView.frame.size.height + self.Bgview.frame.size .height);
//            
//            self.scroll_items.frame = CGRectMake(self.scroll_items.frame.origin.x,self.AddView.frame.origin.y , self.scroll_items.frame.size.width, self.ReviewView.frame.size.height);
//                     
//       
          
           // self.scroll_items.contentSize = CGSizeMake(self.view.frame.size.width-50, self.ReviewView.frame.size.height);
                     
            for (int i = 0; i< [totalItemsArray count]; i++)
                {
           self.restaurantnameLabel.text = [NSString stringWithFormat:@"%@", [[totalItemsArray objectAtIndex:i] objectForKey:@"name"]];
                }
                
                int totalprice = 0;
                
                
                for (int i = 0; i< [totalItemsArray count]; i++)
                {
                    totalprice = totalprice + [[[totalItemsArray objectAtIndex:i] valueForKey:@"total_price"] intValue];
                }
                lblitemCost.text = [NSString stringWithFormat:@"%d.00",totalprice];
                     StrItemCos = [NSString stringWithFormat:@"%d.00",totalprice];
               
                     for (int i = 0; i< [totalItemsArray count]; i++)
                     {
                str_gst = [NSString stringWithFormat:@"%@", [[totalItemsArray objectAtIndex:i] objectForKey:@"gst_value"]];
                     }
                
                
                Gst =  ([str_gst floatValue] *totalprice)/100;
               
                gst = ceil(Gst);
                
                NSLog(@"rounded up %d",gst);
                
                lblgst.text = [NSString stringWithFormat:@"%d.00",gst+ rounded];
                     StrGst = [NSString stringWithFormat:@"%d.00",gst+ rounded];
                
                int subtotalvalue = gst + totalprice;
                     
                     
//                     if (![Utilities null_ValidationString:strvl])
//                     {
//                         strvl = @"0";
//                     }
//                     else
                    // {
                     for (int i = 0; i< [totalItemsArray count]; i++)
                     {
                          strvl = [NSString stringWithFormat:@"%@",[[[totalItemsArray  objectAtIndex:i] valueForKey:@"offer"] valueForKey:@"offer_value"]];
                     }
                   //  }
                     
                     
            float disc;
                    
            disc = ([strvl floatValue]* totalprice)/100;
            disco = ceil(disc);
                   
                
            finalTotal = subtotalvalue;

            lblsubTotal.text = [NSString stringWithFormat:@"%d.00",finalTotal];
                 StrSubTotal = [NSString stringWithFormat:@"%d.00",finalTotal];
                     
            lblDiscountsCost.text =  [NSString stringWithFormat:@"%d.00", disco + coupn];
                     StrDiscounts =  [NSString stringWithFormat:@"%d.00", disco + coupn];
                     
                     
                   
                     
      //  lblGrandTotalCost.text = [NSString stringWithFormat:@"%d.00",finalTotal + a + rounded- disco - coupn];
                StrGrandTotal  = [NSString stringWithFormat:@"%d.00",finalTotal + a + rounded- disco - coupn];
                     NSLog(@"%@StrGrandTotal",StrGrandTotal);

                     int Total = [StrGrandTotal intValue];
                     
                     
                        if ([WalletStr intValue]  == 0 ) {
                     
                            WalletMny.hidden = YES;
                            self.walletLbl.hidden = YES;
                            self.walletLineLbl.hidden = YES;
                            
                            
                        self.DelvryFeeLbl.frame = CGRectMake(self.DelvryFeeLbl.frame.origin.x, self.lblDiscount.frame.origin.y+ self.lblDiscount.frame.size.height + 10, self.DelvryFeeLbl.frame.size.width, self.DelvryFeeLbl.frame.size.height);
                            
                            
                        lblDeliveryChargeCost.frame = CGRectMake(lblDeliveryChargeCost.frame.origin.x, packagingMny.frame.origin.y+ packagingMny.frame.size.height + 10, lblDeliveryChargeCost.frame.size.width, lblDeliveryChargeCost.frame.size.height);
                            
                            
                         self.LinelBlDelivery.frame = CGRectMake(self.LinelBlDelivery.frame.origin.x, self.lblDiscount.frame.origin.y+ self.lblDiscount.frame.size.height + 35, self.LinelBlDelivery.frame.size.width, self.LinelBlDelivery.frame.size.height);
                            
                            
                            self.LblGrand.frame = CGRectMake(self.LblGrand.frame.origin.x, self.lblDiscount.frame.origin.y+ self.lblDiscount.frame.size.height + 40, self.LblGrand.frame.size.width, self.LblGrand.frame.size.height);
                            
                            
                        lblGrandTotalCost.frame = CGRectMake(lblGrandTotalCost.frame.origin.x, lblDiscountsCost.frame.origin.y+ lblDiscountsCost.frame.size.height +40,lblGrandTotalCost.frame.size.width, lblGrandTotalCost.frame.size.height);
                            
                            
                            lblGrandTotalCost.text = [NSString stringWithFormat:@"%d.00",finalTotal + a + rounded- disco - coupn- wallet];
                            
                           // if (PackingStr) {
                            
                                self.packagingLbl.frame = CGRectMake(self.packagingLbl.frame.origin.x, self.discountsLineLbl.frame.size.height+5+self.discountsLineLbl.frame.origin.y, self.discountsLineLbl.frame.size.width, self.packagingLbl.frame.size.height);
                                
                                self.packagingMny.frame = CGRectMake(self.packagingMny.frame.origin.x, self.discountsLineLbl.frame.size.height+5+self.discountsLineLbl.frame.origin.y, self.packagingMny.frame.size.width, self.packagingMny.frame.size.height);
                                
                                self.packagingLineLbl.frame = CGRectMake(self.packagingLineLbl.frame.origin.x, self.packagingLbl.frame.origin.y+self.packagingLbl.frame.size.height+5, self.packagingLineLbl.frame.size.width, self.packagingLineLbl.frame.size.height);
                                
                                self.DelvryFeeLbl.frame = CGRectMake(self.DelvryFeeLbl.frame.origin.x, self.packagingLineLbl.frame.origin.y+5, self.packagingLineLbl.frame.size.width
                                                                     , self.DelvryFeeLbl.frame.size.height);
                                
                                self.LinelBlDelivery.frame = CGRectMake(self.LinelBlDelivery.frame.origin.x, self.DelvryFeeLbl.frame.size.height +self.DelvryFeeLbl.frame.origin.y+5, self.LinelBlDelivery.frame.size.width, self.LinelBlDelivery.frame.size.height);
                                
                                self.LblGrand.frame = CGRectMake(self.LblGrand.frame.origin.x, self.LinelBlDelivery.frame.size.height+self.LinelBlDelivery.frame.origin.y+5, self.LblGrand.frame.size.width, self.LblGrand.frame.size.height);
                                
                                lblGrandTotalCost.frame = CGRectMake(lblGrandTotalCost.frame.origin.x, self.LinelBlDelivery.frame.size.height+self.LinelBlDelivery.frame.origin.y+5, lblGrandTotalCost.frame.size.width, lblGrandTotalCost.frame.size.height);
                            //}
//                            else
//                            {
//                                self.packagingLbl.hidden = YES;
//                                self.DelvryFeeLbl.frame = CGRectMake(self.DelvryFeeLbl.frame.origin.x, self.discountsLineLbl.frame.size.height+5+self.discountsLineLbl.frame.origin.y, self.DelvryFeeLbl.frame.size.width
//                                                                     , self.DelvryFeeLbl.frame.size.height);
//
//                                self.DeliveryChargeCost.frame = CGRectMake(self.DeliveryChargeCost.frame.origin.x, self.discountsLineLbl.frame.size.height+5+self.discountsLineLbl.frame.origin.y, self.DeliveryChargeCost.frame.size.width, self.DeliveryChargeCost.frame.size.height);
//
//                                self.LinelBlDelivery.frame = CGRectMake(self.LinelBlDelivery.frame.origin.x, self.DelvryFeeLbl.frame.size.height +self.DelvryFeeLbl.frame.origin.y+5, self.LinelBlDelivery.frame.size.width, self.LinelBlDelivery.frame.size.height);
//
//                                self.LblGrand.frame = CGRectMake(self.LblGrand.frame.origin.x, self.LinelBlDelivery.frame.size.height+self.LinelBlDelivery.frame.origin.y+5, self.LblGrand.frame.size.width, self.LblGrand.frame.size.height);
//
//                                lblGrandTotalCost.frame = CGRectMake(lblGrandTotalCost.frame.origin.x, self.LinelBlDelivery.frame.size.height+self.LinelBlDelivery.frame.origin.y+5, lblGrandTotalCost.frame.size.width, lblGrandTotalCost.frame.size.height);
//                            }
                            
                     
                        }
                     
                        else
                        {
                        WalletMny.hidden = NO;
                        self.walletLbl.hidden = NO;
                        self.walletLineLbl.hidden = NO;
                            
                            self.DelvryFeeLbl.frame = CGRectMake(5,251,143,21);
                            
                            
                            lblDeliveryChargeCost.frame = CGRectMake(285,251,85,21);
                            
                            
                            self.LinelBlDelivery.frame = CGRectMake(0,275,400,1);
                            
                            
                            self.LblGrand.frame = CGRectMake(5,280,143,20);
                            
                            
                            lblGrandTotalCost.frame = CGRectMake(285,280,85,20);
   
                     
                     if ([WalletStr intValue] > [StrGrandTotal intValue])
                     {
                       
                         lblGrandTotalCost.text = [NSString stringWithFormat:@"0.00"];
                         strWallet = [NSString stringWithFormat:@"%d",wallet - Total];
                         NSLog(@"%@strWallet",strWallet);
                         
                         _CouponcodeTxtfield.userInteractionEnabled = NO;
                         
                         
                        
                        
                         wallet_amount = [NSString stringWithFormat:@"%@",StrGrandTotal];
                         NSLog(@"%@wallet_amount",wallet_amount);
                         
                         
                         // if packaging charges are there
                         int packTotal = [PackingStr intValue];
                         if (packTotal == 0) {
                             self.packagingLbl.hidden = YES;
                             self.packagingLineLbl.hidden = YES;
                             self.GrandTotalCost.frame = CGRectMake(self.GrandTotalCost.frame.origin.x, self.walletLineLbl.frame.size.height + self.walletLineLbl.frame.origin.y+4, self.GrandTotalCost.frame.size.width, self.GrandTotalCost.frame.size.height);
                             
                             lblGrandTotalCost.frame = CGRectMake(lblGrandTotalCost.frame.origin.x, self.walletLineLbl.frame.size.height + self.walletLineLbl.frame.origin.y+4, lblGrandTotalCost.frame.size.width, lblGrandTotalCost.frame.size.height);
                         }
                         else
                         {
                             self.packagingLbl.hidden = NO;
                             
                             self.packagingLbl.frame = CGRectMake(self.packagingLbl.frame.origin.x, self.walletLineLbl.frame.origin.y+self.walletLineLbl.frame.size.height+4, self.packagingLbl.frame.size.width, self.packagingLbl.frame.size.height);
                             
                             self.packagingMny.frame =  CGRectMake(self.packagingMny.frame.origin.x, self.walletLineLbl.frame.origin.y+self.walletLineLbl.frame.size.height+4, self.packagingMny.frame.size.width, self.packagingMny.frame.size.height);
                             
                             
                         }
                     }
                     
                     else if ([WalletStr intValue] > 0 && [WalletStr intValue] < [StrGrandTotal intValue])
                     {
                         
                         StrTotalgrand =  [NSString stringWithFormat:@"%d.00",finalTotal + a + rounded- disco - coupn - wallet];
                         lblGrandTotalCost.text = StrTotalgrand;
                         NSLog(@"%@StrTotalgrand",StrTotalgrand);
                         int grand = [StrTotalgrand intValue];
                         
                         
                         strWallet = [NSString stringWithFormat:@"0.00"];
                         NSLog(@"%@strWallet",strWallet);
                            _CouponcodeTxtfield.userInteractionEnabled = YES;
                         
                         walletMoney = [NSString stringWithFormat:@"%d",wallet];
                         NSLog(@"%@walletMoney",walletMoney);

                        

                     }
                     
                      else if ([WalletStr intValue] == [StrGrandTotal intValue])
                     {
                         lblGrandTotalCost.text = [NSString stringWithFormat:@"%d.00",finalTotal + a + rounded- disco - coupn- wallet];
                         
                          _CouponcodeTxtfield.userInteractionEnabled = NO;
                        
                         walletNil = [NSString stringWithFormat:@"%@",WalletStr];
                         NSLog(@"%@walletNil",walletNil);
                         
                         
                     }
                            self.walletLbl.frame = CGRectMake(self.walletLbl.frame.origin.x, self.discountsLineLbl.frame.origin.y+self.discountsLineLbl.frame.size.height+5, self.walletLbl.frame.size.width, self.walletLbl.frame.size.height);
                            
                            self.walletLineLbl.frame = CGRectMake(self.walletLineLbl.frame.origin.x, self.walletLbl.frame.origin.x+self.walletLbl.frame.size.height, self.walletLineLbl.frame.size.width, self.walletLineLbl.frame.size.height);
                            
                            self.packagingLbl.frame = CGRectMake(self.packagingLbl.frame.origin.x, self.walletLineLbl.frame.size.height+5+self.walletLineLbl.frame.origin.y, self.discountsLineLbl.frame.size.width, self.packagingLbl.frame.size.height);
                            
                            self.packagingMny.frame = CGRectMake(self.packagingMny.frame.origin.x, self.discountsLineLbl.frame.size.height+5+self.discountsLineLbl.frame.origin.y, self.packagingMny.frame.size.width, self.packagingMny.frame.size.height);
                            
                            self.packagingLineLbl.frame = CGRectMake(self.packagingLineLbl.frame.origin.x, self.packagingLbl.frame.origin.y+self.packagingLbl.frame.size.height+5, self.packagingLineLbl.frame.size.width, self.packagingLineLbl.frame.size.height);
                            
                            self.DelvryFeeLbl.frame = CGRectMake(self.DelvryFeeLbl.frame.origin.x, self.packagingLineLbl.frame.origin.y+5, self.packagingLineLbl.frame.size.width
                                                                 , self.DelvryFeeLbl.frame.size.height);
                            
                            self.LinelBlDelivery.frame = CGRectMake(self.LinelBlDelivery.frame.origin.x, self.DelvryFeeLbl.frame.size.height +self.DelvryFeeLbl.frame.origin.y+5, self.LinelBlDelivery.frame.size.width, self.LinelBlDelivery.frame.size.height);
                            
                            self.LblGrand.frame = CGRectMake(self.LblGrand.frame.origin.x, self.LinelBlDelivery.frame.size.height+self.LinelBlDelivery.frame.origin.y+5, self.LblGrand.frame.size.width, self.LblGrand.frame.size.height);
                            
                            lblGrandTotalCost.frame = CGRectMake(lblGrandTotalCost.frame.origin.x, self.LinelBlDelivery.frame.size.height+self.LinelBlDelivery.frame.origin.y+5, lblGrandTotalCost.frame.size.width, lblGrandTotalCost.frame.size.height);
                }

                     
                
            [_OrderItemsTableView reloadData];
                     
                
                 });
                
            }
            
            if (boolUpdate == YES)
            {
                boolUpdate = NO;
                dispatch_async(dispatch_get_main_queue(), ^{

                [self reviewOrderServiceCall];
            strCartCountDisplay = [responseInfo objectForKey:@"cart_count"];
                
            NSLog(@"CartCount:%@",strCartCountDisplay);
            
            });
                
               
            }


            
            else if (isDelete == YES)
            {
                isDelete = NO;
                
                
                if (singleTonInstance.isFromOrders == YES)
                {
                    [USERDEFAULTS removeObjectForKey:@"seltctedRestLat"];
                    [USERDEFAULTS removeObjectForKey:@"seltctedRestLong"];
                    [USERDEFAULTS removeObjectForKey:@"seltctedRestGST"];
                    [USERDEFAULTS removeObjectForKey:@"establishment_id"];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else
                {
                [USERDEFAULTS removeObjectForKey:@"seltctedRestLat"];
                [USERDEFAULTS removeObjectForKey:@"seltctedRestLong"];
                [USERDEFAULTS removeObjectForKey:@"seltctedRestGST"];
                [USERDEFAULTS removeObjectForKey:@"establishment_id"];
                
                NSString *updateLabelString = [NSString stringWithFormat:@"%@",[responseInfo valueForKey:@"cart_count"]];
                // Posting the notification back to our sending view controller with the updateLabelString being the posted object
                [[NSNotificationCenter defaultCenter]postNotificationName:@"UpdateLabel" object:updateLabelString];
                NSLog(@"updateLabelString: %@",updateLabelString);

                [self.navigationController popViewControllerAnimated:YES];
                }
            }
            
            else if (iscouponcode == YES)
            {
                iscouponcode = NO;
                
                 CoupnApp = YES;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                
                DiscountsArr = [[NSMutableArray alloc]init];
                DiscountsArr = [responseInfo valueForKey:@"result"];
                
                if (singleTonInstance.isFromOrders == YES)
                {
                    
                    coupnStr = [NSString stringWithFormat:@"%@.00",[DiscountsArr valueForKey:@"coupon_amount"]];
                    
                    lblDiscountsCost.text = coupnStr;
                    
                    
                   lblGrandTotalCost.text = [NSString stringWithFormat:@"%@.00",[DiscountsArr valueForKey:@"grand_total"]];

                }
                else
                {
               
               coupnStr = [NSString stringWithFormat:@"%@.00",[DiscountsArr valueForKey:@"coupon_amount"]];
                
                    lblDiscountsCost.text = coupnStr;
                    
                    
                  coupn = [coupnStr intValue];
                    
                    
                      GrandTotal = finalTotal + a + rounded - wallet ;
                    
                     lblGrandTotalCost.text = [NSString stringWithFormat:@"%d.00",GrandTotal - coupn];
                          StrGrandTotal     =  [NSString stringWithFormat:@"%d.00",GrandTotal - coupn];
                    
                    
                    
                }
                   

                    
                });
                
                
            }

            
            else if(isaddress == YES)
            {
                isaddress = NO;
                arrAddressList = [[NSMutableArray alloc] init];
            

               arrAddressList = [responseInfo valueForKey:@"delivery_address_data"];
                [AddressTableView reloadData];
                [self reviewOrderServiceCall];
              
               
            }

            else if(isdelivery == YES)
                {
                   
                    if ([responseInfo valueForKey:@"result"])
                    {
                    addressSelectedStr =[NSString stringWithFormat:@"%@.00",[responseInfo valueForKey:@"result"]];
                        [USERDEFAULTS setObject:addressSelectedStr forKey:@"Addressresult"];
                        lblDeliveryChargeCost.text = addressSelectedStr;
                      
                    }
                    else
                    {
                        
                    lblDeliveryChargeCost.text = [NSString stringWithFormat:@"%@.00",[Utilities null_ValidationString:[responseInfo valueForKey:@"result"]]];
                        //StrDeliveryCost =  [NSString stringWithFormat:@"%@.00",[Utilities null_ValidationString:[responseInfo valueForKey:@"result"]]];
                        
                    }
                    
                 lblDiscountsCost.text =  [NSString stringWithFormat:@"%@.00",[Utilities null_ValidationString:[DiscountsArr valueForKey:@"coupon_amount"]]];
                
                lblDeliveryChargeCost.text = [USERDEFAULTS valueForKey:@"Addressresult"];
                    
                    
                    a = [[USERDEFAULTS valueForKey:@"Addressresult"] intValue];

                  
                   // int Delivery_gst = 5;
                    NSString * str = @"5";
                    
                    DeliveryCost =  ([str floatValue] * a)/100;
                    
                    rounded = ceil(DeliveryCost);
                    
                    NSLog(@"rounded value %d",rounded);

                    
                lblgst.text = [NSString stringWithFormat:@"%d.00",gst + rounded];
                    
                    GrandTotal = finalTotal + a + rounded ;
                    
                lblGrandTotalCost.text = [NSString stringWithFormat:@"%d.00",GrandTotal];
                        StrGrandTotal  = [NSString stringWithFormat:@"%d.00",GrandTotal];
                    

                                
            }
            
            
            
        });
        
    }


    else if ([[responseInfo valueForKey:@"status"] intValue] == 2)
    {
        
        if (iscouponcode == YES)
        {
            iscouponcode = NO;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *str = [NSString stringWithFormat:@"%@",[responseInfo valueForKey:@"result"]];
                [Utilities displayCustemAlertViewWithOutImage:str :self.view];
                
                
            });

        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
//                NSString *str = [NSString stringWithFormat:@"%@",[responseInfo valueForKey:@"response"]];
//                [Utilities displayCustemAlertViewWithOutImage:str :self.view];
                
                if ([[responseInfo valueForKey:@"response"]isEqualToString:@"No cart items found"])
                {
                    [USERDEFAULTS removeObjectForKey:@"seltctedRestLat"];
                    [USERDEFAULTS removeObjectForKey:@"seltctedRestLong"];
                    [USERDEFAULTS removeObjectForKey:@"seltctedRestGST"];
                    
                NSString *updateLabelString = @"0";
                // Posting the notification back to our sending view controller with the updateLabelString being the posted object
                [[NSNotificationCenter defaultCenter]postNotificationName:@"UpdateLabel" object:updateLabelString];
                    NSLog(@"updateLabelString",updateLabelString);

                    
                    [self.navigationController popViewControllerAnimated:YES];
                }

                 });
   
        }
        
    }
    else if ([[responseInfo valueForKey:@"status"] intValue] == 3)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *str = [NSString stringWithFormat:@"%@",[responseInfo valueForKey:@"result"]];
            [Utilities displayCustemAlertViewWithOutImage:str :self.view];
        });
    }
    else if ([[responseInfo valueForKey:@"status"] intValue] == 4)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *str = [NSString stringWithFormat:@"%@",[responseInfo valueForKey:@"result"]];
            [Utilities displayCustemAlertViewWithOutImage:str :self.view];
        });
    }
    else if ([[responseInfo valueForKey:@"status"] intValue] == 5)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *str = [NSString stringWithFormat:@"%@",[responseInfo valueForKey:@"result"]];
            [Utilities displayCustemAlertViewWithOutImage:str :self.view];
        });
    }
    
    else if ([[responseInfo valueForKey:@"status"] intValue] == 0)
    {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSString *str = [NSString stringWithFormat:@"%@",[responseInfo valueForKey:@"response"]];
//            [Utilities displayCustemAlertViewWithOutImage:str :self.view];
//        });
    }

    
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            [USERDEFAULTS removeObjectForKey:@"seltctedRestLat"];
            [USERDEFAULTS removeObjectForKey:@"seltctedRestLong"];
            [USERDEFAULTS removeObjectForKey:@"seltctedRestGST"];
           
            [self.navigationController popViewControllerAnimated:YES];
            
//            NSString *str = [NSString stringWithFormat:@"%@",[responseInfo valueForKey:@"result"]];
//            [Utilities displayCustemAlertViewWithOutImage:str :self.view];
//           
//            
//            
        });
       
    }
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [Utilities removeLoading:self.view];
    });
    

}

//action for add new btn
-(IBAction)getLocation:(id)sender
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddAddressManually *nearby = [storyboard instantiateViewControllerWithIdentifier:@"AddAddressManually"];
    [self.navigationController pushViewController:nearby animated:YES];
    
}

#pragma mark - TextField delegates
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up:YES withOffset:textField.frame.origin.y / 2];
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO withOffset:textField.frame.origin.y / 2];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


//text field animate
-(void)animateTextField:(UITextField*)textField up:(BOOL)up withOffset:(CGFloat)offset
{
    const int movementDistance = -offset;
    const float movementDuration = 0.4f;
    int movement = (up ? movementDistance : -movementDistance);
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}



@end
