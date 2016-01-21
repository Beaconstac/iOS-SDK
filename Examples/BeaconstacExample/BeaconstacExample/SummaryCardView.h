//
//  SummaryCardView.h
//  BeaconstacExample
//
//  Copyright (c) 2015 Mobstac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SummaryCardDelegate <NSObject>

- (void)summaryButtonClickedAtIndex:(int)index;

@end


@interface SummaryCardView : UIVisualEffectView

@property (nonatomic, assign) id <SummaryCardDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *summaryView;
@property (weak, nonatomic) IBOutlet UIButton *okButton;
@property (strong, nonatomic) NSString *okAction;

@end
