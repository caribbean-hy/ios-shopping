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
        NSLog(s);
        [array addObject: s];
        
        
    }
    return array;
 
}

- (BOOL) courseIsOn:(NSDate *)datePicked
{
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *comps = [cal components: (NSDayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit) fromDate: datePicked];
    
    NSInteger day = [comps day];
    NSInteger year = [comps year];
    NSInteger month = [comps month];
    
    NSDateComponents *classComps = [[NSDateComponents alloc] init];
    [classComps setYear: year];
    [classComps setMonth: month];
    [classComps setDay: day];
    [classComps setHour: [self getStartTime]];
    
    
    
    return YES;
}

- (NSDate *) getStartTime
{
    NSError *error = nil;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern: @"[^-]+" options:0 error: &error];
   
    NSString *toSearch = [[self times] objectAtIndex:[[self days] indexOfObject: [[PFObjectStore sharedStore] currentSelectedWeekday]]];
    
    NSArray *matches = [regex matchesInString: toSearch options:0 range:NSMakeRange(0, [toSearch length])];
    
        NSString *s = [toSearch substringWithRange:[[matches objectAtIndex: 0] rangeAtIndex:0]];
        NSLog(s);
        // Convert string to date object
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    if ([s length] > 1)
        [dateFormat setDateFormat:@"hh:mm"];
    else
        [dateFormat setDateFormat:@"hh"];
    
    NSDate *date = [dateFormat dateFromString:s];
    
    date = [date dateByAddingTimeInterval:[[NSTimeZone localTimeZone] secondsFromGMTForDate:date]]; // local date!
    
    NSLog(@"%@", date);
    
    return date;
 
}

- (void) dealloc
{
    NSLog(@"deallocing %@", [self title]);
}

@end
