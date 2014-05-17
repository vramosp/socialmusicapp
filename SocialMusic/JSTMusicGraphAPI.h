//
//  JSTMusicGraphAPI.h
//  SocialMusic
//
//  Created by Javier Soto on 5/17/14.
//  Copyright (c) 2014 Javier Soto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSTMusicGraphArtist : NSObject

@property (nonatomic, copy, readonly) NSString *name;

@end

@interface JSTMusicGraphAPI : NSObject

+ (instancetype)sharedInstance;

/**
 Query the Music Graph API and get a list of artists whose name match the provided `aristName`

 @param completionBlock `artists` type is `JSTMusicGraphArtist`
 */
- (void)searchArtistsWithName:(NSString *)artistName
              completionBlock:(void(^)(NSArray *artists, NSError *error))completionBlock;

@end
