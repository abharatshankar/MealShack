//
//  ContactUsViewController.m
//  MealShack
//
//  Created by Prasad on 24/07/17.
//  Copyright © 2017 Possibillion. All rights reserved.
//

#import "ContactUsViewController.h"
#import "SWRevealViewController.h"
#import "SideMenuViewController.h"
#import "Constants.h"
#import "Utilities.h"
#import "ServiceManager.h"
#import "ServiceInitiater.h"

@interface ContactUsViewController ()<ServiceHandlerDelegate>

@end

@implementation ContactUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    SWRevealViewController *revealController = [self revealViewController];
    
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    self.title = @"Contact Us";
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
    
 
    
    [Utilities addShadowtoView:_bgview];
    [Utilities addShadowtoView:_ViewBg];
    
    [self ContactUsServiceCall];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)ContactUsServiceCall
{
    
    [self.view endEditing:YES];
    
    if ([Utilities isInternetConnectionExists]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
        });

    
    // making a GET request to about
    NSString *targetUrl = [NSString stringWithFormat:@"%@contactusInfo",BASEURL];
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

          dispatch_async(dispatch_get_main_queue(), ^{
             
    self.LblnameMbl.text = [NSString stringWithFormat:@"%@",[[[jsondict objectForKey:@"contactInfo"]objectAtIndex:1]objectForKey:@"name"]];
    self.mbltxtLbl.text = [NSString stringWithFormat:@"%@",[[[jsondict objectForKey:@"contactInfo"]objectAtIndex:1]objectForKey:@"value"]];
              
    [USERDEFAULTS setObject:[[[jsondict objectForKey:@"contactInfo"] objectAtIndex:1] objectForKey:@"value"] forKey:@"MerchantMobileNo"];
              
              
    self.emailnameLbl.text = [NSString stringWithFormat:@"%@",[[[jsondict objectForKey:@"contactInfo"]objectAtIndex:0] objectForKey:@"name"]];
    self.EmailvalueLbl.text = [NSString stringWithFormat:@"%@",[[[jsondict objectForKey:@"contactInfo"]objectAtIndex:0] objectForKey:@"value"]];
              
    [USERDEFAULTS setObject:[[[jsondict objectForKey:@"contactInfo"] objectAtIndex:0] objectForKey:@"value"] forKey:@"MerchantEmailId"];
              
              
              
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



- (IBAction)EmailBtn_Tapped:(id)sender
{

    [self emailImage];
}


- (void)emailImage
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
    
        mailpicker = [[MFMailComposeViewController alloc] init];
        if ([MFMailComposeViewController canSendMail]) {
            mailpicker.mailComposeDelegate = self;
            NSString * str = [NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:@"MerchantEmailId"]];
            [mailpicker setToRecipients:@[str]];
            
            [mailpicker setSubject:@"Feedback!"];
            
            [mailpicker setSubject:@""];
            [self presentViewController:mailpicker animated:YES completion:NULL];
        }
        
        
    });
}
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultSent:
            //@"You sent the email.");
        {
            
        }
            break;
        case MFMailComposeResultSaved:
            //@"You saved a draft of this email");
            break;
        case MFMailComposeResultCancelled:
            //@"You cancelled sending this email.");
            break;
        case MFMailComposeResultFailed:
            //@"Mail failed:  An error occurred when trying to compose this email");
            break;
        default:
            //@"An error occurred when trying to compose this email");
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (IBAction)MbleBtn_Tapped:(id)sender
{

    NSString *Number = [NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:@"MerchantMobileNo"]];
    
    
    if ([[Utilities null_ValidationString:Number] isEqualToString:@""])
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Failed!" message:@"Device not supporting to call" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        
        
    }
    else
    {
        NSString *phoneNumber = [@"tel://" stringByAppendingString:[NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:@"MerchantMobileNo"]]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
        
    }

}
@end
