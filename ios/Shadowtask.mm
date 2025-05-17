#import "Shadowtask.h"

@implementation Shadowtask

RCT_EXPORT_MODULE()

- (instancetype)init {
  if (self = [super init]) {
    _timers = [NSMutableDictionary dictionary];
  }
  return self;
}

- (void)dealloc {
  [self invalidateAllTimers];
}

- (void)invalidateAllTimers {
  for (NSString *timerId in self.timers) {
    dispatch_source_t timer = self.timers[timerId];
    dispatch_source_cancel(timer);
  }
  [self.timers removeAllObjects];
}

- (NSNumber *)registerRecurringTask:(NSString *)taskId
  interval:(double)interval {

  // Check if timer with this ID already exists
  if (self.timers[taskId]) {
    dispatch_source_cancel(self.timers[taskId]);
    [self.timers removeObjectForKey:taskId];
  }

  dispatch_queue_t queue = dispatch_get_main_queue();
  dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
  
  /*
   * Set the timer with the interval
   */
  dispatch_source_set_timer(
    timer,
    dispatch_time(DISPATCH_TIME_NOW, 0),
    interval * NSEC_PER_MSEC,
    0);

  __weak __typeof(self) weakSelf = self;
  dispatch_source_set_event_handler(timer, ^{
    __typeof(self) strongSelf = weakSelf;
    if (strongSelf) {
      NSMutableDictionary *eventData = [NSMutableDictionary dictionaryWithDictionary:@{
        @"taskId": taskId,
      }];
      [eventData setObject:taskId forKey:@"taskId"];
      [strongSelf emitOnRecurringTaskUpdate:eventData];
    }
  });

  dispatch_resume(timer);
  self.timers[taskId] = timer;

  return @YES;
}

- (NSNumber *)registerRandomRecurringTask:(NSString *)taskId
  minInterval:(double)minInterval
  maxInterval:(double)maxInterval {

  if (self.timers[taskId]) {
    dispatch_source_cancel(self.timers[taskId]);
    [self.timers removeObjectForKey:taskId];
  }

  dispatch_queue_t queue = dispatch_get_main_queue();
  dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
  
  __weak __typeof(self) weakSelf = self;
  
  /*
   * Set up a handler to reset the timer with a new random interval
   */
  dispatch_source_set_event_handler(timer, ^{
    __typeof(self) strongSelf = weakSelf;
    if (strongSelf) {
      NSMutableDictionary *eventData = [NSMutableDictionary dictionaryWithDictionary:@{
        @"taskId": taskId,
      }];
      [eventData setObject:taskId forKey:@"taskId"];
      [strongSelf emitOnRecurringTaskUpdate:eventData];

      // Next random interval
      uint64_t nextInterval = arc4random_uniform((uint32_t)(maxInterval - minInterval + 1)) + minInterval;
      
      /*
       * Reset the timer with the new interval and set to oneshot mode
       */
      dispatch_source_set_timer(
        timer,
        dispatch_time(DISPATCH_TIME_NOW, nextInterval * NSEC_PER_MSEC),
        DISPATCH_TIME_FOREVER,
        0);
    }
  });
  
  // Initial timer at random interval between min and max
  uint64_t initialInterval = arc4random_uniform((uint32_t)(maxInterval - minInterval + 1)) + minInterval;
  
  dispatch_source_set_timer(
    timer,
    dispatch_time(DISPATCH_TIME_NOW, initialInterval * NSEC_PER_MSEC),
    DISPATCH_TIME_FOREVER, 
    0);

  dispatch_resume(timer);
  self.timers[taskId] = timer;
  
  return @YES;
}


- (NSNumber *)unregisterRecurringTask:(NSString *)taskId {
  if (self.timers[taskId]) {
    dispatch_source_cancel(self.timers[taskId]);
    [self.timers removeObjectForKey:taskId];
    return @YES;
  }
  return @NO;
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
  (const facebook::react::ObjCTurboModule::InitParams &)params {
  return std::make_shared<facebook::react::NativeShadowtaskSpecJSI>(params);
}

@end
