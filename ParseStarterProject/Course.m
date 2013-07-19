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
    
    [newCourse setTimes: [newCourse matchString: [newCourse meetings] withExpression:@"[0-9 ,-:]+" withArray:[newCourse times]]];
    
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
        s = [s stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSLog(s);
        [array addObject: s];
        
        
    }
    return array;
    
}

- (NSString *) timesForSelectedDay
{
    return [[self times] objectAtIndex:[[self days] indexOfObject: [[PFObjectStore sharedStore] currentSelectedWeekday]]];
}

- (BOOL) courseIsOn
{
    NSString *toSearch = [self timesForSelectedDay];
    NSMutableArray *splitSessions = [self getMultipleSessions:toSearch];
  //  NSLog(@"sessions split %d", [splitSessions count]);
    for (int i = 0; i < [splitSessions count]; i++)
    {
     //   NSLog(@"%@%@", [[splitSessions objectAtIndex:i]title], [[splitSessions objectAtIndex:i] times]);
    NSDate *selected = [[PFObjectStore sharedStore] currentSelectedTime];
    NSDate *start = [[splitSessions objectAtIndex:i] getStartTime:toSearch];
    NSDate *end = [[splitSessions objectAtIndex:i] getEndTime:toSearch];
    
    NSLog(@"SELECTED TIME: %@", selected);
  
        
    if ([start compare:selected]!= NSOrderedDescending && [selected compare: end] != NSOrderedDescending)
        return YES;
    
    }
    return NO;
}

- (NSMutableArray *) getMultipleSessions: (NSString *)toSearch
{
       
    NSMutableArray *sessions = [[NSMutableArray alloc] init];
    NSError *error = nil;
//    NSLog(@"\n\nPRE REGEX -- %@, %@, %@\n\n", [self field], [self number], [self times]);
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^,]+" options:0 error:&error];
    NSArray *matches = [regex matchesInString:toSearch options: 0 range: NSMakeRange(0, [toSearch length])];
    BOOL onlyOneTime = ([matches objectAtIndex: 0] == [matches lastObject]);
    if (onlyOneTime) {
        [sessions addObject:self];
//        NSLog(@"/n/nI ONLY HAVE 1 TIME -- %@, %@, %@/n/n", [self field], [self number], [self times]);
    } else {
        NSString *s = [toSearch substringWithRange:[[matches objectAtIndex:0] range]];
        [self setTimeForSelectedDay:s];
        [sessions addObject:self];
        for (int i = 1; i < [matches count] ; i++)
        {
            s = [toSearch substringWithRange:[[matches objectAtIndex:i] range]];
            Course *copyCourse = [self mutableCopy];
            [copyCourse setTimeForSelectedDay:s];
            [sessions addObject:copyCourse];
        }
    }
    return sessions;
}


- (NSDate *) getEndTime: (NSString *) toSearch
{
    
    NSError *error = nil;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern: @"[^-]+" options:0 error: &error];
    
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



- (NSDate *) getStartTime: (NSString *)toSearch
{
    
    NSError *error = nil;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern: @"[^-]+" options:0 error: &error];
    
    
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

- (void) setTimeForSelectedDay: (NSString*) newTime
{
    [[self times] replaceObjectAtIndex: [[self days] indexOfObject: [[PFObjectStore sharedStore] currentSelectedWeekday]] withObject:newTime];
}


- (id) mutableCopyWithZone:(NSZone *)zone
{
    Course *copy = [[[self class] allocWithZone:zone] init];
    
    if (copy)
    {
        [copy setCat_num: [self cat_num]];
        [copy setTerm: [self term]];
        [copy setField: [self field]];
        [copy setNumber: [self number]];
        [copy setTitle: [self title]];
        [copy setFaculty: [self faculty]];
        [copy setDescription: [self description]];
        [copy setPrerequisites: [self prerequisites]];
        [copy setMeetings: [self meetings]];
        [copy setBuilding: [self building]];
        [copy setRoom: [self room]];
        [copy setDays: [self days]];
        [copy setTimes: [[self times] mutableCopyWithZone:zone]];
        
    }
    return copy;
}

@end
