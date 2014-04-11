//
//  HHTimer.h
//  HHTimerKit
//
//  Created by lingaohe on 4/11/14.
//  Copyright (c) 2014 ilingaohe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HHTimer : NSObject
//使用DispatchSource设置timer源的方式做定时器，使timer可以不依赖RunLoop,并且timer也不会hold住target，因此不会造成target与timer间互相hold住产生retainCycle的问题
//不过Timer会hold住block，因此需要要防止block产生的retainCycle，不过block产生的retainCycle比较好解决，使用__weak就行
+ (HHTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)seconds
                              dispatchQueue:(dispatch_queue_t)queue
                                      block:(dispatch_block_t)block
                                   userInfo:(id)userInfo
                                    repeats:(BOOL)yesOrNo;

- (void)fire;
- (void)invalidate;

- (BOOL)isValid;
- (id)userInfo;
@end
