//
//  TextView.m
//  KKMY2_U
//
//  Created by 黄磊 on 14-7-23.
//  Copyright (c) 2014年 yangjuanping. All rights reserved.
//

#import "TextView.h"
#import "NSString+Utils.h"
@interface TextView ()

@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, strong) UIImageView *imgviewBg;

@end

@implementation TextView

@dynamic delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self configView];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self configView];
}

- (void)setContentOffset:(CGPoint)contentOffset
{
    [super setContentOffset:contentOffset];
    
    if (self.tag == 1) {
        [_imgviewBg setFrame:CGRectOffset(_imgviewBg.bounds, contentOffset.x, contentOffset.y)];
    }
}

- (void)configView
{
    // 设置统一背景
    if (self.tag == 1) {
        UIImage *img = [UIImage imageNamed:@"bg_input_white"];
        UIImage *imgResize = [img resizableImageWithCapInsets:UIEdgeInsetsMake(19, 19, 19, 19)];
        _imgviewBg = [[UIImageView alloc] initWithFrame:self.bounds];
        [_imgviewBg setImage:imgResize];
        [self addSubview:_imgviewBg];
        [self sendSubviewToBack:_imgviewBg];
        [_imgviewBg setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    
    
    _placeholderLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _placeholderLabel.font = self.font;
    _placeholderLabel.textColor = [UIColor lightGrayColor];
    _placeholderLabel.backgroundColor = [UIColor clearColor];
    _placeholderLabel.hidden = YES;
    _placeholderLabel.numberOfLines = 0;
    [self addSubview:_placeholderLabel];
    
    self.minLength = 1;             // 最小长度默认为1
    
//    self.layer.borderWidth = 1;
//    self.layer.borderColor = [UIColor colorFromHexRGB:@"cccccc"].CGColor;
//    self.layer.shadowOffset = CGSizeZero;
//    self.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.2].CGColor;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)setContentInset:(UIEdgeInsets)contentInset
{
    [super setContentInset:contentInset];
    [self resizePlaceholderLabel];
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    [_placeholderLabel setFont:font];
}

- (void)textChanged:(NSNotification *)notification
{
    if (self.text.length > 0) {
        [_placeholderLabel setHidden:YES];
        return;
    }
    if (_placeholder.length > 0) {
        [_placeholderLabel setHidden:NO];
    } else {
        [_placeholderLabel setHidden:YES];
    }
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    if (_placeholder.length > 0) {
        [self resizePlaceholderLabel];
    }
    _placeholderLabel.text = _placeholder;
    if (self.text.length == 0 || _placeholder.length > 0) {
        [_placeholderLabel setHidden:NO];
    } else {
        [_placeholderLabel setHidden:YES];
    }
}

- (void)resizePlaceholderLabel
{
    if (_placeholder.length == 0) {
        return;
    }
    UIEdgeInsets edge =  self.contentInset;
    CGRect rect = UIEdgeInsetsInsetRect(self.bounds, edge);
    if (__CUR_IOS_VERSION >= __IPHONE_7_0) {
        UIEdgeInsets edge1 = self.textContainerInset;
        rect = UIEdgeInsetsInsetRect(rect, edge1);
    } else if (__CUR_IOS_VERSION >= __IPHONE_6_0) {
        UIEdgeInsets edge1 = UIEdgeInsetsMake(8, 3, 8, 3);
        rect = UIEdgeInsetsInsetRect(rect, edge1);
    }
    UIEdgeInsets edge2 = UIEdgeInsetsMake(0, 5, 0, 5);
    rect = UIEdgeInsetsInsetRect(rect, edge2);
//    CGSize size = multilineTextSize(_placeholder, self.font, rect.size);
//    rect.size = size;
    [_placeholderLabel setFrame:rect];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
}


@end
