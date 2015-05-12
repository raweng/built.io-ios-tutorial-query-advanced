//
//  QueryViewController.m
//  BuiltQueryDemo
//
//  Created by Akshay Mhatre on 14/03/14.
//  Copyright (c) 2014 raweng. All rights reserved.
//

#import "QueryViewController.h"
#import "AppDelegate.h"
@interface QueryViewController ()

@end

@implementation QueryViewController

- (id)initWithStyle:(UITableViewStyle)style withBuiltClass:(BuiltClass *)builtClass{
    self = [super initWithStyle:style withBuiltClass:builtClass];
    if (self) {
        // Custom initialization
        self.title = @"Result";
        self.enablePullToRefresh = YES;
        self.fetchLimit = 99;
    }
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];

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
    BuiltClass *builtClass = [[AppDelegate sharedInstance].builtApplication classWithUID:@"movie"];
    BuiltQuery *movieQuery = [builtClass query];
    [movieQuery whereKey:@"running_time" lessThan:[NSNumber numberWithInt:120]];
    
    //we want all those nominees that belong to a movie with running time less than 120 minutes
    [self.builtQuery inQuery:movieQuery forKey:@"movie"];
}

- (void)notinQuery{
    BuiltClass *builtClass = [[AppDelegate sharedInstance].builtApplication classWithUID:@"movie"];
    BuiltQuery *movieQuery = [builtClass query];
    [movieQuery whereKey:@"running_time" lessThan:[NSNumber numberWithInt:120]];
    [self.builtQuery notInQuery:movieQuery forKey:@"movie"];
}

- (void)selectQuery{
    //query where running time is less than 120 minutes
    BuiltClass *builtClass = [[AppDelegate sharedInstance].builtApplication classWithUID:@"movie"];
    BuiltQuery *movieQuery = [builtClass query];
    [movieQuery whereKey:@"running_time" lessThan:[NSNumber numberWithInt:120]];
    
    //we want to compare the movie_text field of this("nominees") class with title field of "movie" class
    [self.builtQuery whereKey:@"movie_text" equalToResultOfSelectQuery:movieQuery forKey:@"title"];
}

- (void)notselectQuery{
    BuiltClass *builtClass = [[AppDelegate sharedInstance].builtApplication classWithUID:@"movie"];
    BuiltQuery *movieQuery = [builtClass query];
    [movieQuery whereKey:@"running_time" lessThan:[NSNumber numberWithInt:120]];
    
    [self.builtQuery whereKey:@"movie_text" equalToResultOfDontSelectQuery:movieQuery forKey:@"title"];
}

- (void)orQueries{
    //born in United States
    BuiltClass *builtClass = [[AppDelegate sharedInstance].builtApplication classWithUID:@"nominees"];
    BuiltQuery *query1 = [builtClass query];
    [query1 whereKey:@"born" equalTo:@"United States"];
    
    //born in United Kingdom
    BuiltQuery *query2 = [builtClass query];
    [query2 whereKey:@"born" equalTo:@"United Kingdom"];
    
    //query1 OR query2
    [self.builtQuery orWithSubqueries:@[query1, query2]];
}

- (void)andQueries{
    //born in United States
    BuiltClass *builtClass = [[AppDelegate sharedInstance].builtApplication classWithUID:@"nominees"];
    BuiltQuery *query1 = [builtClass query];
    [query1 whereKey:@"born" equalTo:@"United States"];

    //born in United Kingdom
    BuiltQuery *query2 = [builtClass query];
    [query2 whereKey:@"born" equalTo:@"United Kingdom"];
    
    //query3 = query1 OR query2
    BuiltQuery *query3 = [builtClass query];
    [query3 orWithSubqueries:@[query1,query2]];

    //age<=40
    BuiltQuery *query4 = [builtClass query];
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