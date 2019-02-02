//
//  OrderSummaryViewController.h
//  MealShack
//
//  Created by Prasad on 07/08/17.
//  Copyright © 2017 Possibillion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonClassViewController.h"
@interface OrderSummaryViewController : CommonClassViewController<UITableViewDelegate,UITableViewDataSource>

- (IBAction)TrackButton_Clicked:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *itemsTableview;
@property (strong, nonatomic) IBOutlet UILabel *subtotalPrice;
@property (strong, nonatomic) IBOutlet UILabel *DeliveryAddLabel;
@property (strong, nonatomic) IBOutlet UILabel *paymentmodelabel;
@property (strong, nonatomic) IBOutlet UILabel *AddInstructnsLabel;
@property (strong, nonatomic) IBOutlet UILabel *DiscountsLabel;
@property (strong, nonatomic) IBOutlet UILabel *DeliverychargeLabel;
@property (strong, nonatomic) IBOutlet UILabel *TaxesLabel;
@property (strong, nonatomic) IBOutlet UILabel *grandtotalLabel;
@property (strong, nonatomic) IBOutlet UILabel *restaurantNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *createdonLabel;
@property (strong, nonatomic) NSString *strOrderID;
@property (strong, nonatomic) IBOutlet UIScrollView *orders_Scroll;
@property (strong, nonatomic) IBOutlet UIView *bgview;
@property (strong, nonatomic) IBOutlet UIView *BackView;
@property (strong, nonatomic) IBOutlet UILabel *linelbl;
@property (strong, nonatomic) IBOutlet UIButton *Btn_Track;
@property (strong, nonatomic) IBOutlet UILabel *ItemCostLbl;

@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (strong, nonatomic) IBOutlet UILabel *walletamountLbl;

@property (strong, nonatomic) IBOutlet UILabel *walletLbl;
@property (strong, nonatomic) IBOutlet UILabel *LblDeliveryCharge;
@property (strong, nonatomic) IBOutlet UILabel *LblGrandtotal;
@property (strong, nonatomic) IBOutlet UILabel *Linelabel;
@property (strong, nonatomic) IBOutlet UILabel *LblDiscounts;
@property (strong, nonatomic) IBOutlet UILabel *packagingLbl;

@end
