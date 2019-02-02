//
//  RestaurantsMenuCell.m
//  MealShack
//
//  Created by Prasad on 31/07/17.
//  Copyright © 2017 Possibillion. All rights reserved.
//

#import "RestaurantsMenuCell.h"
#import "Utilities.h"
#import "Constants.h"



@implementation RestaurantsMenuCell
@synthesize bgView,lineView,imgUnavailable,lblunavailable;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [[self.decrementButton imageView] setContentMode: UIViewContentModeScaleAspectFit];
    [[self.incrementButton imageView] setContentMode: UIViewContentModeScaleAspectFit];


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didSelectIncrement:(id)sender
{
    
    itemCount ++;
    self.itemCountLabel.text = [NSString stringWithFormat:@"%d", itemCount];
    
    
    if ([self.delegate respondsToSelector:@selector(didUpdateItemCount:)])
    {
        
        [self.delegate didUpdateItemCount:itemCount];
        
    }

}

- (IBAction)didSelectDecrement:(id)sender
{
   
    if (itemCount > 0)
    {
        itemCount --;
        
        self.itemCountLabel.text = [NSString stringWithFormat:@"%d", itemCount];
        
        if ([self.delegate respondsToSelector:@selector(didUpdateItemCount:)]) {
            [self.delegate didUpdateItemCount:itemCount];
        }
    }

}
@end
