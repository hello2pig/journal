//
//  detailViewController.h
//  journal
//
//  Created by Ted Lee on 10/6/13.
//  Copyright (c) 2013 Ted Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListViewController.h"

@interface detailViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *detailTitle;
@property (strong, nonatomic) IBOutlet UITextView *detailContent;
@property (strong, nonatomic) IBOutlet UILabel *detailTime;

@property (strong, nonatomic) IBOutlet UILabel *detailWeather;
@property (strong, nonatomic) IBOutlet UILabel *detailTemp;

@property (strong,nonatomic) NSString *titles;
@property (strong,nonatomic) NSString *contents;
@property (strong,nonatomic) NSString *time;

@property (strong,nonatomic) NSString *weather;
@property (strong,nonatomic) NSString *temp;
@end
