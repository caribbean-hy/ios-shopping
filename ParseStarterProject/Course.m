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
    
    NSError *error = NULL;
    
    [newCourse setDays:[[NSMutableArray alloc] init]];
    [newCourse setTimes: [[NSMutableArray alloc] init]];
    
    
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[A-Z]" options:0 error:&error];
    NSArray *matches = [regex matchesInString: [newCourse meetings] options:0 range:NSMakeRange(0, [[newCourse meetings] length])];
    for (NSTextCheckingResult* match in matches)
    {
        NSString *s = [[newCourse meetings] substringWithRange:[match rangeAtIndex:0]];
        NSLog(s);
        [[newCourse days] addObject: s];
        
        
    }
    
    regex = [NSRegularExpression regularExpressionWithPattern: @"[^ |A-Z]+" options:0 error: &error];
    
    matches = [regex matchesInString: [newCourse meetings] options:0 range:NSMakeRange(0, [[newCourse meetings] length])];
    
    for (NSTextCheckingResult* match in matches)
    {
        NSString *s = [[newCourse meetings] substringWithRange:[match rangeAtIndex:0]];
        NSLog(s);
        [[newCourse times] addObject: s];
        
        
    }
    
    return newCourse;

}

- (NSArray *) matchString: (NSString *)string withExpression:(NSString *)exp withArray: (NSMutableArray *)array
{
    NSRegularExpression regex = [NSRegularExpression regularExpressionWithPattern: exp options:0 error: &error];
    
    matches = [regex matchesInString: string options:0 range:NSMakeRange(0, [string length])];
    
    for (NSTextCheckingResult* match in matches)
    {
        NSString *s = [string substringWithRange:[match rangeAtIndex:0]];
        NSLog(s);
        [array addObject: s];
        
        
    }
    return array;
 
}

@end
