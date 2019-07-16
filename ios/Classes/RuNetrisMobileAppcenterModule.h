/**
 * ti.appcenter
 *
 * Created by Your Name
 * Copyright (c) 2019 Your Company. All rights reserved.
 */

#import "TiModule.h"
#import <Foundation/Foundation.h>

@interface RuNetrisMobileAppcenterModule : TiModule {
  BOOL isStarted;
}

@property (readonly, assign) BOOL isStarted;

- (void)start:(id)arguments;
- (NSString *)getApiName;

@end
