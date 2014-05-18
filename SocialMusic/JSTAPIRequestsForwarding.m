//
//  JSTAPIRequestsForwarding.m
//  SocialMusic
//
//  Created by Javier Soto on 5/17/14.
//  Copyright (c) 2014 Javier Soto. All rights reserved.
//

#import <JSTAPIToolsURLProtocol/JSTAPIToolsURLProtocol.h>

// APItools username: apitools+test@javisoto.es
// APItools password: SocialMusic

@interface JSTAPIRequestsForwarding : NSObject <JSTAPIToolsURLMapping>

@end

@implementation JSTAPIRequestsForwarding

+ (void)load {
  [JSTAPIToolsURLProtocol registerURLProtocolWithURLMapping:[self sharedInstance]];
}

+ (instancetype)sharedInstance {
  static JSTAPIRequestsForwarding *requestForwarding = nil;

  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    requestForwarding = [[self alloc] init];
  });

  return requestForwarding;
}

#pragma mark - JSTAPIToolsURLMapping

- (NSString *)apiToolsHostForOriginalURLHost:(NSString *)originalURLHost {
  static NSDictionary *mappingDictionary = nil;

  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    mappingDictionary = @{
                          @"api.musicgraph.com" : @"musicgraph-083ba6881b1c.my.apitools.com",
                          @"api.twitter.com" : @"twitter-083ba6881b1c.my.apitools.com",
                          };
  });

  return mappingDictionary[originalURLHost];
}

@end
