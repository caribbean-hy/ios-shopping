#import "ParseStarterProjectViewController.h"
#import <Parse/Parse.h>


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
    
    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    [testObject setObject:@"bar" forKey:@"foo"];
    [testObject save];
    
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
