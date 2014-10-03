//
//  SQLiteUtils.h
//  iBeacons
//
//  Created by Leo van der Zee on 02-10-14.
//  Copyright (c) 2014 Move4Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface SQLiteUtils : NSObject

+(void) sqlite3_bind_string:(sqlite3_stmt*) statement index:(NSInteger)index value:(NSString*) value ;
+(NSString*) sqlite3_column_string:(sqlite3_stmt*) statement index:(NSInteger)index;
+(NSNumber*) sqlite3_column_nsnumber_int:(sqlite3_stmt*) statement index:(NSInteger) index;
+(NSNumber*) sqlite3_column_nsnumber_double:(sqlite3_stmt*) statement index:(NSInteger) index;
+(Boolean) sqlite3_column_boolean:(sqlite3_stmt*) statement index:(NSInteger) index;

+(Boolean) sqlite3_check_result:(int) result inDb:(sqlite3*) db withMessage:(NSString*) msg;


@end