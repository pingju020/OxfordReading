//
//  TextField.m
//  KKMY2_U
//
//  Created by 黄磊 on 14-5-3.
//  Copyright (c) 2014年 yangjuanping. All rights reserved.
//

#import "TextField.h"

@implementation TextField

@dynamic delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self settingView];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self settingView];
}

- (void)settingView
{
    if (self.tag == 1) {
        UIColor *color =[[UIColor whiteColor] colorWithAlphaComponent:0.55];
        [self setBackgroundColor:color];
        self.layer.cornerRadius = 3;
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 1;
        self.layer.borderColor = [[[UIColor blackColor] colorWithAlphaComponent:0.08] CGColor];
    }
    
    self.minLength = 1;             // 最小长度默认为1
    
    _paddingLeft = 10;
    _paddingRight = 10;
}


- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectMake(bounds.origin.x + _paddingLeft,
                      bounds.origin.y,
                      bounds.size.width - _paddingRight,
                      bounds.size.height);
}

- (CGRect)editingRectForBounds:(CGRect)bounds;
{
    return CGRectMake(bounds.origin.x + _paddingLeft,
                      bounds.origin.y,
                      bounds.size.width - _paddingRight,
                      bounds.size.height);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
