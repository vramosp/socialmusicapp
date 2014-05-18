//
//  JSTArtistSocialMentionsTableViewController.m
//  SocialMusic
//
//  Created by Javier Soto on 5/17/14.
//  Copyright (c) 2014 Javier Soto. All rights reserved.
//

#import "JSTArtistSocialMentionsTableViewController.h"

#import "JSTMusicGraphArtist.h"

#import <MBProgressHUD/MBProgressHUD.h>
#import <STTwitter/STTwitter.h>

@import Social;
@import Accounts;

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

    ACAccount *twitterAccount = [[ACAccountStore.new accountsWithAccountType:[ACAccountStore.new accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter]] firstObject];
    STTwitterAPI *twitterAPI = [STTwitterAPI twitterAPIOSWithAccount:twitterAccount];
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
  }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];

//  cell.textLabel.text =

  return cell;
}

@end
