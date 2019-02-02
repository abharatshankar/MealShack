//
//  EditProfileViewController.h
//  MealShack
//
//  Created by Prasad on 25/07/17.
//  Copyright © 2017 Possibillion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonClassViewController.h"

@interface EditProfileViewController : CommonClassViewController
@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UITextField *mobileField;
- (IBAction)SubmitButton_Clicked:(id)sender;

@property NSString * user_id;
- (IBAction)ChangeButton_Clicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *BtnSubmit;

@property NSString * holdOTPStr;
@property (strong, nonatomic) IBOutlet UIButton *changeBtn;


@end
