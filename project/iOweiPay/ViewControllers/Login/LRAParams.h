//
//  LRAParams.h
//  loginMain2
//
//  Created by Ajit Randhawa on 7/19/12.
//  Copyright (c) 2012 Ajit Randhawa. All rights reserved.
//

#import <Foundation/Foundation.h>

//strings for the field names in the user credentials section
//and the matching field name in the POST data array
extern NSString * const F_EMAIL, * const POST_EMAIL;
extern NSString * const F_PASSWORD, * const POST_PASSWORD;
extern NSString * const F_CONFIRM_PASSWORD, * const POST_CONFIRM_PASSWORD;

//strings for the field names in the account type section
//and the matching field name in the POST data array
extern NSString * const F_ACCOUNT_TYPE, * const POST_ACCOUNT_TYPE;

//strings for the field names in the business info section
//and the matching field name in the POST data array
extern NSString * const F_COMPANY_NAME, * const POST_COMPANY_NAME;
extern NSString * const F_FEDERAL_TAX_ID, * const POST_FEDERAL_TAX_ID;

//strings for the field names in the personal info section
//and the matching field name in the POST data array
extern NSString * const F_FIRST_NAME, * const POST_FIRST_NAME;
extern NSString * const F_LAST_NAME, * const POST_LAST_NAME;
extern NSString * const F_MID_INITIAL, * const POST_MID_INITIAL;
extern NSString * const F_SEX, * const POST_SEX;
extern NSString * const F_BIRTH_DATE, * const POST_BIRTH_DATE;
extern NSString * const F_CELL_PHONE, * const POST_CELL_PHONE;

//strings for the field names in the billing address section
//and the matching field name in the POST data array
extern NSString * const F_ADDRESS1, * const POST_ADDRESS1;
extern NSString * const F_ADDRESS2, * const POST_ADDRESS2;
extern NSString * const F_CITY, * const POST_CITY;
extern NSString * const F_STATE, * const POST_STATE;
extern NSString * const F_ZIP_CODE, * const POST_ZIP_CODE;

//a dictionary that contains the mappings from the field names
//to the POST variable names
extern NSDictionary * MAP_POST_NAMES;

//list of URL strings for the login, registration, and activation scripts
extern NSString * const URL_LOGIN;
extern NSString * const URL_ACTIVATE;
extern NSString * const URL_PASSRESET;

@interface LRAParams : NSObject {

    
}

//a function to build the field names to POST names map
+ (void) mapFields;

@end


