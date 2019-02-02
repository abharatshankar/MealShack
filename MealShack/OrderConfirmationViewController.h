//
//  OrderConfirmationViewController.h
//  MealShack
//
//  Created by Prasad on 11/08/17.
//  Copyright © 2017 Possibillion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonClassViewController.h"
@interface OrderConfirmationViewController : CommonClassViewController
{
    IBOutlet UITableView *tblItems;
}
- (IBAction)TrackOrderButton_Clicked:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *restaurantNameLbl;
@property (strong, nonatomic) IBOutlet UILabel *AddressLabel;
@property (strong, nonatomic) NSDictionary *totaldict;

@property (nonatomic, strong) NSMutableDictionary *mutDictTransactionDetails;
@property (strong, nonatomic) IBOutlet UIScrollView *BackScroll;
- (IBAction)Back_Click:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *Bgview;
@property (strong, nonatomic) IBOutlet UILabel *StrTotal;


@end
