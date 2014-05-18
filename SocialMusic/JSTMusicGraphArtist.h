//
//  JSTMusicGraphArtist.h
//  SocialMusic
//
//  Created by Javier Soto on 5/17/14.
//  Copyright (c) 2014 Javier Soto. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Mantle/Mantle.h>

@interface JSTMusicGraphArtist : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSString *artistID;
@property (nonatomic, copy, readonly) NSString *name;

@end
