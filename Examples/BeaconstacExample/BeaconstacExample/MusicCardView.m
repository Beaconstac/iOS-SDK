//
//  MusicCardView.m
//  BeaconstacDemo
//
//  Copyright (c) 2015 Mobstac. All rights reserved.
//

#import "MusicCardView.h"

@interface MusicCardView()<UIWebViewDelegate>
{
    BOOL widgetLoaded;
}
@property (weak, nonatomic) IBOutlet UIButton *playButton;

@end

@implementation MusicCardView

- (void)setNeedsLayout
{
    self.containerView.layer.masksToBounds = YES;
    self.containerView.layer.cornerRadius = 6.0;
    self.containerView.layer.borderColor = [UIColor colorWithWhite:0.0 alpha:1.0].CGColor;
    self.containerView.layer.borderWidth = 0.5;
    
    self.webView.scrollView.scrollEnabled = NO;
    self.webView.scrollView.bounces = NO;
    self.webView.hidden = YES;
    
    widgetLoaded = NO;
}

- (void)loadSoundCloudWithUrl:(NSString*)songUrl
{
    self.webView.hidden = NO;
    
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"soundcloud" ofType:@"html"];
    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"https%3A//api.soundcloud.com/" withString:songUrl];
    [self.webView loadHTMLString:htmlString baseURL:nil];
    self.webView.delegate = self;
}

- (void)loadVimeoWithUrl:(NSURL*)vimeoUrl;
{
    [self setNeedsLayout];
    NSString *videoID = [self extractVimeoID:[vimeoUrl absoluteString]];
    self.webView.hidden = NO;
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"vimeo" ofType:@"html"];
    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"videoID" withString:videoID];
    [self.webView loadHTMLString:htmlString baseURL:nil];
    self.webView.delegate = self;
}

- (void)loadYoutubeWithUrl:(NSURL*)youtubeUrl
{
    [self setNeedsLayout];
    NSString *videoId = [self extractYoutubeID:[youtubeUrl absoluteString]];
    [self.ytPlayerView setHidden:NO];
    
    NSDictionary *playerVars = @{
                                 @"controls" : @1,
                                 @"playsinline" : @0,
                                 @"autohide" : @1,
                                 @"showinfo" : @1,
                                 @"modestbranding" : @1,
                                 @"suggestedQuality" : @"large"
                                 };
    [self.ytPlayerView loadWithVideoId:videoId playerVars:playerVars];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ( navigationType == UIWebViewNavigationTypeOther && !widgetLoaded) {
        return YES;
    }
    return NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    widgetLoaded = YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"Webview didFailLoadWithError %@",error);
}

- (IBAction)button1Clicked:(id)sender
{
    if (self.delegate) [self.delegate mediaCardButtonClickedAtIndex:0];
    [self.ytPlayerView stopVideo];
}

- (IBAction)button2Clicked:(id)sender
{
    if (self.okAction && [self.okAction length]) {
        if (self.delegate) [self.delegate mediaCardButtonClickedAtIndex:2];
    } else {
        if (self.delegate) [self.delegate mediaCardButtonClickedAtIndex:0];
    }    
}

- (void)setMode:(NSString*)mode
{
    if ([mode isEqualToString:@"play"]) {
        [self.playButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    } else if ([mode isEqualToString:@"pause"]) {
        [self.playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    }
}

#pragma mark - Extract video id from URL

/*
 * This is a helper method to extract Youtube video id from a Youtube URL
 * youtube library uses the id to embed the video in an iframe
 */
- (NSString *)extractYoutubeID:(NSString *)youtubeURL
{
    NSError *error = NULL;
    NSString *regexString = @"(?<=v(=|/))([-a-zA-Z0-9_]+)|(?<=youtu.be/)([-a-zA-Z0-9_]+)";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexString options:NSRegularExpressionCaseInsensitive error:&error];
    NSRange rangeOfFirstMatch = [regex rangeOfFirstMatchInString:youtubeURL options:0 range:NSMakeRange(0, [youtubeURL length])];
    if(!NSEqualRanges(rangeOfFirstMatch, NSMakeRange(NSNotFound, 0)))
    {
        NSString *substringForFirstMatch = [youtubeURL substringWithRange:rangeOfFirstMatch];
        return substringForFirstMatch;
    }
    return nil;
}

/*
 * This is a helper method to extract Vimeo video id from a Vimeo URL
 * The id is used to embed the video in an iframe
 */
- (NSString *)extractVimeoID:(NSString *)vimeoURL
{
    NSRange range = [vimeoURL rangeOfString:@"vimeo.com/"];
    if (range.location !=NSNotFound) {
        NSString *str = [vimeoURL substringFromIndex:(range.location+range.length)];
        return str;
    }
    return nil;
}
@end
