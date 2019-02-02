//
//  ViewController.m
//  PaymentGateway
//
//  Created by Suraj on 22/07/15.
//  Copyright (c) 2015 Suraj. All rights reserved.
//

#import "PaymentPageViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import "OrderConfirmationViewController.h"
#import "PaymentMenuViewController.h"
#import "Utilities.h"
#import "ReviewOrderViewController.h"
#import "ServiceManager.h"
#import "Constants.h"
#import <PlugNPlay/PlugNPlay.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface PaymentPageViewController () <UIWebViewDelegate, UIAlertViewDelegate,ServiceHandlerDelegate>
{
    UIActivityIndicatorView *activityIndicatorView;
    NSString *strMIHPayID;
     NSDictionary *requestDict;
    
    UITextField *fieldInAction;
    UITextField *activeField;
    BOOL keyboardVisible;
    CGPoint offset;
    NSString *email;
    NSString *mobile;
    NSString *amount;
    NSString *billUrl;
    NSString *returnUrl;
   
}

@property (nonatomic, weak) IBOutlet UIWebView *webviewPaymentPage;

@end

@implementation PaymentPageViewController
@synthesize  strTotal,totaldict,OrderIdStr,walletStatusStr,walletamountStr;


//live keys
#define Merchant_Key @"HJlfD6LO"
#define Salt @"WlnJMQL6B0"
#define Base_URL @"https://secure.payu.in"
#define Success_URL @"https://mobiletest.payumoney.com/mobileapp/payumoney/success.php"
#define Failure_URL @"https://mobiletest.payumoney.com/mobileapp/payumoney/failure.php"
#define Product_Info @"Food Items"
//#define Paid_Amount @"1549.00"
//#define Payee_Name @"Gayatri"

- (void)viewDidLoad {
    [super viewDidLoad];
    
    activityIndicatorView = [[UIActivityIndicatorView alloc] init];
    activityIndicatorView.center = self.view.center;
    [activityIndicatorView setColor:[UIColor blackColor]];
    [self.view addSubview:activityIndicatorView];
    
    
    NSMutableArray *arrLeftBarItems = [[NSMutableArray alloc] init];
    UIButton *btnLib1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnLib1 setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    btnLib1.frame = CGRectMake(0, 0, 22, 22);
    btnLib1.showsTouchWhenHighlighted=YES;
    UIBarButtonItem *barButtonItem2 = [[UIBarButtonItem alloc] initWithCustomView:btnLib1];
    [arrLeftBarItems addObject:barButtonItem2];
    [btnLib1 addTarget:self action:@selector(Back_Click:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItems = arrLeftBarItems;
    
    
    
    
    //[self fetchRememberedDetails];
    
    UITapGestureRecognizer *tapScroll = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)];
    tapScroll.cancelsTouchesInView = YES;
    
    
    
    
    keyboardVisible = NO;
   // tfEmail.delegate = tfMobile.delegate = tfAmount.delegate = self;
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont systemFontOfSize:15 weight:UIFontWeightThin], NSFontAttributeName,
                                nil];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // [self keyBoardNotification];
     [self registerForKeyboardNotifications];
    keyboardVisible = NO;
    
    if ([PayUMoneyCoreSDK isUserSignedIn]) {
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



#pragma mark - Keyboard handling

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeShown:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}



- (void)keyboardWillBeShown:(NSNotification*)notification {
    NSDictionary *info = notification.userInfo;
    CGSize value = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0, 0, value.height, 0);
    
    CGRect aRect = self.view.frame;
    aRect.size.height  -= value.height;
    
    CGRect activeTextFieldRect = activeField.frame;
    CGPoint activeTextFieldOrigin = activeTextFieldRect.origin;
    if (!CGRectContainsPoint(activeTextFieldRect, activeTextFieldOrigin)) {
    }
}


- (void)keyboardWillBeHidden:(NSNotification*)notification {
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    
    keyboardVisible = false;
}

-(void)Back_Click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma UIWebView - Delegate Methods
-(void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"WebView started loading");
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [activityIndicatorView stopAnimating];
    
    if (webView.isLoading) {
        return;
    }
    
    NSURL *requestURL = [[_webviewPaymentPage request] URL];
    NSLog(@"WebView finished loading with requestURL: %@",requestURL);
    
    NSString *getStringFromUrl = [NSString stringWithFormat:@"%@",requestURL];
    
    if ([self containsString:getStringFromUrl :Success_URL]) {
        [self performSelector:@selector(delayedDidFinish:) withObject:getStringFromUrl afterDelay:0.0];
    } else if ([self containsString:getStringFromUrl :Failure_URL]) {
        // FAILURE ALERT
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Sorry !!!" message:@"Your transaction failed. Please try again!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        alert.tag = 1;
        [alert show];
    }
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [activityIndicatorView stopAnimating];
    NSURL *requestURL = [[_webviewPaymentPage request] URL];
    NSLog(@"WebView failed loading with requestURL: %@ with error: %@ & error code: %ld",requestURL, [error localizedDescription], (long)[error code]);
    if (error.code == -1009 || error.code == -1003 || error.code == -1001) { //error.code == -999
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops !!!" message:@"Please check your internet connection!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        alert.tag = 1;
        [alert show];
    }
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

#pragma UIAlertView - Delegate Method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1 && buttonIndex == 0) {
        // Navigate to Payment Status Screen
        NSMutableDictionary *mutDictTransactionDetails = [[NSMutableDictionary alloc] init];
        [mutDictTransactionDetails setObject:[Utilities getName] forKey:@"Payee_Name"];
        [mutDictTransactionDetails setObject:Product_Info forKey:@"Product_Info"];
        [mutDictTransactionDetails setObject:strTotal forKey:@"Paid_Amount"];
        [mutDictTransactionDetails setObject:strMIHPayID forKey:@"Transaction_ID"];
        [mutDictTransactionDetails setObject:@"Failed" forKey:@"Transaction_Status"];
        
        [self navigateToPaymentMenuScreen:mutDictTransactionDetails];
    }
}

- (BOOL)containsString: (NSString *)string : (NSString*)substring {
    return [string rangeOfString:substring].location != NSNotFound;
}

- (void)navigateToOrderConfirmationScreen: (NSMutableDictionary *)mutDictTransactionDetails {
    dispatch_async(dispatch_get_main_queue(), ^{
        OrderConfirmationViewController *confirm = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"OrderConfirmationViewController"];
       confirm.mutDictTransactionDetails = mutDictTransactionDetails;
        confirm.totaldict = totaldict;
        [self.navigationController pushViewController:confirm animated:YES];
    });
}

- (void)navigateToPaymentMenuScreen:(NSMutableDictionary *)mutDictTransactionDetails {
    dispatch_async(dispatch_get_main_queue(), ^{
       PaymentMenuViewController *menu = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PaymentMenuViewController"];
        menu.mutDictTransactionDetails = mutDictTransactionDetails;
        menu.strTotal= strTotal;
       
        menu.isValue = YES;

        [self.navigationController pushViewController:menu animated:YES];
        
    });
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

- (NSString *)getRandomString:(NSInteger)length
{
    NSMutableString *returnString = [NSMutableString stringWithCapacity:length];
    NSString *numbers = @"0123456789";
    // First number cannot be 0
    [returnString appendFormat:@"%C", [numbers characterAtIndex:(arc4random() % ([numbers length]-1))+1]];
    
    for (int i = 1; i < length; i++) {
        [returnString appendFormat:@"%C", [numbers characterAtIndex:arc4random() % [numbers length]]];
    }
    return returnString;
}

- (unsigned int)intFromHexString:(NSString *)hexStr
{
    unsigned int hexInt = 0;
    // Create scanner
    NSScanner *scanner = [NSScanner scannerWithString:hexStr];
    // Tell scanner to skip the # character
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
    // Scan hex value
    [scanner scanHexInt:&hexInt];
    
    return hexInt;
}

@end
