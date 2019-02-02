//
//  CategoryItemTableViewCell.m
//  MealShack
//
//  Created by Rambabu Mannam on 15/08/17.
//  Copyright © 2017 Possibillion. All rights reserved.
//

#import "CategoryItemTableViewCell.h"

@implementation CategoryItemTableViewCell
@synthesize bgView,lineView,imgUnavailable,lblunavailable;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [[self.decrement_Button imageView] setContentMode: UIViewContentModeScaleAspectFit];
    [[self.Increment_Button imageView] setContentMode: UIViewContentModeScaleAspectFit];


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didSelect_decrement:(id)sender
{
    if (itemCount > 0) {
        itemCount --;
        
        self.itemCountLabel.text = [NSString stringWithFormat:@"%d", itemCount];
        
        if ([self.delegate respondsToSelector:@selector(didUpdateItemCount:)]) {
            [self.delegate didUpdateItemCount:itemCount];
        }
    }
}

- (IBAction)didSelect_Increment:(id)sender
{
    
    itemCount ++;
    self.itemCountLabel.text = [NSString stringWithFormat:@"%d", itemCount];
    
    
    
    
    if ([self.delegate respondsToSelector:@selector(didUpdateItemCount:)]) {
        [self.delegate didUpdateItemCount:itemCount ];
        
        
    }

}
@end
