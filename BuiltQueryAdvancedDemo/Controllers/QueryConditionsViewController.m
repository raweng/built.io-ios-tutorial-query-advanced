//
//  QueryConditionsViewController.m
//  BuiltQueryDemo
//
//  Created by Akshay Mhatre on 18/03/14.
//  Copyright (c) 2014 raweng. All rights reserved.
//

#import "QueryConditionsViewController.h"
#import "QueryViewController.h"
#import "AppDelegate.h"
@interface QueryConditionsViewController ()

@property (strong, nonatomic) NSArray *conditions;
@property (strong, nonatomic) NSArray *descriptions;
@property (strong, nonatomic) QueryViewController *result;
@end

@implementation QueryConditionsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _conditions = @[@"All Objects",
                        @"All Objects with \"movie\" reference field included",
                        @"Nominees from movie with running time less than 2 hrs",
                        @"Nominees from movie with running time greater than 2 hrs",
                        @"Nominees from movie with running time less than 2 hrs",
                        @"Nominees from movie with running time greater than 2 hrs",
                        @"Nominees born in US OR UK",
                        @"Nominees born in US or UK AND with age less than or equal to 40"];
        
        _descriptions = @[@"All the objects that belong to \"nominees\" class",
                          @"include reference field so that response has the referred object included",
                          @"inQuery lets you query a reference field and retrieve objects that satisfy that query",
                          @"notinQuery lets you query a reference field and retrieve objects that don't satisfy that query",
                          @"select query lets you query on a class and use that result to query on a field that may or may not be a reference field.",
                          @"negation of select query",
                          @"Combine two or more queries. Objects returned satisfy any of these conditions. Logical OR",
                          @"Combine two or more queries. Objects returned satisfy all of these conditions. Logical AND"];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Conditions";
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _conditions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = _conditions[indexPath.row];
    cell.detailTextLabel.text = _descriptions[indexPath.row];
    
    [cell.textLabel setNumberOfLines:0];
    [cell.textLabel sizeToFit];

    [cell.detailTextLabel setNumberOfLines:0];
    [cell.detailTextLabel sizeToFit];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BuiltClass *builtClass = [[AppDelegate sharedInstance].builtApplication classWithUID:@"nominees"];
    
    _result = [[QueryViewController alloc]initWithStyle:UITableViewStylePlain withBuiltClass:builtClass];
    
    switch (indexPath.row) {
        case 0:
            break;
        case 1:
            [_result includeReferenceField];
            break;
        case 2:
            [_result inQuery];
            break;
        case 3:
            [_result notinQuery];
            
            break;
        case 4:
            [_result selectQuery];
            
            break;
        case 5:
            [_result notselectQuery];
            break;
        case 6:
            [_result orQueries];
            break;
        case 7:
            [_result andQueries];
            break;
        default:
            break;
    }
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        [_result setEdgesForExtendedLayout:UIRectEdgeBottom];
    }
    [self.navigationController pushViewController:_result animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

@end
