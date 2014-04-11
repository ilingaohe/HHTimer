//
//  HHTimer.m
//  HHTimerKit
//
//  Created by lingaohe on 4/11/14.
//  Copyright (c) 2014 ilingaohe. All rights reserved.
//

#import "HHTimer.h"

@interface HHTimer ()
@property (nonatomic, copy) dispatch_block_t block;
@property (nonatomic, strong) dispatch_source_t source;
@property (nonatomic, strong) id internalUserInfo;
@end

@implementation HHTimer

#pragma mark -- Init
+ (HHTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)seconds
                              dispatchQueue:(dispatch_queue_t)queue
                                      block:(dispatch_block_t)block
                                   userInfo:(id)userInfo
                                    repeats:(BOOL)yesOrNo
{
  NSParameterAssert(seconds);
  NSParameterAssert(block);
  //HHTimer会hold住block，因此需要要防止block产生的retainCycle，不过block产生的retainCycle比较好解决，使用__weak就行
  HHTimer *timer = [[self alloc] init];
  timer.internalUserInfo = userInfo;
  timer.block = block;
  timer.source = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,
                                        0, 0,
                                        queue);
  uint64_t nsec = (uint64_t)(seconds * NSEC_PER_SEC);
  dispatch_source_set_timer(timer.source,
                            dispatch_time(DISPATCH_TIME_NOW, nsec),
                            nsec, 0);
  void (^internalBlock)(void) = ^{
    if (!yesOrNo) {
      block();
      [timer invalidate];
    }else{
      block();
    }
  };
  dispatch_source_set_event_handler(timer.source, internalBlock);
  dispatch_resume(timer.source);
  return timer;
}

- (void)dealloc {
  [self invalidate];
}
#pragma mark --Action
- (void)fire {
  self.block();
}

- (void)invalidate {
  if (self.source) {
    dispatch_source_cancel(self.source);
    self.source = nil;
  }
  self.block = nil;
}

#pragma mark -- State
- (BOOL)isValid
{
  return (self.source != nil);
}

- (id)userInfo
{
  return self.internalUserInfo;
}

@end
