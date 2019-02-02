//
//  user_AddressViewCell.m
//  Shopality
//
//  Created by PossibillionTech on 5/4/17.
//  Copyright © 2017 PossibillionTech. All rights reserved.
//

#import "user_AddressViewCell.h"
#import "Utilities.h"
#import "Constants.h"


@interface user_AddressViewCell() {
    int itemCount;
}

@end

@implementation user_AddressViewCell
@synthesize nameLabel,lblphno,lbltitle,lbladdress,mainImage,btnEditButton,btnDelete,bgview,imgHome;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;


//    [Utilities setBorderBtn:decrementButton :2 :GrayColor];
//    [Utilities setBorderBtn:incrementButton :2 :GrayColor];

  

    
    // Initialization code
}



@end
