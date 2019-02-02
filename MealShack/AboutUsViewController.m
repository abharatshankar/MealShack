//
//  AboutUsViewController.m
//  MealShack
//
//  Created by Prasad on 24/07/17.
//  Copyright © 2017 Possibillion. All rights reserved.
//

#import "AboutUsViewController.h"
#import "SWRevealViewController.h"
#import "SideMenuViewController.h"
#import "Constants.h"
#import "Utilities.h"
#import "ServiceManager.h"
#import "AFHTTPSessionManager.h"

@interface AboutUsViewController ()<ServiceHandlerDelegate>

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SWRevealViewController *revealController = [self revealViewController];
    
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    
    self.title =@"About Us";
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
    
    [self Servicecall];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)Servicecall
{
    
    [self.view endEditing:YES];
    
    if ([Utilities isInternetConnectionExists]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
        });
    // making a GET request to about
    NSString *targetUrl = [NSString stringWithFormat:@"%@about",BASEURL];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:targetUrl]];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:
      ^(NSData * _Nullable data,
        NSURLResponse * _Nullable response,
        NSError * _Nullable error) {
          
          NSString *myString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
          
          NSError *e = nil;
          NSDictionary*jsondict;
          jsondict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&e];
         
          
          NSString * mainStr = [jsondict valueForKey:@"data"];
          
         NSRange r  = NSMakeRange(3, mainStr.length-22);
          
          
       
          NSString *path = [mainStr substringWithRange:r];
          dispatch_async(dispatch_get_main_queue(), ^{
          [self.About_lbl adjustsFontSizeToFitWidth];
             self.About_lbl.text = path;

          });
          
      }]resume];

    }
    else
    {
        [Utilities displayCustemAlertViewWithOutImage:@"Internet connection error" :self.view];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [Utilities removeLoading:self.view];
    });
}

@end
