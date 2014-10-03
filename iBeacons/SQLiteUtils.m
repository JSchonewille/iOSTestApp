//
//  SQLiteUtils.m
//  iBeacons
//
//  Created by Leo van der Zee on 02-10-14.
//  Copyright (c) 2014 Move4Mobile. All rights reserved.
//

#import "SQLiteUtils.h"

@implementation SQLiteUtils


+(void) sqlite3_bind_string:(sqlite3_stmt*) statement index:(NSInteger)index value:(NSString*) value {
    const char* sqlValue = NULL;
    if (value != nil && value != (id)[NSNull null]) {
        sqlValue = [value UTF8String];
    }
    sqlite3_bind_text(statement, index, sqlValue, -1, SQLITE_TRANSIENT);
}

+(NSString*) sqlite3_column_string:(sqlite3_stmt*) statement index:(NSInteger)index {
    NSString* value = nil;
    char* charValue = (char*) sqlite3_column_text(statement, index);
    if (charValue != NULL) {
        value = [[NSString alloc] initWithUTF8String:charValue];
    }
    return value;
}

+(NSNumber*) sqlite3_column_nsnumber_int:(sqlite3_stmt*) statement index:(NSInteger) index {
    NSNumber* value = [NSNumber numberWithInt:sqlite3_column_int(statement, index)];
    return value;
}

+(NSNumber*) sqlite3_column_nsnumber_double:(sqlite3_stmt*) statement index:(NSInteger) index {
    NSNumber* value = [NSNumber numberWithDouble:sqlite3_column_double(statement, index)];
    return value;
}

+(Boolean) sqlite3_column_boolean:(sqlite3_stmt*) statement index:(NSInteger) index {
    NSNumber* value = [NSNumber numberWithDouble:sqlite3_column_double(statement, index)];
    return value == nil ? NO : value.boolValue;
}

+(Boolean) sqlite3_check_result:(int) result inDb:(sqlite3*) db withMessage:(NSString*) msg {
    Boolean success = NO;
    if (result != SQLITE_DONE && result != SQLITE_OK) {
        NSLog(@"[ERROR] SQLITE: %@ Error: '%s'", msg, sqlite3_errmsg(db));
    } else {
        NSLog(@"[DONE] SQLITE: %@", msg);
        success = YES;
    }
    return success;
}


@end