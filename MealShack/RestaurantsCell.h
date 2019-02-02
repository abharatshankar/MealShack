//
//  RestaurantsCell.h
//  MealShack
//
//  Created by Prasad on 27/07/17.
//  Copyright © 2017 Possibillion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RestaurantsCell : UITableViewCell
{
    
}
@property (strong, nonatomic) IBOutlet UIView *bgView;

@property (strong, nonatomic) IBOutlet UIButton *favButton;

@property BOOL * isClicked;
@property (strong, nonatomic) IBOutlet UIImageView *restaurantsImageView;
@property (strong, nonatomic) IBOutlet UILabel *lineLabel;
@property (strong, nonatomic) IBOutlet UILabel *ratingLabel;
@property (strong, nonatomic) IBOutlet UIImageView *starImage;
@property (strong, nonatomic) IBOutlet UILabel *TimeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *ruppeRatingImage;
@property (strong, nonatomic) IBOutlet UILabel *minsLabel;
@property (strong, nonatomic) IBOutlet UIImageView *fav_ImgView;
@property (strong, nonatomic) IBOutlet UILabel *restaurantNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *CuisinesLabel;
- (IBAction)HeartyButton_Clicked:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *ImgLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imgUnavailable;
@property (strong, nonatomic) IBOutlet UILabel *lblUnavailable;
@property (strong, nonatomic) IBOutlet UILabel *UnavailRestName;

@end
