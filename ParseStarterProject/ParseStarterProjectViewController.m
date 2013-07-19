#import "ParseStarterProjectViewController.h"
#import <Parse/Parse.h>
#import "PFObjectStore.h"
#import "TableViewController.h"
#import "Course.h"

@interface ParseStarterProjectViewController ()
@property (unsafe_unretained, nonatomic) IBOutlet UIDatePicker *datePicker;
@end

@implementation ParseStarterProjectViewController

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
  /*
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
    */
    TableViewController *tvc = [[TableViewController alloc] init];
    [self addChildViewController:tvc];
    [self.view addSubview:tvc.view];
    
    
    NSDate *time = [[self datePicker] date];
    [[PFObjectStore sharedStore] setCurrentSelectedTime: time];
    
   /*
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
            }
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    */
    
    
    [[self datePicker] addTarget:self action:@selector(setTimeInterval:) forControlEvents:UIControlEventValueChanged];
    
}


- (IBAction)showClasses:(id)sender {
    [self findWeekday];
   
        
    NSString *searchWeekday = [[PFObjectStore sharedStore] currentSelectedWeekday];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Courses"];
    
    [query whereKey:@"meetings" containsString:searchWeekday];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            [[PFObjectStore sharedStore] clearStore];

            NSLog(@"Successfully retrieved %d scores.", objects.count);
            
           
            // Do something with the found objects
            for (PFObject *object in objects) {
                Course *newCourse = [Course createNewCourse:object];
               
                NSLog(@"%c", [newCourse courseIsOn]);
                
                if ([newCourse courseIsOn])
                    [[PFObjectStore sharedStore] addCourse: newCourse];
                }
        
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

}

- (void) findWeekday
{
    NSDate *time = [[self datePicker] date];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [cal components:NSWeekdayCalendarUnit fromDate:time];
    int datePickerWeekday = [comps weekday];
    NSString *searchWeekday = nil;
    NSLog(@"datePickerWeekday: %d", datePickerWeekday);
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
        case 1:
            searchWeekday = @"Su";
            break;
    }
    [[PFObjectStore sharedStore] setCurrentSelectedWeekday: searchWeekday];
    NSLog(@"weekday changed! %@", [[PFObjectStore sharedStore] currentSelectedWeekday]);
    
}

- (void) setTimeInterval: (id) sender
{
    NSDate *time = [[self datePicker] date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat: @"hh:mm"];
    NSString *timeString = [dateFormat stringFromDate: time];
    NSDate *pickedTime = [dateFormat dateFromString:timeString];
    pickedTime = [pickedTime dateByAddingTimeInterval:[[NSTimeZone localTimeZone] secondsFromGMTForDate:pickedTime]]; // local date!
    
    [[PFObjectStore sharedStore] setCurrentSelectedTime:pickedTime];
}



- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - UIViewController




- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidUnload {
    [self setDatePicker:nil];
    [super viewDidUnload];
}
@end
