//
//  Database.m
//  TakeCaptureViewPic
//
//  Created by Liwei Lin on 10/18/12.
//  Copyright (c) 2012 Ajit Randhawa. All rights reserved.
//

#import "Database.h"
#import "sqlite3.h"
//#import "SDImageCache.h"
//#import "SDImageCacheDelegate.h"
//#import "SDWebImageManager.h"
#import "FMDatabase.h"


#define imageUrl @"http://173.15.239.213/PDF/getAllData.php"
#define headerUrl  @"http://173.15.239.213/screen/getAllHeaderTableData.php"

@implementation Database{
    NSString *databasePath;
   // NSString *imageUrl = @"http://173.15.239.213/screen/getAllData.php";
  
    
}
@synthesize databasePath=databasePath;

//create database connection and table
-(sqlite3 *) databaseConnection{
    sqlite3 *contactDB;
    // Get the documents directory
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"iOweiPay.sqlite"]];
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: databasePath ] == NO)
    {
		const char *dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
        {
            char *errMsg;
            const char *table_image = "CREATE TABLE IF NOT EXISTS pdfData (iid INTEGER PRIMARY KEY AUTOINCREMENT, filename TEXT, subTitle TEXT, filepath TEXT,tag TEXT,numberOfPage INTEGER DEFAULT(1) ,uploaded TEXT DEFAULT('YES'),updateMark Text DEFAULT ('NO'),DeleteMark TEXT DEFAULT('NO'))";
            if (sqlite3_exec(contactDB, table_image, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"file to create table!");
            }
            sqlite3_close(contactDB);
            
        } else {
            NSLog( @"Failed to open/create database");
        }
    }
    return contactDB;
}


// import database table data
- (void) createTableData
{
    sqlite3_stmt    *statement;
    sqlite3 *contactDB = [self databaseConnection];
    const char *dbpath = [databasePath UTF8String];
    NSMutableDictionary *dataDic =[[NSMutableDictionary alloc]init];
    NSMutableArray *tempArray =[self importDistanceDatabase:imageUrl];
    if ([tempArray count]>0) {
    
    for (int i=0; i<[tempArray count]; i++) {
    dataDic =[tempArray objectAtIndex:i];
   if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO pdfData (filename, subTitle, filepath,tag,numberOfPage) VALUES (\"%@\", \"%@\", \"%@\",\"%@\", \"%@\")", [dataDic objectForKey:@"filename"], [dataDic objectForKey:@"subTitle"],[dataDic objectForKey:@"filepath"],[dataDic objectForKey:@"tag"],[dataDic objectForKey:@"numberOfPage"]];
        
        const char *insert_stmt = [insertSQL UTF8String];
        
        sqlite3_prepare_v2(contactDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog( @"record added");
            
        } else {
            NSLog( @"Failed to add record");
        }
        sqlite3_finalize(statement);
        sqlite3_close(contactDB);
    }
  }

    }
}

// to get data from server
-(NSMutableArray *)importDistanceDatabase:(NSString *)url{
    NSURL *importUrl = [NSURL URLWithString:url];
    NSData *importData = [NSData dataWithContentsOfURL:importUrl];
    NSError *error;
    NSMutableArray *infoArray = [NSJSONSerialization JSONObjectWithData:importData options:kNilOptions error:&error];
    return infoArray;
}

-(NSMutableArray *)importDistanceDatabaseForHeaderTable:(NSString *)url{
    NSURL *importUrl = [NSURL URLWithString:url];
    NSData *importData = [NSData dataWithContentsOfURL:importUrl];    
    NSError *error;
    NSMutableArray *infoArray = [NSJSONSerialization JSONObjectWithData:importData options:kNilOptions error:&error];
    return infoArray;
}

- (BOOL) checkImportOrNot
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    sqlite3 *contactDB =[self databaseConnection];
    int numberOfData;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT count(*) FROM pdfData"];// WHERE name=\"%@\"", @"zhu"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            //if (sqlite3_step(statement) == SQLITE_ROW)
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
               // NSString *numberOfData = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                numberOfData = [[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)] intValue];
               // NSLog(@"----%d",numberOfData);
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    
    if (numberOfData>0) {
        return NO;
    }else
    return YES;
}


-(NSMutableArray *)fetchData:(NSString *)sqlString{
    NSMutableArray *dataArray = [[NSMutableArray alloc]init];
    [self databaseConnection];
    NSMutableDictionary *dataDic ;//= [[NSMutableDictionary alloc]init];
    FMDatabase *db= [FMDatabase databaseWithPath:databasePath] ;
    if (![db open]) {
        NSLog(@"Could not open db.");
        //return ;
    }
    FMResultSet *rs=[db executeQuery:sqlString];
    while ([rs next]){
       // NSLog(@"%@",);
         dataDic = [[NSMutableDictionary alloc]init];
         [dataDic setObject:[rs stringForColumn:@"iid"] forKey:@"iid"];
         [dataDic setObject:[rs stringForColumn:@"filename"] forKey:@"filename"];
         [dataDic setObject:[rs stringForColumn:@"subTitle"] forKey:@"subTitle"];
         [dataDic setObject:[rs stringForColumn:@"filepath"] forKey:@"filepath"];
         [dataDic setObject:[rs stringForColumn:@"tag"] forKey:@"tag"];
         [dataDic setObject:[rs stringForColumn:@"numberOfPage"] forKey:@"numberOfPage"];
         [dataDic setObject:[rs stringForColumn:@"uploaded"] forKey:@"uploaded"];
      //  NSLog(@"%@",[rs stringForColumn:@"picOrder"]);
       
         [dataArray addObject:dataDic];
       
    }
    [rs close];
    [db close];
    return dataArray;
}

-(NSMutableArray*)fetchHeaderData:(NSString*)tag{
    NSMutableArray *headerData = [[NSMutableArray alloc]init];
    NSMutableDictionary *headerDic;
    FMDatabase *db= [FMDatabase databaseWithPath:[self getPath]] ;
    if (![db open]) {
        NSLog(@"Could not open db.");
        //return ;
    }
    
    FMResultSet *resultSet=[db executeQuery:@"select * from headerTable where tag=?",tag];
    while ([resultSet next]) {
        headerDic=[[NSMutableDictionary alloc]init];
         [headerDic setObject:[resultSet stringForColumn:@"iid"] forKey:@"iid"];
        [headerDic setObject:[resultSet stringForColumn:@"headerlabel"] forKey:@"headerlabel"];
         [headerDic setObject:[resultSet stringForColumn:@"subheaderlabel"] forKey:@"subheaderlabel"];
         [headerDic setObject:[resultSet stringForColumn:@"tag"] forKey:@"tag"];
        [headerData addObject:headerDic];
    }
    [resultSet close];
    [db close];
    
 //   NSLog(@"update header");
    return headerData;
}

// create an unique device id



-(void)insertData:(NSDate *)date:(NSObject *)existTag:(NSString*)numberOfPage{
    [self databaseConnection];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"iOweiPay.sqlite"]; 
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *filename = [NSString stringWithString:[dateFormatter stringFromDate:date]];
    NSString *tag ;
    [dateFormatter setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    if ([existTag isKindOfClass:[NSString class]]) {
        tag= (NSString*)existTag;
    }else if([existTag isKindOfClass:[NSDate class]]){
    tag = [NSString stringWithString:[dateFormatter stringFromDate:(NSDate *)existTag]];
    }
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *subtitle = [NSString stringWithString:[dateFormatter stringFromDate:date]];
    
    NSString *fullpath = [@"http://173.15.239.213/PDF/PDFS/" stringByAppendingFormat:@"%@%@",filename,@".PDF"];
    
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if (![db open]) {
        NSLog(@"Could not open db.");
    }

    
    NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO pdfData (filename, subTitle, filepath,tag,numberOfPage) VALUES (\"%@\", \"%@\", \"%@\",\"%@\",%@);", filename, subtitle,fullpath,tag,numberOfPage];
    if ([db executeUpdate:insertSQL]) {
        NSLog(@"insert  success!");
     }
    [db close];
}

-(NSString *)getPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"iOweiPay.sqlite"];
    return dbPath;
}


-(void)updateImageInof{
    NSMutableArray *checkArray= [self importDistanceDatabase:imageUrl];
    NSDictionary *checkDic;

    FMDatabase* db = [FMDatabase databaseWithPath:[self getPath]];
    int updateNo = 0;
    if (![db open]) {
        NSLog(@"Could not open db.");
    }
    NSString *checkString =[[NSString alloc]init] ;
   // FMResultSet *rs;
    //[self databaseConnection];
   // NSLog(@"%@",checkArray);
    for (int i=0; i<[checkArray count]; i++) {
       checkDic=[checkArray objectAtIndex:i];
        
        checkString=[@"select * from pdfData where filepath='" stringByAppendingFormat:@"%@%@",[checkDic objectForKey:@"filepath"],@"';"];
        //NSLog(@"%@",checkString);
        if(![[db executeQuery:checkString] next]) {
           checkString = [NSString stringWithFormat: @"INSERT INTO pdfData (filename, subTitle, filepath,tag,numberOfPage) VALUES (\"%@\", \"%@\", \"%@\",\"%@\",\"%@\");", [checkDic objectForKey:@"filename"], [checkDic objectForKey:@"subTitle"],[checkDic objectForKey:@"filepath"],[checkDic objectForKey:@"tag"],[checkDic objectForKey:@"numberOfPage"]];
          //  NSLog(@"%@",checkString);
            [db executeUpdate:checkString];
            
        }else{
            updateNo++;
            if (updateNo == [checkArray count]) {
                NSLog(@"no image information update!!");
            }
        
        }
    
    }


    [db close];

}

//check if there are some delete pic are delete from user device and not delete from server 
-(void)checkDeleteItem{
    FMDatabase* db = [FMDatabase databaseWithPath:[self getPath]];
    NSMutableArray *deleteItemCheck = [self importDistanceDatabase:imageUrl];
    NSMutableDictionary *deleteDic = [[NSMutableDictionary alloc]init];
    if (![db open]) {
        NSLog(@"could not open database!");
    }
   
    FMResultSet *resultSet = [db executeQuery:@"select * from pdfData"];
   while([resultSet next]){
        NSString  *flag=@"delete";
        for (int i=0; i<[deleteItemCheck count]; i++) {
            deleteDic = [deleteItemCheck objectAtIndex:i];
          //  NSLog(@"%@",[resultSet stringForColumn:@"filepath"]);
            if ([[deleteDic objectForKey:@"fullpath" ] isEqualToString: [resultSet stringForColumn:@"filepath"]]) {
              //  [deleteItemCheck removeObjectAtIndex:i];
                flag = @"notDelete";
              //  NSLog(@"image exist!");
            }
        }
       if ([flag isEqualToString:@"delete"]) {
           NSLog(@"no image exist!");
           NSString *deleteString = [@"delete from pdfData where filepath='" stringByAppendingFormat:@"%@' and uploaded = 'YES' ",[resultSet stringForColumn:@"filepath"]];
          // NSLog(@"%@",deleteString);
           [db executeUpdate:deleteString];
          // flag = @"delete";
          // NSLog(@"%@",deleteString);
           
       }
   
   }
    [resultSet close];
    
     [db close];
}

//delete items 
-(void)deleteItem:(NSString*)urString{
    FMDatabase *db = [FMDatabase databaseWithPath:[self getPath]];
    if (![db open]) {
        NSLog(@"could not open Database!");
    }
    NSString *deleteString=[@"delete from pdfData where filepath='" stringByAppendingFormat:@"%@'",urString];
    if ([db executeUpdate:deleteString]) {
       //   [[SDImageCache sharedImageCache]removeImageForKey:urString];
        NSLog(@"delete successful!");
    }
    else{
        NSLog(@"no record to delete!");
    }
    
    [db close];
}

-(void)noNetworkDelteItem:(NSString *)urlString:(NSString*)type{
    FMDatabase *db = [FMDatabase databaseWithPath:[self getPath]];
    if (![db open]) {
        NSLog(@"could not open Database!");
    }
   
         [db executeUpdate:@"update pdfData set DeleteMark='YES' where filepath=?",urlString];
    
    [db close];
   
}

-(void)deleteWholeFolder:(NSString *)folderTag{
    FMDatabase *db = [FMDatabase databaseWithPath:[self getPath]];
    if (![db open]) {
        NSLog(@"could not open Database!");
    }
  
    
    NSString *deleteString=[@"delete from image where tag='" stringByAppendingFormat:@"%@'",folderTag];
      NSLog(@"%@",deleteString);
    if ([db executeUpdate:deleteString]) {
        [db executeUpdate:@"delete from headerTable where tag=?",folderTag];
        NSLog(@"delete successful!");
    }
    else{
        NSLog(@"no record to delete!");
    }
    [db close];

}
-(FMDatabase *)getDatabase{
    FMDatabase *db =[FMDatabase databaseWithPath:[self getPath]];
    if (![db open]) {
        NSLog(@"%@",@"could not open database");
    }
    return db;
}

-(int)numberOfData{
    FMDatabase *db =[FMDatabase databaseWithPath:[self getPath]];
    if (![db open]) {
        NSLog(@"%@",@"could not open database");
    }
    FMResultSet *rs = [db executeQuery:@"select count(*) as number from pdfData"];
    int number;
    while ([rs next]) {
        
        number = [rs intForColumn:@"number"];
        
    }
    [rs close];
    [db close];
    return number;
    
}
-(BOOL)updateNumberOfPageForPDF:(NSString*)url{
    return [[self getDatabase] executeUpdate:@"update pdfData set numberOfPage=? where filepath=",url];
}
-(void)MoveItem:(NSString *)moveType:(NSString *)moveURL:(NSString*)tag{
    FMDatabase *db =[FMDatabase databaseWithPath:[self getPath]];
    if (![db open]) {
        NSLog(@"%@",@"could not open database");
    }
    NSMutableArray *moveArray=[[NSMutableArray alloc]init];
    NSMutableDictionary *moveDic;// =[[NSMutableDictionary alloc]init];
    if ([moveType isEqualToString:@"exist"]) {
        FMResultSet *resultSet=[db executeQuery:@"select * from image where tag=? order by picOrder",tag];
       // NSLog(@"%@",tag);
        while ([resultSet next]) {
          //  int order=(int)[resultSet stringForColumn:@"picOrder"]+1;
            //NSLog(@"%@",[resultSet stringForColumn:@"filepath"]);
            moveDic =[[NSMutableDictionary alloc]init];
            [moveDic setObject:[resultSet stringForColumn:@"picOrder"] forKey:@"picOrder"];
            [moveDic setObject:[resultSet stringForColumn:@"filepath"] forKey:@"filepath"];
          //  
            [moveArray addObject:moveDic];
        }
        for (int i=0; i<[moveArray count]; i++) {
            NSMutableDictionary *fetchArray = [moveArray objectAtIndex:i];
            int order = [[fetchArray objectForKey:@"picOrder"] intValue]+1;
            NSString *picOrder= [NSString stringWithFormat:@"%d",order];
           
            [db executeUpdate:@"update image set picOrder=? where tag=? and filepath=?",picOrder,tag,[fetchArray objectForKey:@"filepath"]];
            
        }
        
        [db executeUpdate:@"update image set picOrder=0 where tag=? and filepath=?",tag,moveURL];
      //  NSLog(@"%@",moveArray);
        NSLog(@"move to exist folder");
        
    }else if ([moveType isEqualToString:@"new"]){
      //  NSLog(@"%@",tag);
        FMResultSet *resultSet =[db executeQuery:@"select * from image where filepath=?",moveURL];
      //  NSLog(@"%@",moveURL);
        while ([resultSet next]) {
          //  NSLog(@"%@",[resultSet stringForColumn:@"filepath"]);
            [db executeUpdate:@"insert into headerTable(headerlabel,subheaderlabel,tag)values(?,?,?)",[resultSet stringForColumn:@"filename"],[resultSet stringForColumn:@"subTitle"],tag];
        }
        [resultSet close];
        NSLog(@"move to new!");
    }
    [db executeUpdate:@"update image set picOrder=0 ,tag=? where filepath=?",tag,moveURL];
    [db close];
}


-(void)MoveInsideFolder:(int)fromRow:(int)toRow:(NSMutableArray*)moveArray{
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc]init];
    FMDatabase *db =[FMDatabase databaseWithPath:[self getPath]];
    if (![db open]) {
        NSLog(@"%@",@"could not open database");
    }
    if(fromRow > toRow){
        int temp = toRow;
        for(int i=toRow;i<fromRow;i++){
            temp++;
            tempDic = [moveArray objectAtIndex:i];
            [db executeUpdate:@"update image set picOrder=? where filepath=?",[NSString stringWithFormat:@"%d",temp],[tempDic objectForKey:@"fullpath"]];
        }
       
        tempDic = [moveArray objectAtIndex:fromRow];
        [db executeUpdate:@"update image set picOrder=? where filepath=?",[NSString stringWithFormat:@"%d",toRow],[tempDic objectForKey:@"fullpath"]];
    }else if(fromRow <toRow){
        
        int tempOr1=fromRow;
        for(int i=fromRow+1;i<=toRow;i++){

             tempDic = [moveArray objectAtIndex:i];
            NSLog(@"%d",tempOr1);
          
            [db executeUpdate:@"update image set picOrder=? where filepath=?",[NSString stringWithFormat:@"%d",tempOr1],[tempDic objectForKey:@"fullpath"]];
            tempOr1++;
        }
      
        tempDic = [moveArray objectAtIndex:fromRow];
        [db executeUpdate:@"update image set picOrder=? where filepath=?",[NSString stringWithFormat:@"%d",toRow],[tempDic objectForKey:@"fullpath"]];
    }
    
    [db close];
}

-(void)changeTile:(NSString*)tag:(NSString*)newText{
   
    FMDatabase *db =[FMDatabase databaseWithPath:[self getPath]];
    if (![db open]) {
        NSLog(@"%@",@"could not open database");
    }
    
    [db executeUpdate:@"update headerTable set headerlabel=? where tag=?",newText,tag];
}

-(void)changeSubTile:(NSString*)tag:(NSString*)newText{
    
    FMDatabase *db =[FMDatabase databaseWithPath:[self getPath]];
    if (![db open]) {
        NSLog(@"%@",@"could not open database");
    }
    
    [db executeUpdate:@"update headerTable set subheaderlabel=? where tag=?",newText,tag];
}

@end
