//
//  PFObjectStore.h
//  ParseStarterProject
//
//  Created by Winnie Wu on 7/15/13.
//
//

#import <Foundation/Foundation.h>
@class PFObject;

@interface PFObjectStore : NSObject

+ (PFObjectStore *) sharedStore;
@property (nonatomic, strong, readonly) NSArray *qCourses;

- (void) removeCourse: (PFObject *) c;
- (void) addCourse: (PFObject *) c;

@end
