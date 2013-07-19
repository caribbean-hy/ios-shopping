//
//  Course.m
//  ParseStarterProject
//
//  Created by Winnie Wu on 7/12/13.
//
//

#import "Course.h"
#import <Parse/Parse.h>
#import "PFObjectStore.h"

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
//        NSLog(s);
        [array addObject: s];
        
        
    }
    return array;
    
}

- (BOOL) courseIsOn
{
    NSDate *selected = [[PFObjectStore sharedStore] currentSelectedTime];
    NSDate *start = [self getStartTime];
    NSDate *end = [self getEndTime];
    
    NSLog(@"SELECTED TIME: %@", selected);
   
    NSLog(@"IS THE COURSE ON? %d", ([start compare:selected]!= NSOrderedDescending && [selected compare: end] != NSOrderedDescending));
    
    return ([start compare:selected]!=NSOrderedDescending && [selected compare: end] != NSOrderedDescending);
    
}

- (NSDate *) getEndTime
{
    
    NSError *error = nil;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern: @"[^-]+" options:0 error: &error];
    
    NSString *toSearch = [[self times] objectAtIndex:[[self days] indexOfObject: [[PFObjectStore sharedStore] currentSelectedWeekday]]];
    
    NSArray *matches = [regex matchesInString: toSearch options:0 range:NSMakeRange(0, [toSearch length])];
    
    NSString *s;
    BOOL onlyOneTime = ([matches objectAtIndex: 0] == [matches lastObject]);
    if (onlyOneTime){
        s = [toSearch substringWithRange:[[matches objectAtIndex:0] range]];
    } else {
        s = [toSearch substringWithRange:[[matches objectAtIndex: 1] range]];
    }
    
//    NSLog(s);
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    if ([s rangeOfString:@":"].location == NSNotFound)
        [dateFormat setDateFormat:@"hh"];
    else
        [dateFormat setDateFormat:@"hh:mm"];
    
    NSDate *date = [dateFormat dateFromString:s];
    
    date = [date dateByAddingTimeInterval:[[NSTimeZone localTimeZone] secondsFromGMTForDate:date]]; // local date!
    
    if (onlyOneTime)
        date = [date dateByAddingTimeInterval: (60 * 60)];
    
    NSLog(@"END TIME: %@", date);
    
    return date;
    
}



- (NSDate *) getStartTime
{
    
    NSError *error = nil;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern: @"[^-]+" options:0 error: &error];
    
    NSString *toSearch = [[self times] objectAtIndex:[[self days] indexOfObject: [[PFObjectStore sharedStore] currentSelectedWeekday]]];
    
    NSTextCheckingResult *match = [regex firstMatchInString: toSearch options:0 range:NSMakeRange(0, [toSearch length])];
    
    NSString *s = [toSearch substringWithRange:[match range]];
//    NSLog(s);
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    if ([s rangeOfString:@":"].location == NSNotFound)
        [dateFormat setDateFormat:@"hh"];
    else
        [dateFormat setDateFormat:@"hh:mm"];
    
    NSDate *date = [dateFormat dateFromString:s];
    
    date = [date dateByAddingTimeInterval:[[NSTimeZone localTimeZone] secondsFromGMTForDate:date]]; // local date!
    
    NSLog(@"START TIME: %@", date);
    
    return date;
    
}




@end
