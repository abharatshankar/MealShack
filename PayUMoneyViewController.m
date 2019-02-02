//
//  ViewController.m
//  FirstPayUMoney
//
//  Created by Prasad on 17/05/18.
//  Copyright © 2018 Possibillion. All rights reserved.
//

#import "PayUMoneyViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import <PlugNPlay/PlugNPlay.h>

#define SCROLLVIEW_HEIGHT 600
#define SCROLLVIEW_WIDTH 320

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface PayUMoneyViewController ()<UIScrollViewDelegate>{
    UITextField *fieldInAction;
    UITextField *activeField;

    CGPoint offset;
    NSString *email;
    NSString *mobile;
    NSString *amount;
    NSString *billUrl;
    NSString *returnUrl;
}

@end

@implementation PayUMoneyViewController
@synthesize  tfEmail,tfMobile,tfAmount;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self fetchRememberedDetails];
    
    UITapGestureRecognizer *tapScroll = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)];
    tapScroll.cancelsTouchesInView = YES;
   
    
    tfEmail.delegate = tfMobile.delegate = tfAmount.delegate = self;
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont systemFontOfSize:15 weight:UIFontWeightThin], NSFontAttributeName,
                                nil];
    

    [self getTxnParam];
    
}


// over
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // [self keyBoardNotification];
    [self registerForKeyboardNotifications];
    
    
    if ([PayUMoneyCoreSDK isUserSignedIn]) {
    }
}


//over
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



#pragma mark - User Actions

- (void)payMethodWithParams:(PUMTxnParam*)txnParam source:(UIViewController*)source {
    //[tfAmount resignFirstResponder];
    //[tfMobile resignFirstResponder];
    //[tfEmail resignFirstResponder];
    
    
    //PUMTxnParam * txnParam = [self getTxnParam];
    [self rememberEnteredDetails];
    
    [PlugNPlay presentPaymentViewControllerWithTxnParams:txnParam onViewController:source withCompletionBlock:^(NSDictionary *paymentResponse, NSError *error, id extraParam)
     {
         if (error)
         {
             [UIUtility toastMessageOnScreen:[error localizedDescription]];
         } else {
             
             NSString *message;
             
             if ([paymentResponse objectForKey:@"result"] && [[paymentResponse objectForKey:@"result"] isKindOfClass:[NSDictionary class]] )
             {
                 
                 message = [[paymentResponse objectForKey:@"result"] valueForKey:@"error_Message"];
                 
                 if ([message isEqual:[NSNull null]] || [message length] == 0 || [message isEqualToString:@"No Error"])
                 {
                     
                     message = [[paymentResponse objectForKey:@"result"] valueForKey:@"status"];
                     
                 }
                 
             }
             
             else {
                 
                 message = [paymentResponse valueForKey:@"status"];
                 
             }
             
             [UIUtility toastMessageOnScreen:message];
             
         }
         
     }];
    
}


- (IBAction)pay:(id)sender
{
    [tfAmount resignFirstResponder];
    [tfMobile resignFirstResponder];
    [tfEmail resignFirstResponder];
    
    
    PUMTxnParam * txnParam = [self getTxnParam];
    [self rememberEnteredDetails];
    
    [PlugNPlay presentPaymentViewControllerWithTxnParams:txnParam onViewController:self withCompletionBlock:^(NSDictionary *paymentResponse, NSError *error, id extraParam)
    {
    if (error)
    {
        [UIUtility toastMessageOnScreen:[error localizedDescription]];
    } else {
        
        NSString *message;
        
        if ([paymentResponse objectForKey:@"result"] && [[paymentResponse objectForKey:@"result"] isKindOfClass:[NSDictionary class]] )
        {
            
            message = [[paymentResponse objectForKey:@"result"] valueForKey:@"error_Message"];
            
            if ([message isEqual:[NSNull null]] || [message length] == 0 || [message isEqualToString:@"No Error"])
            {
                
                message = [[paymentResponse objectForKey:@"result"] valueForKey:@"status"];
                
            }
            
        }
        
        else {
            
            message = [paymentResponse valueForKey:@"status"];
            
        }
        
        [UIUtility toastMessageOnScreen:message];
        
    }
        
    }];
    
}
- (void)tapped {
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0, 0, 0, 0);
   
    [self.view endEditing:YES];
}
#pragma mark - Touch events handling
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [tfEmail resignFirstResponder];
    [tfMobile resignFirstResponder];
    [tfAmount resignFirstResponder];
}

#pragma mark - UITextField Delegates
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    //    LogTrace(@"You entered textFieldShouldReturn %@",textField.text);
    [textField resignFirstResponder];
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(50, 0, 0, 0);
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    //    LogTrace(@"You entered textFieldDidEndEditing %@",textField.text);
    if(fieldInAction.tag > 5){
        textField.backgroundColor = UIColorFromRGB([self intFromHexString:textField.text]);
    }
    [textField resignFirstResponder];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    fieldInAction = textField;
    activeField = textField;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if(textField.tag > 5)
    {
        if(textField.text.length >=6 && string.length > 0){
            
            return NO;
        }
        NSString *finalColorString;
        
        if(string.length > 0){
            finalColorString= [NSString stringWithFormat:@"%@%@",textField.text,string ];
            
        }else{
            finalColorString = [textField.text stringByReplacingCharactersInRange:range withString:string];
            ;
        }
        textField.backgroundColor = UIColorFromRGB([self intFromHexString:finalColorString]);
        
        if (textField.tag == 9)
        {
        }else if (textField.tag == 8)
        {
        }else if (textField.tag == 7)
        {
        }else{
            [_btnPayment setTitleColor: UIColorFromRGB([self intFromHexString:finalColorString]) forState:UIControlStateNormal];
        }
    } else if(textField.tag == 5){
        NSString *finalMerchantName ;
        if(string.length > 0){
            finalMerchantName= [NSString stringWithFormat:@"%@%@",textField.text,string ];
            
        } else {
            finalMerchantName = [textField.text stringByReplacingCharactersInRange:range withString:string];
        }
    }
    return YES;
}

#pragma mark - Helper methods

-(PUMTxnParam*)getTxnParam{
    PUMTxnParam *txnParam= [[PUMTxnParam alloc] init];
    
    //Pass these parameters
//    txnParam.phone = tfMobile.text;
//    txnParam.email = tfEmail.text;
//    txnParam.amount = tfAmount.text;
    txnParam.phone = _mobile;
    txnParam.email = _email;
    txnParam.amount = _amount;
    txnParam.firstname = @"UserFirstName";
    txnParam.key = txnParam.environment == PUMEnvironmentProduction ? @"mdyCKV" : @"Aqryi8";
    txnParam.merchantid = txnParam.environment == PUMEnvironmentProduction ? @"4914106" : @"397202";
    txnParam.txnID = @"12";
    txnParam.surl = @"https://www.payumoney.com/mobileapp/payumoney/success.php";
    txnParam.furl = @"https://www.payumoney.com/mobileapp/payumoney/failure.php";
    txnParam.productInfo = @"iPhone7";
    
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
    //    params.hashValue = @"FDBE365FCE1133A9D7091BEE25D032910B7CE8C2F1AA02F86179209EF4A1652CCB35159ECAEFEDD8DE404E2B27809F0B487749DC8DBD9D264E52142B6D3C3270";
    return txnParam;
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

- (void)fetchRememberedDetails {
    email = [[NSUserDefaults standardUserDefaults] valueForKey:@"EMAIL"];
    amount = [[NSUserDefaults standardUserDefaults] valueForKey:@"AMOUNT"];
    mobile = [[NSUserDefaults standardUserDefaults] valueForKey:@"MOBILE"];
    id selectedSegmentIndex = [[NSUserDefaults standardUserDefaults] valueForKey:@"ENVIRONMENT"];
    if (email.length != 0) {
        tfEmail.text = email;
    }  if (amount.length != 0) {
        tfAmount.text = amount;
    }  if (mobile.length != 0) {
        tfMobile.text = mobile;
    }
}
- (void)rememberEnteredDetails {
    [[NSUserDefaults standardUserDefaults] setValue:tfAmount.text forKey:@"AMOUNT"];
    [[NSUserDefaults standardUserDefaults] setValue:tfEmail.text forKey:@"EMAIL"];
    [[NSUserDefaults standardUserDefaults] setValue:tfMobile.text forKey:@"MOBILE"];
}

//TODO: get rid of this function for test environemnt
-(NSString*)getHashForPaymentParams:(PUMTxnParam*)txnParam {
    NSString *salt = txnParam.environment == PUMEnvironmentProduction? @"Je7q3652" : @"ZRC9Xgru";
    NSString *hashSequence = [NSString stringWithFormat:@"%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@",txnParam.key,txnParam.txnID,txnParam.amount,txnParam.productInfo,txnParam.firstname,txnParam.email,txnParam.udf1,txnParam.udf2,txnParam.udf3,txnParam.udf4,txnParam.udf5,txnParam.udf6,txnParam.udf7,txnParam.udf8,txnParam.udf9,txnParam.udf10, salt];
    
    NSString *hash = [[[[[self createSHA512:hashSequence] description]stringByReplacingOccurrencesOfString:@"<" withString:@""]stringByReplacingOccurrencesOfString:@">" withString:@""]stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return hash;
}


///over
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
@end
