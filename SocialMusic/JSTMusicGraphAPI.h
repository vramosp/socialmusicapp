//
//  JSTMusicGraphAPI.h
//  SocialMusic
//
//  Created by Javier Soto on 5/17/14.
//  Copyright (c) 2014 Javier Soto. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JSTMusicGraphArtist;
@class JSTMusicGraphAlbum;

@interface JSTMusicGraphAPI : NSObject

+ (instancetype)sharedInstance;

/**
 Query the Music Graph API and get a list of artists whose name match the provided `aristName`

 @param completionBlock `artists` type is `JSTMusicGraphArtist`
 */
- (void)searchArtistsWithName:(NSString *)artistName
              completionBlock:(void(^)(NSArray *artists, NSError *error))completionBlock;

/**
 Query the Music Graph API and get a list of albums from the artist `artist`.

 @param completionBlock `artists` type is `JSTMusicGraphAlbum`
 */
- (void)getAlbumsFromArtist:(JSTMusicGraphArtist *)artist
            completionBlock:(void(^)(NSArray *albums, NSError *error))completionBlock;

@end
