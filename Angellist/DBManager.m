//
//  DBManager.m
//  TableProj
//
//  Created by Ram Charan on 8/23/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import "DBManager.h"

@implementation DBManager

//for activity
@synthesize feedDescDisplayArrayFromDB;
@synthesize feedIdArrayFromDB;
@synthesize feedItemTypeArrayFromDB;
@synthesize actorNameArrayFromDB;
@synthesize feedActorImageDisplayArrayFromDB;
@synthesize actorLinkArrayFromDB;
@synthesize actorTaglineArrayFromDB;
@synthesize targetNameArrayFromDB;
@synthesize feedTargetImageDisplayArrayFromDB;
@synthesize targetLinkArrayFromDB;
@synthesize targetTaglineArrayFromDB;
@synthesize actorImageUrlArrayFromDB;
@synthesize targetImageUrlArrayFromDB;
//end activity

//for trending
@synthesize startUpIdArrayFromDB;
@synthesize startUpNameArrayFromDB;
@synthesize startUpLinkArrayFromDB;
@synthesize startUpImageUrlArrayFromDB;
@synthesize startUpProdDescArrayFromDB;
@synthesize startUpHighConceptArrayFromDB;
@synthesize startUpFollowCountArrayFromDB;
@synthesize startUpLocationsArrayFromDB;
@synthesize startUpMarketsArrayFromDB;
@synthesize startUpImageDisplayArrayFromDB;
//end trending

//for user
@synthesize userDetailsArrayFromDB;
//end user

//for Inbox
@synthesize inboxTotalArrayFromDB;
@synthesize inboxThreadIdArrayFromDB;
@synthesize inboxViewedArrayFromDB;
//end Inbox

//To check filePath
-(NSString *) filePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:@"angeldb.sqlite"];
}

-(void) openDB {
    //---create database---
    if (sqlite3_open([[self filePath] UTF8String], &db) != SQLITE_OK ) {
        sqlite3_close(db);
        NSAssert(0, @"Database failed to open."); 
    }
}


//for activity
-(void) createTableActivity:(NSString *)tableName withField1:(NSString *)field1 withField2:(NSString *)field2 withField3:(NSString *)field3 withField4:(NSString *)field4 withField5:(NSString *)field5 withField6:(NSString *)field6 withField7:(NSString *)field7 withField8:(NSString *)field8 withField9:(NSString *)field9 withField10:(NSString *)field10 withField11:(NSString *)field11 withField12:(NSString *)field12 withField13:(NSString *)field13 withField14:(NSString *)field14
{
    char *err;
    NSString *sql = [NSString stringWithFormat:
                     @"CREATE TABLE IF NOT EXISTS '%@' ('%@' TEXT PRIMARY KEY, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT);", tableName, field1, field2, field3, field4, field5, field6, field7, field8, field9 , field10 , field11, field12, field13, field14];

    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) 
    { 
        sqlite3_close(db);
        NSAssert(0, @"Table Activity failed to create.");
    }
}

-(void) insertRecordIntoActivityTable:(NSString *)tableName withField1: (NSString *) field1 field1Value: (NSString *) field1Value andField2: (NSString *) field2 field2Value: (NSString *) field2Value andField3: (NSString *) field3 field3Value: (NSString *) field3Value andField4: (NSString *) field4 field4Value: (NSString *) field4Value andField5: (NSString *) field5 field5Value: (NSString *) field5Value andField6: (NSString *) field6 field6Value: (NSString *) field6Value andField7: (NSString *) field7 field7Value: (NSString *) field7Value andField8: (NSString *) field8 field8Value: (NSString *) field8Value andField9: (NSString *) field9 field9Value: (NSString *) field9Value andField10: (NSString *) field10 field10Value: (NSString *) field10Value andField11: (NSString *) field11 field11Value: (NSString *) field11Value andField12: (NSString *) field12 field12Value: (NSString *) field12Value andField13: (NSString *) field13 field13Value: (NSString *) field13Value andField14: (NSString *) field14 field14Value: (NSString *) field14Value
{
    char *err;
    NSString *sql = [NSString stringWithFormat:
                     @"INSERT OR REPLACE INTO '%@' ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@') VALUES ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@');", tableName, field1, field2, field3, field4, field5, field6, field7, field8, field9, field10, field11, field12, field13, field14, field1Value, field2Value, field3Value, field4Value, field5Value, field6Value, field7Value, field8Value, field9Value, field10Value, field11Value, field12Value, field13Value, field14Value];

    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) 
    { 
        sqlite3_close(db);
        NSAssert(0, @"Error Inserting to Table Activity");
    }
}

-(void) retrieveActivityDetails
{
    NSString *sql = @"SELECT feedId,feedItemType,feedDescription,actorName,actorImagePath,actorLink,actorTagline,targetName,targetImagePath,targetLink, targetTagline, actorImageUrl, targetImageUrl FROM Activity";
    
    sqlite3_stmt *statement;
    
    if(sqlite3_prepare_v2(db,[sql UTF8String],-1,&statement,nil) == SQLITE_OK)
    {
        while(sqlite3_step(statement) == SQLITE_ROW)
        {
            char *field1 = (char *) sqlite3_column_text(statement,0);
            NSString *field1Str = [[NSString alloc] initWithUTF8String:field1];
            NSString *str1 = [[NSString alloc] initWithFormat:@"%@", field1Str];
            [feedIdArrayFromDB addObject:str1];
            
            char *field2 = (char *) sqlite3_column_text(statement,1);
            NSString *field2Str = [[NSString alloc] initWithUTF8String:field2];
            NSString *str2 = [[NSString alloc] initWithFormat:@"%@", field2Str];
            [feedItemTypeArrayFromDB addObject:str2];
            
            char *field3 = (char *) sqlite3_column_text(statement,2);
            NSString *field3Str = [[NSString alloc] initWithUTF8String:field3];
            NSString *str3 = [[NSString alloc] initWithFormat:@"%@", field3Str];
            [feedDescDisplayArrayFromDB addObject:str3];
            
            char *field4 = (char *) sqlite3_column_text(statement,3);
            NSString *field4Str = [[NSString alloc] initWithUTF8String:field4];
            NSString *str4 = [[NSString alloc] initWithFormat:@"%@", field4Str];
            [actorNameArrayFromDB addObject:str4];
            
            char *field5 = (char *) sqlite3_column_text(statement,4);
            NSString *field5Str = [[NSString alloc] initWithUTF8String:field5];
            NSString *str5 = [[NSString alloc] initWithFormat:@"%@", field5Str];
            [feedActorImageDisplayArrayFromDB addObject:str5];
            
            char *field6 = (char *) sqlite3_column_text(statement,5);
            NSString *field6Str = [[NSString alloc] initWithUTF8String:field6];
            NSString *str6 = [[NSString alloc] initWithFormat:@"%@", field6Str];
            [actorLinkArrayFromDB addObject:str6];
            
            char *field7 = (char *) sqlite3_column_text(statement,6);
            NSString *field7Str = [[NSString alloc] initWithUTF8String:field7];
            NSString *str7 = [[NSString alloc] initWithFormat:@"%@", field7Str];
            [actorTaglineArrayFromDB addObject:str7];
            
            char *field8 = (char *) sqlite3_column_text(statement,7);
            NSString *field8Str = [[NSString alloc] initWithUTF8String:field8];
            NSString *str8 = [[NSString alloc] initWithFormat:@"%@", field8Str];
            [targetNameArrayFromDB addObject:str8];
            
            char *field9 = (char *) sqlite3_column_text(statement,8);
            NSString *field9Str = [[NSString alloc] initWithUTF8String:field9];
            NSString *str9 = [[NSString alloc] initWithFormat:@"%@", field9Str];
            [feedTargetImageDisplayArrayFromDB addObject:str9];
            
            char *field10 = (char *) sqlite3_column_text(statement,9);
            NSString *field10Str = [[NSString alloc] initWithUTF8String:field10];
            NSString *str10 = [[NSString alloc] initWithFormat:@"%@", field10Str];
            [targetLinkArrayFromDB addObject:str10];
            
            char *field11 = (char *) sqlite3_column_text(statement,10);
            NSString *field11Str = [[NSString alloc] initWithUTF8String:field11];
            NSString *str11 = [[NSString alloc] initWithFormat:@"%@", field11Str];
            [targetTaglineArrayFromDB addObject:str11];
            
            char *field12 = (char *) sqlite3_column_text(statement,11);
            NSString *field12Str = [[NSString alloc] initWithUTF8String:field12];
            NSString *str12 = [[NSString alloc] initWithFormat:@"%@", field12Str];
            [actorImageUrlArrayFromDB addObject:str12];
            
            char *field13 = (char *) sqlite3_column_text(statement,12);
            NSString *field13Str = [[NSString alloc] initWithUTF8String:field13];
            NSString *str13 = [[NSString alloc] initWithFormat:@"%@", field13Str];
            [targetImageUrlArrayFromDB addObject:str13];
            
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
        }
        sqlite3_finalize(statement);
    }
}

-(void) deleteRowsFromActivity
{
    char *err;
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM Activity"];
    
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) 
    { 
        sqlite3_close(db);
        NSAssert(0, @"Error Deleting to Rows of Activity");
    }
}
//end activity

//for startups
-(void) createTableTrendingStartUps:(NSString *)tableName withField1:(NSString *)field1 withField2:(NSString *)field2 withField3:(NSString *)field3 withField4:(NSString *)field4 withField5:(NSString *)field5 withField6:(NSString *)field6 withField7:(NSString *)field7 withField8:(NSString *)field8 withField9:(NSString *)field9 withField10:(NSString *)field10 withField11:(NSString *)field11
{
    char *err;
    NSString *sql = [NSString stringWithFormat:
                     @"CREATE TABLE IF NOT EXISTS '%@' ('%@' TEXT PRIMARY KEY, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT);", tableName, field1, field2, field3, field4, field5, field6, field7, field8, field9, field10, field11];
    
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) 
    { 
        sqlite3_close(db);
        NSAssert(0, @"Table StartUps failed to create.");
    }
}

-(void) insertRecordIntoTrendingTable:(NSString *)tableName withField1: (NSString *) field1 field1Value: (NSString *) field1Value andField2: (NSString *) field2 field2Value: (NSString *) field2Value andField3: (NSString *) field3 field3Value: (NSString *) field3Value andField4: (NSString *) field4 field4Value: (NSString *) field4Value andField5: (NSString *) field5 field5Value: (NSString *) field5Value andField6: (NSString *) field6 field6Value: (NSString *) field6Value andField7: (NSString *) field7 field7Value: (NSString *) field7Value andField8: (NSString *) field8 field8Value: (NSString *) field8Value andField9: (NSString *) field9 field9Value: (NSString *) field9Value andField10: (NSString *) field10 field10Value: (NSString *) field10Value andField11: (NSString *) field11 field11Value: (NSString *) field11Value
{
    char *err;
    NSString *sql = [NSString stringWithFormat:
                     @"INSERT OR REPLACE INTO '%@' ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@') VALUES ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@');", tableName, field1, field2, field3, field4, field5, field6, field7, field8, field9, field10, field11, field1Value, field2Value, field3Value, field4Value, field5Value, field6Value, field7Value, field8Value, field9Value, field10Value, field11Value];
    
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) 
    { 
        sqlite3_close(db);
        NSAssert(0, @"Error Inserting to Table Trending");
    }
}

-(void) retrieveTrendingDetails
{
    NSString *sql = @"SELECT trendingId,trendingName,trendingLink,trendingImageUrl,trendingProdDesc,trendingHighConcept,trendingFollowCount,trendingLocations,trendingMarkets,trendingImagePath FROM Trending";
    
    sqlite3_stmt *statement;
    
    if(sqlite3_prepare_v2(db,[sql UTF8String],-1,&statement,nil) == SQLITE_OK)
    {
        while(sqlite3_step(statement) == SQLITE_ROW)
        {
            char *field1 = (char *) sqlite3_column_text(statement,0);
            NSString *field1Str = [[NSString alloc] initWithUTF8String:field1];
            NSString *str1 = [[NSString alloc] initWithFormat:@"%@", field1Str];
            [startUpIdArrayFromDB addObject:str1];
            
            char *field2 = (char *) sqlite3_column_text(statement,1);
            NSString *field2Str = [[NSString alloc] initWithUTF8String:field2];
            NSString *str2 = [[NSString alloc] initWithFormat:@"%@", field2Str];
            [startUpNameArrayFromDB addObject:str2];
            
            char *field3 = (char *) sqlite3_column_text(statement,2);
            NSString *field3Str = [[NSString alloc] initWithUTF8String:field3];
            NSString *str3 = [[NSString alloc] initWithFormat:@"%@", field3Str];
            [startUpLinkArrayFromDB addObject:str3];
            
            char *field4 = (char *) sqlite3_column_text(statement,3);
            NSString *field4Str = [[NSString alloc] initWithUTF8String:field4];
            NSString *str4 = [[NSString alloc] initWithFormat:@"%@", field4Str];
            [startUpImageUrlArrayFromDB addObject:str4];
            
            char *field5 = (char *) sqlite3_column_text(statement,4);
            NSString *field5Str = [[NSString alloc] initWithUTF8String:field5];
            NSString *str5 = [[NSString alloc] initWithFormat:@"%@", field5Str];
            [startUpProdDescArrayFromDB addObject:str5];
            
            char *field6 = (char *) sqlite3_column_text(statement,5);
            NSString *field6Str = [[NSString alloc] initWithUTF8String:field6];
            NSString *str6 = [[NSString alloc] initWithFormat:@"%@", field6Str];
            [startUpHighConceptArrayFromDB addObject:str6];
            
            char *field7 = (char *) sqlite3_column_text(statement,6);
            NSString *field7Str = [[NSString alloc] initWithUTF8String:field7];
            NSString *str7 = [[NSString alloc] initWithFormat:@"%@", field7Str];
            [startUpFollowCountArrayFromDB addObject:str7];
            
            char *field8 = (char *) sqlite3_column_text(statement,7);
            NSString *field8Str = [[NSString alloc] initWithUTF8String:field8];
            NSString *str8 = [[NSString alloc] initWithFormat:@"%@", field8Str];
            [startUpLocationsArrayFromDB addObject:str8];
            
            char *field9 = (char *) sqlite3_column_text(statement,8);
            NSString *field9Str = [[NSString alloc] initWithUTF8String:field9];
            NSString *str9 = [[NSString alloc] initWithFormat:@"%@", field9Str];
            [startUpMarketsArrayFromDB addObject:str9];
            
            char *field10 = (char *) sqlite3_column_text(statement,9);
            NSString *field10Str = [[NSString alloc] initWithUTF8String:field10];
            NSString *str10 = [[NSString alloc] initWithFormat:@"%@", field10Str];
            [startUpImageDisplayArrayFromDB addObject:str10];
            
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

-(void) deleteRowsFromTrending
{
    char *err;
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM Trending"];
    
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) 
    { 
        sqlite3_close(db);
        NSAssert(0, @"Error Deleting to Rows of Trending");
    }
}
//end trending

//for following
-(void) createTableFollowingStartUps:(NSString *)tableName withField1:(NSString *)field1 withField2:(NSString *)field2 withField3:(NSString *)field3 withField4:(NSString *)field4 withField5:(NSString *)field5 withField6:(NSString *)field6 withField7:(NSString *)field7 withField8:(NSString *)field8 withField9:(NSString *)field9 withField10:(NSString *)field10 withField11:(NSString *)field11
{
    char *err;
    NSString *sql = [NSString stringWithFormat:
                     @"CREATE TABLE IF NOT EXISTS '%@' ('%@' TEXT PRIMARY KEY, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT);", tableName, field1, field2, field3, field4, field5, field6, field7, field8, field9, field10, field11];
    
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) 
    { 
        sqlite3_close(db);
        NSAssert(0, @"Table StartUps failed to create.");
    }
}

-(void) insertRecordIntoFollowingTable:(NSString *)tableName withField1: (NSString *) field1 field1Value: (NSString *) field1Value andField2: (NSString *) field2 field2Value: (NSString *) field2Value andField3: (NSString *) field3 field3Value: (NSString *) field3Value andField4: (NSString *) field4 field4Value: (NSString *) field4Value andField5: (NSString *) field5 field5Value: (NSString *) field5Value andField6: (NSString *) field6 field6Value: (NSString *) field6Value andField7: (NSString *) field7 field7Value: (NSString *) field7Value andField8: (NSString *) field8 field8Value: (NSString *) field8Value andField9: (NSString *) field9 field9Value: (NSString *) field9Value andField10: (NSString *) field10 field10Value: (NSString *) field10Value andField11: (NSString *) field11 field11Value: (NSString *) field11Value
{
    char *err;
    NSString *sql = [NSString stringWithFormat:
                     @"INSERT OR REPLACE INTO '%@' ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@') VALUES ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@');", tableName, field1, field2, field3, field4, field5, field6, field7, field8, field9, field10, field11, field1Value, field2Value, field3Value, field4Value, field5Value, field6Value, field7Value, field8Value, field9Value, field10Value, field11Value];
    
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) 
    { 
        sqlite3_close(db);
        NSAssert(0, @"Error Inserting to Table Following");
    }
}

-(void) retrieveFollowingDetails
{
    NSString *sql = @"SELECT followingId,followingName,followingLink,followingImageUrl,followingProdDesc,followingHighConcept,followingFollowCount,followingLocations,followingMarkets,followingImagePath FROM Following";
    
    sqlite3_stmt *statement;
    
    if(sqlite3_prepare_v2(db,[sql UTF8String],-1,&statement,nil) == SQLITE_OK)
    {
        while(sqlite3_step(statement) == SQLITE_ROW)
        {
            char *field1 = (char *) sqlite3_column_text(statement,0);
            NSString *field1Str = [[NSString alloc] initWithUTF8String:field1];
            NSString *str1 = [[NSString alloc] initWithFormat:@"%@", field1Str];
            [startUpIdArrayFromDB addObject:str1];
            
            char *field2 = (char *) sqlite3_column_text(statement,1);
            NSString *field2Str = [[NSString alloc] initWithUTF8String:field2];
            NSString *str2 = [[NSString alloc] initWithFormat:@"%@", field2Str];
            [startUpNameArrayFromDB addObject:str2];
            
            char *field3 = (char *) sqlite3_column_text(statement,2);
            NSString *field3Str = [[NSString alloc] initWithUTF8String:field3];
            NSString *str3 = [[NSString alloc] initWithFormat:@"%@", field3Str];
            [startUpLinkArrayFromDB addObject:str3];
            
            char *field4 = (char *) sqlite3_column_text(statement,3);
            NSString *field4Str = [[NSString alloc] initWithUTF8String:field4];
            NSString *str4 = [[NSString alloc] initWithFormat:@"%@", field4Str];
            [startUpImageUrlArrayFromDB addObject:str4];
            
            char *field5 = (char *) sqlite3_column_text(statement,4);
            NSString *field5Str = [[NSString alloc] initWithUTF8String:field5];
            NSString *str5 = [[NSString alloc] initWithFormat:@"%@", field5Str];
            [startUpProdDescArrayFromDB addObject:str5];
            
            char *field6 = (char *) sqlite3_column_text(statement,5);
            NSString *field6Str = [[NSString alloc] initWithUTF8String:field6];
            NSString *str6 = [[NSString alloc] initWithFormat:@"%@", field6Str];
            [startUpHighConceptArrayFromDB addObject:str6];
            
            char *field7 = (char *) sqlite3_column_text(statement,6);
            NSString *field7Str = [[NSString alloc] initWithUTF8String:field7];
            NSString *str7 = [[NSString alloc] initWithFormat:@"%@", field7Str];
            [startUpFollowCountArrayFromDB addObject:str7];
            
            char *field8 = (char *) sqlite3_column_text(statement,7);
            NSString *field8Str = [[NSString alloc] initWithUTF8String:field8];
            NSString *str8 = [[NSString alloc] initWithFormat:@"%@", field8Str];
            [startUpLocationsArrayFromDB addObject:str8];
            
            char *field9 = (char *) sqlite3_column_text(statement,8);
            NSString *field9Str = [[NSString alloc] initWithUTF8String:field9];
            NSString *str9 = [[NSString alloc] initWithFormat:@"%@", field9Str];
            [startUpMarketsArrayFromDB addObject:str9];
            
            char *field10 = (char *) sqlite3_column_text(statement,9);
            NSString *field10Str = [[NSString alloc] initWithUTF8String:field10];
            NSString *str10 = [[NSString alloc] initWithFormat:@"%@", field10Str];
            [startUpImageDisplayArrayFromDB addObject:str10];
            
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

-(void) deleteRowsFromFollowing
{
    char *err;
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM Following"];
    
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) 
    { 
        sqlite3_close(db);
        NSAssert(0, @"Error Deleting to Rows of Following");
    }
}
//end following

//for portfolio
-(void) createTablePortfolioStartUps:(NSString *)tableName withField1:(NSString *)field1 withField2:(NSString *)field2 withField3:(NSString *)field3 withField4:(NSString *)field4 withField5:(NSString *)field5 withField6:(NSString *)field6 withField7:(NSString *)field7 withField8:(NSString *)field8 withField9:(NSString *)field9 withField10:(NSString *)field10 withField11:(NSString *)field11
{
    char *err;
    NSString *sql = [NSString stringWithFormat:
                     @"CREATE TABLE IF NOT EXISTS '%@' ('%@' TEXT PRIMARY KEY, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT);", tableName, field1, field2, field3, field4, field5, field6, field7, field8, field9, field10, field11];
    
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) 
    { 
        sqlite3_close(db);
        NSAssert(0, @"Table Portfolio failed to create.");
    }
}

-(void) insertRecordIntoPortfolioTable:(NSString *)tableName withField1: (NSString *) field1 field1Value: (NSString *) field1Value andField2: (NSString *) field2 field2Value: (NSString *) field2Value andField3: (NSString *) field3 field3Value: (NSString *) field3Value andField4: (NSString *) field4 field4Value: (NSString *) field4Value andField5: (NSString *) field5 field5Value: (NSString *) field5Value andField6: (NSString *) field6 field6Value: (NSString *) field6Value andField7: (NSString *) field7 field7Value: (NSString *) field7Value andField8: (NSString *) field8 field8Value: (NSString *) field8Value andField9: (NSString *) field9 field9Value: (NSString *) field9Value andField10: (NSString *) field10 field10Value: (NSString *) field10Value andField11: (NSString *) field11 field11Value: (NSString *) field11Value
{
    char *err;
    NSString *sql = [NSString stringWithFormat:
                     @"INSERT OR REPLACE INTO '%@' ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@') VALUES ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@');", tableName, field1, field2, field3, field4, field5, field6, field7, field8, field9, field10, field11, field1Value, field2Value, field3Value, field4Value, field5Value, field6Value, field7Value, field8Value, field9Value, field10Value, field11Value];
    
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) 
    { 
        sqlite3_close(db);
        NSAssert(0, @"Error Inserting to Table Portfolio");
    }
}

-(void) retrievePortfolioDetails
{
    NSString *sql = @"SELECT portfolioId,portfolioName,portfolioLink,portfolioImageUrl,portfolioProdDesc,portfolioHighConcept,portfolioFollowCount,portfolioLocations,portfolioMarkets,portfolioImagePath FROM Portfolio";
    
    sqlite3_stmt *statement;
    
    if(sqlite3_prepare_v2(db,[sql UTF8String],-1,&statement,nil) == SQLITE_OK)
    {
        while(sqlite3_step(statement) == SQLITE_ROW)
        {
            char *field1 = (char *) sqlite3_column_text(statement,0);
            NSString *field1Str = [[NSString alloc] initWithUTF8String:field1];
            NSString *str1 = [[NSString alloc] initWithFormat:@"%@", field1Str];
            [startUpIdArrayFromDB addObject:str1];
            
            char *field2 = (char *) sqlite3_column_text(statement,1);
            NSString *field2Str = [[NSString alloc] initWithUTF8String:field2];
            NSString *str2 = [[NSString alloc] initWithFormat:@"%@", field2Str];
            [startUpNameArrayFromDB addObject:str2];
            
            char *field3 = (char *) sqlite3_column_text(statement,2);
            NSString *field3Str = [[NSString alloc] initWithUTF8String:field3];
            NSString *str3 = [[NSString alloc] initWithFormat:@"%@", field3Str];
            [startUpLinkArrayFromDB addObject:str3];
            
            char *field4 = (char *) sqlite3_column_text(statement,3);
            NSString *field4Str = [[NSString alloc] initWithUTF8String:field4];
            NSString *str4 = [[NSString alloc] initWithFormat:@"%@", field4Str];
            [startUpImageUrlArrayFromDB addObject:str4];
            
            char *field5 = (char *) sqlite3_column_text(statement,4);
            NSString *field5Str = [[NSString alloc] initWithUTF8String:field5];
            NSString *str5 = [[NSString alloc] initWithFormat:@"%@", field5Str];
            [startUpProdDescArrayFromDB addObject:str5];
            
            char *field6 = (char *) sqlite3_column_text(statement,5);
            NSString *field6Str = [[NSString alloc] initWithUTF8String:field6];
            NSString *str6 = [[NSString alloc] initWithFormat:@"%@", field6Str];
            [startUpHighConceptArrayFromDB addObject:str6];
            
            char *field7 = (char *) sqlite3_column_text(statement,6);
            NSString *field7Str = [[NSString alloc] initWithUTF8String:field7];
            NSString *str7 = [[NSString alloc] initWithFormat:@"%@", field7Str];
            [startUpFollowCountArrayFromDB addObject:str7];
            
            char *field8 = (char *) sqlite3_column_text(statement,7);
            NSString *field8Str = [[NSString alloc] initWithUTF8String:field8];
            NSString *str8 = [[NSString alloc] initWithFormat:@"%@", field8Str];
            [startUpLocationsArrayFromDB addObject:str8];
            
            char *field9 = (char *) sqlite3_column_text(statement,8);
            NSString *field9Str = [[NSString alloc] initWithUTF8String:field9];
            NSString *str9 = [[NSString alloc] initWithFormat:@"%@", field9Str];
            [startUpMarketsArrayFromDB addObject:str9];
            
            char *field10 = (char *) sqlite3_column_text(statement,9);
            NSString *field10Str = [[NSString alloc] initWithUTF8String:field10];
            NSString *str10 = [[NSString alloc] initWithFormat:@"%@", field10Str];
            [startUpImageDisplayArrayFromDB addObject:str10];
            
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

-(void) deleteRowsFromPortfolio
{
    char *err;
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM Portfolio"];
    
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) 
    { 
        sqlite3_close(db);
        NSAssert(0, @"Error Deleting to Rows of Portfolio");
    }
}
//end portfolio

//for user
//Table for User
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

-(int) retrieveNoOfRowsOfUser
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
            NSString *str1 = [[NSString alloc] initWithFormat:@"%@", field1Str];//username

            
            char *field2 = (char *) sqlite3_column_text(statement,1);
            NSString *field2Str = [[NSString alloc] initWithUTF8String:field2];
            NSString *str2 = [[NSString alloc] initWithFormat:@"%@", field2Str];//userID

            
            char *field3 = (char *) sqlite3_column_text(statement,2);
            NSString *field3Str = [[NSString alloc] initWithUTF8String:field3];
            NSString *str3 = [[NSString alloc] initWithFormat:@"%@", field3Str];//accessToken

            
            char *field4 = (char *) sqlite3_column_text(statement,3);
            NSString *field4Str = [[NSString alloc] initWithUTF8String:field4];
            NSString *str4 = [[NSString alloc] initWithFormat:@"%@", field4Str];//email

            
            char *field5 = (char *) sqlite3_column_text(statement,4);
            NSString *field5Str = [[NSString alloc] initWithUTF8String:field5];
            NSString *str5 = [[NSString alloc] initWithFormat:@"%@", field5Str];//image

            
            char *field6 = (char *) sqlite3_column_text(statement,5);
            NSString *field6Str = [[NSString alloc] initWithUTF8String:field6];
            NSString *str6 = [[NSString alloc] initWithFormat:@"%@", field6Str];//follows
            
            [userDetailsArrayFromDB removeAllObjects];
            [userDetailsArrayFromDB addObjectsFromArray:[NSArray arrayWithObjects:str1,str2,str3,str4,str5,str6, nil]];
            
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

//Delete User from database
-(void) deleteUserFromDB
{
    NSString *sql = @"DELETE FROM User";
    char *err;
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) 
    {
        sqlite3_close(db);
        NSAssert(0, @"Error deleting User table."); 
    }     
}
//end user

//for Inbox
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

//Retrieve inbox details
-(void) retrieveInboxDetails
{
    [inboxThreadIdArrayFromDB removeAllObjects];
    [inboxTotalArrayFromDB removeAllObjects];
    [inboxViewedArrayFromDB removeAllObjects];
    
    NSString *sql = @"SELECT * FROM Inbox";
    
    sqlite3_stmt *statement;
    
    if(sqlite3_prepare_v2(db,[sql UTF8String],-1,&statement,nil) == SQLITE_OK)
    {
        while(sqlite3_step(statement) == SQLITE_ROW)
        {
            char *field1 = (char *) sqlite3_column_text(statement,0);
            NSString *field1Str = [[NSString alloc] initWithUTF8String:field1];
            NSString *str1 = [[NSString alloc] initWithFormat:@"%@", field1Str];
            [inboxThreadIdArrayFromDB addObject:str1];
            
            char *field2 = (char *) sqlite3_column_text(statement,1);
            NSString *field2Str = [[NSString alloc] initWithUTF8String:field2];
            NSString *str2 = [[NSString alloc] initWithFormat:@"%@", field2Str];
            [inboxTotalArrayFromDB addObject:str2];
            
            char *field3 = (char *) sqlite3_column_text(statement,2);
            NSString *field3Str = [[NSString alloc] initWithUTF8String:field3];
            NSString *str3 = [[NSString alloc] initWithFormat:@"%@", field3Str];
            [inboxViewedArrayFromDB addObject:str3];
            
            
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

-(void) deleteInboxFromDB
{
    NSString *ssql = @"DELETE  FROM Inbox";
    char *err;
    if (sqlite3_exec(db, [ssql UTF8String], NULL, NULL, &err) != SQLITE_OK) 
    {
        sqlite3_close(db);
        NSAssert(0, @"Error deleting table."); 
    }
}
//end Inbox

@end
