//
//  UTBundleLoader.h
//  AwesomeTSProject
//
//  Created by Joe on 2021/1/25.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridge.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const UTCommonBundleDidLoadNotification;
extern NSString *const UTCommonBundleFailToLoadNotification;
extern NSString *const COMMON_BUNDLE_NAME;

@interface UTBundleLoader : NSObject
@property (nonatomic, strong, readonly) RCTBridge *bridge;

+ (instancetype)sharedInstance;

- (void)initBridge;
- (BOOL)isBundleLoaded:(NSString *)bundleName;
- (void)loadBundle:(NSString *)bundleName sync:(BOOL)isSync;
- (void)reloadAllBundle;

@end

@interface RCTBridge (UTBundleLoader)

- (RCTBridge *)batchedBridge;
- (void)executeSourceCode:(NSData *)sourceCode sync:(BOOL)sync;

@end

NS_ASSUME_NONNULL_END
