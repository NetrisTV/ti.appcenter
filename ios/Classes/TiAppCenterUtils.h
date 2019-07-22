//
//  TiAppCenterUtils.h
//  TiAppCenter
//
//  Created by Emin Alekperov on 22/07/2019.
//

#import "TiUtils.h"
#import <Foundation/Foundation.h>

@interface TiAppCenterUtils : NSObject {
}

+ (KrollCallback *)getCallback:(NSArray *)args atIndex:(int)index;
+ (KrollCallback *)getCallback:(NSArray *)args atIndex:(int)index for:(NSString *)tag;

@end
