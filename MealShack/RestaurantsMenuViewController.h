//
//  RestaurantsMenuViewController.h
//  MealShack
//
//  Created by Prasad on 31/07/17.
//  Copyright © 2017 Possibillion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "CommonClassViewController.h"
#import "MGCollapsingHeaderView.h"

@interface RestaurantsMenuViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UIPopoverPresentationControllerDelegate,MGCollapsingHeaderDelegate>{
    
    NSMutableArray *categoryArray;

}

@property BOOL  isFromHomePage;

@property (strong, nonatomic) IBOutlet UIButton *backButton;

@property (strong, nonatomic) IBOutlet MGCollapsingHeaderView *headerView;

@property NSString * restaurantIDstr;
@property (strong, nonatomic) IBOutlet UIImageView *ruppeeRatingImage;
@property (strong, nonatomic) IBOutlet UILabel *cartCountLabel,*lblcartTotal;
@property (strong, nonatomic) NSString *strcount;

@property NSString * offsetValueStr;
@property NSString * setValue;

@property (strong, nonatomic) IBOutlet UITableView *RestaurantsMenuTableView;
@property (strong, nonatomic) IBOutlet UIImageView *restaurantImage;
@property (strong, nonatomic) IBOutlet UILabel *restaurantName;
@property (strong, nonatomic) IBOutlet UILabel *restaurantRating;
@property (strong, nonatomic) IBOutlet UILabel *restaurantDeliveryTime;

@property NSString * establishmentId;
- (IBAction)SwitchoffButton_Clicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *switchoff;
- (IBAction)itemslistButton_Clicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *droplistButton;
@property NSString * establishment_idStr,
                   *restarant_name,
                   *restarantRating,
                   *restarantDeliveryTime;
- (IBAction)didSelectIncrement:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *CategoryNameLbl;
@property (strong, nonatomic) IBOutlet UIButton *favbutton;
- (IBAction)FavButton_Clicked:(id)sender;
@property AppDelegate *AD;
@property (strong, nonatomic) IBOutlet UIButton *popoverBtn;
@property (strong, nonatomic) IBOutlet UIView *popview;
@property BOOL * isCompare;
@property (strong, nonatomic) IBOutlet UIImageView *starImage;
@property (strong, nonatomic) IBOutlet UIImageView *clockImage;
@property (strong, nonatomic) IBOutlet UILabel *vegetarianLbl;

@property (strong, nonatomic) IBOutlet UILabel *dimLabel;


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *TableViewTop;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *headerTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *headerHeight;

@property (strong, nonatomic) IBOutlet UILabel *shim1;
@property (strong, nonatomic) IBOutlet UILabel *shim2;
@property (strong, nonatomic) IBOutlet UILabel *shim3;
@property (strong, nonatomic) IBOutlet UILabel *shim4;

@end
