//
//  CategoryItemTableViewCell.h
//  MealShack
//
//  Created by Rambabu Mannam on 15/08/17.
//  Copyright © 2017 Possibillion. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CategoryItemTableViewCellDelegate<NSObject>

@optional
- (void)didUpdateItemCount:(int)count;

@end


@interface CategoryItemTableViewCell : UITableViewCell
{
    int itemCount;

}

@property (nonatomic, weak) id <CategoryItemTableViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView,*lineView;
@property (strong, nonatomic) IBOutlet UIImageView *imgUnavailable;
@property (weak, nonatomic) IBOutlet UILabel *lblunavailable;


////for cart
- (IBAction)didSelect_decrement:(id)sender;
- (IBAction)didSelect_Increment:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *itemCountLabel;
@property (strong, nonatomic) IBOutlet UIButton *decrement_Button;
@property (strong, nonatomic) IBOutlet UIButton *Increment_Button;



@end
