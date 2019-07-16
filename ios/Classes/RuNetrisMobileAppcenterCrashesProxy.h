//
//  TiAppCenterCrashes.h
//  TiAppCenter
//
//  Created by Emin Alekperov on 02/04/2019.
//

#import "TiProxy.h"
#import <Foundation/Foundation.h>

@interface RuNetrisMobileAppcenterCrashesProxy : TiProxy {
}

- (NSString *)getApiName;
- (id)lastSessionCrashReport:(id)arguments;
- (id)hasCrashedInLastSession:(id)arguments;
- (void)setEnabled:(id)arguments;
- (id)isEnabled:(id)arguments;
- (void)generateTestCrash:(id)arguments;
- (void)notifyWithUserConfirmation:(id)arguments;

@end
