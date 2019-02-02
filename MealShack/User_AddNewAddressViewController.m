//
//  User_AddNewAddressViewController.m
//  ShappalityApp
//
//  Created by PossibillionTech on 6/6/17.
//  Copyright © 2017 possibilliontech. All rights reserved.
//

#import "User_AddNewAddressViewController.h"
#import "Utilities.h"
#import "Constants.h"
#import "ServiceManager.h"
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
#import "User_AddressViewController.h"
#import "PopupViewController.h"
#import "LcnManager.h"
#import "ReviewOrderViewController.h"
#import "AddressesViewController.h"
#import "SingleTon.h"
#import "SWRevealViewController.h"



typedef NS_ENUM(NSUInteger , PopoverType) {
    MarkType,
    
};


@interface User_AddNewAddressViewController ()<PopOverViewControllerDelegate>
{
    PopupViewController *popoverVC;
    NSDictionary *dictionarydata;
    SingleTon *singleTonInstance;
   
}
@property (nonatomic) PopoverType mode;

@end

@implementation User_AddNewAddressViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    singleTonInstance=[SingleTon singleTonMethod];
    UIColor *color1 =  [Utilities getUIColorObjectFromHexString:@"#fd6565" alpha:1];

    _saveBtn.backgroundColor = color1;

    _addressScroll.scrollEnabled = YES;
    _addressScroll.scrollEnabled = NO;
    
    CGRect contentRect = CGRectZero;
    for (UIView *view in  _addressScroll.subviews) {
        contentRect = CGRectUnion(contentRect, view.frame);
    }
    _addressScroll.contentSize = contentRect.size;
    
    
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
    [btntitle setTitle:self.strMainTitle forState:UIControlStateNormal];
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
    
    
    
    _addressLabel.text = [NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:@"saveAddress"]];

  

    NSData *dictionarysave = [USERDEFAULTS objectForKey:@"selectedAddress"];
   dictionarydata = [NSKeyedUnarchiver unarchiveObjectWithData:dictionarysave];

    if (dictionarydata.count > 0)
    {
        
        _flatnoTextField.text= [NSString stringWithFormat:@"%@",[dictionarydata valueForKey:@"flat_no" ]];
        _areaText.text= [NSString stringWithFormat:@"%@",[dictionarydata valueForKey:@"area" ]];
        _landmarkText.text= [NSString stringWithFormat:@"%@",[dictionarydata valueForKey:@"land_mark" ]];
        _markLabel.text= [NSString stringWithFormat:@"%@",[dictionarydata valueForKey:@"address_tag" ]];
        _receiverField.text = [NSString stringWithFormat:@"%@",[dictionarydata valueForKey:@"receiver_name" ]];
        _receiverMobileField.text= [NSString stringWithFormat:@"%@",[dictionarydata valueForKey:@"receiver_number" ]];
        
        
    }
    
    
    SWRevealViewController *revealController = [self revealViewController];
    
    revealController.panGestureRecognizer.enabled = NO;
 
}
-(void)Back_Click:(id)sender
{
    [USERDEFAULTS removeObjectForKey:@"selectedAddress"];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)goto_frontView
{
//    AddressViewController * address = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"AddressViewController"];
//    [self.navigationController pushViewController:address animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)saveBtn:(id)sender {
    if (dictionarydata.count > 0)
    {
        if ([Utilities isInternetConnectionExists])
        {
            
            
            //loading UI Starting on mainThread
            dispatch_async(dispatch_get_main_queue(), ^{
                [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
            });
            
            NSDictionary *requestDict;
            
            
            //Request URL
            NSString *urlStr = [NSString stringWithFormat:@"%@edit_delivery_address",BASEURL];
            
            //parameters
            requestDict = @{
                            @"user_id":[Utilities getUserID],
                          //  @"aut_key":[Utilities getAuthKey],
                            @"establishment_id":establishment_id,
                            @"id":[NSString stringWithFormat:@"%@",[dictionarydata valueForKey:@"id" ]],
                            @"flat_no":[Utilities null_ValidationString:_flatnoTextField.text],
                            @"area":[Utilities null_ValidationString:_areaText.text],
                            @"land_mark":[Utilities null_ValidationString:_landmarkText.text],
                            @"latitude":[NSString stringWithFormat:@"%f",[[LcnManager sharedManager]locationManager].location.coordinate.latitude] ,
                            @"longitude":[NSString stringWithFormat:@"%f", [[LcnManager sharedManager]locationManager].location.coordinate.longitude],
                            @"address":[NSString stringWithFormat:@"%@",_addressLabel.text],
                            @"address_tag":[NSString stringWithFormat:@"%@",_markLabel.text],
                            @"receiver_name":[NSString stringWithFormat:@"%@",_receiverField.text],
                            @"receiver_number":[NSString stringWithFormat:@"%@",_receiverMobileField.text]};
            //Running Request in background thread
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                ServiceManager *service = [ServiceManager sharedInstance];
                service.delegate = self;
                
                //extra line
                [USERDEFAULTS removeObjectForKey:@"selectedAddress"];

                [service  handleRequestWithDelegates:urlStr info:requestDict];
                
            });
            [USERDEFAULTS removeObjectForKey:@"selectedAddress"];
        }
        else
        {
            [Utilities displayCustemAlertViewWithOutImage:@"Please Check Your Internet connection" :self.view];
        }

        
    }
    else{
        [self saveAddressServiceCall];
        
    }
    
}

-(void)saveAddressServiceCall
{
    
    [self.view endEditing:YES];

                if ([_landmarkText.text length] > 0)
                {
                    if ([_flatnoTextField.text length] > 0)
                    {
                        if ([_areaText.text length] > 0)
                        {
                            if ([_markLabel.text length] > 0)
                            {

                            if ([Utilities isInternetConnectionExists])
                            {
  
                            
                            //loading UI Starting on mainThread
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
                            });
                            
                            NSDictionary *requestDict;
                            

                            //Request URL
                                
                            NSString *urlStr = [NSString stringWithFormat:@"%@add_delivery_address",BASEURL];
                            //parameters
                            requestDict = @{
                                            @"user_id":[Utilities getUserID],
                                            @"flat_no":[Utilities null_ValidationString:_flatnoTextField.text],
                                            @"area":[Utilities null_ValidationString:_areaText.text],
                                            @"land_mark":[Utilities null_ValidationString:_landmarkText.text],
                                            @"latitude":singleTonInstance.strLat,
                                            @"longitude":singleTonInstance.strLong,
                                            
                                            //@"latitude":[NSString stringWithFormat:@"%f",[[LcnManager sharedManager]locationManager].location.coordinate.latitude] ,
                                           // @"longitude":[NSString stringWithFormat:@"%f", [[LcnManager sharedManager]locationManager].location.coordinate.longitude],
                                            @"address":[NSString stringWithFormat:@"%@",self.addressLabel.text],
                                            @"address_tag":[NSString stringWithFormat:@"%@",self.markLabel.text]
                                           };
                                
                            //Running Request in background thread
                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                
                                //singleton class
                                ServiceManager *service = [ServiceManager sharedInstance];
                                //singleton class custom delegate
                                service.delegate = self;
                                
                                //function to handle registration
                                [service  handleRequestWithDelegates:urlStr info:requestDict];

                            });
                                 
                            }
                            else
                            {
                                [Utilities displayCustemAlertViewWithOutImage:@"Please Check Your Internet connection" :self.view];
                            }
                            
                
                        }
                        else
                        {
                            [Utilities displayCustemAlertViewWithOutImage:@"Please select mark as" :self.view];
                        }
                        
                    }
                        else
                        {
                            [Utilities displayCustemAlertViewWithOutImage:@"Please enter area" :self.view];
                        }

                        }
                    else
                    {
                        [Utilities displayCustemAlertViewWithOutImage:@"Please enter flatno" :self.view];
                    }

                    }
                else
                {
                    [Utilities displayCustemAlertViewWithOutImage:@"Please enter landmark" :self.view];
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
                
                if (dictionarydata.count > 0)
                {
                    for (UIViewController* viewController in self.navigationController.viewControllers)
                    {
                        if ([viewController isKindOfClass:[User_AddressViewController class]] )
                        {
                            
                            User_AddressViewController *groupViewController = (User_AddressViewController*)viewController;
                        [self.navigationController popToViewController:groupViewController animated:YES];
                        }
                        else if([viewController isKindOfClass:[AddressesViewController class]] ) {
                        AddressesViewController *groupViewController = (AddressesViewController*)viewController;
                            [self.navigationController popToViewController:groupViewController animated:YES];
                            
                        }
                        else if([viewController isKindOfClass:[ReviewOrderViewController class]] ) {
                            ReviewOrderViewController *groupViewController = (ReviewOrderViewController*)viewController;
                            [self.navigationController popToViewController:groupViewController animated:YES];
                            
                        }


   

                    }
                }
                
                else
                {
                    for (UIViewController* viewController in self.navigationController.viewControllers) {
                        if ([viewController isKindOfClass:[User_AddressViewController class]] ) {
                            User_AddressViewController *groupViewController = (User_AddressViewController*)viewController;
                            [self.navigationController popToViewController:groupViewController animated:YES];
                          
                        }
                        else if([viewController isKindOfClass:[AddressesViewController class]] ) {
                        AddressesViewController *groupViewController = (AddressesViewController*)viewController;
                            [self.navigationController popToViewController:groupViewController animated:YES];
                            
                        }
                        else if([viewController isKindOfClass:[ReviewOrderViewController class]] ) {
                    ReviewOrderViewController *groupViewController = (ReviewOrderViewController*)viewController;
                            [self.navigationController popToViewController:groupViewController animated:YES];
                            
                        }

                      
                    }
                }
              
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
        });
        [self.view endEditing:YES];
    }
    
}





- (IBAction)Mark_Clicked:(id)sender
{
    _mode = MarkType;
    [self dropdownlinst];
}


-(void)dropdownlinst
{
    [self.view endEditing:YES];

    [_receiverField resignFirstResponder];
    [_receiverMobileField resignFirstResponder];
    [_landmarkText resignFirstResponder];
    [_flatnoTextField resignFirstResponder];
    [_areaText resignFirstResponder];
    
//    [self animateTextField:_areaText up:NO withOffset:txt.frame.origin.y / 2];
   
    if (!popoverVC) {
        popoverVC = [[PopupViewController alloc]initWithNibName:@"PopupViewController" bundle:nil];
        popoverVC.delegate = self;
    }
    
    
    if (_mode == MarkType)
    {
        NSMutableArray * arrdropdowns = [[NSMutableArray alloc]initWithObjects:@"Home",@"Office",@"Other", nil];
        
    
            popoverVC.popoverTableData = arrdropdowns;
            
            popoverVC.headingString = @"MarkAs";
            [popoverVC.popoverTableView reloadData];
            [self presentPopupViewController:popoverVC animationType:MJPopupViewAnimationFade];
        
        
        
    }
    
    
    
}

#pragma mark - Popover delegate

-(void)selectedField:(NSString *)fieldName{
    switch (_mode) {
        case MarkType:{
            
               NSLog(@"selected name :%@",fieldName)  ;
                
            _markLabel.text = [NSString stringWithFormat:@"%@",fieldName];
            
            
        }
            break;
            
            
        default:
            break;
    }
    
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}




#pragma mark - TextField delegates


-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (textField == _receiverMobileField ) {
        [self showDoneButtonOnNumberPad:textField];
    }

    [self animateTextField:textField up:YES withOffset:textField.frame.origin.y / 2];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    [self animateTextField:textField up:NO withOffset:textField.frame.origin.y / 2];
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return true;
}


//textfield animate
-(void)animateTextField:(UITextField*)textField up:(BOOL)up withOffset:(CGFloat)offset
{
    const int movementDistance = -offset;
    const float movementDuration = 0.4f;
    int movement = (up ? movementDistance : -movementDistance);
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
#define ACCEPTABLE_CHARACTERS @" ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    
    if (textField == _receiverMobileField) {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        if (newLength > 10) {
            return NO;
        }
        else{
            NSNumberFormatter * nf = [[NSNumberFormatter alloc] init];
            [nf setNumberStyle:NSNumberFormatterNoStyle];
            
            NSString * newString = [NSString stringWithFormat:@"%@%@",textField.text,string];
            NSNumber * number = [nf numberFromString:newString];
            
            if (number)
                return YES;
            else
                return NO;
        }
    }

    
#define ACCEPTABLE_CHARACTERS @" ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    
    // verify the text field you wanna validate
    
    // do not allow the first character to be space | do not allow more than one space
    if ([string isEqualToString:@" "]) {
        if (!textField.text.length)
            return NO;
        if ([[textField.text stringByReplacingCharactersInRange:range withString:string] rangeOfString:@"  "].length)
            return NO;
    }
    
    
    return YES;
}


//show done button on keypad
-(void)showDoneButtonOnNumberPad :(UITextField *)txtField
{
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    [keyboardDoneButtonView sizeToFit];
    
    UIBarButtonItem *flexibleSpace =  [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *done = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneClicked:)];
    done.tintColor = [UIColor blackColor];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:flexibleSpace,done, nil]];
    txtField.inputAccessoryView = keyboardDoneButtonView;
    
}

-(void)doneClicked:(id)sender
{
    [self.view endEditing:YES];
}


@end
