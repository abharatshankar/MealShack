//
//  MJDetailViewController.m
//  MJPopupViewControllerDemo
//
//  Created by Martin Juhasz on 24.06.12.
//  Copyright (c) 2012 martinjuhasz.de. All rights reserved.
//

#import "MJDetailViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import "Constants.h"

@implementation MJDetailViewController
@synthesize verification,Title,titleDynamicStr;

//- (IBAction)picker:(id)sender {
//   
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        
//        [dateFormatter setDateFormat:@"HH:mm"];
//        
//        NSString *formatedDate = [dateFormatter stringFromDate:self.datePicker.date];
//        
//        // self.selectedDate.text =formatedDate;
//       // _txtdate.text=formatedDate;
//    NSLog(@"%@",formatedDate);
//}


- (void)viewDidLoad
{
    [super viewDidLoad];
   // Title.text = titleDynamicStr;
   
}
-(NSString *)Responsemethod:(NSMutableArray *)Selectedarr
{
     arr = [[NSMutableArray alloc]init];
    [arr addObjectsFromArray:Selectedarr];
    
    
    [_Tableview reloadData];
    return nil;
    
    if(IS_IPHONE_4)
    {
                
    }
    else if(IS_IPHONE_5 || IS_ZOOMED_IPHONE_6)
    {
        _Tableview.frame = CGRectMake(0, 0, 320, 300);
        
    }
    else if(IS_STANDARD_IPHONE_6 || IS_ZOOMED_IPHONE_6_PLUS)
    {
        
        
    }
    else if( IS_STANDARD_IPHONE_6_PLUS)
    {
        
    }

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [arr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"CustomCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [[arr objectAtIndex:indexPath.row] valueForKey:@"desc"];
    
    cell.textLabel.font = [UIFont systemFontOfSize:13.0];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TestNotification" object:[NSString stringWithFormat:@"%ld",(long)indexPath.row] ];
}

@end
