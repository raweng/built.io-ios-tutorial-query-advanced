//
//  QueryViewController.m
//  BuiltQueryDemo
//
//  Created by Akshay Mhatre on 14/03/14.
//  Copyright (c) 2014 raweng. All rights reserved.
//

#import "QueryViewController.h"

@interface QueryViewController ()

@end

@implementation QueryViewController

- (id)initWithStyle:(UITableViewStyle)style{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.enablePullToRefresh = YES;
        self.fetchLimit = 99;
        self.title = @"Result";        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refresh];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath builtObject:(BuiltObject *)builtObject{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[builtObject objectForKey:@"name"]];
    
    if ([[builtObject objectForKey:@"movie"][0] isKindOfClass:[NSDictionary class]]) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[[builtObject objectForKey:@"movie"][0] objectForKey:@"title"]];
        cell.detailTextLabel.text = [cell.detailTextLabel.text stringByAppendingString:[NSString stringWithFormat:@" | Runnning Time:%@mins",[[builtObject objectForKey:@"movie"][0] objectForKey:@"running_time"]]];

    }

    return cell;
}

- (void)includeReferenceField{
    [self.builtQuery includeRefFieldWithKey:@[@"movie"]];
}

- (void)inQuery{
    //query where running time is less than 120 minutes
    BuiltQuery *movieQuery = [BuiltQuery queryWithClassUID:@"movie"];
    [movieQuery whereKey:@"running_time" lessThan:[NSNumber numberWithInt:120]];
    
    //we want all those nominees that belong to a movie with running time less than 120 minutes
    [self.builtQuery inQuery:movieQuery forKey:@"movie"];
}

- (void)notinQuery{
    BuiltQuery *movieQuery = [BuiltQuery queryWithClassUID:@"movie"];
    [movieQuery whereKey:@"running_time" lessThan:[NSNumber numberWithInt:120]];
    [self.builtQuery notinQuery:movieQuery forKey:@"movie"];
}

- (void)selectQuery{
    //query where running time is less than 120 minutes
    BuiltQuery *movieQuery = [BuiltQuery queryWithClassUID:@"movie"];
    [movieQuery whereKey:@"running_time" lessThan:[NSNumber numberWithInt:120]];
    
    //we want to compare the movie_text field of this("nominees") class with title field of "movie" class
    [self.builtQuery whereKey:@"movie_text" equalToResultOfSelectQuery:movieQuery forKey:@"title"];
}

- (void)notselectQuery{
    BuiltQuery *movieQuery = [BuiltQuery queryWithClassUID:@"movie"];
    [movieQuery whereKey:@"running_time" lessThan:[NSNumber numberWithInt:120]];
    
    [self.builtQuery whereKey:@"movie_text" equalToResultOfDontSelectQuery:movieQuery forKey:@"title"];
}

- (void)orQueries{
    //born in United States
    BuiltQuery *query1 = [BuiltQuery queryWithClassUID:@"nominees"];
    [query1 whereKey:@"born" equalTo:@"United States"];
    
    //born in United Kingdom
    BuiltQuery *query2 = [BuiltQuery queryWithClassUID:@"nominees"];
    [query2 whereKey:@"born" equalTo:@"United Kingdom"];
    
    //query1 OR query2
    [self.builtQuery orWithSubqueries:@[query1, query2]];
}

- (void)andQueries{
    //born in United States
    BuiltQuery *query1 = [BuiltQuery queryWithClassUID:@"nominees"];
    [query1 whereKey:@"born" equalTo:@"United States"];

    //born in United Kingdom
    BuiltQuery *query2 = [BuiltQuery queryWithClassUID:@"nominees"];
    [query2 whereKey:@"born" equalTo:@"United Kingdom"];
    
    //query3 = query1 OR query2
    BuiltQuery *query3 = [BuiltQuery queryWithClassUID:@"nominees"];
    [query3 orWithSubqueries:@[query1,query2]];

    //age<=40
    BuiltQuery *query4 = [BuiltQuery queryWithClassUID:@"nominees"];
    [query4 whereKey:@"age" lessThanOrEqualTo:[NSNumber numberWithInt:40]];

    //query3 AND query4
    [self.builtQuery andWithSubqueries:@[query3, query4]];
}

-(void)networkDidFinishLoad:(NSError *)error{
    [self.objectCollection enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSLog(@"object %@",obj);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end