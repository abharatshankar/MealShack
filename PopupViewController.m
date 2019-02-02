//
//  PopupViewController.m
//  Jobaap
//
//  Created by POSSIBILLION on 25/08/15.
//  Copyright (c) 2015 Possibillion. All rights reserved.
//

#import "PopupViewController.h"
#import "Constants.h"
@interface PopupViewController ()
@property (strong, nonatomic) IBOutlet UILabel *headingLabel;

@end

@implementation PopupViewController
@synthesize headingString,popoverTableView,headingLabel,popoverTableData,totalArr,dealClassIts,isSecretCode;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    headingLabel.text = headingString;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
}

#pragma mark - TableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    popoverVC.dealClassIts = @"customDeal";
    
  
        if([dealClassIts isEqualToString:@"customDeal"]) {
            if([popoverTableData count]==1)
            {
                if([[popoverTableData objectAtIndex:0]isEqualToString:@"Other"])
                    return [popoverTableData count];
            }
            else {
                return [popoverTableData count];
            }
        }

    
    
           return [popoverTableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    cell.textLabel.font = [UIFont fontWithName:PROXIMANOVAREGULAR size:15.0f];
    
    
   
        if([headingString isEqualToString:@"MarkAs"])
        {
            cell.textLabel.text = [popoverTableData objectAtIndex:indexPath.row];
           // NSLog(@"=============%@==========",cell.textLabel.text);
            
            
        }
        else if([headingString isEqualToString:@"Times"])
        {
            cell.textLabel.text = [[popoverTableData objectAtIndex:indexPath.row] valueForKey:@"timeSlots"];
            
        }
        else{
            cell.textLabel.text = [popoverTableData objectAtIndex:indexPath.row];
            
        }
    
    return cell;
}

#pragma mark - TableView Delegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Data = %@",popoverTableData);
    NSLog(@"count = %lu %ld",(unsigned long)popoverTableData.count+1  , (long)indexPath.row);
     if([headingString isEqualToString:@"Times"])
    {
        
        [self.view endEditing:YES];
        [self.delegate selectedField:[[popoverTableData objectAtIndex:indexPath.row] valueForKey:@"timeSlots"]];
    }
   else if([headingString isEqualToString:@"MarkAs"])
    {
        [USERDEFAULTS setObject:[popoverTableData objectAtIndex:indexPath.row] forKey:@"TableTitle"];
        [self.delegate selectedField:[popoverTableData objectAtIndex:indexPath.row] ];

    }
     else{
    
    
        if([self.delegate respondsToSelector:@selector(selectedField:)])
        {
            [self.view endEditing:YES];
            [self.delegate selectedField:[popoverTableData objectAtIndex:indexPath.row]];
        }
    
     }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
