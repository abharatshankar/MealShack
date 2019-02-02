//
//  ViewController.h
//  PaymentGateway
//
//  Created by Suraj on 22/07/15.
//  Copyright (c) 2015 Suraj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonClassViewController.h"

@interface PaymentPageViewController : CommonClassViewController

@property (strong, nonatomic) NSString *strTotal;
@property (strong, nonatomic) NSDictionary *totaldict;
@property (strong, nonatomic) NSString *OrderIdStr;
@property (strong, nonatomic) NSString *walletamountStr;
@property (strong, nonatomic) NSString *walletStatusStr;




@end

