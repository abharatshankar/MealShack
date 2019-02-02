//
//  user_AddressViewCell.h
//  Shopality
//
//  Created by PossibillionTech on 5/4/17.
//  Copyright © 2017 PossibillionTech. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface user_AddressViewCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UIImageView *mainImage;
@property (strong, nonatomic) IBOutlet UIImageView *imgHome;


@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *lbladdress;
@property (strong, nonatomic) IBOutlet UILabel *lblphno,*lbltitle;
@property (strong, nonatomic) IBOutlet UIImageView *tickImageView;
@property (strong, nonatomic) IBOutlet UIView *bgview;
@property (strong, nonatomic) IBOutlet UILabel *placeLabel;




@property (weak, nonatomic) IBOutlet UIButton *btnEditButton;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;



@end
