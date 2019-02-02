//
//  RestaurantsViewController.h
//  MealShack
//
//  Created by Prasad on 21/07/17.
//  Copyright © 2017 Possibillion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonClassViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "User_AddressViewController.h"


@interface RestaurantsViewController : CommonClassViewController<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,UIAlertViewDelegate>
{
    IBOutlet UIView *cartView;
    IBOutlet UILabel *lblcartCount;
    
    CLLocationManager *locationManager;
}


@property NSString * comingAddressTypeStr;



@property (strong, nonatomic) IBOutlet UIScrollView *BackgroundScroll;
@property (strong, nonatomic) IBOutlet UIScrollView *BannersScroll;
@property (strong, nonatomic) IBOutlet UIPageControl *BannersPageControl;
@property NSString * user_id;
@property (strong, nonatomic) IBOutlet UITableView *restaurantsTableView;

@property (weak, nonatomic) IBOutlet UIView *dummyView;

@property BOOL isFromSideMenu;

@property NSMutableDictionary * filterDict;


@property(strong,nonatomic)CLGeocoder *geocoder;
@property(strong,nonatomic)CLLocationManager *locationManager;

- (IBAction)BannersTap:(id)sender;

@property BOOL*isfilters;

@property (strong, nonatomic) IBOutlet UILabel *mainshimmer1;
@property (strong, nonatomic) IBOutlet UILabel *mainshimmer2;


@property (weak, nonatomic) IBOutlet UILabel *mainShimmer3;



@end
