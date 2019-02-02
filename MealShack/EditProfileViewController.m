//
//  EditProfileViewController.m
//  MealShack
//
//  Created by Prasad on 25/07/17.
//  Copyright © 2017 Possibillion. All rights reserved.
//

#import "EditProfileViewController.h"
#import "RestaurantsViewController.h"
#import "Utilities.h"
#import "Constants.h"
#import "ServiceManager.h"
#import "SWRevealViewController.h"
#import "ChangePasswordViewController.h"
#import "SideMenuViewController.h"
#import "OtpViewController.h"
#import "SingleTon.h"
#import "RestaurantsViewController.h"
#import "RateUsViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "UIImageView+WebCache.h"
#import "ImageCache.h"

@interface EditProfileViewController ()<ServiceHandlerDelegate,UIAlertViewDelegate>
{
    UIButton *button;
    int buttonclicksCount;
    NSDictionary *requestDict;
    BOOL * numberchange;
    NSString * stringConvertion;
    NSString * stringConvertion1;
    NSString *stringConvertion2;
    SingleTon * singleToninstance;
    BOOL * isPhoneNumAlso,*isEmailEdit,*isNameEdit;
}

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    singleToninstance = [SingleTon singleTonMethod];
   
    UIColor *color1 =  [Utilities getUIColorObjectFromHexString:@"#fd6565" alpha:1];

    
    _changeBtn.backgroundColor = color1;
    
    _BtnSubmit.backgroundColor = color1;
   
    
    
   

    
    self.title = NSLocalizedString(@"My Profile", nil);
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:[UIFont fontWithName:@"MyriadPro-Semibold" size:18]}];
    
    SWRevealViewController *revealController = [self revealViewController];
    //
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    
    UIButton *toggleBtn= [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 50, 35)];
    [toggleBtn.layer addSublayer:[Utilities customToggleButton]];
    [toggleBtn addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftRevealButtonItem = [[UIBarButtonItem alloc]initWithCustomView:toggleBtn];
    
    
    self.navigationController.navigationBar.tintColor = WHITECOLOR;
    

    self.navigationController.navigationBar.barTintColor = color1;
    self.navigationController.navigationBar.translucent = YES;
    self.navigationItem.leftBarButtonItem = leftRevealButtonItem;
    
    
  
    UIView *customview=[[UIView alloc]initWithFrame:CGRectMake(-10, -10, 40, 40)];
    button=[[UIButton alloc]initWithFrame:CGRectMake(5, 12, 50, 20)];
    [button setTitle:@"EDIT" forState:UIControlStateNormal];
     button.titleLabel.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:17];
    [button addTarget:self action:@selector(barButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *rightbarbutton=[[UIBarButtonItem alloc]initWithCustomView:customview];
    [customview addSubview:button];
    [self.navigationItem setRightBarButtonItem:rightbarbutton animated:YES];
  
    
    
    
     _nameField.enabled = NO;
     _emailField.enabled = NO;
    _mobileField.enabled = NO;
    
    
    _BtnSubmit.hidden = YES;
    
    _nameField.text = [Utilities getName];
    _mobileField.text =[Utilities getPhoneno];
    _emailField.text = [Utilities getEmail];
    

    
}
-(void)viewWillAppear:(BOOL)animated
{

    _nameField.text = [Utilities getName];
    _mobileField.text =[Utilities getPhoneno];
    _emailField.text = [Utilities getEmail];
    
}


-(void)barButtonClick
{

   buttonclicksCount=buttonclicksCount+1;
    [self buttonclickAction];


}
-(void)buttonclickAction
{
   if (buttonclicksCount%2==0)
    {
        
        [Utilities setUserName:_nameField.text];
        [Utilities setUserEmail:_emailField.text];
        [Utilities setUserMobile:_mobileField.text];

        _nameField.enabled = NO;
        _emailField.enabled = NO;
        _mobileField.enabled = NO;
        //[self  editUserInfoServiceCall];
        [button setTitle:@"EDIT" forState:UIControlStateNormal];
         button.titleLabel.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:17];
        //[_changePassword setHidden:YES];
        
        //[_editButton setHidden:YES];
        
        
    }
    else
    {
        
        _nameField.enabled = YES;
        _nameField.textColor = [UIColor blackColor];
        _emailField.enabled = YES;
        _emailField.textColor = [UIColor blackColor];
        _mobileField.enabled = YES;
        _mobileField.textColor = [UIColor blackColor];
      
        _BtnSubmit.hidden = NO;
        
     
        
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)SubmitButton_Clicked:(id)sender
{
    [self.view endEditing:YES];
    
    if ([_nameField.text length] > 0)
    {
        if ([_emailField.text length] > 0)
        {
            
        if ([Utilities validateMobileOREmail:_emailField.text error:nil])
        {
            
            if ([_mobileField.text length] > 0)
            {
                if ([_mobileField.text length] == 10)
                {
 

    
    if ([Utilities isInternetConnectionExists]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
        });
        
        
        NSString *urlStr = [NSString stringWithFormat:@"%@profileUpdate",BASEURL];
        
        requestDict = @{
                        @"username":[Utilities null_ValidationString:_nameField.text],
                        @"user_id":[Utilities getUserID],
                         @"email":[Utilities null_ValidationString:_emailField.text],
                        @"mobilenumber":[Utilities null_ValidationString:_mobileField.text]
                        
                        
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
                else
                {
                    [Utilities displayCustemAlertViewWithOutImage:@"Please enter valid mobilenumber" :self.view];
                }
            }
        else
            {
                    [Utilities displayCustemAlertViewWithOutImage:@"Please enter your mobilenumber" :self.view];
            }
            }
                
    else
    {
            [Utilities displayCustemAlertViewWithOutImage:@"Please enter valid email" :self.view];
    }
    }
        else
        {
            [Utilities displayCustemAlertViewWithOutImage:@"Please enter your email" :self.view];
        }
        }
    else
    {
        [Utilities displayCustemAlertViewWithOutImage:@"Please enter your name" :self.view];
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
        // [Utilities displayCustemAlertViewWithOutImage:@"Failed to getting data" :self.view];
        
    });
}
-(void)handleResponse :(NSDictionary *)responseInfo
{
    NSLog(@"responseInfo :%@",responseInfo);
    @try {
        if([[responseInfo valueForKey:@"status"] intValue] == 1)
            
        {
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
          
                [USERDEFAULTS setValue:_nameField.text forKey:@"name"];
                [USERDEFAULTS setValue:_emailField.text forKey:@"email"];
                
                if (numberchange == YES  || (numberchange == YES  && isNameEdit ==YES && isEmailEdit ==YES))
                {
                    
                     dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"" message:@"Are you sure you want to change your number?" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* noButton = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault
                                               
                                                                     handler:^(UIAlertAction * action){
                                                                     }];
                    
                    
                    UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                                
                                                {
                                                    
                      
                        [Utilities saveEmail:_emailField.text];
                        [Utilities saveName:self.nameField.text];
                                                    
                        singleToninstance.isFromEdit = YES;
                    OtpViewController * Otp = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"OtpViewController"];
                    Otp.holdOTPStr = [responseInfo valueForKey:@"code"];
                    [Utilities savechangedPhoneno:self.mobileField.text];
                                                    
                                                    
                    [self.navigationController pushViewController:Otp animated:YES];
                   
                                                    
                                                    
                                                }];
                    [alert addAction:noButton];
                    [alert addAction:yesButton];
                    
                    [self presentViewController:alert animated:YES completion:nil];
                    
                    numberchange = NO;
                    isNameEdit = NO;
                    isEmailEdit  = NO;
                         
                     });
                    
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                       
                            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"" message:@"Are you sure you want to change your details?" preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction* noButton = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault
                                                       
                                                                             handler:^(UIAlertAction * action){
                                                                             }];
                            
                            
                            UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                                        
                                    {
                                                            
                            EditProfileViewController * Otp = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"EditProfileViewController"];
                                                            
                            [Utilities saveName:[[responseInfo valueForKey:@"user_info"] valueForKey:@"username"]];
                            NSLog(@"responseInfo :%@",[NSString stringWithFormat:@"%@",[Utilities getName]]);
                            [Utilities saveEmail:[[responseInfo valueForKey:@"user_info"] valueForKey:@"email"]];
                            NSLog(@"responseInfo :%@",[NSString stringWithFormat:@"%@",[Utilities getEmail]]);
                                                            
                                                            
                            [self.navigationController pushViewController:Otp animated:YES];
                      
                                                            
                                                        }];
                        [alert addAction:noButton];
                        [alert addAction:yesButton];
                        
                        [self presentViewController:alert animated:YES completion:nil];
                        
                     });
                }
          });
        }
        
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *str = [NSString stringWithFormat:@"%@",[responseInfo valueForKey:@"result"]];
                [Utilities displayCustemAlertViewWithOutImage:@"Saved Changes Successfully" :self.view];
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
    NSLog(@"DataT - %@", [Utilities getName]);
    NSLog(@"DataT - %@", [Utilities getEmail]);
    
}


#pragma mark - TextFiled delegates

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ( textField == _mobileField ) {
        
        singleToninstance.isPhoneNumAlso = YES;
        textField.clearsOnBeginEditing = YES;
    
        numberchange = YES;
        [self showDoneButtonOnNumberPad:textField];

    }
     if ( textField == _emailField ) {
         isEmailEdit = YES;
     
     }
    
    if ( textField == _nameField ) {
        isNameEdit = YES;
        
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    
 //   [self animateTextField:textField up:NO withOffset:textField.frame.origin.y / 2];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    return YES;
}


-(void)showDoneButtonOnNumberPad :(UITextField *)txtField
{
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    [keyboardDoneButtonView sizeToFit];
    
    UIBarButtonItem *flexibleSpace =  [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *done = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneClicked:)];
    done.tintColor = [UIColor blackColor];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:flexibleSpace,done, nil]];
    txtField.inputAccessoryView = keyboardDoneButtonView;
    
}

-(void)doneClicked:(id)sender
{
    [self.view endEditing:YES];
    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
#define ACCEPTABLE_CHARACTERS @" ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    
    if (textField == self.mobileField) {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        if (newLength > 10) {
            return NO;
        }
        else{
            NSNumberFormatter * nf = [[NSNumberFormatter alloc] init];
            [nf setNumberStyle:NSNumberFormatterNoStyle];
            
            NSString * newString = [NSString stringWithFormat:@"%@%@",textField.text,string];
            NSNumber * number = [nf numberFromString:newString];
            
            if (number)
                return YES;
            else
                return NO;
        }
    }
#define ACCEPTABLE_CHARACTERS @" ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    
    // verify the text field you wanna validate
    
    // do not allow the first character to be space | do not allow more than one space
    if ([string isEqualToString:@" "])
    {
        if (!textField.text.length)
            return NO;
        if ([[textField.text stringByReplacingCharactersInRange:range withString:string] rangeOfString:@"  "].length)
            return NO;
    }
    
    return YES;
}




- (IBAction)ChangeButton_Clicked:(id)sender
{
    
    ChangePasswordViewController * change = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ChangePasswordViewController"];
    
    [self.navigationController pushViewController:change animated:YES];
    

}
@end
