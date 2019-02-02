//
//  OrderSummaryCell.h
//  MealShack
//
//  Created by Prasad on 07/08/17.
//  Copyright © 2017 Possibillion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderSummaryCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *itemQuantLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;

@end
