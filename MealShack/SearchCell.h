//
//  SearchCell.h
//  MealShack
//
//  Created by Prasad on 01/08/17.
//  Copyright © 2017 Possibillion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchCell : UITableViewCell
//@property (strong, nonatomic) IBOutlet UILabel *itemName;
@property (strong, nonatomic) IBOutlet UIImageView *restaurantImageView;
@property (strong, nonatomic) IBOutlet UILabel *itemName;

@property (strong, nonatomic) IBOutlet UILabel *restaurantName;
@property (strong, nonatomic) IBOutlet UILabel *resaturantAddress;
@property (strong, nonatomic) IBOutlet UIView *bgview;
@property (strong, nonatomic) IBOutlet UILabel *lblUnavailable;
@property (strong, nonatomic) IBOutlet UIImageView *imgUnavailable;
@property (strong, nonatomic) IBOutlet UILabel *restUnavailable;

@end
