//
//  OrdersCell.h
//  MealShack
//
//  Created by Prasad on 28/07/17.
//  Copyright © 2017 Possibillion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrdersCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *restaurantNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *itemName1;
@property (strong, nonatomic) IBOutlet UILabel *quantityLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *createdDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalItemsPrice;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UIButton *reorderBtn;
@property (strong, nonatomic) IBOutlet UILabel *itemname;
@property (strong, nonatomic) IBOutlet UILabel *qtylbl;
@property (strong, nonatomic) IBOutlet UILabel *lblprice;


@end
