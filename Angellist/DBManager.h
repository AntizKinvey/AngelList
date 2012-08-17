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
    
    // for feeds
    NSMutableArray *feedImagesArrayFromDirectoryFromDB; // feed images
    NSMutableArray *actorTypeArrayFromDB; // type of actor either startup or user
    NSMutableArray *actorIdArrayFromDB; // actor id
    NSMutableArray *actorNameArrayFromDB;  // actor name
    NSMutableArray *actorUrlArrayFromDB; // actor URL array
    NSMutableArray *actorTaglineArrayFromDB; // actor tagline
    NSMutableArray *feedDescDisplayArrayFromDB; // feed description display array
    NSMutableArray *feedImageArrayFromDB; // feed image array from Database
    
    NSMutableArray *targetTypeArrayFromDB; // type of actor either startup or user
    NSMutableArray *targetIdArrayFromDB; // actor id
    NSMutableArray *targetNameArrayFromDB;  // actor name
    NSMutableArray *targetUrlArrayFromDB; // actor URL array
    NSMutableArray *targetTaglineArrayFromDB; // actor tagline
    NSMutableArray *targetImageArrayFromDB; // feed image array from Database
    
    // for startups
    NSMutableArray *startUpIdsArrayFromDB; // startup ids from database
    NSMutableArray *startUpNameArrayFromDB; // startup names from database
    NSMutableArray *startUpAngelUrlArrayFromDB; // angel URL from database
    NSMutableArray *startUpLogoUrlArrayFromDB; // startup logo URL from database
    NSMutableArray *startUpProductDescArrayFromDB; // startup product decription array from database
    NSMutableArray *startUpHighConceptArrayFromDB; // startup high concept array from database
    NSMutableArray *startUpFollowerCountArrayFromDB; // startup follower count array from database
    NSMutableArray *startUpLocationArrayFromDB; // startup location array from database
    NSMutableArray *startUpMarketArrayFromDB; // startup market array from database
    NSMutableArray *startUpLogoImageInDirectoryFromDB; // startup logo image from database
    
    // for inbox
    NSMutableArray *inboxTotalFromDB; // total count of messages in inbox
    NSMutableArray *inboxThreadIdFromDB; // thread ids from database
    NSMutableArray *inboxViewedFromDB; // status of a inbox messages
    
    NSMutableArray *userDetailsArray; // userDetails array
    
    NSMutableArray *feedTypeArrayFromDB;
    
    NSString *_angelUserIdFromDB;
    NSString *_angelUserNameFromDB;
    NSString *access_tokenFromDB;
    NSString *_angelUserFollowsFromDB;
    NSString *_angelUserImageFromDB;
    NSString *_angelUserEmailFromDB;
    
}

@property(nonatomic, retain) NSMutableArray *inboxTotalFromDB;
@property(nonatomic, retain) NSMutableArray *inboxThreadIdFromDB;
@property(nonatomic, retain) NSMutableArray *inboxViewedFromDB;
@property(nonatomic, retain) NSMutableArray *userDetailsArray;

@property(nonatomic, retain) NSString *_angelUserIdFromDB;
@property(nonatomic, retain) NSString *_angelUserNameFromDB;
@property(nonatomic, retain) NSString *access_tokenFromDB;
@property(nonatomic, retain) NSString *_angelUserFollowsFromDB;
@property(nonatomic, retain) NSString *_angelUserImageFromDB;
@property(nonatomic, retain) NSString *_angelUserEmailFromDB;


@property(nonatomic, retain) NSMutableArray *targetTypeArrayFromDB; // type of actor either startup or user
@property(nonatomic, retain) NSMutableArray *targetIdArrayFromDB; // actor id
@property(nonatomic, retain) NSMutableArray *targetNameArrayFromDB;  // actor name
@property(nonatomic, retain) NSMutableArray *targetUrlArrayFromDB; // actor URL array
@property(nonatomic, retain) NSMutableArray *targetTaglineArrayFromDB; // actor tagline
@property(nonatomic, retain) NSMutableArray *targetImageArrayFromDB; // feed image array from Database

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

@property (retain) NSMutableArray *feedTypeArrayFromDB;

//To check filePath
-(NSString *)filePath;

//---create database---
-(void) openDB;

// Table for User
-(void) createTableUser:(NSString *) tableName withField1:(NSString *) field1 withField2:(NSString *) field2 withField3:(NSString *) field3 withField4:(NSString *)field4 withField5:(NSString *)field5 withField6:(NSString *)field6 withField7:(NSString *)field7;

// Table for Activity
// create table for feeds
-(void) createTableActivity:(NSString *)tableName withField1:(NSString *)field1 withField2:(NSString *)field2 withField3:(NSString *)field3 withField4:(NSString *)field4 withField5:(NSString *)field5 withField6:(NSString *)field6 withField7:(NSString *)field7 withField8:(NSString *)field8 withField9:(NSString *)field9 withField10:(NSString *)field10 withField11:(NSString *)field11 withField12:(NSString *)field12 withField13:(NSString *)field13 withField14:(NSString *)field14 withField15:(NSString *)field15 withField16:(NSString *)field16;

// Table for StartUps
-(void) createTableStartUps:(NSString *)tableName withField1:(NSString *)field1 withField2:(NSString *)field2 withField3:(NSString *)field3 withField4:(NSString *)field4 withField5:(NSString *)field5 withField6:(NSString *)field6 withField7:(NSString *)field7 withField8:(NSString *)field8 withField9:(NSString *)field9 withField10:(NSString *)field10 withField11:(NSString *)field11;

// Table for StartUps Following
-(void) createTableStartUpsFollowing:(NSString *)tableName withField1:(NSString *)field1 withField2:(NSString *)field2 withField3:(NSString *)field3 withField4:(NSString *)field4 withField5:(NSString *)field5 withField6:(NSString *)field6 withField7:(NSString *)field7 withField8:(NSString *)field8 withField9:(NSString *)field9 withField10:(NSString *)field10 withField11:(NSString *)field11;

// Table for Portfolio Following
-(void) createTableStartUpsPortfolio:(NSString *)tableName withField1:(NSString *)field1 withField2:(NSString *)field2 withField3:(NSString *)field3 withField4:(NSString *)field4 withField5:(NSString *)field5 withField6:(NSString *)field6 withField7:(NSString *)field7 withField8:(NSString *)field8 withField9:(NSString *)field9 withField10:(NSString *)field10 withField11:(NSString *)field11;

// Create table startups in portfolio
-(void) createTableStartUpsTrending:(NSString *)tableName withField1:(NSString *)field1 withField2:(NSString *)field2 withField3:(NSString *)field3 withField4:(NSString *)field4 withField5:(NSString *)field5 withField6:(NSString *)field6 withField7:(NSString *)field7 withField8:(NSString *)field8 withField9:(NSString *)field9 withField10:(NSString *)field10 withField11:(NSString *)field11;

// Table for message status
-(void) createTableInboxDetails:(NSString *)tableName withField1:(NSString *)field1 withField2:(NSString *)field2 withField3:(NSString *)field3;

// Insert record into user table 
-(void) insertRecordIntoUserTable: (NSString *) tableName withField1: (NSString *) field1 field1Value: (NSString *) field1Value andField2: (NSString *) field2 field2Value: (NSString *) field2Value andField3: (NSString *) field3 field3Value: (NSString *) field3Value andField4: (NSString *) field4 field4Value: (NSString *)field4Value andField5: (NSString *) field5 field5Value: (NSString *) field5Value andField6: (NSString *) field6 field6Value: (NSString *) field6Value andField7: (NSString *) field7 field7Value: (NSString *) field7Value;


// Insert record into activity table 
-(void) insertRecordIntoActivityTable:(NSString *)tableName withField1: (NSString *) field1 field1Value: (NSString *) field1Value andField2: (NSString *) field2 field2Value: (NSString *) field2Value andField3: (NSString *) field3 field3Value: (NSString *) field3Value andField4: (NSString *) field4 field4Value: (NSString *) field4Value andField5: (NSString *) field5 field5Value: (NSString *) field5Value andField6: (NSString *) field6 field6Value: (NSString *) field6Value andField7: (NSString *) field7 field7Value: (NSString *) field7Value andField8: (NSString *) field8 field8Value: (NSString *) field8Value andField9: (NSString *) field9 field9Value: (NSString *) field9Value andField10: (NSString *) field10 field10Value: (NSString *) field10Value andField11: (NSString *) field11 field11Value: (NSString *) field11Value andField12: (NSString *) field12 field12Value: (NSString *) field12Value andField13: (NSString *) field13 field13Value: (NSString *) field13Value andField14: (NSString *) field14 field14Value: (NSString *) field14Value andField15: (NSString *) field15 field15Value: (NSString *) field15Value andField16: (NSString *) field16 field16Value: (NSString *) field16Value;

// Insert into startup table
-(void) insertRecordIntoStartUpsTable:(NSString *)tableName field1Value:(NSString *)field1Value field2Value:(NSString *)field2Value field3Value:(NSString *)field3Value field4Value:(NSString *)field4Value field5Value:(NSString *)field5Value field6Value:(NSString *)field6Value field7Value:(NSString *)field7Value field8Value:(NSString *)field8Value field9Value:(NSString *)field9Value field10Value:(NSString *)field10Value field11Value:(NSString *)field11Value;

// Insert into startup following table
-(void) insertRecordIntoStartUpsFollowingTable:(NSString *)tableName field1Value:(NSString *)field1Value field2Value:(NSString *)field2Value field3Value:(NSString *)field3Value field4Value:(NSString *)field4Value field5Value:(NSString *)field5Value field6Value:(NSString *)field6Value field7Value:(NSString *)field7Value field8Value:(NSString *)field8Value field9Value:(NSString *)field9Value field10Value:(NSString *)field10Value field11Value:(NSString *)field11Value;

// Insert into startup portfolio table
-(void) insertRecordIntoStartUpsPortfolioTable:(NSString *)tableName field1Value:(NSString *)field1Value field2Value:(NSString *)field2Value field3Value:(NSString *)field3Value field4Value:(NSString *)field4Value field5Value:(NSString *)field5Value field6Value:(NSString *)field6Value field7Value:(NSString *)field7Value field8Value:(NSString *)field8Value field9Value:(NSString *)field9Value field10Value:(NSString *)field10Value field11Value:(NSString *)field11Value;

// Insert number of rows in StartUp Trending table
-(void) insertRecordIntoStartUpsTrendingTable:(NSString *)tableName field1Value:(NSString *)field1Value field2Value:(NSString *)field2Value field3Value:(NSString *)field3Value field4Value:(NSString *)field4Value field5Value:(NSString *)field5Value field6Value:(NSString *)field6Value field7Value:(NSString *)field7Value field8Value:(NSString *)field8Value field9Value:(NSString *)field9Value field10Value:(NSString *)field10Value field11Value:(NSString *)field11Value;

// Insert into inbox table
-(void) insertRecordIntoInbox: (NSString *) tableName withField1: (NSString *) field1 field1Value: (NSString *) field1Value andField2: (NSString *) field2 field2Value: (NSString *) field2Value andField3: (NSString *) field3 field3Value: (NSString *) field3Value;

// Update into inbox table
-(void) updateRecordIntoInboxTable: (NSString *) tableName withField1: (NSString *) field1 field1Value: (NSString *) field1Value andField2: (NSString *) field2 field2Value: (NSString *) field2Value andField3: (NSString *) field3 field3Value: (NSString *) field3Value;

// update status inbox table
-(void) updateStatusIntoInboxTable: (NSString *) tableName withField1: (NSString *) field1 field1Value: (NSString *) field1Value andField2: (NSString *) field2 field2Value: (NSString *) field2Value;

// Retrieve number of rows in User table
-(int) retrieveUserFromDB;

// Retrieve User details
-(void) retrieveUserDetails;

// Retrieve Activity details
-(void) retrieveActivityDetails;

// Retrieve StartUps details
-(void) retrieveStartUpsDetails;

// retrieve startups Following details
-(void) retrieveStartUpsFollowingDetails;

// Retrieve startups portfolio details
-(void) retrieveStartUpsPortfolioDetails;

// retrieve startups following details
-(void) retrieveStartUpstrendingDetails;

// Retrieve inbox details
-(void) retrieveInboxDetails;


//Delete User from database
-(void) deleteUserFromDB;

//Delete Inbox from database
-(void) deleteFromInbox;

// Close database
-(void) closeDB;

@end
