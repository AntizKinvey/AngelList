//
//  DBManager.h
//  WhackAVC
//
//  
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"

@interface DBManager : NSObject
{
    sqlite3 *db;
    
    NSMutableArray *feedImagesArrayFromDirectoryFromDB;
    NSMutableArray *actorTypeArrayFromDB;
    NSMutableArray *actorIdArrayFromDB;
    NSMutableArray *actorNameArrayFromDB;
    NSMutableArray *actorUrlArrayFromDB;
    NSMutableArray *actorTaglineArrayFromDB;
    NSMutableArray *feedDescDisplayArrayFromDB;
    NSMutableArray *feedImageArrayFromDB;
    
    NSMutableArray *startUpIdsArrayFromDB;
    NSMutableArray *startUpNameArrayFromDB;
    NSMutableArray *startUpAngelUrlArrayFromDB;
    NSMutableArray *startUpLogoUrlArrayFromDB;
    NSMutableArray *startUpProductDescArrayFromDB;
    NSMutableArray *startUpHighConceptArrayFromDB;
    NSMutableArray *startUpFollowerCountArrayFromDB;
    NSMutableArray *startUpLocationArrayFromDB;
    NSMutableArray *startUpMarketArrayFromDB;
    NSMutableArray *startUpLogoImageInDirectoryFromDB;
    
    NSMutableArray *inboxTotalFromDB;
    NSMutableArray *inboxThreadIdFromDB;
    NSMutableArray *inboxViewedFromDB;
    
}

@property(nonatomic, retain) NSMutableArray *inboxTotalFromDB;
@property(nonatomic, retain) NSMutableArray *inboxThreadIdFromDB;
@property(nonatomic, retain) NSMutableArray *inboxViewedFromDB;

@property (retain) NSMutableArray *feedImagesArrayFromDirectoryFromDB;
@property (retain) NSMutableArray *actorTypeArrayFromDB;
@property (retain) NSMutableArray *actorIdArrayFromDB;
@property (retain) NSMutableArray *actorNameArrayFromDB;
@property (retain) NSMutableArray *actorUrlArrayFromDB;
@property (retain) NSMutableArray *actorTaglineArrayFromDB;
@property (retain) NSMutableArray *feedDescDisplayArrayFromDB;
@property (retain) NSMutableArray *feedImageArrayFromDB;

@property (retain) NSMutableArray *startUpIdsArrayFromDB;
@property (retain) NSMutableArray *startUpNameArrayFromDB;
@property (retain) NSMutableArray *startUpAngelUrlArrayFromDB;
@property (retain) NSMutableArray *startUpLogoUrlArrayFromDB;
@property (retain) NSMutableArray *startUpProductDescArrayFromDB;
@property (retain) NSMutableArray *startUpHighConceptArrayFromDB;
@property (retain) NSMutableArray *startUpFollowerCountArrayFromDB;
@property (retain) NSMutableArray *startUpLocationArrayFromDB;
@property (retain) NSMutableArray *startUpMarketArrayFromDB;
@property (retain) NSMutableArray *startUpLogoImageInDirectoryFromDB;

//To check filePath
-(NSString *)filePath;
//---create database---
-(void) openDB;

//Table for User
-(void) createTableUser:(NSString *) tableName withField1:(NSString *) field1 withField2:(NSString *) field2 withField3:(NSString *) field3 withField4:(NSString *)field4;

//Table for Activity
-(void) createTableActivity:(NSString *)tableName withField1:(NSString *)field1 withField2:(NSString *)field2 withField3:(NSString *)field3 withField4:(NSString *)field4 withField5:(NSString *)field5 withField6:(NSString *)field6 withField7:(NSString *)field7 withField8:(NSString *)field8 withField9:(NSString *)field9;

//Table for StartUps
-(void) createTableStartUps:(NSString *)tableName withField1:(NSString *)field1 withField2:(NSString *)field2 withField3:(NSString *)field3 withField4:(NSString *)field4 withField5:(NSString *)field5 withField6:(NSString *)field6 withField7:(NSString *)field7 withField8:(NSString *)field8 withField9:(NSString *)field9 withField10:(NSString *)field10 withField11:(NSString *)field11;

//Table for StartUps Following
-(void) createTableStartUpsFollowing:(NSString *)tableName withField1:(NSString *)field1 withField2:(NSString *)field2 withField3:(NSString *)field3 withField4:(NSString *)field4 withField5:(NSString *)field5 withField6:(NSString *)field6 withField7:(NSString *)field7 withField8:(NSString *)field8 withField9:(NSString *)field9 withField10:(NSString *)field10 withField11:(NSString *)field11;

//Table for Portfolio Following
-(void) createTableStartUpsPortfolio:(NSString *)tableName withField1:(NSString *)field1 withField2:(NSString *)field2 withField3:(NSString *)field3 withField4:(NSString *)field4 withField5:(NSString *)field5 withField6:(NSString *)field6 withField7:(NSString *)field7 withField8:(NSString *)field8 withField9:(NSString *)field9 withField10:(NSString *)field10 withField11:(NSString *)field11;

//Table for message status
-(void) createTableInboxDetails:(NSString *)tableName withField1:(NSString *)field1 withField2:(NSString *)field2 withField3:(NSString *)field3;

//Insert Values to User Table
-(void) insertRecordIntoUserTable: (NSString *) tableName withField1: (NSString *) field1 field1Value: (NSString *) field1Value andField2: (NSString *) field2 field2Value: (NSString *) field2Value andField3: (NSString *) field3 field3Value: (NSString *) field3Value andField4: (NSString *) field4 field4Value: (NSString *) field4Value;



//Insert Values to Activity Table
-(void) insertRecordIntoActivityTable:(NSString *)tableName withField1: (NSString *) field1 field1Value: (NSString *) field1Value andField2: (NSString *) field2 field2Value: (NSString *) field2Value andField3: (NSString *) field3 field3Value: (NSString *) field3Value andField4: (NSString *) field4 field4Value: (NSString *) field4Value andField5: (NSString *) field5 field5Value: (NSString *) field5Value andField6: (NSString *) field6 field6Value: (NSString *) field6Value andField7: (NSString *) field7 field7Value: (NSString *) field7Value andField8: (NSString *) field8 field8Value: (NSString *) field8Value andField9: (NSString *) field9 field9Value: (NSString *) field9Value;


-(void) insertRecordIntoStartUpsTable:(NSString *)tableName field1Value:(NSString *)field1Value field2Value:(NSString *)field2Value field3Value:(NSString *)field3Value field4Value:(NSString *)field4Value field5Value:(NSString *)field5Value field6Value:(NSString *)field6Value field7Value:(NSString *)field7Value field8Value:(NSString *)field8Value field9Value:(NSString *)field9Value field10Value:(NSString *)field10Value field11Value:(NSString *)field11Value;

-(void) insertRecordIntoStartUpsFollowingTable:(NSString *)tableName field1Value:(NSString *)field1Value field2Value:(NSString *)field2Value field3Value:(NSString *)field3Value field4Value:(NSString *)field4Value field5Value:(NSString *)field5Value field6Value:(NSString *)field6Value field7Value:(NSString *)field7Value field8Value:(NSString *)field8Value field9Value:(NSString *)field9Value field10Value:(NSString *)field10Value field11Value:(NSString *)field11Value;

-(void) insertRecordIntoStartUpsPortfolioTable:(NSString *)tableName field1Value:(NSString *)field1Value field2Value:(NSString *)field2Value field3Value:(NSString *)field3Value field4Value:(NSString *)field4Value field5Value:(NSString *)field5Value field6Value:(NSString *)field6Value field7Value:(NSString *)field7Value field8Value:(NSString *)field8Value field9Value:(NSString *)field9Value field10Value:(NSString *)field10Value field11Value:(NSString *)field11Value;

-(void) insertRecordIntoInbox: (NSString *) tableName withField1: (NSString *) field1 field1Value: (NSString *) field1Value andField2: (NSString *) field2 field2Value: (NSString *) field2Value andField3: (NSString *) field3 field3Value: (NSString *) field3Value;


-(void) updateRecordIntoInboxTable: (NSString *) tableName withField1: (NSString *) field1 field1Value: (NSString *) field1Value andField2: (NSString *) field2 field2Value: (NSString *) field2Value andField3: (NSString *) field3 field3Value: (NSString *) field3Value;

-(void) updateStatusIntoInboxTable: (NSString *) tableName withField1: (NSString *) field1 field1Value: (NSString *) field1Value andField2: (NSString *) field2 field2Value: (NSString *) field2Value;

//Retrieve number of rows in User table
-(int) retrieveUserFromDB;

//Retrieve User details
-(void) retrieveUserDetails;

//Retrieve Activity details
-(void) retrieveActivityDetails;

//Retrieve StartUps details
-(void) retrieveStartUpsDetails;

-(void) retrieveStartUpsFollowingDetails;

-(void) retrieveStartUpsPortfolioDetails;

-(void) retrieveInboxDetails;

//Close database
-(void) closeDB;

@end
