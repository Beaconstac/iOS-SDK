//
//  MusicCardView.h
//  BeaconstacDemo
//
//  Copyright (c) 2015 Mobstac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTPlayerView.h"

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

- (void)setMode:(NSString*)mode;
- (void)loadSoundCloudWithUrl:(NSString*)songUrl;
- (void)loadVimeoWithUrl:(NSString*)videoID;

@end
