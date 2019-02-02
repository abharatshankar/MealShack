//
//  FiltersCell.h
//  MealShack
//
//  Created by Prasad on 01/08/17.
//  Copyright © 2017 Possibillion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FiltersCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *filterCuisinesLbl;
@property (strong, nonatomic) IBOutlet UIButton *checkbox;
@property (weak, nonatomic) IBOutlet UIImageView *checkMarkImageView;

@end
