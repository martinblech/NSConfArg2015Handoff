//
//  Location.m
//  NSConfArg2015Handoff
//
//  Created by Martín Blech on 2/5/15.
//  Copyright (c) 2015 Martin Blech. All rights reserved.
//

#import "Location.h"

@implementation Location

+ (instancetype)sharedInstance
{
    static Location *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initPrivate];
    });
    return instance;
}

- (instancetype)init
{
    [NSException raise:@"Singleton" format:@"Use sharedInstance instead"];
    return nil;
}

- (instancetype)initPrivate
{
    return [super init];
}

- (CLLocationCoordinate2D)coordinate
{
    return CLLocationCoordinate2DMake(-34.59855, -58.41624);
}

- (NSString *)title
{
    return @"NSConfArg 2015";
}

- (NSString *)subtitle
{
    return @"Mario Bravo 1050, CABA";
}

@end