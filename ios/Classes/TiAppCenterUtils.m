//
//  TiAppCenterUtils.m
//  TiAppCenter
//
//  Created by Emin Alekperov on 22/07/2019.
//

#import "TiAppCenterUtils.h"
#import "TiUtils.h"
#import <Foundation/Foundation.h>

static NSString *const Tag = @"TiAppCenterUtils";

@implementation TiAppCenterUtils

+ (KrollCallback *)getCallback:(NSArray *)args atIndex:(int)index {
  return [TiAppCenterUtils getCallback:args atIndex:index for:@""];
}

+ (KrollCallback *)getCallback:(NSArray *)args atIndex:(int)index for:(NSString *)tag
{
  if (args.count <= index) {
    NSLog([[Tag stringByAppendingString:@": Wrong arguments count passed: "] stringByAppendingString:tag]);
    return nil;
  }

  KrollCallback *callback = nil;

  NSObject *item = [args objectAtIndex:index];
  if ([item isKindOfClass:[KrollCallback class]]) {
    callback = (KrollCallback *)item;
  } else {
    NSLog([[Tag stringByAppendingString:@": No callback: "] stringByAppendingString:tag]);
    return nil;
  }

  return callback;
}

@end
