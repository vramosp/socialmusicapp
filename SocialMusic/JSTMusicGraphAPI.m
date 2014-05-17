//
//  JSTMusicGraphAPI.m
//  SocialMusic
//
//  Created by Javier Soto on 5/17/14.
//  Copyright (c) 2014 Javier Soto. All rights reserved.
//

#import "JSTMusicGraphAPI.h"

static NSString *const JSTMusicGraphAPIKey = @"61d7a072516a19df3fa1f00e9a61040a";

@interface JSTMusicGraphArtist ()

+ (instancetype)artistWithName:(NSString *)artistName;

@end

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
  NSMutableDictionary *parameters = [parametersDictionary mutableCopy];
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

     NSMutableArray *artists = [NSMutableArray array];
     for (NSDictionary *responseItem in response[@"data"]) {
       NSString *name = responseItem[@"name"];
       [artists addObject:[JSTMusicGraphArtist artistWithName:name]];
     }

     completionBlock(artists,  nil);
   }];
}

@end


@implementation JSTMusicGraphArtist

+ (instancetype)artistWithName:(NSString *)artistName {
  JSTMusicGraphArtist *artist = [[self alloc] init];

  artist->_name = [artistName copy];

  return artist;
}

@end