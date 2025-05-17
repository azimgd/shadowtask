#import <ShadowtaskSpec/ShadowtaskSpec.h>

@interface Shadowtask : NativeShadowtaskSpecBase<NativeShadowtaskSpec>

@property (nonatomic, strong) NSMutableDictionary<NSString *, dispatch_source_t> *timers;

@end
