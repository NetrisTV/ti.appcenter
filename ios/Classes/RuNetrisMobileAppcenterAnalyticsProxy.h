//
//  TiAppCenterAnalyticsModule.h
//  TiAppCenter
//
//  Created by Emin Alekperov on 02/04/2019.
//

#import <Foundation/Foundation.h>
#import "TiProxy.h"
#import "KrollCallback.h"

@interface RuNetrisMobileAppcenterAnalyticsProxy : TiProxy {

}

- (NSString *)getApiName;

- (void)setEnabled:(id)arguments;
- (void)isEnabled:(id)arguments;
- (void)trackEvent:(id)arguments;
- (void)trackTransmissionTargetEvent:(id)arguments;
- (void)getTransmissionTarget:(id)arguments;
- (void)isTransmissionTargetEnabled:(id)arguments;
- (void)setTransmissionTargetEnabled:(id)arguments;
- (void)setTransmissionTargetEventProperty:(id)arguments;
- (void)removeTransmissionTargetEventProperty:(id)arguments;
- (void)collectTransmissionTargetDeviceId:(id)arguments;
- (void)getChildTransmissionTarget:(id)arguments;
- (void)setTransmissionTargetAppName:(id)arguments;
- (void)setTransmissionTargetAppVersion:(id)arguments;
- (void)setTransmissionTargetAppLocale:(id)arguments;

@end
