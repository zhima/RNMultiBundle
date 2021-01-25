//
//  UTBundleLoadEventEmitter.h
//  AwesomeTSProject
//
//  Created by Joe on 2021/1/25.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const UTDidLoadBundlePathNotification;

@interface UTBundleLoadEventEmitter : RCTEventEmitter<RCTBridgeModule>

@end

NS_ASSUME_NONNULL_END
