//
//  searchItemsDisplayViewController.h
//  MealShack
//
//  Created by ashwin challa on 8/2/17.
//  Copyright © 2017 Possibillion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonClassViewController.h"
@interface searchItemsDisplayViewController : CommonClassViewController
@property (strong, nonatomic) IBOutlet UITableView *searchTableView;
@property NSString * searchTrendingString;
@property UISearchController * searchController ;
@end
