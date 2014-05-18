//
//  JSTMusicGraphArtist.m
//  SocialMusic
//
//  Created by Javier Soto on 5/17/14.
//  Copyright (c) 2014 Javier Soto. All rights reserved.
//

#import "JSTMusicGraphArtist.h"

@implementation JSTMusicGraphArtist

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  return @{
           @keypath(JSTMusicGraphArtist.new, name): @"name",
           @keypath(JSTMusicGraphArtist.new, artistID): @"id",
          };
}

@end
