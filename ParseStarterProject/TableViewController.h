//
//  TableViewController.h
//  ParseStarterProject
//
//  Created by Winnie Wu on 7/15/13.
//
//

#import <UIKit/UIKit.h>

@interface TableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
- (UITableView *) getTable;

@end
