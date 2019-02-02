//
//  OtpViewController.h
//  MealShack
//
//  Created by Prasad on 20/07/17.
//  Copyright © 2017 Possibillion. All rights reserved.
#import <UIKit/UIKit.h>
#import "CommonClassViewController.h"
@interface OtpViewController : CommonClassViewController
- (IBAction)BackButton_Clicked:(id)sender;
- (IBAction)DoneButton_Clicked:(id)sender;
- (IBAction)ResendOtp_Clicked:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *numberLabel;
@property NSString * holdOTPStr;
@property (strong, nonatomic) IBOutlet UITextField *txt1;
@property (strong, nonatomic) IBOutlet UITextField *txt2;
@property (strong, nonatomic) IBOutlet UITextField *txt3;
@property (strong, nonatomic) IBOutlet UITextField *txt4;
@property (strong, nonatomic) IBOutlet UILabel *ProgressLbl;
@property (strong, nonatomic) IBOutlet UIButton *resendOtpBtn;
@end
