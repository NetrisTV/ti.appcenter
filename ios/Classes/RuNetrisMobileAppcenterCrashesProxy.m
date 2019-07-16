//
//  TiAppCenterCrashesModule.m
//  TiAppCenter
//
//  Created by Emin Alekperov on 02/04/2019.
//

#import <Foundation/Foundation.h>
#import <KrollCallback.h>
#import <AppCenterCrashes/MSCrashes.h>
#import "TiUtils.h"
#import "RuNetrisMobileAppcenterCrashesProxy.h"

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
             @"incidentIdentifier": report.incidentIdentifier ?: @"",
             @"reporterKey": report.reporterKey ?: @"",
             @"signal": report.signal ?: @"",
             @"exceptionName": report.exceptionName ?: @"",
             @"exceptionReason": report.exceptionReason ?: @"",
             @"appStartTime": [NSNumber numberWithDouble:[report.appStartTime timeIntervalSince1970]] ?: 0,
             @"appErrorTime": [NSNumber numberWithDouble:[report.appErrorTime timeIntervalSince1970]] ?: 0,
             @"appProcessIdentifier": [NSNumber numberWithInteger:report.appProcessIdentifier] ?: 0
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
    
    NSArray *args = (NSArray *) arguments;
    
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
    
    NSArray *args = (NSArray *) arguments;
    
    if (args.count == 0) {
        NSLog([Tag stringByAppendingString:@": Wrong arguments count passed to notifyWithUserConfirmation()"]);
        return;
    }
    
    NSString *value = [TiUtils stringValue:args[0]];
    
    if ([value  isEqual: @"always"]) {
        [MSCrashes notifyWithUserConfirmation:MSUserConfirmationAlways];
    } else if ([value  isEqual: @"send"]) {
        [MSCrashes notifyWithUserConfirmation:MSUserConfirmationSend];
    } else if ([value  isEqual: @"dontsend"]) {
        [MSCrashes notifyWithUserConfirmation:MSUserConfirmationDontSend];
    } else {
        NSLog([Tag stringByAppendingString:@": A wrong value passed to notifyWithUserConfirmation()"]);
    }
}

@end
