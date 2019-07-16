//
//  TiAppCenterAnalyticsModule.m
//  TiAppCenter
//
//  Created by Emin Alekperov on 02/04/2019.
//

#import "RuNetrisMobileAppcenterAnalyticsProxy.h"
#import "TiUtils.h"
#import "AppCenterAnalytics/AppCenterAnalytics.h"

static NSString *const Tag = @"TiAppCenterAnalytics";

@implementation RuNetrisMobileAppcenterAnalyticsProxy

NSMutableDictionary *mTransmissionTargets;

- (id)init {
    if (self = [super init]) {
        mTransmissionTargets = [[NSMutableDictionary alloc] init];
    }
        
    return self;
}

- (NSString *)getApiName
{
    return Tag;
}

- (void)setEnabled:(id)arguments
{
    if (arguments == nil) {
        NSLog([Tag stringByAppendingString:@": Wrong arguments count passed to setEnabled()"]);
        return;
    }
    
    NSArray *args = (NSArray *) arguments;
    
    if (args.count == 0) {
        NSLog([Tag stringByAppendingString:@": Wrong arguments count passed to setEnabled()"]);
        return;
    }
    
    [MSAnalytics setEnabled:[TiUtils boolValue:[args objectAtIndex:0]]];
}

- (void)isEnabled:(id)arguments
{
    return MSAnalytics.isEnabled;
}

- (void)trackEvent:(id)arguments
{
    if (arguments == nil) {
        NSLog([Tag stringByAppendingString:@": Wrong arguments count passed to trackEvent()"]);
        return;
    }
    
    NSArray *args = (NSArray *) arguments;
    
    if (args.count == 0) {
        NSLog([Tag stringByAppendingString:@": Wrong arguments count passed to trackEvent()"]);
        return;
    }

    NSString *eventName = [TiUtils stringValue:[args objectAtIndex:0]];
    
    NSDictionary *properties;
    if (args.count > 1) {
        NSObject *item = [args objectAtIndex:1];
        if ([item isKindOfClass:[NSDictionary class]]) {
            properties = (NSDictionary *)item;
        }
    }
    
    KrollCallback *callback;
    if (args.count > 2) {
        NSObject *item = [args objectAtIndex:2];
        if ([item isKindOfClass:[KrollCallback class]]) {
            callback = (KrollCallback *)item;
        }
    }

    [MSAnalytics trackEvent:eventName withProperties:properties];

    if (callback != nil) {
        [callback call:nil thisObject:Tag];
    }
}

- (void)trackTransmissionTargetEvent:(id)arguments
{
    if (arguments == nil) {
        NSLog([Tag stringByAppendingString:@": Wrong arguments count passed to trackTransmissionTargetEvent()"]);
        return;
    }
    
    NSArray *args = (NSArray *) arguments;
    
    if (args.count == 0) {
        NSLog([Tag stringByAppendingString:@": Wrong arguments count passed to trackTransmissionTargetEvent()"]);
        return;
    }
    
    NSString *eventName = [TiUtils stringValue:[args objectAtIndex:0]];
    
    NSObject *item;
    
    NSDictionary *properties;
    if (args.count > 1) {
        item = [args objectAtIndex:1];
        if ([item isKindOfClass:[NSDictionary class]]) {
            properties = (NSDictionary *)item;
        }
    }
    
    NSString *targetToken = @"";
    if (args.count > 2) {
        item = [args objectAtIndex:2];
        if ([item isKindOfClass:[NSString class]]) {
            targetToken = (NSString *)item;
        }
    }
    
    KrollCallback *callback;
    if (args.count > 3) {
        item = [args objectAtIndex:3];
        if ([item isKindOfClass:[KrollCallback class]]) {
            callback = (KrollCallback *)item;
        }
    }
    
    MSAnalyticsTransmissionTarget *transmissionTarget = (MSAnalyticsTransmissionTarget *)[mTransmissionTargets objectForKey:targetToken];
    if (transmissionTarget != nil) {
        [transmissionTarget trackEvent:eventName withProperties:properties];
    }
    
    if (callback != nil) {
        [callback call:nil thisObject:Tag];
    }
}

- (void)getTransmissionTarget:(id)arguments
{
    if (arguments == nil) {
        NSLog([Tag stringByAppendingString:@": Wrong arguments count passed to getTransmissionTarget()"]);
        return;
    }
    
    NSArray *args = (NSArray *) arguments;
    
    if (args.count < 2) {
        NSLog([Tag stringByAppendingString:@": Wrong arguments count passed to getTransmissionTarget()"]);
        return;
    }
    
    NSString *targetToken = [TiUtils stringValue:[args objectAtIndex:0]];
    KrollCallback *callback = (KrollCallback *)[args objectAtIndex:1];
    
    if (callback == nil) {
        NSLog([Tag stringByAppendingString:@": No callback passed to getTransmissionTarget()"]);
        return;
    }
    
    MSAnalyticsTransmissionTarget *transmissionTarget = [mTransmissionTargets objectForKey:targetToken];
    if (transmissionTarget == nil) {
        [callback call:nil thisObject:Tag];
    } else {
        [mTransmissionTargets setObject:transmissionTarget forKey:targetToken];
        
        [callback call:[NSArray arrayWithObject:targetToken] thisObject:Tag];
    }
}

- (void)isTransmissionTargetEnabled:(id)arguments
{
    if (arguments == nil) {
        NSLog([Tag stringByAppendingString:@": Wrong arguments count passed to isTransmissionTargetEnabled()"]);
        return;
    }
    
    NSArray *args = (NSArray *) arguments;
    
    if (args.count < 2) {
        NSLog([Tag stringByAppendingString:@": Wrong arguments count passed to isTransmissionTargetEnabled()"]);
        return;
    }
    
    NSString *targetToken = [TiUtils stringValue:[args objectAtIndex:0]];
    KrollCallback *callback = (KrollCallback *)[args objectAtIndex:1];
    
    if (callback == nil) {
        NSLog([Tag stringByAppendingString:@": No callback passed to isTransmissionTargetEnabled()"]);
        return;
    }
    
    MSAnalyticsTransmissionTarget *transmissionTarget = (MSAnalyticsTransmissionTarget *)[mTransmissionTargets objectForKey:targetToken];
    if (transmissionTarget == nil) {
        [callback call:nil thisObject:Tag];
    } else {
        [callback call:[NSArray arrayWithObject:[NSNumber numberWithBool:[transmissionTarget isEnabled]]] thisObject:Tag];
    }
}

- (void)setTransmissionTargetEnabled:(id)arguments
{
    if (arguments == nil) {
        NSLog([Tag stringByAppendingString:@": Wrong arguments count passed to setTransmissionTargetEnabled()"]);
        return;
    }
    
    NSArray *args = (NSArray *) arguments;
    
    if (args.count < 3) {
        NSLog([Tag stringByAppendingString:@": Wrong arguments count passed to setTransmissionTargetEnabled()"]);
        return;
    }
    
    BOOL enabled = [TiUtils boolValue:[args objectAtIndex:0]];
    NSString *targetToken = [TiUtils stringValue:[args objectAtIndex:1]];
    KrollCallback *callback = (KrollCallback *)[args objectAtIndex:2];
    
    if (callback == nil) {
        NSLog([Tag stringByAppendingString:@": No callback passed to setTransmissionTargetEnabled()"]);
        return;
    }
    
    
    MSAnalyticsTransmissionTarget *transmissionTarget = [mTransmissionTargets objectForKey:targetToken];
    if (transmissionTarget == nil) {
        [callback call:nil thisObject:Tag];
    } else {
        [transmissionTarget setEnabled:enabled];
        
        [callback call:[NSArray arrayWithObject:[NSNumber numberWithBool:enabled]] thisObject:Tag];
    }
}

- (void)setTransmissionTargetEventProperty:(id)arguments
{
    if (arguments == nil) {
        NSLog([Tag stringByAppendingString:@": Wrong arguments count passed to setTransmissionTargetEventProperty()"]);
        return;
    }
    
    NSArray *args = (NSArray *) arguments;
    
    if (args.count < 4) {
        NSLog([Tag stringByAppendingString:@": Wrong arguments count passed to setTransmissionTargetEventProperty()"]);
        return;
    }
    
    NSString *propertyKey = [TiUtils stringValue:[args objectAtIndex:0]];
    NSString *propertyValue = [TiUtils stringValue:[args objectAtIndex:1]];
    NSString *targetToken = [TiUtils stringValue:[args objectAtIndex:2]];
    KrollCallback *callback = (KrollCallback *)[args objectAtIndex:3];
    
    if (callback == nil) {
        NSLog([Tag stringByAppendingString:@": No callback passed to setTransmissionTargetEventProperty()"]);
        return;
    }
    
    MSAnalyticsTransmissionTarget *transmissionTarget = [mTransmissionTargets objectForKey:targetToken];
    if (transmissionTarget != nil) {
        MSPropertyConfigurator *configurator = [transmissionTarget propertyConfigurator];
        [configurator setEventPropertyString:propertyKey forKey:propertyValue];
    }
    
    [callback call:nil thisObject:Tag];
}

- (void)removeTransmissionTargetEventProperty:(id)arguments
{
    if (arguments == nil) {
        NSLog([Tag stringByAppendingString:@": Wrong arguments count passed to removeTransmissionTargetEventProperty()"]);
        return;
    }
    
    NSArray *args = (NSArray *) arguments;
    
    if (args.count < 3) {
        NSLog([Tag stringByAppendingString:@": Wrong arguments count passed to removeTransmissionTargetEventProperty()"]);
        return;
    }
    
    NSString *propertyKey = [TiUtils stringValue:[args objectAtIndex:0]];
    NSString *targetToken = [TiUtils stringValue:[args objectAtIndex:1]];
    KrollCallback *callback = (KrollCallback *)[args objectAtIndex:2];
    
    if (callback == nil) {
        NSLog([Tag stringByAppendingString:@": No callback passed to removeTransmissionTargetEventProperty()"]);
        return;
    }
    
    MSAnalyticsTransmissionTarget *transmissionTarget = [mTransmissionTargets objectForKey:targetToken];
    if (transmissionTarget != nil) {
        MSPropertyConfigurator *configurator = [transmissionTarget propertyConfigurator];
        [configurator removeEventPropertyForKey:propertyKey];
    }
    
    [callback call:nil thisObject:Tag];
}

- (void)collectTransmissionTargetDeviceId:(id)arguments
{
    if (arguments == nil) {
        NSLog([Tag stringByAppendingString:@": Wrong arguments count passed to collectTransmissionTargetDeviceId()"]);
        return;
    }
    
    NSArray *args = (NSArray *) arguments;
    
    if (args.count < 2) {
        NSLog([Tag stringByAppendingString:@": Wrong arguments count passed to collectTransmissionTargetDeviceId()"]);
        return;
    }
    
    NSString *targetToken = [TiUtils stringValue:[args objectAtIndex:0]];
    KrollCallback *callback = (KrollCallback *)[args objectAtIndex:1];
    
    if (callback == nil) {
        NSLog([Tag stringByAppendingString:@": No callback passed to collectTransmissionTargetDeviceId()"]);
        return;
    }
    
    MSAnalyticsTransmissionTarget *transmissionTarget = [mTransmissionTargets objectForKey:targetToken];
    if (transmissionTarget != nil) {
        MSPropertyConfigurator *configurator = [transmissionTarget propertyConfigurator];
        [configurator collectDeviceId];
    }
    
    [callback call:nil thisObject:Tag];
}

- (void)getChildTransmissionTarget:(id)arguments
{
    if (arguments == nil) {
        NSLog([Tag stringByAppendingString:@": Wrong arguments count passed to getChildTransmissionTarget()"]);
        return;
    }
    
    NSArray *args = (NSArray *) arguments;
    
    if (args.count < 3) {
        NSLog([Tag stringByAppendingString:@": Wrong arguments count passed to getChildTransmissionTarget()"]);
        return;
    }
    
    NSString *childToken = [TiUtils stringValue:[args objectAtIndex:0]];
    NSString *targetToken = [TiUtils stringValue:[args objectAtIndex:1]];
    KrollCallback *callback = (KrollCallback *)[args objectAtIndex:2];
    
    if (callback == nil) {
        NSLog([Tag stringByAppendingString:@": No callback passed to getChildTransmissionTarget()"]);
        return;
    }
    
    MSAnalyticsTransmissionTarget *transmissionTarget = [mTransmissionTargets objectForKey:targetToken];
    if (transmissionTarget == nil) {
        [callback call:nil thisObject:Tag];
        return;
    }
    
    MSAnalyticsTransmissionTarget *childTarget = [transmissionTarget transmissionTargetForToken:childToken];
    if (childTarget == nil) {
        [callback call:nil thisObject:Tag];
        return;
    }
    
    [mTransmissionTargets setObject:childTarget forKey:childToken];
    
    [callback call:[NSArray arrayWithObject:childToken] thisObject:Tag];
}

- (void)setTransmissionTargetAppName:(id)arguments
{
    if (arguments == nil) {
        NSLog([Tag stringByAppendingString:@": Wrong arguments count passed to setTransmissionTargetAppName()"]);
        return;
    }
    
    NSArray *args = (NSArray *) arguments;
    
    if (args.count < 3) {
        NSLog([Tag stringByAppendingString:@": Wrong arguments count passed to setTransmissionTargetAppName()"]);
        return;
    }
    
    NSString *appName = [TiUtils stringValue:[args objectAtIndex:0]];
    NSString *targetToken = [TiUtils stringValue:[args objectAtIndex:1]];
    KrollCallback *callback = (KrollCallback *)[args objectAtIndex:2];
    
    MSAnalyticsTransmissionTarget *transmissionTarget = [mTransmissionTargets objectForKey:targetToken];
    if (transmissionTarget != nil) {
        MSPropertyConfigurator *configurator = [transmissionTarget propertyConfigurator];
        [configurator setAppName:appName];
    }

    [callback call:nil thisObject:Tag];
}

- (void)setTransmissionTargetAppVersion:(id)arguments
{
    if (arguments == nil) {
        NSLog([Tag stringByAppendingString:@": Wrong arguments count passed to setTransmissionTargetAppVersion()"]);
        return;
    }
    
    NSArray *args = (NSArray *) arguments;
    
    if (args.count < 3) {
        NSLog([Tag stringByAppendingString:@": Wrong arguments count passed to setTransmissionTargetAppVersion()"]);
        return;
    }
    
    NSString *appVersion = [TiUtils stringValue:[args objectAtIndex:0]];
    NSString *targetToken = [TiUtils stringValue:[args objectAtIndex:1]];
    KrollCallback *callback = (KrollCallback *)[args objectAtIndex:2];
    
    MSAnalyticsTransmissionTarget *transmissionTarget = [mTransmissionTargets objectForKey:targetToken];
    if (transmissionTarget != nil) {
        MSPropertyConfigurator *configurator = [transmissionTarget propertyConfigurator];
        [configurator setAppVersion:appVersion];
    }
    
    [callback call:nil thisObject:Tag];
}

- (void)setTransmissionTargetAppLocale:(id)arguments
{
    if (arguments == nil) {
        NSLog([Tag stringByAppendingString:@": Wrong arguments count passed to setTransmissionTargetAppLocale()"]);
        return;
    }
    
    NSArray *args = (NSArray *) arguments;
    
    if (args.count < 3) {
        NSLog([Tag stringByAppendingString:@": Wrong arguments count passed to setTransmissionTargetAppLocale()"]);
        return;
    }
    
    NSString *appLocale = [TiUtils stringValue:[args objectAtIndex:0]];
    NSString *targetToken = [TiUtils stringValue:[args objectAtIndex:1]];
    KrollCallback *callback = (KrollCallback *)[args objectAtIndex:2];
    
    MSAnalyticsTransmissionTarget *transmissionTarget = [mTransmissionTargets objectForKey:targetToken];
    if (transmissionTarget != nil) {
        MSPropertyConfigurator *configurator = [transmissionTarget propertyConfigurator];
        [configurator setAppLocale:appLocale];
    }
    
    [callback call:nil thisObject:Tag];
}


@end
