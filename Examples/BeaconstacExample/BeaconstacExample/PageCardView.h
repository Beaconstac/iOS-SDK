//
//  PageCardView.h
//  BeaconstacDemo
//
//  Created by Kshitij-Deo on 09/04/15.
//  Copyright (c) 2015 Mobstac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PageCardDelegate <NSObject>

- (void)pageButtonClickedAtIndex:(int)index;

@end

@interface PageCardView : UIVisualEffectView

@property (nonatomic, assign) id <PageCardDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *summaryView;
@property (weak, nonatomic) IBOutlet UIButton *okButton;
@property (strong, nonatomic) NSString *okAction;

@end