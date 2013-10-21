//
//  NoteBookInfo.h
//  journal
//
//  Created by Ted Lee on 10/5/13.
//  Copyright (c) 2013 Ted Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoteBookInfo : NSObject
@property(nonatomic)int pk_id;
@property(nonatomic,strong)NSString *whattime;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSString *title;
@end

