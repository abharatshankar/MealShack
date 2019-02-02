//
//  FiltersViewController.m
//  MealShack
//
//  Created by Prasad on 31/07/17.
//  Copyright © 2017 Possibillion. All rights reserved.
//

#import "FiltersViewController.h"
#import "Utilities.h"
#import "Constants.h"
#import "ServiceManager.h"
#import "FiltersCell.h"
#import "LcnManager.h"
#import "SingleTon.h"
#import "RestaurantsViewController.h"
#import "ISMessages.h"

@interface FiltersViewController ()<ServiceHandlerDelegate>
{
    NSMutableArray * totalfiltersArray;
    NSMutableArray * NSSortDescriptor;
    BOOL * isClicked,*isRatingBool,*isDeliveryBool, isResetOptions;
    NSDictionary *requestDict;
    BOOL * rupe1;
    BOOL * rupe2;
    BOOL * rupe3;
    BOOL * rupe4;
    BOOL * isRatings;
    BOOL * isDeliverytime;
    BOOL isBack;
    SingleTon * singleToninstance;
    NSMutableArray *arrfoodTypeList;
    NSString * ratingStringParam,*deliveryStrParam,*priceParam, *cuisinesStrParam;
    NSString *strminvalue,*strmaxvalue, * strValue;
    NSString *strRating,*strdeliveryTime;
    NSMutableArray *cousineArray;
    NSString *strCusines;

}

@end

@implementation FiltersViewController
@synthesize ratings,deliverytime,rup1,rup2,rup3,rup4;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    singleToninstance =   [SingleTon singleTonMethod];
    
    singleToninstance.filteredDict = [[NSMutableDictionary alloc]init];
    totalfiltersArray =[[NSMutableArray alloc]init];
    arrfoodTypeList = [[NSMutableArray alloc] init];
    cousineArray = [[NSMutableArray alloc] init];
    
    _filtersTableView.delegate =self;
    _filtersTableView.dataSource = self;
    
    
    
   
    
    NSString * checkVal = [USERDEFAULTS valueForKey:@"strValue"];
    NSString * checkVal2 = [USERDEFAULTS valueForKey:@"strRating"];
    NSString * checkVal3 = [USERDEFAULTS valueForKey:@"strCusines"];
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"strCusinesArray"]];

    
    if (checkVal.length>0) {
        NSLog(@"star value is there");
        if ([checkVal isEqualToString:@"1"]) {
            
                strValue = @"1";
                [rup1 setImage:[UIImage imageNamed:@"rupeered1.png"] forState:UIControlStateNormal];
                [rup2 setImage:[UIImage imageNamed:@"rtwogreyy.png"] forState:UIControlStateNormal];
                [rup3 setImage:[UIImage imageNamed:@"rthreegry.png"] forState:UIControlStateNormal];
                [rup4 setImage:[UIImage imageNamed:@"rfourgry.png"] forState:UIControlStateNormal];
        }
        else if ([checkVal isEqualToString:@"2"])
        {
            strValue = @"2";
            [rup2 setImage:[UIImage imageNamed:@"rtwo2.png"] forState:UIControlStateNormal];
            [rup1 setImage:[UIImage imageNamed:@"rupgrey.png"] forState:UIControlStateNormal];
            [rup3 setImage:[UIImage imageNamed:@"rthreegry.png"] forState:UIControlStateNormal];
            [rup4 setImage:[UIImage imageNamed:@"rfourgry.png"] forState:UIControlStateNormal];
        }
        else if ([checkVal isEqualToString:@"3"])
        {
            strValue = @"3";
            [rup3 setImage:[UIImage imageNamed:@"rthreee.png"] forState:UIControlStateNormal];
            [rup1 setImage:[UIImage imageNamed:@"rupgrey.png"] forState:UIControlStateNormal];
            [rup2 setImage:[UIImage imageNamed:@"rtwogreyy.png"] forState:UIControlStateNormal];
            [rup4 setImage:[UIImage imageNamed:@"rfourgry.png"] forState:UIControlStateNormal];
        }
        else if ([checkVal isEqualToString:@"4"])
        {
            strValue = @"4";
            [rup4 setImage:[UIImage imageNamed:@"rfourra.png"] forState:UIControlStateNormal];
            [rup1 setImage:[UIImage imageNamed:@"rupgrey.png"] forState:UIControlStateNormal];
            [rup2 setImage:[UIImage imageNamed:@"rtwogreyy.png"] forState:UIControlStateNormal];
            [rup3 setImage:[UIImage imageNamed:@"rthreegry.png"] forState:UIControlStateNormal];
        }
        
    }
    
    if (checkVal2.length>0) {
        NSLog(@"star rating is there");
        
        if ([checkVal2 isEqualToString:@"1"]) {
            
            strRating = @"1";
            strdeliveryTime = @"0";
            
            [ratings setImage:[UIImage imageNamed:@"rating-start-red.png"] forState:UIControlStateNormal];
            [deliverytime setImage:[UIImage imageNamed:@"delivery-gray1.png"] forState:UIControlStateNormal];
        }
        else
        {
            
            strRating = @"0";
            strdeliveryTime = @"1";
            
            [ratings setImage:[UIImage imageNamed:@"rating-start-gray1.png"] forState:UIControlStateNormal];
            [deliverytime setImage:[UIImage imageNamed:@"delivery-red.png"] forState:UIControlStateNormal];
        }
        
    }
    
    if (array.count>0) {
        NSLog(@"star cusines is there");
        for (int i=0; i<array.count; i++) {
            [arrfoodTypeList addObject:[array objectAtIndex:i]];
        }
        
    }
    
    
    
    //////////////////
    NSMutableArray *arrLeftBarItems = [[NSMutableArray alloc] init];
    UIButton *btnLib1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnLib1 setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    btnLib1.frame = CGRectMake(0, 0, 22, 22);
    btnLib1.showsTouchWhenHighlighted=YES;
    UIBarButtonItem *barButtonItem2 = [[UIBarButtonItem alloc] initWithCustomView:btnLib1];
    [arrLeftBarItems addObject:barButtonItem2];
    [btnLib1 addTarget:self action:@selector(Back_Click:) forControlEvents:UIControlEventTouchUpInside];
    
    NSLayoutConstraint * widthConstraint = [btnLib1.widthAnchor constraintEqualToConstant:30];
    NSLayoutConstraint * HeightConstraint =[btnLib1.heightAnchor constraintEqualToConstant:30];
    [widthConstraint setActive:YES];
    [HeightConstraint setActive:YES];
    
    
    UIButton *btnreload = [[UIButton alloc]initWithFrame:CGRectMake(116, 22, 23, 23)];
    [btnreload setImage:[UIImage imageNamed:@"reeload.png"] forState:UIControlStateNormal ];
    UIBarButtonItem * itemreload = [[UIBarButtonItem alloc] initWithCustomView:btnreload];
    [btnreload addTarget:self action:@selector(reloadMethodClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray *arrBtns = [[NSArray alloc]initWithObjects:itemreload, nil];
    self.navigationItem.rightBarButtonItems = arrBtns;
    

    NSLayoutConstraint * widthConstraint5 = [btnreload.widthAnchor constraintEqualToConstant:22];
    NSLayoutConstraint * HeightConstraint5 =[btnreload.heightAnchor constraintEqualToConstant:22];
    
    [widthConstraint5 setActive:YES];
    [HeightConstraint5 setActive:YES];
    
    
    UIButton *btntitle = [UIButton buttonWithType:UIButtonTypeCustom];
    [btntitle setTitle:@"Filters" forState:UIControlStateNormal];
    btntitle.titleLabel.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:18];
    btntitle.frame = CGRectMake(0, 0, 250, 22);
    btntitle.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btntitle setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    btntitle.showsTouchWhenHighlighted=YES;
    UIBarButtonItem *barButtonItem3 = [[UIBarButtonItem alloc] initWithCustomView:btntitle];
    [arrLeftBarItems addObject:barButtonItem3];
    btntitle.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.leftBarButtonItems = arrLeftBarItems;

    
    [self filtersServicecall];
}

-(void)Back_Click:(id)sender
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@""message:@"Are you sure you want to leave this page?"preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* noButton = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault
                               
                                                     handler:^(UIAlertAction * action){
                                                     }];
    
    
    UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Yes"style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                
        {
//             if (strValue.length>0 || strRating.length>0 || strCusines.length>0 || isRatingBool == YES) {
//             [self.navigationController popViewControllerAnimated:YES];
//             }
//            else
//            {
//
//                [self ApplyButton_Clicked:self];
//            }
            
            [USERDEFAULTS removeObjectForKey:@"strValue"];
            [USERDEFAULTS removeObjectForKey:@"strRating"];
            [USERDEFAULTS removeObjectForKey:@"strCusines"];
            [USERDEFAULTS removeObjectForKey:@"strCusinesArray"];
            
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"TestNotification"
             object:self];
            singleToninstance.isNotFilterApplies = YES;
            //[self.navigationController popViewControllerAnimated:YES];
        }];
    
                                
                    [alertController addAction:noButton];
                    [alertController addAction:yesButton];
                                    
                  [self presentViewController:alertController animated:YES completion:nil];
                                    


}

- (void)reloadMethodClicked:(id)sender
{
    
   isResetOptions = YES;
    [arrfoodTypeList removeAllObjects];
    [deliverytime setImage:[UIImage imageNamed:@"delivery-gray1.png"] forState:UIControlStateNormal];
    [ratings setImage:[UIImage imageNamed:@"rating-start-gray1.png"] forState:UIControlStateNormal];
    [rup1 setImage:[UIImage imageNamed:@"rupgrey.png"] forState:UIControlStateNormal];
    [rup2 setImage:[UIImage imageNamed:@"rtwogreyy.png"] forState:UIControlStateNormal];
    [rup3 setImage:[UIImage imageNamed:@"rthreegry.png"] forState:UIControlStateNormal];
    [rup4 setImage:[UIImage imageNamed:@"rfourgry.png"] forState:UIControlStateNormal];
    [_filtersTableView reloadData];
    
    
    strValue = @"";
    strRating = @"";
    strCusines = @"";
    isRatingBool = NO;
    
    [USERDEFAULTS removeObjectForKey:@"strValue"];
    [USERDEFAULTS removeObjectForKey:@"strRating"];
    [USERDEFAULTS removeObjectForKey:@"strCusines"];
    [USERDEFAULTS removeObjectForKey:@"strCusinesArray"];
    
   // [[NSNotificationCenter defaultCenter]
   //  postNotificationName:@"TestNotification"
   //  object:self];
    singleToninstance.isNotFilterApplies = YES;
    //[self.navigationController popViewControllerAnimated:YES];
    
    //[self ApplyButton_Clicked:self];
   
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)filtersServicecall
{
   
    NSString *StrUrl = [NSString stringWithFormat:@"%@filters",BASEURL];
    
    NSLog(@"StrUrl:%@",StrUrl);
    
    // NSMutableURLRequest *request =[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:str_country]];
    NSMutableURLRequest*request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:StrUrl] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    
   StrUrl = nil;
    NSData *returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil ];
    request=nil;
    NSString *returnString = [[NSString alloc]initWithData:returnData encoding:NSUTF8StringEncoding];
    
    NSLog(@"returnString:%@",returnString);
    if (returnString==nil || returnString==NULL || [returnString isEqualToString:@""] || [returnString isEqual:nil]) {
        NSLog(@"Network Not Reachable");
    }
    else{
        returnString=nil;
       
        NSError *jsonError;
       
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:returnData
                                                             options:kNilOptions
                                                               error:&jsonError];
        NSLog(@"Dict value:%@",dict);
        
        if (dict==nil||dict==NULL)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"No Response From Server" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
          
        }
        
        
        else {
           // NSDictionary *create_result_dict;
            NSString *statuscode;
            NSString *message;
            
            statuscode = [dict objectForKey:@"status"];
            message = [dict objectForKey:@"result"];
            NSLog(@"info:%@",[dict objectForKey:@"categories"]);
            int status = [statuscode intValue];
            if (status==1){
                
               totalfiltersArray = [dict objectForKey:@"categories"];
                
            }
            else if (status==2&&([message isEqualToString:@"Email and Password Authentication Error."]||[message isEqualToString:@"This customer email already exists"])){
               
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }
    }

}

////Table view method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return totalfiltersArray.count;
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell...
   
    static NSString *CellIdentifier = @"FiltersCell";
    
    FiltersCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[FiltersCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    NSLog(@"cellForRowAtIndexPath");
    if (arrfoodTypeList.count > 0) {

        if([arrfoodTypeList containsObject:[[totalfiltersArray objectAtIndex:indexPath.row] valueForKey:@"category_id"]] )
        {
        
            cell.checkMarkImageView.image = [UIImage imageNamed:@"check-active.png"];
        }
        else
        {
            cell.checkMarkImageView.image = [UIImage imageNamed:@"check-normal.png"];
        }
 
    }
    else
    {
        cell.checkMarkImageView.image = [UIImage imageNamed:@"check-normal.png"];
    }
   
    cell.filterCuisinesLbl.text = [[totalfiltersArray objectAtIndex:indexPath.row]objectForKey:@"category_name"];
    

    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    strCusines = [[totalfiltersArray objectAtIndex:indexPath.row] valueForKey:@"category_id"];
    
    [USERDEFAULTS setObject:strCusines forKey:@"strCusines"];
   
        if([arrfoodTypeList containsObject:[[totalfiltersArray objectAtIndex:indexPath.row] valueForKey:@"category_id"]])
        {
            [arrfoodTypeList removeObject:[[totalfiltersArray objectAtIndex:indexPath.row] valueForKey:@"category_id"]];
            strCusines = nil;
        }
        else
        {
            [arrfoodTypeList addObject:[[totalfiltersArray objectAtIndex:indexPath.row] valueForKey:@"category_id"]];
        }
    
    [[NSUserDefaults standardUserDefaults] setObject:arrfoodTypeList forKey:@"strCusinesArray"];

    
    [_filtersTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    isResetOptions = NO;
    
    
}
-(BOOL)isItemExistsInScrollView:(NSDictionary *)object
{
    BOOL isFound = NO;
    for (NSDictionary *dict in totalfiltersArray) {
        if ([[dict objectForKey:@"category_id"] isEqualToString:[object objectForKey:@"category_id"]]) {
            isFound = YES;
            break;
        }
    }
    return isFound;
}

- (IBAction)RatingsButton_Clicked:(id)sender
{
    
    [singleToninstance.ratingSarray sortUsingComparator:^NSComparisonResult(NSString *str1, NSString *str2) {
        return [str1 compare:str2 options:(NSNumericSearch)];
    }];
    
    isResetOptions = NO;
    isRatingBool =YES;
    isDeliveryBool =NO;
    if (isRatingBool == YES)
    {
        strRating = @"1";
        strdeliveryTime = @"0";

        [USERDEFAULTS setObject:strRating forKey:@"strRating"];
        
        [ratings setImage:[UIImage imageNamed:@"rating-start-red.png"] forState:UIControlStateNormal];
        [deliverytime setImage:[UIImage imageNamed:@"delivery-gray1.png"] forState:UIControlStateNormal];
    }
    

}

- (IBAction)DeliverytimeButton_Clicked:(id)sender
{
    
    isResetOptions = NO;
    isRatingBool =NO;
    isDeliveryBool =YES;
    
    
    [singleToninstance.deliveryTimeArray sortUsingComparator:^NSComparisonResult(NSString *str1, NSString *str2) {
        return [str1 compare:str2 options:(NSNumericSearch)];
        
         

    }];

    
    if (isDeliveryBool == YES)
    {
        strRating = @"0";
        strdeliveryTime = @"1";
        [USERDEFAULTS setObject:strRating forKey:@"strRating"];
        [ratings setImage:[UIImage imageNamed:@"rating-start-gray1.png"] forState:UIControlStateNormal];
        [deliverytime setImage:[UIImage imageNamed:@"delivery-red.png"] forState:UIControlStateNormal];
        
    }
    

}

- (IBAction)rup1Button_Clicked:(id)sender
{
    rupe1 = YES;
    isResetOptions = NO;
   
   
    if (rupe1==YES)
    {
        [rup1 setImage:[UIImage imageNamed:@"rupeered1.png"] forState:UIControlStateNormal];
        [rup2 setImage:[UIImage imageNamed:@"rtwogreyy.png"] forState:UIControlStateNormal];
        [rup3 setImage:[UIImage imageNamed:@"rthreegry.png"] forState:UIControlStateNormal];
        [rup4 setImage:[UIImage imageNamed:@"rfourgry.png"] forState:UIControlStateNormal];
        isClicked = NO;
        
        strValue = @"1";
        
        [USERDEFAULTS setObject:strValue forKey:@"strValue"];
        
        rupe2 = NO;
        rupe3 = NO;
        rupe4 = NO;
    }

    
    
    

    
}

- (IBAction)rup2Button_Clicked:(id)sender
{
    
    rupe2 = YES;
    isResetOptions = NO;
    
    if (rupe2==YES)
    {
        [rup2 setImage:[UIImage imageNamed:@"rtwo2.png"] forState:UIControlStateNormal];
        [rup1 setImage:[UIImage imageNamed:@"rupgrey.png"] forState:UIControlStateNormal];
        [rup3 setImage:[UIImage imageNamed:@"rthreegry.png"] forState:UIControlStateNormal];
        [rup4 setImage:[UIImage imageNamed:@"rfourgry.png"] forState:UIControlStateNormal];
        isClicked = NO;
        
        strValue = @"2";
[USERDEFAULTS setObject:strValue forKey:@"strValue"];
        rupe1 = NO;
        rupe3 = NO;
        rupe4 = NO;
    }

}

- (IBAction)rup3Button_Clicked:(id)sender
{
    
    
    rupe3 = YES;
    isResetOptions = NO;
    if (rupe3==YES)
    {
        [rup3 setImage:[UIImage imageNamed:@"rthreee.png"] forState:UIControlStateNormal];
        [rup1 setImage:[UIImage imageNamed:@"rupgrey.png"] forState:UIControlStateNormal];
        [rup2 setImage:[UIImage imageNamed:@"rtwogreyy.png"] forState:UIControlStateNormal];
        [rup4 setImage:[UIImage imageNamed:@"rfourgry.png"] forState:UIControlStateNormal];
        isClicked = NO;

        //        strmaxvalue = @"501";
//        strmaxvalue = @"1000";
        
        strValue = @"3";
        [USERDEFAULTS setObject:strValue forKey:@"strValue"];
        rupe1 = NO;
        rupe2 = NO;
        rupe4 = NO;
    }


}

- (IBAction)rup4Button_Clicked:(id)sender
{
    rupe4 = YES;
    isResetOptions = NO;
    if (rupe4==YES)
    {
        [rup4 setImage:[UIImage imageNamed:@"rfourra.png"] forState:UIControlStateNormal];
        [rup1 setImage:[UIImage imageNamed:@"rupgrey.png"] forState:UIControlStateNormal];
        [rup2 setImage:[UIImage imageNamed:@"rtwogreyy.png"] forState:UIControlStateNormal];
        [rup3 setImage:[UIImage imageNamed:@"rthreegry.png"] forState:UIControlStateNormal];
        isClicked = NO;
        
        
        strValue = @"4";

        [USERDEFAULTS setObject:strValue forKey:@"strValue"];
        rupe1 = NO;
        rupe2 = NO;
        rupe3 = NO;
    }


}


- (IBAction)ApplyButton_Clicked:(id)sender
{
    [self.view endEditing:YES];
       
    
    if (isResetOptions == YES) {
        
        [USERDEFAULTS removeObjectForKey:@"strValue"];
        [USERDEFAULTS removeObjectForKey:@"strRating"];
        [USERDEFAULTS removeObjectForKey:@"strCusines"];
        [USERDEFAULTS removeObjectForKey:@"strCusinesArray"];
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"TestNotification"
         object:self];
        singleToninstance.isNotFilterApplies = YES;
    }
    else
    {
        
        [singleToninstance.ratingArray sortUsingComparator:^NSComparisonResult(NSString *str1, NSString *str2) {
            return [str1 compare:str2 options:(NSNumericSearch)];
        }];
        
        
        
        if ((isBack == YES)||(strValue.length>0 || strRating.length>0 || strCusines.length>0 || isRatingBool == NO)) {
            
            if ([Utilities isInternetConnectionExists]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
                });
                
                NSString* strLatitude = [NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:@"selectedlat"]];
                NSString* strLongitude = [NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:@"selectedlong"]];
                if (![[Utilities null_ValidationString:strLatitude] isEqualToString:@""])
                {
                    strLatitude = [NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:@"selectedlat"]];
                    strLongitude = [NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:@"selectedlong"]];
                    
                    
                }
                else
                {
                    
                    strLatitude = [NSString stringWithFormat:@"%f",[[LcnManager sharedManager]locationManager].location.coordinate.latitude];
                    strLongitude = [NSString stringWithFormat:@"%f", [[LcnManager sharedManager]locationManager].location.coordinate.longitude];
                    
                }
                
                
                NSString *urlStr = [NSString stringWithFormat:@"%@merchantfilters",BASEURL];
                
                
                if (isRatingBool==YES || isDeliveryBool==YES)
                {
                    if (!isRatingBool)
                    {
                        strRating =@"";
                    }
                    
                    if (!isDeliveryBool) {
                        strdeliveryTime =@"";
                    }
                    
                    requestDict = @{
                                    
                                    
                                    @"restaurant_value":[Utilities null_ValidationString:strValue],
                                    @"rating":[Utilities null_ValidationString:strRating],
                                    @"delivery_time":@"ascending",
                                    //[Utilities null_ValidationString:],
                                    @"cuisines":[Utilities null_ValidationString:strCusines],
                                    @"user_id":[Utilities getUserID],
                                    @"latitude":strLatitude,
                                    @"longitude":strLongitude
                                    
                                    };
                }
                else if(isRatingBool==NO && isDeliveryBool==NO)
                {
                    requestDict = @{
                                    
                                    
                                    @"restaurant_value":[Utilities null_ValidationString:strValue],
                                    @"rating":@"",
                                    @"delivery_time":@"",
                                    @"cuisines":[Utilities null_ValidationString:strCusines],
                                    @"user_id":[Utilities getUserID],
                                    @"latitude":strLatitude,
                                    @"longitude":strLongitude
                                    
                                    };
                }
                
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    ServiceManager *service = [ServiceManager sharedInstance];
                    service.delegate = self;
                    
                    
                    [service  handleRequestWithDelegates:urlStr info:requestDict];
                    // [self uploadImagetoServer:urlStr];
                    
                });
                
                isBack = NO;
            }
            else
            {
                [Utilities displayCustemAlertViewWithOutImage:@"Internet connection error" :self.view];
            }
        }
        else
        {
            [ISMessages showCardAlertWithTitle:nil
                                       message:@"Please select Filter options"
                                      duration:1.f
                                   hideOnSwipe:YES
                                     hideOnTap:YES
                                     alertType:ISAlertTypeInfo
                                 alertPosition:ISAlertPositionTop
                                       didHide:^(BOOL finished) {
                                           NSLog(@"Alert did hide.");
                                       }];
        }
        
        
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
        
    });
}
-(void)handleResponse :(NSDictionary *)responseInfo
{
    NSLog(@"responseInfo :%@",responseInfo);
    @try {
        if([[responseInfo valueForKey:@"status"] intValue] == 1)
            
        {
            dispatch_async(dispatch_get_main_queue(), ^{
            
                
            RestaurantsViewController * restaurants = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"RestaurantsViewController"];
           // restaurants.filterDict =responseInfo;
                singleToninstance.filteredDict = responseInfo;
                singleToninstance.isfilter = YES;
            restaurants.isfilters = YES;
            
                [self.navigationController popViewControllerAnimated:YES];
 });
         
        }
        
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *str = [NSString stringWithFormat:@"%@",[responseInfo valueForKey:@"response"]];
                [Utilities displayCustemAlertViewWithOutImage:str :self.view];
            });
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities removeLoading:self.view];
        });
        
    }
    
    @catch (NSException *exception) {
        
    }
    @finally {
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities removeLoading:self.view];
            [self.view endEditing:YES];
        });
        
    }
}
@end
