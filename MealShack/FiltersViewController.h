//
//  FiltersViewController.h
//  MealShack
//
//  Created by Prasad on 31/07/17.
//  Copyright © 2017 Possibillion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonClassViewController.h"


@interface FiltersViewController : CommonClassViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *filtersTableView;
- (IBAction)RatingsButton_Clicked:(id)sender;
- (IBAction)DeliverytimeButton_Clicked:(id)sender;
- (IBAction)rup1Button_Clicked:(id)sender;
- (IBAction)rup2Button_Clicked:(id)sender;

- (IBAction)rup3Button_Clicked:(id)sender;
- (IBAction)rup4Button_Clicked:(id)sender;
- (IBAction)checkboxButton_Clicked:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *ratings;
@property (strong, nonatomic) IBOutlet UIButton *deliverytime;
@property (strong, nonatomic) IBOutlet UIButton *rup1;
@property (strong, nonatomic) IBOutlet UIButton *rup2;
@property (strong, nonatomic) IBOutlet UIButton *rup3;
@property (strong, nonatomic) IBOutlet UIButton *rup4;

- (IBAction)ApplyButton_Clicked:(id)sender;



@end
