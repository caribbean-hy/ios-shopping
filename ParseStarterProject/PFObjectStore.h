//
//  PFObjectStore.h
//  ParseStarterProject
//
//  Created by Winnie Wu on 7/15/13.
//
//

#import <Foundation/Foundation.h>
@class Course;

@interface PFObjectStore : NSObject

+ (PFObjectStore *) sharedStore;
@property (nonatomic, strong, readonly) NSArray *qCourses;
@property (nonatomic, strong) NSDate *currentSelectedDate;
@property (nonatomic, strong) NSString *currentSelectedWeekday;
- (void) removeCourse: (Course *) c;
- (void) addCourse: (Course *) c;
- (void) clearStore;
@end
