//
//  FavouritesCell.h
//  MealShack
//
//  Created by Prasad on 02/08/17.
//  Copyright © 2017 Possibillion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavouritesCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *DeleteButton;
@property (strong, nonatomic) IBOutlet UIView *bgview;

@property (strong, nonatomic) IBOutlet UIImageView *favImgView;
@property (strong, nonatomic) IBOutlet UILabel *restaurantName;

@property (strong, nonatomic) IBOutlet UILabel *cuisinesLabel;
@property (strong, nonatomic) IBOutlet UIImageView *rupeeRating;


@property (strong, nonatomic) IBOutlet UILabel *restaurantRatingLbl;
@property (strong, nonatomic) IBOutlet UILabel *restaurantDeliverytime;
@property (strong, nonatomic) IBOutlet UILabel *DeliveryMinLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imgUnavailable;
@property (strong, nonatomic) IBOutlet UILabel *RestUnavailable;

@end
