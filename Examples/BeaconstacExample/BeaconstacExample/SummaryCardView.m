//
//  SummaryCardView.m
//  BeaconstacExample
//
//  Created by Kshitij-Deo on 05/01/15.
//

#import "SummaryCardView.h"

@interface SummaryCardView()

@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation SummaryCardView

- (void)setNeedsLayout
{
    self.containerView.layer.masksToBounds = YES;
    self.containerView.layer.cornerRadius = 6.0;
    self.containerView.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:1.0].CGColor;
    self.containerView.layer.borderWidth = 0.5;
    self.imageView.layer.masksToBounds = YES;
}


- (IBAction)button1Clicked:(id)sender
{
    if (self.delegate) [self.delegate summaryButtonClickedAtIndex:0];
}

- (IBAction)button2Clicked:(id)sender
{
    if (self.okAction && [self.okAction length]) {
        if (self.delegate) [self.delegate summaryButtonClickedAtIndex:1];
    } else {
        if (self.delegate) [self.delegate summaryButtonClickedAtIndex:0];
    }
}

@end
