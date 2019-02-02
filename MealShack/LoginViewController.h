//
//  LoginViewController.h
//  MealShack
//
//  Created by Prasad on 20/07/17.
//  Copyright © 2017 Possibillion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonClassViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "ACFloatingTextField.h"


@interface LoginViewController : CommonClassViewController<CLLocationManagerDelegate>
{
    IBOutlet UIButton *btnlogin,*btnsignup;
}
- (IBAction)LoginButton_Clicked:(id)sender;
- (IBAction)SignUpButton_Clicked:(id)sender;
- (IBAction)TapButton_Clicked:(id)sender;

@property (strong, nonatomic) IBOutlet ACFloatingTextField *mobileTextField;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *PasswordTextField;

@property(strong,nonatomic)CLGeocoder *geocoder;
@property(strong,nonatomic)CLLocationManager *locationManager;

@end
