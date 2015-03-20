//
//  Talk.m
//  NSConfArg2015Handoff
//
//  Created by Martín Blech on 2/5/15.
//  Copyright (c) 2015 Martin Blech. All rights reserved.
//

#import "Talk.h"

@implementation Talk

- (instancetype)initWithTitle:(NSString *)title speakerName:(NSString *)speakerName time:(NSString *)time
{
    self = [super init];
    if (self) {
        _title = title;
        _speakerName = speakerName;
        _time = time;
    }
    return self;
}

+ (NSArray *)defaultTalks
{
    return @[
        [[self alloc] initWithTitle:@"Handoff" speakerName:@"Martín Blech" time:@"9:30"],
        [[self alloc] initWithTitle:@"Functional Programming en Swift" speakerName:@"Adrián Ferreyra" time:@"10:15"],
        [[self alloc] initWithTitle:@"Accesibilidad, apps para todos y todas" speakerName:@"Julio Carrettoni" time:@"11:15"],
        [[self alloc] initWithTitle:@"HealthKit" speakerName:@"Adrián Coria" time:@"12:00"],
    ];
}

@end
