//
//  SignUpViewController.m
//  MealShack
//
//  Created by Prasad on 20/07/17.
//  Copyright © 2017 Possibillion. All rights reserved.
//

#import "SignUpViewController.h"
#import "OtpViewController.h"
#import "Utilities.h"
#import "Constants.h"
#import "ServiceManager.h"
#import "LcnManager.h"
#import "SingleTon.h"

#define NUMBERS_ONLY @"1234567890"
#define CHARACTER_LIMIT 11

@interface SignUpViewController ()<ServiceHandlerDelegate>
{
    NSDictionary *requestDict;
    BOOL isEmailEntered;
    SingleTon *singleTonInstance;
}

@end

@implementation SignUpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    singleTonInstance=[SingleTon singleTonMethod];

    // Do any additional setup after loading the view.
    [Utilities addShadowtoView:borderView];
    [Utilities addShadowtoButton:btnsignup];
    isEmailEntered = NO;
    [_enterEmail addTarget:self
                   action:@selector(textFieldDidChange:)
         forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldDidChange:(UITextField*)sender{
    if (sender.tag == 3) {
        if(sender.text.length == 0) {
            isEmailEntered = NO;
        }else{
            isEmailEntered = YES;
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)BackButton_Clicked:(id)sender
{
     [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

- (IBAction)SubmitButton_Clicked:(id)sender
{
    [self.view endEditing:YES];
    if ([_firstName.text length] > 0)
    {
    if ([  _lastName.text length] > 0)
    {
    if ([_mobileNumberText.text length] > 0)
    {
    if ([_mobileNumberText.text length] >= 10)
    {
    if(isEmailEntered == YES)
    {
                BOOL isValid = [self validateEmailWithString:_enterEmail.text];
                if (isValid == NO) {
                    [Utilities displayCustemAlertViewWithOutImage:@"Please enter valid email" :self.view];
                    return;
                }
            }
            if ([_enterPassword.text length] > 0)
            {
                if([_enterPassword.text length] >= 5)
                {

                    if ([Utilities isInternetConnectionExists])
                            {
                                //loading UI Starting on mainThread
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
                                });
                                
                                //Request URL
                                NSString *urlStr = [NSString stringWithFormat:@"%@signup",BASEURL];
                                
                                NSString *nameString = [NSString stringWithFormat:@"%@ %@", self.firstName.text, self.lastName.text];
                                //parameters
                                requestDict = @{
                                                @"mobilenumber":[Utilities null_ValidationString:_mobileNumberText.text],
                                                @"email":[Utilities null_ValidationString:_enterEmail.text],
                                                @"username":[Utilities null_ValidationString:nameString],
                                                @"password": [Utilities null_ValidationString:_enterPassword.text],
                                                @"latitude":[NSString stringWithFormat:@"%f",[[LcnManager sharedManager]locationManager].location.coordinate.latitude],
                                                @"longitude":[NSString stringWithFormat:@"%f", [[LcnManager sharedManager]locationManager].location.coordinate.longitude],
                                                @"device_token":@"123456789",
                                                @"device_type":@"ios"
                                                };
                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                    ServiceManager *service = [ServiceManager sharedInstance];
                                    service.delegate = self;
                                    
                                    [service handleRequestWithDelegates:urlStr info:requestDict];
                                    
                                });
                                
                            }
                    else
                    {
                        [Utilities displayCustemAlertViewWithOutImage:@"Please Check Your Internet connection" :self.view];
                    }
                  }
        else
        {
            
            [Utilities displayCustemAlertViewWithOutImage:@"Please Enter at least 5 characters password" :self.view];
        }
    }
        else
      {
        
        [Utilities displayCustemAlertViewWithOutImage:@"Please enter your password" :self.view];
    }
}

    else
    {
        [Utilities displayCustemAlertViewWithOutImage:@"Please enter valid mobile number" :self.view];
    }
    }
    else
    {
        [Utilities displayCustemAlertViewWithOutImage:@"Please enter your mobile number" :self.view];
    }
    }
    else
    {
        [Utilities displayCustemAlertViewWithOutImage:@"Please enter your last name" :self.view];
    }
}
    else
    {
        [Utilities displayCustemAlertViewWithOutImage:@"Please enter your First name" :self.view];
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
            
            if ([[responseInfo valueForKey:@"user_status"] intValue] == 1) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *str = @"Number already registered";
                    [Utilities displayCustemAlertViewWithOutImage:str :self.view];
                });
            }

            else
            dispatch_async(dispatch_get_main_queue(), ^{
            [USERDEFAULTS setBool:YES forKey:@"UserSignedIn"];
            [Utilities savePhoneno:[[responseInfo valueForKey:@"user_info"]  valueForKey:@"mobilenumber"]];
                
                [Utilities saveName:[[responseInfo valueForKey:@"user_info"]  valueForKey:@"username"]];

                [Utilities saveEmail:[[responseInfo valueForKey:@"user_info"]  valueForKey:@"email"]];

            [Utilities SaveUserID:[[responseInfo valueForKey:@"user_info"] valueForKey:@"id"]];
                
                
        NSLog(@"responseInfo:%@",[NSString stringWithFormat:@"%@",[Utilities getUserID]]);
        NSLog(@"responseInfo phone num:%@",[NSString stringWithFormat:@"%@",[Utilities getPhoneno]]);
    
            
            OtpViewController * Otp = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"OtpViewController"];
            [self.navigationController pushViewController:Otp animated:YES];
            
            Otp.holdOTPStr = [responseInfo valueForKey:@"code"];
                
            
                singleTonInstance.isSignup = YES;
                singleTonInstance.nameStr = [Utilities null_ValidationString:self.enterName.text];
                singleTonInstance.emailStr = [Utilities null_ValidationString:self.enterEmail.text];
            
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
        });
        [self.view endEditing:YES];
    }
}

// add done button on number keypad
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

//action for done button
-(void)doneClicked:(id)sender
{
    [self.view endEditing:YES];
}

//adding done button to mobile keypad
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField ==  _mobileNumberText)
    {
        [self showDoneButtonOnNumberPad:textField];
    }
    [self animateTextField:textField up:YES withOffset:textField.frame.origin.y / 2];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO withOffset:textField.frame.origin.y / 2];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
#define ACCEPTABLE_CHARACTERS @" ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    if (textField == self.mobileNumberText) {
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
@end
