//
//  ViewController.h
//  FirstPayUMoney
//
//  Created by Prasad on 17/05/18.
//  Copyright © 2018 Possibillion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PlugNPlay/PlugNPlay.h>

@interface PayUMoneyViewController : UIViewController <UITextFieldDelegate>



@property (strong, nonatomic) IBOutlet UITextField *tfEmail;
@property (strong, nonatomic) IBOutlet UITextField *tfMobile;
@property (strong, nonatomic) IBOutlet UITextField *tfAmount;

@property (strong, nonatomic) IBOutlet UIButton *btnPayment;


@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *mobile;
@property (strong, nonatomic) NSString *amount;

- (void)payMethodWithParams:(PUMTxnParam*)txnParam source:(UIViewController*)source;

@end

