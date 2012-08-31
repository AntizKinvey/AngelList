//
//  DBManager.h
//  TableProj
//
//  Created by Ram Charan on 8/23/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"

@interface DBManager : NSObject
{
    sqlite3 *db;
    //for activity
    NSMutableArray *feedDescDisplayArrayFromDB;
    NSMutableArray *feedIdArrayFromDB;
    NSMutableArray *feedItemTypeArrayFromDB;
    NSMutableArray *actorNameArrayFromDB;
    NSMutableArray *feedActorImageDisplayArrayFromDB;
    NSMutableArray *actorLinkArrayFromDB;
    NSMutableArray *actorTaglineArrayFromDB;
    NSMutableArray *targetNameArrayFromDB;
    NSMutableArray *feedTargetImageDisplayArrayFromDB;
    NSMutableArray *targetLinkArrayFromDB;
    NSMutableArray *targetTaglineArrayFromDB;
    NSMutableArray *actorImageUrlArrayFromDB;
    NSMutableArray *targetImageUrlArrayFromDB;
    //end activity
    
    //for trending
    NSMutableArray *startUpIdArrayFromDB;
    NSMutableArray *startUpNameArrayFromDB;
    NSMutableArray *startUpLinkArrayFromDB;
    NSMutableArray *startUpImageUrlArrayFromDB;
    NSMutableArray *startUpProdDescArrayFromDB;
    NSMutableArray *startUpHighConceptArrayFromDB;
    NSMutableArray *startUpFollowCountArrayFromDB;
    NSMutableArray *startUpLocationsArrayFromDB;
    NSMutableArray *startUpMarketsArrayFromDB;
    NSMutableArray *startUpImageDisplayArrayFromDB;
    //end trending
    
    //for user
    NSMutableArray *userDetailsArrayFromDB;
    //end user
    
    //for Inbox
    NSMutableArray *inboxTotalArrayFromDB; // total count of messages in inbox
    NSMutableArray *inboxThreadIdArrayFromDB; // thread ids from database
    NSMutableArray *inboxViewedArrayFromDB; // status of a inbox messages
    //end Inbox
}
//for activity
@property (retain) NSMutableArray *feedDescDisplayArrayFromDB;
@property (retain) NSMutableArray *feedIdArrayFromDB;
@property (retain) NSMutableArray *feedItemTypeArrayFromDB;
@property (retain) NSMutableArray *actorNameArrayFromDB;
@property (retain) NSMutableArray *feedActorImageDisplayArrayFromDB;
@property (retain) NSMutableArray *actorLinkArrayFromDB;
@property (retain) NSMutableArray *actorTaglineArrayFromDB;
@property (retain) NSMutableArray *targetNameArrayFromDB;
@property (retain) NSMutableArray *feedTargetImageDisplayArrayFromDB;
@property (retain) NSMutableArray *targetLinkArrayFromDB;
@property (retain) NSMutableArray *targetTaglineArrayFromDB;
@property (retain) NSMutableArray *actorImageUrlArrayFromDB;
@property (retain) NSMutableArray *targetImageUrlArrayFromDB;
//end activity

//for trending
@property (retain) NSMutableArray *startUpIdArrayFromDB;
@property (retain) NSMutableArray *startUpNameArrayFromDB;
@property (retain) NSMutableArray *startUpLinkArrayFromDB;
@property (retain) NSMutableArray *startUpImageUrlArrayFromDB;
@property (retain) NSMutableArray *startUpProdDescArrayFromDB;
@property (retain) NSMutableArray *startUpHighConceptArrayFromDB;
@property (retain) NSMutableArray *startUpFollowCountArrayFromDB;
@property (retain) NSMutableArray *startUpLocationsArrayFromDB;
@property (retain) NSMutableArray *startUpMarketsArrayFromDB;
@property (retain) NSMutableArray *startUpImageDisplayArrayFromDB;
//end trending

//for user
@property (retain) NSMutableArray *userDetailsArrayFromDB;
//end user

//for Inbox
@property (retain) NSMutableArray *inboxTotalArrayFromDB; // total count of messages in inbox
@property (retain) NSMutableArray *inboxThreadIdArrayFromDB; // thread ids from database
@property (retain) NSMutableArray *inboxViewedArrayFromDB; // status of a inbox messages
//end Inbox

-(void) openDB;

//for Activity
-(void) createTableActivity:(NSString *)tableName withField1:(NSString *)field1 withField2:(NSString *)field2 withField3:(NSString *)field3 withField4:(NSString *)field4 withField5:(NSString *)field5 withField6:(NSString *)field6 withField7:(NSString *)field7 withField8:(NSString *)field8 withField9:(NSString *)field9 withField10:(NSString *)field10 withField11:(NSString *)field11 withField12:(NSString *)field12 withField13:(NSString *)field13 withField14:(NSString *)field14;


-(void) insertRecordIntoActivityTable:(NSString *)tableName withField1: (NSString *) field1 field1Value: (NSString *) field1Value andField2: (NSString *) field2 field2Value: (NSString *) field2Value andField3: (NSString *) field3 field3Value: (NSString *) field3Value andField4: (NSString *) field4 field4Value: (NSString *) field4Value andField5: (NSString *) field5 field5Value: (NSString *) field5Value andField6: (NSString *) field6 field6Value: (NSString *) field6Value andField7: (NSString *) field7 field7Value: (NSString *) field7Value andField8: (NSString *) field8 field8Value: (NSString *) field8Value andField9: (NSString *) field9 field9Value: (NSString *) field9Value andField10: (NSString *) field10 field10Value: (NSString *) field10Value andField11: (NSString *) field11 field11Value: (NSString *) field11Value andField12: (NSString *) field12 field12Value: (NSString *) field12Value andField13: (NSString *) field13 field13Value: (NSString *) field13Value andField14: (NSString *) field14 field14Value: (NSString *) field14Value;


-(void) retrieveActivityDetails;

-(void) deleteRowsFromActivity;
//end Activity


-(void) createTableTrendingStartUps:(NSString *)tableName withField1:(NSString *)field1 withField2:(NSString *)field2 withField3:(NSString *)field3 withField4:(NSString *)field4 withField5:(NSString *)field5 withField6:(NSString *)field6 withField7:(NSString *)field7 withField8:(NSString *)field8 withField9:(NSString *)field9 withField10:(NSString *)field10 withField11:(NSString *)field11;

-(void) insertRecordIntoTrendingTable:(NSString *)tableName withField1: (NSString *) field1 field1Value: (NSString *) field1Value andField2: (NSString *) field2 field2Value: (NSString *) field2Value andField3: (NSString *) field3 field3Value: (NSString *) field3Value andField4: (NSString *) field4 field4Value: (NSString *) field4Value andField5: (NSString *) field5 field5Value: (NSString *) field5Value andField6: (NSString *) field6 field6Value: (NSString *) field6Value andField7: (NSString *) field7 field7Value: (NSString *) field7Value andField8: (NSString *) field8 field8Value: (NSString *) field8Value andField9: (NSString *) field9 field9Value: (NSString *) field9Value andField10: (NSString *) field10 field10Value: (NSString *) field10Value andField11: (NSString *) field11 field11Value: (NSString *) field11Value;

-(void) retrieveTrendingDetails;

-(void) deleteRowsFromTrending;
//end trending

//for following
-(void) createTableFollowingStartUps:(NSString *)tableName withField1:(NSString *)field1 withField2:(NSString *)field2 withField3:(NSString *)field3 withField4:(NSString *)field4 withField5:(NSString *)field5 withField6:(NSString *)field6 withField7:(NSString *)field7 withField8:(NSString *)field8 withField9:(NSString *)field9 withField10:(NSString *)field10 withField11:(NSString *)field11;

-(void) insertRecordIntoFollowingTable:(NSString *)tableName withField1: (NSString *) field1 field1Value: (NSString *) field1Value andField2: (NSString *) field2 field2Value: (NSString *) field2Value andField3: (NSString *) field3 field3Value: (NSString *) field3Value andField4: (NSString *) field4 field4Value: (NSString *) field4Value andField5: (NSString *) field5 field5Value: (NSString *) field5Value andField6: (NSString *) field6 field6Value: (NSString *) field6Value andField7: (NSString *) field7 field7Value: (NSString *) field7Value andField8: (NSString *) field8 field8Value: (NSString *) field8Value andField9: (NSString *) field9 field9Value: (NSString *) field9Value andField10: (NSString *) field10 field10Value: (NSString *) field10Value andField11: (NSString *) field11 field11Value: (NSString *) field11Value;

-(void) retrieveFollowingDetails;

-(void) deleteRowsFromFollowing;

//end following

//for portfolio
-(void) createTablePortfolioStartUps:(NSString *)tableName withField1:(NSString *)field1 withField2:(NSString *)field2 withField3:(NSString *)field3 withField4:(NSString *)field4 withField5:(NSString *)field5 withField6:(NSString *)field6 withField7:(NSString *)field7 withField8:(NSString *)field8 withField9:(NSString *)field9 withField10:(NSString *)field10 withField11:(NSString *)field11;

-(void) insertRecordIntoPortfolioTable:(NSString *)tableName withField1: (NSString *) field1 field1Value: (NSString *) field1Value andField2: (NSString *) field2 field2Value: (NSString *) field2Value andField3: (NSString *) field3 field3Value: (NSString *) field3Value andField4: (NSString *) field4 field4Value: (NSString *) field4Value andField5: (NSString *) field5 field5Value: (NSString *) field5Value andField6: (NSString *) field6 field6Value: (NSString *) field6Value andField7: (NSString *) field7 field7Value: (NSString *) field7Value andField8: (NSString *) field8 field8Value: (NSString *) field8Value andField9: (NSString *) field9 field9Value: (NSString *) field9Value andField10: (NSString *) field10 field10Value: (NSString *) field10Value andField11: (NSString *) field11 field11Value: (NSString *) field11Value;

-(void) retrievePortfolioDetails;

-(void) deleteRowsFromPortfolio;
//end portfolio

//for user
-(void) createTableUser:(NSString *) tableName withField1:(NSString *) field1 withField2:(NSString *) field2 withField3:(NSString *) field3 withField4:(NSString *)field4 withField5:(NSString *)field5 withField6:(NSString *)field6 withField7:(NSString *)field7;

-(void) insertRecordIntoUserTable: (NSString *) tableName withField1: (NSString *) field1 field1Value: (NSString *) field1Value andField2: (NSString *) field2 field2Value: (NSString *) field2Value andField3: (NSString *) field3 field3Value: (NSString *) field3Value andField4: (NSString *) field4 field4Value: (NSString *)field4Value andField5: (NSString *) field5 field5Value: (NSString *) field5Value andField6: (NSString *) field6 field6Value: (NSString *) field6Value andField7: (NSString *) field7 field7Value: (NSString *) field7Value;

// Retrieve number of rows in User table
-(int) retrieveNoOfRowsOfUser;

// Retrieve User details
-(void) retrieveUserDetails;

-(void) deleteUserFromDB;
//end user

//for Inbox
-(void) createTableInboxDetails:(NSString *)tableName withField1:(NSString *)field1 withField2:(NSString *)field2 withField3:(NSString *)field3;

-(void) insertRecordIntoInbox: (NSString *) tableName withField1: (NSString *) field1 field1Value: (NSString *) field1Value andField2: (NSString *) field2 field2Value: (NSString *) field2Value andField3: (NSString *) field3 field3Value: (NSString *) field3Value;

-(void) updateRecordIntoInboxTable: (NSString *) tableName withField1: (NSString *) field1 field1Value: (NSString *) field1Value andField2: (NSString *) field2 field2Value: (NSString *) field2Value andField3: (NSString *) field3 field3Value: (NSString *) field3Value;

-(void) updateStatusIntoInboxTable: (NSString *) tableName withField1: (NSString *) field1 field1Value: (NSString *) field1Value andField2: (NSString *) field2 field2Value: (NSString *) field2Value;

-(void) retrieveInboxDetails;

-(void) deleteInboxFromDB;
//end Inbox

@end
