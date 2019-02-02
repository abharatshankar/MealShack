//
//  Person.h
//  Closrr
//
//  Created by POSSIBILLION on 02/01/15.
//  Copyright (c) 2015 D. MADHU KIRAN RAJU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



@interface Person : NSObject

@property(nonatomic, readwrite) NSString *firstName;
@property(nonatomic, readwrite) NSString *lastName;
@property(nonatomic, readwrite) NSArray *phoneNumbers;
@property(nonatomic, readwrite) NSArray *emails;
@property(nonatomic, readwrite) UIImage *photo;

- (void)initWithModel:(NSDictionary* )data;

@end
