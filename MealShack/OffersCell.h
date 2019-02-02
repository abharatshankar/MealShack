//
//  OffersCell.h
//  MealShack
//
//  Created by Prasad on 28/07/17.
//  Copyright © 2017 Possibillion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OffersCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *offersImageView;
@property (strong, nonatomic) IBOutlet UILabel *OffLabel;
@property (strong, nonatomic) IBOutlet UILabel *offers_restaurantName;
@property (strong, nonatomic) IBOutlet UIView *bgview;
@property (strong, nonatomic) IBOutlet UIImageView *ImgUnavailable;
@property (strong, nonatomic) IBOutlet UILabel *LblUnvailable;

@end
