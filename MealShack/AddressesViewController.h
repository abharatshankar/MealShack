//
//  AddressesViewController.h
//  MealShack
//
//  Created by Prasad on 24/07/17.
//  Copyright © 2017 Possibillion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonClassViewController.h"


@interface AddressesViewController : CommonClassViewController<UITableViewDataSource,UITableViewDelegate>
{
    
    NSMutableArray *goods;
    NSString *strname;
    NSString *strprice;
    NSString *strsku;
    
    
}



@property (strong, nonatomic) IBOutlet UITableView *AddressTableView;
@property (strong, nonatomic) IBOutlet UIButton *addAddress;


@property (strong, nonatomic) IBOutlet UILabel *shimTest3;
@property NSString * address_id;
@property (strong, nonatomic) IBOutlet UILabel *shimTest1;
@property (strong, nonatomic) IBOutlet UILabel *shimTest2;
@property (strong, nonatomic) IBOutlet UILabel *shimTest4;
@property (strong, nonatomic) IBOutlet UILabel *shimTest5;
@property (strong, nonatomic) IBOutlet UILabel *shimTest6;
@property (strong, nonatomic) IBOutlet UILabel *shimTest7;
@property (strong, nonatomic) IBOutlet UILabel *shimTest8;
@property (strong, nonatomic) IBOutlet UILabel *shimTest9;
@property (strong, nonatomic) IBOutlet UILabel *shimTest10;
@property (strong, nonatomic) IBOutlet UILabel *shimTest11;
@property (strong, nonatomic) IBOutlet UILabel *shimTest12;
@property (strong, nonatomic) IBOutlet UILabel *shimTest13;
@property (strong, nonatomic) IBOutlet UILabel *shimTest14;
@property (strong, nonatomic) IBOutlet UILabel *shimTest15;

@end
