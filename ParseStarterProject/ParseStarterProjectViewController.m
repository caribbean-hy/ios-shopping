#import "ParseStarterProjectViewController.h"
#import <Parse/Parse.h>
#import "PFObjectStore.h"
#import "TableViewController.h"

@interface ParseStarterProjectViewController ()
@property (unsafe_unretained, nonatomic) IBOutlet UITableView *tableView;
@property (unsafe_unretained, nonatomic) IBOutlet UIDatePicker *datePicker;
@end

@implementation ParseStarterProjectViewController
- (IBAction)showClasses:(id)sender {
    NSDate *time = [[self datePicker] date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"HH:mm"];
    NSString *timeString = [dateFormatter stringFromDate: time];
    NSLog(@"%@", timeString);
    
    TableViewController *tvc = [[TableViewController alloc] init];
    //[[self navigationController] pushViewController:tvc animated:YES];
    [self addChildViewController:tvc];
    [self.view addSubview:tvc.view];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - UIViewController
//- (void)loadView
//{
//    TableViewController *tvc = [[TableViewController alloc] init];
//   
//}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
//    [testObject setObject:@"bar" forKey:@"foo"];
//    [testObject save];
    
    [PFCloud callFunctionInBackground:@"helloworld"
                       withParameters:@{}
                                block:^(NSString *result, NSError *error) {
                                    if (!error) {
                                        // result is @"Hello world!"
                                    } else {
                                        NSLog(@"HELP");
                                    }
                                }];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Courses"];
    [query whereKey:@"cat_num" equalTo:@"4949"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d scores.", objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
                NSLog(@"%@%@", [object objectForKey:@"field"], [object objectForKey:@"number"]);
                [[PFObjectStore sharedStore] addCourse: object];
            }
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    [[self datePicker] addTarget:self action:@selector(showTime:) forControlEvents:UIControlEventValueChanged];
    
}

- (void) showTime: (id) sender
{
    NSDate *time = [[self datePicker] date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"HH:mm"];
    NSString *timeString = [dateFormatter stringFromDate: time];
    NSLog(@"%@", timeString);
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidUnload {
    [self setDatePicker:nil];
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
