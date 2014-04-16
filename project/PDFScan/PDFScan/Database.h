//
//  Database.h
//  TakeCaptureViewPic
//
//  Created by Liwei Lin on 10/18/12.
//  Copyright (c) 2012 Ajit Randhawa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"

@interface Database : NSObject{
    //NSString *moveType;
    
}
@property (nonatomic,retain)NSString *databasePath;
-(sqlite3 *) databaseConnection;
-(NSMutableArray *)importDistanceDatabase:(NSString *)url;
- (void) createTableData;
- (BOOL) checkImportOrNot;
-(NSMutableArray *)fetchData:(NSString *)sqlString;
-(void)insertData:(NSDate *)date:(NSObject *)existTag:(NSString*)numberOfPage;
-(void)updateImageInof;
-(void)checkDeleteItem;
-(NSString *)getPath;
-(void)deleteItem:(NSString*)urString;
-(void)deleteWholeFolder:(NSString *)folderTag;
-(void)MoveItem:(NSString *)moveType:(NSString *)moveURL:(NSString*)tag;
-(NSMutableArray *)importDistanceDatabaseForHeaderTable:(NSString *)url;
-(NSMutableArray*)fetchHeaderData:(NSString*)tag;
-(void)MoveInsideFolder:(int)fromRow:(int)toRow:(NSMutableArray*)moveArray;
-(void)changeTile:(NSString*)tag:(NSString*)newText;
-(void)changeSubTile:(NSString*)tag:(NSString*)newText;
-(void)noNetworkDelteItem:(NSString *)urlString:(NSString*)type;
-(int)numberOfData;
-(BOOL)updateNumberOfPageForPDF:(NSString*)url;
@end
