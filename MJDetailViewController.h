//
//  MJDetailViewController.h
//  MJPopupViewControllerDemo
//
//  Created by Martin Juhasz on 24.06.12.
//  Copyright (c) 2012 martinjuhasz.de. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSString *commontime;
    int t;
    NSMutableArray *arr;
}
//@property (weak, nonatomic) IBOutlet UIDatePicker *picker;
-(NSString *)Responsemethod:(NSMutableArray *)Selectedarr ;

@property (weak, nonatomic) IBOutlet UITableView *Tableview;
@property (nonatomic,assign) BOOL verification;
@property (weak, nonatomic) IBOutlet UILabel *Title;
@property (nonatomic,assign) NSString *titleDynamicStr;

@end
