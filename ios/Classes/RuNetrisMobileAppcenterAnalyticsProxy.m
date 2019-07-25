//
//  TiAppCenterAnalyticsModule.m
//  TiAppCenter
//
//  Created by Emin Alekperov on 02/04/2019.
//

#import "RuNetrisMobileAppcenterAnalyticsProxy.h"
#import "AppCenterAnalytics/AppCenterAnalytics.h"
#import "TiUtils.h"

static NSString *const Tag = @"TiAppCenterAnalytics";

@implementation RuNetrisMobileAppcenterAnalyticsProxy

NSMutableDictionary *mTransmissionTargets;

- (id)init
{
  if (self = [super init]) {
    mTransmissionTargets = [[NSMutableDictionary alloc] init];
  }

  return self;
}

- (NSString *)getApiName
{
  return Tag;
}

- (void)setEnabled:(id)args
{
  KrollCallback *callback = nil;
  ENSURE_ARG_AT_INDEX(callback, args, 1, KrollCallback);
  BOOL value = [TiUtils boolValue:[args objectAtIndex:0]];

  [MSAnalytics setEnabled:value];

  [callback callAsync:[NSArray arrayWithObject:NUMBOOL(value)] thisObject:self];
}

- (void)isEnabled:(id)args
{
  ENSURE_SINGLE_ARG(args, KrollCallback);
  KrollCallback *callback = args;
  [callback callAsync:[NSArray arrayWithObject:NUMBOOL(MSAnalytics.isEnabled)] thisObject:self];
}

- (void)trackEvent:(id)args
{
  NSString *eventName = nil;
  NSDictionary *properties = nil;

  ENSURE_ARG_AT_INDEX(eventName, args, 0, NSString);
  ENSURE_ARG_AT_INDEX(properties, args, 1, NSDictionary);

  [MSAnalytics trackEvent:eventName withProperties:properties];
}

- (void)trackTransmissionTargetEvent:(id)args
{
  NSString *eventName = nil;
  NSDictionary *properties = nil;
  NSString *targetToken = nil;

  ENSURE_ARG_AT_INDEX(eventName, args, 0, NSString);
  ENSURE_ARG_AT_INDEX(properties, args, 1, NSDictionary);
  ENSURE_ARG_AT_INDEX(targetToken, args, 2, NSString);

  MSAnalyticsTransmissionTarget *transmissionTarget = (MSAnalyticsTransmissionTarget *)[mTransmissionTargets objectForKey:targetToken];
  if (transmissionTarget != nil) {
    [transmissionTarget trackEvent:eventName withProperties:properties];
  }
}

- (NSString *)getTransmissionTarget:(id)args
{
  NSString *targetToken = nil;
  KrollCallback *callback = nil;
  ENSURE_ARG_AT_INDEX(targetToken, args, 0, NSString);
  ENSURE_ARG_AT_INDEX(callback, args, 1, KrollCallback);

  MSAnalyticsTransmissionTarget *transmissionTarget = [mTransmissionTargets objectForKey:targetToken];
  if (transmissionTarget == nil) {
    return nil;
  } else {
    [mTransmissionTargets setObject:transmissionTarget forKey:targetToken];
    return targetToken;
  }
}

- (void)isTransmissionTargetEnabled:(id)args
{
  NSString *targetToken = nil;
  KrollCallback *callback = nil;
  ENSURE_ARG_AT_INDEX(targetToken, args, 0, NSString);
  ENSURE_ARG_AT_INDEX(callback, args, 1, KrollCallback);

  MSAnalyticsTransmissionTarget *transmissionTarget = (MSAnalyticsTransmissionTarget *)[mTransmissionTargets objectForKey:targetToken];
  if (transmissionTarget == nil) {
    [callback call:nil thisObject:self];
  } else {
    [callback call:[NSArray arrayWithObject:[NSNumber numberWithBool:[transmissionTarget isEnabled]]] thisObject:self];
  }
}

- (void)setTransmissionTargetEnabled:(id)args
{
  NSString *targetToken = nil;
  KrollCallback *callback = nil;
  ENSURE_ARG_AT_INDEX(targetToken, args, 0, NSString);
  ENSURE_ARG_AT_INDEX(callback, args, 1, KrollCallback);
  BOOL enabled = [TiUtils boolValue:[args objectAtIndex:0]];

  MSAnalyticsTransmissionTarget *transmissionTarget = [mTransmissionTargets objectForKey:targetToken];
  if (transmissionTarget == nil) {
    [callback call:nil thisObject:self];
  } else {
    [transmissionTarget setEnabled:enabled];

    [callback call:[NSArray arrayWithObject:[NSNumber numberWithBool:enabled]] thisObject:self];
  }
}

- (void)setTransmissionTargetEventProperty:(id)args
{
  NSString *propertyKey = nil;
  NSString *propertyValue = nil;
  NSString *targetToken = nil;
  ENSURE_ARG_AT_INDEX(propertyKey, args, 0, NSString);
  ENSURE_ARG_AT_INDEX(propertyValue, args, 1, NSString);
  ENSURE_ARG_AT_INDEX(targetToken, args, 2, NSString);

  MSAnalyticsTransmissionTarget *transmissionTarget = [mTransmissionTargets objectForKey:targetToken];
  if (transmissionTarget != nil) {
    MSPropertyConfigurator *configurator = [transmissionTarget propertyConfigurator];
    [configurator setEventPropertyString:propertyKey forKey:propertyValue];
  }
}

- (void)removeTransmissionTargetEventProperty:(id)args
{
  NSString *propertyKey = nil;
  NSString *targetToken = nil;
  ENSURE_ARG_AT_INDEX(propertyKey, args, 0, NSString);
  ENSURE_ARG_AT_INDEX(targetToken, args, 1, NSString);

  MSAnalyticsTransmissionTarget *transmissionTarget = [mTransmissionTargets objectForKey:targetToken];
  if (transmissionTarget != nil) {
    MSPropertyConfigurator *configurator = [transmissionTarget propertyConfigurator];
    [configurator removeEventPropertyForKey:propertyKey];
  }
}

- (void)collectTransmissionTargetDeviceId:(id)args
{
  ENSURE_SINGLE_ARG(args, NSString)

  MSAnalyticsTransmissionTarget *transmissionTarget = [mTransmissionTargets objectForKey:args];
  if (transmissionTarget != nil) {
    MSPropertyConfigurator *configurator = [transmissionTarget propertyConfigurator];
    [configurator collectDeviceId];
  }
}

- (NSString *)getChildTransmissionTarget:(id)args
{
  NSString *childToken = nil;
  NSString *targetToken = nil;
  ENSURE_ARG_AT_INDEX(childToken, args, 0, NSString);
  ENSURE_ARG_AT_INDEX(targetToken, args, 1, NSString);

  MSAnalyticsTransmissionTarget *transmissionTarget = [mTransmissionTargets objectForKey:targetToken];
  if (transmissionTarget == nil) {
    return nil;
  }

  MSAnalyticsTransmissionTarget *childTarget = [transmissionTarget transmissionTargetForToken:childToken];
  if (childTarget == nil) {
    return nil;
  }

  [mTransmissionTargets setObject:childTarget forKey:childToken];
  return childToken;
}

- (void)setTransmissionTargetAppName:(id)args
{
  NSString *appName = nil;
  NSString *targetToken = nil;
  ENSURE_ARG_AT_INDEX(appName, args, 0, NSString);
  ENSURE_ARG_AT_INDEX(targetToken, args, 1, NSString);

  MSAnalyticsTransmissionTarget *transmissionTarget = [mTransmissionTargets objectForKey:targetToken];
  if (transmissionTarget != nil) {
    MSPropertyConfigurator *configurator = [transmissionTarget propertyConfigurator];
    [configurator setAppName:appName];
  }
}

- (void)setTransmissionTargetAppVersion:(id)args
{
  NSString *appVersion = nil;
  NSString *targetToken = nil;
  ENSURE_ARG_AT_INDEX(appVersion, args, 0, NSString);
  ENSURE_ARG_AT_INDEX(targetToken, args, 1, NSString);

  MSAnalyticsTransmissionTarget *transmissionTarget = [mTransmissionTargets objectForKey:targetToken];
  if (transmissionTarget != nil) {
    MSPropertyConfigurator *configurator = [transmissionTarget propertyConfigurator];
    [configurator setAppVersion:appVersion];
  }
}

- (void)setTransmissionTargetAppLocale:(id)args
{
  NSString *appLocale = nil;
  NSString *targetToken = nil;
  ENSURE_ARG_AT_INDEX(appLocale, args, 0, NSString);
  ENSURE_ARG_AT_INDEX(targetToken, args, 1, NSString);

  MSAnalyticsTransmissionTarget *transmissionTarget = [mTransmissionTargets objectForKey:targetToken];
  if (transmissionTarget != nil) {
    MSPropertyConfigurator *configurator = [transmissionTarget propertyConfigurator];
    [configurator setAppLocale:appLocale];
  }
}

@end
