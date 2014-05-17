//
//  JSTArtistInfoViewController.h
//  SocialMusic
//
//  Created by Javier Soto on 5/17/14.
//  Copyright (c) 2014 Javier Soto. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JSTMusicGraphArtist;

@protocol JSTArtistInfoViewController <NSObject>

@property (nonatomic, copy) JSTMusicGraphArtist *artist;

@end
