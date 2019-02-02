//
//  SideMenuViewController.h
//  SportAlbums
//
//  Created by POSSIBILLION on 17/01/14.
//  Copyright (c) 2014 POSSIBILLION. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonClassViewController.h"

@interface SideMenuViewController : CommonClassViewController <UITableViewDelegate, UITableViewDataSource,UIAlertViewDelegate>
{
    IBOutlet UILabel *lblname,*lblemail;
    IBOutlet  UITableView *tblMenu;
    IBOutlet UIImageView *profilepic;
    NSArray *arrMenu, *arrImages;
    NSArray *arrImagesRed;
    NSManagedObjectContext* managedobjectcontext;
    NSString *struser;
   
    IBOutlet UIButton *Logout;

    IBOutlet UIImageView *ProfileImg;
}

@end
