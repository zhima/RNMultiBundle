#import "AppDelegate.h"

#import <React/RCTBridge.h>
#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>
#import <React/RCTJavaScriptLoader.h>

#import <React/RCTDevSettings.h>
#import <React/RCTLog.h>

#import <CodePush/CodePush.h>
#import "UTBundleLoader.h"
#import "UTReactViewController.h"

#ifdef FB_SONARKIT_ENABLED
#import <FlipperKit/FlipperClient.h>
#import <FlipperKitLayoutPlugin/FlipperKitLayoutPlugin.h>
#import <FlipperKitUserDefaultsPlugin/FKUserDefaultsPlugin.h>
#import <FlipperKitNetworkPlugin/FlipperKitNetworkPlugin.h>
#import <SKIOSNetworkPlugin/SKIOSNetworkAdapter.h>
#import <FlipperKitReactPlugin/FlipperKitReactPlugin.h>

static void InitializeFlipper(UIApplication *application) {
  FlipperClient *client = [FlipperClient sharedClient];
  SKDescriptorMapper *layoutDescriptorMapper = [[SKDescriptorMapper alloc] initWithDefaults];
  [client addPlugin:[[FlipperKitLayoutPlugin alloc] initWithRootNode:application withDescriptorMapper:layoutDescriptorMapper]];
  [client addPlugin:[[FKUserDefaultsPlugin alloc] initWithSuiteName:nil]];
  [client addPlugin:[FlipperKitReactPlugin new]];
  [client addPlugin:[[FlipperKitNetworkPlugin alloc] initWithNetworkAdapter:[SKIOSNetworkAdapter new]]];
  [client start];
}
#endif

@interface AppDelegate ()
@property (nonatomic, assign) BOOL isNewBundle;
@property (nonatomic, strong) UINavigationController *navig;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
#ifdef FB_SONARKIT_ENABLED
  InitializeFlipper(application);
#endif
  
  self.isNewBundle = NO;
  

  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadScript) name:@"UTCOOKReloadScriptNotification" object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoFirstPage) name:@"UTCOOKGotoPageNotification" object:nil];
  
//  RCTBridge *bridge = [[RCTBridge alloc] initWithDelegate:self launchOptions:launchOptions];
//  [ScriptLoadUtil init:bridge];
  
  [[UTBundleLoader sharedInstance] initBridge];
  
  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  UIViewController *rootViewController = [[UTReactViewController alloc] initWithBundle:@"ios.index.main" moduleName:@"MainRootPage"];
  UINavigationController *navig = [[UINavigationController alloc] initWithRootViewController:rootViewController];
//  navig.navigationBarHidden = YES;
  self.navig = navig;
  self.window.rootViewController = navig;
  [self.window makeKeyAndVisible];
  return YES;
}

- (void)gotoFirstPage
{
  UTReactViewController *busnVC = [[UTReactViewController alloc] initWithBundle:@"ios.index.busn1" moduleName:@"AwesomeTSProject"];
  [self.navig pushViewController:busnVC animated:YES];
//  NSError *error = nil;
//  NSString *bundleName = self.isNewBundle ? @"ios.index.busn2" : @"ios.index.busn1";
//  NSLog(@"load bundle script:%@", bundleName);
//  NSData *sourceBuz = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:bundleName withExtension:@"bundle"]
//                                            options:NSDataReadingMappedIfSafe
//                                              error:&error];
//
//  if (error) {
//    NSLog(@"load business data error:%@", error);
//  }
//  RCTBridge *bridge = [ScriptLoadUtil getBridge];
//  NSLog(@"begin to execute source code");
//  [bridge.batchedBridge executeSourceCode:sourceBuz sync:YES];
//  NSLog(@"after to execute source code");
//
//  dispatch_async(dispatch_get_main_queue(), ^{
//    RCTRootView *rootView = [[RCTRootView alloc] initWithBridge:bridge
//                                                     moduleName:@"AwesomeTSProject"
//                                              initialProperties:nil];
//
//    rootView.backgroundColor = [[UIColor alloc] initWithRed:1.0f green:1.0f blue:1.0f alpha:1];
//    UIViewController *firstVC = [UIViewController new];
//    firstVC.view = rootView;
//    [self.navig pushViewController:firstVC animated:YES];
//  });
}

- (void)reloadScript
{
  NSLog(@"reloadScript");
  self.isNewBundle = !self.isNewBundle;

}

//由于在 UTBundleLoader 中已经实现了 RCTBridgeDelegate，所以这里其实是可以删掉的，但是为了之后 debug 用所以保留
- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge
{
//#if DEBUG
//  return [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index" fallbackResource:nil];
//#else
//  return [CodePush bundleURL];
//#endif
  return  [[NSBundle mainBundle] URLForResource:@"ios.common" withExtension:@"bundle"];
}

@end
