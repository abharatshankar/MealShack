//
//  PaymentMenuViewController.h
//  MealShack
//
//  Created by Prasad on 11/08/17.
//  Copyright © 2017 Possibillion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonClassViewController.h"

@interface PaymentMenuViewController : CommonClassViewController
{
    IBOutlet UIButton *btncontinue;
}
- (IBAction)CashonDelivery:(id)sender;
- (IBAction)PayUMoney:(id)sender;
- (IBAction)ContinueButton_Clicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *cashondelivryBtn;
@property (strong, nonatomic) IBOutlet UIButton *PayumoneyBtn;
@property (strong, nonatomic) NSString *strTotal;
@property (strong, nonatomic) NSMutableDictionary *dictFinal,*dic1;
@property (strong, nonatomic) NSDictionary *totaldict;


@property BOOL*isValue;


@property (nonatomic, strong) NSMutableDictionary *mutDictTransactionDetails;
@property (strong, nonatomic) IBOutlet UIImageView *payuImg;


@end
