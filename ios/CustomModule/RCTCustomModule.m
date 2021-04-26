//
//  RCTCustomModule.m
//  AwesomeTSProject
//
//  Created by Joe on 2021/1/13.
//

#import "RCTCustomModule.h"

@implementation RCTCustomModule

RCT_EXPORT_MODULE(CustomModule);

RCT_EXPORT_METHOD(loadBundle:(NSString *)bundleName
                 resolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
  [[NSNotificationCenter defaultCenter] postNotificationName:@"UTCOOKReloadScriptNotification" object:nil userInfo:@{@"BundleName": bundleName}];
  resolve(@"update script success from native");
}

RCT_EXPORT_METHOD(gotoFirstPage:(NSString *)scriptName
                 resolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
  [[NSNotificationCenter defaultCenter] postNotificationName:@"UTCOOKGotoPageNotification" object:nil];
  resolve(@"go to first Page success from native");
}

- (NSArray<NSString *> *)supportedEvents
{
  return nil;
}

- (dispatch_queue_t)methodQueue
{
  return dispatch_get_main_queue();
}

@end
