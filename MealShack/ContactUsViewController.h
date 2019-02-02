//
//  ContactUsViewController.h
//  MealShack
//
//  Created by Prasad on 24/07/17.
//  Copyright © 2017 Possibillion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonClassViewController.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface ContactUsViewController : CommonClassViewController <MFMailComposeViewControllerDelegate>
{
    MFMailComposeViewController *mailpicker;

}

@property (strong, nonatomic) IBOutlet UIView *bgview;
@property (strong, nonatomic) IBOutlet UILabel *LblnameMbl;

@property (strong, nonatomic) IBOutlet UILabel *emailnameLbl;
@property (strong, nonatomic) IBOutlet UIView *ViewBg;
- (IBAction)EmailBtn_Tapped:(id)sender;
- (IBAction)MbleBtn_Tapped:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *EmailvalueLbl;
@property (strong, nonatomic) IBOutlet UILabel *mbltxtLbl;

@end
