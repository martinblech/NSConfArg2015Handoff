//
//  Talk.m
//  NSConfArg2015Handoff
//
//  Created by Martín Blech on 2/5/15.
//  Copyright (c) 2015 Martin Blech. All rights reserved.
//

#import "Talk.h"

@implementation Talk

- (instancetype)initWithTitle:(NSString *)title speakerName:(NSString *)speakerName
{
    self = [super init];
    if (self) {
        _title = title;
        _speakerName = speakerName;
    }
    return self;
}

+ (NSArray *)defaultTalks
{
    return @[
        [[self alloc] initWithTitle:@"HealthKit" speakerName:@"Adrián Coria"],
        [[self alloc] initWithTitle:@"Swift Funcional" speakerName:@"Adrián Ferreyra"],
        [[self alloc] initWithTitle:@"Handoff" speakerName:@"Martín Blech"],
        [[self alloc] initWithTitle:@"One more thing…" speakerName:@"TBD"],
    ];
}

@end
