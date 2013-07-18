//
//  Course.h
//  ParseStarterProject
//
//  Created by Winnie Wu on 7/12/13.
//
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Course : NSObject

@property (nonatomic) int cat_num;
@property (nonatomic) NSString * term;
@property (nonatomic, strong) NSString *field;
@property (nonatomic) NSString * number;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *faculty;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *prerequisites;
@property (nonatomic, strong) NSString *meetings;
@property (nonatomic, strong) NSString *building;
@property (nonatomic, strong) NSString *room;

@property (nonatomic, strong) NSMutableArray *days;
@property (nonatomic, strong) NSMutableArray *times;

+ (Course *) createNewCourse: (PFObject *) object;
- (BOOL) courseIsOn: (NSDate *)time;
@end
