//
//  ListViewController.m
//  journal
//
//  Created by Ted Lee on 10/5/13.
//  Copyright (c) 2013 Ted Lee. All rights reserved.
//

#import "ListViewController.h"
#import "detailViewController.h"

@interface ListViewController ()

@end

@implementation ListViewController



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
	// Do any additional setup after loading the view.
    
    databasePath=[NSHomeDirectory() stringByAppendingFormat:@"/Documents/data.sqlite"];
    [self initializeDataToDisaplay];
    self.tableView.dataSource = self;
    [self.tableView reloadData];
    
}

- (void)viewWillAppear:(BOOL)animated {
    databasePath=[NSHomeDirectory() stringByAppendingFormat:@"/Documents/data.sqlite"];
    [self initializeDataToDisaplay];
//    self.tableView.dataSource = self;
    
    [self.tableView reloadData];
    
}


-(void)initializeDataToDisaplay
{
    self.noteArray=[[NSMutableArray alloc]init];
    const char *dbpath=[databasePath UTF8String];
    sqlite3_stmt *statement;
    
    
    if (sqlite3_open(dbpath, &noteDB)==SQLITE_OK) {
        NSString *querySql1=[NSString stringWithFormat:@"SELECT ID,WHATTIME,TITLE FROM DairyList"];
     //   NSString *querySql2=[NSString stringWithFormat:@"SELECT ID,WHATTIME,CONTENT FROM DairyList"];
        
        const char *query_stmt1=[querySql1 UTF8String];
       // const char *query_stmt2=[querySql2 UTF8String];
        if (sqlite3_prepare_v2(noteDB, query_stmt1, -1, &statement, NULL)==SQLITE_OK) {
            while (sqlite3_step(statement)==SQLITE_ROW)
            {
                NoteBookInfo *notebookInfo=[[NoteBookInfo alloc]init];
                notebookInfo.pk_id=sqlite3_column_int(statement,0);
                //notebookInfo.content=[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement,3)];
               // NSLog(@"statement3:content is %@",notebookInfo.content);
                notebookInfo.title=[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement,2)];
               // NSLog(@"statement2:title is %@",notebookInfo.title);
                notebookInfo.whattime=[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement,1)];
              //  NSLog(@"statement1:time is %@",notebookInfo.whattime);
                [self.noteArray addObject:notebookInfo];
            //    NSLog(@"====count:%d====",[self.noteArray count]);
            }
        }else
        {
            NSLog(@"Problem0 with prepare statement %s",sqlite3_errmsg(noteDB));
        }
        sqlite3_finalize(statement);
    }
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"count:%d",[self.noteArray count]);
    return [self.noteArray count];
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *noteCellIdentifier = @"noteCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:noteCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault reuseIdentifier:noteCellIdentifier];
    }
    cell.textLabel.text=((NoteBookInfo*)[self.noteArray objectAtIndex:indexPath.row]).title;
    cell.detailTextLabel.text =((NoteBookInfo*)[self.noteArray objectAtIndex:indexPath.row]).whattime;
    NSLog(@"%@",cell.textLabel.text);
    return cell;
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Get the object to delete from the array
        NoteBookInfo *notebookInfo = [self.noteArray objectAtIndex:indexPath.row];
        [self removeNotebook: notebookInfo];
        
        // Delete the object from the table
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(void)removeNotebook:(NoteBookInfo*)notebookInfo{
    sqlite3_stmt *statement;
    const char *sql_delete="delete from DairyList where id=?";
    if(sqlite3_prepare_v2(noteDB, sql_delete, -1, &statement, NULL) != SQLITE_OK)
        NSAssert1(0, @"Error while creating delete statement. '%s'", sqlite3_errmsg(noteDB));
    
    sqlite3_bind_int(statement, 1, notebookInfo.pk_id);
    
    if (sqlite3_step(statement)  != SQLITE_DONE)
        NSAssert1(0, @"Error while deleting. '%s'", sqlite3_errmsg(noteDB));
    
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    
    [self.noteArray removeObject:notebookInfo];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"showDetailSegue"]) {
        NSIndexPath *indexpath = [self.tableView indexPathForSelectedRow];
        
       detailViewController *desViewController = segue.destinationViewController;
        desViewController.titles=((NoteBookInfo*)[self.noteArray objectAtIndex:indexpath.row]).title;
        desViewController.time=((NoteBookInfo*)[self.noteArray objectAtIndex:indexpath.row]).whattime;
        
        const char *dbpath=[databasePath UTF8String];
        if (sqlite3_open(dbpath, &noteDB)==SQLITE_OK) {
            NSLog(@"open database success!！！！！！！");
            
            
            NSString *querySql2=[NSString stringWithFormat:@"SELECT DISTINCT CONTENT FROM DairyContent where whattime =?"];
            
            NSString *querySql3=[NSString stringWithFormat:@"SELECT DISTINCT condition FROM DairyWeather where whattime =?"];
            
            NSString *querySql4=[NSString stringWithFormat:@"SELECT DISTINCT temp FROM DairyWeather where whattime =?"];
            
            const char *query2=[querySql2 UTF8String];
            const char *query3=[querySql3 UTF8String];
            const char *query4=[querySql4 UTF8String];
            
            sqlite3_stmt *statement;
            NSLog(@"querySql3 is %@",querySql3);
            NSLog(@"querySql4 is %@",querySql4);
            
            if (sqlite3_prepare_v2(noteDB, query4, -1, &statement, nil) == SQLITE_OK) {
                NSLog(@"ok1");
                sqlite3_bind_text(statement, 1, [((NoteBookInfo*)[self.noteArray objectAtIndex:indexpath.row]).whattime UTF8String], -1, SQLITE_TRANSIENT);
                while (sqlite3_step(statement) == SQLITE_ROW){
                    NSString *tempString = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    NSLog(@"temp is %@",tempString);
                    desViewController.temp=tempString;
                }
                sqlite3_finalize(statement);
            }
            
            if (sqlite3_prepare_v2(noteDB, query3, -1, &statement, nil) == SQLITE_OK) {
                NSLog(@"ok2");
                sqlite3_bind_text(statement, 1, [((NoteBookInfo*)[self.noteArray objectAtIndex:indexpath.row]).whattime UTF8String], -1, SQLITE_TRANSIENT);
                while (sqlite3_step(statement) == SQLITE_ROW){
                    NSString *conditionString = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    NSLog(@"conditon is %@",conditionString);
                    desViewController.weather=conditionString;
                }
                sqlite3_finalize(statement);
            }
            
            if (sqlite3_prepare_v2(noteDB, query2, -1, &statement, nil) == SQLITE_OK) {
                NSLog(@"ok3");
                sqlite3_bind_text(statement, 1, [((NoteBookInfo*)[self.noteArray objectAtIndex:indexpath.row]).whattime UTF8String], -1, SQLITE_TRANSIENT);
                while (sqlite3_step(statement) == SQLITE_ROW){
                    NSString *contentString = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    NSLog(@"content is %@",contentString);
                    desViewController.contents=contentString;
                }
                sqlite3_finalize(statement);
            }else
            {
                NSLog(@"Problem1 with prepare statement %s",sqlite3_errmsg(noteDB));
            }
            
        }else
        {
                NSLog(@"Problem2 with prepare statement %s",sqlite3_errmsg(noteDB));
        }
           // sqlite3_finalize(statement);
    }
    
}
@end
