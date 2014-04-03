//
//  QueryViewController.h
//  BuiltQueryDemo
//
//  Created by Akshay Mhatre on 14/03/14.
//  Copyright (c) 2014 raweng. All rights reserved.
//

#import <BuiltIO/BuiltIO.h>

@interface QueryViewController : BuiltUITableViewController

- (void)inQuery;
- (void)notinQuery;
- (void)selectQuery;
- (void)notselectQuery;
- (void)includeReferenceField;
- (void)orQueries;
- (void)andQueries;

@end

