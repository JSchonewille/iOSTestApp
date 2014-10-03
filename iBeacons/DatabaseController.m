//
//  DatabaseController.m
//  iBeacons
//
//  Created by Leo van der Zee on 02-10-14.
//  Copyright (c) 2014 Move4Mobile. All rights reserved.
//

#import "DatabaseController.h"
#import <sqlite3.h>

@interface DatabaseController () {
    
}

@end

@implementation DatabaseController

@synthesize database;

-(id) initDatabaseWithTables:(NSArray*) createTableQueries {
    
    self = [super init];
    if (self) {
        database = nil;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        NSString *sqlitePath = [documentsDirectory stringByAppendingPathComponent:@"beacons.sqlite"];
        NSLog(@"database path %@", sqlitePath);
        
        if (![fileManager fileExistsAtPath:sqlitePath]){
            if(![fileManager createFileAtPath:sqlitePath contents:nil attributes:nil]){
                NSLog(@"[ERROR] SQLITE Database failed to initialize! File could not be created in application.");
            } else {
                if(sqlite3_open([sqlitePath UTF8String], &database) == SQLITE_OK) {
                    if (createTableQueries != nil) {
                        for (NSString* query in createTableQueries) {
                            sqlite3_exec(database, [query UTF8String], NULL, NULL, NULL);
                            NSLog(@"Table created with query: %@", query);
                        }
                    }
                    sqlite3_close(database);
                    database = nil;
                } else {
                    NSLog(@"[ERROR] SQLITE Could not seed tables!");
                }
                
            }
        } else {
            NSLog(@"SQLITE: Database already exists");
            
            
        }
        sqlite3_open([sqlitePath UTF8String], &database);
    }
    return self;
}

-(void) addColumnIfNotExists:(NSString*)columnName type:(NSString*)type toTable:(NSString*)tableName {
    if (![self columnExists:columnName inTable:tableName]) {
        NSString* query = [NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN %@ %@", tableName, columnName, type];
        int result = sqlite3_exec(self.database, [query UTF8String], NULL, NULL, NULL);
        if (result == SQLITE_DONE || result == SQLITE_OK) {
            NSLog(@"[SUCCESS] Added %@ to %@", columnName, tableName);
        } else {
            NSLog(@"[ERROR] Failed adding %@ to %@", columnName, tableName);
        }
    } else {
        NSLog(@"[SUCCESS] %@ is already in %@", columnName, tableName);
    }
}

-(BOOL) columnExists:(NSString*)columnName inTable:(NSString*)tableName {
    sqlite3_stmt* statement;
    
    NSString* selectString = [NSString stringWithFormat:@"SELECT %@ FROM %@", columnName, tableName];
    
    return sqlite3_prepare_v2(self.database, [selectString UTF8String], -1, &statement, NULL) == SQLITE_OK;
}

-(void) addIntegerColumn:(NSString*) columnName toTable:(NSString*) tableName withDefaultValue:(NSInteger) defaultValue {
    NSString* query = [NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN %@ INTEGER DEFAULT %d", tableName, columnName, defaultValue];
    
    int result = sqlite3_exec(database, [query UTF8String], NULL, NULL, NULL);
    if (result != SQLITE_DONE && result != SQLITE_OK) {
        NSLog(@"[ERROR] SQLITE Error: '%s'", sqlite3_errmsg(database));
    } else {
        NSLog(@"[DONE] SQLITE");
    }
}


@end