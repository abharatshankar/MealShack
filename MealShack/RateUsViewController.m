//
//  RateUsViewController.m
//  MealShack
//
//  Created by Prasad on 11/08/17.
//  Copyright © 2017 Possibillion. All rights reserved.
//

#import "RateUsViewController.h"
#import "ServiceManager.h"
#import "Utilities.h"
#import "Constants.h"
#import "StarRatingView.h"
#import "SingleTon.h"
#import "RestaurantsViewController.h"
#import "SideMenuViewController.h"
#import "SWRevealViewController.h"



#define kLabelAllowance 50.0f
#define kStarViewHeight 30.0f
#define kStarViewWidth 130.0f
#define kLeftPadding 5.0f


@interface RateUsViewController ()<ServiceHandlerDelegate,UITextViewDelegate,UIGestureRecognizerDelegate,SWRevealViewControllerDelegate>
{
    SingleTon *singleTonInstance;
    BOOL * isPop;
    SWRevealViewController *revealController;
    

}

@end

@implementation RateUsViewController
@synthesize createdOnId,restaurant,totalCost;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    isPop = YES;
    
    [self.commentsView setDelegate:self];
    
    singleTonInstance=[SingleTon singleTonMethod];
    
    //////////////////
    NSMutableArray *arrLeftBarItems = [[NSMutableArray alloc] init];
    
    UIButton *btninfo = [[UIButton alloc]initWithFrame:CGRectMake(116, 22, 26, 27)];
    [btninfo setImage:[UIImage imageNamed:@"info.png"] forState:UIControlStateNormal ];
    UIBarButtonItem * itemreload = [[UIBarButtonItem alloc] initWithCustomView:btninfo];
    [btninfo addTarget:self action:@selector(infoMethodClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    NSLayoutConstraint * widthConstraint = [btninfo.widthAnchor constraintEqualToConstant:30];
    NSLayoutConstraint * HeightConstraint =[btninfo.heightAnchor constraintEqualToConstant:30];
    [widthConstraint setActive:YES];
    [HeightConstraint setActive:YES];
    
    
    NSArray *arrBtns = [[NSArray alloc]initWithObjects:itemreload, nil];
    self.navigationItem.rightBarButtonItems = arrBtns;
    
    
    
    UIButton *btntitle = [UIButton buttonWithType:UIButtonTypeCustom];
    [btntitle setTitle:@"Rate Us" forState:UIControlStateNormal];
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
    
    self.PopView.hidden = YES;
    
    
    SWRevealViewController *revealController = [self revealViewController];
    
   
    

//    StarRatingView* starview = [[StarRatingView alloc]initWithFrame:CGRectMake(85,self.deliveryExp.frame.origin.y+self.deliveryExp.frame.size.height+10, kStarViewWidth+kLabelAllowance+kLeftPadding, kStarViewHeight) andRating:60 withLabel:NO animated:NO];
//    [self.view addSubview:starview];
    
    
    
    if (IS_IPHONE_5 || IS_IPHONE_5S || IS_IPHONE_5C)
    {
        StarRatingView* starview = [[StarRatingView alloc]initWithFrame:CGRectMake(70,self.deliveryExp.frame.origin.y+self.deliveryExp.frame.size.height+10, kStarViewWidth+kLabelAllowance+kLeftPadding, kStarViewHeight) andRating:60 withLabel:NO animated:NO];
        [self.view addSubview:starview];
 
    }
    else if (IS_STANDARD_IPHONE_6 || IS_STANDARD_IPHONE_6S || IS_STANDARD_IPHONE_7 )
    {
        StarRatingView* starview = [[StarRatingView alloc]initWithFrame:CGRectMake(95,self.deliveryExp.frame.origin.y+self.deliveryExp.frame.size.height+10, kStarViewWidth+kLabelAllowance+kLeftPadding, kStarViewHeight) andRating:60 withLabel:NO animated:NO];
        [self.view addSubview:starview];

    }
    else if( IS_STANDARD_IPHONE_6_PLUS || IS_STANDARD_IPHONE_6S_PLUS || IS_STANDARD_IPHONE_7_PLUS )
    {
        StarRatingView* starview = [[StarRatingView alloc]initWithFrame:CGRectMake(115,self.deliveryExp.frame.origin.y+self.deliveryExp.frame.size.height+10, kStarViewWidth+kLabelAllowance+kLeftPadding, kStarViewHeight) andRating:60 withLabel:NO animated:NO];
        [self.view addSubview:starview];
        
    }
    else
    {
        StarRatingView* starview = [[StarRatingView alloc]initWithFrame:CGRectMake(90,self.deliveryExp.frame.origin.y+self.deliveryExp.frame.size.height+10, kStarViewWidth+kLabelAllowance+kLeftPadding, kStarViewHeight) andRating:60 withLabel:NO animated:NO];
        [self.view addSubview:starview];
    }
    
    
//    StarRatingView* starview1 = [[StarRatingView alloc]initWithFrame:CGRectMake(85,self.restExp.frame.origin.y+self.restExp.frame.size.height+10, kStarViewWidth+kLabelAllowance+kLeftPadding, kStarViewHeight) andRating:60 withLabel:NO animated:NO];
//    [self.view addSubview:starview1];
    
    
    if (IS_IPHONE_5 || IS_IPHONE_5S || IS_IPHONE_5C)
    {
        StarRatingView* starview1 = [[StarRatingView alloc]initWithFrame:CGRectMake(70,self.restExp.frame.origin.y+self.restExp.frame.size.height+10, kStarViewWidth+kLabelAllowance+kLeftPadding, kStarViewHeight) andRating:60 withLabel:NO animated:NO];
        [self.view addSubview:starview1];
    }
    else if (IS_STANDARD_IPHONE_6 || IS_STANDARD_IPHONE_6S || IS_STANDARD_IPHONE_7 )
    {
        StarRatingView* starview1 = [[StarRatingView alloc]initWithFrame:CGRectMake(95,self.restExp.frame.origin.y+self.restExp.frame.size.height+10, kStarViewWidth+kLabelAllowance+kLeftPadding, kStarViewHeight) andRating:60 withLabel:NO animated:NO];
        [self.view addSubview:starview1];
    }
    else if(IS_STANDARD_IPHONE_6_PLUS || IS_STANDARD_IPHONE_6S_PLUS || IS_STANDARD_IPHONE_7_PLUS )
    {
        StarRatingView* starview1 = [[StarRatingView alloc]initWithFrame:CGRectMake(115,self.restExp.frame.origin.y+self.restExp.frame.size.height+10, kStarViewWidth+kLabelAllowance+kLeftPadding, kStarViewHeight) andRating:60 withLabel:NO animated:NO];
        [self.view addSubview:starview1];
    }
    else
    {
        StarRatingView* starview1 = [[StarRatingView alloc]initWithFrame:CGRectMake(90,self.restExp.frame.origin.y+self.restExp.frame.size.height+10, kStarViewWidth+kLabelAllowance+kLeftPadding, kStarViewHeight) andRating:60 withLabel:NO animated:NO];
        [self.view addSubview:starview1];

    }

    self.commentsView.layer.borderWidth = 2.0f;
    self.commentsView.layer.borderColor = [[UIColor grayColor] CGColor];
    self.commentsView.returnKeyType = UIReturnKeyDone;
    
    self.DateNTimeLbl.text = createdOnId;
    self.restaurantNameLbl.text = restaurant;
    self.ItemPriceLbl.text = totalCost;
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
     revealController.panGestureRecognizer.enabled = NO;
}

-(void)viewWillDisappear:(BOOL)animated
{

     revealController.panGestureRecognizer.enabled = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)infoMethodClicked:(id)sender
{
    if (isPop == YES) {
         self.PopView.hidden = NO;
        isPop  =NO;
    }
    else{
        self.PopView.hidden = YES;
        isPop  =YES;
    }
}


////Delegate Methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesBegan:withEvent:");
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    NSLog(@"textViewShouldBeginEditing:");
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    NSLog(@"textViewDidBeginEditing:");
    textView.backgroundColor = [UIColor whiteColor];
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    NSLog(@"textViewShouldEndEditing:");
    textView.backgroundColor = [UIColor whiteColor];
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    NSLog(@"textViewDidEndEditing:");
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSCharacterSet *doneButtonCharacterSet = [NSCharacterSet newlineCharacterSet];
    NSRange replacementTextRange = [text rangeOfCharacterFromSet:doneButtonCharacterSet];
    NSUInteger location = replacementTextRange.location;
    
    if (textView.text.length + text.length > 140){
        if (location != NSNotFound){
            [textView resignFirstResponder];
        }
        return NO;
    }
    else if (location != NSNotFound){
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView
{
    NSLog(@"textViewDidChange:");
}
- (void)textViewDidChangeSelection:(UITextView *)textView
{
    NSLog(@"textViewDidChangeSelection:");
}


- (IBAction)SubmitButton_Clicked:(id)sender
{
    [self.view endEditing:YES];
    
  //  NSString * starValues;
    
    
    
//    if (_restExp.text.length)
//    {
//        
//    }
    
    if ([singleTonInstance.userRatingStr intValue]>0)
    {
    
    
       
        
    if ([Utilities isInternetConnectionExists]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
        });
        
        
        NSString *urlStr = [NSString stringWithFormat:@"%@userRating",BASEURL];
        
        NSLog(@"---%@----",singleTonInstance.userRatingStr);
        
        NSString * deliveryRating, * restaurantRating;

        if ([singleTonInstance.userRatingStr isEqualToString:@"80%"])
        {
            deliveryRating = @"4";
            restaurantRating = @"4";
        }
        else if ([singleTonInstance.userRatingStr isEqualToString:@"60%"])
        {
            deliveryRating = @"3";
            restaurantRating = @"3";
        }
        else if ([singleTonInstance.userRatingStr isEqualToString:@"40%"])
        {
            deliveryRating = @"2";
            restaurantRating = @"2";
        }
        else if ([singleTonInstance.userRatingStr isEqualToString:@"20%"])
        {
            deliveryRating = @"1";
            restaurantRating = @"1";
        }
        else
        {
            deliveryRating = @"5";
            restaurantRating = @"5";
        }

        
        
        
        NSDictionary *requestDict = @{
                                      @"order_id":self.strOrderID,
                                      @"establishment_id":self.establishmentID,
                                      @"user_id":[Utilities getUserID],
                                      @"delivery_rating":deliveryRating,
                                      @"restaurant_rating":restaurantRating,
                                      @"comments":self.commentsView.text
                                      
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
    else
    {
    [Utilities displayCustemAlertViewWithOutImage:@"Please Give your valuable Ratings" :self.view];
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
    
    if([[responseInfo valueForKey:@"status"] intValue] == 1)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            RestaurantsViewController * restaurants = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"RestaurantsViewController"];
            [self.navigationController pushViewController:restaurants animated:YES];
 
            
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


@end
