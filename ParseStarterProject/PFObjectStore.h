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

- (void) removeCourse: (Course *) c;
- (void) addCourse: (Course *) c;

@end
