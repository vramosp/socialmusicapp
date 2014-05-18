//
//  JSTArtistSearchViewController.m
//  SocialMusic
//
//  Created by Javier Soto on 5/17/14.
//  Copyright (c) 2014 Javier Soto. All rights reserved.
//

#import "JSTArtistSearchViewController.h"

#import <MLPAutoCompleteTextField/MLPAutoCompleteTextField.h>

#import "JSTArtistInfoViewController.h"
#import "JSTMusicGraphAPI.h"
#import "JSTMusicGraphArtist.h"

static NSString *const PBArtistInfoModalSegueIdentifier = @"ArtistInfoModalSegue";

@interface JSTMusicGraphArtist (MLPAutoCompletionObject) <MLPAutoCompletionObject>

@end

@implementation JSTMusicGraphArtist (MLPAutoCompletionObject)

- (NSString *)autocompleteString {
  return self.name;
}

@end

@interface JSTArtistSearchViewController () <MLPAutoCompleteTextFieldDataSource, MLPAutoCompleteTextFieldDelegate>

@property (strong, nonatomic) IBOutlet MLPAutoCompleteTextField *textField;

@property (nonatomic, strong) JSTMusicGraphArtist *selectedArtist;

@end

@implementation JSTArtistSearchViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.textField.autoCompleteDataSource = self;
  self.textField.autoCompleteDelegate = self;

  self.textField.autoCompleteTableAppearsAsKeyboardAccessory = NO;
  [self.textField registerAutoCompleteCellClass:[UITableViewCell class]
                                     forCellReuseIdentifier:@"TableViewCell"];
  self.textField.applyBoldEffectToAutoCompleteSuggestions = YES;
  self.textField.showTextFieldDropShadowWhenAutoCompleteTableIsOpen = YES;
  self.textField.reverseAutoCompleteSuggestionsBoldEffect = YES;
  self.textField.autoCompleteTableBackgroundColor = [UIColor whiteColor];
  self.textField.autoCompleteFetchRequestDelay = 0.5;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  // This is horrible and I hate storyboards.
  for (UINavigationController *viewController in [segue.destinationViewController viewControllers]) {
    ((UIViewController <JSTArtistInfoViewController> *)viewController.topViewController).artist = self.selectedArtist;
  }
}

#pragma mark - MLPAutoCompleteTextFieldDataSource

- (void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField possibleCompletionsForString:(NSString *)string completionHandler:(void (^)(NSArray *))handler {
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  [[JSTMusicGraphAPI sharedInstance] searchArtistsWithName:string
                                           completionBlock:^(NSArray *artists, NSError *error)
  {
    if (!error) {
      handler(artists);
    }
    else {
      NSLog(@"Error querying artists with name %@: %@", string, error);
    }

    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
  }];
}

#pragma mark - MLPAutoCompleteTextFieldDelegate

- (void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
  didSelectAutoCompleteString:(NSString *)selectedString
       withAutoCompleteObject:(JSTMusicGraphArtist *)selectedObject
            forRowAtIndexPath:(NSIndexPath *)indexPath {
  self.selectedArtist = selectedObject;

  [self performSegueWithIdentifier:PBArtistInfoModalSegueIdentifier sender:self];
}

@end
