//
//  TimerCaseObject.m
//  HHTimerKit
//
//  Created by lingaohe on 4/11/14.
//  Copyright (c) 2014 ilingaohe. All rights reserved.
//

#import "TimerCaseObject.h"
#import "HHTimer.h"
#import "NSTimer+HHBlockSupport.h"

@interface TimerCaseObject ()
@property (nonatomic, strong) NSTimer *timerWithRunLoop;
@property (nonatomic, strong) HHTimer *timerWithDispatchSource;
@end

@implementation TimerCaseObject

#pragma mark --
- (void)dealloc
{
  NSLog(@"%s",__FUNCTION__);
  //释放的时候在dealloc中invalidata timer
  [_timerWithRunLoop invalidate];
  [_timerWithDispatchSource invalidate];
}

#pragma mark -- Internal
- (void)nop
{
  NSLog(@"%s",__FUNCTION__);
}
#pragma mark -- Public
- (void)runTimerWithRetainCycle
{
  //self会hold住NSTimer（只要调用了scheduledTimerxxx方法，即使不保留返回的句柄），同时NSTimer会hold住target（这里为self），这样就产生一个retainCycle。因此只要NSTimer是有效的话，那target就不会被释放，不会调用dealloc方法
  self.timerWithRunLoop = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                           target:self
                                                         selector:@selector(nop)
                                                         userInfo:nil
                                                          repeats:YES];
}
- (void)runTimerWithOutRetainCycle
{
  //写法一：虽然解决了NSTimer hold住target造成的retainCycle，但是还是会产生因为hold住block产生的retainCycle，不过这个retainCycle好解决，参考写法二
//  self.timerWithRunLoop = [NSTimer hh_scheduledTimerWithTimeInterval:1.0f block:^{
//    [self nop];
//  } repeats:YES];
  
  
  //写法二：使用__weak的方式解决因为hold住block产生的retainCycle
  __weak __typeof(self) weakSelf = self;
  self.timerWithRunLoop = [NSTimer hh_scheduledTimerWithTimeInterval:1.0f block:^{
    __strong __typeof(weakSelf) strongSelf = weakSelf;
    [strongSelf nop];
  } repeats:YES];
}
- (void)runTimerWithRunLoop
{
  //NSTimer需要在RunLoop中运行，如果直接在main线程中执行的话，因为main线程已经有RunLoop了，所以不需要显式的启动RunLoop，但是如果是在子线程的话，需要显式的运行RunLoop
  //在主线程中运行NSTimer会产生一个额外的问题，那就是如果主线程卡住的话（比如用户长按具有点击事件的UIControl不松手），那NSTimer也会被卡住
  //使用__weak的方式解决因为hold住block产生的retainCycle
  __weak __typeof(self) weakSelf = self;
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    __strong __typeof(weakSelf) strongSelf = weakSelf;
    [strongSelf runTimerWithOutRetainCycle];
    //因为不是在主线程中运行，所以需要显式的运行NSRunLoop。如果注释掉下面这行代码，那NSTimer定时器将不会被执行
    [[NSRunLoop currentRunLoop] run];
  });
}
- (void)runTimerWithoutRunLoop
{
  //使用DispatchSource设置timer源的方式做定时器，使timer可以不依赖RunLoop
  //使用__weak的方式解决因为hold住block产生的retainCycle
  __weak __typeof(self) weakSelf = self;
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    [HHTimer scheduledTimerWithTimeInterval:1.0f dispatchQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0) block:^{
      __strong __typeof(weakSelf) strongSelf = weakSelf;
      [strongSelf nop];
    } userInfo:nil repeats:YES];
  });
}


@end
