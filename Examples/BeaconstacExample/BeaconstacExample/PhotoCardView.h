//
//  PhotoCardView.h
//  BeaconstacDemo
//
//  Created by Kshitij-Deo on 07/01/15.
//  Copyright (c) 2015 Mobstac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KIImagePager.h"

@protocol PhotoCardDelegate <NSObject>

- (void)photoCardButtonClickedAtIndex:(int)index;

@end

@interface PhotoCardView : UIVisualEffectView

@property (nonatomic, assign) id <PhotoCardDelegate> delegate;
@property (strong, nonatomic) NSArray *imageArray;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet KIImagePager *imagePager;
@property (weak, nonatomic) IBOutlet UIButton *okButton;
@property (strong, nonatomic) NSString *okAction;

@end
