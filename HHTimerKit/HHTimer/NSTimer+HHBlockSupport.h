//
//  NSTimer+HHBlockSupport.h
//  HHTimerKit
//
//  Created by lingaohe on 4/11/14.
//  Copyright (c) 2014 ilingaohe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (HHBlockSupport)

//Timer会hold住block，因此需要要防止block产生的retainCycle，不过block产生的retainCycle比较好解决，使用__weak就行
+ (NSTimer *)hh_scheduledTimerWithTimeInterval:(NSTimeInterval)ti
                                         block:(void(^)(void))block
                                       repeats:(BOOL)yesOrNo;

@end
