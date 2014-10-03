//
//  DatabaseController.h
//  iBeacons
//
//  Created by Leo van der Zee on 02-10-14.
//  Copyright (c) 2014 Move4Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DatabaseController : NSObject

-(id) initDatabaseWithTables:(NSArray*) createTableQueries;
-(void) addColumnIfNotExists:(NSString*)columnName type:(NSString*)type toTable:(NSString*)tableName;

@property (nonatomic) sqlite3* database;


@end
