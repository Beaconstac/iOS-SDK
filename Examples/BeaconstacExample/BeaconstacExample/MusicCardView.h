//
//  MusicCardView.h
//  BeaconstacDemo
//
//  Copyright (c) 2015 Mobstac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTPlayerView.h"
#import <Beaconstac/Beaconstac.h>

@protocol MusicCardDelegate <NSObject>

- (void)mediaCardButtonClickedAtIndex:(int)index;

@end

@interface MusicCardView : UIVisualEffectView

@property (nonatomic, weak) id <MusicCardDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet YTPlayerView *ytPlayerView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *okButton;
@property (strong, nonatomic) NSString *okAction;
@property (strong, nonatomic) MSMedia *media;

- (void)setMode:(NSString*)mode;
- (void)loadSoundCloudWithUrl:(NSString*)songUrl;
- (void)loadVimeoWithUrl:(NSURL*)vimeoUrl;
- (void)loadYoutubeWithUrl:(NSURL*)youtubeUrl;

@end
