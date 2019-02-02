//
//  RateUsViewController.h
//  MealShack
//
//  Created by Prasad on 11/08/17.
//  Copyright © 2017 Possibillion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonClassViewController.h"

@interface RateUsViewController : CommonClassViewController
@property (strong, nonatomic) IBOutlet UILabel *DateNTimeLbl;
@property (strong, nonatomic) IBOutlet UILabel *restaurantNameLbl;
@property (strong, nonatomic) IBOutlet UILabel *ItemPriceLbl;

- (IBAction)SubmitButton_Clicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *PopView;

@property(strong,nonatomic) NSString * strOrderID;
@property(strong,nonatomic) NSString * establishmentID;
@property(strong,nonatomic) NSString * createdOnId;
@property(strong,nonatomic) NSString * restaurant;
@property(strong,nonatomic)NSString * totalCost;



@property (strong, nonatomic) IBOutlet UITextView *commentsView;

@property (strong, nonatomic) IBOutlet UILabel *deliveryExp;

@property (strong, nonatomic) IBOutlet UILabel *restExp;



@end
