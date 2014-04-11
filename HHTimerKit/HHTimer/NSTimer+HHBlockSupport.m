//
//  NSTimer+HHBlockSupport.m
//  HHTimerKit
//
//  Created by lingaohe on 4/11/14.
//  Copyright (c) 2014 ilingaohe. All rights reserved.
//

#import "NSTimer+HHBlockSupport.h"

@implementation NSTimer (HHBlockSupport)

+ (NSTimer *)hh_scheduledTimerWithTimeInterval:(NSTimeInterval)ti
                                         block:(void (^)(void))block
                                       repeats:(BOOL)yesOrNo
{
  //让NSTimer的target变为自己（NSTimer单例），因此NSTimer hold住的是自己。但是NSTimer还是会hold住block，因此解决了hold住target产生的retainCycle，仍然还要防止block产生的retainCycle，不过block产生的retainCycle比较好解决，使用__weak就行
  return [self scheduledTimerWithTimeInterval:ti
                                       target:self
                                     selector:@selector(hh_blockInvoke:)
                                     userInfo:[block copy]
                                      repeats:yesOrNo];
}

#pragma mark -- Internal
+ (void)hh_blockInvoke:(NSTimer *)timer
{
  void (^block)(void) = timer.userInfo;
  if (block) {
    block();
  }
}
@end
