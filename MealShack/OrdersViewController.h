//
//  OrdersViewController.h
//  MealShack
//
//  Created by Prasad on 24/07/17.
//  Copyright © 2017 Possibillion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonClassViewController.h"


@interface OrdersViewController : CommonClassViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *OrdersTableView;

@property (strong, nonatomic) IBOutlet UILabel *ordershimmer1;
@property (strong, nonatomic) IBOutlet UILabel *ordershimmer2;

@property (strong, nonatomic) IBOutlet UILabel *ordershimmer3;


@end
