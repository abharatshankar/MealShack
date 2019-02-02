//
//  Pop.m
//  MealShack
//
//  Created by Prasad on 09/10/17.
//  Copyright © 2017 Possibillion. All rights reserved.
//

#import "Pop.h"
#import "SingleTon.h"
#import "RestaurantsMenuViewController.h"


@interface Pop ()
{
    SingleTon * singleTonInstance;
    
}
@end

@implementation Pop

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    singleTonInstance = [SingleTon singleTonMethod];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5,190,225)];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorColor = [UIColor grayColor];
    [self.view addSubview:tableView];
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *sectionName;
    if (section == 0)
        sectionName = @"";
    
//    if (section == 1)
//        sectionName = @"Section 1";
    
    return sectionName;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numOfRows = 0;
    numOfRows = section == 0 ? 15 : 10; //if else single line condition
    NSLog(@"---%@---",singleTonInstance.CategorynamesArray);
    NSLog(@"count is %lu",(unsigned long)singleTonInstance.CategorynamesArray.count);
    return singleTonInstance.CategorynamesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *MyIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:MyIdentifier] ;
    }
    @try {
        cell.textLabel.text = [singleTonInstance.CategorynamesArray objectAtIndex:indexPath.row];
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.textColor = [UIColor blackColor];
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"DidselectRowAtIndexPath method called");
    
    NSDictionary* dict = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:indexPath.row]forKey:@"index"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CategorySelected" object:dict];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
