//
//  PaymentMenuViewController.m
//  MealShack
//
//  Created by Prasad on 11/08/17.
//  Copyright © 2017 Possibillion. All rights reserved.
//

#import "PaymentMenuViewController.h"
#import "Utilities.h"
#import "Constants.h"
#import "ServiceManager.h"
#import "OrderConfirmationViewController.h"
#import "PaymentPageViewController.h"
#import <PlugNPlay/PlugNPlay.h>
#import "PayUMoneyViewController.h"
#import <CommonCrypto/CommonCrypto.h>
#import "SingleTon.h"




@interface PaymentMenuViewController ()<ServiceHandlerDelegate,UIAlertViewDelegate>
{
    BOOL * isCash;
    BOOL * isPayU;
    BOOL isdeletecart;
    NSDictionary *dictItems;
    NSString * OrderIdStr;
    BOOL *isAvailability;
    NSString * availabilityStr,*terminateStr, *adminTerm_status, *userStatus;
    NSDictionary *requestDict;
    NSString * walletamountStr, * walletStatusStr;
    NSString *strMIHPayID;
    SingleTon * singleToninstance;

    PnPUtility * payutils;
     
}

@end

@implementation PaymentMenuViewController
@synthesize PayumoneyBtn,cashondelivryBtn,strTotal,dictFinal,dic1;

#define Merchant_Key @"HJlfD6LO"
#define Salt @"WlnJMQL6B0"
#define Base_URL @"https://secure.payu.in"
#define Success_URL @"https://mobiletest.payumoney.com/mobileapp/payumoney/success.php"
#define Failure_URL @"https://mobiletest.payumoney.com/mobileapp/payumoney/failure.php"
#define Product_Info @"Food Items"



- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //////////////////

    singleToninstance=[SingleTon singleTonMethod];

    
    
    dictFinal = [[NSMutableDictionary alloc] init];
    [dictFinal setDictionary:dic1];
    
    NSMutableArray *arrLeftBarItems = [[NSMutableArray alloc] init];
    NSMutableArray* arrRightBarItems= [[NSMutableArray alloc] init];
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
    [btntitle setTitle:@"Payment" forState:UIControlStateNormal];
    btntitle.titleLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:18];
    btntitle.frame = CGRectMake(0, 0, 250, 22);
    btntitle.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btntitle setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    btntitle.showsTouchWhenHighlighted=YES;
    UIBarButtonItem *barButtonItem3 = [[UIBarButtonItem alloc] initWithCustomView:btntitle];
    [arrLeftBarItems addObject:barButtonItem3];
    btntitle.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    
    UIButton *btntitle1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btntitle1 setTitle:[NSString stringWithFormat:@"Rs.%@",strTotal] forState:UIControlStateNormal];
    btntitle1.titleLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:18];
    btntitle1.frame = CGRectMake(116, 22, 80, 25);
    btntitle1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btntitle1 setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    btntitle1.showsTouchWhenHighlighted=YES;
    UIBarButtonItem *barButtonItem1 = [[UIBarButtonItem alloc] initWithCustomView:btntitle1];
    [arrRightBarItems addObject:barButtonItem1];
    btntitle1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    
    
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationItem.leftBarButtonItems = arrLeftBarItems;
    self.navigationItem.rightBarButtonItems = arrRightBarItems;
    
    
    btncontinue.hidden = YES;
//    just once
    if ([strTotal intValue] == 0)
    {
        PayumoneyBtn.hidden = YES;
        self.payuImg.hidden = YES;
    }
    else
    {
          PayumoneyBtn.hidden = NO;
          self.payuImg.hidden = NO;
    }

    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
   
    
    if (self.isValue == YES)
    {
        [dictFinal setDictionary:[USERDEFAULTS valueForKey:@"totalDic"]];

    }
}


-(void)Back_Click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)CashonDelivery:(id)sender
{
    
    isCash = YES;
    isPayU = NO;
    btncontinue.hidden = NO;
    [dictFinal setObject:@"COD" forKey:@"payment_mode"];
    [cashondelivryBtn setTitleColor:REDCOLOR forState:UIControlStateNormal];
    [PayumoneyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
      [self restaurantAvailabilityService];
 

}

- (IBAction)PayUMoney:(id)sender
{

    isCash = NO;
    isPayU = YES;
    btncontinue.hidden = NO;
    [dictFinal setObject:@"pay by card" forKey:@"payment_mode"];
    
    [USERDEFAULTS setObject:dic1 forKey:@"totalDic"];
    
    [PayumoneyBtn setTitleColor:REDCOLOR forState:UIControlStateNormal];
    [cashondelivryBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
      [self restaurantAvailabilityService];

    

}

- (IBAction)ContinueButton_Clicked:(id)sender
{
    
    
    if (([strTotal integerValue]>1000)&& isCash==YES)
    {
        [Utilities displayCustemAlertViewWithOutImage:@"COD not available for this amount" :self.view];
    }
    
    
   else if([availabilityStr isEqualToString:@"0"] || [terminateStr isEqualToString:@"0"] || [adminTerm_status isEqualToString:@"1"])
    {
        
      
        [Utilities displayCustemAlertViewWithOutImage:@"Restaurant not available" :self.view];

        
    }
    
    else if ([userStatus isEqualToString:@"1"])
    {
        [Utilities displayCustemAlertViewWithOutImage:@"your account is blocked" :self.view];

    }
   
   else
   {
       
       if (isPayU==YES) {
           int i = arc4random() % 9999999999;
           
           NSString *strHash = [self createSHA512:[NSString stringWithFormat:@"%d%@",i,[NSDate date]]];// Generatehash512(rnd.ToString() + DateTime.Now);
           PUMTxnParam *txnParam= [[PUMTxnParam alloc] init];
           txnParam.phone = [Utilities getPhoneno];
           txnParam.email = [Utilities getEmail];
           txnParam.amount = strTotal;
           
         //  txnParam.amount = strTotal;
           
           //Bharat
           strTotal = txnParam.amount;
           
           txnParam.firstname = [Utilities getName];
           txnParam.key = Merchant_Key;
           txnParam.merchantid = txnParam.environment == PUMEnvironmentProduction ? @"4914106" : @"397202";
           txnParam.txnID = [strHash substringToIndex:20];
           
           //Bharat
           strMIHPayID = txnParam.txnID;
           
           txnParam.surl = Success_URL;
           txnParam.furl = Failure_URL;
           txnParam.productInfo = PRODUCT_INFO;
           
           txnParam.udf1 = @"as";
           txnParam.udf2 = @"sad";
           txnParam.udf3 = @"";
           txnParam.udf4 = @"";
           txnParam.udf5 = @"";
           txnParam.udf6 = @"";
           txnParam.udf7 = @"";
           txnParam.udf8 = @"";
           txnParam.udf9 = @"";
           txnParam.udf10 = @"";
           txnParam.hashValue = [self getHashForPaymentParams:txnParam];
          
//           NSString *hashValue = [NSString stringWithFormat:@"%@|%@|%@|%@|%@|%@|||||||||||%@",key,txnid,amount,productInfo,firstname,email,Salt];
//           NSString *hash = [self createSHA512:hashValue];
           
           
           [self testPaymentWithParams:txnParam andSource:self];
          [self OrderServiceCall];
           
           
           
           [PlugNPlay presentPaymentViewControllerWithTxnParams:txnParam onViewController:self withCompletionBlock:^(NSDictionary *paymentResponse, NSError *error, id extraParam) {
               
               NSString * surl = [Utilities null_ValidationString:[[paymentResponse valueForKey:@"result"] valueForKey:@"postUrl"]];
               
               if ([Success_URL isEqualToString:surl])
               {
                   NSLog(@" - - - payment success url - - - ");
                   
                   
             // [self performSelector:@selector(delayedDidFinish:) withObject:getStringFromUrl afterDelay:0.0];
                   [self delayedDidFinish:surl];
                   
               }
               else
               {
                   NSLog(@" - - - payment failure url - - - ");
                   UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Sorry !!!" message:@"Your transaction failed. Please try again!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                   alert.tag = 1;
                   [alert show];
               }
               
               NSLog(@"success response params are %@",paymentResponse);
           }];
       }
       else
       {
           OrderConfirmationViewController * order = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"OrderConfirmationViewController"];

           [self.navigationController pushViewController:order animated:YES];

            [self OrderServiceCall];

       }
       
       
   
   
   }
}


// NSDictionary *parameters = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:txnid1,key,amount,productInfo,firstname,email,phone,Success_URL,Failure_URL,hash,serviceprovider
//, nil] forKeys:[NSArray arrayWithObjects:@"txnid",@"key",@"amount",@"productinfo",@"firstname",@"email",@"phone",@"surl",@"furl",@"hash",@"service_provider", nil]];



//TODO: get rid of this function for test environemnt
-(NSString*)getHashForPaymentParams:(PUMTxnParam*)txnParam {
    NSString *salt =  Salt;
    NSString *hashSequence = [NSString stringWithFormat:@"%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@",txnParam.key,txnParam.txnID,txnParam.amount,txnParam.productInfo,txnParam.firstname,txnParam.email,txnParam.udf1,txnParam.udf2,txnParam.udf3,txnParam.udf4,txnParam.udf5,txnParam.udf6,txnParam.udf7,txnParam.udf8,txnParam.udf9,txnParam.udf10, salt];
    
    NSString *hash = [[[[[self createSHA512:hashSequence] description]stringByReplacingOccurrencesOfString:@"<" withString:@""]stringByReplacingOccurrencesOfString:@">" withString:@""]stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return hash;
}

- (NSString*) createSHA512:(NSString *)source {
    
    const char *s = [source cStringUsingEncoding:NSASCIIStringEncoding];
    
    NSData *keyData = [NSData dataWithBytes:s length:strlen(s)];
    
    uint8_t digest[CC_SHA512_DIGEST_LENGTH] = {0};
    
    CC_SHA512(keyData.bytes, (CC_LONG)keyData.length, digest);
    
    NSData *output = [NSData dataWithBytes:digest length:CC_SHA512_DIGEST_LENGTH];
    NSLog(@"Hash output --------- %@",output);
    NSString *hash =  [[[[output description]stringByReplacingOccurrencesOfString:@"<" withString:@""]stringByReplacingOccurrencesOfString:@">" withString:@""]stringByReplacingOccurrencesOfString:@" " withString:@""];
    return hash;
}


- (void)testPaymentWithParams:(PUMTxnParam*)params andSource:(UIViewController*)source {
    PayUMoneyViewController *payVC = [[PayUMoneyViewController alloc] init];
    
    [payVC payMethodWithParams:params source:source];
}


- (void)delayedDidFinish:(NSString *)getStringFromUrl {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableDictionary *mutDictTransactionDetails = [[NSMutableDictionary alloc] init];
        [mutDictTransactionDetails setObject:strMIHPayID forKey:@"Transaction_ID"];
        [mutDictTransactionDetails setObject:@"Success" forKey:@"Transaction_Status"];
        [mutDictTransactionDetails setObject:[Utilities getName] forKey:@"Payee_Name"];
        [mutDictTransactionDetails setObject:Product_Info forKey:@"Product_Info"];
        [mutDictTransactionDetails setObject:strTotal forKey:@"Paid_Amount"];
        
        
        [self transactionServiceCall];
        
        [self navigateToOrderConfirmationScreen:mutDictTransactionDetails];
    });
}


- (void)navigateToOrderConfirmationScreen: (NSMutableDictionary *)mutDictTransactionDetails
{
    dispatch_async(dispatch_get_main_queue(), ^{
        OrderConfirmationViewController *confirm = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"OrderConfirmationViewController"];
        confirm.mutDictTransactionDetails = mutDictTransactionDetails;
        confirm.totaldict = _totaldict;
        [self.navigationController pushViewController:confirm animated:YES];
    });
}




-(void)restaurantAvailabilityService
{
    [self.view endEditing:YES];
    
    if ([Utilities isInternetConnectionExists]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
        });
        
        
        NSString *urlStr = [NSString stringWithFormat:@"%@restaurantAvailability",BASEURL];
        requestDict = @{
                        
                        @"establishment_id":[NSString stringWithFormat:@"%@",[dictFinal valueForKey:@"establishment_id"]]
                        
                        };
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            ServiceManager *service = [ServiceManager sharedInstance];
            service.delegate = self;
            
          
            isAvailability = YES;
            [service  handleRequestWithDelegates:urlStr info:requestDict];
            // [self uploadImagetoServer:urlStr];
            
        });
        
        
    }
    else
    {
        [Utilities displayCustemAlertViewWithOutImage:@"Internet connection error" :self.view];
    }

}

-(void)OrderServiceCall
{
    [self.view endEditing:YES];
    
   
    
    if ([Utilities isInternetConnectionExists]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
        });
        
        
        NSString *urlStr = [NSString stringWithFormat:@"%@addorder_items",BASEURL];
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            ServiceManager *service = [ServiceManager sharedInstance];
            service.delegate = self;
            
            
            [service  handleRequestWithDelegates:urlStr info:dictFinal];
            // [self uploadImagetoServer:urlStr];
            
        });
        
        
    }
    else
    {
        [Utilities displayCustemAlertViewWithOutImage:@"Internet connection error" :self.view];
    }
    
    
}

-(void)deleteCartServiceCall
{
    [self.view endEditing:YES];
    
    if ([Utilities isInternetConnectionExists]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
        });
        
        isdeletecart = YES;
        NSString *urlStr = [NSString stringWithFormat:@"%@deleteCartItems",BASEURL];
        NSDictionary *requestDict;
        requestDict = @{
                        @"user_id":[Utilities getUserID],
                        @"establishment_id":[NSString stringWithFormat:@"%@",[dictFinal valueForKey:@"establishment_id"]]
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






-(void)transactionServiceCall
{
    [self.view endEditing:YES];
    
    if ([Utilities isInternetConnectionExists]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
        });
        
        
        NSString *urlStr = [NSString stringWithFormat:@"%@add_transaction",BASEURL];
        requestDict = @{
                        @"order_id":OrderIdStr,
                        @"transaction_id": strMIHPayID,
                        @"wallet_status":walletStatusStr,
                        @"wallet_amount":walletamountStr
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
            
            
            if (isdeletecart == YES)
            {
                isdeletecart = NO;
                
                
                if (isCash == YES)
                {
                   
//                    OrderConfirmationViewController * confirm = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"OrderConfirmationViewController"];
//                    confirm.totaldict = dictItems ;
//                    
//                    [self.navigationController pushViewController:confirm animated:YES];
                }
                else if (isPayU == YES)
                {
                   
                   // PaymentPageViewController* payment = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"PaymentPageViewController"];
//                    payment.strTotal = strTotal;
//                    payment.totaldict = dictItems ;
//                    payment.OrderIdStr = OrderIdStr;
//                    payment.walletamountStr = walletamountStr;
//                    payment.walletStatusStr = walletStatusStr;
                    
                  //  [self.navigationController pushViewController:payment animated:YES];
                }
                
            }
            
            else if (isAvailability == YES)
            {
                isAvailability = NO;
                
                availabilityStr = [NSString stringWithFormat:@"%@",[responseInfo objectForKey:@"availability"]];
                terminateStr = [NSString stringWithFormat:@"%@",[responseInfo valueForKey:@"terminate_status"]];
                adminTerm_status = [NSString stringWithFormat:@"%@",[responseInfo valueForKey:@"admin_terminate_status"]];
                userStatus = [NSString stringWithFormat:@"%@",[responseInfo valueForKey:@"user_status"]];
                
                
//                if ([availabilityStr isEqualToString:@"1"] && [terminateStr isEqualToString:@"1"] && [adminTerm_status isEqualToString:@"0"])
//                {
//                    
//                   btncontinue.hidden = NO;
//                    
//                }
//                else
//                {
//                    
//                    [Utilities displayCustemAlertViewWithOutImage:@"Restaurant Not Available" :self.view];
//                }
 
            }
            else
            {
                
                dictItems = responseInfo ;
                OrderIdStr = [NSString stringWithFormat:@"%d",[[responseInfo valueForKey:@"order_id"] intValue]];
                singleToninstance.orderIdStr = OrderIdStr;
                walletamountStr = [responseInfo valueForKey:@"wallet_amount"];
                walletStatusStr = [responseInfo valueForKey:@"wallet_status"];
                
                [self deleteCartServiceCall];
            }
            
            
            
            
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

//- (NSString*) createSHA512:(NSString *)source {
//
//    const char *s = [source cStringUsingEncoding:NSASCIIStringEncoding];
//
//    NSData *keyData = [NSData dataWithBytes:s length:strlen(s)];
//
//    uint8_t digest[CC_SHA512_DIGEST_LENGTH] = {0};
//
//    CC_SHA512(keyData.bytes, (CC_LONG)keyData.length, digest);
//
//    NSData *output = [NSData dataWithBytes:digest length:CC_SHA512_DIGEST_LENGTH];
//    NSLog(@"Hash output --------- %@",output);
//    NSString *hash =  [[[[output description]stringByReplacingOccurrencesOfString:@"<" withString:@""]stringByReplacingOccurrencesOfString:@">" withString:@""]stringByReplacingOccurrencesOfString:@" " withString:@""];
//    return hash;
//}

@end
