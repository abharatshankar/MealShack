//
//  ReviewOrderViewController.h
//  MealShack
//
//  Created by Prasad on 10/08/17.
//  Copyright © 2017 Possibillion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "CommonClassViewController.h"
@interface ReviewOrderViewController : CommonClassViewController<UITableViewDelegate,UITableViewDataSource>
{
   
    
    NSString *strname;
    NSString *strprice,*strqty;
    NSString *strSubtotal;
    
    
    
    IBOutlet UIView *addressView;
    
    IBOutlet UILabel *lblselectedAddress;
   // NSString *strsku;
}

- (IBAction)CloseButton_Clicked:(id)sender;
- (IBAction)ApplyButton_Clicked:(id)sender;
- (IBAction)ProceedToPayment:(id)sender;

@property NSString * restaurantIDstr;
@property (strong, nonatomic) IBOutlet UITableView *OrderItemsTableView;
@property (strong, nonatomic) IBOutlet UILabel *restaurantnameLabel;
@property (strong, nonatomic) IBOutlet UITextField *CouponcodeTxtfield;
@property (strong, nonatomic) IBOutlet UITextField *AddInstructionsField;

@property (strong, nonatomic) IBOutlet UILabel *subtotalcost;
@property (strong, nonatomic) IBOutlet UILabel *DiscountsCost;
@property (strong, nonatomic) IBOutlet UILabel *TaxesCost;
@property (strong, nonatomic) IBOutlet UILabel *DeliveryChargeCost;
@property (strong, nonatomic) IBOutlet UILabel *GrandTotalCost;
- (IBAction)ExpandButton_Clicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *expandbutton;
@property AppDelegate *AD;


@property (strong, nonatomic) IBOutlet UIView *ExpandView;
@property (strong, nonatomic) IBOutlet UIImageView *downarrowImg;
@property (strong, nonatomic) IBOutlet UIView *AddView;

@property NSString * strlat;
@property NSString * strlog;
@property (strong, nonatomic) IBOutlet UIScrollView *scroll_items;
@property (strong, nonatomic) IBOutlet UIView *ReviewView;
@property (strong, nonatomic) IBOutlet UIView *Bgview;
@property (strong, nonatomic) NSDictionary *dicttotal;
@property NSString *strDeliverycharge ;

@property (strong, nonatomic) IBOutlet UIButton *closebtn;
@property (strong, nonatomic) IBOutlet UIImageView *AddressImg;
@property (strong, nonatomic) IBOutlet UILabel *WalletMny;
@property (strong, nonatomic) IBOutlet UILabel *walletLbl;
@property (strong, nonatomic) IBOutlet UILabel *walletLineLbl;

@property (strong, nonatomic) IBOutlet UILabel *discountsLineLbl;

@property (strong, nonatomic) IBOutlet UILabel *packagingMny;
@property (strong, nonatomic) IBOutlet UILabel *packagingLbl;
@property (strong, nonatomic) IBOutlet UIView *packagingLineLbl;



@property (strong, nonatomic) IBOutlet UILabel *DelvryFeeLbl;
@property (strong, nonatomic) IBOutlet UILabel *LblGrand;
@property (strong, nonatomic) IBOutlet UILabel *LinelBlDelivery;
@property (strong, nonatomic) IBOutlet UILabel *lblDiscount;

@end
