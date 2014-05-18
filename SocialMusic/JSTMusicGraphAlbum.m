//
//  JSTMusicGraphAlbum.m
//  SocialMusic
//
//  Created by Javier Soto on 5/17/14.
//  Copyright (c) 2014 Javier Soto. All rights reserved.
//

#import "JSTMusicGraphAlbum.h"

@implementation JSTMusicGraphAlbum

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  return @{
          @keypath(JSTMusicGraphAlbum.new, title): @"title",
          @keypath(JSTMusicGraphAlbum.new, releaseDate): @"release_date",
          };
}

@end
