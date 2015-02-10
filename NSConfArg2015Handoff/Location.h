//
//  Location.h
//  NSConfArg2015Handoff
//
//  Created by Martín Blech on 2/5/15.
//  Copyright (c) 2015 Martin Blech. All rights reserved.
//

@import MapKit;
#import <Foundation/Foundation.h>

@interface Location : NSObject <MKAnnotation>

+ (instancetype)sharedInstance;

@end
