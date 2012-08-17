//
//  DBManager.m
//  WhackAVC
//
//  Created by Antiz Technologies on 3/15/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import "DBManager.h"

@implementation DBManager

extern NSString *_angelUserId;
extern NSString *_angelUserName;
extern NSString *access_token;

NSString *_angelUserIdFromDB;
NSString *_angelUserNameFromDB;
NSString *access_tokenFromDB;
NSString *_angelUserFollowsFromDB;
NSString *_angelUserImageFromDB;
NSString *_angelUserEmailFromDB;


@synthesize feedImagesArrayFromDirectoryFromDB;
@synthesize actorTypeArrayFromDB;
@synthesize actorIdArrayFromDB;
@synthesize actorNameArrayFromDB;
@synthesize actorUrlArrayFromDB;
@synthesize actorTaglineArrayFromDB;
@synthesize feedDescDisplayArrayFromDB;
@synthesize feedImageArrayFromDB;
@synthesize startUpIdsArrayFromDB;
@synthesize startUpNameArrayFromDB;
@synthesize startUpAngelUrlArrayFromDB;
@synthesize startUpLogoUrlArrayFromDB;
@synthesize startUpProductDescArrayFromDB;
@synthesize startUpHighConceptArrayFromDB;
@synthesize startUpFollowerCountArrayFromDB;
@synthesize startUpLocationArrayFromDB;
@synthesize startUpMarketArrayFromDB;
@synthesize startUpLogoImageInDirectoryFromDB;
@synthesize inboxTotalFromDB;
@synthesize inboxViewedFromDB;
@synthesize inboxThreadIdFromDB;
@synthesize _angelUserEmailFromDB, _angelUserIdFromDB, _angelUserNameFromDB, _angelUserImageFromDB, _angelUserFollowsFromDB,access_tokenFromDB, userDetailsArray, targetTaglineArrayFromDB, targetNameArrayFromDB, targetImageArrayFromDB, targetIdArrayFromDB, targetTypeArrayFromDB, targetUrlArrayFromDB,feedTypeArrayFromDB;

///To check filePath
-(NSString *) filePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:@"angellistdb.sqlite"];
}

-(void) openDB {
    //---create database---
    if (sqlite3_open([[self filePath] UTF8String], &db) != SQLITE_OK ) {
        sqlite3_close(db);
        NSAssert(0, @"Database failed to open."); 
    }
    
}

//Table for MetaData
-(void) createTableUser:(NSString *) tableName withField1:(NSString *) field1 withField2:(NSString *) field2 withField3:(NSString *) field3 withField4:(NSString *)field4 withField5:(NSString *)field5 withField6:(NSString *)field6 withField7:(NSString *)field7
{
    char *err;
    NSString *sql = [NSString stringWithFormat:
                     @"CREATE TABLE IF NOT EXISTS '%@' ('%@' TEXT PRIMARY KEY, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT);", tableName, field1, field2, field3, field4,field5,field6,field7];
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) 
    { 
        sqlite3_close(db);
        NSAssert(0, @"Table User failed to create.");
    }
}

// create table for feeds
-(void) createTableActivity:(NSString *)tableName withField1:(NSString *)field1 withField2:(NSString *)field2 withField3:(NSString *)field3 withField4:(NSString *)field4 withField5:(NSString *)field5 withField6:(NSString *)field6 withField7:(NSString *)field7 withField8:(NSString *)field8 withField9:(NSString *)field9 withField10:(NSString *)field10 withField11:(NSString *)field11 withField12:(NSString *)field12 withField13:(NSString *)field13 withField14:(NSString *)field14 withField15:(NSString *)field15 withField16:(NSString *)field16
{
    char *err;
    NSString *sql = [NSString stringWithFormat:
                     @"CREATE TABLE IF NOT EXISTS '%@' ('%@' TEXT PRIMARY KEY, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT);", tableName, field1, field2, field3, field4, field5, field6, field7, field8, field9 , field10 , field11, field12 , field13 , field14, field15, field16];
    
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) 
    { 
        sqlite3_close(db);
        NSAssert(0, @"Table User failed to create.");
    }
}

// create table for startups
-(void) createTableStartUps:(NSString *)tableName withField1:(NSString *)field1 withField2:(NSString *)field2 withField3:(NSString *)field3 withField4:(NSString *)field4 withField5:(NSString *)field5 withField6:(NSString *)field6 withField7:(NSString *)field7 withField8:(NSString *)field8 withField9:(NSString *)field9 withField10:(NSString *)field10 withField11:(NSString *)field11
{
    char *err;
    NSString *sql = [NSString stringWithFormat:
                     @"CREATE TABLE IF NOT EXISTS '%@' ('%@' TEXT PRIMARY KEY, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT)", tableName, field1, field2, field3, field4, field5, field6, field7, field8, field9, field10, field11];
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) 
    { 
        sqlite3_close(db);
        NSAssert(0, @"Table StartUps failed to create.");
    }
}

// create table for following startups
-(void) createTableStartUpsFollowing:(NSString *)tableName withField1:(NSString *)field1 withField2:(NSString *)field2 withField3:(NSString *)field3 withField4:(NSString *)field4 withField5:(NSString *)field5 withField6:(NSString *)field6 withField7:(NSString *)field7 withField8:(NSString *)field8 withField9:(NSString *)field9 withField10:(NSString *)field10 withField11:(NSString *)field11
{
    char *err;
    NSString *sql = [NSString stringWithFormat:
                     @"CREATE TABLE IF NOT EXISTS '%@' ('%@' TEXT PRIMARY KEY, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT)", tableName, field1, field2, field3, field4, field5, field6, field7, field8, field9, field10, field11];
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) 
    { 
        sqlite3_close(db);
        NSAssert(0, @"Table StartUps Following failed to create.");
    }
}

// Create table startups in portfolio
-(void) createTableStartUpsPortfolio:(NSString *)tableName withField1:(NSString *)field1 withField2:(NSString *)field2 withField3:(NSString *)field3 withField4:(NSString *)field4 withField5:(NSString *)field5 withField6:(NSString *)field6 withField7:(NSString *)field7 withField8:(NSString *)field8 withField9:(NSString *)field9 withField10:(NSString *)field10 withField11:(NSString *)field11
{
    char *err;
    NSString *sql = [NSString stringWithFormat:
                     @"CREATE TABLE IF NOT EXISTS '%@' ('%@' TEXT PRIMARY KEY, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT)", tableName, field1, field2, field3, field4, field5, field6, field7, field8, field9, field10, field11];
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) 
    { 
        sqlite3_close(db);
        NSAssert(0, @"Table StartUps Portfolio failed to create.");
    }
}

// Create table startups in portfolio
-(void) createTableStartUpsTrending:(NSString *)tableName withField1:(NSString *)field1 withField2:(NSString *)field2 withField3:(NSString *)field3 withField4:(NSString *)field4 withField5:(NSString *)field5 withField6:(NSString *)field6 withField7:(NSString *)field7 withField8:(NSString *)field8 withField9:(NSString *)field9 withField10:(NSString *)field10 withField11:(NSString *)field11
{
    char *err;
    NSString *sql = [NSString stringWithFormat:
                     @"CREATE TABLE IF NOT EXISTS '%@' ('%@' TEXT PRIMARY KEY, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT)", tableName, field1, field2, field3, field4, field5, field6, field7, field8, field9, field10, field11];
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) 
    { 
        sqlite3_close(db);
        NSAssert(0, @"Table StartUps Portfolio failed to create.");
    }
}

//Table for message status
-(void) createTableInboxDetails:(NSString *)tableName withField1:(NSString *)field1 withField2:(NSString *)field2 withField3:(NSString *)field3 
{
    char *err;
    NSString *sql = [NSString stringWithFormat:
                     @"CREATE TABLE IF NOT EXISTS '%@' ('%@' TEXT PRIMARY KEY, '%@' TEXT, '%@' TEXT)", tableName, field1, field2, field3];
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) 
    { 
        sqlite3_close(db);
        NSAssert(0, @"Table Inbox failed to create.");
    }
}


//Insert Values to Inbox Table
-(void) insertRecordIntoInbox: (NSString *) tableName withField1: (NSString *) field1 field1Value: (NSString *) field1Value andField2: (NSString *) field2 field2Value: (NSString *) field2Value andField3: (NSString *) field3 field3Value: (NSString *) field3Value
{
    
    NSString *sql = [NSString stringWithFormat:
                     @"INSERT OR REPLACE INTO '%@' ('%@', '%@', '%@') VALUES ('%@','%@', '%@')", tableName, field1, field2, field3, field1Value, field2Value, field3Value];
    char *err;
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) 
    {
        sqlite3_close(db);
        NSAssert(0, @"Error Inserting to table Inbox."); 
    } 
}


// Insert record into user table 
-(void) insertRecordIntoUserTable: (NSString *) tableName withField1: (NSString *) field1 field1Value: (NSString *) field1Value andField2: (NSString *) field2 field2Value: (NSString *) field2Value andField3: (NSString *) field3 field3Value: (NSString *) field3Value andField4: (NSString *) field4 field4Value: (NSString *)field4Value andField5: (NSString *) field5 field5Value: (NSString *) field5Value andField6: (NSString *) field6 field6Value: (NSString *) field6Value andField7: (NSString *) field7 field7Value: (NSString *) field7Value
{
    NSString *sql = [NSString stringWithFormat:
                     @"INSERT OR REPLACE INTO '%@' ('%@', '%@', '%@', '%@', '%@', '%@', '%@') VALUES ('%@','%@', '%@', '%@', '%@', '%@', '%@')", tableName, field1, field2, field3, field4, field5, field6, field7, field1Value, field2Value, field3Value, field4Value, field5Value, field6Value, field7Value];
   
    char *err;
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) 
    {
        sqlite3_close(db);
        NSAssert(0, @"Error Inserting to table User."); 
    } 
}

// Update record into inbox table
-(void) updateRecordIntoInboxTable: (NSString *) tableName withField1: (NSString *) field1 field1Value: (NSString *) field1Value andField2: (NSString *) field2 field2Value: (NSString *) field2Value andField3: (NSString *) field3 field3Value: (NSString *) field3Value
{
    
    NSString *sql = [NSString stringWithFormat:
                     @"UPDATE '%@' SET %@= '%@' , %@= '%@' WHERE %@= '%@' ", tableName, field2,field2Value, field3,  field3Value,field1, field1Value];
    char *err;
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) 
    {
        sqlite3_close(db);
        NSAssert(0, @"Error Inserting to table User."); 
    } 
}

// Update status into Inbox table
-(void) updateStatusIntoInboxTable: (NSString *) tableName withField1: (NSString *) field1 field1Value: (NSString *) field1Value andField2: (NSString *) field2 field2Value: (NSString *) field2Value 
{
    NSString *sql = [NSString stringWithFormat:
                     @"UPDATE '%@' SET %@= '%@' WHERE %@= '%@' ", tableName, field1,field1Value, field2,  field2Value];
    char *err;
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) 
    {
        sqlite3_close(db);
        NSAssert(0, @"Error Inserting to table User."); 
    } 
}

// Insert record into activity table 
-(void) insertRecordIntoActivityTable:(NSString *)tableName withField1: (NSString *) field1 field1Value: (NSString *) field1Value andField2: (NSString *) field2 field2Value: (NSString *) field2Value andField3: (NSString *) field3 field3Value: (NSString *) field3Value andField4: (NSString *) field4 field4Value: (NSString *) field4Value andField5: (NSString *) field5 field5Value: (NSString *) field5Value andField6: (NSString *) field6 field6Value: (NSString *) field6Value andField7: (NSString *) field7 field7Value: (NSString *) field7Value andField8: (NSString *) field8 field8Value: (NSString *) field8Value andField9: (NSString *) field9 field9Value: (NSString *) field9Value andField10: (NSString *) field10 field10Value: (NSString *) field10Value andField11: (NSString *) field11 field11Value: (NSString *) field11Value andField12: (NSString *) field12 field12Value: (NSString *) field12Value andField13: (NSString *) field13 field13Value: (NSString *) field13Value andField14: (NSString *) field14 field14Value: (NSString *) field14Value andField15: (NSString *) field15 field15Value: (NSString *) field15Value andField16: (NSString *) field16 field16Value: (NSString *) field16Value
{
    char *err;
    NSString *sql = [NSString stringWithFormat:
                     @"INSERT OR REPLACE INTO '%@' ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@') VALUES ('%@','%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')", tableName, field1, field2, field3, field4, field5, field6, field7, field8, field9, field10, field11, field12, field13, field14, field15, field16, field1Value, field2Value, field3Value, field4Value, field5Value, field6Value, field7Value, field8Value, field9Value, field10Value , field11Value , field12Value , field13Value, field14Value , field15Value, field16Value];
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) 
    { 
        sqlite3_close(db);
        NSAssert(0, @"Error Inserting to Table Activity");
    }
}

// Insert into startup table
-(void) insertRecordIntoStartUpsTable:(NSString *)tableName field1Value:(NSString *)field1Value field2Value:(NSString *)field2Value field3Value:(NSString *)field3Value field4Value:(NSString *)field4Value field5Value:(NSString *)field5Value field6Value:(NSString *)field6Value field7Value:(NSString *)field7Value field8Value:(NSString *)field8Value field9Value:(NSString *)field9Value field10Value:(NSString *)field10Value field11Value:(NSString *)field11Value
{
    char *err;
    NSString *sql = [NSString stringWithFormat:
                     @"INSERT OR REPLACE INTO '%@' VALUES ('%@','%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')", tableName, field1Value, field2Value, field3Value, field4Value, field5Value, field6Value, field7Value, field8Value, field9Value, field10Value, field11Value];
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) 
    { 
        sqlite3_close(db);
        NSAssert(0, @"Error Inserting to Table StartUp");
    }
}

//Insert number of rows in StartUp Following table
-(void) insertRecordIntoStartUpsFollowingTable:(NSString *)tableName field1Value:(NSString *)field1Value field2Value:(NSString *)field2Value field3Value:(NSString *)field3Value field4Value:(NSString *)field4Value field5Value:(NSString *)field5Value field6Value:(NSString *)field6Value field7Value:(NSString *)field7Value field8Value:(NSString *)field8Value field9Value:(NSString *)field9Value field10Value:(NSString *)field10Value field11Value:(NSString *)field11Value
{
    char *err;
    NSString *sql = [NSString stringWithFormat:
                     @"INSERT OR REPLACE INTO '%@' VALUES ('%@','%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')", tableName, field1Value, field2Value, field3Value, field4Value, field5Value, field6Value, field7Value, field8Value, field9Value, field10Value, field11Value];
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) 
    { 
        sqlite3_close(db);
        NSAssert(0, @"Error Inserting to Table StartUps Following");
    }
}

//Insert number of rows in StartUp Portfolio table
-(void) insertRecordIntoStartUpsPortfolioTable:(NSString *)tableName field1Value:(NSString *)field1Value field2Value:(NSString *)field2Value field3Value:(NSString *)field3Value field4Value:(NSString *)field4Value field5Value:(NSString *)field5Value field6Value:(NSString *)field6Value field7Value:(NSString *)field7Value field8Value:(NSString *)field8Value field9Value:(NSString *)field9Value field10Value:(NSString *)field10Value field11Value:(NSString *)field11Value
{
    char *err;
    NSString *sql = [NSString stringWithFormat:
                     @"INSERT OR REPLACE INTO '%@' VALUES ('%@','%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')", tableName, field1Value, field2Value, field3Value, field4Value, field5Value, field6Value, field7Value, field8Value, field9Value, field10Value, field11Value];
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) 
    { 
        sqlite3_close(db);
        NSAssert(0, @"Error Inserting to Table StartUps Following");
    }
}

//Insert number of rows in StartUp Trending table
-(void) insertRecordIntoStartUpsTrendingTable:(NSString *)tableName field1Value:(NSString *)field1Value field2Value:(NSString *)field2Value field3Value:(NSString *)field3Value field4Value:(NSString *)field4Value field5Value:(NSString *)field5Value field6Value:(NSString *)field6Value field7Value:(NSString *)field7Value field8Value:(NSString *)field8Value field9Value:(NSString *)field9Value field10Value:(NSString *)field10Value field11Value:(NSString *)field11Value
{
    char *err;
    NSString *sql = [NSString stringWithFormat:
                     @"INSERT OR REPLACE INTO '%@' VALUES ('%@','%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')", tableName, field1Value, field2Value, field3Value, field4Value, field5Value, field6Value, field7Value, field8Value, field9Value, field10Value, field11Value];
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) 
    { 
        sqlite3_close(db);
        NSAssert(0, @"Error Inserting to Table StartUps Following");
    }
}

//Retrieve number of rows in User table
-(int) retrieveUserFromDB
{
    NSString *sql = @"SELECT COUNT(*) FROM User";
    int _noOfRowsInUserTable = 0;
    
    sqlite3_stmt *statement;
    
    if(sqlite3_prepare_v2(db,[sql UTF8String],-1,&statement,nil) == SQLITE_OK)
    {
        if(sqlite3_step(statement) == SQLITE_ROW)
        {
            char *field1 = (char *) sqlite3_column_text(statement,0);
            NSString *field1Str = [[NSString alloc] initWithUTF8String:field1];
            
            NSString *str = [[NSString alloc] initWithFormat:@"%@", field1Str];
            _noOfRowsInUserTable = [str intValue];
            
            [field1Str release];
            [str release];
        }
        sqlite3_finalize(statement);
    }
    return _noOfRowsInUserTable;
}

//Delete User from database
-(void) deleteUserFromDB
{
    NSString *ssql = @"DELETE FROM User";
    char *err;
    if (sqlite3_exec(db, [ssql UTF8String], NULL, NULL, &err) != SQLITE_OK) 
    {
        sqlite3_close(db);
        NSAssert(0, @"Error deleting table."); 
    }     
}


//Retrieve inbox details
-(void) retrieveInboxDetails
{
    [inboxThreadIdFromDB removeAllObjects];
    [inboxTotalFromDB removeAllObjects];
    [inboxViewedFromDB removeAllObjects];
    
    NSString *sql = @"SELECT * FROM Inbox";
    
    sqlite3_stmt *statement;
    
    if(sqlite3_prepare_v2(db,[sql UTF8String],-1,&statement,nil) == SQLITE_OK)
    {
        while(sqlite3_step(statement) == SQLITE_ROW)
        {
            char *field1 = (char *) sqlite3_column_text(statement,0);
            NSString *field1Str = [[NSString alloc] initWithUTF8String:field1];
            NSString *str1 = [[NSString alloc] initWithFormat:@"%@", field1Str];
            [inboxThreadIdFromDB addObject:str1];
            
            char *field2 = (char *) sqlite3_column_text(statement,1);
            NSString *field2Str = [[NSString alloc] initWithUTF8String:field2];
            NSString *str2 = [[NSString alloc] initWithFormat:@"%@", field2Str];
            [inboxTotalFromDB addObject:str2];
            
            char *field3 = (char *) sqlite3_column_text(statement,2);
            NSString *field3Str = [[NSString alloc] initWithUTF8String:field3];
            NSString *str3 = [[NSString alloc] initWithFormat:@"%@", field3Str];
            [inboxViewedFromDB addObject:str3];
            
            
            [field1Str release];
            [field2Str release];
            [field3Str release];
            [str1 release];
            [str2 release];
            [str3 release];
        }
        sqlite3_finalize(statement);
    }
}

//Delete rows from Inbox
-(void) deleteFromInbox
{
    NSString *ssql = @"DELETE  FROM Inbox";
    char *err;
    if (sqlite3_exec(db, [ssql UTF8String], NULL, NULL, &err) != SQLITE_OK) 
    {
        sqlite3_close(db);
        NSAssert(0, @"Error deleting table."); 
    }
}


// retrieve User details
-(void) retrieveUserDetails
{
    //userDetailsArray = [[NSMutableArray alloc] init];
    NSString *sql = @"SELECT username,angelUserId,access_token,email,image,follows FROM User";
    
    sqlite3_stmt *statement;
       
    if(sqlite3_prepare_v2(db,[sql UTF8String],-1,&statement,nil) == SQLITE_OK)
    {
        while(sqlite3_step(statement) == SQLITE_ROW)
        {
            char *field1 = (char *) sqlite3_column_text(statement,0);
            NSString *field1Str = [[NSString alloc] initWithUTF8String:field1];
            NSString *str1 = [[NSString alloc] initWithFormat:@"%@", field1Str];
            _angelUserNameFromDB = str1;
           
            char *field2 = (char *) sqlite3_column_text(statement,1);
            NSString *field2Str = [[NSString alloc] initWithUTF8String:field2];
            NSString *str2 = [[NSString alloc] initWithFormat:@"%@", field2Str];
            _angelUserIdFromDB = [NSString stringWithFormat:@"%@",str2];
            
            char *field3 = (char *) sqlite3_column_text(statement,2);
            NSString *field3Str = [[NSString alloc] initWithUTF8String:field3];
            NSString *str3 = [[NSString alloc] initWithFormat:@"%@", field3Str];
            access_tokenFromDB = [NSString stringWithFormat:@"%@",str3];
            
            char *field4 = (char *) sqlite3_column_text(statement,3);
            NSString *field4Str = [[NSString alloc] initWithUTF8String:field4];
            NSString *str4 = [[NSString alloc] initWithFormat:@"%@", field4Str];
            _angelUserEmailFromDB = [NSString stringWithFormat:@"%@",str4];
            
            char *field5 = (char *) sqlite3_column_text(statement,4);
            NSString *field5Str = [[NSString alloc] initWithUTF8String:field5];
            NSString *str5 = [[NSString alloc] initWithFormat:@"%@", field5Str];
            _angelUserImageFromDB = [NSString stringWithFormat:@"%@",str5];
            
            char *field6 = (char *) sqlite3_column_text(statement,5);
            NSString *field6Str = [[NSString alloc] initWithUTF8String:field6];
            NSString *str6 = [[NSString alloc] initWithFormat:@"%@", field6Str];
            _angelUserFollowsFromDB = [NSString stringWithFormat:@"%@",str6];
            
            [userDetailsArray addObjectsFromArray:[NSArray arrayWithObjects: _angelUserNameFromDB,_angelUserEmailFromDB, _angelUserFollowsFromDB, _angelUserImageFromDB, access_tokenFromDB, _angelUserIdFromDB, nil]];
            
            
            [field1Str release];
            [field2Str release];
            [field3Str release];
            [field4Str release];
            [field5Str release];
            [field6Str release];
            [str1 release];
            [str2 release];
            [str3 release];
            [str4 release];
            [str5 release];
            [str6 release];
        }
        sqlite3_finalize(statement);
    }
}

// retrieve activity details
-(void) retrieveActivityDetails
{
    NSString *sql = @"SELECT feedDescription,feedImageUrl,actorType,actorId,actorName,actorUrl,actorTagline,feedImagePath, targetType, targetId , targetName, targetURL, targetTagline , targetImagePath,feedType FROM Activity";
    
    sqlite3_stmt *statement;
    
    if(sqlite3_prepare_v2(db,[sql UTF8String],-1,&statement,nil) == SQLITE_OK)
    {
        while(sqlite3_step(statement) == SQLITE_ROW)
        {
            char *field1 = (char *) sqlite3_column_text(statement,0);
            NSString *field1Str = [[NSString alloc] initWithUTF8String:field1];
            NSString *str1 = [[NSString alloc] initWithFormat:@"%@", field1Str];
            [feedDescDisplayArrayFromDB addObject:str1];
            
            char *field2 = (char *) sqlite3_column_text(statement,1);
            NSString *field2Str = [[NSString alloc] initWithUTF8String:field2];
            NSString *str2 = [[NSString alloc] initWithFormat:@"%@", field2Str];
            [feedImageArrayFromDB addObject:str2];
            
            char *field3 = (char *) sqlite3_column_text(statement,2);
            NSString *field3Str = [[NSString alloc] initWithUTF8String:field3];
            NSString *str3 = [[NSString alloc] initWithFormat:@"%@", field3Str];
            [actorTypeArrayFromDB addObject:str3];
            
            char *field4 = (char *) sqlite3_column_text(statement,3);
            NSString *field4Str = [[NSString alloc] initWithUTF8String:field4];
            NSString *str4 = [[NSString alloc] initWithFormat:@"%@", field4Str];
            [actorIdArrayFromDB addObject:str4];
            
            char *field5 = (char *) sqlite3_column_text(statement,4);
            NSString *field5Str = [[NSString alloc] initWithUTF8String:field5];
            NSString *str5 = [[NSString alloc] initWithFormat:@"%@", field5Str];
            [actorNameArrayFromDB addObject:str5];
            
            char *field6 = (char *) sqlite3_column_text(statement,5);
            NSString *field6Str = [[NSString alloc] initWithUTF8String:field6];
            NSString *str6 = [[NSString alloc] initWithFormat:@"%@", field6Str];
            [actorUrlArrayFromDB addObject:str6];
            
            char *field7 = (char *) sqlite3_column_text(statement,6);
            NSString *field7Str = [[NSString alloc] initWithUTF8String:field7];
            NSString *str7 = [[NSString alloc] initWithFormat:@"%@", field7Str];
            [actorTaglineArrayFromDB addObject:str7];
            
            char *field8 = (char *) sqlite3_column_text(statement,7);
            NSString *field8Str = [[NSString alloc] initWithUTF8String:field8];
            NSString *str8 = [[NSString alloc] initWithFormat:@"%@", field8Str];
            [feedImagesArrayFromDirectoryFromDB addObject:str8];
   
            char *field9 = (char *) sqlite3_column_text(statement,8);
            NSString *field9Str = [[NSString alloc] initWithUTF8String:field9];
            NSString *str9 = [[NSString alloc] initWithFormat:@"%@", field9Str];
            [targetTypeArrayFromDB addObject:str9];
            
            char *field10 = (char *) sqlite3_column_text(statement,9);
            NSString *field10Str = [[NSString alloc] initWithUTF8String:field10];
            NSString *str10 = [[NSString alloc] initWithFormat:@"%@", field10Str];
            [targetIdArrayFromDB addObject:str10];
            
            char *field11 = (char *) sqlite3_column_text(statement,10);
            NSString *field11Str = [[NSString alloc] initWithUTF8String:field11];
            NSString *str11 = [[NSString alloc] initWithFormat:@"%@", field11Str];
            [targetNameArrayFromDB addObject:str11];
            
            char *field12 = (char *) sqlite3_column_text(statement,11);
            NSString *field12Str = [[NSString alloc] initWithUTF8String:field12];
            NSString *str12 = [[NSString alloc] initWithFormat:@"%@", field12Str];
            [targetUrlArrayFromDB addObject:str12];
            
            char *field13 = (char *) sqlite3_column_text(statement,12);
            NSString *field13Str = [[NSString alloc] initWithUTF8String:field13];
            NSString *str13 = [[NSString alloc] initWithFormat:@"%@", field13Str];
            [targetTaglineArrayFromDB addObject:str13];
            
            char *field14 = (char *) sqlite3_column_text(statement,13);
            NSString *field14Str = [[NSString alloc] initWithUTF8String:field14];
            NSString *str14 = [[NSString alloc] initWithFormat:@"%@", field14Str];
            [targetImageArrayFromDB addObject:str14];
            
            char *field15 = (char *) sqlite3_column_text(statement,14);
            NSString *field15Str = [[NSString alloc] initWithUTF8String:field15];
            NSString *str15 = [[NSString alloc] initWithFormat:@"%@", field15Str];
            [feedTypeArrayFromDB addObject:str15];
            
            
            [field1Str release];
            [field2Str release];
            [field3Str release];
            [field4Str release];
            [field5Str release];
            [field6Str release];
            [field7Str release];
            [field8Str release];
            [field9Str release];
            [field10Str release];
            [field11Str release];
            [field12Str release];
            [field13Str release];
            [field14Str release];
            [field15Str release];
            
            [str1 release];
            [str2 release];
            [str3 release];
            [str4 release];
            [str5 release];
            [str6 release];
            [str7 release];
            [str8 release];
            [str9 release];
            [str10 release];
            [str11 release];
            [str12 release];
            [str13 release];
            [str14 release];
            [str15 release];
        }
        sqlite3_finalize(statement);
    }
}


// retrieve startup details 
-(void) retrieveStartUpsDetails
{
    NSString *sql = @"SELECT startUpId,startUpName,startUpAngelUrl,startUpLogoUrl,startUpProdDesc,startUpHighConcept,startUpFollowerCount,startUpLocations,startUpMarkets,startUpImagePath FROM StartUps";
    
    sqlite3_stmt *statement;
    
    if(sqlite3_prepare_v2(db,[sql UTF8String],-1,&statement,nil) == SQLITE_OK)
    {
        while(sqlite3_step(statement) == SQLITE_ROW)
        {
            char *field1 = (char *) sqlite3_column_text(statement,0);
            NSString *field1Str = [[NSString alloc] initWithUTF8String:field1];
            NSString *str1 = [[NSString alloc] initWithFormat:@"%@", field1Str];
            [startUpIdsArrayFromDB addObject:str1];
            
            char *field2 = (char *) sqlite3_column_text(statement,1);
            NSString *field2Str = [[NSString alloc] initWithUTF8String:field2];
            NSString *str2 = [[NSString alloc] initWithFormat:@"%@", field2Str];
            [startUpNameArrayFromDB addObject:str2];
            
            char *field3 = (char *) sqlite3_column_text(statement,2);
            NSString *field3Str = [[NSString alloc] initWithUTF8String:field3];
            NSString *str3 = [[NSString alloc] initWithFormat:@"%@", field3Str];
            [startUpAngelUrlArrayFromDB addObject:str3];
            
            char *field4 = (char *) sqlite3_column_text(statement,3);
            NSString *field4Str = [[NSString alloc] initWithUTF8String:field4];
            NSString *str4 = [[NSString alloc] initWithFormat:@"%@", field4Str];
            [startUpLogoUrlArrayFromDB addObject:str4];
            
            char *field5 = (char *) sqlite3_column_text(statement,4);
            NSString *field5Str = [[NSString alloc] initWithUTF8String:field5];
            NSString *str5 = [[NSString alloc] initWithFormat:@"%@", field5Str];
            [startUpProductDescArrayFromDB addObject:str5];
            
            char *field6 = (char *) sqlite3_column_text(statement,5);
            NSString *field6Str = [[NSString alloc] initWithUTF8String:field6];
            NSString *str6 = [[NSString alloc] initWithFormat:@"%@", field6Str];
            [startUpHighConceptArrayFromDB addObject:str6];
            
            char *field7 = (char *) sqlite3_column_text(statement,6);
            NSString *field7Str = [[NSString alloc] initWithUTF8String:field7];
            NSString *str7 = [[NSString alloc] initWithFormat:@"%@", field7Str];
            [startUpFollowerCountArrayFromDB addObject:str7];
            
            char *field8 = (char *) sqlite3_column_text(statement,7);
            NSString *field8Str = [[NSString alloc] initWithUTF8String:field8];
            NSString *str8 = [[NSString alloc] initWithFormat:@"%@", field8Str];
            [startUpLocationArrayFromDB addObject:str8];
            
            char *field9 = (char *) sqlite3_column_text(statement,8);
            NSString *field9Str = [[NSString alloc] initWithUTF8String:field9];
            NSString *str9 = [[NSString alloc] initWithFormat:@"%@", field9Str];
            [startUpMarketArrayFromDB addObject:str9];
            
            char *field10 = (char *) sqlite3_column_text(statement,9);
            NSString *field10Str = [[NSString alloc] initWithUTF8String:field10];
            NSString *str10 = [[NSString alloc] initWithFormat:@"%@", field10Str];
            [startUpLogoImageInDirectoryFromDB addObject:str10];
            
            [field1Str release];
            [field2Str release];
            [field3Str release];
            [field4Str release];
            [field5Str release];
            [field6Str release];
            [field7Str release];
            [field8Str release];
            [field9Str release];
            [field10Str release];
            [str1 release];
            [str2 release];
            [str3 release];
            [str4 release];
            [str5 release];
            [str6 release];
            [str7 release];
            [str8 release];
            [str9 release];
            [str10 release];
        }
        sqlite3_finalize(statement);
    }
}


// retrieve startups following details
-(void) retrieveStartUpsFollowingDetails
{
    NSString *sql = @"SELECT startUpId,startUpName,startUpAngelUrl,startUpLogoUrl,startUpProdDesc,startUpHighConcept,startUpFollowerCount,startUpLocations,startUpMarkets,startUpImagePath FROM Following";
    
    sqlite3_stmt *statement;
    
    if(sqlite3_prepare_v2(db,[sql UTF8String],-1,&statement,nil) == SQLITE_OK)
    {
        while(sqlite3_step(statement) == SQLITE_ROW)
        {
            char *field1 = (char *) sqlite3_column_text(statement,0);
            NSString *field1Str = [[NSString alloc] initWithUTF8String:field1];
            NSString *str1 = [[NSString alloc] initWithFormat:@"%@", field1Str];
            [startUpIdsArrayFromDB addObject:str1];
            
            char *field2 = (char *) sqlite3_column_text(statement,1);
            NSString *field2Str = [[NSString alloc] initWithUTF8String:field2];
            NSString *str2 = [[NSString alloc] initWithFormat:@"%@", field2Str];
            [startUpNameArrayFromDB addObject:str2];
            
            char *field3 = (char *) sqlite3_column_text(statement,2);
            NSString *field3Str = [[NSString alloc] initWithUTF8String:field3];
            NSString *str3 = [[NSString alloc] initWithFormat:@"%@", field3Str];
            [startUpAngelUrlArrayFromDB addObject:str3];
            
            char *field4 = (char *) sqlite3_column_text(statement,3);
            NSString *field4Str = [[NSString alloc] initWithUTF8String:field4];
            NSString *str4 = [[NSString alloc] initWithFormat:@"%@", field4Str];
            [startUpLogoUrlArrayFromDB addObject:str4];
            
            char *field5 = (char *) sqlite3_column_text(statement,4);
            NSString *field5Str = [[NSString alloc] initWithUTF8String:field5];
            NSString *str5 = [[NSString alloc] initWithFormat:@"%@", field5Str];
            [startUpProductDescArrayFromDB addObject:str5];
            
            char *field6 = (char *) sqlite3_column_text(statement,5);
            NSString *field6Str = [[NSString alloc] initWithUTF8String:field6];
            NSString *str6 = [[NSString alloc] initWithFormat:@"%@", field6Str];
            [startUpHighConceptArrayFromDB addObject:str6];
            
            char *field7 = (char *) sqlite3_column_text(statement,6);
            NSString *field7Str = [[NSString alloc] initWithUTF8String:field7];
            NSString *str7 = [[NSString alloc] initWithFormat:@"%@", field7Str];
            [startUpFollowerCountArrayFromDB addObject:str7];
            
            char *field8 = (char *) sqlite3_column_text(statement,7);
            NSString *field8Str = [[NSString alloc] initWithUTF8String:field8];
            NSString *str8 = [[NSString alloc] initWithFormat:@"%@", field8Str];
            [startUpLocationArrayFromDB addObject:str8];
            
            char *field9 = (char *) sqlite3_column_text(statement,8);
            NSString *field9Str = [[NSString alloc] initWithUTF8String:field9];
            NSString *str9 = [[NSString alloc] initWithFormat:@"%@", field9Str];
            [startUpMarketArrayFromDB addObject:str9];
            
            char *field10 = (char *) sqlite3_column_text(statement,9);
            NSString *field10Str = [[NSString alloc] initWithUTF8String:field10];
            NSString *str10 = [[NSString alloc] initWithFormat:@"%@", field10Str];
            [startUpLogoImageInDirectoryFromDB addObject:str10];
            
            [field1Str release];
            [field2Str release];
            [field3Str release];
            [field4Str release];
            [field5Str release];
            [field6Str release];
            [field7Str release];
            [field8Str release];
            [field9Str release];
            [field10Str release];
            
            [str1 release];
            [str2 release];
            [str3 release];
            [str4 release];
            [str5 release];
            [str6 release];
            [str7 release];
            [str8 release];
            [str9 release];
            [str10 release];
        }
        sqlite3_finalize(statement);
    }
}

// retrieve startup portfolio details
-(void) retrieveStartUpsPortfolioDetails
{
    NSString *sql = @"SELECT startUpId,startUpName,startUpAngelUrl,startUpLogoUrl,startUpProdDesc,startUpHighConcept,startUpFollowerCount,startUpLocations,startUpMarkets,startUpImagePath FROM Portfolio";
    
    sqlite3_stmt *statement;
    
    if(sqlite3_prepare_v2(db,[sql UTF8String],-1,&statement,nil) == SQLITE_OK)
    {
        while(sqlite3_step(statement) == SQLITE_ROW)
        {
            char *field1 = (char *) sqlite3_column_text(statement,0);
            NSString *field1Str = [[NSString alloc] initWithUTF8String:field1];
            NSString *str1 = [[NSString alloc] initWithFormat:@"%@", field1Str];
            [startUpIdsArrayFromDB addObject:str1];
            
            char *field2 = (char *) sqlite3_column_text(statement,1);
            NSString *field2Str = [[NSString alloc] initWithUTF8String:field2];
            NSString *str2 = [[NSString alloc] initWithFormat:@"%@", field2Str];
            [startUpNameArrayFromDB addObject:str2];
            
            char *field3 = (char *) sqlite3_column_text(statement,2);
            NSString *field3Str = [[NSString alloc] initWithUTF8String:field3];
            NSString *str3 = [[NSString alloc] initWithFormat:@"%@", field3Str];
            [startUpAngelUrlArrayFromDB addObject:str3];
            
            char *field4 = (char *) sqlite3_column_text(statement,3);
            NSString *field4Str = [[NSString alloc] initWithUTF8String:field4];
            NSString *str4 = [[NSString alloc] initWithFormat:@"%@", field4Str];
            [startUpLogoUrlArrayFromDB addObject:str4];
            
            char *field5 = (char *) sqlite3_column_text(statement,4);
            NSString *field5Str = [[NSString alloc] initWithUTF8String:field5];
            NSString *str5 = [[NSString alloc] initWithFormat:@"%@", field5Str];
            [startUpProductDescArrayFromDB addObject:str5];
            
            char *field6 = (char *) sqlite3_column_text(statement,5);
            NSString *field6Str = [[NSString alloc] initWithUTF8String:field6];
            NSString *str6 = [[NSString alloc] initWithFormat:@"%@", field6Str];
            [startUpHighConceptArrayFromDB addObject:str6];
            
            char *field7 = (char *) sqlite3_column_text(statement,6);
            NSString *field7Str = [[NSString alloc] initWithUTF8String:field7];
            NSString *str7 = [[NSString alloc] initWithFormat:@"%@", field7Str];
            [startUpFollowerCountArrayFromDB addObject:str7];
            
            char *field8 = (char *) sqlite3_column_text(statement,7);
            NSString *field8Str = [[NSString alloc] initWithUTF8String:field8];
            NSString *str8 = [[NSString alloc] initWithFormat:@"%@", field8Str];
            [startUpLocationArrayFromDB addObject:str8];
            
            char *field9 = (char *) sqlite3_column_text(statement,8);
            NSString *field9Str = [[NSString alloc] initWithUTF8String:field9];
            NSString *str9 = [[NSString alloc] initWithFormat:@"%@", field9Str];
            [startUpMarketArrayFromDB addObject:str9];
            
            char *field10 = (char *) sqlite3_column_text(statement,9);
            NSString *field10Str = [[NSString alloc] initWithUTF8String:field10];
            NSString *str10 = [[NSString alloc] initWithFormat:@"%@", field10Str];
            [startUpLogoImageInDirectoryFromDB addObject:str10];
            
            [field1Str release];
            [field2Str release];
            [field3Str release];
            [field4Str release];
            [field5Str release];
            [field6Str release];
            [field7Str release];
            [field8Str release];
            [field9Str release];
            [field10Str release];
            
            [str1 release];
            [str2 release];
            [str3 release];
            [str4 release];
            [str5 release];
            [str6 release];
            [str7 release];
            [str8 release];
            [str9 release];
            [str10 release];
        }
        sqlite3_finalize(statement);
    }
}


// retrieve startups trending details
-(void) retrieveStartUpstrendingDetails
{
    NSString *sql = @"SELECT startUpId,startUpName,startUpAngelUrl,startUpLogoUrl,startUpProdDesc,startUpHighConcept,startUpFollowerCount,startUpLocations,startUpMarkets,startUpImagePath FROM Trending";
    
    sqlite3_stmt *statement;
    
    if(sqlite3_prepare_v2(db,[sql UTF8String],-1,&statement,nil) == SQLITE_OK)
    {
        while(sqlite3_step(statement) == SQLITE_ROW)
        {
            char *field1 = (char *) sqlite3_column_text(statement,0);
            NSString *field1Str = [[NSString alloc] initWithUTF8String:field1];
            NSString *str1 = [[NSString alloc] initWithFormat:@"%@", field1Str];
            [startUpIdsArrayFromDB addObject:str1];
            
            char *field2 = (char *) sqlite3_column_text(statement,1);
            NSString *field2Str = [[NSString alloc] initWithUTF8String:field2];
            NSString *str2 = [[NSString alloc] initWithFormat:@"%@", field2Str];
            [startUpNameArrayFromDB addObject:str2];
            
            char *field3 = (char *) sqlite3_column_text(statement,2);
            NSString *field3Str = [[NSString alloc] initWithUTF8String:field3];
            NSString *str3 = [[NSString alloc] initWithFormat:@"%@", field3Str];
            [startUpAngelUrlArrayFromDB addObject:str3];
            
            char *field4 = (char *) sqlite3_column_text(statement,3);
            NSString *field4Str = [[NSString alloc] initWithUTF8String:field4];
            NSString *str4 = [[NSString alloc] initWithFormat:@"%@", field4Str];
            [startUpLogoUrlArrayFromDB addObject:str4];
            
            char *field5 = (char *) sqlite3_column_text(statement,4);
            NSString *field5Str = [[NSString alloc] initWithUTF8String:field5];
            NSString *str5 = [[NSString alloc] initWithFormat:@"%@", field5Str];
            [startUpProductDescArrayFromDB addObject:str5];
            
            char *field6 = (char *) sqlite3_column_text(statement,5);
            NSString *field6Str = [[NSString alloc] initWithUTF8String:field6];
            NSString *str6 = [[NSString alloc] initWithFormat:@"%@", field6Str];
            [startUpHighConceptArrayFromDB addObject:str6];
            
            char *field7 = (char *) sqlite3_column_text(statement,6);
            NSString *field7Str = [[NSString alloc] initWithUTF8String:field7];
            NSString *str7 = [[NSString alloc] initWithFormat:@"%@", field7Str];
            [startUpFollowerCountArrayFromDB addObject:str7];
            
            char *field8 = (char *) sqlite3_column_text(statement,7);
            NSString *field8Str = [[NSString alloc] initWithUTF8String:field8];
            NSString *str8 = [[NSString alloc] initWithFormat:@"%@", field8Str];
            [startUpLocationArrayFromDB addObject:str8];
            
            char *field9 = (char *) sqlite3_column_text(statement,8);
            NSString *field9Str = [[NSString alloc] initWithUTF8String:field9];
            NSString *str9 = [[NSString alloc] initWithFormat:@"%@", field9Str];
            [startUpMarketArrayFromDB addObject:str9];
            
            char *field10 = (char *) sqlite3_column_text(statement,9);
            NSString *field10Str = [[NSString alloc] initWithUTF8String:field10];
            NSString *str10 = [[NSString alloc] initWithFormat:@"%@", field10Str];
            [startUpLogoImageInDirectoryFromDB addObject:str10];
            
            [field1Str release];
            [field2Str release];
            [field3Str release];
            [field4Str release];
            [field5Str release];
            [field6Str release];
            [field7Str release];
            [field8Str release];
            [field9Str release];
            [field10Str release];
            [str1 release];
            [str2 release];
            [str3 release];
            [str4 release];
            [str5 release];
            [str6 release];
            [str7 release];
            [str8 release];
            [str9 release];
            [str10 release];
        }
        sqlite3_finalize(statement);
    }
}


//Close database
-(void) closeDB
{
    sqlite3_close(db);
}



@end
