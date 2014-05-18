//
//  JSTArtistAlbumListTableViewController.m
//  SocialMusic
//
//  Created by Javier Soto on 5/17/14.
//  Copyright (c) 2014 Javier Soto. All rights reserved.
//

#import "JSTArtistAlbumListTableViewController.h"

#import "JSTMusicGraphAPI.h"
#import "JSTMusicGraphArtist.h"
#import "JSTMusicGraphAlbum.h"

#import <MBProgressHUD/MBProgressHUD.h>

@interface JSTArtistAlbumListTableViewController ()

@property (nonatomic) BOOL requestInProgress;
@property (nonatomic, copy) NSArray *albums;

@end

@implementation JSTArtistAlbumListTableViewController

@synthesize artist = _artist;

- (void)viewDidLoad {
  [super viewDidLoad];

  self.title = [NSString stringWithFormat:@"%@'s albums", self.artist.name];
}

- (IBAction)dismissModal:(id)sender {
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidAppear:(BOOL)animated {
  if (!self.albums && !self.requestInProgress) {
    self.requestInProgress = YES;

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    @weakify(self);
[[JSTMusicGraphAPI sharedInstance] getAlbumsFromArtist:self.artist
  completionBlock:^(NSArray *albums, NSError *error)
    {
      @strongify(self);
      self.requestInProgress = NO;

      [MBProgressHUD hideHUDForView:self.view animated:YES];

      self.albums = albums;
      [self.tableView reloadData];
  }];
  }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.albums.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];

  cell.textLabel.text = [self.albums[indexPath.row] title];
  cell.detailTextLabel.text = [self.albums[indexPath.row] releaseDate];

  return cell;
}

@end
