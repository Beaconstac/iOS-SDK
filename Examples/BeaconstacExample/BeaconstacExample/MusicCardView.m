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

- (void)loadVimeoWithUrl:(NSString*)videoID
{
    self.webView.hidden = NO;
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"vimeo" ofType:@"html"];
    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"videoID" withString:videoID];
    [self.webView loadHTMLString:htmlString baseURL:nil];
    self.webView.delegate = self;
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
}

- (IBAction)button2Clicked:(id)sender
{
    if (self.delegate) [self.delegate mediaCardButtonClickedAtIndex:2];
}

- (void)setMode:(NSString*)mode
{
    if ([mode isEqualToString:@"play"]) {
        [self.playButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    } else if ([mode isEqualToString:@"pause"]) {
        [self.playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    }
}

@end
