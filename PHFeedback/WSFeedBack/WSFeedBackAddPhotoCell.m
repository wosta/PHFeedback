//
//  WSFeedBackAddPhotoCell.m
//  PHFeedback
//
//  Created by penghe on 15/4/30.
//  Copyright (c) 2015年 penghe. All rights reserved.
//

#import "WSFeedBackAddPhotoCell.h"

@implementation WSFeedBackAddPhotoCell
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setupPhotoImageView];
    
}
//设置圆角
- (void)setupPhotoImageView
{
    self.addImageIconView.layer.cornerRadius = 5.0;
    self.addImageIconView.layer.masksToBounds = YES;
}
@end
