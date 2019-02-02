//
//  SlideMenuTableViewCell.m
//  JagabambaProject
//
//  Created by D. MADHU KIRAN RAJU on 10/07/14.
//  Copyright (c) 2014 D. MADHU KIRAN RAJU. All rights reserved.
//

#import "SlideMenuTableViewCell.h"

@implementation SlideMenuTableViewCell
@synthesize iconImage,imgLine;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
         iconImage = [[UIImageView alloc] init];
        [self.contentView addSubview:iconImage];
        [iconImage setFrame:CGRectMake(10, 10, 21, 21)];//Nani ///change icon size g3
        
        imgLine = [[UIImageView alloc] init];
        [self.contentView addSubview:imgLine];
        [imgLine setFrame:CGRectMake(0, 35, 200, 2)];//Nani
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(10,5,50,50);
    self.textLabel.frame = CGRectMake(50, 10, 200, 20);   //change this to your needed
}
@end
