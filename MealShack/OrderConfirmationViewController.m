//
//  OrderConfirmationViewController.m
//  MealShack
//
//  Created by Prasad on 11/08/17.
//  Copyright © 2017 Possibillion. All rights reserved.
//

#import "OrderConfirmationViewController.h"
#import "ServiceManager.h"
#import "Utilities.h"
#import "Constants.h"
#import "TrackOrderViewController.h"
#import "ReviewOrderCell.h"
#import "RestaurantsViewController.h"

@interface OrderConfirmationViewController ()<ServiceHandlerDelegate>
{
    
    NSDictionary *requestDict;
    IBOutlet UIView *borderview;
    NSMutableArray *totalItemsArray;
    
}

@end

@implementation OrderConfirmationViewController
@synthesize totaldict;
- (void)viewDidLoad {
    [super viewDidLoad];
   self.navigationController.navigationBar.hidden = YES;
    
//    CGRect contentRect = CGRectZero;
//    for (UIView *view in  _BackScroll.subviews) {
//        contentRect = CGRectUnion(contentRect, view.frame);
//    }
//    _BackScroll.contentSize = contentRect.size;
    
    
     self.BackScroll.contentSize = CGSizeMake(self.view.frame.size.width-50, self.view.frame.size.height);

  // [self.BackScroll setFrame:CGRectMake(borderview.frame.origin.x, borderview.frame.origin.y+borderview.frame.size.height, borderview.frame.size.width,385)];
    
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
    
    
    totalItemsArray = [[NSMutableArray alloc]init];
    totalItemsArray = [[[totaldict valueForKey:@"order_info"] valueForKey:@"order_items"] objectAtIndex:0];
  _restaurantNameLbl.text =  [[[totaldict valueForKey:@"order_info"] valueForKey:@"name"] objectAtIndex:0];
    
    [tblItems reloadData];
    
   // _StrTotal.text=[[[totaldict valueForKey:@"order_info"] valueForKey:@"grand_total"] objectAtIndex:0];
    
    self.StrTotal.text = [USERDEFAULTS valueForKey:@"grandTotal"];
    
   _AddressLabel.text = [NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:@"deliveryaddress"]];
   [Utilities addShadowtoView:borderview];
    
    
    
//    [borderview setFrame:CGRectMake(_BackScroll.frame.origin.x,_BackScroll.frame.origin.y+ _BackScroll.frame.size.height+5, self.view.frame.size.width, self.view.frame.size.height)];
//    
    
    tblItems.frame = CGRectMake(self.view.frame.origin.x, self.restaurantNameLbl.frame.origin.y+self.restaurantNameLbl.frame.size.height, borderview.frame.size.width,totalItemsArray.count*59);
    
  [self.Bgview setFrame:CGRectMake(self.view.frame.origin.x,tblItems.frame.origin.y+ tblItems.frame.size.height+5, borderview.frame.size.width, 126)];
    
    
 }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
     self.navigationController.navigationBar.hidden = YES;
}


-(void)viewWillDisappear:(BOOL)animated
{
    //self.navigationController.navigationBar.hidden = NO;
    [self.navigationController.navigationBar setHidden:NO];
}



////Table view method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int value;
   
        value = [totalItemsArray count];
    
    return value;
    
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return 59;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell...
    
    static NSString *CellIdentifier = @"ReviewOrderCell";
    
        ReviewOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[ReviewOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        }
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        NSLog(@"cellForRowAtIndexPath");
    
        NSDictionary  *dict = [totalItemsArray  objectAtIndex:indexPath.row];
        
       NSString *strprice = [NSString stringWithFormat:@"%@", [Utilities null_ValidationString:[dict valueForKey:@"price"]]];
       NSString *strname = [NSString stringWithFormat:@"%@",[Utilities null_ValidationString:[dict valueForKey:@"item_name"]]];
       NSString* strqty = [NSString stringWithFormat:@"%@",[Utilities null_ValidationString:[dict valueForKey:@"quantity"]]];
        
        
        //    [Utilities setBorderView:cell.bgview :5 :LIGHTGRYCOLOR];
        [Utilities setBorderView:cell.lineView :0 :LIGHTGRYCOLOR];
          cell.lineView.hidden = YES;
    
        [cell.IncrementButton addTarget:self action:@selector(increaseLabelCount:) forControlEvents:UIControlEventTouchUpInside];
        [cell.decrementButton addTarget:self action:@selector(decreaseLabelCount:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        cell.IncrementButton.tag=indexPath.row;
        cell.decrementButton.tag=indexPath.row;
        
        cell.itemNameLbl.text = strname;// capitalizedString];
        cell.itemPriceLbl.text  =  strprice;
    
       cell.lblqty.text = [NSString stringWithFormat:@"%@", [Utilities null_ValidationString:[dict valueForKey:@"quantity"]]];
        return cell;
    
    
    
    
}


- (IBAction)TrackOrderButton_Clicked:(id)sender
{
    TrackOrderViewController * track = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"TrackOrderViewController"];
    track.strOrderID = [[[totaldict valueForKey:@"order_info"] valueForKey:@"order_id"] objectAtIndex:0];
    track.stritemcount = [NSString stringWithFormat:@"%d",[totalItemsArray count]];
    [self.navigationController pushViewController:track animated:YES];
}

- (IBAction)Back_Click:(id)sender
{
    
    for (UIViewController *controller in self.navigationController.viewControllers)
    {
        if ([controller isKindOfClass:[RestaurantsViewController class]])
        {
            [self.navigationController popToViewController:controller animated:YES];
            
            break;
        }
    }
    
    //[self.navigationController popToRootViewControllerAnimated:YES];
}
@end
