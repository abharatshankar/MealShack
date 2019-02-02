//
//  searchItemsTableViewCell.h
//  MealShack
//
//  Created by ashwin challa on 8/2/17.
//  Copyright © 2017 Possibillion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface searchItemsTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *restaurantsImageView;
@property (strong, nonatomic) IBOutlet UILabel *itemName;
@property (strong, nonatomic) IBOutlet UILabel *restaurantName;
@property (strong, nonatomic) IBOutlet UILabel *restaurantAddress;

@end
