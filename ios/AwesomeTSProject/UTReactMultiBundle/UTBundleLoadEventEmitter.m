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
