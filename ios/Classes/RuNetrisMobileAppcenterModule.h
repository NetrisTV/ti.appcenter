/**
 * ti.appcenter
 *
 * Created by Your Name
 * Copyright (c) 2019 Your Company. All rights reserved.
 */

#import "RuNetrisMobileAppcenterAnalyticsProxy.h"
#import "RuNetrisMobileAppcenterCrashesProxy.h"
#import "TiModule.h"
#import <Foundation/Foundation.h>

@interface RuNetrisMobileAppcenterModule : TiModule {
  @private
  RuNetrisMobileAppcenterCrashesProxy *crashes;
  RuNetrisMobileAppcenterAnalyticsProxy *analytics;
  BOOL isStarted;
}

@property (readonly, assign) BOOL isStarted;

- (void)start:(id)arguments;
- (NSString *)getApiName;

@end
