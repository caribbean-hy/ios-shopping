//
//  TableViewController.m
//  ParseStarterProject
//
//  Created by Winnie Wu on 7/15/13.
//
//

#import "TableViewController.h"
#import "PFObjectStore.h"
#import <Parse/Parse.h>
#import "TableViewCell.h"
#import "Course.h"

@interface TableViewController ()

@end

UITableView *tableView;
static NSString *nibName = @"TableViewCell";


@implementation TableViewController

- (void) loadView
{
    CGRect mainViewFrame = CGRectMake(0.0, 255.0, [[UIScreen mainScreen] bounds].size.width, 200.0);
    self.view = [[UIView alloc] initWithFrame: mainViewFrame];
    
    CGRect tableViewFrame = self.view.bounds;
    tableView = [[UITableView alloc] initWithFrame: tableViewFrame style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    
    tableView.delegate = self;
    tableView.dataSource = self;
}

- (UITableView *) getTable
{
    return tableView;
}
//- (id)initWithStyle:(UITableViewStyle)style
//{
//    //self = [super initWithStyle:style];
//    self = [super init];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (id) init
{
    self = [super init];
    if (self){
        NSLog(@"init");
    }
    return self;
    
}


-(id) initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UINib *nib = [UINib nibWithNibName: nibName bundle: nil];
    [tableView registerNib:nib forCellReuseIdentifier: nibName];
    
    
    NSLog(@"meow tableviewcontrollerhasloaded");
    NSLog(@"%d", [[[PFObjectStore sharedStore] qCourses] count]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    NSLog(@"rowing");
    return [[[PFObjectStore sharedStore] qCourses] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nibName];
    NSLog(@"celling");
    // Configure the cell...
    
    if (!cell)
        cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nibName];
    
    NSArray *courses = [[PFObjectStore sharedStore] qCourses];
    
    Course *c = [courses objectAtIndex:[indexPath row]];
    [cell setController:self];
    [[cell titleLabel] setText: [NSString stringWithFormat:@"%@%@", [c field], [c number]]];
    [[cell roomLabel] setText: [NSString stringWithFormat: @"%@%@",[c building], [c room]]];
    [[cell timeLabel] setText: [c meetings]];
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void)viewDidUnload {
   
    [super viewDidUnload];
}
@end
