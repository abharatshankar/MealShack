//
//  AddressesCell.h
//  MealShack
//
//  Created by Prasad on 26/07/17.
//  Copyright © 2017 Possibillion. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <FBShimmeringView.h>


@interface AddressesCell : UITableViewCell

@property (weak, nonatomic) IBOutlet FBShimmeringView *vwShimmer;
@property (weak, nonatomic) IBOutlet UIView *vwMain;
@property (strong, nonatomic) IBOutlet UILabel *PlaceLabel;
@property (strong, nonatomic) IBOutlet UILabel *AreaLabel;

@property (strong, nonatomic) IBOutlet UIImageView *imgHome;




@property (strong, nonatomic) IBOutlet UIButton *btnedit;
@property (strong, nonatomic) IBOutlet UIButton *btndelete;


@end
