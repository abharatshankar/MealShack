//
//  AddressesCell.m
//  MealShack
//
//  Created by Prasad on 26/07/17.
//  Copyright © 2017 Possibillion. All rights reserved.
//

#import "AddressesCell.h"

@implementation AddressesCell
@synthesize imgHome,btnedit,btndelete;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    imgHome.layer.cornerRadius = CGRectGetWidth(imgHome.frame) / 2;
//    imgHome.clipsToBounds= YES;
    
    _PlaceLabel.layer.cornerRadius = 5.0f;
    _PlaceLabel.clipsToBounds = YES;
    
    _AreaLabel.layer.cornerRadius = 5.0f;
    _AreaLabel.clipsToBounds = YES;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
