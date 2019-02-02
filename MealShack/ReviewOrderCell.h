//
//  ReviewOrderCell.h
//  MealShack
//
//  Created by Prasad on 18/08/17.
//  Copyright © 2017 Possibillion. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ReviewOrderCellDelegate<NSObject>

@optional
- (void)didUpdateItemCount:(int)count;

@end


@interface ReviewOrderCell : UITableViewCell
{
    int itemCount;
}

@property (nonatomic, weak) id <ReviewOrderCellDelegate> delegate;
@property (strong, nonatomic) IBOutlet UILabel *itemNameLbl;
@property (strong, nonatomic) IBOutlet UILabel *itemPriceLbl;
@property (strong, nonatomic) IBOutlet UILabel *itemQuantLbl;
@property (strong, nonatomic) IBOutlet UIView *bgview,*lineView;


///cart
- (IBAction)didSelectdecrement:(id)sender;
- (IBAction)didSelectIncrement:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *lblqty;

@property (strong, nonatomic) IBOutlet UIButton *decrementButton;
@property (strong, nonatomic) IBOutlet UIButton *IncrementButton;


@end
