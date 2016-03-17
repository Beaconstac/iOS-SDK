//
//  PhotoCardView.m
//  BeaconstacDemo
//
//  Created by Kshitij-Deo on 07/01/15.
//  Copyright (c) 2015 Mobstac. All rights reserved.
//

#import "PhotoCardView.h"
#import <Beaconstac/Beaconstac.h>

@interface PhotoCardView()<KIImagePagerDelegate,KIImagePagerDataSource>

@property (weak, nonatomic) IBOutlet UIView *containerView;

@end


@implementation PhotoCardView

- (IBAction)button1Clicked:(id)sender
{
    [self.delegate photoCardButtonClickedAtIndex:0];
}

- (IBAction)button2Clicked:(id)sender
{
    if (self.okAction && [self.okAction length]) {
        if (self.delegate) [self.delegate photoCardButtonClickedAtIndex:1];
    } else {
        if (self.delegate) [self.delegate photoCardButtonClickedAtIndex:0];
    }
}

- (void)setNeedsLayout
{
    self.containerView.layer.masksToBounds = YES;
    self.containerView.layer.cornerRadius = 6.0;
    self.containerView.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:1.0].CGColor;
    self.containerView.layer.borderWidth = 0.5;
    
    self.imagePager.slideshowTimeInterval = 3.0f;
    self.imagePager.slideshowShouldCallScrollToDelegate = YES;
    
    self.imagePager.delegate = self;
    self.imagePager.dataSource = self;
}


#pragma mark - KIImagePager delegates

- (NSArray *)arrayWithImages:(KIImagePager*)pager
{
    NSMutableArray *imagesArray = [NSMutableArray new];
    for (MSMedia *media in self.imageArray) {
        [imagesArray addObject:media.mediaUrl];
    }
    return imagesArray;
}

- (UIViewContentMode)contentModeForImage:(NSUInteger)image inPager:(KIImagePager*)pager
{
    return UIViewContentModeScaleToFill;
}

- (UIImage *)placeHolderImageForImagePager:(KIImagePager*)pager
{
    return [UIImage imageNamed:@"placeholder"];
}

- (NSString *) captionForImageAtIndex:(NSUInteger)index  inPager:(KIImagePager*)pager
{
    return nil;
}

- (UIViewContentMode)contentModeForPlaceHolder:(KIImagePager*)pager
{
    return UIViewContentModeScaleToFill;
}
@end
