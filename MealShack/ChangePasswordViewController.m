//
//  ChangePasswordViewController.m
//  MealShack
//
//  Created by Prasad on 26/07/17.
//  Copyright © 2017 Possibillion. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "Utilities.h"
#import "Constants.h"
#import "ServiceManager.h"
#import "OtpViewController.h"
#import "RestaurantsViewController.h"

#define NUMBERS_ONLY @"1234567890"
#define CHARACTER_LIMIT 11

@interface ChangePasswordViewController ()<ServiceHandlerDelegate>


@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIColor *color1 =  [Utilities getUIColorObjectFromHexString:@"#fd6565" alpha:1];

    _submit.backgroundColor = color1;
    
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
    [btntitle setTitle:@"Change Password" forState:UIControlStateNormal];
    btntitle.titleLabel.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:18];
    btntitle.frame = CGRectMake(0, 0, 250, 22);
    btntitle.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btntitle setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    btntitle.showsTouchWhenHighlighted=YES;
    UIBarButtonItem *barButtonItem3 = [[UIBarButtonItem alloc] initWithCustomView:btntitle];
    [arrLeftBarItems addObject:barButtonItem3];
    btntitle.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    


    
    self.navigationController.navigationBar.tintColor = WHITECOLOR;
    self.navigationController.navigationBar.barTintColor = color1;
    self.navigationController.navigationBar.translucent = YES;
    self.navigationItem.leftBarButtonItems = arrLeftBarItems;


}
-(void)Back_Click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)SubmitButton_Clicked:(id)sender
{
    [self.view endEditing:YES];
    
    NSString *savedValue = [USERDEFAULTS
                            valueForKey:@"pass"];
    
    if ([_oldPasswordTextField.text length] > 0)
    {
        if ([_oldPasswordTextField.text isEqualToString:savedValue])
        {
            //old code
//        if ([_oldPasswordTextField.text length] >= 5)
//        {
            if ([_NewPasswordTextField.text length] > 0)
            {
                if ([_NewPasswordTextField.text length] >= 5)
                {
                    if ([_confirmPasswordTextField.text length] > 0)
                    {
                        
                        if ([_NewPasswordTextField.text isEqualToString:_confirmPasswordTextField.text])
                            
                        {
                            if (![_oldPasswordTextField.text isEqualToString: _NewPasswordTextField.text])

                            {
                            
                            
                            if ([Utilities isInternetConnectionExists])
                            {
                                
                                //loading UI Starting on mainThread
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
                                });
                                
                            
                                NSDictionary *requestDict;
                            
                                
                                //Request URL
                                NSString *urlStr = [NSString stringWithFormat:@"%@changePassword",BASEURL];
                                
                                //parameters
                                requestDict = @{
                                                @"user_id":[Utilities getUserID],
                                                @"password":[NSString stringWithFormat:@"%@",_NewPasswordTextField.text],
                                                @"old_password":[NSString stringWithFormat:@"%@",_oldPasswordTextField.text]                        };
                                
                                
                                
                                
                                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                    ServiceManager *service = [ServiceManager sharedInstance];
                                    service.delegate = self;
                                    
                                    
                                    [service  handleRegistration :urlStr info:requestDict andMethod:@"POST"];
//old code
                                //    [service handleRequestWithDelegates:urlStr info:requestDict];
                                    
                                });
                                
                            }
                            else
                            {
                                [Utilities displayCustemAlertViewWithOutImage:@"Internet connection error" :self.view];
                            }
                        }
                        else
                        {
                            [Utilities displayCustemAlertViewWithOutImage:@"The old and new passwords are same.Please enter a new password" :self.view];
                        }


                    }
                    
                        else
                        {
                            [Utilities displayCustemAlertViewWithOutImage:@"Passwords do not match,please check and enter new password" :self.view];
                        }
                        
                        
                    }
                    
                    
                    else
                    {
                        [Utilities displayCustemAlertViewWithOutImage:@"Please Enter confirm password" :self.view];
                    }
                    
                }
                
                
                else
                {
                    [Utilities displayCustemAlertViewWithOutImage:@"password must be atleast 5 characters" :self.view];
                }
                
            }
            
            else
            {
                [Utilities displayCustemAlertViewWithOutImage:@"Please Enter your new password" :self.view];
            }
        }
        
        else
        {
            [Utilities displayCustemAlertViewWithOutImage:@"Please Enter valid old password" :self.view];
        }
        
        
    }
    else
    {
        [Utilities displayCustemAlertViewWithOutImage:@"Please Enter your old password" :self.view];
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
                [USERDEFAULTS setValue:_NewPasswordTextField.text forKey:@"pass"];


                [USERDEFAULTS setBool:YES forKey:@"UserSignedIn"];

                
                
                [Utilities saveName:[[responseInfo valueForKey:@"data"] valueForKey:@"username"]];
                [Utilities saveEmail:[[responseInfo valueForKey:@"data"] valueForKey:@"email"]];
                [Utilities savePhoneno:[[responseInfo valueForKey:@"data"] valueForKey:@"mobilenumber"]];
                [Utilities SaveUserID:[[responseInfo valueForKey:@"data"] valueForKey:@"id"]];

                
                
                
                
            });
            
        }
        else if ([[responseInfo valueForKey:@"status"] intValue] == 2)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *str = [NSString stringWithFormat:@"%@",[responseInfo valueForKey:@"response"]];
                [Utilities displayCustemAlertViewWithOutImage:str :self.view];
            });
        }
        else if ([[responseInfo valueForKey:@"status"] intValue] == 3)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *str = [NSString stringWithFormat:@"%@",[responseInfo valueForKey:@"response"]];
                [Utilities displayCustemAlertViewWithOutImage:str :self.view];
                
                RestaurantsViewController * restaurants = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"RestaurantsViewController"];
                
                [self.navigationController pushViewController:restaurants animated:YES];
            });
        }
        else if ([[responseInfo valueForKey:@"status"] intValue] == 4)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *str = [NSString stringWithFormat:@"%@",[responseInfo valueForKey:@"response"]];
                [Utilities displayCustemAlertViewWithOutImage:str :self.view];
            });
        }
        
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *str = [NSString stringWithFormat:@"%@",[responseInfo valueForKey:@"response"]];
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
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
        
    });
    
}


//-(void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    [self showDoneButtonOnNumberPad:textField];
//
//}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//
//    //return true;
//    if (textField.tag==1) {
//
//    }
//    return true;
//}

#pragma mark - TextFiled delegates

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == _NewPasswordTextField) {
        _NewPasswordTextField.clearsOnBeginEditing = NO;
    }
    
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
-(void)doneClicked:(id)sender
{
    [self.view endEditing:YES];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


@end
