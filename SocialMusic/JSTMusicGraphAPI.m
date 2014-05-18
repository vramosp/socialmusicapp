//
//  JSTMusicGraphAPI.m
//  SocialMusic
//
//  Created by Javier Soto on 5/17/14.
//  Copyright (c) 2014 Javier Soto. All rights reserved.
//

#import "JSTMusicGraphAPI.h"

#import "JSTMusicGraphArtist.h"
#import "JSTMusicGraphAlbum.h"

// https://developer.musicgraph.com/api-docs/v2/artists
static NSString *const JSTMusicGraphAPIKey = @"61d7a072516a19df3fa1f00e9a61040a";

@implementation JSTMusicGraphAPI

+ (instancetype)sharedInstance {
  static JSTMusicGraphAPI *API = nil;

  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    API = [[self alloc] init];
  });

  return API;
}

- (NSString *)baseURLString {
  return @"http://api.musicgraph.com/api/v2";
}

- (void)getPath:(NSString *)path
 withParameters:(NSDictionary *)parametersDictionary
completionBlock:(void(^)(NSDictionary *response, NSError *error))completionBlock {
  NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:parametersDictionary];
  parameters[@"api_key"] = JSTMusicGraphAPIKey;

  NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@/%@", [self baseURLString], path];

  NSMutableArray *parametersArray = [NSMutableArray array];

  [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
    NSString *s = [NSString stringWithFormat:@"%@=%@", key, [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [parametersArray addObject:s];
  }];

  if (parametersArray.count > 0) {
    NSString *parameterString = [parametersArray componentsJoinedByString:@"&"];

    [urlString appendFormat:@"?%@", parameterString];
  }

  [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:urlString]
                               completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
    {
      completionBlock([NSJSONSerialization JSONObjectWithData:data options:0 error:nil], error);
    }] resume];
}

- (void)searchArtistsWithName:(NSString *)artistName
              completionBlock:(void(^)(NSArray *artists, NSError *error))completionBlock {
  NSParameterAssert(artistName);
  NSParameterAssert(completionBlock);

  [self getPath:@"artist/suggest"
 withParameters:@{@"prefix" : artistName}
completionBlock:^(NSDictionary *response, NSError *error)
   {
     if (error) {
       completionBlock(nil, error);
       return;
     }

     NSError *error2 = nil;
     NSArray *artists = [MTLJSONAdapter modelsOfClass:[JSTMusicGraphArtist class] fromJSONArray:response[@"data"] error:&error2];

     completionBlock(artists,  error2);
   }];
}

- (void)getAlbumsFromArtist:(JSTMusicGraphArtist *)artist
            completionBlock:(void(^)(NSArray *albums, NSError *error))completionBlock {
  NSParameterAssert(artist);
  NSParameterAssert(completionBlock);

  [self getPath:[NSString stringWithFormat:@"artist/%@/albums", artist.artistID]
 withParameters:nil
completionBlock:^(NSDictionary *response, NSError *error)
   {
     if (error) {
       completionBlock(nil, error);
       return;
     }

     NSError *error2 = nil;
     NSArray *albums = [MTLJSONAdapter modelsOfClass:[JSTMusicGraphAlbum class] fromJSONArray:response[@"data"] error:&error2];

     completionBlock(albums,  error2);
   }];
}

@end