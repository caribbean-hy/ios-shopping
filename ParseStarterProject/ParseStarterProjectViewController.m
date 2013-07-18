#import "ParseStarterProjectViewController.h"
#import <Parse/Parse.h>
#import "PFObjectStore.h"
#import "TableViewController.h"
#import "Course.h"

@interface ParseStarterProjectViewController ()
@property (unsafe_unretained, nonatomic) IBOutlet UIDatePicker *datePicker;
@end

@implementation ParseStarterProjectViewController




- (IBAction)showClasses:(id)sender {
    NSDate *time = [[self datePicker] date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"hh:mm"];
    NSString *timeString = [dateFormatter stringFromDate: time];
    //NSLog(@"%@", timeString);
    
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [cal components:NSWeekdayCalendarUnit fromDate:time];
    int datePickerWeekday = [comps weekday];
    NSString *searchWeekday = nil;
    switch (datePickerWeekday) {
        case 2:
            searchWeekday = @"M";
            break;
        case 3:
            searchWeekday = @"Tu";
            break;
        case 4:
            searchWeekday = @"W";
            break;
        case 5:
            searchWeekday = @"Th";
            break;
        case 6:
            searchWeekday = @"F";
            break;
        case 7:
            searchWeekday = @"Sa";
            break;
        case 0:
            searchWeekday = @"Su";
            break;
    }
    [[PFObjectStore sharedStore] setCurrentSelectedWeekday: searchWeekday];
    
    
    //    NSLog(searchWeekday);
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"Courses"];
    
    [query whereKey:@"meetings" containsString:searchWeekday];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d scores.", objects.count);
            [[PFObjectStore sharedStore] clearStore];
            // Do something with the found objects
            for (PFObject *object in objects) {
                Course *newCourse = [Course createNewCourse:object];
                
                
                [[PFObjectStore sharedStore] addCourse: newCourse];
                 NSDate *date = [newCourse getStartTime];
            }
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    
    
    
    
    
    
    
}




- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - UIViewController


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    //    [testObject setObject:@"bar" forKey:@"foo"];
    //    [testObject save];
    
//    [PFCloud callFunctionInBackground:@"helloworld"
//                       withParameters:@{}
//                                block:^(NSString *result, NSError *error) {
//                                    if (!error) {
//                                        // result is @"Hello world!"
//                                    } else {
//                                        NSLog(@"HELP");
//                                    }
//                                }];
//    
//    
    
    TableViewController *tvc = [[TableViewController alloc] init];
    //[[self navigationController] pushViewController:tvc animated:YES];
    [self addChildViewController:tvc];
    [self.view addSubview:tvc.view];
    
    
    [[PFObjectStore sharedStore] setCurrentSelectedWeekday: @"M"];
    
    
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"Courses"];
    [query whereKey:@"cat_num" equalTo:@"4949"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d scores.", objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
                Course *newCourse = [Course createNewCourse:object];
                
                
                [[PFObjectStore sharedStore] addCourse: newCourse];
                NSDate *date = [newCourse getStartTime];
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
    [[PFObjectStore sharedStore] setCurrentSelectedDate: time];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidUnload {
    [self setDatePicker:nil];
    [super viewDidUnload];
}
@end
