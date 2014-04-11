//
//  TimerCaseObject.h
//  HHTimerKit
//
//  Created by lingaohe on 4/11/14.
//  Copyright (c) 2014 ilingaohe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimerCaseObject : NSObject

- (void)runTimerWithRetainCycle;
- (void)runTimerWithOutRetainCycle;
- (void)runTimerWithRunLoop;
- (void)runTimerWithoutRunLoop;

@end
