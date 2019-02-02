//
//  OtpViewController.m
//  MealShack
//
//  Created by Prasad on 20/07/17.
//  Copyright © 2017 Possibillion. All rights reserved.
//

#import "OtpViewController.h"
#import "SignUpViewController.h"
#import "Utilities.h"
#import "Constants.h"
#import "ServiceManager.h"
#import "SingleTon.h"
#import "RestaurantsViewController.h"
#import "SideMenuViewController.h"
#import "SWRevealViewController.h"

@interface OtpViewController ()<ServiceHandlerDelegate,UITextFieldDelegate>

{
    SingleTon * singletonInstance;
    BOOL * isResend;
    NSString *strotp;
    NSString* user_id;
    NSDictionary *requestDict;
    NSTimer *timer;
    NSInteger currMinute,currSeconds;
    BOOL * isResendfromEdit, * isdone;
    NSString * CodeStr;
}
@property (strong, nonatomic) NSMutableArray *array;
@end

@implementation OtpViewController
@synthesize ProgressLbl;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.hidden = YES;
    
     singletonInstance = [SingleTon singleTonMethod];
    
  
    
    if (singletonInstance.isFromEdit == YES)
    {
        self.numberLabel.text = [NSString stringWithFormat:@"%@",[Utilities getchangedPhoneno]];
          NSLog(@"responseInfo :%@",[NSString stringWithFormat:@"%@",[Utilities getchangedPhoneno]]);
    }
    else
    {
          self.numberLabel.text = [NSString stringWithFormat:@"%@",[Utilities getPhoneno]];
          NSLog(@"responseInfo :%@",[NSString stringWithFormat:@"%@",[Utilities getPhoneno]]);
    }

  
    
    // to display mobile number
    SignUpViewController * signupVC = [[SignUpViewController alloc]init];
    
    signupVC.mobileNumberText.text = self.numberLabel.text;
    
    
    _resendOtpBtn.alpha = 0.2;

    _resendOtpBtn.userInteractionEnabled = NO;
    // Do any additional setup after loading the view.
    ProgressLbl.hidden = NO;
    
    [ProgressLbl setText:@"Wait : 30 sec"];
   // currMinute=1;
    currSeconds=30;
    [self start];
}



-(void)start
{
    timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    
}
-(void)timerFired
{
    
    @try {
        if((currMinute>0 || currSeconds>=0) && currMinute>=0)
        {
            if(currSeconds==0)
            {
                currMinute-=1;
                currSeconds=29;
            }
            else if(currSeconds>0)
            {
                currSeconds-=1;
            }
            if(currMinute>-1)
                if(currSeconds == 0)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        _resendOtpBtn.alpha = 1.0;
                        _resendOtpBtn.userInteractionEnabled = YES;
                        ProgressLbl.hidden = YES;
                    });
                    
                    
                }
            
            ProgressLbl.text =[NSString stringWithFormat:@"Wait : %1ld sec" ,(long)currSeconds];
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                _resendOtpBtn.alpha = 1.0;
                _resendOtpBtn.userInteractionEnabled = YES;
                ProgressLbl.hidden = YES;
            });
            
            [timer invalidate];
        }
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
    }
    @finally {
        // Added to show finally works as well
    }
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;

}


- (IBAction)BackButton_Clicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];

}

- (IBAction)DoneButton_Clicked:(id)sender
{
     [self.view endEditing:YES];
    
    if (isResend == YES)
    
    {
        if ([Utilities isInternetConnectionExists]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [Utilities showLoading :self.view :FontColorHex and:@"#ffffff"];
            });
            
            
            NSString *urlStr = [NSString stringWithFormat:@"%@verifyotp",BASEURL];
            
            
            strotp = [NSString stringWithFormat:@"%@%@%@%@",_txt1.text,_txt2.text,_txt3.text,_txt4.text];
            if ([strotp length] == 4 )
            {
                
                
                requestDict = @{
                                @"mobilenumber":self.numberLabel.text =[NSString stringWithFormat:@"%@",[Utilities getPhoneno]],
                                @"otp":[NSString stringWithFormat:@"%@%@%@%@",_txt1.text,_txt2.text,_txt3.text,_txt4.text],
                                
                                };
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    ServiceManager *service = [ServiceManager sharedInstance];
                    service.delegate = self;
                    isResend = NO;
                    [service  handleRequestWithDelegates:urlStr info:requestDict];
                });
                
            }
            
            else
            {
                [Utilities displayCustemAlertViewWithOutImage:@"Please enter OTP" :self.view];
            }
        }
    }

    else if (singletonInstance.isFromEdit == YES)
    {
        if ([Utilities isInternetConnectionExists]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [Utilities showLoading :self.view :FontColorHex and:@"#ffffff"];
            });
            
            
            NSString *urlStr = [NSString stringWithFormat:@"%@verifyotp",BASEURL];
            
            
            strotp = [NSString stringWithFormat:@"%@%@%@%@",_txt1.text,_txt2.text,_txt3.text,_txt4.text];
            if ([strotp length] == 4 )
            {
                
                
                requestDict = @{
                                
                                @"mobilenumber":[Utilities getchangedPhoneno],
                                @"otp":[NSString stringWithFormat:@"%@%@%@%@",_txt1.text,_txt2.text,_txt3.text,_txt4.text]
                             
                                };
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    ServiceManager *service = [ServiceManager sharedInstance];
                    service.delegate = self;
                    [service  handleRequestWithDelegates:urlStr info:requestDict];
                });
                
            }
            
            else
            {
                [Utilities displayCustemAlertViewWithOutImage:@"Please enter OTP" :self.view];
            }
        }
    }
    
    else if (isResendfromEdit == YES)
    {
        if ([Utilities isInternetConnectionExists]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [Utilities showLoading :self.view :FontColorHex and:@"#ffffff"];
            });
            
            
            NSString *urlStr = [NSString stringWithFormat:@"%@verifyotp",BASEURL];
            
            
            strotp = [NSString stringWithFormat:@"%@%@%@%@",_txt1.text,_txt2.text,_txt3.text,_txt4.text];
            if ([strotp length] == 4 )
            {
                
                
                requestDict = @{
                                
                                @"mobilenumber":[Utilities getchangedPhoneno],
                                @"otp":[NSString stringWithFormat:@"%@%@%@%@",_txt1.text,_txt2.text,_txt3.text,_txt4.text]
                                
                                };
                
                
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    ServiceManager *service = [ServiceManager sharedInstance];
                    service.delegate = self;
                    isdone = YES;
                    [service  handleRequestWithDelegates:urlStr info:requestDict];
                });
                
            }
            
            else
            {
                [Utilities displayCustemAlertViewWithOutImage:@"Please enter OTP" :self.view];
            }
        }

    }

    
    else{
        

    if ([Utilities isInternetConnectionExists]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities showLoading :self.view :FontColorHex and:@"#ffffff"];
        });

    
    NSString *urlStr = [NSString stringWithFormat:@"%@verifyotp",BASEURL];
    

     strotp = [NSString stringWithFormat:@"%@%@%@%@",_txt1.text,_txt2.text,_txt3.text,_txt4.text];
         if ([strotp length] == 4 )
         {
    
        
    requestDict = @{
                    @"mobilenumber":self.numberLabel.text =[NSString stringWithFormat:@"%@",[Utilities getPhoneno]],
                    @"otp":[NSString stringWithFormat:@"%@%@%@%@",_txt1.text,_txt2.text,_txt3.text,_txt4.text],
                    
                    };
             
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ServiceManager *service = [ServiceManager sharedInstance];
        service.delegate = self;
        [service  handleRequestWithDelegates:urlStr info:requestDict];
    });

}

        else
        {
            [Utilities displayCustemAlertViewWithOutImage:@"Please enter OTP" :self.view];
        }
        }
}
}

# pragma mark - Webservice Delegates

- (void)responseDic:(NSDictionary *)info
{
    [self handleResponse:info];
}
- (void)failResponse:(NSError*)error
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [Utilities removeLoading:self.view];
    });
}
-(void)handleResponse :(NSDictionary *)responseInfo
{
    NSLog(@"responseInfo :%@",responseInfo);
    @try {
       if([[responseInfo valueForKey:@"status"] intValue] == 1)
            {
            
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 
                if (singletonInstance.isFromEdit==YES)
                 {
                      singletonInstance.isFromEdit= NO;
                     
                     if (isResendfromEdit == YES)
                     {
                         
                     }
                     else
                     {
                     RestaurantsViewController * rest = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"RestaurantsViewController"];
                     
                    
                     singletonInstance.isFromOtp = YES;
                     
                     [Utilities saveName:[[responseInfo valueForKey:@"data"] valueForKey:@"username"]];
                     [Utilities saveEmail:[[responseInfo valueForKey:@"data"] valueForKey:@"email"]];
                     [Utilities savePhoneno:[[responseInfo valueForKey:@"data"]valueForKey:@"mobilenumber"]];
                     
                     [self.navigationController pushViewController:rest animated:YES];
                     }
                     
                    
                 }
                 else if (isResend == YES)
                 {
                     isResend = NO;
                     
                     //user_id = [responseInfo valueForKey:@"id"];
                 }
                 
                 
                 else if (isdone == YES)
                 {
                     isdone = NO;
                     
                     RestaurantsViewController * rest = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"RestaurantsViewController"];
                    singletonInstance.isFromOtp = YES;
                     [Utilities saveName:[[responseInfo valueForKey:@"data"] valueForKey:@"username"]];
                     [Utilities saveEmail:[[responseInfo valueForKey:@"data"] valueForKey:@"email"]];
                     [Utilities savePhoneno:[[responseInfo valueForKey:@"data"]valueForKey:@"mobilenumber"]];

                     
                     [self.navigationController pushViewController:rest animated:YES];
                     
                 }
                 else
                 {
                 
                     UIWindow *mainWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
                     
                     RestaurantsViewController *restaurantsVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"RestaurantsViewController"];
                     
                     UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:restaurantsVC];
                     
                     
                     SideMenuViewController *sideMenuVC=[[SideMenuViewController alloc] initWithNibName:@"SideMenuViewController" bundle:nil];
                     
                     UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:sideMenuVC];
                     
                     SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
                     
                     revealController.delegate = self;
                     
                     mainWindow.rootViewController = revealController;
                     [mainWindow makeKeyAndVisible];
                     
                 }
        
             });
               
        }
        
        else if([[responseInfo valueForKey:@"status"] intValue] == 2)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *str = [NSString stringWithFormat:@"%@",[responseInfo valueForKey:@"result"]];
                [Utilities displayCustemAlertViewWithOutImage:str :self.view];
            });
            
        }

        
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *str = [NSString stringWithFormat:@"%@",[responseInfo valueForKey:@"result"]];
                [Utilities displayCustemAlertViewWithOutImage:str :self.view];
            });
        }
        
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

//auto fill text fields
-(void)autoFillCodeIntoTextFields:(NSString*)code
{
    _array = [NSMutableArray array];
    
    for (int i = 0; i < [code length]; i++) {
        NSString *ch = [code substringWithRange:NSMakeRange(i, 1)];
        [_array addObject:ch];
    }
    
    for (int i = 0; i < _array.count; i++){
        switch (i) {
            case 0:
                _txt1.text = [_array objectAtIndex:i];
                break;
            case 1:
                _txt2.text = [_array objectAtIndex:i];
                break;
            case 2:
                _txt3.text = [_array objectAtIndex:i];
                break;
            case 3:
                _txt4.text = [_array objectAtIndex:i];
                break;
           
            default:
                break;
        }
    }
    
}


//always return no since we are manually changing the text field
    

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (![string isEqualToString:@""]) {
        textField.text = string;
        if ([textField isEqual:self.txt1]) {
            [self.txt2 becomeFirstResponder];
        }else if ([textField isEqual:self.txt2]){
            [self.txt3 becomeFirstResponder];
        }else if ([textField isEqual:self.txt3]){
            [self.txt4 becomeFirstResponder];
        }
        else{
            [textField resignFirstResponder];
        }
        return NO;
    }
    return YES;
}


- (IBAction)ResendOtp_Clicked:(id)sender
{
    
    
    _resendOtpBtn.alpha = 0.2;
    _resendOtpBtn.userInteractionEnabled = NO;
    
    ProgressLbl.hidden = NO;
    
    [ProgressLbl setText:@"Wait : 30 sec"];
    currMinute =1;
    currSeconds=30;
    
    [self start];
    
    if (singletonInstance.isFromEdit == YES)
    {
        if ([Utilities isInternetConnectionExists]) {
            dispatch_async(dispatch_get_main_queue(), ^{
            });
            
            
            NSString *urlStr = [NSString stringWithFormat:@"%@resendotp",BASEURL];
            
            NSLog(@"responseInfo :%@",[NSString stringWithFormat:@"%@",[Utilities getchangedPhoneno]]);
            
            requestDict = @{
                            @"mobilenumber":[NSString stringWithFormat:@"%@",[Utilities getchangedPhoneno]]
                            
                            };
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                ServiceManager *service = [ServiceManager sharedInstance];
                service.delegate = self;
                
              isResendfromEdit = YES;
                [service  handleRegistration :urlStr info:requestDict andMethod:@"POST"];
            });
            
            
        }

    }
    else
    {
    
    if ([Utilities isInternetConnectionExists]) {
        dispatch_async(dispatch_get_main_queue(), ^{
        });

    
    NSString *urlStr = [NSString stringWithFormat:@"%@resendotp",BASEURL];
        
    requestDict = @{
                    @"mobilenumber":self.numberLabel.text =[NSString stringWithFormat:@"%@",[Utilities getPhoneno]]

                    };
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ServiceManager *service = [ServiceManager sharedInstance];
        service.delegate = self;
        
        isResend = YES;
        [service  handleRegistration :urlStr info:requestDict andMethod:@"POST"];
    });
    }
    }
}
@end
