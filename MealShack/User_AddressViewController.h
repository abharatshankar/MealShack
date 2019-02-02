//
//  User_AddressViewController.h
//  Shopality
//
//  Created by PossibillionTech on 5/3/17.
//  Copyright © 2017 PossibillionTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonClassViewController.h"
#import "RestaurantsViewController.h"

@protocol addressTypeDelegate <NSObject>

-(void)setAddressType:(NSString*)address;

@end

@interface User_AddressViewController : CommonClassViewController<UIImagePickerControllerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    
    NSMutableArray *goods;
    NSString *strname;
    NSString *strprice;
    NSString *strsku;
    
    
}

@property (weak, nonatomic) IBOutlet UITableView *tblProducts;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, retain) NSString *isfromCart;


@property (nonatomic, retain) NSString *productName;
@property (nonatomic, retain) NSString *price;
@property (nonatomic,retain) NSString * sku;
@property (nonatomic, retain) NSURL *imageUrl;

- (IBAction)standardTime:(id)sender;
- (IBAction)cartButton:(id)sender;
- (IBAction)plusBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *addNew;

@property (retain)id <addressTypeDelegate> delegate;

@property (nonatomic,strong) NSString * addressTypString;

@end
