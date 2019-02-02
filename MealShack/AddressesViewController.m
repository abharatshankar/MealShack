//
//  AddressesViewController.m
//  MealShack
//
//  Created by Prasad on 24/07/17.
//  Copyright © 2017 Possibillion. All rights reserved.
//

#import "AddressesViewController.h"
#import "SWRevealViewController.h"
#import "SideMenuViewController.h"
#import "Constants.h"
#import "Utilities.h"
#import "AddressesCell.h"
#import "ServiceManager.h"
#import "AddAddressManually.h"
#import "MJDetailViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>
#import "UILabel+SOXGlowAnimation.h"

@interface AddressesViewController ()<ServiceHandlerDelegate,UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    
    NSMutableArray * totalAddressArray;
    NSDictionary *requestDict,*requestDict1;
    UIAlertView *alertView;
    NSMutableArray * arrDelete;
    BOOL isdeleted;
    NSInteger variantTag,selectedTag;
    NSString * strTitle;

}

@end

@implementation AddressesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    selectedTag = 0;

    
    self.title = @"Your Addresses";
    
    UIColor *color1 =  [Utilities getUIColorObjectFromHexString:@"#fd6565" alpha:1];

    _addAddress.backgroundColor = color1;
    
    
    _shimTest1.hidden = NO;
    _shimTest2.hidden = NO;
    _shimTest3.hidden = NO;
    _shimTest4.hidden = NO;
    _shimTest5.hidden = NO;
    _shimTest6.hidden = NO;
    _shimTest7.hidden = NO;
    _shimTest8.hidden = NO;
    _shimTest9.hidden = NO;
    _shimTest10.hidden = NO;
    _shimTest11.hidden = NO;
    _shimTest12.hidden = NO;
    _shimTest13.hidden = NO;
    _shimTest14.hidden = NO;
    _shimTest15.hidden = NO;


    // Do any additional setup after loading the view.
    
    
    
    
    SWRevealViewController *revealController = [self revealViewController];
    
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    totalAddressArray = [[NSMutableArray alloc]init];
    arrDelete =[[NSMutableArray alloc]init];
    
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:[UIFont fontWithName:@"MyriadPro-Semibold" size:18]}];
    
    UIButton *toggleBtn= [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 50, 35)];
    [toggleBtn.layer addSublayer:[Utilities customToggleButton]];
    [toggleBtn addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftRevealButtonItem = [[UIBarButtonItem alloc]initWithCustomView:toggleBtn];
    
    
    self.navigationController.navigationBar.tintColor = WHITECOLOR;

    self.navigationController.navigationBar.barTintColor = color1;
    self.navigationController.navigationBar.translucent = YES;
    self.navigationItem.leftBarButtonItem = leftRevealButtonItem;
    
    
    
    
    

}



-(void)DeleteButton_Clicked:(UIButton*)sender
{
    UIButton *btn=(UIButton *)sender;
    variantTag =btn.tag;
    
    
    CustomAlertView *cstmAlertReview = [[CustomAlertView alloc]initWithAlertType:ImageWithTwoButtonsType andMessage:@"Are you sure you want to delete?" andImageName:@"" andCancelTitle:@"No" andOtherTitle:@"Yes" andDisplayOn:self.navigationController.view];
    [self.navigationController.view addSubview:cstmAlertReview];
    cstmAlertReview.delegate = self;
    
    
}


-(void)customAlertView:(CustomAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        isdeleted = YES;
        
        if ([Utilities isInternetConnectionExists]) {
            dispatch_async(dispatch_get_main_queue(), ^{
 
            });
            
            NSString *urlStr = [NSString stringWithFormat:@"%@delete_delivery_address",BASEURL];
            requestDict1 = @{
                             @"address_id":[NSString stringWithFormat:@"%@",[[totalAddressArray objectAtIndex:variantTag] objectForKey:@"id"]]};
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            ServiceManager *service = [ServiceManager sharedInstance];
            service.delegate = self;
            [service  handleRequestWithDelegates:urlStr info:requestDict1];
                
            });
        }
        else
        {
            [Utilities displayCustemAlertViewWithOutImage:@"Please Check Your Internet connection" :self.view];
        }
    }
    else
    {
        
        
        
    }
    
}

-(void)AddressService
{
    [self.view endEditing:YES];
    
    if ([Utilities isInternetConnectionExists]) {
        dispatch_async(dispatch_get_main_queue(), ^{
         //   [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
            [self.shimTest1 addGlowEffectWithWidth:80 duration:1.5];
            [self.shimTest2 addGlowEffectWithWidth:80 duration:1.5];
            [self.shimTest3 addGlowEffectWithWidth:80 duration:1.5];
            [self.shimTest4 addGlowEffectWithWidth:80 duration:1.5];
             [self.shimTest5 addGlowEffectWithWidth:80 duration:1.5];
            [self.shimTest6 addGlowEffectWithWidth:80 duration:1.5];
            [self.shimTest7 addGlowEffectWithWidth:80 duration:1.5];
            [self.shimTest8 addGlowEffectWithWidth:80 duration:1.5];
            [self.shimTest9 addGlowEffectWithWidth:80 duration:1.5];
            [self.shimTest10 addGlowEffectWithWidth:80 duration:1.5];
            [self.shimTest11 addGlowEffectWithWidth:80 duration:1.5];
            [self.shimTest12 addGlowEffectWithWidth:80 duration:1.5];
            [self.shimTest13 addGlowEffectWithWidth:80 duration:1.5];
            [self.shimTest14 addGlowEffectWithWidth:80 duration:1.5];
            [self.shimTest15 addGlowEffectWithWidth:80 duration:1.5];
        });
        
        NSDictionary *requestDict;
        NSString *urlStr = [NSString stringWithFormat:@"%@user_delivery_address",BASEURL];
        requestDict = @{
                        @"user_id":[Utilities getUserID]
                        };
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            ServiceManager *service = [ServiceManager sharedInstance];
            service.delegate = self;
            
            
            [service  handleRequestWithDelegates:urlStr info:requestDict];
            
        });
        
        
    }
    else
    {
        [Utilities displayCustemAlertViewWithOutImage:@"Please Check Your Internet connection" :self.view];
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
            
            
            
            if (isdeleted == YES)
            {
            dispatch_async(dispatch_get_main_queue(), ^{

                
                

                     isdeleted = NO;
                     [self AddressService];
            });
                
                }
                else
                {
                dispatch_async(dispatch_get_main_queue(), ^{
                //HMsegmented control to display categories
                totalAddressArray = [[NSMutableArray alloc] init];
                
                totalAddressArray = [responseInfo valueForKey:@"delivery_address_data"] ;
                    
                [_AddressTableView reloadData];

                
            });
            }
            
        }
        
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *str = [NSString stringWithFormat:@"%@",[responseInfo valueForKey:@"result"]];
                //[Utilities displayCustemAlertViewWithOutImage:str :self.view];
            });
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            _shimTest1.hidden = YES;
            _shimTest2.hidden = YES;
            _shimTest3.hidden = YES;
            _shimTest4.hidden = YES;
            _shimTest5.hidden = YES;
            _shimTest6.hidden = YES;
            _shimTest7.hidden = YES;
            _shimTest8.hidden = YES;
            _shimTest9.hidden = YES;
            _shimTest10.hidden = YES;
            _shimTest11.hidden = YES;
            _shimTest12.hidden = YES;
            _shimTest13.hidden = YES;
            _shimTest14.hidden = YES;
            _shimTest15.hidden = YES;
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Tableview methods
- (float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger numOfSections = 0;
    
    if ([totalAddressArray count] > 0  )
    {
    
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        numOfSections                = 1;
        tableView.backgroundView = nil;
    }
    
    else
    {
        
        [Utilities removeLoading:self.view];

//        UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, tableView.bounds.size.height)];
//        noDataLabel.text             = @"No AddressList";
//        noDataLabel.textColor        = GrayColor;
//        noDataLabel.textAlignment    = NSTextAlignmentCenter;
//        tableView.backgroundView = noDataLabel;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return numOfSections;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    // To "clear" the footer view
    return [UIView new] ;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (totalAddressArray.count>0) {
        
         AddressesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddressesCell"];
        
        cell.AreaLabel.backgroundColor = [UIColor clearColor];

        
        return totalAddressArray.count;
    }
    else
    {
        NSLog(@"coming inside  - - - - - -");
         AddressesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddressesCell"];

        

//         [self.shimTest1 addGlowEffectWithWidth:80 duration:1.5];
//        [self.shimTest2 addGlowEffectWithWidth:80 duration:1.5];
//        [self.shimTest3 addGlowEffectWithWidth:80 duration:1.5];
//        [self.shimTest4 addGlowEffectWithWidth:80 duration:1.5];
//        [self.shimTest5 addGlowEffectWithWidth:80 duration:1.5];
//        [self.shimTest6 addGlowEffectWithWidth:80 duration:1.5];
//        [self.shimTest7 addGlowEffectWithWidth:80 duration:1.5];
//        [self.shimTest8 addGlowEffectWithWidth:80 duration:1.5];
//        [self.shimTest9 addGlowEffectWithWidth:80 duration:1.5];
//        [self.shimTest10 addGlowEffectWithWidth:80 duration:1.5];
//        [self.shimTest11 addGlowEffectWithWidth:80 duration:1.5];
//        [self.shimTest12 addGlowEffectWithWidth:80 duration:1.5];
//        [self.shimTest13 addGlowEffectWithWidth:80 duration:1.5];
//        [self.shimTest14 addGlowEffectWithWidth:80 duration:1.5];
//        [self.shimTest15 addGlowEffectWithWidth:80 duration:1.5];
        
        
        return 0;
    }
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell...
   
    static NSString *CellIdentifier = @"AddressesCell";
    
    AddressesCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[AddressesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    

    if ([totalAddressArray count] > 0)
    {
        NSDictionary  *dict =[totalAddressArray objectAtIndex:indexPath.row];

        cell.btnedit.tag=indexPath.row;
        [cell.btnedit addTarget:self action:@selector(editbuttonclick:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.btndelete.tag=indexPath.row;
        [cell.btndelete addTarget:self action:@selector(DeleteButton_Clicked:) forControlEvents:UIControlEventTouchUpInside];

        

        [cell.AreaLabel adjustsFontSizeToFitWidth];
        [cell.PlaceLabel adjustsFontSizeToFitWidth];
        
    cell.PlaceLabel.text = [[totalAddressArray objectAtIndex:indexPath.row]objectForKey:@"address_tag"];
    cell.AreaLabel.text =[[totalAddressArray objectAtIndex:indexPath.row]objectForKey:@"delivery_address"];
    _address_id = [[totalAddressArray objectAtIndex:indexPath.row] objectForKey:@"id"];
        NSString *strtitle = [NSString stringWithFormat:@"%@",[Utilities null_ValidationString:[dict valueForKey:@"address_tag"]]];

        if ([strtitle isEqualToString:@"Office"])
        {
            [cell.imgHome setImage:[UIImage imageNamed:@"suit.png"]];
        }
        else if ([strtitle isEqualToString:@"Home"])
            [cell.imgHome setImage:[UIImage imageNamed:@"homeadd.png"]];
        else if ([strtitle isEqualToString:@"Other"])
            [cell.imgHome setImage:[UIImage imageNamed:@"lmark.png"]];
        
    }
    
    
    
    return cell;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self AddressService];
    
    SWRevealViewController *revealController = [self revealViewController];
    
    revealController.panGestureRecognizer.enabled = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //Has to be unregistered always, otherwise nav controllers down the line will call this method
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"TestNotification" object:nil];
    
}

- (void) receiveTestNotification:(NSNotification *) notification
{
   
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    
    if ([[notification name] isEqualToString:@"TestNotification"])
    {
        
        NSLog (@"Successfully received the test notification! %@",notification.object);
        NSLog(@"%@",[totalAddressArray objectAtIndex:[notification.object intValue]]);
        selectedTag = [notification.object intValue];
        
        [_AddressTableView reloadData];

    }
    
    
}




 // code changed
-(void)editbuttonclick:(UIButton*)sender
{
    UIButton *btn=(UIButton *)sender;
    NSInteger btnvalue =btn.tag;

    NSDictionary *myDictionary = [totalAddressArray objectAtIndex:btnvalue];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddAddressManually *nearby = [storyboard instantiateViewControllerWithIdentifier:@"AddAddressManually"];
     NSData *data = [NSKeyedArchiver archivedDataWithRootObject:myDictionary];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"selectedAddress"];
    //code changed on aug 23 
//    nearby.editLocationLatLong()
    
    
    nearby.latiSt = [[totalAddressArray objectAtIndex:btnvalue] objectForKey:@"to_lat"] ;
    
    nearby.longiSt = [[totalAddressArray objectAtIndex:btnvalue] objectForKey:@"to_long"];
    
    nearby. strTitle = @"Edit Address";
    [self.navigationController pushViewController:nearby animated:YES];

}


-(IBAction)getLocation:(id)sender
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddAddressManually *nearby = [storyboard instantiateViewControllerWithIdentifier:@"AddAddressManually"];
    
    nearby. strTitle = @"Add New Address";
    
    [self.navigationController pushViewController:nearby animated:YES];
    
}

@end
