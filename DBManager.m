//
//  DBManager.m
//  ShappalityApp
//
//  Created by Possibillion on 14/06/17.
//  Copyright © 2017 possibilliontech. All rights reserved.
//

#import "DBManager.h"

static DBManager *sharedInstance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;

@implementation DBManager

+(DBManager*)getSharedInstance{
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL]init];
        [sharedInstance createDB];
    }
    return sharedInstance;
}

-(BOOL)createDB{
    NSString *docsDir;
    NSArray *dirPaths;
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString:
                    [docsDir stringByAppendingPathComponent: @"cartdata.db"]];
    BOOL isSuccess = YES;
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath: databasePath ] == NO)
    {
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &database) == SQLITE_OK)
        {
            
            char *errMsg;
            const char *sql_stmt =
            "create table if not exists cartDetail (restaruantId text, categoryId text, itemId text,itemName text, itemPrice text, itemQuantity text)";
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to create table");
            }
            sqlite3_close(database);
            return  isSuccess;
        }
        else {
            isSuccess = NO;
            NSLog(@"Failed to open/create database");
        }
    }
    return isSuccess;
}

- (BOOL)saveData:(NSDictionary *)itemdict itemcount:(NSString*)itemQty variant:(NSString*)variantPrice;
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
      NSString *  restaruantId = [NSString stringWithFormat:@"%@",[itemdict valueForKey:@"establishment_id"]];
        NSString *  categoryId = [NSString stringWithFormat:@"%@",[itemdict valueForKey:@"item_category_id"]];
        NSString *  itemId = [NSString stringWithFormat:@"%@",[itemdict valueForKey:@"items_id"]];
        NSString *  itemName = [NSString stringWithFormat:@"%@",[itemdict valueForKey:@"item_name"]];
        NSString *  itemPrice = [NSString stringWithFormat:@"%@",[itemdict valueForKey:@"price"]];
        NSString *  itemQuantity = [NSString stringWithFormat:@"%@",itemQty];
       // NSString *  variant = [NSString stringWithFormat:@"%@",variantPrice];

        
        
        NSString *insertSQL = [NSString stringWithFormat:
                               @"insert into cartDetail (restaruantId , categoryId , itemId ,itemName , itemPrice , itemQuantity) values (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\")",
                               restaruantId , categoryId , itemId ,itemName , itemPrice , itemQuantity];
                                const char *insert_stmt = [insertSQL UTF8String];
                                sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
                                if (sqlite3_step(statement) == SQLITE_DONE)
                                {
                                    return YES;
                                }
                                else
                                {
                                    return NO;
                                }
                                sqlite3_reset(statement);
                                }
                                return NO;
                                }
                                
-(NSArray*) finddata
        {
            const char *dbpath = [databasePath UTF8String];
            if (sqlite3_open(dbpath, &database) == SQLITE_OK)
            {
                NSString *querySQL = [NSString stringWithFormat:
                                       @"select * from cartDetail"];
                
                
              
                const char *query_stmt = [querySQL UTF8String];
                NSMutableArray *resultArray = [[NSMutableArray alloc]init];
                if (sqlite3_prepare_v2(database,
                                       query_stmt, -1, &statement, NULL) == SQLITE_OK)
                {
                    if (sqlite3_step(statement) == SQLITE_ROW)
                    {
                        NSString *restaruantId = [[NSString alloc] initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 0)];
                        [resultArray addObject:restaruantId];
                        NSString *categoryId = [[NSString alloc] initWithUTF8String:
                                                (const char *) sqlite3_column_text(statement, 1)];
                        [resultArray addObject:categoryId];
                        NSString *itemId = [[NSString alloc]initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 2)];
                        [resultArray addObject:itemId];
                        
                        NSString *itemName = [[NSString alloc]initWithUTF8String:
                                            (const char *) sqlite3_column_text(statement, 3)];
                        [resultArray addObject:itemName];
                        
                        NSString *itemPrice = [[NSString alloc]initWithUTF8String:
                                            (const char *) sqlite3_column_text(statement, 4)];
                        [resultArray addObject:itemPrice];
                        
                        NSString *itemQuantity = [[NSString alloc]initWithUTF8String:
                                            (const char *) sqlite3_column_text(statement, 5)];
                        [resultArray addObject:itemQuantity];
                        
     
                        NSLog(@"total data :%@", resultArray);

                        return resultArray;
                    }
                    else{
                        NSLog(@"Not found");
                        return nil;
                    }
                    sqlite3_reset(statement);
                }
            }
            return nil;
        }
@end
