//
//  LoginViewController.m
//  MealShack
//
//  Created by Prasad on 20/07/17.
//  Copyright © 2017 Possibillion. All rights reserved.
//

#import "LoginViewController.h"
#import "SignUpViewController.h"
#import "ForgotPasswordViewController.h"
#import "Constants.h"
#import "Utilities.h"
#import "ServiceManager.h"
#import "RestaurantsViewController.h"
#import "SWRevealViewController.h"
#import "SideMenuViewController.h"
#import "LcnManager.h"
#import "SingleTon.h"

#define NUMBERS_ONLY @"1234567890"
#define CHARACTER_LIMIT 11

@interface LoginViewController ()<ServiceHandlerDelegate>
{
    NSString *loginType;
    NSDictionary *requestDict;
    IBOutlet UIView *borderView;
    SingleTon * singletonInstance;
    NSString * PwdStr;
    NSMutableDictionary * TotalDict;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
  
    
    [Utilities addShadowtoView:borderView];
    [Utilities addShadowtoButton:btnlogin];
    [Utilities addShadowtoButton:btnsignup];
        
   _mobileTextField.text= @"9704539761";
   _PasswordTextField.text = @"123456";
    _mobileTextField.delegate = self;
    _PasswordTextField.delegate = self;
    
    _mobileTextField.placeholder = @"Enter Mobile Number";
    _PasswordTextField.placeholder = @"Enter Password";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)LoginButton_Clicked:(id)sender
{
    [self.view endEditing:YES];
    
    if ([_mobileTextField.text length] >= 0)
   {
       if ([_mobileTextField.text length] >= 10)
       {
        if ([Utilities validateMobileOREmail:_mobileTextField.text error:nil])
        {
            if ([_PasswordTextField.text length] > 0)
            {
               if([_PasswordTextField.text length] >= 5)
               
                    if ([Utilities isInternetConnectionExists])
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
                        });
                        
                        NSString *urlStr = [NSString stringWithFormat:@"%@login",BASEURL];
                        
                        singletonInstance.isFromLogin =YES;
                        
                        //parameters
                        requestDict = @{
                                        @"mobilenumber":[Utilities null_ValidationString:_mobileTextField.text],
                                         @"password":[Utilities null_ValidationString:_PasswordTextField.text],
                                         @"device_token":@"123456789",
                                         @"latitude":[NSString stringWithFormat:@"%f",[[LcnManager sharedManager]locationManager].location.coordinate.latitude],
                                         @"longitude":[NSString stringWithFormat:@"%f", [[LcnManager sharedManager]locationManager].location.coordinate.longitude]
                                        //@"device_type":@"ios"
                                        };

                        [USERDEFAULTS setValue:_PasswordTextField.text forKey:@"pass"];
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            
                            ServiceManager *service = [ServiceManager sharedInstance];
                            
                            service.delegate = self;
                            [service  handleRequestWithDelegates:urlStr info:requestDict];
                        });
                    }
                    else
                    {
                        [Utilities displayCustemAlertViewWithOutImage:@"Please check your internet connection" :self.view];
                    }
                }
                else
                {
                    [Utilities displayCustemAlertViewWithOutImage:@"Please Enter at least 5 characters password" :self.view];
               }
            }
            else
            {
                [Utilities displayCustemAlertViewWithOutImage:@"Please enter password" :self.view];
            }
        }
        else
        {
            [Utilities displayCustemAlertViewWithOutImage:@"Please enter valid mobilenumber" :self.view];
        }
    }
    else
    {
        [Utilities displayCustemAlertViewWithOutImage:@"Please enter mobilenumber" :self.view];
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
            TotalDict= [responseInfo valueForKey:@"data"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [USERDEFAULTS setBool:YES forKey:@"UserSignedIn"];
                        
                        singletonInstance.isFromLogin =YES;
                        
                        [Utilities saveName:[[responseInfo valueForKey:@"data"] valueForKey:@"username"]];
                        [Utilities saveEmail:[[responseInfo valueForKey:@"data"] valueForKey:@"email"]];
                        [Utilities savePhoneno:[[responseInfo valueForKey:@"data"] valueForKey:@"mobilenumber"]];
                        [Utilities SaveUserID:[[responseInfo valueForKey:@"data"] valueForKey:@"id"]];
                
                        [APPDELEGATE loginChecking];
                        
                    });
                }
        
        else if([[responseInfo valueForKey:@"status"] intValue] == 2)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *str = [NSString stringWithFormat:@"%@",[responseInfo valueForKey:@"result"]];
                [Utilities displayCustemAlertViewWithOutImage:str :self.view];
            });
        }
        else if ([[responseInfo valueForKey:@"status"] intValue] == 3)
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
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities removeLoading:self.view];
        });
    }
    @catch (NSException *exception) {
    }
    @finally {
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities removeLoading:self.view];
             [self.view endEditing:YES];
        });
       
    }
}

#pragma mark - TextField delegates
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField ==  _mobileTextField)
    {
        [self showDoneButtonOnNumberPad:textField];
    }
    [self animateTextField:textField up:YES withOffset:textField.frame.origin.y / 2];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO withOffset:textField.frame.origin.y / 2];
}
//action for return btn in keypad
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//password validation
-(BOOL)passwordValidation
{
    int numberofCharacters = 0;
    BOOL lowerCaseLetter,upperCaseLetter,digit,specialCharacter = 0;
    
    for (int i = 0; i < [_PasswordTextField.text length]; i++)
    {
        unichar c = [_PasswordTextField.text characterAtIndex:i];
        if(!lowerCaseLetter)
        {
            lowerCaseLetter = [[NSCharacterSet lowercaseLetterCharacterSet] characterIsMember:c];
        }
        if(!upperCaseLetter)
        {
            upperCaseLetter = [[NSCharacterSet uppercaseLetterCharacterSet] characterIsMember:c];
        }
        if(!digit)
        {
            digit = [[NSCharacterSet decimalDigitCharacterSet] characterIsMember:c];
        }
    }
    if(digit && lowerCaseLetter && upperCaseLetter)
        return YES;
    else
        return NO;
}
//empty password field
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == _PasswordTextField)
    {
        _PasswordTextField.clearsOnBeginEditing = NO;
    }
    return YES;
}

// show done btn on number pad
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

//action for done btn

-(void)doneClicked:(id)sender
{
    [self.view endEditing:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

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

//write up to 10 numbers in mobile field
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
#define ACCEPTABLE_CHARACTERS @" ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    
    if (textField == self.mobileTextField) {
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
#define ACCEPTABLE_CHARACTERS @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    
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

//sign up btn action
- (IBAction)SignUpButton_Clicked:(id)sender
{
    
    SignUpViewController *  signup =[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"SignUpViewController"];
    [self.navigationController pushViewController:signup animated:YES];
}
//forgot password btn action
- (IBAction)TapButton_Clicked:(id)sender
{
    ForgotPasswordViewController *  forgotpassword =[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ForgotPasswordViewController"];
    [self.navigationController pushViewController:forgotpassword animated:YES];
}
@end
