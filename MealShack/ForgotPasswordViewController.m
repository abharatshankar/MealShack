//
//  ForgotPasswordViewController.m
//  MealShack
//
//  Created by Prasad on 20/07/17.
//  Copyright © 2017 Possibillion. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "LoginViewController.h"
#import "ServiceManager.h"
#import "Utilities.h"
#import "Constants.h"

#define NUMBERS_ONLY @"1234567890"
#define CHARACTER_LIMIT 11

@interface ForgotPasswordViewController ()

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [Utilities addShadowtoView:borderview];
    [Utilities addShadowtoButton:btnsignup];
    
    
    _mobileNumberText.placeholder = @"Enter Mobile Number";
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)BackButton_Clicked:(id)sender
{
     [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)SendButton_Clicked:(id)sender
{
    [self.view endEditing:YES];
    if ([_mobileNumberText.text length] > 0)
    {
        if ([_mobileNumberText.text length] >= 10)
        {

        if ([Utilities validateMobileOREmail:_mobileNumberText.text error:nil])
        {
            dispatch_async(dispatch_get_main_queue(),
                           ^{
                               [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
                           });
            
            NSDictionary *requestDict;
            NSString *urlStr = [NSString stringWithFormat:@"%@forgot_password",BASEURL];
            
            requestDict = @{
                            @"mobilenumber":[Utilities null_ValidationString:_mobileNumberText.text]
                            };
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                           ^{
                               ServiceManager *service = [ServiceManager sharedInstance];
                               service.delegate = self;
                               [service  handleRegistration :urlStr info:requestDict andMethod:@"POST"];
                         
                           });
            
            
        }
        else
        {
            [Utilities displayCustemAlertViewWithOutImage:@"Internet connection error" :self.view];
        }
        
    }
        else
        {
            
            [Utilities displayCustemAlertViewWithOutImage:@"Please enter valid Mobile Number" :self.view];
        }
    }

        
    else
    {
        
        [Utilities displayCustemAlertViewWithOutImage:@"Please enter your Mobile number" :self.view];
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
                NSString *str = [NSString stringWithFormat:@"%@",[responseInfo valueForKey:@"result"]];
                [Utilities displayCustemAlertViewWithOutImage:str :self.view];
            LoginViewController * login = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"LoginViewController"];
            [self.navigationController pushViewController:login animated:YES];
              });
            
            if ([[[responseInfo valueForKey:@"data"] valueForKey:@"user_type"] isEqualToString:@"User"])
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [USERDEFAULTS setBool:YES forKey:@"UserSignedIn"];
                    
                    [Utilities SaveUserType:[[responseInfo valueForKey:@"data"] valueForKey:@"user_type"]];
                    [Utilities savePhoneno:[[responseInfo valueForKey:@"data"] valueForKey:@"mobilenumber"]];
                    
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
#pragma mark - TextFiled delegates

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    //    [backGroundScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    return YES;
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField ==  _mobileNumberText)
    {
        [self showDoneButtonOnNumberPad:textField];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    //[self animateTextField:textField up:NO withOffset:textField.frame.origin.y / 2];
    
}



-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
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
