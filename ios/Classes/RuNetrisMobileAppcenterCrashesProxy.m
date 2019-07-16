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

- (id)lastSessionCrashReport:(id)arguments
{
  MSErrorReport *report = [MSCrashes lastSessionCrashReport];
  return @{
    @"incidentIdentifier" : report.incidentIdentifier ?: @"",
    @"reporterKey" : report.reporterKey ?: @"",
    @"signal" : report.signal ?: @"",
    @"exceptionName" : report.exceptionName ?: @"",
    @"exceptionReason" : report.exceptionReason ?: @"",
    @"appStartTime" : [NSNumber numberWithDouble:[report.appStartTime timeIntervalSince1970]] ?: 0,
    @"appErrorTime" : [NSNumber numberWithDouble:[report.appErrorTime timeIntervalSince1970]] ?: 0,
    @"appProcessIdentifier" : [NSNumber numberWithInteger:report.appProcessIdentifier] ?: 0
  };
}

- (id)hasCrashedInLastSession:(id)arguments
{
  return NUMBOOL([MSCrashes hasCrashedInLastSession]);
}

- (void)setEnabled:(id)arguments
{
  if (arguments == nil) {
    NSLog([Tag stringByAppendingString:@": Wrong arguments count passed to setEnabled()"]);
    return;
  }

  NSArray *args = (NSArray *)arguments;

  if (args.count == 0) {
    NSLog([Tag stringByAppendingString:@": Wrong arguments count passed to setEnabled()"]);
    return;
  }

  [MSCrashes setEnabled:[TiUtils boolValue:[args objectAtIndex:0]]];
}

- (id)isEnabled:(id)arguments
{
  return NUMBOOL(MSCrashes.isEnabled);
}

- (void)generateTestCrash:(id)arguments
{
  [MSCrashes generateTestCrash];
}

- (void)notifyWithUserConfirmation:(id)arguments
{
  if (arguments == nil) {
    NSLog([Tag stringByAppendingString:@": Wrong arguments count passed to notifyWithUserConfirmation()"]);
    return;
  }

  NSArray *args = (NSArray *)arguments;

  if (args.count == 0) {
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
}

MAKE_SYSTEM_STR(DONT_SEND, @"dontsend");
MAKE_SYSTEM_STR(SEND, @"send");
MAKE_SYSTEM_STR(ALWAYS_SEND, @"always");
@end
