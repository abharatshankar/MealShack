//
//  RestaurantsMenuCell.h
//  MealShack
//
//  Created by Prasad on 31/07/17.
//  Copyright © 2017 Possibillion. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RestaurantsMenuCellDelegate<NSObject>

@optional
- (void)didUpdateItemCount:(int)count;

@end


@interface RestaurantsMenuCell : UITableViewCell
{
     int itemCount;
}
@property (nonatomic, weak) id <RestaurantsMenuCellDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIImageView *itemImage;
@property (strong, nonatomic) IBOutlet UILabel *itemNameLbl;
@property (strong, nonatomic) IBOutlet UILabel *itemPriceLbl;
@property (strong, nonatomic) IBOutlet UILabel *itemQuantLbl;
@property (strong, nonatomic) IBOutlet UILabel *CategoryNameLbl;
@property (weak, nonatomic) IBOutlet UIView *bgView,*lineView;
@property (strong, nonatomic) IBOutlet UIImageView *imgUnavailable;
@property (weak, nonatomic) IBOutlet UILabel *lblunavailable;


///// for cart

- (IBAction)didSelectIncrement:(id)sender;
- (IBAction)didSelectDecrement:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *itemCountLabel;
@property (strong, nonatomic) IBOutlet UIButton *decrementButton;
@property (strong, nonatomic) IBOutlet UIButton *incrementButton;

@end
