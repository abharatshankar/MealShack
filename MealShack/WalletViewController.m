//
//  WalletViewController.m
//  MealShack
//
//  Created by Prasad on 06/02/18.
//  Copyright © 2018 Possibillion. All rights reserved.
//

#import "WalletViewController.h"
#import "SWRevealViewController.h"
#import "SideMenuViewController.h"
#import "Constants.h"
#import "Utilities.h"
#import "ServiceManager.h"
#import "RestaurantsMenuViewController.h"



@interface WalletViewController ()<ServiceHandlerDelegate>
{
    NSDictionary *requestDict ;
    NSMutableDictionary * totalWalletDict;
}

@end

@implementation WalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
     totalWalletDict=[[NSMutableDictionary alloc]init];
    
    SWRevealViewController *revealController = [self revealViewController];
    
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    
    self.title = @"Wallet";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:[UIFont fontWithName:@"MyriadPro-Semibold" size:18]}];
    
    UIButton *toggleBtn= [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 50, 35)];
    [toggleBtn.layer addSublayer:[Utilities customToggleButton]];
    [toggleBtn addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftRevealButtonItem = [[UIBarButtonItem alloc]initWithCustomView:toggleBtn];
    
    
    self.navigationController.navigationBar.tintColor = WHITECOLOR;
    UIColor *color1 =  [Utilities getUIColorObjectFromHexString:@"#fd6565" alpha:1];

    self.navigationController.navigationBar.barTintColor = color1;
    self.navigationController.navigationBar.translucent = YES;
    self.navigationItem.leftBarButtonItem = leftRevealButtonItem;
    
     [Utilities addShadowtoView:_bgView];
    
    [self WalletServiceCall];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)WalletServiceCall
{
    [self.view endEditing:YES];
    
    if ([Utilities isInternetConnectionExists]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
        });

        NSString *urlStr = [NSString stringWithFormat:@"%@userwallet",BASEURL];
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
    dispatch_async(dispatch_get_main_queue(), ^{
        [Utilities removeLoading:self.view];
    });
}
-(void)handleResponse :(NSDictionary *)responseInfo
{
    NSLog(@"responseInfo :%@",responseInfo);
    
    if([[responseInfo valueForKey:@"status"] intValue] == 1)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            totalWalletDict = [responseInfo objectForKey:@"wallet_amount"];
            
            self.Wallet_amountLbl.text = [NSString stringWithFormat:@"Meal Shack Credit : Rs.%@",totalWalletDict];
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



@end
