//
//  PageCardView.m
//  BeaconstacDemo
//
//  Created by Kshitij-Deo on 09/04/15.
//  Copyright (c) 2015 Mobstac. All rights reserved.
//

#import "PageCardView.h"

@implementation PageCardView

- (void)setNeedsLayout
{
    self.imageView.layer.masksToBounds = YES;
}

- (IBAction)button1Clicked:(id)sender
{
    if (self.delegate) [self.delegate pageButtonClickedAtIndex:0];
}

- (IBAction)button2Clicked:(id)sender
{
    if (self.okAction && [self.okAction length]) {
        if (self.delegate) [self.delegate pageButtonClickedAtIndex:1];
    } else {
        if (self.delegate) [self.delegate pageButtonClickedAtIndex:0];
    }
}

@end