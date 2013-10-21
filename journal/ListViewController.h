//
//  ListViewController.h
//  journal
//
//  Created by Ted Lee on 10/5/13.
//  Copyright (c) 2013 Ted Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import "NoteBookInfo.h"

@interface ListViewController : UIViewController<UITableViewDataSource,UITabBarDelegate>
{
    sqlite3 *noteDB;
    NSString *databasePath;
}

@property NSMutableArray *noteArray;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
