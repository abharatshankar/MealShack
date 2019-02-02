//
//  ChangePasswordViewController.h
//  MealShack
//
//  Created by Prasad on 26/07/17.
//  Copyright © 2017 Possibillion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonClassViewController.h"

@interface ChangePasswordViewController : CommonClassViewController


@property (strong, nonatomic) IBOutlet UITextField *oldPasswordTextField;
@property (strong, nonatomic) IBOutlet UITextField *NewPasswordTextField;
@property (strong, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
- (IBAction)SubmitButton_Clicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *submit;


@end
