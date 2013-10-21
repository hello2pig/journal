//
//  AddNoteViewController.h
//  journal
//
//  Created by Ted Lee on 10/5/13.
//  Copyright (c) 2013 Ted Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"


@interface AddNoteViewController : UIViewController
{
    sqlite3 *noteDB;
    NSString *databasePath;
}

@property (strong, nonatomic) IBOutlet UITextField *addTitle;
@property (strong, nonatomic) IBOutlet UITextView *addContent;

@property (strong,nonatomic) NSString *tempF;
@property (strong,nonatomic) NSString *condition;

- (IBAction)hideKeyboard:(id)sender;
- (IBAction)addNote:(id)sender;

@end
