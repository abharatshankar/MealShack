//
//  CartModel.h
//  ShappalityApp
//
//  Created by Possibillion on 08/06/17.
//  Copyright © 2017 possibilliontech. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreData/CoreData.h>

@interface CartModel : NSManagedObject


@property (nonatomic, retain) NSString *restaruantId;
@property (nonatomic, retain) NSString *categoryId;
@property (nonatomic, retain) NSString *itemId;
@property (nonatomic, retain) NSString *itemName;
@property (nonatomic, retain) NSString *itemPrice;
@property (nonatomic, retain) NSString *itemQuantity;
@property (nonatomic, retain) NSString *variant;

@end
