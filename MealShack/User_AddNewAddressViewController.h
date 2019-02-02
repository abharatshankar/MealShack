//
//  User_AddNewAddressViewController.h
//  ShappalityApp
//
//  Created by PossibillionTech on 6/6/17.
//  Copyright © 2017 possibilliontech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonClassViewController.h"
#import "ACFloatingTextField.h"

@interface User_AddNewAddressViewController : CommonClassViewController<UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *addressScroll;




@property (weak, nonatomic) IBOutlet UITextField *receiverField;
@property (weak, nonatomic) IBOutlet UITextField *receiverMobileField;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (strong, nonatomic) IBOutlet ACFloatingTextField *landmarkText;

@property (weak, nonatomic) IBOutlet ACFloatingTextField *flatnoTextField;

@property (weak, nonatomic) IBOutlet ACFloatingTextField *areaText;



@property (weak, nonatomic) IBOutlet UILabel *markLabel;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;


@property NSString *strMainTitle;


- (IBAction)saveBtn:(id)sender;
@property (nonatomic) BOOL isAddressEditing;


@end
