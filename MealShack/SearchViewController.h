//
//  SearchViewController.h
//  MealShack
//
//  Created by Prasad on 27/07/17.
//  Copyright © 2017 Possibillion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonClassViewController.h"

@interface SearchViewController : CommonClassViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *searchTableView;
@property UISearchController * searchController ;

@end
