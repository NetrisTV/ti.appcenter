//
//  TiAppCenterCrashesModule.m
//  TiAppCenter
//
//  Created by Emin Alekperov on 02/04/2019.
//

#import "RuNetrisMobileAppcenterCrashesProxy.h"
#import "TiUtils.h"
#import <AppCenterCrashes/MSCrashes.h>
#import <Foundation/Foundation.h>
#import <KrollCallback.h>

static NSString *const Tag = @"TiAppCenterCrashes";

@implementation RuNetrisMobileAppcenterCrashesProxy

- (NSString *)getApiName
{
  return Tag;
}

- (void)lastSessionCrashReport:(id)args
{
  ENSURE_SINGLE_ARG(args, KrollCallback);
  KrollCallback *callback = args;

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

- (void)hasCrashedInLastSession:(id)args
{
  ENSURE_SINGLE_ARG(args, KrollCallback);
  KrollCallback *callback = args;
  if (callback != nil) {
    [callback callAsync:[NSArray arrayWithObject:NUMBOOL([MSCrashes hasCrashedInLastSession])] thisObject:nil];
  }
}

- (void)setEnabled:(id)args
{
  KrollCallback *callback = nil;
  ENSURE_ARG_AT_INDEX(callback, args, 1, KrollCallback);
  BOOL value = [TiUtils boolValue:[args objectAtIndex:0]];

  [MSCrashes setEnabled:value];

  [callback callAsync:[NSArray arrayWithObject:NUMBOOL(value)] thisObject:nil];
}

- (void)isEnabled:(id)args
{
  ENSURE_SINGLE_ARG(args, KrollCallback);
  KrollCallback *callback = args;

  [callback callAsync:[NSArray arrayWithObject:NUMBOOL(MSCrashes.isEnabled)] thisObject:nil];
}

- (void)generateTestCrash:(id)args
{
  [MSCrashes generateTestCrash];
}

- (void)notifyWithUserConfirmation:(id)args
{
  ENSURE_SINGLE_ARG(args, NSString);

  if ([args isEqual:self.ALWAYS_SEND]) {
    [MSCrashes notifyWithUserConfirmation:MSUserConfirmationAlways];
  } else if ([args isEqual:self.SEND]) {
    [MSCrashes notifyWithUserConfirmation:MSUserConfirmationSend];
  } else if ([args isEqual:self.DONT_SEND]) {
    [MSCrashes notifyWithUserConfirmation:MSUserConfirmationDontSend];
  } else {
    NSLog([Tag stringByAppendingString:@": A wrong value passed to notifyWithUserConfirmation()"]);
  }
}

MAKE_SYSTEM_STR(DONT_SEND, @"dontsend");
MAKE_SYSTEM_STR(SEND, @"send");
MAKE_SYSTEM_STR(ALWAYS_SEND, @"always");
@end
