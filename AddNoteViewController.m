//
//  AddNoteViewController.m
//  journal
//
//  Created by Ted Lee on 10/5/13.
//  Copyright (c) 2013 Ted Lee. All rights reserved.
//

#import "AddNoteViewController.h"
#import "sqlite3.h"

@interface AddNoteViewController ()


@end

@implementation AddNoteViewController
@synthesize tempF;
@synthesize condition;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad
 {
     [super viewDidLoad];
     NSURL *detailURL;
     NSString *detailURLString;
     detailURLString=[[NSString alloc] initWithFormat:@"http://weather.yahooapis.com/forecastrss?w=2377543"];
     
     detailURL=[[NSURL alloc]initWithString:detailURLString];
     
     NSString *htmlString=[NSString stringWithContentsOfURL:detailURL encoding:NSUTF8StringEncoding error:nil];
     NSRange range1 = [htmlString rangeOfString:@"<yweather:condition"];
     
     NSRange range2 = [htmlString rangeOfString:@"EDT\""];
     
     NSString *bodyString = [htmlString substringWithRange:NSMakeRange(range1.location, range2.location-range1.location+range2.length)];

     NSArray *array = [bodyString componentsSeparatedByString:@"="];
     NSLog(@"=========array:%@==========",array);
     NSString *temp1=[array objectAtIndex:1];
     NSString *condition1=[array objectAtIndex:3];
     
     NSArray *array1=[temp1 componentsSeparatedByString:@"\""];
     NSArray *array2=[condition1 componentsSeparatedByString:@"\""];
     condition=[array1 objectAtIndex:1];
     NSString *temp=[array2 objectAtIndex:1];
     tempF=[temp stringByAppendingString:@" F"];
     NSLog(@"condition is %@",condition);
     NSLog(@"tempF is %@",tempF);
     noteDB=nil;
     databasePath=[NSHomeDirectory() stringByAppendingFormat:@"/Documents/data.sqlite"];
     NSLog(@"databse path is:%@",databasePath);
     //open database
     int result = sqlite3_open([databasePath UTF8String], &noteDB);
     if (result != SQLITE_OK)
     {
         NSLog(@"open database failed!");
         return;
     }
     //create table1
     NSString *sql_list = @"CREATE TABLE IF NOT EXISTS DairyList(ID INTEGER PRIMARY KEY AUTOINCREMENT,WHATTIME Text,TITLE TEXT)";
     
     NSString *sql_content = @"CREATE TABLE IF NOT EXISTS DairyContent(ID INTEGER PRIMARY KEY AUTOINCREMENT,WHATTIME Text,CONTENT TEXT)";
     
     NSString *sql_weather= @"CREATE TABLE IF NOT EXISTS DairyWeather(ID INTEGER PRIMARY KEY AUTOINCREMENT,whattime Text,condition TEXT,temp TEXT)";
     char *error;
     char *error2;
     char *error3;
     result=sqlite3_exec(noteDB, [sql_list UTF8String], NULL, NULL,&error);
     result=sqlite3_exec(noteDB, [sql_weather UTF8String],NULL, NULL, &error2);
     result=sqlite3_exec(noteDB, [sql_content UTF8String],NULL, NULL, &error3);
     
     if (result != SQLITE_OK)
     {
         NSLog(@"create table failed!");
         NSLog(@"%s",error);
         return;
     }
     sqlite3_close(noteDB);
     
     NSLog(@"SUccess!");
     //self.title=@"new add notebook";
     

 }
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)hideKeyboard:(id)sender {
    [self.addContent resignFirstResponder];
    [self.addTitle resignFirstResponder];
}

- (IBAction)addNote:(id)sender {
    char *errMsg;
    
    
    const char *dbpath=[databasePath UTF8String];
   
    NSString *nowTime=[NSDateFormatter localizedStringFromDate:[NSDate date] dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];

    if (sqlite3_open(dbpath, &noteDB)==SQLITE_OK) {
        NSString *titleWith=[self.addTitle.text stringByReplacingOccurrencesOfString:@"\"" withString:@"\"\""];
        NSString *insertList=[NSString stringWithFormat:@"INSERT INTO DairyList(WHATTIME,TITLE)VALUES(\"%@\",\"%@\")",nowTime,titleWith];
        
        NSString *insertWeather=[NSString stringWithFormat:@"INSERT INTO DairyWeather(whattime,condition,temp)VALUES(\"%@\",\"%@\",\"%@\")",nowTime,condition,tempF];
       
        NSString *contentWith=[self.addContent.text stringByReplacingOccurrencesOfString:@"\"" withString:@"\"\""];
        NSString *insertContent=[NSString stringWithFormat:@"INSERT INTO DairyContent(WHATTIME,CONTENT)VALUES(\"%@\",\"%@\")",nowTime,contentWith];
        
       
        
        const char *insert_weather=[insertWeather UTF8String];
        const char *insert_list=[insertList UTF8String];
        const char *insert_content=[insertContent UTF8String];
        
        if(sqlite3_exec(noteDB, insert_list, NULL, NULL, &errMsg)==SQLITE_OK&&sqlite3_exec(noteDB, insert_weather, NULL, NULL, &errMsg)==SQLITE_OK&&sqlite3_exec(noteDB, insert_content, NULL, NULL, &errMsg)==SQLITE_OK){
            self.addContent.text=@"";
            self.addTitle.text=@"";
            UIAlertView *infoalert;
            infoalert=[[UIAlertView alloc]initWithTitle:@"Congratulation!" message:@"Datebase is created successful!" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [infoalert show];
        }else{
            NSLog(@"insert error:%s",errMsg);
            sqlite3_free(errMsg);
        
        }
        sqlite3_close(noteDB);
        
        }
    
}
@end
