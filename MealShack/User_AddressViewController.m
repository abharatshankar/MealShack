//
//  User_AddressViewController.m
//  Shopality
//
//  Created by PossibillionTech on 5/3/17.
//  Copyright © 2017 PossibillionTech. All rights reserved.
//

#import "User_AddressViewController.h"
#import "SWRevealViewController.h"
#import "user_AddressViewCell.h"
#import "SingleTon.h"
#import "SideMenuViewController.h"
#import "SlideMenuTableViewCell.h"
#import "Constants.h"
#import "LoginViewController.h"
#import "Utilities.h"
#import "ServiceManager.h"
#import "UIImageView+WebCache.h"
#import "ImageCache.h"
#import "MJDetailViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import "AddAddressManually.h"

@interface User_AddressViewController ()<UITableViewDataSource,UITableViewDelegate,ServiceHandlerDelegate>
{

    int cartItemsCount;
   NSMutableArray * arrqty;
    NSMutableArray *arrprices;
    NSMutableArray *selectedAdress;
    BOOL isAddressSelected;
    NSMutableArray *arrAddressList,*arrMarchantInfo,*arrProducts;
    NSMutableDictionary *dictProducts;
    NSString *selectedTitle;
    NSUInteger selectedCategory_index;
    NSInteger variantTag,selectedTag;
    NSString *straddress;
    NSString *strplaces;
    NSString * strTitle;
    SingleTon * singleInstance;


}


@property (strong, nonatomic) IBOutlet UILabel *cartCountLabel;

- (IBAction)pushExample:(id)sender;

@end


@implementation User_AddressViewController
@synthesize isfromCart,delegate,addressTypString;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    selectedTag = 0;
    singleInstance =   [SingleTon singleTonMethod];

    UIColor *color1 =  [Utilities getUIColorObjectFromHexString:@"#fd6565" alpha:1];

    _addNew.backgroundColor = color1;
    
    SWRevealViewController *revealController = [self revealViewController];
    
    revealController.panGestureRecognizer.enabled = NO;
        
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
        
        
        
        UIButton *btntitle = [UIButton buttonWithType:UIButtonTypeCustom];
        [btntitle setTitle:@"Your Addresses" forState:UIControlStateNormal];
        btntitle.titleLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:18];
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

}

-(void)Back_Click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)ServiceCall
{

    
    [self.view endEditing:YES];
    
                    if ([Utilities isInternetConnectionExists]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
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
    @try {
        if([[responseInfo valueForKey:@"status"] intValue] == 1)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                //HMsegmented control to display categories
                arrAddressList = [[NSMutableArray alloc] init];
                arrMarchantInfo  = [[NSMutableArray alloc] init];
                dictProducts  = [[NSMutableDictionary alloc] init];
                arrProducts = [[NSMutableArray alloc] init];
                
                arrqty=[[NSMutableArray alloc] init];
                arrprices=[[NSMutableArray alloc] init];
                
                
                
                arrAddressList = [responseInfo valueForKey:@"delivery_address_data"] ;
               // arrMarchantInfo = [responseInfo valueForKey:@"merchant_info"] ;

                
         
                [_tblProducts reloadData];

            });
            
           
        }
        
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *str = [NSString stringWithFormat:@"%@",[responseInfo valueForKey:@"result"]];
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


//search bar button method to go next view

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

    if ([arrAddressList count] > 0  )
    {
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        numOfSections                = 1;
        tableView.backgroundView = nil;
    }
    
    else
    {
        
            [Utilities removeLoading:self.view];
                
        UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, tableView.bounds.size.height)];
        noDataLabel.text             = @"No AddressList";
        noDataLabel.textColor        = GrayColor;
        noDataLabel.textAlignment    = NSTextAlignmentCenter;
        tableView.backgroundView = noDataLabel;
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
    
    return arrAddressList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    
    static NSString *simpleTableIdentifier = @"user_AddressViewCell";
    
    user_AddressViewCell *cell = (user_AddressViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if ([arrAddressList count] > 0 )
    {
        NSDictionary  *dict =[arrAddressList objectAtIndex:indexPath.row];
        
        
        NSString *strtitle = [NSString stringWithFormat:@"%@",[Utilities null_ValidationString:[dict valueForKey:@"address_tag"]]];

    straddress = [NSString stringWithFormat:@"%@",[Utilities null_ValidationString:[dict valueForKey:@"delivery_address"]]];
        
        
        strplaces = [NSString stringWithFormat:@"%@",[Utilities null_ValidationString:[dict valueForKey:@"address_tag"]]];
       // cell.btnvariant.tag=indexPath.row;
       // [cell.btnvariant addTarget:self action:@selector(DropDown:) forControlEvents:UIControlEventTouchUpInside];
        
    
    NSString *urlimage = [NSString stringWithFormat:@"%@",[Utilities null_ValidationString:[dict valueForKey:@""]]];
    
        if ([selectedAdress containsObject:[NSNumber numberWithInteger:indexPath.row]])
        {
            [cell.tickImageView setImage:[UIImage imageNamed:@"address_selection.png"]];
           // cell.lbltitle.tintColor= BGNavigationCOLOR;
        }
        else
        [cell.tickImageView setImage:[UIImage imageNamed:@""]];

        if ([strtitle isEqualToString:@"Office"])
        {
            [cell.imgHome setImage:[UIImage imageNamed:@"suit.png"]];
        }
        else if ([strtitle isEqualToString:@"Home"])
            [cell.imgHome setImage:[UIImage imageNamed:@"homeadd.png"]];
        else if ([strtitle isEqualToString:@"Other"])
            [cell.imgHome setImage:[UIImage imageNamed:@"lmark.png"]];
        

        
        
    
    NSString *imageUrl;
    imageUrl = [NSString stringWithFormat:@"%@%@",BASEURLImages,urlimage];
    
    if ([[[ImageCache sharedManager] imageCache] objectForKey:imageUrl])
    {
        cell.mainImage.image =[[[ImageCache sharedManager] imageCache] objectForKey:imageUrl];
    }
    else
    {
        [cell.mainImage sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                             placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    }
    
    
    
       // cell.lbltitle.text = strtitle;// capitalizedString];
        
        [cell.lbladdress adjustsFontSizeToFitWidth];

    cell.nameLabel.text = strname;// capitalizedString];
    cell.lbladdress.text  =  straddress;
        cell.placeLabel.text = strplaces;
        cell.lblphno.text  =  @"";

    }
    
   // [Utilities setBorderView:cell.bgview :5 :LIGHTGRYCOLOR];

    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    
    return cell;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self ServiceCall];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary  *dict =[arrAddressList objectAtIndex:indexPath.row];

    //caliclate distance
    
   NSString *strLatitude   = [NSString stringWithFormat:@"%@",[dict valueForKey:@"to_lat"]];
   NSString *strLongitude  = [NSString stringWithFormat:@"%@", [dict valueForKey:@"to_long"]];
    [USERDEFAULTS setObject:strLatitude forKey:@"selectedlat"];
    [USERDEFAULTS setObject:strLongitude forKey:@"selectedlong"];
   

    
    NSString *stradd = [NSString stringWithFormat:@"%@",[Utilities null_ValidationString:[dict valueForKey:@"delivery_address"]]];
    
    NSString *strtitle = [NSString stringWithFormat:@"%@",[Utilities null_ValidationString:[dict valueForKey:@"address_tag"]]];
    
    singleInstance.addressTyp = strtitle;
    
    //[NSString stringWithFormat:@"%@",[USERDEFAULTS objectForKey:@"addressDictionary"]];
    
    [USERDEFAULTS setObject:stradd forKey:@"addressDictionary1"];
    NSLog(@"addressDictionary %@",[NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:@"addressDictionary1"]]);

    [self.navigationController popViewControllerAnimated:YES];
    
  
}
-(IBAction)getLocation:(id)sender
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddAddressManually *nearby = [storyboard instantiateViewControllerWithIdentifier:@"AddAddressManually"];
    
    nearby. strTitle = @"Add New Address";
    [self.navigationController pushViewController:nearby animated:YES];
    
}


#pragma mark - Table view data source

//number of sections in table view

- (void)didUpdateItemCount:(int)count {
    cartItemsCount = count;
    
    self.cartCountLabel.text = [NSString stringWithFormat:@"%d", cartItemsCount];
}
@end
