//
//  AppDelegate.m
//  HHTimerKit
//
//  Created by lingaohe on 4/11/14.
//  Copyright (c) 2014 ilingaohe. All rights reserved.
//

#import "AppDelegate.h"
#import "TimerCaseObject.h"

@interface AppDelegate ()
@property (nonatomic, strong) TimerCaseObject *timerCaseObject;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
  [self setupData];
    return YES;
}

- (void)setupData
{
  //方式一：使用系统的NSTimer，NSTimer会hold住target,会造成retainCycle
  [self runTimerWithRetainCycle];
  
  //方式二：使用Category的NSTimer，不hold住target，解决retainCycle的问题
//  [self runTimerWithOutRetainCycle];
  
  //方式三：使用系统的NSTimer需要在RunLoo中运行
//  [self runTimerWithRunLoop];
  
  //方式四：使用DispatchSource设置timer源的方式，是timer可以不依赖RunLoop
//  [self runTimerWithoutRunLoop];
}

- (void)runTimerWithRetainCycle
{
  TimerCaseObject *timerCaseObject = [[TimerCaseObject alloc] init];
  //方式一：使用系统的NSTimer，NSTimer会hold住target,会造成retainCycle
  [timerCaseObject runTimerWithRetainCycle];
}
- (void)runTimerWithOutRetainCycle
{
  TimerCaseObject *timerCaseObject = [[TimerCaseObject alloc] init];
  //方式二：使用Category的NSTimer，不hold住target，解决retainCycle的问题
  [timerCaseObject runTimerWithOutRetainCycle];
  
  //因为解决了retainCycle的问题，所以如果外面不hold住timerCaseObject的话，timerCaseObject会马上就释放
  self.timerCaseObject = timerCaseObject;
}
- (void)runTimerWithRunLoop
{
  TimerCaseObject *timerCaseObject = [[TimerCaseObject alloc] init];
  //方式三：使用系统的NSTimer需要在RunLoo中运行
  [timerCaseObject runTimerWithRunLoop];
  //因为解决了retainCycle的问题，所以如果外面不hold住timerCaseObject的话，timerCaseObject会马上就释放
  self.timerCaseObject = timerCaseObject;
}
- (void)runTimerWithoutRunLoop
{
  TimerCaseObject *timerCaseObject = [[TimerCaseObject alloc] init];
  //方式四：使用DispatchSource设置timer源的方式，使timer可以不依赖RunLoop
  [timerCaseObject runTimerWithoutRunLoop];
  //因为解决了retainCycle的问题，所以如果外面不hold住timerCaseObject的话，timerCaseObject会马上就释放
  self.timerCaseObject = timerCaseObject;
}
@end
