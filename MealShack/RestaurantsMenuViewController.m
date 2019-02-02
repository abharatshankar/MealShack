//
//  RestaurantsMenuViewController.m
//  MealShack
//
//  Created by Bharat shankar on 31/07/17.
//  Copyright © 2017 Possibillion. All rights reserved.
//

#import "RestaurantsMenuViewController.h"
#import "RestaurantsMenuCell.h"
#import "Utilities.h"
#import "Constants.h"
#import "ServiceManager.h"
#import "SWRevealViewController.h"
#import "SearchViewController.h"
#import "UIImageView+WebCache.h"
#import "CategoryItemTableViewCell.h"
#import "DBManager.h"
#import "CartModel.h"
#import "ReviewOrderViewController.h"
#import "Pop.h"
#import "SingleTon.h"
#import "UILabel+SOXGlowAnimation.h"




@interface RestaurantsMenuViewController ()<ServiceHandlerDelegate,RestaurantsMenuCellDelegate,CategoryItemTableViewCellDelegate>
{
    NSMutableArray * totalMenuArray,*sectionsArray,*imageArray;
     NSDictionary *requestDict,*totalDetailsDict;
    NSMutableArray * mostpopImage;
     NSString * imageString;
    NSData * imageData ;
    BOOL  isSwitchoff,isfavrite,isSwitchBtn;
    NSMutableArray *arrMostPopular;
    NSString *strItemName, * strItemPrice, * strItemCatName,*typeCategory;
    BOOL isAvailability;
    NSString * availabilityStr, *terminateStr, * adminTerm_status;

    int indexNumFromClick;
    int cellCountNumCheck;
    NSString * itemNameStr, * itemPriceStr;
    NSString * itemQuantStr, * itemIdStr;
    BOOL * isClicked;
    BOOL * clicked;
    BOOL isrestaurantsMenuService;
    BOOL isAfterClickCat;
    NSMutableArray *arrAllItems;
    NSArray *arrTemp;
    NSArray *arrData;
    NSMutableArray *itemsArray;
    NSMutableArray *categoryNamesArray;
    NSString *restarantIdStr;
    
    NSMutableArray *quantityArr;
    NSMutableArray *quantities;
    NSMutableArray *alertsArray;
    NSString * strVarientDifferent;
    
    BOOL * boolUpdate,*isVaraiantChanged,*isVaraiantChanged1,*isMostPopular,*isDecreased;
    NSMutableDictionary * dummyDic;
    NSMutableArray * dummyArray;
    NSString * ratingString;
    NSMutableArray *arrfoodTypeList;
    NSString *strEid;
    BOOL isdeletecart;
    
    NSDictionary *addDict;
    NSString * addprice,*addqty;
   
    SingleTon *singleTonInstance;
    
    IBOutlet UIView *cartView;
    float * height ,*height1 ;
    NSMutableArray * itemsIdsArray;
    NSString * ImgStr;
    NSString *gst_value;
    BOOL * isgetcart;
    NSMutableArray * arrcartItems;
    NSString * establishmentString;
    int itemcount;
    NSInteger section;
    BOOL * isdeleteall;
    NSString * strCartCountDisplay;
    NSString * strCount;
//    BOOL isAvailability;
//    NSString * availabilityStr, *terminateStr, * adminTerm_status;
}

@end

@implementation RestaurantsMenuViewController
@synthesize favbutton,switchoff,cartCountLabel,strcount,lblcartTotal;

- (void)viewDidLoad
{
    [super viewDidLoad];
    //NEW


    switchoff.hidden = YES;
    favbutton.hidden = YES;
    self.starImage.hidden = YES;
    self.clockImage.hidden =YES;
    self.vegetarianLbl.hidden = YES;
    _shim3.hidden = NO;
    _RestaurantsMenuTableView.hidden = YES;
    _popoverBtn.hidden = YES;
    _popoverBtn.layer.cornerRadius = self.popoverBtn.frame.size.width/2;
    _shim1.hidden = NO;
    _shim2.hidden = NO;
    _shim4.hidden = NO;

    singleTonInstance = [SingleTon singleTonMethod];
    singleTonInstance.CategorynamesArray = [[NSMutableArray alloc]init];
    
    // Do any additional setup after loading the view.
    totalMenuArray =[[NSMutableArray alloc]init];
    mostpopImage =[[NSMutableArray alloc]init];
    sectionsArray =[[NSMutableArray alloc]init];
    totalDetailsDict =[[NSMutableDictionary alloc]init];
    imageArray =[[NSMutableArray alloc]init];
    arrMostPopular=[[NSMutableArray alloc]init];
    categoryNamesArray=[[NSMutableArray alloc]init];
    arrfoodTypeList = [[NSMutableArray alloc] init];
    arrcartItems = [[NSMutableArray alloc]init];

   itemsIdsArray = [[NSMutableArray alloc]init];
    
    lblcartTotal.layer.borderColor = 0;
    lblcartTotal.layer.cornerRadius = lblcartTotal.frame.size.height/2;
    lblcartTotal.layer.backgroundColor =WHITECOLOR.CGColor;
    lblcartTotal.layer.borderColor = WHITECOLOR.CGColor;
    lblcartTotal.layer.masksToBounds = YES;
    
    
    
    if ([strcount intValue] > 0)
    {
        lblcartTotal.text = [NSString stringWithFormat:@"%@",strcount];
        
        cartView.hidden = NO;

    }
else
    cartView.hidden = YES;
    
    isDecreased = NO;
    
    arrAllItems=[[NSMutableArray alloc]init];
    arrData =[[NSArray alloc]init];
    itemsArray = [[NSMutableArray alloc]init];
    categoryArray = [NSMutableArray new];
    
    _RestaurantsMenuTableView.delegate = self;
    _RestaurantsMenuTableView.dataSource = self;
    
//    UINavigationBar *bar = [self.navigationController navigationBar];
//    [bar setTintColor:[UIColor clearColor]];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];

    
    [[self.backButton imageView] setContentMode: UIViewContentModeScaleAspectFit];

    
    SWRevealViewController *revealController = [self revealViewController];

    revealController.panGestureRecognizer.enabled = NO;

    
    [self.headerView setDelegate:self];
    [self.headerView setCollapsingConstraint:_headerHeight];
    
    [self.headerView addFadingSubview:self.dimLabel fadeBy:0.3];
    [self.headerView addFadingSubview:self.starImage fadeBy:0.3];
    [self.headerView addFadingSubview:self.restarantRating fadeBy:0.3];
    [self.headerView addFadingSubview:self.favbutton fadeBy:0.3];
    [self.headerView addFadingSubview:self.clockImage fadeBy:0.3];
    [self.headerView addFadingSubview:self.restaurantDeliveryTime fadeBy:0.3];
    [self.headerView addFadingSubview:self.ruppeeRatingImage fadeBy:0.3];
    [self.headerView addFadingSubview:self.restaurantRating fadeBy:0.3];
    NSArray *attrs;
    double r = 16.0;
    attrs    = @[
                 [MGTransform transformAttribute:MGAttributeX byValue:-r],
                 [MGTransform transformAttribute:MGAttributeY byValue:-r],
                 [MGTransform transformAttribute:MGAttributeWidth byValue:2 * r],
                 [MGTransform transformAttribute:MGAttributeHeight byValue:2 * r],
                 [MGTransform transformAttribute:MGAttributeCornerRadius byValue:r],
                 [MGTransform transformAttribute:MGAttributeFontSize byValue:12.0]
                 ];
    //    [self.headerView addTransformingSubview:self.button1 attributes:attrs];
    
    
    // Push this button closer to the bottom-right corner since the header view's height
    // is resizing.
    attrs = @[
              [MGTransform transformAttribute:MGAttributeX byValue:10.0],
              [MGTransform transformAttribute:MGAttributeY byValue:13.0],
              [MGTransform transformAttribute:MGAttributeWidth byValue:-32.0],
              [MGTransform transformAttribute:MGAttributeHeight byValue:-32.0]
              ];
    //[self.headerView addTransformingSubview:self.button1 attributes:attrs];
    
    attrs = @[
              [MGTransform transformAttribute:MGAttributeY byValue:-30.0],
              [MGTransform transformAttribute:MGAttributeWidth byValue:-30.0],
              [MGTransform transformAttribute:MGAttributeHeight byValue:-20.0],
              [MGTransform transformAttribute:MGAttributeFontSize byValue:-10.]
              ];
    [self.headerView addTransformingSubview:self.restaurantName attributes:attrs];

    
    
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"CategorySelected" object:nil];

}

-(void)viewDidDisappear:(BOOL)animated
{
//    self.navigationController.navigationBar.hidden =NO
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)setUpNavigationBar
{
    SWRevealViewController *revealController = [self revealViewController];
    
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
   
    
   
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if (self.isFromHomePage == YES) {
        [self restaurantAvailabilityService];
        self.isFromHomePage = NO;
    }
    
    
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateLabelStr:) name:@"UpdateLabel" object:nil];
  

    dispatch_async(dispatch_get_main_queue(), ^ {
        
   [singleTonInstance.CategorynamesArray removeAllObjects];
        
    //
    [self restaurantsMenuService];

      
        });
}


-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO];
}


- (void)updateLabelStr:(NSNotification*)notification
{
    // Update the UILabel's text to that of the notification object posted from the other view controller
    lblcartTotal.text = notification.object;
    cartView.hidden = YES;
    
    NSLog(@"–--");
}

- (void)dealloc
{
    // Clean up; make sure to add this
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

//-(void)Back_Click:(id)sender
//{
//  [self.navigationController popViewControllerAnimated:YES];
//}

- (void)searchMethodClicked:(id)sender
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchViewController * search = [storyboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
    [self.navigationController pushViewController:search animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//NEW
- (void)handleNotification:(NSNotification*)note {
    NSLog(@"Got notified: %@", note);
    NSDictionary *dict = note.object;
    int section = [[dict objectForKey:@"index"] intValue];
    indexNumFromClick = [[dict objectForKey:@"index"] intValue];;
    if (section == 0) {
        if (arrMostPopular == (id)[NSNull null] || [arrMostPopular count] == 0) {
            NSLog(@"array is empty");
            // return arrMostPopular.count;
            return;
        }
        else{
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
            
            [_RestaurantsMenuTableView scrollToRowAtIndexPath:indexPath
                                             atScrollPosition:UITableViewScrollPositionTop
                                                     animated:YES];

        }
    }else{
       // [self afterClickCategoriesService];

        NSDictionary *dict = [categoryArray objectAtIndex:section - 1];
        NSArray *array = [dict valueForKey:@"items"];
        if (array.count != 0)
        {
//            if (categoryArray.count) {
//                [categoryArray removeAllObjects];
//            }
//            for (int i=0; i<array.count; i++) {
//                [categoryArray addObject:[array objectAtIndex:i]];
//            }
            
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
            [_RestaurantsMenuTableView scrollToRowAtIndexPath:indexPath
                                             atScrollPosition:UITableViewScrollPositionTop
                                                     animated:YES];
        }
    }
}



-(void)afterClickCategoriesService
{
    
    [self.view endEditing:YES];
    
    if ([Utilities isInternetConnectionExists]) {
        isAfterClickCat = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            //  [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
            
            [self.shim1 addGlowEffectWithWidth:80 duration:1.5];
            [self.shim2 addGlowEffectWithWidth:80 duration:1.5];
            [self.shim3 addGlowEffectWithWidth:80 duration:1.5];
            [self.shim4 addGlowEffectWithWidth:80 duration:1.5];
            
            
        });
        
        isrestaurantsMenuService = YES;
        
        NSString *urlStr = [NSString stringWithFormat:@"%@restaurantCategoryItems",BASEURL];
        requestDict = @{
                        
                        @"establishment_id":self.establishment_idStr,
                        @"user_id":[Utilities getUserID],
                        @"sort_type":@""
                        
                        };
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            ServiceManager *service = [ServiceManager sharedInstance];
            service.delegate = self;
            
            isdeletecart = NO;
            boolUpdate = NO;
            [service  handleRequestWithDelegates:urlStr info:requestDict];
            // [self uploadImagetoServer:urlStr];
            
        });
        
        
    }
    else
    {
        [Utilities displayCustemAlertViewWithOutImage:@"Internet connection error" :self.view];
    }
    

}




////Table view method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return categoryArray.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if (arrMostPopular == (id)[NSNull null] || [arrMostPopular count] == 0) {
            NSLog(@"array is empty");
            // return arrMostPopular.count;
            [self restaurantsMenuService];
            return 0;
        }
        else
        {
            cellCountNumCheck = arrMostPopular.count;
            return arrMostPopular.count;
        }
        
        
        
    }else{
        NSDictionary *dict = [categoryArray objectAtIndex:section - 1];
        NSArray *array = [dict valueForKey:@"items"];
        
        cellCountNumCheck = array.count;
        return array.count;
        
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
       // return 180;
        return  180;
       
    }else{
        //return 76;
        return 76;
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == categoryArray.count) {
        return _popview.frame.size.height+2;
    }
    else
    return 2;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 25)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 18)];
    [label setFont:[UIFont boldSystemFontOfSize:14]];
    if (section == 0) {
        NSString *string =@"Most Popular";
        /* Section header is in 0th index... */
        [label setText:string];
        [label setTextColor:REDCOLOR];
    }else{
        NSDictionary *dict = [categoryArray objectAtIndex:section - 1];
        NSString *string = [dict valueForKey:@"item_category_name"];
        /* Section header is in 0th index... */
        [label setText:string];
        [label setTextColor:REDCOLOR];
    }
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, tableView.frame.size.width, 1)];
    [lineLabel setBackgroundColor:REDCOLOR];
    
    [view addSubview:label];
    [view addSubview:lineLabel];
    
    [view setBackgroundColor:[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0]]; //your background color...
    return view;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell...
   
    
  //  cartCountLabel.hidden= NO;
    
    if (indexPath.section == 0) {
        
        isMostPopular = YES;
        
        static NSString *CellIdentifier = @"RestaurantsMenuCell";
        
        RestaurantsMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[RestaurantsMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        }
        
        [Utilities setBorderView:cell.lineView :0 :LIGHTGRYCOLOR];

        [Utilities addShadowtoView:cell.bgView];
        

        
        
        NSLog(@"cellForRowAtIndexPath");
        
        
        /////most popular
        NSDictionary *dict = [arrMostPopular objectAtIndex:indexPath.row];
        //Each dictionary contains Item
        if ([[dict valueForKey:@"item_status"] intValue] == 0)
        {
            cell.imgUnavailable.hidden = NO;
            cell.lblunavailable.hidden = NO;
            cell.userInteractionEnabled = NO;
            
            
        }
        else
        {
            cell.imgUnavailable.hidden = YES;
            cell.lblunavailable.hidden = YES;
            cell.userInteractionEnabled = YES;
        }
        
        
        
        [cell.itemNameLbl adjustsFontSizeToFitWidth];
        cell.itemNameLbl.text = [dict valueForKey:@"item_name"];
        cell.itemPriceLbl.text = [dict valueForKey:@"price"];
        
        cell.itemNameLbl.minimumFontSize = 8;
        cell.itemNameLbl.adjustsFontSizeToFitWidth = YES;
        
        
        
        cell.itemCountLabel.text = [dict valueForKey:@"quantity"];

        
        cell.bgView.layer.borderWidth = 1;
        cell.bgView.layer.borderColor = [[UIColor whiteColor] CGColor];
       
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
        dispatch_async(queue, ^{
        //imageString = [NSString stringWithFormat:@"http://35.240.151.154//uploads/items/%@",mostpopImage];
        mostpopImage  = [dict objectForKey:@"photo"];
            NSLog(@"actuall image is %@",mostpopImage);
            
            imageString = [NSString stringWithFormat:@"%@%@",ITEMS_IMAGE_URL,mostpopImage];
        NSURL *url = [NSURL URLWithString:imageString];
        dispatch_async(dispatch_get_main_queue(), ^{
        [cell.itemImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
        });
        });
       
       
        
        cell.incrementButton.tag=indexPath.row;
        cell.decrementButton.tag=indexPath.row;
        
        [cell.incrementButton addTarget:self action:@selector(increaseLabelCount:) forControlEvents:UIControlEventTouchUpInside];
        [cell.decrementButton addTarget:self action:@selector(decreaseLabelCount:) forControlEvents:UIControlEventTouchUpInside];
        
        
        return cell;
    }
    else
    {
        
        isMostPopular = NO;
        
        static NSString *CellIdentifier = @"CategoryCell";
        CategoryItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[CategoryItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        }
        NSDictionary *dict1 = [categoryArray objectAtIndex:indexPath.section - 1];
        NSArray *array = [dict1 valueForKey:@"items"];
        NSDictionary *dict = [array objectAtIndex:indexPath.row];
        //Each dictionary contains Item
        
        [cell.nameLabel adjustsFontSizeToFitWidth];
        cell.nameLabel.minimumFontSize = 8;
        cell.nameLabel.adjustsFontSizeToFitWidth = YES;
        cell.nameLabel.text = [dict valueForKey:@"item_name"];
        cell.priceLabel.text = [dict valueForKey:@"price"];
        [Utilities addShadowtoView:cell.bgView];
        [Utilities setBorderView:cell.lineView :0 :LIGHTGRYCOLOR];

        if ([[dict valueForKey:@"item_status"] intValue] == 0)
        {
            cell.imgUnavailable.hidden = NO;
            cell.lblunavailable.hidden = NO;
            cell.userInteractionEnabled = NO;
            [Utilities setBorderView:cell.lblunavailable :1 :LIGHTGRYCOLOR];
        }
        else
        {
            cell.imgUnavailable.hidden = YES;
            cell.lblunavailable.hidden = YES;
            cell.userInteractionEnabled = YES;
        }

         cell.itemCountLabel.text = [dict valueForKey:@"quantity"];
       
        
        cell.Increment_Button.tag=indexPath.row;
        cell.decrement_Button.tag=indexPath.row;

        
        
        [cell.Increment_Button addTarget:self action:@selector(increaseLabelCount:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.decrement_Button addTarget:self action:@selector(decreaseLabelCount:) forControlEvents:UIControlEventTouchUpInside];
        
        
        return cell;
    }
    
 
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSDictionary *dict ;
    
     if (indexPath.section == 0)
     {
         dict = [arrMostPopular objectAtIndex:indexPath.section];
         if([arrfoodTypeList containsObject:[NSString stringWithFormat:@"%@",[dict valueForKey:@"items_id"]]])

         {
             [arrfoodTypeList removeObjectAtIndex:indexPath.section];
         }
         else
         {
             [arrfoodTypeList addObject:[NSString stringWithFormat:@"%@",[dict valueForKey:@"items_id"]]];
         }

         
     }
    else
    {
         dict = [categoryArray objectAtIndex:indexPath.section - 1];
        if([arrfoodTypeList containsObject:[NSString stringWithFormat:@"%@",[dict valueForKey:@"items_id"]]])
        {
            [arrfoodTypeList removeObjectAtIndex:indexPath.section - 1];
        }
        else
        {
            [arrfoodTypeList addObject:[NSString stringWithFormat:@"%@",[dict valueForKey:@"items_id"]]];
        }

    }
 
    
    [_RestaurantsMenuTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];

}


#pragma mark -
#pragma mark Scroll View Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.headerView collapseWithScroll:scrollView];
    
    NSLog(@"V:|-(%.2f)-header(%.2f)-(%.2f)-|",
          _headerTop.constant,
          _headerHeight.constant,
          _TableViewTop.constant);
}



#pragma mark -
#pragma mark Collapsing Header Delegate

- (void)headerDidCollapseToOffset:(double)offset
{
    
    NSLog(@"collapse %.4f", offset);
    
   
}
- (void)headerDidFinishCollapsing
{
    NSLog(@"collapsed!!!");
    self.headerView.backgroundColor=REDCOLOR;
    self.restaurantImage.hidden=YES;

    
}
- (void)headerDidExpandToOffset:(double)offset
{
    NSLog(@"expand %.4f", offset);
    
    self.headerView.backgroundColor=CLEARCOLOR;
    self.restaurantImage.hidden=NO;
    }
- (void)headerDidFinishExpanding
{
    NSLog(@"expanded!!!");
}

-(BOOL)isItemExistsInScrollView:(NSDictionary *)object
{
    BOOL isFound = NO;
    for (NSDictionary *dict in arrMostPopular) {
        if ([[dict objectForKey:@"items_id"] isEqualToString:[object objectForKey:@"items_id"]]) {
            isFound = YES;
            break;
        }
    }
    return isFound;
}

-(void)increaseLabelCount:(UIButton *)sender
{
    
    
    if ([Utilities isInternetConnectionExists]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
        });
    
    NSLog(@"current establishment =%@",self.establishment_idStr);

    strEid = [NSString stringWithFormat:@"%@",[Utilities null_ValidationString:[USERDEFAULTS valueForKey:@"establishmentString"]]];

    boolUpdate = YES;
    isDecreased = NO;
    cartView.hidden = NO;
  
    
    UIButton *btn=(UIButton *)sender;
    NSIndexPath *indexPath;
    
    UIButton *senderButton = (UIButton *)sender;
    NSLog(@"current Row=%d",senderButton.tag);
    
    NSLog(@"current Row path =%d",senderButton.tag);
    
    
    
    
    CGPoint touchPoint = [sender convertPoint:CGPointZero toView:_RestaurantsMenuTableView];
    NSIndexPath *clickedButtonIndexPath = [_RestaurantsMenuTableView indexPathForRowAtPoint:touchPoint];
    
    NSInteger row = clickedButtonIndexPath.row;
    section = clickedButtonIndexPath.section;
    
    NSLog(@"current Row=%d",row);
    
    NSLog(@"current Row path =%d",section);
    
    NSMutableArray * sectionCountArray = [[NSMutableArray alloc]init];
   sectionCountArray =   [totalDetailsDict valueForKey:@"categories"];
    
    RestaurantsMenuCell *cell;
    CategoryItemTableViewCell *cell2 ;
    
    int itemCount;
    NSMutableDictionary  *dict = [[NSMutableDictionary alloc] init];
    NSString  *strPrice;
    
    
    
    if (section == 0)
    {
         indexPath = [NSIndexPath indexPathForRow:btn.tag inSection:0];
        cell  = (RestaurantsMenuCell *)[_RestaurantsMenuTableView cellForRowAtIndexPath:indexPath];
        
        itemCount =  [cell.itemCountLabel.text intValue];
        itemCount ++;
       
        dict =[arrMostPopular objectAtIndex:btn.tag];
        strPrice = [NSString stringWithFormat:@"%@",[dict valueForKey:@"price"]];
    }
    else
        
    {
        for (int i = 0 ; i < sectionCountArray.count+1; i++) {
            if (section == i)
            {
                
                indexPath = [NSIndexPath indexPathForRow:btn.tag inSection:i];
                cell2 = (CategoryItemTableViewCell *)[_RestaurantsMenuTableView cellForRowAtIndexPath:indexPath];
                
                itemCount =  [cell2.itemCountLabel.text intValue];
                itemCount ++;
                
                dict = [categoryArray objectAtIndex:indexPath.section - 1];
                NSArray *array = [dict valueForKey:@"items"];
                dict = [array objectAtIndex:btn.tag];
                strPrice = [NSString stringWithFormat:@"%@",[dict valueForKey:@"price"]];
                
            }
        }
    }
    
    

    addDict = dict;
    addprice = strPrice;
    addqty = [NSString stringWithFormat:@"%d",itemCount];
    
    if ([strEid isEqualToString:@""])
    {
    [self addtocartItems:dict itemcount:[NSString stringWithFormat:@"%d",itemCount] variant:strPrice];
        
        if (section == 0)
        {
            if([[[arrMostPopular objectAtIndex:btn.tag] valueForKey:@"items_id"] isEqualToString:[NSString stringWithFormat:@"%@",[dict valueForKey:@"items_id"]]])
                
            {
                [dict removeObjectForKey:@"quantity"];
                [dict setValue:[NSString stringWithFormat:@"%d",itemCount] forKey:@"quantity"];
                [arrMostPopular replaceObjectAtIndex:btn.tag withObject:dict];
                cell.itemCountLabel.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"quantity"]];
               
               
                
            }
        }
        else
        {
                for (int i = 0; i < sectionCountArray.count+1; i++)
                {
                    if (section == i) {
                        dict = [categoryArray objectAtIndex:indexPath.section - 1];
                        NSArray *array = [dict valueForKey:@"items"];
                        dict = [array objectAtIndex:btn.tag];
                        
                        
                        if([[[array objectAtIndex:btn.tag] valueForKey:@"items_id"] isEqualToString:[NSString stringWithFormat:@"%@",[dict valueForKey:@"items_id"]]])
                            
                        {
                            dict = [categoryArray objectAtIndex:indexPath.section - 1];
                            NSArray *array = [dict valueForKey:@"items"];
                            dict = [array objectAtIndex:btn.tag];
                            
                            [dict removeObjectForKey:@"quantity"];
                            [dict setValue:[NSString stringWithFormat:@"%d",itemCount] forKey:@"quantity"];
                            
                            [[[categoryArray objectAtIndex:indexPath.section - 1] valueForKey:@"items"] replaceObjectAtIndex:btn.tag withObject:dict];
                            cell2. itemCountLabel.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"quantity"]];
                           
                            
                        }
                        

                    }

                }
            }
    }
    else if ([self.establishment_idStr isEqualToString:strEid])
    {
        
      
        if (itemCount > 0)
        {
            [self updateInDB:dict itemcount:[NSString stringWithFormat:@"%d",itemCount] variant:strPrice];
            

            if (section == 0)
            {
            if([[[arrMostPopular objectAtIndex:btn.tag] valueForKey:@"items_id"] isEqualToString:[NSString stringWithFormat:@"%@",[dict valueForKey:@"items_id"]]])
                
            {
                [dict removeObjectForKey:@"quantity"];
                [dict setValue:[NSString stringWithFormat:@"%d",itemCount] forKey:@"quantity"];
                [arrMostPopular replaceObjectAtIndex:btn.tag withObject:dict];
                 cell.itemCountLabel.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"quantity"]];
                
                
            }
            }
            else
            {
                 for (int i = 0; i < sectionCountArray.count+1; i++)
                 {
                     if (section == i)
                     {
                         dict = [categoryArray objectAtIndex:indexPath.section - 1];
                         NSArray *array = [dict valueForKey:@"items"];
                         dict = [array objectAtIndex:btn.tag];
                         
                         
                         if([[[array objectAtIndex:btn.tag] valueForKey:@"items_id"] isEqualToString:[NSString stringWithFormat:@"%@",[dict valueForKey:@"items_id"]]])
                             
                         {
                             dict = [categoryArray objectAtIndex:indexPath.section - 1];
                             NSArray *array = [dict valueForKey:@"items"];
                             dict = [array objectAtIndex:btn.tag];
                             
                             [dict removeObjectForKey:@"quantity"];
                             [dict setValue:[NSString stringWithFormat:@"%d",itemCount] forKey:@"quantity"];
                             
                             [[[categoryArray objectAtIndex:indexPath.section - 1] valueForKey:@"items"] replaceObjectAtIndex:btn.tag withObject:dict];
                             cell2. itemCountLabel.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"quantity"]];
                             
                             
                         }
 
                     }
                 }
            }
        }
   
    dispatch_async(dispatch_get_main_queue(), ^{
         [_RestaurantsMenuTableView reloadData];
    });
  
    
}

else
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *LogoutAlert = [[UIAlertView alloc]initWithTitle:@"" message:@"Items are already in the Cart.Do you want to remove already added Items?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
        [LogoutAlert show];
        
        
    });
    
  }

}
    else
    {
        [Utilities displayCustemAlertViewWithOutImage:@"Internet connection error" :self.view];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [Utilities removeLoading:self.view];
    });
    

}

 //Do you want to delete cart?

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex == 1)
    {
        if ([Utilities isInternetConnectionExists]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
            });
            [USERDEFAULTS removeObjectForKey:@"establishmentString"];
            isdeletecart = YES;
            NSString *urlStr = [NSString stringWithFormat:@"%@deleteCartItems",BASEURL];
            requestDict = @{
                            
                            @"establishment_id":strEid,
                            @"user_id":[Utilities getUserID],
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
    
}


-(void)decreaseLabelCount:(UIButton *)sender
{
    
    if ([Utilities isInternetConnectionExists]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
        });


    strEid = [NSString stringWithFormat:@"%@",[Utilities null_ValidationString:[USERDEFAULTS valueForKey:@"establishmentString"]]];

    boolUpdate = YES;
    isDecreased = NO;
    cartView.hidden = NO;
    
    
    UIButton *btn=(UIButton *)sender;
    NSIndexPath *indexPath;
   
    
    UIButton *senderButton = (UIButton *)sender;
    NSLog(@"current Row=%d",senderButton.tag);
    
    NSLog(@"current Row path =%d",senderButton.tag);
    
    
    
    CGPoint touchPoint = [sender convertPoint:CGPointZero toView:_RestaurantsMenuTableView];
    NSIndexPath *clickedButtonIndexPath = [_RestaurantsMenuTableView indexPathForRowAtPoint:touchPoint];
    
    NSInteger row = clickedButtonIndexPath.row;
    section = clickedButtonIndexPath.section;
    
    NSLog(@"current Row=%d",row);
    
    NSLog(@"current Row path =%d",section);
    
    
    NSMutableArray * sectionCountArray = [[NSMutableArray alloc]init];
    sectionCountArray =   [totalDetailsDict valueForKey:@"categories"];

    
    RestaurantsMenuCell *cell;
    CategoryItemTableViewCell *cell2 ;
        int itemCount = 0;
    NSMutableDictionary  *dict = [[NSMutableDictionary alloc] init];
    NSString  *strPrice;
    
    if (section == 0)
    {
        indexPath = [NSIndexPath indexPathForRow:btn.tag inSection:0];
        cell  = (RestaurantsMenuCell *)[_RestaurantsMenuTableView cellForRowAtIndexPath:indexPath];
        
        itemCount =  [cell.itemCountLabel.text intValue];
        itemCount --;
        dict =[arrMostPopular objectAtIndex:btn.tag];
        strPrice = [NSString stringWithFormat:@"%@",[dict valueForKey:@"price"]];
    }
    else
    {
        for (int i = 0 ; i < sectionCountArray.count+1; i++) {
            if (section == i)
            {
                
            indexPath = [NSIndexPath indexPathForRow:btn.tag inSection:i];
            cell2 = (CategoryItemTableViewCell *)[_RestaurantsMenuTableView cellForRowAtIndexPath:indexPath];
                
            itemCount =  [cell2.itemCountLabel.text intValue];
            itemCount --;
            dict = [categoryArray objectAtIndex:indexPath.section - 1];
            NSArray *array = [dict valueForKey:@"items"];
            dict = [array objectAtIndex:btn.tag];
            strPrice = [NSString stringWithFormat:@"%@",[dict valueForKey:@"price"]];

                break;
            }
        }
    }

    
    
    addDict = dict;
    addprice = strPrice;
    addqty = [NSString stringWithFormat:@"%d",itemCount];
        
        
   
    if ([strEid isEqualToString:@""])
    {
        if (itemCount > 0 || itemCount == 0)
        {
         [self updateInDB:dict itemcount:[NSString stringWithFormat:@"%d",itemCount] variant:strPrice];
        
        
        if (section == 0)
        {
            if([[[arrMostPopular objectAtIndex:btn.tag] valueForKey:@"items_id"] isEqualToString:[NSString stringWithFormat:@"%@",[dict valueForKey:@"items_id"]]])
                
            {
                [dict removeObjectForKey:@"quantity"];
                [dict setValue:[NSString stringWithFormat:@"%d",itemCount] forKey:@"quantity"];
                [arrMostPopular replaceObjectAtIndex:btn.tag withObject:dict];
                
                cell.itemCountLabel.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"quantity"]];
               
                
            }
        }
        else
        {
            
            for (int i = 0 ; i < sectionCountArray.count+1; i++)
            {
                if (section == i)
                {
                    dict = [categoryArray objectAtIndex:indexPath.section - 1];
                    NSArray *array = [dict valueForKey:@"items"];
                    dict = [array objectAtIndex:btn.tag];
                    
                    
                    if([[[array objectAtIndex:btn.tag] valueForKey:@"items_id"] isEqualToString:[NSString stringWithFormat:@"%@",[dict valueForKey:@"items_id"]]])
                        
                    {
                        dict = [categoryArray objectAtIndex:indexPath.section - 1];
                        NSArray *array = [dict valueForKey:@"items"];
                        dict = [array objectAtIndex:btn.tag];
                        
                        [dict removeObjectForKey:@"quantity"];
                        [dict setValue:[NSString stringWithFormat:@"%d",itemCount] forKey:@"quantity"];
                        
                        [[[categoryArray objectAtIndex:indexPath.section - 1] valueForKey:@"items"] replaceObjectAtIndex:btn.tag withObject:dict];
                        cell2.itemCountLabel.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"quantity"]];
                        
                    }

                }
            }
        }
    }
        
}
    
    else if ([self.establishment_idStr isEqualToString:strEid])
    {
        
        
        if (itemCount > 0 || itemCount == 0)
        {

            
            [self updateInDB:dict itemcount:[NSString stringWithFormat:@"%d",itemCount] variant:strPrice];
            
            
            if (section == 0)
            {
                if([[[arrMostPopular objectAtIndex:btn.tag] valueForKey:@"items_id"] isEqualToString:[NSString stringWithFormat:@"%@",[dict valueForKey:@"items_id"]]])
                    
                    
                {
                    [dict removeObjectForKey:@"quantity"];
                    [dict setValue:[NSString stringWithFormat:@"%d",itemCount] forKey:@"quantity"];
                    [arrMostPopular replaceObjectAtIndex:btn.tag withObject:dict];
                    
                    cell.itemCountLabel.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"quantity"]];
                    
                }
            }
            else
            {
                for (int i = 0 ; i < sectionCountArray.count+1; i++)
                    

                {
                    if (section == i)
                    {
                        dict = [categoryArray objectAtIndex:indexPath.section - 1];
                        NSArray *array = [dict valueForKey:@"items"];
                        dict = [array objectAtIndex:btn.tag];
                        
                        
                        if([[[array objectAtIndex:btn.tag] valueForKey:@"items_id"] isEqualToString:[NSString stringWithFormat:@"%@",[dict valueForKey:@"items_id"]]])
                            
                        {
                            dict = [categoryArray objectAtIndex:indexPath.section - 1];
                            NSArray *array = [dict valueForKey:@"items"];
                            dict = [array objectAtIndex:btn.tag];
                            
                            [dict removeObjectForKey:@"quantity"];
                            [dict setValue:[NSString stringWithFormat:@"%d",itemCount] forKey:@"quantity"];
                            
                            [[[categoryArray objectAtIndex:indexPath.section - 1] valueForKey:@"items"] replaceObjectAtIndex:btn.tag withObject:dict];
                            cell2.itemCountLabel.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"quantity"]];
                            
                        }
                    }

                }
            }
        }
       
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_RestaurantsMenuTableView reloadData];
        });
        
        
    }
        

//        else if (itemCount == 0 || itemCount > 0)
//        {
//            itemCount == 0;
//            cell.decrementButton.enabled = NO;
//            
//            
//        }
//        else
//        {
//            itemCount --;
//            cell.decrementButton.enabled = YES;
//        }
//
        
      
}
    else
    {
        [Utilities displayCustemAlertViewWithOutImage:@"Internet connection error" :self.view];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [Utilities removeLoading:self.view];
    });
    

    
}



- (IBAction)addtocartItems:(NSDictionary *)itemdict itemcount:(NSString*)itemQty variant:(NSString*)variantPrice

{
   
        [self.view endEditing:YES];
    
    
        if ([Utilities isInternetConnectionExists]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
            });
            
            
           isfavrite = NO;
          
            
            NSString *urlStr = [NSString stringWithFormat:@"%@addToCart",BASEURL];
            requestDict = @{
                            @"establishment_id":self.establishment_idStr,
                            @"user_id":[Utilities getUserID],
                            @"item_id":[NSString stringWithFormat:@"%@",[itemdict valueForKey:@"items_id"]],
                            @"quantity":itemQty,
                            @"price":[NSString stringWithFormat:@"%@",variantPrice],
                            @"gst":gst_value,
                                //[NSString stringWithFormat:@"%@",[totalDetailsDict valueForKey:@"gst_id"]],
                            @"device_type":@"ios"
                            
                            };
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                ServiceManager *service = [ServiceManager sharedInstance];
                service.delegate = self;
                
               // isdeletecart = NO;
                [service  handleRequestWithDelegates:urlStr info:requestDict];
                // [self uploadImagetoServer:urlStr];
                
            });
            
            
        }
        else
        {
            [Utilities displayCustemAlertViewWithOutImage:@"Internet connection error" :self.view];
        }
    
 
}


- (IBAction)updateInDB:(NSDictionary *)itemdict itemcount:(NSString*)itemQty variant:(NSString*)variantPrice

{
    
    
    [self.view endEditing:YES];
    
    
    if ([Utilities isInternetConnectionExists]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
        });
        
        isdeletecart = NO;
        
        NSString *urlStr = [NSString stringWithFormat:@"%@addToCart",BASEURL];
        requestDict = @{
                        @"establishment_id":self.establishment_idStr,
                        @"user_id":[Utilities getUserID],
                        @"item_id":[NSString stringWithFormat:@"%@",[itemdict valueForKey:@"items_id"]],
                        @"quantity":itemQty,
                        @"price":[NSString stringWithFormat:@"%@",variantPrice],
                        @"gst":gst_value,
                            //[NSString stringWithFormat:@"%@",[itemdict valueForKey:@"items_id"]],
                        @"device_type":@"ios"
                        
                        
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



- (IBAction)Cart_Click:(id)sender
{
   
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ReviewOrderViewController * search = [storyboard instantiateViewControllerWithIdentifier:@"ReviewOrderViewController"];
    [self.navigationController pushViewController:search animated:YES];
    
    
    [USERDEFAULTS setObject:[totalDetailsDict objectForKey:@"establishment_id"] forKey:@"establishment_id"];
    NSLog(@"establishment_id %@",[NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:@"establishment_id"]]);
    
    [USERDEFAULTS setObject:[totalDetailsDict objectForKey:@"latitude"] forKey:@"seltctedRestLat"];
    NSLog(@"seltctedRestLat %@",[NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:@"seltctedRestLat"]]);
    
    [USERDEFAULTS setObject:[totalDetailsDict objectForKey:@"longitude"] forKey:@"seltctedRestLong"];
    NSLog(@"seltctedRestLong %@",[NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:@"seltctedRestLong"]]);
    
    [USERDEFAULTS setObject:[totalDetailsDict objectForKey:@"gst_value"] forKey:@"seltctedRestGST"];
    NSLog(@"seltctedRestGST %@",[NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:@"seltctedRestGST"]]);

    
}
    



-(void)restaurantsMenuService
{
    [self.view endEditing:YES];
    
    if ([Utilities isInternetConnectionExists]) {
        dispatch_async(dispatch_get_main_queue(), ^{
          //  [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
            
            [self.shim1 addGlowEffectWithWidth:80 duration:1.5];
            [self.shim2 addGlowEffectWithWidth:80 duration:1.5];
            [self.shim3 addGlowEffectWithWidth:80 duration:1.5];
            [self.shim4 addGlowEffectWithWidth:80 duration:1.5];


        });
        
        isrestaurantsMenuService = YES;
        
        NSString *urlStr = [NSString stringWithFormat:@"%@restaurantCategoryItems",BASEURL];
        requestDict = @{
                        
                        @"establishment_id":self.establishment_idStr,
                        @"user_id":[Utilities getUserID],
                        @"sort_type":@""
                        
                        };
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            ServiceManager *service = [ServiceManager sharedInstance];
            service.delegate = self;
            
            isdeletecart = NO;
            boolUpdate = NO;
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


-(void)restaurantAvailabilityService
{
    [self.view endEditing:YES];
    
    if ([Utilities isInternetConnectionExists]) {
        dispatch_async(dispatch_get_main_queue(), ^{
                    //  [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
//            [self.mainshimmer1 addGlowEffectWithWidth:80 duration:1.5];
//            [self.mainshimmer2 addGlowEffectWithWidth:80 duration:1.5];
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



- (void)responseDic:(NSDictionary *)info
{
    [self handleResponse:info];
    
    
}
- (void)failResponse:(NSError*)error
{
    ////@"Error");
    dispatch_async(dispatch_get_main_queue(), ^{
        [Utilities removeLoading:self.view];
    });
    
}
-(void)handleResponse :(NSDictionary *)responseInfo
{
    

    
    
    if([[responseInfo valueForKey:@"status"] intValue] == 1)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
           
            
            
            strCartCountDisplay = [NSString stringWithFormat:@"%@",[responseInfo valueForKey:@"cart_count"]];
            

        
            if (boolUpdate == YES )
            {
                dispatch_async(dispatch_get_main_queue(), ^{

                if (isdeletecart == YES)
                {
                   
                    [USERDEFAULTS removeObjectForKey:@"seltctedRestLat"];
                    [USERDEFAULTS removeObjectForKey:@"seltctedRestLong"];
                    [USERDEFAULTS removeObjectForKey:@"seltctedRestGST"];
                    
                    
                    [self addtocartItems:addDict itemcount:addqty variant:addprice];
                    
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                    
//                    [self restaurantsMenuService];
//                    
//                    });

                }
                
                    NSString * cartCountDsply = [Utilities null_ValidationString:strCartCountDisplay];
                    int numb = [cartCountDsply intValue];
                
                if ([strCartCountDisplay isEqualToString:@"0"])
                {
                    cartView.hidden = YES;
                }
                
                else
                {

                        lblcartTotal.text = [NSString stringWithFormat:@"%@",strCartCountDisplay];
                        
                        cartView.hidden = NO;

                   
                }

                NSLog(@"test1");
                    
                });
                boolUpdate = NO;
            }
           
            else if (isAvailability == YES)
            {
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    // do ur background stuff here
                    

                    isAvailability = NO;
                    
                    availabilityStr = [NSString stringWithFormat:@"%@",[responseInfo objectForKey:@"availability"]];
                    terminateStr = [NSString stringWithFormat:@"%@",[responseInfo valueForKey:@"terminate_status"]];
                    
                    adminTerm_status = [NSString stringWithFormat:@"%@",[responseInfo valueForKey:@"admin_terminate_status"]];
                    
                    
                    if ([availabilityStr isEqualToString:@"1"] && [terminateStr isEqualToString:@"1"] && [adminTerm_status isEqualToString:@"0"])
                    {
                        
                        
                        
                    }
                    else
                    {
                        
         
                        dispatch_async(dispatch_get_main_queue(), ^{
                            // Update UI
                            //[self.navigationController popViewControllerAnimated:NO];
                            //[Utilities displayToastWithMessage:@"Restaurant not available"];
                        });
                        
                        
                    }
                    
                    
                });
                
            }
            
            else if (isfavrite == YES)
            {
                 NSLog(@"test2");
                
                 dispatch_async(dispatch_get_main_queue(), ^{

                 });
            }
            else if (isSwitchBtn == YES)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    isSwitchBtn = NO;
                    totalDetailsDict = [responseInfo objectForKey:@"restaurant_categories_items"] ;
                    
                    [_restaurantName adjustsFontSizeToFitWidth];
                    
                    self.restaurantName.text = [NSString stringWithFormat:@"%@",[totalDetailsDict objectForKey:@"name"]];
                    self.restaurantRating.text = [NSString stringWithFormat:@"%@",[Utilities null_ValidationString:[totalDetailsDict objectForKey:@"rating"]]];
                    self.restaurantDeliveryTime.text = [NSString stringWithFormat:@"%@",[totalDetailsDict objectForKey:@"delivery_time"]];
                    
                    strCount = [NSString stringWithFormat:@"%@",[responseInfo objectForKey:@"cart_count"]];
                    
                    
                    if ([strCount isEqualToString:@"0"])
                    {
                        cartView.hidden = YES;
                    }
                    else
                    {
                        lblcartTotal.text = [NSString stringWithFormat:@"%@",strCount];
                        
                        cartView.hidden = NO;
                    }
                    
                    NSLog(@"strCount: %@",strCount);
                    
                    // lblcartTotal.text = [NSString stringWithFormat:@"%@",[totalDetailsDict objectForKey:@"cart_count"]];
                    
                    NSLog(@"responseInfo restaurantCategoryItems:%@",[NSString stringWithFormat:@"%@",[totalDetailsDict objectForKey:@"establishment_id"]]);
                    
                    restarantIdStr = [NSString stringWithFormat:@"%@",[totalDetailsDict objectForKey:@"establishment_id"]];
                    
                    gst_value  = [totalDetailsDict valueForKey:@"gst_value"];
                    
                    NSString *Strfav = [NSString stringWithFormat:@"%@",[totalDetailsDict objectForKey:@"favourite"]];
                    if ([Strfav intValue] == 1)
                    {
                        
                        [favbutton setImage:[UIImage imageNamed:@"wishlistwhite.png"] forState:UIControlStateNormal];
                        
                    }
                    else
                    {
                        [favbutton setImage:[UIImage imageNamed:@"wishlwhite.png"] forState:UIControlStateNormal];
                        
                    }
                    
                    
                    
                    NSString * imageString = [NSString stringWithFormat:@"http://www.mealshack.com/uploads/establishment/%@",[totalDetailsDict objectForKey:@"logo"]] ;
                    
                    imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: imageString]];
                    _restaurantImage.image = [UIImage imageWithData:imageData];
                    
                    ratingString = [totalDetailsDict objectForKey:@"restaurant_value"];
                    
                    
                    int value;
                    
                    value = [ratingString intValue];
                    
                    
                    if ([Utilities null_ValidationString:ratingString])
                    {
                        
                        if ([ratingString isEqualToString:@"1"])
                        {
                            _ruppeeRatingImage.image = [UIImage imageNamed:@"1-white.png"];
                        }
                        else if ([ratingString isEqualToString:@"2"])
                        {
                            _ruppeeRatingImage.image = [UIImage imageNamed:@"2-white.png"];
                        }
                        //minorder > 501 && minorder < 1000
                        else if ([ratingString isEqualToString:@"3"])
                        {
                            _ruppeeRatingImage.image = [UIImage imageNamed:@"3-white.png"];
                        }
                        //minorder > 1000
                        else if ([ratingString isEqualToString:@"4"])
                        {
                            _ruppeeRatingImage.image = [UIImage imageNamed:@"4-white.png"];
                        }
                    }
                    
                    
                    //_CategoryNameLbl =[NSString stringWithFormat:@"%@",[totalDetailsDict objectForKey:@"most_popular"]];
                    
                    if ([totalDetailsDict valueForKey:@"most_popular"])
                    {
                        typeCategory = @"Most Popular";
                    }
                    else if([totalDetailsDict valueForKey:@"categories"])
                    {
                        typeCategory = [[totalDetailsDict valueForKey:@"categories"]objectForKey:@"item_category_name"];
                    }
                    
                    _CategoryNameLbl = typeCategory;
                    
                    
                    
                    // NSDictionary *Response;
                    arrMostPopular = [responseInfo valueForKeyPath:@"restaurant_categories_items.most_popular"];
                    categoryArray=[responseInfo valueForKeyPath:@"restaurant_categories_items.categories"];
                    NSArray *tempItemsArray = [responseInfo valueForKeyPath:@"restaurant_categories_items.most_popular"];
                    
                    [categoryNamesArray addObject:@"Most Popular"];
                    [singleTonInstance.CategorynamesArray addObject:@"Most Popular"];
                    
                    for (int k=0; k<categoryArray.count; k++)
                    {
                        NSDictionary *dict=[categoryArray objectAtIndex:k];
                        [categoryNamesArray addObject:[dict valueForKey:@"item_category_name"]];
                        [singleTonInstance.CategorynamesArray addObject:[dict valueForKey:@"item_category_name"]];
                    }
                    
                    NSLog(@"cat names array %@ \n -- categoryNamesArray : %@",singleTonInstance.CategorynamesArray,categoryNamesArray);
                    
                    
                    for (int k=0; k<arrAllItems.count; k++)
                        
                    {
                        NSDictionary *dict=[arrAllItems objectAtIndex:k];
                        itemNameStr=[NSString stringWithFormat:@"%@",[dict valueForKey:@"item_name"]];
                        itemPriceStr=[NSString stringWithFormat:@"%@",[dict valueForKey:@"price"]];
                        //////
                        itemQuantStr =[NSString stringWithFormat:@"%@",[dict valueForKey:@"quantity"]];
                        itemIdStr = [NSString stringWithFormat:@"%@",[dict valueForKey:@"items_id"]];
                        
                        // strItemName is your Item name
                    }
                    
                    
                    [_RestaurantsMenuTableView reloadData];
                    
                });
                
            }
           else if (isAfterClickCat == YES && isrestaurantsMenuService == YES)
           {
               isAfterClickCat = NO;
               NSLog(@"test3");
               isrestaurantsMenuService = NO;
               dispatch_async(dispatch_get_main_queue(), ^{
                   
                   
                   switchoff.hidden = NO;
                   favbutton.hidden = NO;
                   self.starImage.hidden = NO;
                   self.clockImage.hidden =NO;
                   self.vegetarianLbl.hidden = NO;
                   self.shim3.hidden = YES;
                   self.shim1.hidden = YES;
                   self.shim2.hidden = YES;
                   self.shim4.hidden = YES;
                   _RestaurantsMenuTableView.hidden = NO;
                   _popoverBtn.hidden = NO;
                   
                   totalDetailsDict = [responseInfo objectForKey:@"restaurant_categories_items"] ;
                   
                   //[_restaurantName adjustsFontSizeToFitWidth];
                   _restaurantName.adjustsFontSizeToFitWidth = YES;
                   self.restaurantName.text = [Utilities null_ValidationString:[NSString stringWithFormat:@"%@",[totalDetailsDict objectForKey:@"name"]]];
                   self.restaurantRating.text = [NSString stringWithFormat:@"%@",[Utilities null_ValidationString:[totalDetailsDict objectForKey:@"rating"]]];
                   self.restaurantDeliveryTime.text = [NSString stringWithFormat:@"%@",[totalDetailsDict objectForKey:@"delivery_time"]];
                   
                   strCount = [NSString stringWithFormat:@"%@",[responseInfo objectForKey:@"cart_count"]];
                   
                   
                   if ([strCount isEqualToString:@"0"])
                   {
                       cartView.hidden = YES;
                   }
                   else
                   {
                       lblcartTotal.text = [NSString stringWithFormat:@"%@",strCount];
                       
                       cartView.hidden = NO;
                   }
                   
                   NSLog(@"strCount: %@",strCount);
                   
                   // lblcartTotal.text = [NSString stringWithFormat:@"%@",[totalDetailsDict objectForKey:@"cart_count"]];
                   
                   NSLog(@"responseInfo restaurantCategoryItems:%@",[NSString stringWithFormat:@"%@",[totalDetailsDict objectForKey:@"establishment_id"]]);
                   
                   restarantIdStr = [NSString stringWithFormat:@"%@",[totalDetailsDict objectForKey:@"establishment_id"]];
                   
                   gst_value  = [totalDetailsDict valueForKey:@"gst_value"];
                   
                   NSString *Strfav = [NSString stringWithFormat:@"%@",[totalDetailsDict objectForKey:@"favourite"]];
                   if ([Strfav intValue] == 1)
                   {
                       
                       [favbutton setImage:[UIImage imageNamed:@"wishlistwhite.png"] forState:UIControlStateNormal];
                       
                   }
                   else
                   {
                       [favbutton setImage:[UIImage imageNamed:@"wishlwhite.png"] forState:UIControlStateNormal];
                       
                   }
                   
                   
                   
                   NSString * imageString = [NSString stringWithFormat:@"%@%@",RESTAURENTS_IMAGE_URL,[totalDetailsDict objectForKey:@"logo"]] ;
                   
                   imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: imageString]];
                   _restaurantImage.image = [UIImage imageWithData:imageData];
                   
                   ratingString = [totalDetailsDict objectForKey:@"restaurant_value"];
                   
                   
                   int value;
                   
                   value = [ratingString intValue];
                   
                   
                   if ([Utilities null_ValidationString:ratingString])
                   {
                       
                       if ([ratingString isEqualToString:@"1"])
                       {
                           _ruppeeRatingImage.image = [UIImage imageNamed:@"1-white.png"];
                       }
                       else if ([ratingString isEqualToString:@"2"])
                       {
                           _ruppeeRatingImage.image = [UIImage imageNamed:@"2-white.png"];
                       }
                       //minorder > 501 && minorder < 1000
                       else if ([ratingString isEqualToString:@"3"])
                       {
                           _ruppeeRatingImage.image = [UIImage imageNamed:@"3-white.png"];
                       }
                       //minorder > 1000
                       else if ([ratingString isEqualToString:@"4"])
                       {
                           _ruppeeRatingImage.image = [UIImage imageNamed:@"4-white.png"];
                       }
                   }
                   
                   
                   //_CategoryNameLbl =[NSString stringWithFormat:@"%@",[totalDetailsDict objectForKey:@"most_popular"]];
                   
                   if ([totalDetailsDict valueForKey:@"most_popular"])
                   {
                       typeCategory = @"Most Popular";
                   }
                   else if([totalDetailsDict valueForKey:@"categories"])
                   {
                       typeCategory = [[totalDetailsDict valueForKey:@"categories"]objectForKey:@"item_category_name"];
                   }
                   
                   _CategoryNameLbl.text = typeCategory;
                   
                   
                   
                   // NSDictionary *Response;
                   arrMostPopular = [responseInfo valueForKeyPath:@"restaurant_categories_items.most_popular"];
                   
                   if([categoryArray count])
                      [categoryArray removeAllObjects];
                   
                   for (NSDictionary * tempDic in [responseInfo valueForKeyPath:@"restaurant_categories_items.categories"]){
                       
                       [categoryArray addObject:tempDic];
                   }
                   
                   
                   
                   
                   if (singleTonInstance.CategorynamesArray.count) {
                       [singleTonInstance.CategorynamesArray removeAllObjects];
                   }
                   
                   
                   
                   
                   [categoryNamesArray addObject:@"Most Popular"];
                   [singleTonInstance.CategorynamesArray addObject:@"Most Popular"];
                   
                   for (int k=0; k<categoryArray.count; k++)
                   {
                       NSDictionary *dict=[categoryArray objectAtIndex:k];
                       [categoryNamesArray addObject:[dict valueForKey:@"item_category_name"]];
                       [singleTonInstance.CategorynamesArray addObject:[dict valueForKey:@"item_category_name"]];
                   }
                   
                   NSLog(@"cat names array %@ \n -- categoryNamesArray : %@",singleTonInstance.CategorynamesArray,categoryNamesArray);
                   
                   
                   for (int k=0; k<arrAllItems.count; k++)
                       
                   {
                       NSDictionary *dict=[arrAllItems objectAtIndex:k];
                       itemNameStr=[NSString stringWithFormat:@"%@",[dict valueForKey:@"item_name"]];
                       itemPriceStr=[NSString stringWithFormat:@"%@",[dict valueForKey:@"price"]];
                       //////
                       itemQuantStr =[NSString stringWithFormat:@"%@",[dict valueForKey:@"quantity"]];
                       itemIdStr = [NSString stringWithFormat:@"%@",[dict valueForKey:@"items_id"]];
                       
                       // strItemName is your Item name
                   }
                   //                    if (cellCountNumCheck > 0) {
                   //                        [_RestaurantsMenuTableView
                   //                         scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:cellCountNumCheck-1
                   //                                                                   inSection:0]
                   //                         atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                   //
                   //                        [_RestaurantsMenuTableView
                   //                         scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:cellCountNumCheck-1
                   //                                                                   inSection:0]
                   //                         atScrollPosition:UITableViewScrollPositionTop animated:YES];
                   //                    }
                   
                  
                   
                   [_RestaurantsMenuTableView reloadData];
                   
                           NSDictionary *dict = [categoryArray objectAtIndex:indexNumFromClick - 1];
                           NSArray *array = [dict valueForKey:@"items"];
                           if (array.count != 0)
                           {
                   
                               NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:indexNumFromClick];
                               [_RestaurantsMenuTableView scrollToRowAtIndexPath:indexPath
                                                                atScrollPosition:UITableViewScrollPositionTop
                                                                        animated:YES];
                   
                           }
                   
                   
               });
               
               
           }
           else if (isrestaurantsMenuService == YES)
            {
                 NSLog(@"test3");
                isrestaurantsMenuService = NO;
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                    switchoff.hidden = NO;
                    favbutton.hidden = NO;
                    self.starImage.hidden = NO;
                    self.clockImage.hidden =NO;
                    self.vegetarianLbl.hidden = NO;
                    self.shim3.hidden = YES;
                    self.shim1.hidden = YES;
                    self.shim2.hidden = YES;
                    self.shim4.hidden = YES;
                    _RestaurantsMenuTableView.hidden = NO;
                    _popoverBtn.hidden = NO;
                
             totalDetailsDict = [responseInfo objectForKey:@"restaurant_categories_items"] ;

                    //[_restaurantName adjustsFontSizeToFitWidth];
                    _restaurantName.adjustsFontSizeToFitWidth = YES;
            self.restaurantName.text = [Utilities null_ValidationString:[NSString stringWithFormat:@"%@",[totalDetailsDict objectForKey:@"name"]]];
            self.restaurantRating.text = [NSString stringWithFormat:@"%@",[Utilities null_ValidationString:[totalDetailsDict objectForKey:@"rating"]]];
            self.restaurantDeliveryTime.text = [NSString stringWithFormat:@"%@",[totalDetailsDict objectForKey:@"delivery_time"]];
            
             strCount = [NSString stringWithFormat:@"%@",[responseInfo objectForKey:@"cart_count"]];
                
                
                if ([strCount isEqualToString:@"0"])
                {
                    cartView.hidden = YES;
                }
                else
                {
                    lblcartTotal.text = [NSString stringWithFormat:@"%@",strCount];
                    
                    cartView.hidden = NO;
                }
                
                NSLog(@"strCount: %@",strCount);
           
    
            NSLog(@"responseInfo restaurantCategoryItems:%@",[NSString stringWithFormat:@"%@",[totalDetailsDict objectForKey:@"establishment_id"]]);

            restarantIdStr = [NSString stringWithFormat:@"%@",[totalDetailsDict objectForKey:@"establishment_id"]];
                
                gst_value  = [totalDetailsDict valueForKey:@"gst_value"];
                
               NSString *Strfav = [NSString stringWithFormat:@"%@",[totalDetailsDict objectForKey:@"favourite"]];
                if ([Strfav intValue] == 1)
                {
                    
                    [favbutton setImage:[UIImage imageNamed:@"wishlistwhite.png"] forState:UIControlStateNormal];
                   
                }
                else
                {
                    [favbutton setImage:[UIImage imageNamed:@"wishlwhite.png"] forState:UIControlStateNormal];
                   
                }
                
            
                    NSString * imageString = [NSString stringWithFormat:@"%@%@",RESTAURENTS_IMAGE_URL,[totalDetailsDict objectForKey:@"logo"]] ;
            
            imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: imageString]];
            _restaurantImage.image = [UIImage imageWithData:imageData];
            
            ratingString = [totalDetailsDict objectForKey:@"restaurant_value"];
            
            
            int value;
            
            value = [ratingString intValue];
                
                
                if ([Utilities null_ValidationString:ratingString])
                {
          
            if ([ratingString isEqualToString:@"1"])
            {
                _ruppeeRatingImage.image = [UIImage imageNamed:@"1-white.png"];
            }
            else if ([ratingString isEqualToString:@"2"])
            {
                _ruppeeRatingImage.image = [UIImage imageNamed:@"2-white.png"];
            }
            //minorder > 501 && minorder < 1000
            else if ([ratingString isEqualToString:@"3"])
            {
                _ruppeeRatingImage.image = [UIImage imageNamed:@"3-white.png"];
            }
            //minorder > 1000
            else if ([ratingString isEqualToString:@"4"])
            {
                _ruppeeRatingImage.image = [UIImage imageNamed:@"4-white.png"];
            }
                }

            
            //_CategoryNameLbl =[NSString stringWithFormat:@"%@",[totalDetailsDict objectForKey:@"most_popular"]];
           
            if ([totalDetailsDict valueForKey:@"most_popular"])
            {
                typeCategory = @"Most Popular";
            }
            else if([totalDetailsDict valueForKey:@"categories"])
            {
                typeCategory = [[totalDetailsDict valueForKey:@"categories"]objectForKey:@"item_category_name"];
            }

            _CategoryNameLbl.text = typeCategory;
            
            
            
           // NSDictionary *Response;
            arrMostPopular = [responseInfo valueForKeyPath:@"restaurant_categories_items.most_popular"];

                    if([categoryArray count])
                        [categoryArray removeAllObjects];
                    
                    for (NSDictionary * tempDic in [responseInfo valueForKeyPath:@"restaurant_categories_items.categories"]){
                        
                        [categoryArray addObject:tempDic];
                    }
            
                    if (singleTonInstance.CategorynamesArray.count) {
                        [singleTonInstance.CategorynamesArray removeAllObjects];
                    }
                    
                [categoryNamesArray addObject:@"Most Popular"];
                [singleTonInstance.CategorynamesArray addObject:@"Most Popular"];
            
            for (int k=0; k<categoryArray.count; k++)
            {
                NSDictionary *dict=[categoryArray objectAtIndex:k];
                [categoryNamesArray addObject:[dict valueForKey:@"item_category_name"]];
                [singleTonInstance.CategorynamesArray addObject:[dict valueForKey:@"item_category_name"]];
            }
            
                NSLog(@"cat names array %@ \n -- categoryNamesArray : %@",singleTonInstance.CategorynamesArray,categoryNamesArray);
                

            for (int k=0; k<arrAllItems.count; k++)
                
            {
                NSDictionary *dict=[arrAllItems objectAtIndex:k];
                itemNameStr=[NSString stringWithFormat:@"%@",[dict valueForKey:@"item_name"]];
                itemPriceStr=[NSString stringWithFormat:@"%@",[dict valueForKey:@"price"]];
                //////
                itemQuantStr =[NSString stringWithFormat:@"%@",[dict valueForKey:@"quantity"]];
                itemIdStr = [NSString stringWithFormat:@"%@",[dict valueForKey:@"items_id"]];
                
                // strItemName is your Item name
            }
//                    if (cellCountNumCheck > 0) {
//                        [_RestaurantsMenuTableView
//                         scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:cellCountNumCheck-1
//                                                                   inSection:0]
//                         atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//
//                        [_RestaurantsMenuTableView
//                         scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:cellCountNumCheck-1
//                                                                   inSection:0]
//                         atScrollPosition:UITableViewScrollPositionTop animated:YES];
//                    }
                    
                    
                [_RestaurantsMenuTableView reloadData];
                    
                    
                    
            });
                                   
           
        }
            
            
        });
        
    }
    
 
    else if([[responseInfo valueForKey:@"status"] intValue] == 2)
    {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSString *str = [NSString stringWithFormat:@"%@",[responseInfo valueForKey:@"response"]];
//            [Utilities displayCustemAlertViewWithOutImage:str :self.view];
//        });

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            if (isAvailability == YES) {
                [self restaurantAvailabilityService];
                
            }
            else if(isrestaurantsMenuService == YES)
            {
                [self restaurantsMenuService];
            }
            
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

- (IBAction)BackClick:(id)sender
{
    
     [self.navigationController popViewControllerAnimated:YES];
    
    
}




- (IBAction)SwitchoffButton_Clicked:(id)sender
{
    
    isSwitchBtn = YES;
    NSLog(@"Tapped");
    NSString *sort_TypeString;

    if (clicked==NO)
    {
        [switchoff setImage:[UIImage imageNamed:@"switchon.png"] forState:UIControlStateNormal];
         sort_TypeString=@"1";
        clicked = YES;
    }
    else
    {
        [switchoff setImage:[UIImage imageNamed:@"switchofff.png"] forState:UIControlStateNormal];
        sort_TypeString=@"";
        clicked= NO;
    }
    
    
     [singleTonInstance.CategorynamesArray removeAllObjects];
    
    
    
    if ([Utilities isInternetConnectionExists]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
        });
        
        
        NSString *urlStr = [NSString stringWithFormat:@"%@restaurantCategoryItems",BASEURL];
        requestDict = @{
                        @"establishment_id":self.establishment_idStr,
                        @"user_id":[Utilities getUserID],
                        @"sort_type":sort_TypeString
                        
                        };
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            ServiceManager *service = [ServiceManager sharedInstance];
            service.delegate = self;
            
            isfavrite = NO;
            boolUpdate = NO;
           
            [service  handleRequestWithDelegates:urlStr info:requestDict];
            
        });
        
        
    }
    else
    {
        [Utilities displayCustemAlertViewWithOutImage:@"Internet connection error" :self.view];
    }


}


- (IBAction)FavButton_Clicked:(id)sender
{
    
    NSString *TypeString;
    
    if (isClicked==NO)
    {
        [favbutton setImage:[UIImage imageNamed:@"wishlistwhite.png"] forState:UIControlStateNormal];
        TypeString = @"1";
        isClicked = YES;
    }
    else
    {
        [favbutton setImage:[UIImage imageNamed:@"wishlwhite.png"] forState:UIControlStateNormal];
         TypeString = @"2";
        isClicked= NO;
    }
    
    if ([Utilities isInternetConnectionExists]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
        });
        
        
        NSString *urlStr = [NSString stringWithFormat:@"%@addfavourates",BASEURL];
        requestDict = @{
                        @"user_id":[Utilities getUserID],
                        @"restaurant_id":restarantIdStr,
                        @"type":TypeString
                        };
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            ServiceManager *service = [ServiceManager sharedInstance];
            service.delegate = self;
            isfavrite = YES;
            
            [service  handleRequestWithDelegates:urlStr info:requestDict];
            // [self uploadImagetoServer:urlStr];
            
        });
        
        
    }
    else
    {
        [Utilities displayCustemAlertViewWithOutImage:@"Internet connection error" :self.view];
    }
    


}
- (IBAction)Categories_Clicked:(id)sender
{
    // grab the view controller we want to show
    
    if (arrMostPopular == (id)[NSNull null] || [arrMostPopular count] == 0) {
        [Utilities displayToastWithMessage:@"NO data"];
    }
    else
    {
        
        
        UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"Pop"];
        
        // configure the Popover presentation controller
        UIPopoverPresentationController *popController = [controller popoverPresentationController];
        popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
        
        UINavigationController *destNav = [[UINavigationController alloc] initWithRootViewController:controller];/*Here popController is controller you want to show in popover*/
        
        controller.preferredContentSize = CGSizeMake(200,200);
        destNav.modalPresentationStyle = UIModalPresentationPopover;
        popController = destNav.popoverPresentationController;
        popController.delegate = self;
        popController.sourceView = self.popview;
        popController.sourceRect = self.popoverBtn.frame;
        destNav.navigationBarHidden = YES;
        
        [self presentViewController:destNav animated:YES completion:nil];
    }
    
}

- (UIModalPresentationStyle) adaptivePresentationStyleForPresentationController: (UIPresentationController *) controller {
    return UIModalPresentationNone;
}

- (void)dismissMe
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


# pragma mark - Popover Presentation Controller Delegate

- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    
    
    
    
    
    // called when a Popover is dismissed

}

- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    
    // return YES if the Popover should be dismissed
    // return NO if the Popover should not be dismissed
    return YES;
}

- (void)popoverPresentationController:(UIPopoverPresentationController *)popoverPresentationController willRepositionPopoverToRect:(inout CGRect *)rect inView:(inout UIView *__autoreleasing  _Nonnull *)view {
    
    // called when the Popover changes position
}

@end
