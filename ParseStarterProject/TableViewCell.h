//
//  TableViewCell.h
//  ParseStarterProject
//
//  Created by Winnie Wu on 7/16/13.
//
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *titleLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *roomLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *timeLabel;
@property (unsafe_unretained, nonatomic) id controller;
@property (unsafe_unretained, nonatomic) UITableView *owningTableView;

@end
