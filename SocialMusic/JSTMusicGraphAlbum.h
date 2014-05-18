//
//  JSTMusicGraphAlbum.h
//  SocialMusic
//
//  Created by Javier Soto on 5/17/14.
//  Copyright (c) 2014 Javier Soto. All rights reserved.
//

#import "MTLModel.h"

#import <Mantle/Mantle.h>

@interface JSTMusicGraphAlbum : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *releaseDate;

@end
