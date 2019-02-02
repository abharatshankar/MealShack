//
//  RestaurantsViewController.m
//  MealShack
//
//  Created by Prasad on 21/07/17.
//  Copyright © 2017 Possibillion. All rights reserved.
//

#import "RestaurantsViewController.h"
#import "LoginViewController.h"
#import "SWRevealViewController.h"
#import "SideMenuViewController.h"
#import "SlideMenuTableViewCell.h"
#import "Constants.h"
#import "Utilities.h"
#import "ServiceManager.h"
#import "ServiceInitiater.h"
#import "RestaurantsCell.h"
#import "ServiceManager.h"
#import "SearchViewController.h"
#import "RestaurantsMenuViewController.h"
#import "FiltersViewController.h"
#import "AddressesViewController.h"
#import "SingleTon.h"
#import "LcnManager.h"
#import "AddAddressManually.h"
#import "User_AddressViewController.h"
#import "ImageCache.h"
#import "UIImageView+WebCache.h"
#import "ReviewOrderViewController.h"
#import "LoginViewController.h"
#import "UILabel+SOXGlowAnimation.h"



@interface RestaurantsViewController ()<UIScrollViewDelegate,ServiceHandlerDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate,addressTypeDelegate>
{
    NSString *stradd;
    NSString *timerCheck;
   IBOutlet UIScrollView *slidingScrollView;
   IBOutlet UIPageControl *pageControl;
    UIButton *btntitle;
    UIButton *toggleBtn;
    NSTimer *timeForScroolAnimation;
    BOOL pageControlBeingUsed;
    IBOutlet UIImageView *imageView;
    UILabel *noDataLabel ;
    NSString * establishmentString,*isFav;
    int tempImgNum;
    NSMutableArray *pageImages;
    NSString * imageString;
    NSMutableArray *pageViews;
     int onCall,countimages;
    NSDictionary *requestDict;
   
    //NSMutableArray * ratingArray;
    NSMutableArray * timeArray;
    NSMutableArray * imageArray;
    NSMutableArray * totalResponseArray;
    NSMutableArray * restaurantsImages;
    NSMutableArray * UnavailableImages;
    NSInteger pageCount;
    BOOL * isClicked,isgetcart;
    NSString *restarantIdStr;
    SingleTon * singleInstance;
    
    NSMutableArray * totalFiltersResultArray,*arrcartItems,*imagesArray;
    
    NSInteger variantTag;
    
    NSString * strLatitude,*strLongitude;
    NSString * strImg ,* ImgStr;
    
    
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    NSString * gpsLoc;
    NSString * UnavailableImgStr;
    NSString * TerminateStr;
    BOOL isAvailability;
    NSString * availabilityStr, *terminateStr, * adminTerm_status, *user_status;
    RestaurantsMenuViewController * Menu;
    
}

@end



@implementation RestaurantsViewController
@synthesize  geocoder,locationManager;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    singleInstance =   [SingleTon singleTonMethod];
    
    imagesArray = [[NSMutableArray alloc]init];
    
//    _mainshimmer1.hidden = NO;
//    _mainshimmer2.hidden = NO;
    NSString *str = [NSString stringWithFormat:@"%f",[[LcnManager sharedManager]locationManager].location.coordinate.latitude];
    NSString *strlong = [NSString stringWithFormat:@"%f", [[LcnManager sharedManager]locationManager].location.coordinate.longitude];
    
    
     [self.navigationController.view addSubview:cartView];     
    
     UIColor *color1 =  [Utilities getUIColorObjectFromHexString:@"#fd6565" alpha:1];
    
     self.navigationController.navigationBar.barTintColor = color1;
    
    geocoder = [[CLGeocoder alloc] init];
    if (locationManager == nil)
    {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        locationManager.delegate = self;
        [locationManager requestAlwaysAuthorization];
    }
    [locationManager startUpdatingLocation];
    
//    CGRect contentRect = CGRectZero;
//    for (UIView *view in  _BackgroundScroll.subviews) {
//        contentRect = CGRectUnion(contentRect, view.frame);
//    }
    //_BackgroundScroll.contentSize = contentRect.size;
    //[slidingScrollView addSubview:pageControl];
   // [_BackgroundScroll addSubview:cartView];
   // [_BackgroundScroll addSubview:slidingScrollView];
   // [_BackgroundScroll addSubview:_restaurantsTableView];
   
    self.BackgroundScroll.contentSize = CGSizeMake(self.view.frame.size.width, slidingScrollView.frame.size.height+self.restaurantsTableView.frame.size.height);
    [self.view addSubview:self.BackgroundScroll];
  
    
    lblcartCount.layer.borderColor = 0;
    lblcartCount.layer.cornerRadius = lblcartCount.frame.size.height/2;
    lblcartCount.layer.backgroundColor =WHITECOLOR.CGColor;
    lblcartCount.layer.borderColor = WHITECOLOR.CGColor;
    lblcartCount.layer.masksToBounds = YES;
    
    //time for scrol animation
    
    timeForScroolAnimation = nil;
    [timeForScroolAnimation invalidate];
    if (!timeForScroolAnimation) {
        [timeForScroolAnimation invalidate];
        timeForScroolAnimation = nil;
       // timeForScroolAnimation = [NSTimer scheduledTimerWithTimeInterval:8.0 target:self selector:@selector(scrollingTimer) userInfo:nil repeats:YES];
    }
    
 
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    totalFiltersResultArray =[[NSMutableArray alloc]init];
    imageArray = [[NSMutableArray alloc]init];
    totalResponseArray = [[NSMutableArray alloc]init];
    restaurantsImages = [[NSMutableArray alloc]init];
    UnavailableImages = [[NSMutableArray alloc]init];
    arrcartItems = [[NSMutableArray alloc]init];
    
    // Do any additional setup after loading the view.
    
    _restaurantsTableView.delegate = self;
    _restaurantsTableView.dataSource = self;
    _BannersScroll.delegate = self;
    
    [self setUpNavigationBar];
    
    
    
    countimages=1;
    
   // ratingArray = [[NSMutableArray alloc]init];
     timeArray  = [[NSMutableArray alloc]init];
    
    
    
    //gesture for banner image click
    UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapping:)];
    [singleTap setNumberOfTapsRequired:1];
    [imageView addGestureRecognizer:singleTap];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(testRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.BackgroundScroll addSubview:refreshControl];
    
    [self.view addSubview:self.BackgroundScroll];
    
    
    
  
    
}


- (void)testRefresh:(UIRefreshControl *)refreshControl
{
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data..."];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [NSThread sleepForTimeInterval:3];//for 3 seconds, prevent scrollview from bouncing back down (which would cover up the refresh view immediately and stop the user from even seeing the refresh text / animation)
        
        dispatch_async(dispatch_get_main_queue(), ^{
//            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//            [formatter setDateFormat:@"MMM d, h:mm a"];
//            NSString *lastUpdate = [NSString stringWithFormat:@"Last updated on %@", [formatter stringFromDate:[NSDate date]]];
//    
//            
//            refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdate];
            
            [refreshControl endRefreshing];
            
            NSLog(@"refresh end");
            
            
            [self restaurantsService:strLatitude :strLongitude];
            
        });
    });
}


#pragma mark - CLLocationManager delegate methods

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLLocation *newLocation = [locations lastObject];
    
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];

        
            CLPlacemark *placemark= [placemarks objectAtIndex:0];
            
           NSString * addressStr = [NSString stringWithFormat:@"%@,%@",[placemark thoroughfare],[placemark locality], [placemark administrativeArea]];
            
            NSLog(@"address is %@",addressStr);
            gpsLoc = [NSString stringWithFormat:@"%@",addressStr];
            
            
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
    
    // Turn off the location manager to save power.
    [manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"Cannot find the location.");
}





//banner image click
-(void)singleTapping:(UIGestureRecognizer *)recognizer
{
    
    if ([Utilities isInternetConnectionExists]) {
        dispatch_async(dispatch_get_main_queue(), ^{
    //        [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
            
            [self.mainshimmer1 addGlowEffectWithWidth:80 duration:1.5];
            [self.mainshimmer2 addGlowEffectWithWidth:80 duration:1.5];
            [self.mainShimmer3 addGlowEffectWithWidth:80 duration:1.5];
        });
    
   // NSLog(@"image clicked");
        
        
        if (![[[pageImages objectAtIndex:pageControl.currentPage]objectForKey:@"restaurant_id"] isEqualToString:@"0"] && !(pageImages == (id)[NSNull null] || [pageImages count] == 0) )
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
             Menu = [storyboard instantiateViewControllerWithIdentifier:@"RestaurantsMenuViewController"];
            Menu.establishment_idStr =[[pageImages objectAtIndex:pageControl.currentPage] objectForKey:@"restaurant_id"];
            
            Menu.strcount = [NSString stringWithFormat:@"%lu",(unsigned long)[arrcartItems count]];
            NSLog(@"Restaurant Clicked");
            
            [self.navigationController pushViewController:Menu animated:YES];

        }
        else
        {
            [Utilities displayCustemAlertViewWithOutImage:@"Restaurant not active" :self.view];
            NSLog(@"Banner Clicked");
        }
    }
    

    
    
  //}
    else
    {
        [Utilities displayCustemAlertViewWithOutImage:@"Internet connection error" :self.view];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [Utilities removeLoading:self.view];
    });

}


//service call for latitude and longitude

-(void)ServiceCall: (NSString *)latitude : (NSString *) langtitude
{
    // gettingCurrentLocatoion
    
    [self.view endEditing:YES];
    
    if ([Utilities isInternetConnectionExists]) {
        dispatch_async(dispatch_get_main_queue(), ^{
     //       [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
            [self.mainshimmer1 addGlowEffectWithWidth:80 duration:1.5];
            [self.mainshimmer2 addGlowEffectWithWidth:80 duration:1.5];
            [self.mainShimmer3 addGlowEffectWithWidth:80 duration:1.5];
            
        });
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            ServiceManager *service = [ServiceManager sharedInstance];
            service.delegate = self;
            
            
            [service  gettingCurrentLocatoion:latitude :langtitude];
            
        });
        
        
    }
    else
    {
        [Utilities displayCustemAlertViewWithOutImage:@"Internet connection error" :self.view];
    }
    
}



-(void)setUpNavigationBar
{
    SWRevealViewController *revealController = [self revealViewController];
    
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    toggleBtn= [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 50, 35)];
    [toggleBtn.layer addSublayer:[Utilities customToggleButton]];
    [toggleBtn addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftRevealButtonItem = [[UIBarButtonItem alloc]initWithCustomView:toggleBtn];
    
    NSMutableArray *arrBtns1 = [[NSMutableArray alloc]init];
    

    UIButton *btnlocation = [[UIButton alloc]initWithFrame:CGRectMake(toggleBtn.frame.origin.x+toggleBtn.frame.size.width, 20, 14, 20)];
    [btnlocation setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal ];
    UIBarButtonItem * itemlocation = [[UIBarButtonItem alloc] initWithCustomView:btnlocation];
    [btnlocation addTarget:self action:@selector(locationMethodClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    NSLayoutConstraint * widthConstraint = [btnlocation.widthAnchor constraintEqualToConstant:15];
    NSLayoutConstraint * HeightConstraint =[btnlocation.heightAnchor constraintEqualToConstant:20];
    
    [widthConstraint setActive:YES];
    [HeightConstraint setActive:YES];

    
    [arrBtns1 addObject:itemlocation];
    // self.navigationItem.leftBarButtonItems = itemlocation;
   
    stradd = [NSString stringWithFormat:@"%@",[USERDEFAULTS objectForKey:@"addressDictionary"]];
    
    
  //  [stradd stringByReplacingCharactersInRange:NSMakeRange(0, [stradd length]-0)
//                                 withString:@"24"];

    
    
    NSMutableArray *arrBtns = [[NSMutableArray alloc]init];
    NSMutableArray *leftnavButtons = [[NSMutableArray alloc]init];
    
    UIButton *btntaget = [[UIButton alloc]initWithFrame:CGRectMake(16, 22, 20, 20)];
    [btntaget setImage:[UIImage imageNamed:@"tageticon.png"] forState:UIControlStateNormal];
    UIBarButtonItem * itemtaget = [[UIBarButtonItem alloc] initWithCustomView:btntaget];
    [btntaget addTarget:self action:@selector(tagetMethodClicked:) forControlEvents:UIControlEventTouchUpInside];
    btntaget.contentMode = UIViewContentModeCenter;
    btntaget.imageView.contentMode = UIViewContentModeScaleAspectFit;
  
    
    NSLayoutConstraint * widthConstraint1 = [btntaget.widthAnchor constraintEqualToConstant:40];
    NSLayoutConstraint * HeightConstraint1 =[btntaget.heightAnchor constraintEqualToConstant:20];
    [widthConstraint1 setActive:YES];
    [HeightConstraint1 setActive:YES];

    
    UIButton *btnfilters = [[UIButton alloc]initWithFrame:CGRectMake(76, 22, 20, 20)];
    
    if (self.isfilters == YES)
    {
        [btnfilters setImage:[UIImage imageNamed:@"filtersWhite.png"] forState:UIControlStateNormal];
    }
    else
    {
    [btnfilters setImage:[UIImage imageNamed:@"filterss.png"] forState:UIControlStateNormal];
    }
    UIBarButtonItem * itemFilters = [[UIBarButtonItem alloc] initWithCustomView:btnfilters];
    [btnfilters addTarget:self action:@selector(filtersMethodClicked:) forControlEvents:UIControlEventTouchUpInside];
    btnfilters.contentMode = UIViewContentModeCenter;
    btnfilters.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    NSLayoutConstraint * widthConstraint2 = [btnfilters.widthAnchor constraintEqualToConstant:40];
    NSLayoutConstraint * HeightConstraint2 =[btnfilters.heightAnchor constraintEqualToConstant:20];
    [widthConstraint2 setActive:YES];
    [HeightConstraint2 setActive:YES];
    
    
    
    
    UIButton *btnsearch = [[UIButton alloc]initWithFrame:CGRectMake(116, 22, 20, 20)];
    [btnsearch setImage:[UIImage imageNamed:@"search.png"] forState:UIControlStateNormal];
    UIBarButtonItem * itemsearch = [[UIBarButtonItem alloc] initWithCustomView:btnsearch];
    [btnsearch addTarget:self action:@selector(searchMethodClicked:) forControlEvents:UIControlEventTouchUpInside];
    btnsearch.contentMode = UIViewContentModeCenter;
    btnsearch.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    NSLayoutConstraint * widthConstraint3 = [btnsearch.widthAnchor constraintEqualToConstant:40];
    NSLayoutConstraint * HeightConstraint3 =[btnsearch.heightAnchor constraintEqualToConstant:20];
    [widthConstraint3 setActive:YES];
    [HeightConstraint3 setActive:YES];
    
    
    
    [arrBtns addObject:itemsearch];
    [arrBtns addObject:itemFilters];
     
    [arrBtns addObject:itemtaget];
    self.navigationItem.rightBarButtonItems = arrBtns;
    
    self.navigationController.navigationBar.tintColor = Backgroundcolor;
    self.navigationController.navigationBar.barTintColor = Backgroundcolor;
    self.navigationController.navigationBar.translucent = YES;
    [leftnavButtons addObject:leftRevealButtonItem];
    [leftnavButtons addObject:itemlocation];
    
    
    
    
    btntitle = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if ([[Utilities null_ValidationString:stradd ] isEqualToString:@""])
    {
        [btntitle setTitle:@"Tap to change your location" forState:UIControlStateNormal];
         btntitle.titleLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:13];
        
    }
    else
    {
        
        
        
        [btntitle setTitle:stradd  forState:UIControlStateNormal];
         btntitle.titleLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:5];

    }
    
    
    btntitle.frame = CGRectMake(10,10, 200, 10);
    btntitle.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btntitle setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    //btntitle.backgroundColor = LIGHTGRYCOLOR;
    btntitle.showsTouchWhenHighlighted=YES;
    UIBarButtonItem *barButtonItem3 = [[UIBarButtonItem alloc] initWithCustomView:btntitle];
    [leftnavButtons addObject:barButtonItem3];
    [btntitle.titleLabel setFont:[UIFont systemFontOfSize:12]];
    btntitle.titleLabel.numberOfLines = 0; // if you want unlimited number of lines put 0

//    NSString *str = textField.text;
//    NSString *truncatedString = [str substringToIndex:[str length]-1];
    
    NSLayoutConstraint * widthConstraint6 = [btntitle.widthAnchor constraintEqualToConstant:150];
    NSLayoutConstraint * HeightConstraint6 =[btntitle.heightAnchor constraintEqualToConstant:self.navigationController.navigationBar.frame.size.height];
    [widthConstraint6 setActive:YES];
    [HeightConstraint6 setActive:YES];
    
    

 [btntitle addTarget:self action:@selector(locationMethodClicked:) forControlEvents:UIControlEventTouchUpInside];

    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.leftBarButtonItems = leftnavButtons;
    
    
    if (singleInstance.isResetFilter == YES) {
        singleInstance.isResetFilter = NO;
    }
    else
    {
        [revealController revealToggle:nil];
        [revealController revealToggle:nil];
    }

    
}




-(void)locationMethodClicked:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        User_AddressViewController *nearby = [storyboard instantiateViewControllerWithIdentifier:@"User_AddressViewController"];
        [self.navigationController pushViewController:nearby animated:YES];
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    _restaurantsTableView.delegate = self;
    _restaurantsTableView.dataSource = self;
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationController.navigationBar.tintColor = REDCOLOR;
    self.navigationController.navigationBar.barTintColor = REDCOLOR;
   
    self.navigationController.navigationBar.hidden = NO;
    
    cartView.hidden = YES;
    
    timerCheck = @"Yes";
    
    if (singleInstance.isNotFilterApplies == YES) {
        self.isFromSideMenu = YES;
        
    }
    
    if (self.isFromSideMenu == YES) {
        self.isFromSideMenu = NO;
        if (self.filterDict.count) {
            [self.filterDict removeAllObjects];
        }
    }
    else
    {
        
        if (singleInstance.filteredDict.count && singleInstance.isfilter == YES) {
            if (self.filterDict.count) {
                [self.filterDict removeAllObjects];
            }
            singleInstance.isfilter = NO;
            self.filterDict = singleInstance.filteredDict;
            
        }
        
    }
    
    if (self.filterDict && singleInstance.isNotFilterApplies != YES)
    {
        self.isfilters = YES;
        [self handleResponse:self.filterDict];
    }
    else
    {
        singleInstance.isNotFilterApplies = NO;
        strLatitude = [NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:@"selectedlat"]];
        strLongitude = [NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:@"selectedlong"]];
        if (![[Utilities null_ValidationString:strLatitude] isEqualToString:@""])
        {
              [self restaurantsService:strLatitude :strLongitude];
            
//            [USERDEFAULTS removeObjectForKey:@"selectedlat"];
//            [USERDEFAULTS removeObjectForKey:@"selectedlong"];
        }
        else
        {
            [self restaurantsService: [NSString stringWithFormat:@"%f",[[LcnManager sharedManager]locationManager].location.coordinate.latitude] :[NSString stringWithFormat:@"%f", [[LcnManager sharedManager]locationManager].location.coordinate.longitude]];
        }
        
       

    }
    
    NSString * addressCheckStr = [USERDEFAULTS objectForKey:@"addressDictionary1"];
    
    if (addressCheckStr.length) {
        stradd = [NSString stringWithFormat:@"%@",[USERDEFAULTS objectForKey:@"addressDictionary1"]];
        
        // define the range you're interested in
        NSRange stringRange = {0, MIN([stradd length], 15)};
        
        // adjust the range to include dependent chars
        stringRange = [stradd rangeOfComposedCharacterSequencesForRange:stringRange];
        
        // Now you can create the short string
        NSString *shortString = [stradd substringWithRange:stringRange];
        
        NSLog(@"---btn title %@",shortString);
        btntitle.frame = CGRectMake(toggleBtn.frame.origin.x+toggleBtn.frame.size.width, 5, 150, 35);
        if (![singleInstance.addressTyp isKindOfClass:[NSNull class]] && singleInstance.addressTyp != nil) {
            [btntitle setTitle:[NSString stringWithFormat:@"%@\nTap to change address",singleInstance.addressTyp]  forState:UIControlStateNormal];
        }
        else
        [btntitle setTitle:[NSString stringWithFormat:@"%@\nTap to change address",shortString]  forState:UIControlStateNormal];
       
        //NSString *myString = @"I have to replace text 'Dr Andrew Murphy, John Smith' ";
        NSString *myString = @"Tap to change address";
        
        //Create mutable string from original one
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:btntitle.titleLabel.text];
        
        //Fing range of the string you want to change colour
        //If you need to change colour in more that one place just repeat it
        NSLog(@"%d",shortString.length);
        
        NSRange range = NSMakeRange(btntitle.titleLabel.text.length - myString.length, myString.length);//[myString rangeOfString:shortString];
        [attString addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:range];
        
        //Add it to the label - notice its not text property but it's attributeText
        btntitle.titleLabel.attributedText = attString;
    }
    
   
    
    
    
//    CGSize pagesScrollViewSize = self.BannersScroll.frame.size;
//    self.BannersScroll.contentSize = CGSizeMake(pagesScrollViewSize.width * pageImages.count, pagesScrollViewSize.height);
    
    self.navigationController.navigationBar.tintColor = REDCOLOR;
    self.navigationController.navigationBar.barTintColor = REDCOLOR;
    
    //[self loadVisiblePages];
    
   // [self.revealViewController.frontViewController.view setUserInteractionEnabled:NO];
    SWRevealViewController *revealController = [self revealViewController];
    
    revealController.panGestureRecognizer.enabled = YES;

    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
}



-(CGSize)screenSize {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    if ((NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1) && UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        return CGSizeMake(screenSize.height, screenSize.width);
    }
    return screenSize;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
     
//search btn click action
- (void)searchMethodClicked:(id)sender
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchViewController * search = [storyboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
    [self.navigationController pushViewController:search animated:YES];
}


//filters method action
- (void)filtersMethodClicked:(id)sender
{
    if ([Utilities isInternetConnectionExists]) {
        dispatch_async(dispatch_get_main_queue(), ^{
      //      [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
        });
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FiltersViewController * filters = [storyboard instantiateViewControllerWithIdentifier:@"FiltersViewController"];
    [self.navigationController pushViewController:filters animated:YES];
        
}
    else
    {
        [Utilities displayCustemAlertViewWithOutImage:@"Internet connection error" :self.view];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [Utilities removeLoading:self.view];
    });
}


- (void)nameMethodClicked:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddressesViewController * address = [storyboard instantiateViewControllerWithIdentifier:@"AddressesViewController"];
    [self.navigationController pushViewController:address animated:YES];
    
}


//current location action
- (void)tagetMethodClicked:(id)sender
{
    [self restaurantsService: [NSString stringWithFormat:@"%f",[[LcnManager sharedManager]locationManager].location.coordinate.latitude] :[NSString stringWithFormat:@"%f", [[LcnManager sharedManager]locationManager].location.coordinate.longitude]];
    
        [btntitle setTitle:[NSString stringWithFormat:@"%@\nTap to change your location",gpsLoc] forState:UIControlStateNormal];
        btntitle.titleLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:12];

    //NSString *myString = @"I have to replace text 'Dr Andrew Murphy, John Smith' ";
    NSString *myString = @"Tap to change your location";
    
    //Create mutable string from original one
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:btntitle.titleLabel.text];
    
    //Fing range of the string you want to change colour
    //If you need to change colour in more that one place just repeat it
    NSLog(@"%d",gpsLoc.length);
    
    NSRange range = NSMakeRange(btntitle.titleLabel.text.length - myString.length, myString.length);//[myString rangeOfString:shortString];
    [attString addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:range];
    
    //Add it to the label - notice its not text property but it's attributeText
    btntitle.titleLabel.attributedText = attString;
    
}


//main service call to load reastaurants
-(void)restaurantsService:(NSString *)strLatitude:(NSString*)strLongitude

{
    [self.view endEditing:YES];
    
    if ([Utilities isInternetConnectionExists]) {
        dispatch_async(dispatch_get_main_queue(), ^{
      //      [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
            [self.mainshimmer1 addGlowEffectWithWidth:80 duration:1.5];
            [self.mainshimmer2 addGlowEffectWithWidth:80 duration:1.5];
            [self.mainShimmer3 addGlowEffectWithWidth:80 duration:1.5];
            
        });
        
        
        NSString *urlStr = [NSString stringWithFormat:@"%@restaurants",BASEURL];
        
        
        requestDict = @{
                        @"user_id":[NSString stringWithFormat:@"%@",[Utilities getUserID]],
                        @"latitude":strLatitude,
                        @"longitude":strLongitude
                        };
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            ServiceManager *service = [ServiceManager sharedInstance];
            service.delegate = self;
            
            
            [service  handleRequestWithDelegates:urlStr info:requestDict];
            // [self uploadImagetoServer:urlStr];
            
        });
        
        
    }
    else
    {
        [Utilities displayCustemAlertViewWithOutImage:@"Internet connection error" :self.view];
    }
    

}

//service call for cart
-(void)GetCartServiceCall
{
    
    
    if ([Utilities isInternetConnectionExists]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view endEditing:YES];
     //       [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
            [self.mainshimmer1 addGlowEffectWithWidth:80 duration:1.5];
            [self.mainshimmer2 addGlowEffectWithWidth:80 duration:1.5];
            [self.mainShimmer3 addGlowEffectWithWidth:80 duration:1.5];
            
        });
        
        isgetcart = YES;

        NSString *urlStr = [NSString stringWithFormat:@"%@userCartItems",BASEURL];
        requestDict = @{
                        @"user_id":[Utilities getUserID]
                        
                        };
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            ServiceManager *service = [ServiceManager sharedInstance];
            service.delegate = self;
            [service  handleRequestWithDelegates:urlStr info:requestDict];
            // [self uploadImagetoServer:urlStr];
            
        });
        
        
    }
    else
    {
        [Utilities displayCustemAlertViewWithOutImage:@"Internet connection error" :self.view];
    }
}

# pragma mark - Webservice Delegates

- (void)responseDic:(NSDictionary *)info
{
    [self handleResponse:info];
    
    
}
- (void)failResponse:(NSError*)error
{
    ////@"Error");
    dispatch_async(dispatch_get_main_queue(), ^{
        [Utilities removeLoading:self.view];
        // [Utilities displayCustemAlertViewWithOutImage:@"Failed to getting data" :self.view];
        
    });
}
-(void)handleResponse :(NSDictionary *)responseInfo
{
    
   NSLog(@"responseInfo :%@",responseInfo);
  
    
    if (isgetcart == YES)
    {
        isgetcart = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
       // dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            if ([[responseInfo valueForKey:@"status"] intValue] == 1)
            {
               // dispatch_async(dispatch_get_main_queue(), ^{
                    // Update UI
                    _mainshimmer1.hidden = YES;
                    _mainshimmer2.hidden = YES;
                    _mainShimmer3.hidden = YES;
                    self.dummyView.hidden = YES;
                    arrcartItems = [responseInfo valueForKey:@"cart_items"];
                    cartView.hidden = NO;
              //  });
                

               
                if (arrcartItems.count) {
                    [USERDEFAULTS setObject:[NSString stringWithFormat:@"%d",arrcartItems.count] forKey:@"arrcartItemsCount"];
                }
                else
                {
                    [USERDEFAULTS removeObjectForKey:@"arrcartItemsCount"];
                    
                }
                
                if (arrcartItems.count) {
                     establishmentString = [[arrcartItems objectAtIndex:0] valueForKey:@"establishment_id"];
                    [USERDEFAULTS setObject:establishmentString forKey:@"establishmentString"];
                }
               
                
                
                
                NSLog(@"GET CART establishment_id :%@",[USERDEFAULTS valueForKey:@"establishmentString"]);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    // Update UI
                    lblcartCount.text = [NSString stringWithFormat:@"%d",[arrcartItems count]];
                });
                
                  NSLog(@"GET CART responseInfo :%@",responseInfo);
                
                
            }
            else if ([[responseInfo valueForKey:@"status"] intValue] == 2)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    // Update UI
                    
                    cartView.hidden = YES;
                });
            }
        });
        
        
    }
    
    else if (isAvailability == YES)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
       // dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

            dispatch_async(dispatch_get_main_queue(), ^{
                // Update UI
                [self.mainshimmer1 addGlowEffectWithWidth:80 duration:1.5];
                [self.mainshimmer2 addGlowEffectWithWidth:80 duration:1.5];
                [self.mainShimmer3 addGlowEffectWithWidth:80 duration:1.5];
            });
            
            //self.dummyView.hidden = NO;
            isAvailability = NO;
            
            availabilityStr = [NSString stringWithFormat:@"%@",[responseInfo objectForKey:@"availability"]];
            terminateStr = [NSString stringWithFormat:@"%d",[[responseInfo valueForKey:@"terminate_status"]intValue]];
            
            adminTerm_status = [NSString stringWithFormat:@"%@",[responseInfo valueForKey:@"admin_terminate_status"]];
            
            
            if ([availabilityStr isEqualToString:@"1"] && [terminateStr isEqualToString:@"1"] && [adminTerm_status isEqualToString:@"0"])
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController pushViewController:Menu animated:YES];
                });

               
            }
            else
            {
                
                [Utilities displayCustemAlertViewWithOutImage:@"Restaurant not available" :self.view];
            }
            
            
        });
        
    }
  
       else if([[responseInfo valueForKey:@"status"] intValue] == 1)
        {
           //ashwin resta
              dispatch_async(dispatch_get_main_queue(), ^{
            //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

//                  [self.mainshimmer1 addGlowEffectWithWidth:80 duration:1.5];
//                  [self.mainshimmer2 addGlowEffectWithWidth:80 duration:1.5];
            if ([[self.filterDict valueForKey:@"status"] intValue] == 1)
            {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self.filterDict.count >0 && self.isfilters == YES) {
                        TerminateStr = [NSString stringWithFormat:@"%d",[[responseInfo objectForKey:@"terminate_status"]intValue]];
                        totalFiltersResultArray  = [self.filterDict objectForKey:@"result"];
                        NSLog(@"ocunttttttt %d",totalFiltersResultArray.count);
                        NSLog(@"restaurant%@",totalFiltersResultArray);
                        self.isfilters = NO;
                        if (imageArray.count) {
                            [imageArray removeAllObjects];
                        }
                        for (int i=0; i<totalFiltersResultArray.count; i++) {
                           [imageArray addObject:[[totalFiltersResultArray objectAtIndex:i] objectForKey:@"logo"]] ;
                        }
                        
                        [_restaurantsTableView reloadData];
                    }
                    
                });
               
            }
            else
            {
            // isfav is to  identification : it is coming from love button, else part is from restaurants service call response
            if ([isFav isEqualToString:@"isFav"])
            {
                
                isFav = @".";
                static NSString *CellIdentifier = @"RestaurantsCell";
                
                RestaurantsCell *cell = [self.restaurantsTableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (![[Utilities null_ValidationString:strLatitude] isEqualToString:@""])
                {
                    [self restaurantsService:strLatitude :strLongitude];
               
                }
                else
                {
                    [self restaurantsService: [NSString stringWithFormat:@"%f",[[LcnManager sharedManager]locationManager].location.coordinate.latitude] :[NSString stringWithFormat:@"%f", [[LcnManager sharedManager]locationManager].location.coordinate.longitude]];
                }
                
                if (![USERDEFAULTS valueForKey:@"arrcartItemsCount"]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // Update UI
                        cartView.hidden = NO;
                    });
                    
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // Update UI
                        cartView.hidden = YES;
                    });
                    
                   
                }
                
            }
            else
            {
                //get restarents data
                
            user_status = [NSString stringWithFormat:@"%@",[responseInfo objectForKey:@"user_status"]];
                
                if ([user_status isEqualToString:@"1"])
                {
                    TerminateStr = [NSString stringWithFormat:@"%d",[[responseInfo objectForKey:@"terminate_status"] intValue]];
                    
                    NSMutableArray * restaurantDumArray =  [responseInfo objectForKey:@"restaurants"];
                    
                    NSMutableArray * restaurantAvlblArray = [[NSMutableArray alloc]init];
                    NSMutableArray * restaurantNotAvlblArray = [[NSMutableArray alloc]init];
      ////for loop
                    for (int i=0; i<restaurantDumArray.count; i++) {
                        
                        if ([[responseInfo objectForKey:@"terminate_status"] intValue] == 0)
                        {
                            if ([[[restaurantDumArray objectAtIndex:i] objectForKey:@"terminate_status"] intValue] == 1 && [[[restaurantDumArray objectAtIndex:i] objectForKey:@"restauant_availability"] intValue] == 1) {
                                [restaurantAvlblArray addObject:[restaurantDumArray objectAtIndex:i] ];
                            }
                            else if ([[[restaurantDumArray objectAtIndex:i] objectForKey:@"terminate_status"] intValue] == 0 && [[[restaurantDumArray objectAtIndex:i] objectForKey:@"restauant_availability"] intValue] == 1)
                            {
                                [restaurantNotAvlblArray addObject:[restaurantDumArray objectAtIndex:i] ];
                            }
                            else if ([[[restaurantDumArray objectAtIndex:i] objectForKey:@"terminate_status"] intValue] == 0 || [[[restaurantDumArray objectAtIndex:i] objectForKey:@"restauant_availability"] intValue] == 0)
                            {
                                [restaurantNotAvlblArray addObject:[restaurantDumArray objectAtIndex:i] ];
                            }
                            
                           
                            
                        }
                        else
                        {
                             [restaurantNotAvlblArray addObject:[restaurantDumArray objectAtIndex:i] ];
                        }
                        
                    }
                    if (totalResponseArray.count) {
                        [totalResponseArray removeAllObjects];
                    }
                     for (int i=0; i<restaurantAvlblArray.count; i++) {
                         [totalResponseArray addObject:[restaurantAvlblArray objectAtIndex:i]];
                     }
                    
                    for (int i=0; i<restaurantNotAvlblArray.count; i++) {
                         [totalResponseArray addObject:[restaurantNotAvlblArray objectAtIndex:i]];
                    }
                    
                    
                    
                    
                    singleInstance.dixFromRestarunts = [responseInfo objectForKey:@"restaurants"];
                    
                    [USERDEFAULTS setObject:[responseInfo objectForKey:@"restaurant_distance"] forKey:@"distance"];
                    
                    NSLog(@"distance %@",[NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:@"distance"]]);
                    NSString * imgUrlStr = [NSString stringWithFormat:@"%@%@",BASEURLImages,[responseInfo valueForKey:@"profileImage"]];
                    [Utilities Saveimageurl:imgUrlStr];
                    [_restaurantsTableView reloadData];
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // Update UI
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                    
                }

            }
                
               
                
        }
                  

                pageImages =  [responseInfo objectForKey:@"banners"];
                  
                if (pageImages == (id)[NSNull null] || [pageImages count] == 0)
                {
                    NSLog(@"Banners nil");
                    
                    pageImages = nil;
                    dispatch_async(dispatch_get_main_queue(), ^{
                    self.mainshimmer1.hidden = YES;
                    self.mainshimmer2.hidden = YES;
                    self.mainShimmer3.hidden = YES;
                    self.dummyView.hidden = YES;
                        
                    });
                }
               else if([pageImages count]>0)
                  {
                      [self setUpScrollImages:pageImages];
                  }
                  
                  for (int i = 0; i<totalResponseArray.count; i++)
                  {
                      [singleInstance.ratingArray addObject:[[totalResponseArray objectAtIndex:i] objectForKey:@"restaurant_value"]];
                      [singleInstance.ratingSarray addObject:[[totalResponseArray objectAtIndex:i] objectForKey:@"rating"]];
                      [singleInstance.deliveryTimeArray addObject:[[totalResponseArray objectAtIndex:i] objectForKey:@"delivery_time"]];
                      [singleInstance.cusinesArray addObject:[[totalResponseArray objectAtIndex:i]objectForKey:@"cuisines"]];
                  }
                  
                  [self GetCartServiceCall];
                  
                  
                  static NSString *CellIdentifier = @"RestaurantsCell";
                  
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    // Update UI
                    RestaurantsCell *cell = [_restaurantsTableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    _restaurantsTableView.frame = CGRectMake(self.BackgroundScroll.frame.origin.x, slidingScrollView.frame.size.height+slidingScrollView.frame.origin.y, self.restaurantsTableView.frame.size.width, totalResponseArray.count * 162);
                    
                    self.BackgroundScroll.contentSize = CGSizeMake(self.view.frame.size.width, slidingScrollView.frame.size.height+self.restaurantsTableView.frame.size.height);
                    
                    
                    [_restaurantsTableView reloadData];
                });
                
                  
                 // }
                  
             });
        }
                             
        else if([[responseInfo valueForKey:@"status"] intValue] == 2)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.mainshimmer1 addGlowEffectWithWidth:80 duration:1.5];
                [self.mainshimmer2 addGlowEffectWithWidth:80 duration:1.5];
                [self.mainShimmer3 addGlowEffectWithWidth:80 duration:1.5];
                if (![[Utilities null_ValidationString:strLatitude] isEqualToString:@""])
                {
                    [self restaurantsService:strLatitude :strLongitude];
                    
                }
                else
                {
                    [self restaurantsService: [NSString stringWithFormat:@"%f",[[LcnManager sharedManager]locationManager].location.coordinate.latitude] :[NSString stringWithFormat:@"%f", [[LcnManager sharedManager]locationManager].location.coordinate.longitude]];
                }
            });
            
        }
        else if([[responseInfo valueForKey:@"status"] intValue] == 0)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.mainshimmer1 addGlowEffectWithWidth:80 duration:1.5];
//                [self.mainshimmer2 addGlowEffectWithWidth:80 duration:1.5];
//                [totalResponseArray removeAllObjects];
//                [totalFiltersResultArray removeAllObjects];
//                pageImages = nil;
//
//                [self GetCartServiceCall];
//                isgetcart = YES;
//
//
//                static NSString *CellIdentifier = @"RestaurantsCell";
//
//                RestaurantsCell *cell = [_restaurantsTableView dequeueReusableCellWithIdentifier:CellIdentifier];
//
//                _restaurantsTableView.frame = CGRectMake(self.BackgroundScroll.frame.origin.x, slidingScrollView.frame.size.height+slidingScrollView.frame.origin.y, self.restaurantsTableView.frame.size.width, totalResponseArray.count * cell.contentView.frame.size.height);
//
//                self.BackgroundScroll.contentSize = CGSizeMake(self.view.frame.size.width, slidingScrollView.frame.size.height+self.restaurantsTableView.frame.size.height);
//
//                [_restaurantsTableView reloadData];
                
//                noDataLabel      = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
//                noDataLabel.text             = @"No Restaurants around you";
//                noDataLabel.textColor        = GrayColor;
//                noDataLabel.textAlignment    = NSTextAlignmentCenter;
//                self.restaurantsTableView.backgroundView = noDataLabel;
//                self.restaurantsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//
//                [self.view bringSubviewToFront:noDataLabel];
                
                
                
                if ([[responseInfo objectForKey:@"result"] isEqualToString:@"No data found"]) {
                    [Utilities displayCustemAlertView:@"No Restaurants Around You" :self.view];
                }
                self.mainshimmer1.hidden = YES;
                self.mainshimmer2.hidden = YES;
                self.mainShimmer3.hidden = YES;
                self.dummyView.hidden = YES;
                
                isgetcart = NO;
                [totalResponseArray removeAllObjects];
                [totalFiltersResultArray removeAllObjects];
                pageImages = nil;
                self.dummyView.hidden = YES;
                [_restaurantsTableView reloadData];
                
                
                

            });

            
                    }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *str = [NSString stringWithFormat:@"%@",[responseInfo valueForKey:@"message"]];
                [Utilities displayCustemAlertViewWithOutImage:str :self.view];
            });
            
        }
    
    
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities removeLoading:self.view];
        });
    }
    


#pragma mark Tableview methods
- (float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    NSInteger numOfSections = 0;
    
    if ([totalFiltersResultArray count] > 0  || [totalResponseArray count] > 0 )
    {
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        numOfSections                = 1;
        dispatch_async(dispatch_get_main_queue(), ^{
            tableView.backgroundView = nil;
            slidingScrollView.hidden = NO;
        });
        
        
    }
    else
    {
        slidingScrollView.hidden = YES;

        [Utilities removeLoading:self.view];
        
//        noDataLabel      = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
//        noDataLabel.text             = @"No Restaurants around you";
//        noDataLabel.textColor        = GrayColor;
//        noDataLabel.textAlignment    = NSTextAlignmentCenter;
//        tableView.backgroundView = noDataLabel;
//        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        
    }
    
    return numOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (totalFiltersResultArray.count)
    {
      return totalFiltersResultArray.count;
    }
    else
    return  totalResponseArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell...
   
    static NSString *CellIdentifier = @"RestaurantsCell";
    
    RestaurantsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
    cell = [[RestaurantsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    
    NSLog(@"cellForRowAtIndexPath");
    
    [Utilities addShadowtoView:cell.bgView];
    
    if (!self.filterDict)
    {
        
    restaurantsImages  = [[totalResponseArray objectAtIndex:indexPath.row] objectForKey:@"logo"];
   UnavailableImages  = [[totalResponseArray objectAtIndex:indexPath.row] objectForKey:@"unavailable_image"];
    
        imageString = [NSString stringWithFormat:@"%@%@",RESTAURENTS_IMAGE_URL,restaurantsImages];
    
        UnavailableImgStr =[NSString stringWithFormat:@"%@%@",RESTAURENTS_IMAGE_URL,UnavailableImages];
  
    NSLog(@"===image url  == %@",imageString);
    
    NSURL *url = [NSURL URLWithString:imageString];
        
        
        if ([TerminateStr isEqualToString:@"0"])
        {
            [cell.restaurantsImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
            
            cell.imgUnavailable.hidden = YES;
            cell.lblUnavailable.hidden = YES;
            cell.userInteractionEnabled = YES;
            
            //[[[totalResponseArray objectAtIndex:indexPath.row] objectForKey:@"terminate_status"] intValue] == 1
            
            if (![[[totalResponseArray objectAtIndex:indexPath.row] objectForKey:@"terminate_status"] intValue] == 1)
            {
                
                
                UnavailableImgStr =[NSString stringWithFormat:@"%@%@",RESTAURENTS_IMAGE_URL,UnavailableImages];
                
                NSLog(@"===image url  == %@",UnavailableImgStr);
                
                NSURL *url = [NSURL URLWithString:UnavailableImgStr];
                [cell.imgUnavailable sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
                
                
                cell.imgUnavailable.hidden = NO;
                cell.lblUnavailable.hidden = NO;
                cell.userInteractionEnabled = NO;
               
                
                
                /////for drivers
                UnavailableImgStr = [NSString stringWithFormat:@"%@%@",RESTAURENTS_IMAGE_URL,UnavailableImages];
                
                NSLog(@"===image url  == %@",UnavailableImgStr);
                
                NSURL *url1 = [NSURL URLWithString:UnavailableImgStr];
                [cell.imgUnavailable sd_setImageWithURL:url1 placeholderImage:[UIImage imageNamed:@""]];
                
                [cell setUserInteractionEnabled:NO];
                cell.lblUnavailable.hidden = NO;
                [cell.imgUnavailable setUserInteractionEnabled:NO];
              
                
            }
            else
            {
                [cell.restaurantsImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
                cell.imgUnavailable.hidden = YES;
                cell.lblUnavailable.hidden = YES;
                cell.userInteractionEnabled = YES;
                
                // for drivers
                NSString * stringConvertion = [NSString stringWithFormat:@"%d",[[[totalResponseArray objectAtIndex:indexPath.row] objectForKey:@"restauant_availability"] intValue]];
                
                if (![stringConvertion intValue] == 1 )
                {
                    
                    // imageString = [NSString stringWithFormat:@"http://www.testingmadesimple.org/mealShack/uploads/establishment/%@",restaurantsImages];
                    UnavailableImgStr = [NSString stringWithFormat:@"%@%@",RESTAURENTS_IMAGE_URL,UnavailableImages];
                    
                    NSLog(@"===image url  == %@",UnavailableImgStr);
                    
                    NSURL *url2 = [NSURL URLWithString:UnavailableImgStr];
                    [cell.imgUnavailable sd_setImageWithURL:url2 placeholderImage:[UIImage imageNamed:@""]];
                    
                    
                    
                    [cell setUserInteractionEnabled:NO];
                    cell.imgUnavailable.hidden = NO;
                    cell.lblUnavailable.hidden = NO;
                    cell.userInteractionEnabled = NO;
                    
                    
                    
                    
                }
                else
                {
                    [cell.restaurantsImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
                    
                    cell.imgUnavailable.hidden = YES;
                    cell.lblUnavailable.hidden = YES;
                    cell.userInteractionEnabled = YES;
                    
                    
                }
                
                
            }

            
        }
        
        else
       {
           
           
           UnavailableImgStr =[NSString stringWithFormat:@"%@%@",RESTAURENTS_IMAGE_URL,UnavailableImages];
           
           NSLog(@"===image url  == %@",UnavailableImgStr);
           
           NSURL *url = [NSURL URLWithString:UnavailableImgStr];
           [cell.imgUnavailable sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
           
           
           cell.imgUnavailable.hidden = NO;
           cell.lblUnavailable.hidden = NO;
           cell.userInteractionEnabled = NO;

           
       }
        
        
    NSString *rating = [[totalResponseArray objectAtIndex:indexPath.row]objectForKey:@"rating"];
    if ([rating isEqual:[NSNull null]])
    {
        cell.ratingLabel.text = @"";
    }
    else
    {
        cell.ratingLabel.text = rating;
    }
    
        NSString *strfav = [[totalResponseArray objectAtIndex:indexPath.row]objectForKey:@"favourite"];
        
        if (tempImgNum == 1 || tempImgNum == 0 || [strfav intValue] == 1 ||[strfav intValue] == 0) {
            if (tempImgNum == 1 && [isFav isEqualToString:@"isFav"])
            {
                
                [cell.favButton setImage:[UIImage imageNamed:@"heartyfill.png"] forState:UIControlStateNormal];
                tempImgNum = 3;
            }
            else if(tempImgNum == 0 && [isFav isEqualToString:@"isFav"])
            {
                
                [cell.favButton setImage:[UIImage imageNamed:@"heartyy.png"] forState:UIControlStateNormal];
                
                tempImgNum = 3;
            }
            else if ([strfav intValue] == 1)
            {
                
                [cell.favButton setImage:[UIImage imageNamed:@"heartyfill.png"] forState:UIControlStateNormal];
                
            }
            else if ([strfav intValue] == 0)
            {
                
                [cell.favButton setImage:[UIImage imageNamed:@"heartyy.png"] forState:UIControlStateNormal];
            }
            
            
        }
        
        

        
       
    cell.TimeLabel.text =[[totalResponseArray objectAtIndex:indexPath.row]objectForKey:@"delivery_time"];
    cell.restaurantNameLabel.text = [[totalResponseArray objectAtIndex:indexPath.row]objectForKey:@"name"];

        cell.restaurantNameLabel.adjustsFontSizeToFitWidth = YES;
    cell.CuisinesLabel.text = [[totalResponseArray objectAtIndex:indexPath.row]objectForKey:@"cuisines"];
   

       strImg = [[totalResponseArray objectAtIndex:indexPath.row] objectForKey:@"restaurant_value"];
        
    
        if ([Utilities null_ValidationString:strImg])
                    {
        
                    if ([strImg isEqualToString:@"1"])
                {
                        cell.ruppeRatingImage.image = [UIImage imageNamed:@"3-gray.png"];
                    }
                    
                    else if ([strImg isEqualToString:@"2"])
                    {
                        cell.ruppeRatingImage.image = [UIImage imageNamed:@"2-gray.png"];
                    }
                    //minorder > 501 && minorder < 1000
                    else if ([strImg isEqualToString:@"3"])
                    {
                        cell.ruppeRatingImage.image = [UIImage imageNamed:@"1-gray.png"];
                    }
                   //minorder > 1000
                    else if ([strImg isEqualToString:@"4"])
                    {
                       cell.ruppeRatingImage.image = [UIImage imageNamed:@"rfourr.png"];
                    }
                    }

        
       cell.favButton.tag=indexPath.row;
[cell.favButton addTarget:self action:@selector(loveButtonAction:) forControlEvents:UIControlEventTouchUpInside];

}
    else
    {
        
//        totalFiltersResultArray  = [self.filterDict objectForKey:@"result"];
        NSLog(@"restaurants are%@",totalFiltersResultArray);
    cell.restaurantNameLabel.text = [[totalFiltersResultArray objectAtIndex:indexPath.row] objectForKey:@"name"];
        
        
      
        
        NSString *rating = [[totalFiltersResultArray objectAtIndex:indexPath.row]objectForKey:@"rating"];
        if ([rating isEqual:[NSNull null]]) {
            cell.ratingLabel.text = @"";
        }
        else {
            cell.ratingLabel.text = rating;
        }

        
        cell.CuisinesLabel.text = [[totalFiltersResultArray objectAtIndex:indexPath.row] objectForKey:@"cuisines"];
        cell.TimeLabel.text =[[totalFiltersResultArray objectAtIndex:indexPath.row] objectForKey:@"delivery_time"];
        
        ////
        
        restaurantsImages  = [[totalFiltersResultArray objectAtIndex:indexPath.row] objectForKey:@"logo"];
        UnavailableImages  = [[totalFiltersResultArray objectAtIndex:indexPath.row] objectForKey:@"unavailable_image"];
        
        imageString = [NSString stringWithFormat:@"%@%@",RESTAURENTS_IMAGE_URL,[imageArray objectAtIndex:indexPath.row]];
        
       // imageString = [NSString stringWithFormat:@"%@%@",RESTAURENTS_IMAGE_URL,restaurantsImages];
        
        NSLog(@"===image url  == %@",imageString);
        
        NSURL *url = [NSURL URLWithString:imageString];
        
        //    [cell.restaurantsImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
        
        
        
        if ([TerminateStr isEqualToString:@"0"])
        {
            [cell.restaurantsImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
            
            cell.imgUnavailable.hidden = YES;
            cell.lblUnavailable.hidden = YES;
            cell.userInteractionEnabled = YES;
            
            
            if (/*![[[totalFiltersResultArray objectAtIndex:indexPath.row] objectForKey:@"terminate_status"] isEqualToString:@"1"] ||*/ [[[totalFiltersResultArray objectAtIndex:indexPath.row] objectForKey:@"terminate_status"] intValue] == 0)
            {
                
                
                UnavailableImgStr =[NSString stringWithFormat:@"%@%@",RESTAURENTS_IMAGE_URL,UnavailableImages];
                
                NSLog(@"===image url  == %@",UnavailableImgStr);
                
                NSURL *url = [NSURL URLWithString:UnavailableImgStr];
                [cell.imgUnavailable sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
                
                
                cell.imgUnavailable.hidden = NO;
                cell.lblUnavailable.hidden = NO;
                cell.userInteractionEnabled = NO;
                
                
                /////for drivers
                UnavailableImgStr = [NSString stringWithFormat:@"%@%@",RESTAURENTS_IMAGE_URL,UnavailableImages];
                
                NSLog(@"===image url  == %@",UnavailableImgStr);
                
                NSURL *url1 = [NSURL URLWithString:UnavailableImgStr];
                [cell.imgUnavailable sd_setImageWithURL:url1 placeholderImage:[UIImage imageNamed:@""]];
                
                [cell setUserInteractionEnabled:NO];
                cell.lblUnavailable.hidden = NO;
                [cell.imgUnavailable setUserInteractionEnabled:NO];
                
            }
            else
            {
                [cell.restaurantsImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
                cell.imgUnavailable.hidden = YES;
                cell.lblUnavailable.hidden = YES;
                cell.userInteractionEnabled = YES;
                
                // for drivers
                NSString * stringConvertion = [NSString stringWithFormat:@"%d",[[[totalFiltersResultArray objectAtIndex:indexPath.row] objectForKey:@"restauant_availability"] intValue]];
                
                if (![stringConvertion intValue] == 1 )
                {
                    
                    UnavailableImgStr = [NSString stringWithFormat:@"%@%@",RESTAURENTS_IMAGE_URL,UnavailableImages];
                    
                    NSLog(@"===image url  == %@",UnavailableImgStr);
                    
                    NSURL *url2 = [NSURL URLWithString:UnavailableImgStr];
                    [cell.imgUnavailable sd_setImageWithURL:url2 placeholderImage:[UIImage imageNamed:@""]];
                    
                    
                    
                    [cell setUserInteractionEnabled:NO];
                    cell.imgUnavailable.hidden = NO;
                    cell.lblUnavailable.hidden = NO;
                    cell.userInteractionEnabled = NO;
                    
                    
                    
                    
                }
                else
                {
                    [cell.restaurantsImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
                    
                    cell.imgUnavailable.hidden = YES;
                    cell.lblUnavailable.hidden = YES;
                    cell.userInteractionEnabled = YES;
                    
                    
                }
                
                
            }
            
        }
        else
        {
            UnavailableImgStr =[NSString stringWithFormat:@"%@%@",RESTAURENTS_IMAGE_URL,UnavailableImages];
            
            NSLog(@"===image url  == %@",UnavailableImgStr);
            
            NSURL *url = [NSURL URLWithString:UnavailableImgStr];
            [cell.imgUnavailable sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
            
            
            cell.imgUnavailable.hidden = NO;
            cell.lblUnavailable.hidden = NO;
            cell.userInteractionEnabled = NO;

        }
        
        
        [cell.restaurantsImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
       
            
        NSString *strfav = [[totalFiltersResultArray objectAtIndex:indexPath.row]objectForKey:@"favourite"];
        
        
        if ([strfav intValue] == 1)
        {
            [cell.favButton setImage:[UIImage imageNamed:@"heartyfill.png"] forState:UIControlStateNormal];
        }
        else
        {
            [cell.favButton setImage:[UIImage imageNamed:@"heartyy.png"] forState:UIControlStateNormal];
        }
        
       // NSString * nullvalidate
       ImgStr = [[totalFiltersResultArray objectAtIndex:indexPath.row] objectForKey:@"restaurant_value"];
        
        
        if ([Utilities null_ValidationString:ImgStr])
        {
            
            if ([ImgStr isEqualToString:@"1"])
            {
                cell.ruppeRatingImage.image = [UIImage imageNamed:@"3-gray.png"];
            }
            
            else if ([ImgStr isEqualToString:@"2"])
            {
                cell.ruppeRatingImage.image = [UIImage imageNamed:@"2-gray.png"];
            }
            //minorder > 501 && minorder < 1000
            else if ([ImgStr isEqualToString:@"3"])
            {
                cell.ruppeRatingImage.image = [UIImage imageNamed:@"1-gray.png"];
            }
            //minorder > 1000
            else if ([ImgStr isEqualToString:@"4"])
            {
                cell.ruppeRatingImage.image = [UIImage imageNamed:@"rfourr.png"];
            }
        }
    
    }


    return cell;
    
}






-(void)loveButtonAction:(UIButton*)sender
{
    
    //addfavourates
    NSString *TypeString;
    
    isgetcart = NO;
    UIButton *btn=(UIButton *)sender;
    variantTag =btn.tag;
    isFav =@"isFav";

    
    
    
    NSString *strfav = [[totalResponseArray objectAtIndex:variantTag]objectForKey:@"favourite"] ;
    
    restarantIdStr = [[totalResponseArray objectAtIndex:variantTag] objectForKey:@"establishment_id"] ;
    
    
    static NSString *CellIdentifier = @"RestaurantsCell";
    
    RestaurantsCell *cell = [self.restaurantsTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if ([strfav intValue] == 1)
    {
        TypeString = @"2";
        tempImgNum = 0;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:btn.tag inSection:0];
        NSArray *indexPaths = [[NSArray alloc] initWithObjects:indexPath, nil];
        [self.restaurantsTableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        
    }
    else if ([strfav intValue] == 0)
    {
        TypeString =@"1";
        tempImgNum = 1;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:btn.tag inSection:0];
        NSArray *indexPaths = [[NSArray alloc] initWithObjects:indexPath, nil];
        
        [self.restaurantsTableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        
        
    }
    
    
    if ([Utilities isInternetConnectionExists]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
        });
        
        
        
        
        NSString *urlStr = [NSString stringWithFormat:@"%@addfavourates",BASEURL];
        requestDict = @{
                         @"user_id":[NSString stringWithFormat:@"%@",[Utilities getUserID]],
                        @"restaurant_id":restarantIdStr,
                        @"type":TypeString
                        };
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            ServiceManager *service = [ServiceManager sharedInstance];
            service.delegate = self;
            
            
            [service  handleRequestWithDelegates:urlStr info:requestDict];
            // [self uploadImagetoServer:urlStr];
            
        });
        
        
    }
    else
    {
        [Utilities displayCustemAlertViewWithOutImage:@"Internet connection error" :self.view];
    }
    

}



#pragma mark - Tableview delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (!self.filterDict){
    if ([Utilities isInternetConnectionExists]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"loading");
      //      [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
        });
    
    dispatch_async(dispatch_get_main_queue(), ^{

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    Menu = [storyboard instantiateViewControllerWithIdentifier:@"RestaurantsMenuViewController"];
   
    Menu.establishment_idStr =[[totalResponseArray objectAtIndex:indexPath.row] objectForKey:@"establishment_id"];
  //  Menu.gst_idStr = [[totalResponseArray objectAtIndex:indexPath.row] objectForKey:@"gst_value"]];
     [USERDEFAULTS setObject:[[totalResponseArray objectAtIndex:indexPath.row] objectForKey:@"establishment_id"] forKey:@"establishment_id"];
    
    [USERDEFAULTS setObject:[[totalResponseArray objectAtIndex:indexPath.row] objectForKey:@"latitude"] forKey:@"seltctedRestLat"];
    [USERDEFAULTS setObject:[[totalResponseArray objectAtIndex:indexPath.row] objectForKey:@"longitude"] forKey:@"seltctedRestLong"];
    [USERDEFAULTS setObject:[[totalResponseArray objectAtIndex:indexPath.row]
    objectForKey:@"gst_value"]forKey:@"seltctedRestGST"];

        if ([singleInstance.identifyStr isEqualToString:@"close"])
        {
            [arrcartItems removeAllObjects];
            Menu.isFromHomePage = YES;
        }
        else{
    
            Menu.isFromHomePage = YES;
          Menu.strcount = [NSString stringWithFormat:@"%d",[arrcartItems count]];
        }
        
        
        
   // Menu.strcount = [NSString stringWithFormat:@"%d",[arrcartItems count]];
        
     //   Menu.isCompare = YES;
        
//        NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:imageString]];
//        [USERDEFAULTS setObject:imageData forKey:@"imageData"];
//        [USERDEFAULTS objectForKey:@"imageData"];
        
        
        
        [self.navigationController pushViewController:Menu animated:YES];
     //[self restaurantAvailabilityService];

    //[self.navigationController pushViewController:Menu animated:YES];

   
   
        
         });
    
}
    }
    else
    {
        if ([Utilities isInternetConnectionExists]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"-loading");
        //        [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
            });
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                 Menu = [storyboard instantiateViewControllerWithIdentifier:@"RestaurantsMenuViewController"];
                
                Menu.establishment_idStr =[[totalFiltersResultArray objectAtIndex:indexPath.row] objectForKey:@"establishment_id"];
                
                [USERDEFAULTS setObject:[[totalResponseArray objectAtIndex:indexPath.row] objectForKey:@"establishment_id"] forKey:@"establishment_id"];
                

                [USERDEFAULTS setObject:[[totalFiltersResultArray objectAtIndex:indexPath.row] objectForKey:@"latitude"] forKey:@"seltctedRestLat"];
                [USERDEFAULTS setObject:[[totalFiltersResultArray objectAtIndex:indexPath.row] objectForKey:@"longitude"] forKey:@"seltctedRestLong"];
                [USERDEFAULTS setObject:[[totalFiltersResultArray objectAtIndex:indexPath.row]
                                         objectForKey:@"gst_value"]forKey:@"seltctedRestGST"];
                
                
                NSLog(@"establishment_id %@",[NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:@"establishment_id"]]);
                NSLog(@"seltctedRestLat %@",[NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:@"seltctedRestLat"]]);
                NSLog(@"seltctedRestLong %@",[NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:@"seltctedRestLong"]]);
                NSLog(@"seltctedRestGST %@",[NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:@"seltctedRestGST"]]);
                
            
                if ([singleInstance.identifyStr isEqualToString:@"close"])
                {
                    
                    [arrcartItems removeAllObjects];
                    Menu.isFromHomePage = YES;
                    
                }
                else{
                    
                    Menu.strcount = [NSString stringWithFormat:@"%d",[arrcartItems count]];
                    Menu.isFromHomePage = YES;
                    
                }
                [self.navigationController pushViewController:Menu animated:YES];
                // [self restaurantAvailabilityService];
                
            //    [self.navigationController pushViewController:Menu animated:YES];
                
                
                NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:imageString]];
                [USERDEFAULTS setObject:imageData forKey:@"imageData"];
                [USERDEFAULTS objectForKey:@"imageData"];
                
            });
            

    }
    }
}


-(void)restaurantAvailabilityService
{
    [self.view endEditing:YES];
    
    if ([Utilities isInternetConnectionExists]) {
        dispatch_async(dispatch_get_main_queue(), ^{
  //          [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
            //self.dummyView.hidden = NO;
            [self.mainshimmer1 addGlowEffectWithWidth:80 duration:1.5];
            [self.mainshimmer2 addGlowEffectWithWidth:80 duration:1.5];
            [self.mainShimmer3 addGlowEffectWithWidth:80 duration:1.5];
            
        });
        
        
        NSString *urlStr = [NSString stringWithFormat:@"%@restaurantAvailability",BASEURL];
        requestDict = @{
                        
                        @"establishment_id":[USERDEFAULTS valueForKey:@"establishment_id"]
                        
                        };
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            ServiceManager *service = [ServiceManager sharedInstance];
            service.delegate = self;
            
          
            isAvailability = YES;
            [service  handleRequestWithDelegates:urlStr info:requestDict];
            // [self uploadImagetoServer:urlStr];
            
        });
        
        
    }
    else
    {
        [Utilities displayCustemAlertViewWithOutImage:@"Internet connection error" :self.view];
    }
    
}

#pragma mark - Top Sliding
-(void)setUpScrollImages:(NSArray *)array
{
    [USERDEFAULTS setBool:YES forKey:@"SetScroolCalled"];
    
    @try {
        dispatch_async(dispatch_get_main_queue(), ^{
        pageControlBeingUsed = NO;
        CGRect scrollFrame = slidingScrollView.frame;
      //  scrollFrame.size.height = TOPSCROLLVIEW_HEIGHT;
//        scrollFrame.size.width = SCREEN_WIDTH;
        slidingScrollView.frame = scrollFrame;
        
        for (int i = 0; i < array.count; i++)
        {
            CGRect frame;
            frame.origin.x = SCREEN_WIDTH * i;
            frame.origin.y = 0;
            frame.size = slidingScrollView.frame.size;
            
            imageView       =   [[UIImageView alloc] initWithFrame:frame];
            UIImageView *transparentImage       =   [[UIImageView alloc] init];

            
          
            UILabel *cashbackLbl1,*cashbackLbl2,*placeandKmLbl,*restaurentNameLbl,*ratingbl,*dealsLbl;
            cashbackLbl1 = [[UILabel alloc] init];
            cashbackLbl2 = [[UILabel alloc] init];
            placeandKmLbl = [[UILabel alloc] init];
            restaurentNameLbl = [[UILabel alloc] init];
            ratingbl = [[UILabel alloc] init];
            dealsLbl = [[UILabel alloc] init];
            
            cashbackLbl1.textColor = WHITECOLOR;
            cashbackLbl2.textColor = WHITECOLOR;
            restaurentNameLbl.textColor = WHITECOLOR;
            placeandKmLbl.textColor = WHITECOLOR;
            ratingbl.textColor = YELLOW;
            dealsLbl.textColor = WHITECOLOR;
            
            
            
//            transparentImage .frame = CGRectMake(0, imageView.frame.size.height-120 , imageView.frame.size.width, 160);
//            transparentImage.alpha = 0.3;
            
            dealsLbl.textAlignment = NSTextAlignmentRight;
            ratingbl.textAlignment = NSTextAlignmentRight;
            //imageView.contentMode        =    UIViewContentModeScaleAspectFit;
            imageView.contentMode        =    UIViewContentModeScaleToFill;
            imageView.layer.masksToBounds = YES;
            
           
            NSString * imgStr = [Utilities null_ValidationString:[[array objectAtIndex:i] valueForKey:@"image"]];
            
            if (imgStr.length) {
                NSString *imageUrl = [NSString stringWithFormat:@"%@%@",BASEURLBanner,[Utilities null_ValidationString:[[array objectAtIndex:i] valueForKey:@"image"]]];
                
                imageUrl = [imageUrl stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
                //NSLog(@"muralimg = %@",imageUrl);
                [  imageView setContentMode:UIViewContentModeScaleAspectFill];
                [  imageView setClipsToBounds:YES];
                
                if ([[[ImageCache sharedManager] imageCache] objectForKey:imageUrl])
                {
                    imageView.image =[[[ImageCache sharedManager] imageCache] objectForKey:imageUrl];
                    
                }
                else
                {
                    [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                                 placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                    _mainShimmer3.hidden = YES;
                }

            }
            
            
           // [Utilities addLinearGradientToView:imageView withColor:CLEARCOLOR];
            

            
            [slidingScrollView addSubview:imageView];
            [imageView addSubview:transparentImage];
            [imageView addSubview:cashbackLbl1];
            [imageView addSubview:cashbackLbl2];
            [imageView addSubview:placeandKmLbl];
            [imageView addSubview:restaurentNameLbl];
            [imageView addSubview:ratingbl];
            [imageView addSubview:dealsLbl];
            slidingScrollView.backgroundColor = CLEARCOLOR;
            imageView.backgroundColor = CLEARCOLOR;
        }
        
        slidingScrollView.backgroundColor = CLEARCOLOR;
        slidingScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * array.count, 150);
        pageControl.currentPage    = 0;
        pageControl.numberOfPages  = array.count;
    });
    }
    @catch (NSException *exception) {
        //@"%@", exception.reason);
        //@throw;
        
    }
    @finally {
    }
    
    
}
-(void)scrollingTimer
{
    if([timerCheck isEqualToString:@"Yes"]){
        
        
        NSInteger pageCount = pageControl.currentPage;
        
        if(pageControl.currentPage+1 >= [pageImages count])
        {
            pageCount = 0;
        }
        else
        {
            pageCount = pageCount+1;
        }
        pageControl.currentPage = pageCount;
        
        CGPoint offset = CGPointMake(slidingScrollView.bounds.size.width * pageCount,
                                     slidingScrollView.contentOffset.y);
        
        [UIView animateWithDuration:.8
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             [slidingScrollView setContentOffset:offset animated:NO];
                         } completion:nil];
    }
    
    
    
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    if (totalResponseArray.count) {
        self.dummyView.hidden = YES;
    }
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //[self.navigationController setNavigationBarHidden:YES animated:YES];

    
    timerCheck = @"No";
    

    
    timeForScroolAnimation= nil;
    //[bottomItemsView removeFromSuperview];
    [timeForScroolAnimation invalidate];
    
    
    CGPoint newOffset = slidingScrollView.contentOffset;
    newOffset.y = 0;
    [slidingScrollView setContentOffset:newOffset animated:YES];
    
    cartView.hidden  = YES;
    
   
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    ////filterView.hidden = YES;
    if([pageImages count]>0){
     
            // your tableview is scrolled.
            // Add your code here
                if (scrollView.contentOffset.y == 0)
                    //@"At the top");
                    
                    
                    if (!pageControlBeingUsed)
                    {
                        if(pageImages.count>0){
                            
                            CGFloat pageWidth           =    slidingScrollView.frame.size.width;
                            int page                    =    floor((slidingScrollView.contentOffset.x - pageWidth / 3) / pageWidth) + 1;
                            pageControl.currentPage = page;
                        }
                    }
                // //@"%f",scrollView.frame.origin.x);
                if(![USERDEFAULTS valueForKey:@"BothDataShow"])
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                    });
                    //filterView.hidden = NO;
                }
                else
                {
                    // //@"%f",slidingScrollView.contentSize.height);
                    ////@"%f",restaurentsTableView.contentOffset.y);
                    
                   
                        if([pageImages count]>0)
                        {
                            //filterView.hidden = YES;
                        }
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [UIView animateKeyframesWithDuration:1.0
                                                           delay:0.0
                                                         options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionAllowUserInteraction
                                                      animations:^{
                                                          
                                                          [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                                                                        forBarMetrics:UIBarMetricsDefault];
                                                          self.navigationController.navigationBar.shadowImage = [UIImage new];
                                                          self.navigationController.navigationBar.translucent = YES;
                                                          
                                                          
                                                      } completion:nil];
                        });
                    
                }
            
        }
        
    
}
/*!
 @param         UIScrollView
 @discussion    this method used to scrollView begin dragging scrolling  on home page
 @return        nil
 */

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
   
    pageControlBeingUsed = NO;
    
    // [self.navigationController setNavigationBarHidden:YES
    // animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pageControlBeingUsed = NO;
    
    // [self.navigationController setNavigationBarHidden:NO
    // animated:YES];
}

- (IBAction)showPageScrolls:(UIPageControl *)sender
{
    CGRect frame;
    frame.origin.x = slidingScrollView.frame.size.width * pageControl.currentPage;
    frame.origin.y = 0;
    frame.size     = slidingScrollView.frame.size;
    [slidingScrollView scrollRectToVisible:frame animated:YES];
    pageControlBeingUsed = YES;
    
}

-(void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    //[self.navigationController setNavigationBarHidden:YES
    //            animated:YES];
}




//action for cart btn
- (IBAction)Cart_Click:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ReviewOrderViewController * search = [storyboard instantiateViewControllerWithIdentifier:@"ReviewOrderViewController"];
    
    [self.navigationController pushViewController:search animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
    // Turn off the location manager to save power.
    [self.locationManager stopUpdatingLocation];
    
//    [self.revealViewController.frontViewController.view setUserInteractionEnabled:YES];
    
}


@end
