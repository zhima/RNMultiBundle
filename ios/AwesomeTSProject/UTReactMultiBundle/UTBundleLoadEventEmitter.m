//
//  UTBundleLoadEventEmitter.m
//  AwesomeTSProject
//
//  Created by Joe on 2021/1/25.
//

#import "UTBundleLoadEventEmitter.h"

NSString *const UTDidLoadBundlePathNotification = @"UTDidLoadBundlePathNotification";
NSString *const UTDidLoadBundlePathEventName = @"DidLoadBundlePath";

@interface UTBundleLoadEventEmitter ()
@property (nonatomic, assign) BOOL hasListeners;
@end

@implementation UTBundleLoadEventEmitter
- (instancetype)init
{
  self = [super init];
  if (self) {
    /** 这里之所以要通过接收 NSNotification 来发送 event到 JS 层，是因为原生层没法直接跟 JS 层通信，原生发消息给JS层必须通过 EventEmitter，而EventEmitter是只能由 JS层实例化然后监听的，原生层没有EventEmitter的实例，所以没法直接调用EventEmitter的实例方法然后发送 event 到 JS层，所以只能通过 NSNotification 做一个中转，原生层->NSNotification->EventEmitter->JS层*/
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(bundleLoaded:)
                                                 name:UTDidLoadBundlePathNotification
                                               object:nil];
  }
  return self;
}

RCT_EXPORT_MODULE();

// Will be called when this module's first listener is added.
-(void)startObserving
{
  self.hasListeners = YES;
  // Set up any upstream listeners or background tasks as necessary
}

// Will be called when this module's last listener is removed, or on dealloc.
-(void)stopObserving
{
  self.hasListeners = NO;
  // Remove upstream listeners, stop unnecessary background tasks
}

- (NSArray<NSString *> *)supportedEvents
{
  return @[UTDidLoadBundlePathEventName];
}

- (void)bundleLoaded:(NSNotification *)notification
{
  NSString *bundlePath = notification.userInfo[@"path"];
  if (self.hasListeners) { // Only send events if anyone is listening
    [self sendEventWithName:UTDidLoadBundlePathEventName body:@{@"path": bundlePath}];
  }
}

+ (BOOL)requiresMainQueueSetup
{
  return YES;
}

@end
