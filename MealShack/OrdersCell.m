//
//  OrdersCell.m
//  MealShack
//
//  Created by Prasad on 28/07/17.
//  Copyright © 2017 Possibillion. All rights reserved.
//

#import "OrdersCell.h"



@implementation OrdersCell
@synthesize bgView,restaurantNameLabel,itemName1,quantityLabel,priceLabel,createdDateLabel,totalItemsPrice;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
