//
//  SignUpViewController.h
//  MealShack
//
//  Created by Prasad on 20/07/17.
//  Copyright © 2017 Possibillion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CommonClassViewController.h"
#import "ACFloatingTextField.h"

@interface SignUpViewController : CommonClassViewController<CLLocationManagerDelegate,UITextFieldDelegate>
{
    IBOutlet UIView *borderView;
    IBOutlet UIButton *btnsignup;
}
- (IBAction)BackButton_Clicked:(id)sender;
- (IBAction)SubmitButton_Clicked:(id)sender;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *enterName;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *firstName;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *lastName;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *enterEmail;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *enterPassword;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *mobileNumberText;

@property NSString * user_id;
@end
