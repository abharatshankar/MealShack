//
//  ForgotPasswordViewController.h
//  MealShack
//
//  Created by Prasad on 20/07/17.
//  Copyright © 2017 Possibillion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonClassViewController.h"
#import "ACFloatingTextField.h"

@interface ForgotPasswordViewController : CommonClassViewController
{
    IBOutlet UIView *borderview;
    IBOutlet UIButton *btnsignup;
}
- (IBAction)BackButton_Clicked:(id)sender;
- (IBAction)SendButton_Clicked:(id)sender;

@property (strong, nonatomic) IBOutlet ACFloatingTextField *mobileNumberText;


@end
