//
//  detailViewController.m
//  journal
//
//  Created by Ted Lee on 10/6/13.
//  Copyright (c) 2013 Ted Lee. All rights reserved.
//

#import "detailViewController.h"

@interface detailViewController ()

@end

@implementation detailViewController
@synthesize contents=_contents;
@synthesize titles=_titles;
@synthesize weather=_weather;
@synthesize temp=_temp;

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
    self.detailContent.text=self.contents;
    self.detailTitle.text=self.titles;
    self.detailTemp.text=self.temp;
    self.detailWeather.text=self.weather;
    self.detailTime.text=self.time;
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
