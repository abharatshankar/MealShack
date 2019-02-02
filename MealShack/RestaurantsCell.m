//
//  RestaurantsCell.m
//  MealShack
//
//  Created by Prasad on 27/07/17.
//  Copyright © 2017 Possibillion. All rights reserved.
//

#import "RestaurantsCell.h"

@implementation RestaurantsCell
@synthesize isClicked,favButton,bgView;


- (void)awakeFromNib {
    [super awakeFromNib];
    isClicked = YES;
    // Initialization code
    [[self.favButton imageView] setContentMode: UIViewContentModeScaleAspectFit];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)HeartyButton_Clicked:(id)sender
{
    if (isClicked==YES)
    {
        [favButton setImage:[UIImage imageNamed:@"heartyfill.png"] forState:UIControlStateNormal];
        isClicked = NO;
    }
    else
    {
        [favButton setImage:[UIImage imageNamed:@"heartyy.png"] forState:UIControlStateNormal];
        isClicked= YES;
    }
}
@end
