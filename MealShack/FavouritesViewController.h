//
//  FavouritesViewController.h
//  MealShack
//
//  Created by Prasad on 24/07/17.
//  Copyright © 2017 Possibillion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonClassViewController.h"

@interface FavouritesViewController : CommonClassViewController<UITableViewDelegate,UITableViewDataSource>


@property (strong, nonatomic) IBOutlet UITableView *favouritesTableview;
@property NSString * restarantIdStr;
@property (strong, nonatomic) IBOutlet UILabel *shimmer1;
@property (strong, nonatomic) IBOutlet UILabel *shimmer2;
@property (strong, nonatomic) IBOutlet UILabel *shimmer3;
@property (strong, nonatomic) IBOutlet UILabel *shimmer4;
@property (strong, nonatomic) IBOutlet UILabel *shimmer5;
@property (strong, nonatomic) IBOutlet UILabel *shimmer6;
@property (strong, nonatomic) IBOutlet UILabel *shimmer7;
@property (strong, nonatomic) IBOutlet UILabel *shimmer8;

@end
