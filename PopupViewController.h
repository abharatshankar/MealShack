//
//  PopupViewController.h
//  Jobaap
//
//  Created by POSSIBILLION on 25/08/15.
//  Copyright (c) 2015 Possibillion. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PopOverViewControllerDelegate;

@interface PopupViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *popoverTableView;
@property (strong, nonatomic) NSString *headingString,*dealClassIts,*isSecretCode;
@property (strong, nonatomic) NSArray *popoverTableData,*totalArr;
@property(weak,nonatomic) id <PopOverViewControllerDelegate> delegate;

@end
/*!
 @abstract      property
 @param         string
 @discussion    PopOverViewController Delegate
 @return        object
 */

@protocol PopOverViewControllerDelegate <NSObject>

@required
-(void)selectedField:(NSString*)fieldName;
@optional
-(void)cancelPopover;

@end
