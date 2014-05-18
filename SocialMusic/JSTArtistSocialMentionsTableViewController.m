//
//  JSTArtistSocialMentionsTableViewController.m
//  SocialMusic
//
//  Created by Javier Soto on 5/17/14.
//  Copyright (c) 2014 Javier Soto. All rights reserved.
//

#import "JSTArtistSocialMentionsTableViewController.h"

#import "JSTMusicGraphArtist.h"

#import "JSTTweetCell.h"

#import <MBProgressHUD/MBProgressHUD.h>
#import <STTwitter/STTwitter.h>

@import Social;
@import Accounts;
@import Twitter;

@interface JSTArtistSocialMentionsTableViewController ()

@property (nonatomic) BOOL requestInProgress;
@property (nonatomic, copy) NSArray *tweets;

@end

@implementation JSTArtistSocialMentionsTableViewController

@synthesize artist = _artist;

- (IBAction)dismiss:(id)sender {
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.title = [NSString stringWithFormat:@"Tweets about %@", self.artist.name];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  if (!self.tweets && !self.requestInProgress) {
    self.requestInProgress = YES;

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    STTwitterAPI *twitterAPI = [STTwitterAPI twitterAPIOSWithFirstAccount];
    [twitterAPI verifyCredentialsWithSuccessBlock:^(NSString *username) {
      [twitterAPI getSearchTweetsWithQuery:self.artist.name successBlock:^(NSDictionary *searchMetadata, NSArray *statuses)
       {
         [MBProgressHUD hideHUDForView:self.view animated:YES];

         self.requestInProgress = NO;
         self.tweets = statuses;
         [self.tableView reloadData];
       }
                                errorBlock:^(NSError *error)
       {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         self.requestInProgress = NO;
       }];
    } errorBlock:^(NSError *error) {
      NSLog(@"Error getting twitter account: %@", error);
    }];
  }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  JSTTweetCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JSTTweetCell class]) forIndexPath:indexPath];

  cell.tweet = self.tweets[indexPath.row];

  return cell;
}

@end
