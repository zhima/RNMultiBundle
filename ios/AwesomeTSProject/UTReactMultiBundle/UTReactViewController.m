//
//  UTReactViewController.m
//  AwesomeTSProject
//
//  Created by Joe on 2021/1/25.
//

#import "UTReactViewController.h"
#import <React/RCTRootView.h>
#import "UTBundleLoader.h"
#import "UTBundleLoadEventEmitter.h"

@interface UTReactViewController ()
@property (nonatomic, copy) NSString *bundleName;
@property (nonatomic, copy) NSString *moduleName;
@property (nonatomic, strong) UIActivityIndicatorView* loadingView;
@end

@implementation UTReactViewController

- (instancetype)initWithBundle:(NSString *)bundleName moduleName:(NSString *)moduleName
{
  self = [super init];
  if (self) {
    _bundleName = [bundleName copy];
    _moduleName = [moduleName copy];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];
  
  UTBundleLoader *bundleLoader = [UTBundleLoader sharedInstance];
  if([bundleLoader isBundleLoaded:COMMON_BUNDLE_NAME]) {
    if([bundleLoader isBundleLoaded:self.bundleName]) {
      [self initView];
    } else {
      [self loadBundle];
      [self initView];
    }
  } else {
    [self addObserver];
    
    UIActivityIndicatorView* loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhiteLarge)];
    loadingView.center = self.view.center;
    loadingView.color = [UIColor darkGrayColor];
    [self.view addSubview:loadingView];
    [loadingView startAnimating];
    self.loadingView = loadingView;
  }
}

- (void)addObserver
{
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCommonBundleDidLoadNotification:) name:UTCommonBundleDidLoadNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCommonBundleFailToLoadNotification:) name:UTCommonBundleFailToLoadNotification object:nil];
}

- (void)handleCommonBundleDidLoadNotification:(NSNotification *)notification
{
  dispatch_async(dispatch_get_main_queue(), ^{
    if (self.loadingView != nil) {
      [self.loadingView stopAnimating];
      [self.loadingView removeFromSuperview];
      self.loadingView = nil;
    }
    [self loadBundle];
    [self initView];
  });
}

- (void)handleCommonBundleFailToLoadNotification:(NSNotification *)notification
{
  NSLog(@"Failed to load common bundle:%@", notification);
}

- (void)loadBundle
{
  NSString* mainBundlePath = [NSBundle mainBundle].bundlePath;
  NSString* jsBundlePath = [NSString stringWithFormat:@"file://%@/", mainBundlePath];
  [[NSNotificationCenter defaultCenter] postNotificationName:UTDidLoadBundlePathNotification object:nil userInfo:@{@"path":jsBundlePath}];//通知rn更换查找图片资源的路径
  [[UTBundleLoader sharedInstance] loadBundle:self.bundleName sync:NO];
}

- (void)initView{
  RCTBridge* bridge = [UTBundleLoader sharedInstance].bridge;
  RCTRootView* view = [[RCTRootView alloc] initWithBridge:bridge moduleName:self.moduleName initialProperties:nil];
  view.frame = self.view.bounds;
  view.backgroundColor = [UIColor whiteColor];
  self.view = view;
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
