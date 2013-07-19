//
//  PFObjectStore.m
//  ParseStarterProject
//
//  Created by Winnie Wu on 7/15/13.
//
//

#import "PFObjectStore.h"
@interface PFObjectStore ()
{
    NSMutableArray *_qCourses;
}
@end

@implementation PFObjectStore

- (id) init
{
    self = [super init];
    if (self) {
        _qCourses = [[NSMutableArray alloc] init];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DataUpdated" object:self];
    }
    return self;
}

+ (PFObjectStore *) sharedStore
{
    static PFObjectStore *sharedStore = nil;
    if (!sharedStore)
    {
        sharedStore = [[super allocWithZone:nil] init];
    }
    return sharedStore;
}

- (void) removeCourse:(Course *)c
{
    [_qCourses removeObjectIdenticalTo: c];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DataUpdated" object:self];

}

-(void) addCourse:(Course *)c
{
    [_qCourses addObject:c];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DataUpdated" object:self];
}

- (void) clearStore
{
    id refreshed = [self init];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DataUpdated" object:self];

}

@end
