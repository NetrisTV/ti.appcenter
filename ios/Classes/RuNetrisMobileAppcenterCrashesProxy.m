//
//  TiAppCenterCrashesModule.m
//  TiAppCenter
//
//  Created by Emin Alekperov on 02/04/2019.
//

#import "RuNetrisMobileAppcenterCrashesProxy.h"
#import "TiAppCenterUtils.h"
#import "TiUtils.h"
#import <AppCenterCrashes/MSCrashes.h>
#import <Foundation/Foundation.h>
#import <KrollCallback.h>

static NSString *const Tag = @"TiAppCenterCrashes";

@implementation RuNetrisMobileAppcenterCrashesProxy

- (NSString *)getApiName {
  return Tag;
}

- (void)lastSessionCrashReport:(id)arguments {
  if (arguments == nil) {
    NSLog([Tag stringByAppendingString:@": Wrong arguments count passed to lastSessionCrashReport()"]);
    return;
  }

  KrollCallback *callback = [TiAppCenterUtils getCallback:(NSArray *)arguments
                                                  atIndex:0
                                                      for:[Tag stringByAppendingString:@": lastSessionCrashReport()"]];

  MSErrorReport *report = [MSCrashes lastSessionCrashReport];
  NSDictionary *result = @{
      @"incidentIdentifier" : report.incidentIdentifier ?: @"",
      @"reporterKey" : report.reporterKey ?: @"",
      @"signal" : report.signal ?: @"",
      @"exceptionName" : report.exceptionName ?: @"",
      @"exceptionReason" : report.exceptionReason ?: @"",
      @"appStartTime" : [NSNumber numberWithDouble:[report.appStartTime timeIntervalSince1970]] ?: 0,
      @"appErrorTime" : [NSNumber numberWithDouble:[report.appErrorTime timeIntervalSince1970]] ?: 0,
      @"appProcessIdentifier" : [NSNumber numberWithInteger:report.appProcessIdentifier] ?: 0
  };

  if (callback != nil) {
    [callback callAsync:[NSArray arrayWithObject:result] thisObject:nil];
  }
}

- (void)hasCrashedInLastSession:(id)arguments {
  if (arguments == nil) {
    NSLog([Tag stringByAppendingString:@": Wrong arguments count passed to hasCrashedInLastSession()"]);
    return;
  }

  KrollCallback *callback = [TiAppCenterUtils getCallback:(NSArray *)arguments atIndex:0 for:Tag];
  if (callback != nil) {
    [callback callAsync:[NSArray arrayWithObject:NUMBOOL([MSCrashes hasCrashedInLastSession])] thisObject:nil];
  }
}

- (void)setEnabled:(id)arguments {
  if (arguments == nil) {
    NSLog([Tag stringByAppendingString:@": Wrong arguments count passed to setEnabled()"]);
    return;
  }

  NSArray *args = (NSArray *)arguments;

  if (args.count == 0 || args.count > 2) {
    NSLog([Tag stringByAppendingString:@": Wrong arguments count passed to setEnabled()"]);
    return;
  }

  BOOL value = [TiUtils boolValue:[args objectAtIndex:0]];

  [MSCrashes setEnabled:value];

  KrollCallback *callback = [TiAppCenterUtils getCallback:args atIndex:2];
  if (callback != nil) {
    [callback callAsync:[NSArray arrayWithObject:NUMBOOL(value)] thisObject:nil];
  }
}

- (void)isEnabled:(id)arguments {
  if (arguments == nil) {
    NSLog([Tag stringByAppendingString:@": Wrong arguments count passed to isEnabled()"]);
    return;
  }

  KrollCallback *callback = [TiAppCenterUtils getCallback:(NSArray *)arguments atIndex:0 for:Tag];
  if (callback != nil) {
    [callback callAsync:[NSArray arrayWithObject:NUMBOOL(MSCrashes.isEnabled)] thisObject:nil];
  }
}

- (void)generateTestCrash:(id)arguments {
  [MSCrashes generateTestCrash];
}

- (void)notifyWithUserConfirmation:(id)arguments {
  if (arguments == nil) {
    NSLog([Tag stringByAppendingString:@": Wrong arguments count passed to notifyWithUserConfirmation()"]);
    return;
  }

  NSArray *args = (NSArray *)arguments;

  if (args.count == 0 || args.count > 2) {
    NSLog([Tag stringByAppendingString:@": Wrong arguments count passed to notifyWithUserConfirmation()"]);
    return;
  }

  NSString *value = [TiUtils stringValue:args[0]];

  if ([value isEqual:self.ALWAYS_SEND]) {
    [MSCrashes notifyWithUserConfirmation:MSUserConfirmationAlways];
  } else if ([value isEqual:self.SEND]) {
    [MSCrashes notifyWithUserConfirmation:MSUserConfirmationSend];
  } else if ([value isEqual:self.DONT_SEND]) {
    [MSCrashes notifyWithUserConfirmation:MSUserConfirmationDontSend];
  } else {
    NSLog([Tag stringByAppendingString:@": A wrong value passed to notifyWithUserConfirmation()"]);
  }

  KrollCallback *callback = [TiAppCenterUtils getCallback:(NSArray *)args atIndex:1];
  if (callback != nil) {
    [callback callAsync:[NSArray arrayWithObject:value] thisObject:nil];
  }
}

MAKE_SYSTEM_STR(DONT_SEND, @"dontsend");
MAKE_SYSTEM_STR(SEND, @"send");
MAKE_SYSTEM_STR(ALWAYS_SEND, @"always");
@end
