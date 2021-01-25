//
//  UTBundleLoader.m
//  AwesomeTSProject
//
//  Created by Joe on 2021/1/25.
//

#import "UTBundleLoader.h"

#import <React/RCTBridgeDelegate.h>
#import <React/RCTDevSettings.h>
#import <React/RCTLog.h>

NSString *const UTCommonBundleDidLoadNotification = @"UTCommonBundleDidLoadNotification";
NSString *const UTCommonBundleFailToLoadNotification = @"UTCommonBundleFailToLoadNotification";

NSString *const COMMON_BUNDLE_NAME = @"ios.common";



@interface RCTBridge (UTBundleLoader)

- (RCTBridge *)batchedBridge;
- (void)executeSourceCode:(NSData *)sourceCode sync:(BOOL)sync;

@end

@interface UTBundleLoader ()<RCTBridgeDelegate>
@property (nonatomic, strong) RCTBridge *bridge;
@property (nonatomic, strong) NSMutableSet *loadedBundleSet;
@end

@implementation UTBundleLoader

+ (instancetype)sharedInstance {
    static dispatch_once_t pred;
    static UTBundleLoader *instance;
    dispatch_once(&pred, ^{
        instance = [[UTBundleLoader alloc] init];
    });
    return instance;
}

// 进行类的初始化
- (instancetype)init {
    self = [super init];
    if (self) {
      _loadedBundleSet = [NSMutableSet set];
        // 在 Native 中打印 React Native 中的日志，方便真机调试
        RCTSetLogThreshold(RCTLogLevelInfo);
        RCTAddLogFunction(^(RCTLogLevel level, RCTLogSource source, NSString *fileName, NSNumber *lineNumber, NSString *message) {
            NSLog(@"React Native log: %@, %@", @(source), message);
        });
        
        // 保证 React Native 的错误被静默
        RCTSetFatalHandler(^(NSError *error) {
            NSLog(@"React Native Fatal Error: %@", error.localizedDescription);
            // 将错误事件上报，进行统一处理
//            [[NSNotificationCenter defaultCenter] postNotificationName:ReactNativeFatalErrorNotification object:nil];
        });
    }
    return self;
}

// 进行 React Native 的初始化
- (void)initBridge {
    if (!_bridge) {
        // 初始化所有事件监听
        [self addObservers];
        // 初始化 bridge，并且加载基础包
        _bridge = [[RCTBridge alloc] initWithDelegate:self launchOptions:nil];
    }
}

- (BOOL)isBundleLoaded:(NSString *)bundleName
{
  return [self.loadedBundleSet containsObject:bundleName];
}

- (void)loadBundle:(NSString *)bundleName sync:(BOOL)isSync
{
  if (self.bridge == nil) {
    NSLog(@"RCTBridge has not been initialized yet");
    return;
  }
  NSError *error = nil;
  NSURL *jsBundleURL = [[NSBundle mainBundle] URLForResource:bundleName withExtension:@"bundle"];
  NSData *sourceBuz = [NSData dataWithContentsOfURL:jsBundleURL
                                            options:NSDataReadingMappedIfSafe
                                              error:&error];
  if (error) {
    NSLog(@"load business data error:%@", error);
  }
  [self.bridge.batchedBridge executeSourceCode:sourceBuz sync:isSync];
  NSLog(@"after to execute source code");
}

- (void)reloadAllBundle
{
  [self.loadedBundleSet removeAllObjects];
  [self.bridge reload];
}

- (void)addObservers {
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleJSDidLoadNotification:) name:RCTJavaScriptDidLoadNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleJSDidFailToLoadNotification:) name:RCTJavaScriptDidFailToLoadNotification object:nil];
}

- (void)handleJSDidLoadNotification:(NSNotification *)notification
{
  if([self.loadedBundleSet containsObject:COMMON_BUNDLE_NAME]) {
    return;
  }
  [self.loadedBundleSet addObject:COMMON_BUNDLE_NAME];
  [[NSNotificationCenter defaultCenter] postNotificationName:UTCommonBundleDidLoadNotification object:nil];
}

- (void)handleJSDidFailToLoadNotification:(NSNotification *)notification
{
  [[NSNotificationCenter defaultCenter] postNotificationName:UTCommonBundleFailToLoadNotification object:nil];
  NSLog(@"JS Script did load failed:%@", notification);
}

- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge
{
  return  [[NSBundle mainBundle] URLForResource:COMMON_BUNDLE_NAME withExtension:@"bundle"];
}
@end
