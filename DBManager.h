//
//  DBManager.h
//  ShappalityApp
//
//  Created by Possibillion on 14/06/17.
//  Copyright © 2017 possibilliontech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBManager : NSObject
{
    NSString *databasePath;
}

+(DBManager*)getSharedInstance;
-(BOOL)createDB;
- (BOOL)saveData:(NSDictionary *)itemdict itemcount:(NSString*)itemQty variant:(NSString*)variantPrice;

-(NSArray*) finddata;

@end
