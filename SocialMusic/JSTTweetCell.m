//
//  JSTTweetCell.m
//  SocialMusic
//
//  Created by Javier Soto on 5/17/14.
//  Copyright (c) 2014 Javier Soto. All rights reserved.
//

#import "JSTTweetCell.h"

@interface JSTTweetCell ()

@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UILabel *tweetLabel;

@end

@implementation JSTTweetCell

- (void)awakeFromNib {
  [super awakeFromNib];

  self.tweetLabel.preferredMaxLayoutWidth = 290;
}

- (void)setTweet:(NSDictionary *)tweet {
  _tweet = [tweet copy];

  self.usernameLabel.text = [NSString stringWithFormat:@"@%@", tweet[@"user"][@"screen_name"]];
  self.tweetLabel.text = tweet[@"text"];
}

@end
