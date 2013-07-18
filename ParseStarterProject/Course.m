//
//  Course.m
//  ParseStarterProject
//
//  Created by Winnie Wu on 7/12/13.
//
//

#import "Course.h"
#import <Parse/Parse.h>

@interface Course ()

- (NSMutableArray *) matchString: (NSString *)string withExpression:(NSString *)exp withArray: (NSMutableArray *)array;


@end


@implementation Course

+ (Course *) createNewCourse:(PFObject *)object
{
    Course *newCourse = [[Course alloc] init];
    NSLog(@"%@%@", [object objectForKey:@"field"], [object objectForKey:@"number"]);
    [newCourse setCat_num: [object objectForKey:@"cat_num"]];
    [newCourse setTerm: [object objectForKey:@"term"]];
    [newCourse setField: [object objectForKey:@"field"]];
    [newCourse setNumber: [object objectForKey:@"number"]];
    [newCourse setTitle: [object objectForKey:@"title"]];
    [newCourse setFaculty: [object objectForKey:@"faculty"]];
    [newCourse setDescription: [object objectForKey:@"description"]];
    [newCourse setPrerequisites: [object objectForKey:@"prerequisites"]];
    [newCourse setMeetings: [object objectForKey:@"meetings"]];
    [newCourse setBuilding: [object objectForKey:@"building"]];
    [newCourse setRoom: [object objectForKey:@"room"]];
    
    
    [newCourse setDays:[[NSMutableArray alloc] init]];
    [newCourse setTimes: [[NSMutableArray alloc] init]];
    
    [newCourse setDays: [newCourse matchString: [newCourse meetings] withExpression: @"[A-Za-z]+" withArray: [newCourse days]]];
    
    [newCourse setTimes: [newCourse matchString: [newCourse meetings] withExpression:@"[^ |A-Za-z]+" withArray:[newCourse times]]];

    return newCourse;

}

- (NSMutableArray *) matchString: (NSString *)string withExpression:(NSString *)exp withArray: (NSMutableArray *)array
{
    NSError *error = nil;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern: exp options:0 error: &error];
    
    NSArray *matches = [regex matchesInString: string options:0 range:NSMakeRange(0, [string length])];
    
    for (NSTextCheckingResult* match in matches)
    {
        NSString *s = [string substringWithRange:[match rangeAtIndex:0]];
        NSLog(s);
        [array addObject: s];
        
        
    }
    return array;
 
}

- (BOOL) courseIsOn:(NSDate *)datePicked
{

    
    return YES;
}

- (void) dealloc
{
    NSLog(@"deallocing %@", [self title]);
}

@end
