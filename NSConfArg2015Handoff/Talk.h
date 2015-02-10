//
//  Talk.h
//  NSConfArg2015Handoff
//
//  Created by Martín Blech on 2/5/15.
//  Copyright (c) 2015 Martin Blech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Talk : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *speakerName;

- (instancetype)initWithTitle:(NSString *)title speakerName:(NSString *)speakerName;

+ (NSArray *)defaultTalks;

@end
